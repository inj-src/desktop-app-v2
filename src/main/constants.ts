import type { DatabaseMode, ProcessName } from '../types';

export const HOSTNAME = 'sasthotech.local';
export const BACKEND_PORT = 5000;
export const FRONTEND_PORT = 3000;
export const MDNS_TTL = 300;
export const MDNS_CHECK_INTERVAL_MS = 5000;
export const PGLITE_HOST = '127.0.0.1';
export const PGLITE_PORT = parsePort(process.env.PGLITE_PORT, 5433);
export const DB_MODE = parseDatabaseMode({
  dbMode: process.env.DB_MODE,
  databaseMode: process.env.DATABASE_MODE,
  useExternalDb: process.env.USE_EXTERNAL_DB,
});

export const PROCESS_NAMES: ProcessName[] = ['backend', 'frontend'];

export function isProcessName(value: unknown): value is ProcessName {
  return value === 'backend' || value === 'frontend';
}

function parsePort(value: string | undefined, fallback: number): number {
  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed <= 0 || parsed > 65535) {
    return fallback;
  }

  return parsed;
}

interface ParseDatabaseModeInput {
  dbMode?: string;
  databaseMode?: string;
  useExternalDb?: string;
}

function parseDatabaseMode(input: ParseDatabaseModeInput): DatabaseMode {
  if (isTruthyFlag(input.useExternalDb)) {
    return 'external-postgres';
  }

  const rawValue = (input.dbMode || input.databaseMode || '').trim().toLowerCase();
  if (
    rawValue === 'external-postgres' ||
    rawValue === 'external' ||
    rawValue === 'postgres' ||
    rawValue === 'external_pg'
  ) {
    return 'external-postgres';
  }

  return 'pglite';
}

function isTruthyFlag(value: string | undefined): boolean {
  if (!value) {
    return false;
  }

  const normalized = value.trim().toLowerCase();
  return normalized === '1' || normalized === 'true' || normalized === 'yes' || normalized === 'on';
}
