import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { createInterface } from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import crossSpawn from "cross-spawn";

const rootDir = path.resolve(__dirname, "..");
const npmBin = process.platform === "win32" ? "npm.cmd" : "npm";

const c = {
  reset: "\x1b[0m",
  bold: (s: string) => `\x1b[1m${s}\x1b[0m`,
  dim: (s: string) => `\x1b[2m${s}\x1b[0m`,
  cyan: (s: string) => `\x1b[36m${s}\x1b[0m`,
  green: (s: string) => `\x1b[32m${s}\x1b[0m`,
  yellow: (s: string) => `\x1b[33m${s}\x1b[0m`,
  red: (s: string) => `\x1b[31m${s}\x1b[0m`,
  step: (s: string) => `\x1b[36m→ ${s}\x1b[0m`,
  success: (s: string) => `\x1b[32m✔ ${s}\x1b[0m`,
  warn: (s: string) => `\x1b[33m⚠ ${s}\x1b[0m`,
  error: (s: string) => `\x1b[31m✖ ${s}\x1b[0m`,
};

interface ParsedArgs {
  yes: boolean;
}

function parseArgs(argv: string[]): ParsedArgs {
  let yes = false;

  for (const arg of argv) {
    if (arg === "--yes") {
      yes = true;
    }
  }

  return { yes };
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

function compareVersions(a: string, b: string): number {
  const parse = (v: string) => v.split(".").map(Number);
  const [aMajor = 0, aMinor = 0, aPatch = 0] = parse(a);
  const [bMajor = 0, bMinor = 0, bPatch = 0] = parse(b);
  if (aMajor !== bMajor) return aMajor - bMajor;
  if (aMinor !== bMinor) return aMinor - bMinor;
  return aPatch - bPatch;
}

/** Returns the highest semver release tag on origin, or null if none exist yet. */
function getLatestRemoteVersion(): string | null {
  const result = runGit(["ls-remote", "--tags", "origin"]);
  if (result.status !== 0) {
    throw new Error(`Unable to query remote tags.\n${result.stderr || result.stdout}`.trim());
  }

  const semverPattern = /refs\/tags\/(v?(\d+\.\d+\.\d+))$/;
  const versions: string[] = [];

  for (const line of result.stdout.trim().split("\n")) {
    const match = semverPattern.exec(line);
    if (match) {
      versions.push(match[2]); // bare x.y.z
    }
  }

  if (versions.length === 0) {
    return null;
  }

  return versions.sort((a, b) => compareVersions(b, a))[0];
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
  const archivePath = "build-resources/resources.zip";
  const absoluteArchivePath = path.join(rootDir, archivePath);
  if (!fs.existsSync(absoluteArchivePath)) {
    throw new Error(
      [
        "Prepared resources archive is missing.",
        "Run `npm run prepare:resources` to generate build-resources/resources.zip.",
      ].join("\n"),
    );
  }

  const ignoredResult = runGit(["check-ignore", "-q", archivePath]);
  if (ignoredResult.status === 0) {
    throw new Error(
      [
        "`build-resources/resources.zip` is git-ignored, so CI will not receive prepared artifacts.",
        "Unignore that file in `.gitignore` and commit it before release.",
      ].join("\n"),
    );
  }

  const trackedArchiveResult = runGit(["ls-files", "--error-unmatch", archivePath]);

  if (trackedArchiveResult.status !== 0) {
    throw new Error(
      [
        "Prepared resources archive is not committed yet.",
        "Commit `build-resources/resources.zip` before running `build:prod` release.",
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

async function run(): Promise<void> {
  const parsedArgs = parseArgs(process.argv.slice(2));

  console.log(c.step("Preparing build resources (`npm run prepare:resources`)..."));
  await runCommand("prepare-resources", npmBin, ["run", "prepare:resources"]);

  console.log(c.step("Running local production build check (`npm run build`)..."));
  await runCommand("local-prod-build", npmBin, ["run", "build"]);
  console.log(c.success("Local production build passed."));

  const shouldRelease =
    parsedArgs.yes ||
    (await askYesNo(c.cyan("Do you want to trigger GitHub release build now? (y/N): ")));

  if (!shouldRelease) {
    console.log(c.warn("Release cancelled. Local build artifacts are available in `dist/`."));
    return;
  }

  validateGitRepo();
  assertReleaseResourcesCommitted();
  assertWorkTreeClean();
  const currentBranch = getCurrentBranch();

  const packageVersion = getPackageVersion();
  const tag = `v${packageVersion}`;

  console.log(c.step("Checking latest release on origin..."));
  const latestRemoteVersion = getLatestRemoteVersion();

  if (latestRemoteVersion === null) {
    console.log(c.warn("No previous releases found. Proceeding with first release."));
  } else {
    console.log(c.dim(`Latest release: v${latestRemoteVersion}`));
  }

  if (latestRemoteVersion !== null && compareVersions(packageVersion, latestRemoteVersion) <= 0) {
    throw new Error(
      [
        `package.json version "${packageVersion}" must be greater than the latest release "${latestRemoteVersion}".`,
        `Update the version in package.json before pushing to release.`,
      ].join("\n"),
    );
  }

  console.log(c.bold(c.green(`Releasing version: ${tag}`)));

  console.log(c.step(`Pushing current branch "${currentBranch}" to origin...`));
  await runCommand("git-push-branch", "git", ["push", "origin", currentBranch]);

  if (localTagExists(tag) || remoteTagExists(tag)) {
    throw new Error(
      `Tag "${tag}" already exists. Update the version in package.json before pushing to release.`,
    );
  }

  await runCommand("git-tag", "git", ["tag", tag]);
  await runCommand("git-push-tag", "git", ["push", "origin", tag]);

  console.log(
    c.success(
      `Branch "${currentBranch}" and tag "${tag}" pushed. GitHub Actions will build Windows artifacts and publish the release.`,
    ),
  );
}

void run().catch((error) => {
  console.error(c.error(error instanceof Error ? error.message : String(error)));
  process.exit(1);
});
