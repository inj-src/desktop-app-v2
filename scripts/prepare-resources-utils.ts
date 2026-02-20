import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { stdout as output } from "node:process";
import crossSpawn from "cross-spawn";

export interface ProjectGitMeta {
  branch: string;
  commit: string;
}

export interface FreshBuildSelection {
  backend: boolean;
  frontend: boolean;
}

export interface PrepareResourcesPaths {
  backendProjectDir: string;
  frontendProjectDir: string;
  resourcesDir: string;
  tempResourcesDir: string;
  existingBackendResourcesDir: string;
  existingFrontendResourcesDir: string;
  backendBundleFile: string;
}

const colors = {
  reset: "\x1b[0m",
  bold: "\x1b[1m",
  dim: "\x1b[2m",
  cyan: "\x1b[36m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  red: "\x1b[31m",
};

export function paint(text: string, color: keyof typeof colors): string {
  if (!output.isTTY) {
    return text;
  }

  return `${colors[color]}${text}${colors.reset}`;
}

export function resolveProjectDir(envName: string, fallbacks: string[]): string {
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

  const message = [
    `Unable to resolve project directory for ${envName}.`,
    ...candidates.map((value) => `- ${value}`),
  ];
  throw new Error(message.join("\n"));
}

export function readProjectGitMeta(projectDir: string): ProjectGitMeta | null {
  const branchResult = spawnSync("git", ["-C", projectDir, "branch", "--show-current"], {
    encoding: "utf8",
  });
  const commitResult = spawnSync("git", ["-C", projectDir, "rev-parse", "--short", "HEAD"], {
    encoding: "utf8",
  });

  if (branchResult.status !== 0 || commitResult.status !== 0) {
    return null;
  }

  const branch = branchResult.stdout.trim() || "detached-head";
  const commit = commitResult.stdout.trim() || "unknown";
  return { branch, commit };
}

export function assertExpectedBranch(
  projectLabel: string,
  meta: ProjectGitMeta | null,
  expectedBranch: string,
): void {
  if (!meta) {
    throw new Error(
      `${projectLabel} is not a git repository, cannot validate expected branch "${expectedBranch}".`,
    );
  }

  if (meta.branch !== expectedBranch) {
    throw new Error(
      `${projectLabel} branch mismatch. Expected "${expectedBranch}" but found "${meta.branch}" (${meta.commit}).`,
    );
  }
}

export function writeBuildBranchMeta(
  resourcesDir: string,
  backendMeta: ProjectGitMeta | null,
  frontendMeta: ProjectGitMeta | null,
): void {
  const metadataPath = path.join(resourcesDir, "build-meta.json");
  const payload = {
    builtAt: new Date().toISOString(),
    backend: backendMeta,
    frontend: frontendMeta,
  };

  fs.writeFileSync(metadataPath, JSON.stringify(payload, null, 2), "utf8");
}

export function directoryExists(directoryPath: string): boolean {
  return fs.existsSync(directoryPath) && fs.statSync(directoryPath).isDirectory();
}

export function runCommand(
  label: string,
  cwd: string,
  args: string[],
  npmBin: string,
): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = crossSpawn(npmBin, args, {
      cwd,
      env: process.env,
      stdio: ["ignore", "pipe", "pipe"],
    });

    child.stdout?.on("data", (data) => {
      process.stdout.write(`[${label}] ${data}`);
    });

    child.stderr?.on("data", (data) => {
      process.stderr.write(`[${label}] ${data}`);
    });

    child.on("error", reject);

    child.on("close", (code) => {
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

function resolvePrismaRuntimeFiles(prismaClientDir: string): string[] {
  const wasmFiles = fs
    .readdirSync(prismaClientDir, { withFileTypes: true })
    .filter((entry) => entry.isFile() && entry.name.endsWith(".wasm"))
    .map((entry) => entry.name);

  if (wasmFiles.length === 0) {
    throw new Error(
      [
        "Missing Prisma runtime wasm files required for packaged backend.",
        `- ${prismaClientDir}`,
        "Run `npm install` and `npx prisma generate` in backend repository, then run `npm run prepare:resources` again.",
      ].join("\n"),
    );
  }

  const schemaFile = "schema.prisma";
  if (!fs.existsSync(path.join(prismaClientDir, schemaFile))) {
    throw new Error(
      [
        "Missing Prisma runtime schema file required for packaged backend.",
        `- ${path.join(prismaClientDir, schemaFile)}`,
        "Run `npm install` and `npx prisma generate` in backend repository, then run `npm run prepare:resources` again.",
      ].join("\n"),
    );
  }

  return [...wasmFiles, schemaFile];
}

function copyPrismaRuntimeNodeModules(backendProjectDir: string, backendOutputDir: string): void {
  const prismaClientSourceDir = path.join(backendProjectDir, "node_modules", ".prisma", "client");
  const prismaClientOutputDir = path.join(backendOutputDir, "node_modules", ".prisma", "client");

  if (!fs.existsSync(prismaClientSourceDir)) {
    throw new Error(
      [
        "Missing Prisma runtime folder required for packaged backend.",
        `- ${prismaClientSourceDir}`,
        "Run `npm install` and `npx prisma generate` in backend repository, then run `npm run prepare:resources` again.",
      ].join("\n"),
    );
  }

  const runtimeFiles = resolvePrismaRuntimeFiles(prismaClientSourceDir);
  fs.mkdirSync(prismaClientOutputDir, { recursive: true });

  for (const runtimeFile of runtimeFiles) {
    copyIfExists(
      path.join(prismaClientSourceDir, runtimeFile),
      path.join(prismaClientOutputDir, runtimeFile),
    );
  }
}

function normalizePrismaRuntimeNodeModules(targetResourcesRootDir: string): void {
  const backendOutputDir = path.join(targetResourcesRootDir, "backend");
  const prismaClientDir = path.join(backendOutputDir, "node_modules", ".prisma", "client");

  // Legacy resources may include `node_modules/@prisma/*`; runtime only needs `.prisma/client`.
  fs.rmSync(path.join(backendOutputDir, "node_modules", "@prisma"), {
    recursive: true,
    force: true,
  });

  if (!fs.existsSync(prismaClientDir) || !fs.statSync(prismaClientDir).isDirectory()) {
    return;
  }

  const requiredFiles = new Set(resolvePrismaRuntimeFiles(prismaClientDir));
  const entries = fs.readdirSync(prismaClientDir, { withFileTypes: true });

  for (const entry of entries) {
    if (!entry.isFile() || requiredFiles.has(entry.name)) {
      continue;
    }

    fs.rmSync(path.join(prismaClientDir, entry.name), { force: true });
  }
}

function pruneArtifacts(rootDir: string, shouldDelete: (filePath: string) => boolean): number {
  if (!fs.existsSync(rootDir)) {
    return 0;
  }

  let removedCount = 0;
  const queue: string[] = [rootDir];

  while (queue.length > 0) {
    const current = queue.pop();
    if (!current) {
      continue;
    }

    const entries = fs.readdirSync(current, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(current, entry.name);

      if (entry.isDirectory()) {
        queue.push(fullPath);
        continue;
      }

      if (!entry.isFile()) {
        continue;
      }

      if (!shouldDelete(fullPath)) {
        continue;
      }

      fs.rmSync(fullPath, { force: true });
      removedCount += 1;
    }
  }

  return removedCount;
}

function pruneBackendBuildArtifacts(targetResourcesRootDir: string): void {
  const backendOutputDir = path.join(targetResourcesRootDir, "backend");
  const removedCount = pruneArtifacts(backendOutputDir, (filePath) => filePath.endsWith(".map"));
  if (removedCount > 0) {
    console.log(`Pruned ${removedCount} backend sourcemap files.`);
  }
}

function pruneFrontendBuildArtifacts(targetResourcesRootDir: string): void {
  const frontendOutputDir = path.join(targetResourcesRootDir, "frontend");
  const removedCount = pruneArtifacts(frontendOutputDir, (filePath) => {
    const normalized = filePath.replace(/\\/g, "/");
    return normalized.endsWith(".map") || normalized.endsWith("/.DS_Store");
  });

  if (removedCount > 0) {
    console.log(`Pruned ${removedCount} frontend sourcemap/metadata files.`);
  }
}

function resolveFrontendStaticDir(frontendProjectDir: string): string {
  const outputDir = path.join(frontendProjectDir, "output");
  const outDir = path.join(frontendProjectDir, "out");

  if (fs.existsSync(outputDir) && fs.statSync(outputDir).isDirectory()) {
    return outputDir;
  }

  if (fs.existsSync(outDir) && fs.statSync(outDir).isDirectory()) {
    return outDir;
  }

  throw new Error(`Frontend static output not found. Checked: ${outputDir}, ${outDir}`);
}

function copyBackendResources(paths: PrepareResourcesPaths, targetResourcesRootDir: string): void {
  const backendOutputDir = path.join(targetResourcesRootDir, "backend");
  fs.mkdirSync(backendOutputDir, { recursive: true });

  const staticItems = ["prisma", "package.json", "data", "secretKeys", paths.backendBundleFile];

  for (const item of staticItems) {
    copyIfExists(path.join(paths.backendProjectDir, item), path.join(backendOutputDir, item));
  }

  copyIfExists(
    path.join(paths.backendProjectDir, "src", "views"),
    path.join(backendOutputDir, "views"),
  );

  const offlineEnvPath = path.join(paths.backendProjectDir, ".env.offline");
  if (!fs.existsSync(offlineEnvPath)) {
    throw new Error(
      [
        "Missing required backend environment file for desktop packaging.",
        `- ${offlineEnvPath}`,
        "Create `.env.offline` in backend repository, then run `npm run prepare:resources` again.",
      ].join("\n"),
    );
  }
  copyIfExists(offlineEnvPath, path.join(backendOutputDir, ".env"));

  fs.mkdirSync(path.join(backendOutputDir, "data", "image"), { recursive: true });
  fs.mkdirSync(path.join(backendOutputDir, "data", "file"), { recursive: true });
  fs.mkdirSync(path.join(backendOutputDir, "secretKeys"), { recursive: true });
  copyPrismaRuntimeNodeModules(paths.backendProjectDir, backendOutputDir);
}

function normalizeBackendRuntimeLayout(targetResourcesRootDir: string): void {
  const backendOutputDir = path.join(targetResourcesRootDir, "backend");
  const legacyViewsDir = path.join(backendOutputDir, "src", "views");
  const runtimeViewsDir = path.join(backendOutputDir, "views");
  const legacyOfflineEnv = path.join(backendOutputDir, ".env.offline");
  const runtimeEnvPath = path.join(backendOutputDir, ".env");

  if (!fs.existsSync(runtimeViewsDir) && fs.existsSync(legacyViewsDir)) {
    fs.mkdirSync(path.dirname(runtimeViewsDir), { recursive: true });
    fs.cpSync(legacyViewsDir, runtimeViewsDir, { recursive: true });
  }

  fs.rmSync(path.join(backendOutputDir, "src"), { recursive: true, force: true });
  normalizePrismaRuntimeNodeModules(targetResourcesRootDir);

  if (!fs.existsSync(runtimeEnvPath) && fs.existsSync(legacyOfflineEnv)) {
    fs.cpSync(legacyOfflineEnv, runtimeEnvPath, { force: true });
  }

  const backendRootEntries = fs.readdirSync(backendOutputDir, { withFileTypes: true });
  for (const entry of backendRootEntries) {
    if (!entry.isFile() || !entry.name.startsWith(".env") || entry.name === ".env") {
      continue;
    }

    fs.rmSync(path.join(backendOutputDir, entry.name), { force: true });
  }

  if (!fs.existsSync(runtimeViewsDir)) {
    throw new Error(
      `Backend runtime views directory is missing: ${runtimeViewsDir}. Ensure templates are available before packaging.`,
    );
  }
}

function copyFrontendResources(paths: PrepareResourcesPaths, targetResourcesRootDir: string): void {
  const frontendOutputDir = path.join(targetResourcesRootDir, "frontend");
  fs.mkdirSync(frontendOutputDir, { recursive: true });

  const staticDir = resolveFrontendStaticDir(paths.frontendProjectDir);
  const staticDirName = path.basename(staticDir);

  copyIfExists(staticDir, path.join(frontendOutputDir, staticDirName));
}

function assertBackendBundleExists(
  paths: PrepareResourcesPaths,
  targetResourcesRootDir: string,
): void {
  const bundledEntryPath = path.join(targetResourcesRootDir, "backend", paths.backendBundleFile);
  if (!fs.existsSync(bundledEntryPath)) {
    throw new Error(`Backend bundled entry was not found: ${bundledEntryPath}`);
  }
}

export function reuseExistingResourcesInPlace(paths: PrepareResourcesPaths): void {
  if (
    !directoryExists(paths.existingBackendResourcesDir) ||
    !directoryExists(paths.existingFrontendResourcesDir)
  ) {
    throw new Error(
      `Cannot reuse build-resources in place because backend/frontend folders are missing under ${paths.resourcesDir}.`,
    );
  }

  normalizeBackendRuntimeLayout(paths.resourcesDir);
  assertBackendBundleExists(paths, paths.resourcesDir);
  pruneBackendBuildArtifacts(paths.resourcesDir);
  pruneFrontendBuildArtifacts(paths.resourcesDir);
}

export function copyBuildResources(
  paths: PrepareResourcesPaths,
  freshBuildSelection: FreshBuildSelection,
): void {
  fs.rmSync(paths.tempResourcesDir, { recursive: true, force: true });
  fs.mkdirSync(paths.tempResourcesDir, { recursive: true });

  if (freshBuildSelection.backend) {
    copyBackendResources(paths, paths.tempResourcesDir);
  } else {
    copyIfExists(paths.existingBackendResourcesDir, path.join(paths.tempResourcesDir, "backend"));
  }

  normalizeBackendRuntimeLayout(paths.tempResourcesDir);
  assertBackendBundleExists(paths, paths.tempResourcesDir);

  if (freshBuildSelection.frontend) {
    copyFrontendResources(paths, paths.tempResourcesDir);
  } else {
    copyIfExists(paths.existingFrontendResourcesDir, path.join(paths.tempResourcesDir, "frontend"));
  }

  pruneBackendBuildArtifacts(paths.tempResourcesDir);
  pruneFrontendBuildArtifacts(paths.tempResourcesDir);

  fs.rmSync(paths.resourcesDir, { recursive: true, force: true });
  fs.renameSync(paths.tempResourcesDir, paths.resourcesDir);
}
