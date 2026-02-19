import path from 'node:path';
import { spawn } from 'node:child_process';

import { prepareResources } from './prepare-resources';

const rootDir = path.resolve(__dirname, '..');
const npmBin = process.platform === 'win32' ? 'npm.cmd' : 'npm';

function runNpm(label: string, args: string[]): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = spawn(npmBin, args, {
      cwd: rootDir,
      env: process.env,
      stdio: ['ignore', 'pipe', 'pipe'],
    });

    child.stdout.on('data', data => {
      process.stdout.write(`[${label}] ${data}`);
    });

    child.stderr.on('data', data => {
      process.stderr.write(`[${label}] ${data}`);
    });

    child.on('error', reject);

    child.on('close', code => {
      if (code === 0) {
        resolve();
        return;
      }

      reject(new Error(`${label} exited with code ${code}`));
    });
  });
}

async function run(): Promise<void> {
  const dirMode = process.argv.includes('--dir');

  await prepareResources();
  await runNpm('desktop-compile', ['run', 'compile']);

  const packageArgs = ['run', 'package:builder'];
  if (dirMode) {
    packageArgs.push('--', '--dir');
  }

  await runNpm('desktop-package', packageArgs);
}

void run().catch(error => {
  console.error(error);
  process.exit(1);
});
