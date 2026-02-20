import fs from "node:fs";
import { createInterface } from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import {
  type ResourcesArchiveLayout,
  extractResourcesArchive,
  resourcesFoldersExist,
} from "./resources-archive";

function archiveExists(layout: ResourcesArchiveLayout): boolean {
  return fs.existsSync(layout.archivePath) && fs.statSync(layout.archivePath).isFile();
}

async function askReplaceExistingFolders(): Promise<boolean> {
  const rl = createInterface({ input, output });

  try {
    const answer = (
      await rl.question(
        "Prepared backend/frontend folders already exist. Unzip resources.zip and replace them? (y/N): ",
      )
    )
      .trim()
      .toLowerCase();

    return answer === "y" || answer === "yes";
  } finally {
    rl.close();
  }
}

export async function ensureResourcesAvailableForBuild(
  layout: ResourcesArchiveLayout,
): Promise<void> {
  const hasArchive = archiveExists(layout);
  const hasFolders = resourcesFoldersExist(layout);

  if (!hasArchive) {
    throw new Error(
      [
        "Missing prepared resources archive.",
        "Run `npm run prepare:resources` first, then retry `npm run build`.",
        `Expected archive: ${layout.archivePath}`,
      ].join("\n"),
    );
  }

  if (!hasFolders) {
    extractResourcesArchive(layout, { replaceExisting: true });
    console.log("Extracted build-resources/resources.zip for packaging.");
    return;
  }

  if (!input.isTTY || !output.isTTY) {
    console.warn(
      "Frontend/backend resource folders already exist and terminal is non-interactive; using existing folders.",
    );
    return;
  }

  const shouldReplace = await askReplaceExistingFolders();
  if (!shouldReplace) {
    console.log("Using existing build-resources/frontend and build-resources/backend folders.");
    return;
  }

  extractResourcesArchive(layout, { replaceExisting: true });
  console.log("Replaced resource folders from build-resources/resources.zip.");
}
