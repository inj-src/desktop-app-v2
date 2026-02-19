import type { ProcessName } from '../types';

export const HOSTNAME = 'sasthotech.local';
export const BACKEND_PORT = 5000;
export const FRONTEND_PORT = 3000;
export const MDNS_TTL = 300;
export const MDNS_CHECK_INTERVAL_MS = 5000;

export const PROCESS_NAMES: ProcessName[] = ['backend', 'frontend'];

export function isProcessName(value: unknown): value is ProcessName {
  return value === 'backend' || value === 'frontend';
}
