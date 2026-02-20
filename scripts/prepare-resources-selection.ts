import readline from 'node:readline';
import { stdin as input, stdout as output } from 'node:process';
import type { FreshBuildSelection } from './prepare-resources-utils';
import { paint } from './prepare-resources-utils';

async function askFreshBuildSelection(backendProjectDir: string, frontendProjectDir: string): Promise<FreshBuildSelection> {
  type Key = keyof FreshBuildSelection;
  const optionOrder: Key[] = ['backend', 'frontend'];
  const selected: FreshBuildSelection = { backend: true, frontend: true };
  let cursorIndex = 0;
  let initialized = false;
  const lineCount = 7;

  const render = () => {
    if (initialized) {
      for (let index = 0; index < lineCount; index += 1) {
        readline.moveCursor(output, 0, -1);
        readline.clearLine(output, 0);
      }
    } else {
      output.write('\n'.repeat(lineCount));
      initialized = true;
    }

    output.write(`${paint('Select fresh builds (Space to toggle, Enter to confirm)', 'bold')}\n`);

    for (let index = 0; index < optionOrder.length; index += 1) {
      const key = optionOrder[index];
      const checked = selected[key];
      const focused = index === cursorIndex;
      const checkbox = checked ? paint('[x]', 'green') : '[ ]';
      const prefix = focused ? paint('>', 'cyan') : ' ';
      const label = key === 'backend' ? 'Backend' : 'Frontend';
      const projectPath = key === 'backend' ? backendProjectDir : frontendProjectDir;
      const text = focused ? paint(label, 'cyan') : label;
      output.write(`${prefix} ${checkbox} ${text} ${paint(`(${projectPath})`, 'dim')}\n`);
    }

    output.write('\n');
    output.write(`${paint('Tip:', 'yellow')} Uncheck both to reuse existing resources only.\n`);
    output.write(`${paint('Controls:', 'dim')} ↑/↓ move, Space toggle, Enter confirm, Ctrl+C cancel\n`);
    output.write('\n');
  };

  return new Promise((resolve, reject) => {
    readline.emitKeypressEvents(input);
    input.resume();

    let cleanedUp = false;

    const restoreTerminal = () => {
      if (!input.isTTY) {
        return;
      }

      try {
        input.setRawMode(false);
      } catch {
        // best effort
      }
    };

    if (input.isTTY) {
      input.setRawMode(true);
    }

    const onProcessExit = () => {
      restoreTerminal();
    };
    process.once('exit', onProcessExit);

    const cleanup = () => {
      if (cleanedUp) {
        return;
      }

      cleanedUp = true;
      input.off('keypress', onKeyPress);
      process.off('exit', onProcessExit);
      restoreTerminal();
      input.pause();
    };

    const finish = () => {
      cleanup();
      output.write('\n');
      resolve(selected);
    };

    const onKeyPress = (_char: string, key: readline.Key) => {
      if (key.ctrl && key.name === 'c') {
        cleanup();
        output.write('\n');
        reject(new Error('Selection cancelled by user.'));
        return;
      }

      if (key.name === 'up') {
        cursorIndex = (cursorIndex - 1 + optionOrder.length) % optionOrder.length;
        render();
        return;
      }

      if (key.name === 'down') {
        cursorIndex = (cursorIndex + 1) % optionOrder.length;
        render();
        return;
      }

      if (key.name === 'space') {
        const keyName = optionOrder[cursorIndex];
        selected[keyName] = !selected[keyName];
        render();
        return;
      }

      if (key.name === 'return' || key.name === 'enter') {
        finish();
      }
    };

    input.on('keypress', onKeyPress);
    render();
  });
}

export async function resolveFreshBuildSelection(
  hasBackendResources: boolean,
  hasFrontendResources: boolean,
  backendProjectDir: string,
  frontendProjectDir: string
): Promise<FreshBuildSelection> {
  const canPrompt = hasBackendResources && hasFrontendResources && input.isTTY && output.isTTY;

  if (!canPrompt) {
    if (!hasBackendResources || !hasFrontendResources) {
      console.log(
        paint('Missing existing build-resources for backend/frontend. Running a fresh build for both.', 'yellow')
      );
      return { backend: true, frontend: true };
    }

    console.log(paint('Non-interactive terminal detected. Reusing existing backend/frontend builds.', 'yellow'));
    return { backend: false, frontend: false };
  }

  return askFreshBuildSelection(backendProjectDir, frontendProjectDir);
}
