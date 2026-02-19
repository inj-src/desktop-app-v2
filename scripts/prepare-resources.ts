import fs from 'node:fs';
import path from 'node:path';
import { spawn, spawnSync } from 'node:child_process';
import { createInterface } from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';
import { pathToFileURL } from 'node:url';

const rootDir = path.resolve(__dirname, '..');
const backendProjectDir = resolveProjectDir('BACKEND_PROJECT_DIR', [
  path.resolve(rootDir, '../sasthotech-hospital-backend-v1'),
  path.resolve(rootDir, 'sasthotech-hospital-backend-v1'),
]);
const frontendProjectDir = resolveProjectDir('FRONTEND_PROJECT_DIR', [
  path.resolve(rootDir, '../hospital_v1'),
  path.resolve(rootDir, 'hospital_v1'),
]);
const resourcesDir = path.join(rootDir, 'build-resources');
const tempResourcesDir = path.join(rootDir, 'build-resources.tmp');
const existingBackendResourcesDir = path.join(resourcesDir, 'backend');
const existingFrontendResourcesDir = path.join(resourcesDir, 'frontend');
const backendBundleFile = 'sasthotech-hospital-backend-v1.cjs';

const npmBin = process.platform === 'win32' ? 'npm.cmd' : 'npm';

interface ProjectGitMeta {
  branch: string;
  commit: string;
}

interface FreshBuildSelection {
  backend: boolean;
  frontend: boolean;
}

function resolveProjectDir(envName: string, fallbacks: string[]): string {
  const envValue = process.env[envName];
  const candidates = envValue ? [path.resolve(envValue), ...fallbacks] : fallbacks;

  for (const candidate of candidates) {
    if (!fs.existsSync(candidate)) {
      continue;
    }

    if (!fs.statSync(candidate).isDirectory()) {
      continue;
    }

    return candidate;
  }

  const message = [`Unable to resolve project directory for ${envName}.`, ...candidates.map(value => `- ${value}`)];
  throw new Error(message.join('\n'));
}

function readProjectGitMeta(projectDir: string): ProjectGitMeta | null {
  const branchResult = spawnSync('git', ['-C', projectDir, 'branch', '--show-current'], {
    encoding: 'utf8',
  });
  const commitResult = spawnSync('git', ['-C', projectDir, 'rev-parse', '--short', 'HEAD'], {
    encoding: 'utf8',
  });

  if (branchResult.status !== 0 || commitResult.status !== 0) {
    return null;
  }

  const branch = branchResult.stdout.trim() || 'detached-head';
  const commit = commitResult.stdout.trim() || 'unknown';
  return { branch, commit };
}

function assertExpectedBranch(projectLabel: string, meta: ProjectGitMeta | null, expectedBranch: string): void {
  if (!meta) {
    throw new Error(`${projectLabel} is not a git repository, cannot validate expected branch "${expectedBranch}".`);
  }

  if (meta.branch !== expectedBranch) {
    throw new Error(
      `${projectLabel} branch mismatch. Expected "${expectedBranch}" but found "${meta.branch}" (${meta.commit}).`
    );
  }
}

function writeBuildBranchMeta(
  backendMeta: ProjectGitMeta | null,
  frontendMeta: ProjectGitMeta | null
): void {
  const metadataPath = path.join(resourcesDir, 'build-meta.json');
  const payload = {
    builtAt: new Date().toISOString(),
    backend: backendMeta,
    frontend: frontendMeta,
  };

  fs.writeFileSync(metadataPath, JSON.stringify(payload, null, 2), 'utf8');
}

function directoryExists(directoryPath: string): boolean {
  return fs.existsSync(directoryPath) && fs.statSync(directoryPath).isDirectory();
}

function parseSelectionInput(value: string): FreshBuildSelection {
  const normalized = value.trim().toLowerCase();

  if (!normalized || normalized === 'n' || normalized === 'none') {
    return { backend: false, frontend: false };
  }

  if (normalized === 'b' || normalized === 'backend') {
    return { backend: true, frontend: false };
  }

  if (normalized === 'f' || normalized === 'frontend') {
    return { backend: false, frontend: true };
  }

  if (
    normalized === 'bf' ||
    normalized === 'fb' ||
    normalized === 'both' ||
    normalized === 'all' ||
    normalized === 'backend,frontend' ||
    normalized === 'frontend,backend'
  ) {
    return { backend: true, frontend: true };
  }

  const letters = new Set(normalized.replace(/[\s,]+/g, '').split(''));
  return {
    backend: letters.has('b'),
    frontend: letters.has('f'),
  };
}

async function askFreshBuildSelection(): Promise<FreshBuildSelection> {
  console.log('Fresh build options (checkbox style):');
  console.log(`[ ] Backend  (${backendProjectDir})`);
  console.log(`[ ] Frontend (${frontendProjectDir})`);
  console.log('Select with: b=backend, f=frontend, bf=both, n=none');

  const rl = createInterface({ input, output });
  try {
    const answer = await rl.question('Fresh build selection [n]: ');
    const parsed = parseSelectionInput(answer);
    return parsed;
  } finally {
    rl.close();
  }
}

async function resolveFreshBuildSelection(): Promise<FreshBuildSelection> {
  const hasBackendResources = directoryExists(existingBackendResourcesDir);
  const hasFrontendResources = directoryExists(existingFrontendResourcesDir);
  const canPrompt = hasBackendResources && hasFrontendResources && input.isTTY && output.isTTY;

  if (!canPrompt) {
    if (!hasBackendResources || !hasFrontendResources) {
      console.log('Missing existing build-resources for backend/frontend. Running a fresh build for both.');
      return { backend: true, frontend: true };
    }

    console.log('Non-interactive terminal detected. Reusing existing backend/frontend builds.');
    return { backend: false, frontend: false };
  }

  return askFreshBuildSelection();
}

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

function copyBackendResources(targetResourcesRootDir: string): void {
  const backendOutputDir = path.join(targetResourcesRootDir, 'backend');
  fs.mkdirSync(backendOutputDir, { recursive: true });

  const staticItems = ['src', 'prisma', 'package.json', 'data', 'secretKeys', backendBundleFile];

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
  fs.rmSync(path.join(backendOutputDir, 'node_modules'), { recursive: true, force: true });
}

function copyFrontendResources(targetResourcesRootDir: string): void {
  const frontendOutputDir = path.join(targetResourcesRootDir, 'frontend');
  fs.mkdirSync(frontendOutputDir, { recursive: true });

  const staticDir = resolveFrontendStaticDir();
  const staticDirName = path.basename(staticDir);

  copyIfExists(staticDir, path.join(frontendOutputDir, staticDirName));
}

function assertBackendBundleExists(targetResourcesRootDir: string): void {
  const bundledEntryPath = path.join(targetResourcesRootDir, 'backend', backendBundleFile);
  if (!fs.existsSync(bundledEntryPath)) {
    throw new Error(`Backend bundled entry was not found: ${bundledEntryPath}`);
  }
}

export async function prepareResources(): Promise<void> {
  const backendMeta = readProjectGitMeta(backendProjectDir);
  const frontendMeta = readProjectGitMeta(frontendProjectDir);

  if (backendMeta) {
    console.log(`Backend source: branch=${backendMeta.branch}, commit=${backendMeta.commit}`);
  }

  if (frontendMeta) {
    console.log(`Frontend source: branch=${frontendMeta.branch}, commit=${frontendMeta.commit}`);
  }

  const expectedBackendBranch = (process.env.EXPECTED_BACKEND_BRANCH || '').trim();
  const expectedFrontendBranch = (process.env.EXPECTED_FRONTEND_BRANCH || '').trim();

  if (expectedBackendBranch) {
    assertExpectedBranch('backend', backendMeta, expectedBackendBranch);
  }

  if (expectedFrontendBranch) {
    assertExpectedBranch('frontend', frontendMeta, expectedFrontendBranch);
  }

  const freshBuildSelection = await resolveFreshBuildSelection();
  const buildTasks: Promise<void>[] = [];

  if (freshBuildSelection.backend) {
    buildTasks.push(runCommand('backend-build', backendProjectDir, ['run', 'build']));
  }

  if (freshBuildSelection.frontend) {
    buildTasks.push(runCommand('frontend-build', frontendProjectDir, ['run', 'build:offline']));
  }

  if (buildTasks.length > 0) {
    console.log('Running selected fresh builds...');
    await Promise.all(buildTasks);
  } else {
    console.log('Skipping fresh backend/frontend builds and using current build outputs.');
  }

  console.log('Copying build resources for packaging...');

  fs.rmSync(tempResourcesDir, { recursive: true, force: true });
  fs.mkdirSync(tempResourcesDir, { recursive: true });

  if (freshBuildSelection.backend) {
    copyBackendResources(tempResourcesDir);
  } else {
    copyIfExists(existingBackendResourcesDir, path.join(tempResourcesDir, 'backend'));
  }

  fs.rmSync(path.join(tempResourcesDir, 'backend', 'node_modules'), { recursive: true, force: true });
  assertBackendBundleExists(tempResourcesDir);

  if (freshBuildSelection.frontend) {
    copyFrontendResources(tempResourcesDir);
  } else {
    copyIfExists(existingFrontendResourcesDir, path.join(tempResourcesDir, 'frontend'));
  }

  fs.rmSync(resourcesDir, { recursive: true, force: true });
  fs.renameSync(tempResourcesDir, resourcesDir);
  writeBuildBranchMeta(backendMeta, frontendMeta);
}

if (pathToFileURL(process.argv[1]).href === import.meta.url) {
  void prepareResources().catch(error => {
    console.error(error);
    process.exit(1);
  });
}
