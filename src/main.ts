import path from 'node:path';

import { app, BrowserWindow, ipcMain, shell } from 'electron';

import type { DesktopState, ProcessLogPayload } from './types';
import {
  BACKEND_PORT,
  DB_MODE,
  FRONTEND_PORT,
  HOSTNAME,
  MDNS_CHECK_INTERVAL_MS,
  MDNS_TTL,
  PGLITE_HOST,
  PGLITE_PORT,
  isProcessName,
} from './main/constants';
import { MdnsService } from './main/mdns-service';
import { PgliteService } from './main/pglite-service';
import { ProcessService } from './main/process-service';
import { resolveAppIconPath, resolveBackendDir, type RuntimePathContext } from './main/runtime-paths';
import { UpdaterService } from './main/updater-service';

let mainWindow: BrowserWindow | null = null;
let appIsShuttingDown = false;
let signalShutdownStarted = false;

const runtimePathContext: RuntimePathContext = {
  appRootDir: app.isPackaged ? process.resourcesPath : path.resolve(__dirname, '..'),
  isPackaged: app.isPackaged,
};

const backendDir = resolveBackendDir(runtimePathContext);

const databaseService = new PgliteService({
  mode: DB_MODE,
  host: PGLITE_HOST,
  port: PGLITE_PORT,
  dataDir: path.join(app.getPath('userData'), 'pglite', 'main'),
  backendDir,
  externalDatabaseUrl: process.env.DATABASE_URL_EXTERNAL,
  onLog: emitLog,
  onStateChange: emitState,
});

const processService = new ProcessService({
  backendPort: BACKEND_PORT,
  frontendPort: FRONTEND_PORT,
  hostname: HOSTNAME,
  databaseMode: DB_MODE,
  runtimePathContext,
  resolveDatabaseUrl: () => databaseService.getDatabaseUrl(),
  onLog: emitLog,
  onStateChange: emitState,
});

const mdnsService = new MdnsService({
  hostname: HOSTNAME,
  ttl: MDNS_TTL,
  checkIntervalMs: MDNS_CHECK_INTERVAL_MS,
  onLog: emitLog,
  onStateChange: emitState,
});

const updaterService = new UpdaterService({
  getMainWindow: () => mainWindow,
  onLog: emitLog,
  onPrepareInstall: async () => {
    await shutdown();
  },
});

function emitLog(target: string, stream: string, message: string): void {
  const payload: ProcessLogPayload = {
    target,
    stream,
    message,
    at: new Date().toISOString(),
  };

  if (mainWindow && !mainWindow.isDestroyed()) {
    mainWindow.webContents.send('desktop:log', payload);
  }

  const prefix = `[${target}:${stream}]`;
  const lines = String(message)
    .replace(/\r/g, '')
    .split('\n')
    .filter(Boolean);

  for (const line of lines) {
    console.log(`${prefix} ${line}`);
  }
}

function snapshotState(): DesktopState {
  return {
    hostname: HOSTNAME,
    mdns: mdnsService.getSnapshot(),
    database: databaseService.getSnapshot(),
    processes: processService.getSnapshot(),
  };
}

function emitState(): void {
  if (mainWindow && !mainWindow.isDestroyed()) {
    mainWindow.webContents.send('desktop:state', snapshotState());
  }
}

function createWindow(): void {
  mainWindow = new BrowserWindow({
    width: 1500,
    height: 920,
    minWidth: 1100,
    minHeight: 700,
    icon: resolveAppIconPath(runtimePathContext),
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
    },
  });

  mainWindow.loadFile(path.join(__dirname, 'renderer', 'index.html'));

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

function registerIpcHandlers(): void {
  ipcMain.handle('desktop:status:get', () => snapshotState());

  ipcMain.handle('desktop:process:start', async (_event, name: unknown) => {
    if (name === 'all') {
      await processService.startAll();
      return snapshotState();
    }

    if (!isProcessName(name)) {
      throw new Error(`Unknown process name: ${String(name)}`);
    }

    await processService.startProcess(name);
    return snapshotState();
  });

  ipcMain.handle('desktop:process:stop', async (_event, name: unknown) => {
    if (name === 'all') {
      await processService.stopAll();
      return snapshotState();
    }

    if (!isProcessName(name)) {
      throw new Error(`Unknown process name: ${String(name)}`);
    }

    await processService.stopProcess(name);
    return snapshotState();
  });

  ipcMain.handle('desktop:process:restart', async (_event, name: unknown) => {
    if (name === 'all') {
      await processService.restartAll();
      return snapshotState();
    }

    if (!isProcessName(name)) {
      throw new Error(`Unknown process name: ${String(name)}`);
    }

    await processService.restartProcess(name);
    return snapshotState();
  });

  ipcMain.handle('desktop:open-external', async (_event, url: unknown) => {
    if (typeof url !== 'string' || !/^https?:\/\//.test(url)) {
      throw new Error('Only http(s) URLs are allowed');
    }

    await shell.openExternal(url);
  });
}

async function shutdown(): Promise<void> {
  appIsShuttingDown = true;
  processService.setShuttingDown(true);
  mdnsService.stopMonitor();
  await processService.stopAll();
  processService.forceStopChildren();
  await databaseService.stop();
}

function handleTerminationSignal(signal: NodeJS.Signals): void {
  if (signalShutdownStarted) {
    return;
  }

  signalShutdownStarted = true;
  emitLog('system', 'system', `Received ${signal}, shutting down...`);

  void shutdown()
    .catch(error => {
      emitLog('system', 'error', `Signal shutdown error: ${error instanceof Error ? error.message : String(error)}`);
    })
    .finally(() => {
      processService.forceStopChildren();
      app.exit(0);
    });
}

for (const signal of ['SIGINT', 'SIGTERM', 'SIGHUP'] as const) {
  process.on(signal, () => {
    handleTerminationSignal(signal);
  });
}

process.on('exit', () => {
  mdnsService.stopMonitor();
  processService.forceStopChildren();
  void databaseService.stop();
});

app.on('before-quit', event => {
  if (appIsShuttingDown) {
    return;
  }

  event.preventDefault();

  void shutdown()
    .catch(error => {
      emitLog('system', 'error', `Shutdown error: ${error instanceof Error ? error.message : String(error)}`);
    })
    .finally(() => {
      app.quit();
    });
});

app.on('will-quit', () => {
  mdnsService.stopMonitor();
  processService.forceStopChildren();
  void databaseService.stop();
});

app.whenReady().then(async () => {
  registerIpcHandlers();
  createWindow();
  mdnsService.startMonitor();

  try {
    await databaseService.start();
  } catch (error) {
    emitLog(
      'database',
      'error',
      `Database startup failed: ${error instanceof Error ? error.message : String(error)}`
    );
  }

  emitState();
  await processService.startAll();
  updaterService.start();
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
    emitState();
  }
});
