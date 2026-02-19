import fs from 'node:fs';
import { createHash } from 'node:crypto';
import path from 'node:path';
import { spawn } from 'node:child_process';

import { PGlite } from '@electric-sql/pglite';
import { pg_trgm } from '@electric-sql/pglite/contrib/pg_trgm';
import { PGLiteSocketServer } from '@electric-sql/pglite-socket';

import type { DatabaseMode, DatabaseState } from '../types';
import { buildPrismaRuntimeEnv } from './runtime-paths';

const EMBEDDED_MIGRATIONS_TABLE = '_embedded_pglite_migrations';

interface PgliteServiceOptions {
  mode: DatabaseMode;
  host: string;
  port: number;
  dataDir: string;
  backendDir: string;
  externalDatabaseUrl?: string;
  onLog: (target: string, stream: string, message: string) => void;
  onStateChange: () => void;
}

interface EmbeddedMigrationFile {
  name: string;
  sql: string;
  checksum: string;
}

export class PgliteService {
  private readonly mode: DatabaseMode;
  private readonly host: string;
  private readonly port: number;
  private readonly dataDir: string;
  private readonly backendDir: string;
  private readonly externalDatabaseUrl: string | undefined;
  private readonly onLog: (target: string, stream: string, message: string) => void;
  private readonly onStateChange: () => void;

  private db: PGlite | null = null;
  private socketServer: PGLiteSocketServer | null = null;

  private state: DatabaseState;

  constructor(options: PgliteServiceOptions) {
    this.mode = options.mode;
    this.host = options.host;
    this.port = options.port;
    this.dataDir = options.dataDir;
    this.backendDir = options.backendDir;
    this.externalDatabaseUrl = options.externalDatabaseUrl;
    this.onLog = options.onLog;
    this.onStateChange = options.onStateChange;

    this.state = {
      mode: this.mode,
      status: 'stopped',
      running: false,
      host: this.mode === 'pglite' ? this.host : null,
      port: this.mode === 'pglite' ? this.port : null,
      dataDir: this.mode === 'pglite' ? this.dataDir : null,
      connectionString: null,
      lastError: null,
    };
  }

  getSnapshot(): DatabaseState {
    return { ...this.state };
  }

  getDatabaseUrl(): string | null {
    return this.state.connectionString;
  }

  async start(): Promise<void> {
    if (this.state.running || this.state.status === 'starting') {
      return;
    }

    this.onLog('database', 'system', `Database mode selected: ${this.mode}`);

    this.setState({
      status: 'starting',
      running: false,
      lastError: null,
    });

    if (this.mode === 'external-postgres') {
      await this.startExternalMode();
      return;
    }

    await this.startPgliteMode();
  }

  async stop(): Promise<void> {
    if (this.mode === 'external-postgres') {
      this.setState({
        status: 'stopped',
        running: false,
        connectionString: null,
      });
      return;
    }

    await this.stopPgliteInternals();
    this.setState({
      status: 'stopped',
      running: false,
      connectionString: null,
    });
  }

  private async startExternalMode(): Promise<void> {
    const externalUrl = (this.externalDatabaseUrl || process.env.DATABASE_URL || '').trim();
    if (!externalUrl) {
      this.setState({
        status: 'error',
        running: false,
        lastError:
          'DB_MODE=external-postgres requires DATABASE_URL_EXTERNAL (or DATABASE_URL) to be set.',
      });
      throw new Error(this.state.lastError ?? 'External database URL is missing.');
    }

    const parsed = safeParseUrl(externalUrl);
    this.setState({
      status: 'running',
      running: true,
      connectionString: externalUrl,
      host: parsed?.hostname || null,
      port: parsed?.port ? Number(parsed.port) : null,
      dataDir: null,
      lastError: null,
    });

    this.onLog('database', 'system', 'Using external PostgreSQL database mode.');
  }

  private async startPgliteMode(): Promise<void> {
    try {
      fs.mkdirSync(this.dataDir, { recursive: true });

      this.db = await PGlite.create(this.dataDir, {
        extensions: {
          pg_trgm: pg_trgm as any,
        },
      });

      await this.db.waitReady;
      await this.runCompatibilityChecks();
      await this.runEmbeddedMigrations();

      await this.startSocketServer();
      const setupDatabaseUrl = normalizeDatabaseUrl(this.socketServer!.getServerConn(), this.host, this.port);
      const setupRan = await this.runBackendSetupScript(setupDatabaseUrl);

      if (setupRan) {
        // setup.js uses Prisma over pgwire; reset socket sessions to avoid stale prepared statements.
        await this.restartSocketServer();
      }

      const databaseUrl = normalizeDatabaseUrl(this.socketServer!.getServerConn(), this.host, this.port);

      this.setState({
        status: 'running',
        running: true,
        connectionString: databaseUrl,
        lastError: null,
      });

      this.onLog('database', 'system', `PGlite socket server listening on ${this.host}:${this.port}`);
    } catch (error) {
      await this.stopPgliteInternals();

      const message = error instanceof Error ? error.message : String(error);
      this.setState({
        status: 'error',
        running: false,
        connectionString: null,
        lastError: message,
      });

      this.onLog('database', 'error', `Failed to start embedded database: ${message}`);
      throw error;
    }
  }

  private async stopPgliteInternals(): Promise<void> {
    if (this.socketServer) {
      try {
        await this.socketServer.stop();
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        this.onLog('database', 'error', `Failed stopping socket server: ${message}`);
      }
      this.socketServer = null;
    }

    if (this.db) {
      try {
        await this.db.close();
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        this.onLog('database', 'error', `Failed closing PGlite database: ${message}`);
      }
      this.db = null;
    }
  }

  private async startSocketServer(): Promise<void> {
    if (!this.db) {
      throw new Error('PGlite is not initialized.');
    }

    const socketServer = new PGLiteSocketServer({
      db: this.db,
      host: this.host,
      port: this.port,
    });

    socketServer.addEventListener('error', event => {
      const payload = event as unknown as { error?: unknown };
      const message = payload.error instanceof Error ? payload.error.message : 'Unknown socket error';
      this.onLog('database', 'error', `Socket server error: ${message}`);
    });

    await socketServer.start();
    this.socketServer = socketServer;
  }

  private async restartSocketServer(): Promise<void> {
    if (this.socketServer) {
      await this.socketServer.stop();
      this.socketServer = null;
    }

    await this.startSocketServer();
  }

  private async runCompatibilityChecks(): Promise<void> {
    if (!this.db) {
      throw new Error('PGlite is not initialized.');
    }

    this.onLog('database', 'system', 'Running PGlite compatibility preflight checks...');

    await this.db.query('SELECT version();');
    await this.db.query("SELECT to_tsvector('english', 'sasthotech pglite check') AS vector;");
    await this.db.exec('DO $$ BEGIN PERFORM 1; END $$ LANGUAGE plpgsql;');
    await this.db.exec('CREATE EXTENSION IF NOT EXISTS pg_trgm;');
    await this.db.query("SELECT similarity('sasthotech', 'sasthotek') AS score;");

    this.onLog('database', 'system', 'Compatibility checks passed.');
  }

  private async runEmbeddedMigrations(): Promise<void> {
    if (!this.db) {
      throw new Error('PGlite is not initialized.');
    }

    const migrationsDir = path.join(this.backendDir, 'prisma', 'migrations');
    if (!fs.existsSync(migrationsDir)) {
      throw new Error(`Prisma migrations directory not found at ${migrationsDir}`);
    }

    const migrations = loadEmbeddedMigrations(migrationsDir);
    this.onLog('database', 'system', `Loaded ${migrations.length} migration files for embedded apply.`);

    await this.db.exec(`
      CREATE TABLE IF NOT EXISTS "public"."${EMBEDDED_MIGRATIONS_TABLE}" (
        "id" BIGSERIAL PRIMARY KEY,
        "migration_name" TEXT NOT NULL UNIQUE,
        "checksum" TEXT NOT NULL,
        "applied_at" TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );
    `);

    await this.importPrismaMigrationHistory(migrations);

    const appliedRows = await this.db.query<{
      migration_name: string;
      checksum: string;
    }>(`SELECT "migration_name", "checksum" FROM "public"."${EMBEDDED_MIGRATIONS_TABLE}";`);

    const appliedMap = new Map<string, string>();
    for (const row of appliedRows.rows) {
      appliedMap.set(String(row.migration_name), String(row.checksum));
    }

    let appliedCount = 0;
    let skippedCount = 0;

    for (const migration of migrations) {
      const previousChecksum = appliedMap.get(migration.name);
      if (previousChecksum) {
        if (previousChecksum !== migration.checksum) {
          throw new Error(
            `Migration "${migration.name}" checksum mismatch in embedded migration table. Existing=${previousChecksum}, current=${migration.checksum}.`
          );
        }

        skippedCount += 1;
        continue;
      }

      this.onLog('database', 'system', `Applying embedded migration ${migration.name}...`);
      const startedAt = Date.now();

      try {
        await this.db.exec(migration.sql);
      } catch (error) {
        const reason = error instanceof Error ? error.message : String(error);
        throw new Error(`Embedded migration "${migration.name}" failed: ${reason}`);
      }

      await this.db.query(
        `INSERT INTO "public"."${EMBEDDED_MIGRATIONS_TABLE}" ("migration_name", "checksum", "applied_at") VALUES ($1, $2, NOW())`,
        [migration.name, migration.checksum]
      );

      appliedMap.set(migration.name, migration.checksum);
      appliedCount += 1;
      this.onLog(
        'database',
        'system',
        `Applied embedded migration ${migration.name} in ${Date.now() - startedAt}ms.`
      );
    }

    this.onLog(
      'database',
      'system',
      `Embedded migrations completed. Applied=${appliedCount}, skipped=${skippedCount}.`
    );
  }

  private async runBackendSetupScript(databaseUrl: string): Promise<boolean> {
    const setupScriptPath = path.join(this.backendDir, 'setup.js');
    const shouldRunSetup = process.env.PGLITE_RUN_SETUP !== 'false';

    if (!shouldRunSetup) {
      this.onLog('database', 'system', 'Skipping setup.js because PGLITE_RUN_SETUP=false.');
      return false;
    }

    if (!fs.existsSync(setupScriptPath)) {
      this.onLog('database', 'system', `No setup.js found at ${setupScriptPath}; skipping setup.`);
      return false;
    }

    this.onLog('database', 'system', 'Running backend setup.js against embedded PGlite database...');

    await runNodeCommand({
      cmd: process.execPath,
      args: [setupScriptPath],
      cwd: this.backendDir,
      env: {
        ...process.env,
        ELECTRON_RUN_AS_NODE: '1',
        DATABASE_URL: databaseUrl,
        PRISMA_HIDE_UPDATE_MESSAGE: '1',
        ...buildPrismaRuntimeEnv(this.backendDir),
      },
      onStdout: message => this.onLog('database', 'stdout', `[setup] ${message}`),
      onStderr: message => this.onLog('database', 'stderr', `[setup] ${message}`),
    });

    this.onLog('database', 'system', 'setup.js finished successfully.');
    return true;
  }

  private async importPrismaMigrationHistory(migrations: EmbeddedMigrationFile[]): Promise<void> {
    if (!this.db) {
      throw new Error('PGlite is not initialized.');
    }

    const tableExistsResult = await this.db.query<{ exists: boolean }>(`
      SELECT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public' AND table_name = '_prisma_migrations'
      ) AS "exists";
    `);

    if (!tableExistsResult.rows[0]?.exists) {
      return;
    }

    const migrationMap = new Map<string, EmbeddedMigrationFile>();
    for (const migration of migrations) {
      migrationMap.set(migration.name, migration);
    }

    const prismaRows = await this.db.query<{
      migration_name: string;
      finished_at: string | null;
      rolled_back_at: string | null;
    }>(`
      SELECT "migration_name", "finished_at", "rolled_back_at"
      FROM "public"."_prisma_migrations";
    `);

    let importedCount = 0;
    let unresolvedFailedCount = 0;

    for (const row of prismaRows.rows) {
      const migrationName = String(row.migration_name);
      const migration = migrationMap.get(migrationName);
      if (!migration) {
        continue;
      }

      const finishedAt = row.finished_at;
      const rolledBackAt = row.rolled_back_at;
      const isApplied = Boolean(finishedAt) && !rolledBackAt;

      if (!isApplied) {
        unresolvedFailedCount += 1;
        continue;
      }

      await this.db.query(
        `INSERT INTO "public"."${EMBEDDED_MIGRATIONS_TABLE}" ("migration_name", "checksum", "applied_at")
         VALUES ($1, $2, COALESCE($3::timestamptz, NOW()))
         ON CONFLICT ("migration_name") DO NOTHING;`,
        [migration.name, migration.checksum, finishedAt]
      );

      importedCount += 1;
    }

    if (importedCount > 0) {
      this.onLog(
        'database',
        'system',
        `Imported ${importedCount} applied migration records from _prisma_migrations.`
      );
    }

    if (unresolvedFailedCount > 0) {
      this.onLog(
        'database',
        'system',
        `Found ${unresolvedFailedCount} unfinished Prisma migration records. Embedded runner will apply any missing migration files directly.`
      );
    }
  }

  private setState(patch: Partial<DatabaseState>): void {
    Object.assign(this.state, patch);
    this.onStateChange();
  }
}

function loadEmbeddedMigrations(migrationsDir: string): EmbeddedMigrationFile[] {
  const dirNames = fs
    .readdirSync(migrationsDir, { withFileTypes: true })
    .filter(entry => entry.isDirectory())
    .map(entry => entry.name)
    .sort();

  const migrations: EmbeddedMigrationFile[] = [];

  for (const name of dirNames) {
    const sqlFilePath = path.join(migrationsDir, name, 'migration.sql');
    if (!fs.existsSync(sqlFilePath)) {
      continue;
    }

    const sql = fs.readFileSync(sqlFilePath, 'utf8');
    const checksum = createHash('sha256').update(sql).digest('hex');

    migrations.push({
      name,
      sql,
      checksum,
    });
  }

  return migrations;
}

interface NodeCommandOptions {
  cmd: string;
  args: string[];
  cwd: string;
  env: NodeJS.ProcessEnv;
  onStdout: (message: string) => void;
  onStderr: (message: string) => void;
}

async function runNodeCommand(options: NodeCommandOptions): Promise<void> {
  await new Promise<void>((resolve, reject) => {
    const child = spawn(options.cmd, options.args, {
      cwd: options.cwd,
      env: options.env,
      stdio: ['ignore', 'pipe', 'pipe'],
      detached: false,
    });

    child.stdout.on('data', chunk => {
      options.onStdout(String(chunk));
    });

    child.stderr.on('data', chunk => {
      options.onStderr(String(chunk));
    });

    child.on('error', error => {
      reject(error);
    });

    child.on('exit', code => {
      if (code === 0) {
        resolve();
        return;
      }

      reject(new Error(`Command failed (${options.cmd} ${options.args.join(' ')}) with exit code ${code}`));
    });
  });
}

function normalizeDatabaseUrl(connectionString: string, host: string, port: number): string {
  const trimmed = String(connectionString || '').trim();
  const normalizedInput = trimmed.includes('://')
    ? trimmed
    : `postgresql://postgres:postgres@${host}:${port}/postgres`;

  let parsed: URL;
  try {
    parsed = new URL(normalizedInput);
  } catch {
    parsed = new URL(`postgresql://postgres:postgres@${host}:${port}/postgres`);
  }

  parsed.searchParams.set('sslmode', 'disable');
  parsed.searchParams.set('pgbouncer', 'true');
  parsed.searchParams.set('connection_limit', '1');
  parsed.searchParams.set('pool_timeout', '0');
  return parsed.toString();
}

function safeParseUrl(value: string): URL | null {
  try {
    return new URL(value);
  } catch {
    return null;
  }
}
