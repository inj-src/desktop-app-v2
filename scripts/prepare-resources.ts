import path from 'node:path';
import {
  assertExpectedBranch,
  copyBuildResources,
  directoryExists,
  paint,
  readProjectGitMeta,
  resolveProjectDir,
  reuseExistingResourcesInPlace,
  runCommand,
  writeBuildBranchMeta,
} from './prepare-resources-utils';
import { resolveFreshBuildSelection } from './prepare-resources-selection';
import { createResourcesArchive, resolveResourcesArchiveLayout } from './resources-archive';

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
const paths = {
  backendProjectDir,
  frontendProjectDir,
  resourcesDir,
  tempResourcesDir: path.join(rootDir, 'build-resources.tmp'),
  existingBackendResourcesDir: path.join(resourcesDir, 'backend'),
  existingFrontendResourcesDir: path.join(resourcesDir, 'frontend'),
  backendBundleFile: 'sasthotech-hospital-backend-v1.cjs',
};
const resourcesArchiveLayout = resolveResourcesArchiveLayout(rootDir);

const npmBin = process.platform === 'win32' ? 'npm.cmd' : 'npm';

function printSourceMeta(): { backendMeta: ReturnType<typeof readProjectGitMeta>; frontendMeta: ReturnType<typeof readProjectGitMeta> } {
  const backendMeta = readProjectGitMeta(backendProjectDir);
  const frontendMeta = readProjectGitMeta(frontendProjectDir);

  if (backendMeta) {
    console.log(`Backend source: branch=${backendMeta.branch}, commit=${backendMeta.commit}`);
  }

  if (frontendMeta) {
    console.log(`Frontend source: branch=${frontendMeta.branch}, commit=${frontendMeta.commit}`);
  }

  return { backendMeta, frontendMeta };
}

function validateExpectedBranches(
  backendMeta: ReturnType<typeof readProjectGitMeta>,
  frontendMeta: ReturnType<typeof readProjectGitMeta>
): void {
  const expectedBackendBranch = (process.env.EXPECTED_BACKEND_BRANCH || '').trim();
  const expectedFrontendBranch = (process.env.EXPECTED_FRONTEND_BRANCH || '').trim();

  if (expectedBackendBranch) {
    assertExpectedBranch('backend', backendMeta, expectedBackendBranch);
  }

  if (expectedFrontendBranch) {
    assertExpectedBranch('frontend', frontendMeta, expectedFrontendBranch);
  }
}

async function runSelectedBuilds(backend: boolean, frontend: boolean): Promise<void> {
  const buildTasks: Promise<void>[] = [];

  if (backend) {
    buildTasks.push(runCommand('backend-build', backendProjectDir, ['run', 'build'], npmBin));
  }

  if (frontend) {
    buildTasks.push(runCommand('frontend-build', frontendProjectDir, ['run', 'build:offline'], npmBin));
  }

  if (buildTasks.length === 0) {
    console.log(paint('Skipping fresh backend/frontend builds and using current build outputs.', 'yellow'));
    return;
  }

  console.log(paint('Running selected fresh builds...', 'bold'));
  await Promise.all(buildTasks);
}

export async function prepareResources(): Promise<void> {
  const { backendMeta, frontendMeta } = printSourceMeta();
  validateExpectedBranches(backendMeta, frontendMeta);

  const selection = await resolveFreshBuildSelection(
    directoryExists(paths.existingBackendResourcesDir),
    directoryExists(paths.existingFrontendResourcesDir),
    backendProjectDir,
    frontendProjectDir
  );

  await runSelectedBuilds(selection.backend, selection.frontend);

  if (!selection.backend && !selection.frontend) {
    console.log(paint('No fresh build selected. Reusing build-resources in place...', 'bold'));
    reuseExistingResourcesInPlace(paths);
    createResourcesArchive(resourcesArchiveLayout);
    console.log(paint('Build resources copied successfully.', 'green'));
    console.log(paint('Build resources archive created: build-resources/resources.zip', 'green'));
    return;
  }

  console.log(paint('Copying build resources for packaging...', 'bold'));
  copyBuildResources(paths, selection);
  writeBuildBranchMeta(resourcesDir, backendMeta, frontendMeta);
  createResourcesArchive(resourcesArchiveLayout);
  console.log(paint('Build resources copied successfully.', 'green'));
  console.log(paint('Build resources archive created: build-resources/resources.zip', 'green'));
}

void prepareResources().catch(error => {
  console.error(paint(String(error), 'red'));
  process.exit(1);
});
