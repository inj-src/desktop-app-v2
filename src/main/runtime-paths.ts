import fs from 'node:fs';
import path from 'node:path';

export interface RuntimePathContext {
  appRootDir: string;
  isPackaged: boolean;
}

export function resolveBackendDir(context: RuntimePathContext): string {
  if (context.isPackaged) {
    return path.join(context.appRootDir, 'backend');
  }

  return path.resolve(context.appRootDir, '../sasthotech-hospital-backend-v1');
}

export function resolveFrontendRootDir(context: RuntimePathContext): string {
  if (context.isPackaged) {
    return path.join(context.appRootDir, 'frontend');
  }

  return path.resolve(context.appRootDir, '../hospital_v1');
}

export function resolveFrontendStaticDir(context: RuntimePathContext): string {
  const root = resolveFrontendRootDir(context);
  const outputDir = path.join(root, 'output');
  const outDir = path.join(root, 'out');

  if (fs.existsSync(outputDir) && fs.statSync(outputDir).isDirectory()) {
    return outputDir;
  }

  if (fs.existsSync(outDir) && fs.statSync(outDir).isDirectory()) {
    return outDir;
  }

  throw new Error(`Unable to find static frontend directory. Checked: ${outputDir} and ${outDir}`);
}

export function ensureBackendRuntimeDirectories(backendDir: string): void {
  const neededDirs = [
    path.join(backendDir, 'data', 'image'),
    path.join(backendDir, 'data', 'file'),
    path.join(backendDir, 'secretKeys'),
  ];

  for (const dirPath of neededDirs) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

function findFirstFileByPrefix(dirPath: string, prefix: string, suffix = ''): string | null {
  if (!fs.existsSync(dirPath)) {
    return null;
  }

  const entries = fs.readdirSync(dirPath, { withFileTypes: true });

  for (const entry of entries) {
    if (!entry.isFile()) {
      continue;
    }

    if (!entry.name.startsWith(prefix)) {
      continue;
    }

    if (suffix && !entry.name.endsWith(suffix)) {
      continue;
    }

    return path.join(dirPath, entry.name);
  }

  return null;
}

export function buildPrismaRuntimeEnv(backendDir: string): Record<string, string> {
  const runtimeEnv: Record<string, string> = {
    PRISMA_CLIENT_ENGINE_TYPE: 'library',
  };

  const prismaClientDir = path.join(backendDir, 'node_modules', '.prisma', 'client');
  const prismaEnginesDir = path.join(backendDir, 'node_modules', '@prisma', 'engines');

  const queryLibrary = findFirstFileByPrefix(prismaClientDir, 'libquery_engine', '.node');
  if (queryLibrary) {
    runtimeEnv.PRISMA_QUERY_ENGINE_LIBRARY = queryLibrary;
  }

  const queryBinary = findFirstFileByPrefix(prismaClientDir, 'query_engine');
  if (queryBinary) {
    runtimeEnv.PRISMA_QUERY_ENGINE_BINARY = queryBinary;
  }

  const schemaBinary = findFirstFileByPrefix(prismaEnginesDir, 'schema-engine');
  if (schemaBinary) {
    runtimeEnv.PRISMA_SCHEMA_ENGINE_BINARY = schemaBinary;
  }

  return runtimeEnv;
}
