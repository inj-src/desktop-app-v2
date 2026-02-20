import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";

export interface RuntimePathContext {
  appRootDir: string;
  isPackaged: boolean;
}

export const BACKEND_BUNDLE_FILE = "sasthotech-hospital-backend-v1.cjs";

function resolveBuildResourcesDir(context: RuntimePathContext): string {
  if (context.isPackaged) {
    return context.appRootDir;
  }

  const buildResourcesDir = path.join(context.appRootDir, "build-resources");
  if (!fs.existsSync(buildResourcesDir) || !fs.statSync(buildResourcesDir).isDirectory()) {
    throw new Error(
      `Missing build resources directory: ${buildResourcesDir}. Run npm run prepare:resources and restart the app.`,
    );
  }

  return buildResourcesDir;
}

export function resolveBackendDir(context: RuntimePathContext): string {
  const baseDir = resolveBuildResourcesDir(context);
  return path.join(baseDir, "backend");
}

export function resolveBackendEntry(context: RuntimePathContext): string {
  return path.join(resolveBackendDir(context), BACKEND_BUNDLE_FILE);
}

export function resolveFrontendRootDir(context: RuntimePathContext): string {
  const baseDir = resolveBuildResourcesDir(context);
  return path.join(baseDir, "frontend");
}

export function resolveFrontendStaticDir(context: RuntimePathContext): string {
  const root = resolveFrontendRootDir(context);
  const outputDir = path.join(root, "output");
  const outDir = path.join(root, "out");

  if (fs.existsSync(outputDir) && fs.statSync(outputDir).isDirectory()) {
    return outputDir;
  }

  if (fs.existsSync(outDir) && fs.statSync(outDir).isDirectory()) {
    return outDir;
  }

  throw new Error(
    `Unable to find static frontend directory in build resources. Checked: ${outputDir} and ${outDir}. Run npm run prepare:resources and restart the app.`,
  );
}

export function resolveAppIconPath(context: RuntimePathContext): string {
  if (context.isPackaged) {
    return path.join(context.appRootDir, "assets", "icon.ico");
  }

  return path.resolve(context.appRootDir, "assets", "icon.ico");
}

export function ensureBackendRuntimeDirectories(backendDir: string): void {
  const neededDirs = [
    path.join(backendDir, "data", "image"),
    path.join(backendDir, "data", "file"),
    path.join(backendDir, "secretKeys"),
  ];

  for (const dirPath of neededDirs) {
    fs.mkdirSync(dirPath, { recursive: true });
  }

  const secretKeysDir = path.join(backendDir, "secretKeys");
  const tokenPublicKeyPath = path.join(secretKeysDir, "tokenECPublic.pem");
  const tokenPrivateKeyPath = path.join(secretKeysDir, "tokenECPrivate.pem");

  if (!fs.existsSync(tokenPublicKeyPath) || !fs.existsSync(tokenPrivateKeyPath)) {
    const tokenKey = crypto.generateKeyPairSync("rsa", {
      modulusLength: 4096,
      publicKeyEncoding: { type: "spki", format: "pem" },
      privateKeyEncoding: { type: "pkcs8", format: "pem" },
    });

    fs.writeFileSync(tokenPublicKeyPath, tokenKey.publicKey, "utf8");
    fs.writeFileSync(tokenPrivateKeyPath, tokenKey.privateKey, "utf8");
  }

  const requiredPublicKeys = ["pharmacyPublicKey.pem", "prescriptionPublicKey.pem"];
  for (const fileName of requiredPublicKeys) {
    const filePath = path.join(secretKeysDir, fileName);
    if (!fs.existsSync(filePath)) {
      throw new Error(
        `Missing backend key file: ${filePath}. Rebuild with complete build-resources (run npm run prepare:resources).`,
      );
    }
  }
}

export function buildPrismaRuntimeEnv(_backendDir: string): Record<string, string> {
  // Rust-free Prisma (engineType="client") does not require engine binary path overrides.
  return {};
}
