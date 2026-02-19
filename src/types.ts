export type ProcessName = 'backend' | 'frontend';
export type ProcessStatus = 'stopped' | 'starting' | 'running' | 'stopping' | 'error';
export type DatabaseMode = 'pglite' | 'external-postgres';
export type DatabaseStatus = 'stopped' | 'starting' | 'running' | 'error';

export interface ManagedProcessState {
  name: ProcessName;
  port: number;
  status: ProcessStatus;
  running: boolean;
  pid: number | null;
  restarts: number;
  lastExitCode: number | null;
  lastSignal: NodeJS.Signals | null;
  networkUrl: string;
  localUrl: string;
}

export interface MdnsState {
  hostname: string;
  running: boolean;
  ip: string | null;
}

export interface DatabaseState {
  mode: DatabaseMode;
  status: DatabaseStatus;
  running: boolean;
  host: string | null;
  port: number | null;
  dataDir: string | null;
  connectionString: string | null;
  lastError: string | null;
}

export interface DesktopState {
  hostname: string;
  mdns: MdnsState;
  database: DatabaseState;
  processes: Record<ProcessName, ManagedProcessState>;
}

export interface ProcessLogPayload {
  target: string;
  stream: string;
  message: string;
  at: string;
}

export interface DesktopApi {
  getStatus: () => Promise<DesktopState>;
  startProcess: (name: ProcessName | 'all') => Promise<DesktopState>;
  stopProcess: (name: ProcessName | 'all') => Promise<DesktopState>;
  restartProcess: (name: ProcessName | 'all') => Promise<DesktopState>;
  openExternal: (url: string) => Promise<void>;
  onState: (callback: (state: DesktopState) => void) => () => void;
  onLog: (callback: (payload: ProcessLogPayload) => void) => () => void;
}
