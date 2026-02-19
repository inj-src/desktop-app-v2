import fs from 'node:fs';
import path from 'node:path';
import { spawn, type ChildProcessByStdio } from 'node:child_process';
import type { Readable } from 'node:stream';

import type { ManagedProcessState, ProcessName } from '../types';
import { PROCESS_NAMES } from './constants';
import {
  buildPrismaRuntimeEnv,
  ensureBackendRuntimeDirectories,
  resolveBackendDir,
  resolveFrontendStaticDir,
  type RuntimePathContext,
} from './runtime-paths';

type ManagedChildProcess = ChildProcessByStdio<null, Readable, Readable>;

interface ProcessServiceOptions {
  backendPort: number;
  frontendPort: number;
  hostname: string;
  runtimePathContext: RuntimePathContext;
  resolveDatabaseUrl: () => string | null;
  onLog: (target: string, stream: string, message: string) => void;
  onStateChange: () => void;
}

export class ProcessService {
  private readonly backendPort: number;
  private readonly frontendPort: number;
  private readonly hostname: string;
  private readonly runtimePathContext: RuntimePathContext;
  private readonly resolveDatabaseUrl: () => string | null;
  private readonly onLog: (target: string, stream: string, message: string) => void;
  private readonly onStateChange: () => void;

  private shuttingDown = false;

  private readonly children: Record<ProcessName, ManagedChildProcess | null> = {
    backend: null,
    frontend: null,
  };

  private readonly expectedExit: Record<ProcessName, boolean> = {
    backend: false,
    frontend: false,
  };

  private readonly processState: Record<ProcessName, ManagedProcessState>;

  constructor(options: ProcessServiceOptions) {
    this.backendPort = options.backendPort;
    this.frontendPort = options.frontendPort;
    this.hostname = options.hostname;
    this.runtimePathContext = options.runtimePathContext;
    this.resolveDatabaseUrl = options.resolveDatabaseUrl;
    this.onLog = options.onLog;
    this.onStateChange = options.onStateChange;

    this.processState = {
      backend: {
        name: 'backend',
        port: this.backendPort,
        status: 'stopped',
        running: false,
        pid: null,
        restarts: 0,
        lastExitCode: null,
        lastSignal: null,
        networkUrl: `http://${this.hostname}:${this.backendPort}`,
        localUrl: `http://127.0.0.1:${this.backendPort}`,
      },
      frontend: {
        name: 'frontend',
        port: this.frontendPort,
        status: 'stopped',
        running: false,
        pid: null,
        restarts: 0,
        lastExitCode: null,
        lastSignal: null,
        networkUrl: `http://${this.hostname}:${this.frontendPort}`,
        localUrl: `http://127.0.0.1:${this.frontendPort}`,
      },
    };
  }

  setShuttingDown(value: boolean): void {
    this.shuttingDown = value;
  }

  getSnapshot(): Record<ProcessName, ManagedProcessState> {
    return {
      backend: { ...this.processState.backend },
      frontend: { ...this.processState.frontend },
    };
  }

  async startAll(): Promise<void> {
    await this.startProcess('backend');
    await this.startProcess('frontend');
  }

  async stopAll(): Promise<void> {
    await this.stopProcess('frontend');
    await this.stopProcess('backend');
  }

  async restartAll(): Promise<void> {
    await this.restartProcess('backend');
    await this.restartProcess('frontend');
  }

  async startProcess(name: ProcessName): Promise<void> {
    if (this.children[name]) {
      return;
    }

    this.setProcessState(name, { status: 'starting' });

    try {
      const child = name === 'backend' ? this.spawnBackend() : this.spawnFrontend();
      this.children[name] = child;

      this.setProcessState(name, {
        status: 'running',
        running: true,
        pid: child.pid,
        lastExitCode: null,
        lastSignal: null,
      });

      this.wireChildLogs(name, child);
      this.onLog(name, 'system', `Started with pid ${child.pid}`);
    } catch (error) {
      this.children[name] = null;
      this.expectedExit[name] = false;

      this.setProcessState(name, {
        status: 'error',
        running: false,
        pid: null,
      });

      this.onLog(name, 'error', error instanceof Error ? error.message : String(error));
    }
  }

  async stopProcess(name: ProcessName): Promise<void> {
    const child = this.children[name];
    if (!child) {
      return;
    }

    this.expectedExit[name] = true;
    this.setProcessState(name, { status: 'stopping' });

    await this.waitForExitOrTimeout(
      child,
      () => {
        this.sendSignalToProcessTree(child, 'SIGTERM');
      },
      5000
    );

    if (child.exitCode === null) {
      await this.waitForExitOrTimeout(
        child,
        () => {
          this.sendSignalToProcessTree(child, 'SIGKILL');
        },
        2000
      );
    }
  }

  async restartProcess(name: ProcessName): Promise<void> {
    this.processState[name].restarts += 1;
    this.onStateChange();

    await this.stopProcess(name);
    await this.startProcess(name);
  }

  forceStopChildren(): void {
    for (const name of [...PROCESS_NAMES].reverse()) {
      const child = this.children[name];
      if (!child) {
        continue;
      }

      this.expectedExit[name] = true;
      this.sendSignalToProcessTree(child, 'SIGTERM');

      if (child.exitCode === null) {
        this.sendSignalToProcessTree(child, 'SIGKILL');
      }
    }
  }

  private setProcessState(name: ProcessName, updates: Partial<ManagedProcessState>): void {
    Object.assign(this.processState[name], updates);
    this.onStateChange();
  }

  private wireChildLogs(name: ProcessName, child: ManagedChildProcess): void {
    child.stdout.on('data', chunk => {
      this.onLog(name, 'stdout', chunk.toString());
    });

    child.stderr.on('data', chunk => {
      this.onLog(name, 'stderr', chunk.toString());
    });

    child.on('error', error => {
      this.onLog(name, 'error', error.message);
      this.setProcessState(name, {
        status: 'error',
        running: false,
        pid: null,
      });
    });

    child.on('exit', (code, signal) => {
      const expected = this.expectedExit[name];
      this.expectedExit[name] = false;
      this.children[name] = null;

      const nextStatus = expected || this.shuttingDown ? 'stopped' : code === 0 ? 'stopped' : 'error';

      this.setProcessState(name, {
        status: nextStatus,
        running: false,
        pid: null,
        lastExitCode: code,
        lastSignal: signal,
      });

      this.onLog(name, 'system', `Exited (code=${code}, signal=${signal})`);
    });
  }

  private spawnBackend(): ManagedChildProcess {
    const backendDir = resolveBackendDir(this.runtimePathContext);
    const backendEntry = path.join(backendDir, 'src', 'index.js');

    if (!fs.existsSync(backendEntry)) {
      throw new Error(`Backend entry file was not found: ${backendEntry}`);
    }

    ensureBackendRuntimeDirectories(backendDir);

    const databaseUrl = this.resolveDatabaseUrl() || process.env.DATABASE_URL || null;
    if (!databaseUrl) {
      throw new Error('No database URL available. Start database service first.');
    }

    const env = {
      ...process.env,
      ELECTRON_RUN_AS_NODE: '1',
      NODE_ENV: 'production',
      PORT: String(this.backendPort),
      CLIENT_URL: `http://${this.hostname}:${this.frontendPort}`,
      COOKIE_SECURE: process.env.COOKIE_SECURE ?? 'false',
      COOKIE_SAME_SITE: process.env.COOKIE_SAME_SITE ?? 'lax',
      DATABASE_URL: databaseUrl,
      ...buildPrismaRuntimeEnv(backendDir),
    };

    return spawn(process.execPath, [backendEntry], {
      cwd: backendDir,
      env,
      detached: false,
      stdio: ['ignore', 'pipe', 'pipe'],
    });
  }

  private spawnFrontend(): ManagedChildProcess {
    const frontendStaticDir = resolveFrontendStaticDir(this.runtimePathContext);
    const serveEntry = require.resolve('serve/build/main.js');

    return spawn(
      process.execPath,
      [serveEntry, '-s', frontendStaticDir, '-l', `tcp://0.0.0.0:${this.frontendPort}`, '--no-port-switching'],
      {
        cwd: frontendStaticDir,
        env: {
          ...process.env,
          ELECTRON_RUN_AS_NODE: '1',
          NODE_ENV: 'production',
        },
        detached: false,
        stdio: ['ignore', 'pipe', 'pipe'],
      }
    );
  }

  private async waitForExitOrTimeout(
    child: ManagedChildProcess,
    kick: () => void,
    timeoutMs: number
  ): Promise<void> {
    if (child.exitCode !== null) {
      return;
    }

    await new Promise<void>(resolve => {
      let resolved = false;

      const finish = () => {
        if (resolved) {
          return;
        }

        resolved = true;
        clearTimeout(timer);
        child.removeListener('exit', onExit);
        resolve();
      };

      const onExit = () => {
        finish();
      };

      const timer = setTimeout(finish, timeoutMs);

      child.once('exit', onExit);
      kick();
    });
  }

  private sendSignalToProcessTree(child: ManagedChildProcess, signal: NodeJS.Signals): void {
    if (child.exitCode !== null || !child.pid) {
      return;
    }

    const pid = child.pid;

    if (process.platform === 'win32') {
      const args = ['/pid', String(pid), '/t'];

      if (signal === 'SIGKILL') {
        args.push('/f');
      }

      const killer = spawn('taskkill', args, { stdio: 'ignore' });
      killer.on('error', error => {
        this.onLog('system', 'error', `Failed to run taskkill for pid ${pid}: ${error.message}`);
      });

      return;
    }

    try {
      process.kill(-pid, signal);
      return;
    } catch {
      // Fall back to direct child signal if process group signaling is unavailable.
    }

    try {
      child.kill(signal);
    } catch {
      // Ignore if process already exited.
    }
  }
}
