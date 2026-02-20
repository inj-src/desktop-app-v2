import fs from "node:fs";
import path from "node:path";
import AdmZip from "adm-zip";

export interface ResourcesArchiveLayout {
  resourcesRootDir: string;
  backendResourcesDir: string;
  frontendResourcesDir: string;
  archivePath: string;
}

export function resolveResourcesArchiveLayout(rootDir: string): ResourcesArchiveLayout {
  const resourcesRootDir = path.join(rootDir, "build-resources");
  return {
    resourcesRootDir,
    backendResourcesDir: path.join(resourcesRootDir, "backend"),
    frontendResourcesDir: path.join(resourcesRootDir, "frontend"),
    archivePath: path.join(resourcesRootDir, "resources.zip"),
  };
}

function isExistingDirectory(dirPath: string): boolean {
  return fs.existsSync(dirPath) && fs.statSync(dirPath).isDirectory();
}

export function resourcesFoldersExist(layout: ResourcesArchiveLayout): boolean {
  return (
    isExistingDirectory(layout.backendResourcesDir) && isExistingDirectory(layout.frontendResourcesDir)
  );
}

function assertArchiveExists(layout: ResourcesArchiveLayout): void {
  if (fs.existsSync(layout.archivePath) && fs.statSync(layout.archivePath).isFile()) {
    return;
  }

  throw new Error(
    [
      "Missing prepared resources archive.",
      "Run `npm run prepare:resources` first, then retry `npm run build`.",
      `Expected archive: ${layout.archivePath}`,
    ].join("\n"),
  );
}

export function createResourcesArchive(layout: ResourcesArchiveLayout): void {
  if (!resourcesFoldersExist(layout)) {
    throw new Error(
      [
        "Cannot create resources archive because backend/frontend folders are missing.",
        `Expected folder: ${layout.backendResourcesDir}`,
        `Expected folder: ${layout.frontendResourcesDir}`,
      ].join("\n"),
    );
  }

  fs.mkdirSync(layout.resourcesRootDir, { recursive: true });

  const zip = new AdmZip();
  zip.addLocalFolder(layout.backendResourcesDir, "backend");
  zip.addLocalFolder(layout.frontendResourcesDir, "frontend");

  const buildMetaPath = path.join(layout.resourcesRootDir, "build-meta.json");
  if (fs.existsSync(buildMetaPath) && fs.statSync(buildMetaPath).isFile()) {
    zip.addLocalFile(buildMetaPath, "", "build-meta.json");
  }

  zip.writeZip(layout.archivePath);
}

export function extractResourcesArchive(
  layout: ResourcesArchiveLayout,
  options?: { replaceExisting?: boolean },
): void {
  assertArchiveExists(layout);

  if (options?.replaceExisting) {
    fs.rmSync(layout.backendResourcesDir, { recursive: true, force: true });
    fs.rmSync(layout.frontendResourcesDir, { recursive: true, force: true });
  }

  fs.mkdirSync(layout.resourcesRootDir, { recursive: true });

  const zip = new AdmZip(layout.archivePath);
  zip.extractAllTo(layout.resourcesRootDir, true);

  if (!resourcesFoldersExist(layout)) {
    throw new Error(
      [
        "Archive extraction did not produce required backend/frontend folders.",
        `Archive: ${layout.archivePath}`,
        `Expected folder: ${layout.backendResourcesDir}`,
        `Expected folder: ${layout.frontendResourcesDir}`,
      ].join("\n"),
    );
  }
}
