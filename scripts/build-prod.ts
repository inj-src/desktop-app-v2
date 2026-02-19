import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { createInterface } from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import crossSpawn from "cross-spawn";

const rootDir = path.resolve(__dirname, "..");
const npmBin = process.platform === "win32" ? "npm.cmd" : "npm";

interface ParsedArgs {
  yes: boolean;
  tag: string | null;
}

function parseArgs(argv: string[]): ParsedArgs {
  let yes = false;
  let tag: string | null = null;

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];

    if (arg === "--yes") {
      yes = true;
      continue;
    }

    if (arg === "--tag") {
      const value = argv[index + 1];
      if (!value) {
        throw new Error("--tag requires a value");
      }

      tag = value.trim();
      index += 1;
      continue;
    }
  }

  return { yes, tag };
}

function runCommand(label: string, command: string, args: string[], cwd = rootDir): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = crossSpawn(command, args, {
      cwd,
      env: process.env,
      stdio: "inherit",
    });

    child.on("error", reject);
    child.on("close", (code) => {
      if (code === 0) {
        resolve();
        return;
      }

      reject(new Error(`${label} failed with exit code ${code}`));
    });
  });
}

function runGit(args: string[], cwd = rootDir): { status: number; stdout: string; stderr: string } {
  const result = spawnSync("git", args, {
    cwd,
    env: process.env,
    encoding: "utf8",
  });

  return {
    status: result.status ?? 1,
    stdout: result.stdout || "",
    stderr: result.stderr || "",
  };
}

function getPackageVersion(): string {
  const packagePath = path.join(rootDir, "package.json");
  const parsed = JSON.parse(fs.readFileSync(packagePath, "utf8")) as { version?: string };
  const version = parsed.version?.trim();
  if (!version) {
    throw new Error("Unable to resolve version from package.json");
  }

  return version;
}

function normalizeTag(inputTag: string): string {
  const tag = inputTag.trim();
  if (!tag) {
    throw new Error("Release tag cannot be empty");
  }

  if (!tag.startsWith("v")) {
    throw new Error(`Release tag must start with "v". Received "${tag}"`);
  }

  return tag;
}

function localTagExists(tag: string): boolean {
  const result = runGit(["show-ref", "--tags", "--verify", `refs/tags/${tag}`]);
  return result.status === 0;
}

function remoteTagExists(tag: string): boolean {
  const result = runGit(["ls-remote", "--tags", "origin", `refs/tags/${tag}`]);
  if (result.status !== 0) {
    throw new Error(`Unable to query remote tags.\n${result.stderr || result.stdout}`.trim());
  }

  return result.stdout.trim().length > 0;
}

function validateGitRepo(): void {
  const insideWorkTree = runGit(["rev-parse", "--is-inside-work-tree"]);
  if (insideWorkTree.status !== 0 || insideWorkTree.stdout.trim() !== "true") {
    throw new Error("Current directory is not a git repository.");
  }
}

function getCurrentBranch(): string {
  const branchResult = runGit(["rev-parse", "--abbrev-ref", "HEAD"]);
  if (branchResult.status !== 0) {
    throw new Error(
      `Unable to determine current git branch.\n${branchResult.stderr || branchResult.stdout}`.trim(),
    );
  }

  const branch = branchResult.stdout.trim();
  if (!branch || branch === "HEAD") {
    throw new Error("Detached HEAD is not supported for build:prod. Checkout a branch first.");
  }

  return branch;
}

function assertWorkTreeClean(): void {
  const statusResult = runGit(["status", "--porcelain"]);
  if (statusResult.status !== 0) {
    throw new Error(
      `Unable to read git status.\n${statusResult.stderr || statusResult.stdout}`.trim(),
    );
  }

  if (statusResult.stdout.trim().length > 0) {
    throw new Error(
      "Working tree has uncommitted changes. Commit and push your changes first, then run `npm run build:prod` again.",
    );
  }
}

function assertReleaseResourcesCommitted(): void {
  const ignoredResult = runGit(["check-ignore", "-q", "build-resources"]);
  if (ignoredResult.status === 0) {
    throw new Error(
      [
        "`build-resources` is git-ignored, so CI will not receive prepared artifacts.",
        "Remove it from `.gitignore` or force-add the required files before release.",
      ].join("\n"),
    );
  }

  const trackedBackendResult = runGit(["ls-files", "--error-unmatch", "build-resources/backend"]);
  const trackedFrontendResult = runGit(["ls-files", "--error-unmatch", "build-resources/frontend"]);

  if (trackedBackendResult.status !== 0 || trackedFrontendResult.status !== 0) {
    throw new Error(
      [
        "Prepared resources are not committed yet.",
        "Commit `build-resources/backend` and `build-resources/frontend` before running `build:prod` release.",
      ].join("\n"),
    );
  }
}

async function askYesNo(question: string): Promise<boolean> {
  const rl = createInterface({ input, output });
  try {
    const answer = (await rl.question(question)).trim().toLowerCase();
    return answer === "y" || answer === "yes";
  } finally {
    rl.close();
  }
}

async function askTag(defaultTag: string): Promise<string> {
  const rl = createInterface({ input, output });
  try {
    const answer = (await rl.question(`Release tag [${defaultTag}]: `)).trim();
    if (!answer) {
      return defaultTag;
    }

    return answer;
  } finally {
    rl.close();
  }
}

async function run(): Promise<void> {
  const parsedArgs = parseArgs(process.argv.slice(2));

  console.log("Preparing build resources (`npm run prepare:resources`)...");
  await runCommand("prepare-resources", npmBin, ["run", "prepare:resources"]);

  console.log("Running local production build check (`npm run build`)...");
  await runCommand("local-prod-build", npmBin, ["run", "build"]);
  console.log("Local production build passed.");

  const shouldRelease =
    parsedArgs.yes || (await askYesNo("Do you want to trigger GitHub release build now? (y/N): "));

  if (!shouldRelease) {
    console.log("Release cancelled. Local build artifacts are available in `dist/`.");
    return;
  }

  validateGitRepo();
  assertReleaseResourcesCommitted();
  assertWorkTreeClean();
  const currentBranch = getCurrentBranch();

  console.log(`Pushing current branch "${currentBranch}" to origin...`);
  await runCommand("git-push-branch", "git", ["push", "origin", currentBranch]);

  let candidateTag = parsedArgs.tag || `v${getPackageVersion()}`;

  if (!parsedArgs.tag) {
    candidateTag = await askTag(candidateTag);
  }

  const tag = normalizeTag(candidateTag);

  if (localTagExists(tag) || remoteTagExists(tag)) {
    throw new Error(
      `Tag "${tag}" already exists locally or on origin. Use a new version tag (for example: --tag v1.0.1).`,
    );
  }

  await runCommand("git-tag", "git", ["tag", tag]);
  await runCommand("git-push-tag", "git", ["push", "origin", tag]);

  console.log(
    `Branch ${currentBranch} and tag ${tag} pushed. GitHub Actions will build Windows artifacts and publish the release.`,
  );
}

void run().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exit(1);
});
