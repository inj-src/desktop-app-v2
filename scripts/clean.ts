import fs from "node:fs";
import path from "node:path";

const rootDir = path.resolve(__dirname, "..");
// Keep build-resources so `npm run build` can package pre-prepared artifacts.
const targets = ["build", "dist"];

for (const target of targets) {
  fs.rmSync(path.join(rootDir, target), { recursive: true, force: true });
}
