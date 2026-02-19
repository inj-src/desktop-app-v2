import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { pathToFileURL } from 'node:url';

const rootDir = path.resolve(__dirname, '..');
const backendProjectDir = path.resolve(rootDir, '../sasthotech-hospital-backend-v1');
const frontendProjectDir = path.resolve(rootDir, '../hospital_v1');
const resourcesDir = path.join(rootDir, 'build-resources');

const npmBin = process.platform === 'win32' ? 'npm.cmd' : 'npm';

function runCommand(label: string, cwd: string, args: string[]): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = spawn(npmBin, args, {
      cwd,
      env: process.env,
      stdio: ['ignore', 'pipe', 'pipe'],
    });

    child.stdout.on('data', data => {
      process.stdout.write(`[${label}] ${data}`);
    });

    child.stderr.on('data', data => {
      process.stderr.write(`[${label}] ${data}`);
    });

    child.on('error', reject);

    child.on('close', code => {
      if (code === 0) {
        resolve();
        return;
      }

      reject(new Error(`${label} exited with code ${code}`));
    });
  });
}

function copyIfExists(sourcePath: string, targetPath: string): void {
  if (!fs.existsSync(sourcePath)) {
    return;
  }

  fs.cpSync(sourcePath, targetPath, { recursive: true });
}

function resolveFrontendStaticDir(): string {
  const outputDir = path.join(frontendProjectDir, 'output');
  const outDir = path.join(frontendProjectDir, 'out');

  if (fs.existsSync(outputDir) && fs.statSync(outputDir).isDirectory()) {
    return outputDir;
  }

  if (fs.existsSync(outDir) && fs.statSync(outDir).isDirectory()) {
    return outDir;
  }

  throw new Error(`Frontend static output not found. Checked: ${outputDir}, ${outDir}`);
}

function copyBackendResources(): void {
  const backendOutputDir = path.join(resourcesDir, 'backend');
  fs.mkdirSync(backendOutputDir, { recursive: true });

  const staticItems = [
    'src',
    'prisma',
    'node_modules',
    'package.json',
    'package-lock.json',
    'data',
    'secretKeys',
  ];

  for (const item of staticItems) {
    copyIfExists(path.join(backendProjectDir, item), path.join(backendOutputDir, item));
  }

  const rootEntries = fs.readdirSync(backendProjectDir, { withFileTypes: true });

  for (const entry of rootEntries) {
    if (!entry.isFile() || !entry.name.startsWith('.env')) {
      continue;
    }

    copyIfExists(path.join(backendProjectDir, entry.name), path.join(backendOutputDir, entry.name));
  }

  fs.mkdirSync(path.join(backendOutputDir, 'data', 'image'), { recursive: true });
  fs.mkdirSync(path.join(backendOutputDir, 'data', 'file'), { recursive: true });
  fs.mkdirSync(path.join(backendOutputDir, 'secretKeys'), { recursive: true });
}

function copyFrontendResources(): void {
  const frontendOutputDir = path.join(resourcesDir, 'frontend');
  fs.mkdirSync(frontendOutputDir, { recursive: true });

  const staticDir = resolveFrontendStaticDir();
  const staticDirName = path.basename(staticDir);

  copyIfExists(staticDir, path.join(frontendOutputDir, staticDirName));
}

export async function prepareResources(): Promise<void> {
  console.log('Running backend and frontend builds in parallel...');

  await Promise.all([
    runCommand('backend-build', backendProjectDir, ['run', 'build']),
    runCommand('frontend-build', frontendProjectDir, ['run', 'build:offline']),
  ]);

  console.log('Copying build resources for packaging...');

  fs.rmSync(resourcesDir, { recursive: true, force: true });
  fs.mkdirSync(resourcesDir, { recursive: true });

  copyBackendResources();
  copyFrontendResources();
}

if (pathToFileURL(process.argv[1]).href === import.meta.url) {
  void prepareResources().catch(error => {
    console.error(error);
    process.exit(1);
  });
}
