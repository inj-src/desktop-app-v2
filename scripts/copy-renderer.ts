import fs from 'node:fs';
import path from 'node:path';
import ts from 'typescript';

const sourceDir = path.resolve(__dirname, '../src/renderer');
const targetDir = path.resolve(__dirname, '../build/renderer');
const rendererEntryTs = path.join(sourceDir, 'app.ts');
const rendererEntryJs = path.join(targetDir, 'app.js');

function copyDirectory(src: string, dest: string): void {
  fs.mkdirSync(dest, { recursive: true });

  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const sourcePath = path.join(src, entry.name);
    const targetPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDirectory(sourcePath, targetPath);
      continue;
    }

    if (entry.name.endsWith('.ts')) {
      continue;
    }

    fs.copyFileSync(sourcePath, targetPath);
  }
}

copyDirectory(sourceDir, targetDir);

const rendererCode = fs.readFileSync(rendererEntryTs, 'utf8');
const transpiled = ts.transpileModule(rendererCode, {
  compilerOptions: {
    target: ts.ScriptTarget.ES2022,
    module: ts.ModuleKind.ES2022,
  },
  fileName: rendererEntryTs,
  reportDiagnostics: true,
});

if (transpiled.diagnostics && transpiled.diagnostics.length > 0) {
  const errors = transpiled.diagnostics
    .map(diagnostic => ts.flattenDiagnosticMessageText(diagnostic.messageText, '\n'))
    .join('\n');
  throw new Error(`Renderer transpile failed:\n${errors}`);
}

fs.writeFileSync(rendererEntryJs, transpiled.outputText, 'utf8');
