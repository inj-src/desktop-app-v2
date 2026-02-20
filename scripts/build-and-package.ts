import path from "node:path";
import fs from "node:fs";
import { spawnSync } from "node:child_process";
import crypto from "node:crypto";
import crossSpawn from "cross-spawn";

const rootDir = path.resolve(__dirname, "..");
const resourcesRootDir = path.join(rootDir, "build-resources");
const backendResourcesDir = path.join(resourcesRootDir, "backend");
const frontendResourcesDir = path.join(resourcesRootDir, "frontend");
const backendSecretKeysDir = path.join(backendResourcesDir, "secretKeys");

function buildSpawnEnv(): NodeJS.ProcessEnv {
  // On Windows + Git Bash, inherited env can include invalid keys for CreateProcess
  // (for example exported shell-function variables). Filter those out to avoid EINVAL.
  const nextEnv: NodeJS.ProcessEnv = {};
  for (const [key, value] of Object.entries(process.env)) {
    if (typeof value !== "string") {
      continue;
    }

    if (!key || key.includes("=") || key.includes("\0") || value.includes("\0")) {
      continue;
    }

    nextEnv[key] = value;
  }

  return nextEnv;
}

function assertPreparedResources(): void {
  if (
    fs.existsSync(resourcesRootDir) &&
    fs.statSync(resourcesRootDir).isDirectory() &&
    fs.existsSync(backendResourcesDir) &&
    fs.statSync(backendResourcesDir).isDirectory() &&
    fs.existsSync(frontendResourcesDir) &&
    fs.statSync(frontendResourcesDir).isDirectory()
  ) {
    return;
  }

  throw new Error(
    [
      "Missing prepared build resources.",
      "Run `npm run prepare:resources` first, then retry `npm run build`.",
      `Expected folder: ${resourcesRootDir}`,
    ].join("\n"),
  );
}

function ensureBackendSecretKeysPrepared(): void {
  fs.mkdirSync(backendSecretKeysDir, { recursive: true });

  const tokenPublicKeyPath = path.join(backendSecretKeysDir, "tokenECPublic.pem");
  const tokenPrivateKeyPath = path.join(backendSecretKeysDir, "tokenECPrivate.pem");

  if (!fs.existsSync(tokenPublicKeyPath) || !fs.existsSync(tokenPrivateKeyPath)) {
    const tokenKey = crypto.generateKeyPairSync("rsa", {
      modulusLength: 4096,
      publicKeyEncoding: { type: "spki", format: "pem" },
      privateKeyEncoding: { type: "pkcs8", format: "pem" },
    });

    fs.writeFileSync(tokenPublicKeyPath, tokenKey.publicKey, "utf8");
    fs.writeFileSync(tokenPrivateKeyPath, tokenKey.privateKey, "utf8");
    console.warn(
      "[warning] Generated missing token key pair in build-resources/backend/secretKeys.",
    );
  }

  for (const fileName of ["pharmacyPublicKey.pem", "prescriptionPublicKey.pem"]) {
    const filePath = path.join(backendSecretKeysDir, fileName);
    if (!fs.existsSync(filePath)) {
      throw new Error(
        [
          `Missing required backend public key: ${filePath}`,
          "Add this key into build-resources/backend/secretKeys and rebuild.",
          "Tip: run npm run prepare:resources on a machine with the backend secretKeys available.",
        ].join("\n"),
      );
    }
  }
}

function runNpm(label: string, args: string[]): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = crossSpawn("npm", args, {
      cwd: rootDir,
      env: buildSpawnEnv(),
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

function parseGitHubRepoFromRemoteUrl(value: string): { owner: string; repo: string } | null {
  const trimmed = value.trim();
  if (!trimmed) {
    return null;
  }

  const withoutGit = trimmed.endsWith(".git") ? trimmed.slice(0, -4) : trimmed;
  const match = withoutGit.match(/github\.com[/:]([^/]+)\/([^/]+)$/i);
  if (!match) {
    return null;
  }

  return { owner: match[1], repo: match[2] };
}

function ensureReleaseEnvFallbacks(): void {
  const hasOwner = Boolean((process.env.GH_RELEASE_OWNER || "").trim());
  const hasRepo = Boolean((process.env.GH_RELEASE_REPO || "").trim());

  if (hasOwner && hasRepo) {
    return;
  }

  const remoteResult = spawnSync("git", ["config", "--get", "remote.origin.url"], {
    cwd: rootDir,
    env: process.env,
    encoding: "utf8",
  });

  if (remoteResult.status === 0) {
    const parsed = parseGitHubRepoFromRemoteUrl(remoteResult.stdout || "");
    if (parsed) {
      process.env.GH_RELEASE_OWNER = process.env.GH_RELEASE_OWNER || parsed.owner;
      process.env.GH_RELEASE_REPO = process.env.GH_RELEASE_REPO || parsed.repo;
      return;
    }
  }

  process.env.GH_RELEASE_OWNER = process.env.GH_RELEASE_OWNER || "local";
  process.env.GH_RELEASE_REPO = process.env.GH_RELEASE_REPO || "local";
}

async function run(): Promise<void> {
  const cliArgs = process.argv.slice(2);
  const dirMode = cliArgs.includes("--dir");
  const extraBuilderArgs = cliArgs.filter((arg) => arg !== "--dir");

  assertPreparedResources();
  ensureBackendSecretKeysPrepared();
  ensureReleaseEnvFallbacks();
  await runNpm("desktop-compile", ["run", "compile"]);

  const packageArgs = ["run", "package:builder"];
  const builderArgs: string[] = [];

  if (dirMode) {
    builderArgs.push("--dir");
  }

  builderArgs.push(...extraBuilderArgs);

  if (builderArgs.length > 0) {
    packageArgs.push("--", ...builderArgs);
  }

  await runNpm("desktop-package", packageArgs);

  console.warn(
    [
      "",
      "[warning] Build completed using existing `build-resources` only.",
      "[warning] Backend/frontend may be out of date because this command does not rebuild those repositories.",
      "[warning] Run `npm run prepare:resources` before build when you need fresh artifacts.",
    ].join("\n"),
  );
}

void run().catch((error) => {
  console.error(error);
  process.exit(1);
});
