import fs from 'node:fs';
import path from 'node:path';

const rootDir = path.resolve(__dirname, '..');
const targets = ['build'];

for (const target of targets) {
  fs.rmSync(path.join(rootDir, target), { recursive: true, force: true });
}
