import type { DesktopState, ProcessLogPayload, ProcessName } from "../types";

const MAX_LOG_LINES = 700;
const LOG_STORAGE_KEY = "sasthotech-desktop-v2-logs";

interface LogStore {
  all: string[];
  backend: string[];
  frontend: string[];
}

interface MainElements {
  mdnsStatus: HTMLParagraphElement | null;
  logs: HTMLPreElement | null;
  clearLogs: HTMLButtonElement | null;
  openFrontend: HTMLButtonElement;
  openDetailsPage: HTMLButtonElement;
  statusBackend: HTMLSpanElement;
  statusFrontend: HTMLSpanElement;
  actionButtons: HTMLButtonElement[];
}

interface DetailsElements {
  mdnsStatus: HTMLParagraphElement;
  backToMain: HTMLButtonElement;
  tabButtons: HTMLButtonElement[];
  detailsTitle: HTMLHeadingElement;
  detailsLogsTitle: HTMLHeadingElement;
  detailsStatus: HTMLDivElement;
  detailsPid: HTMLDivElement;
  detailsPort: HTMLDivElement;
  detailsRestarts: HTMLDivElement;
  detailsLastExit: HTMLDivElement;
  detailsLastSignal: HTMLDivElement;
  detailsLogs: HTMLPreElement;
  clearTabLogs: HTMLButtonElement;
}

let latestState: DesktopState | null = null;
let logStore: LogStore = loadLogStore();
let activeTab: ProcessName = "frontend";

function loadLogStore(): LogStore {
  try {
    const raw = window.localStorage.getItem(LOG_STORAGE_KEY);
    if (!raw) {
      return { all: [], backend: [], frontend: [] };
    }

    const parsed = JSON.parse(raw) as Partial<LogStore>;
    return {
      all: Array.isArray(parsed.all) ? trimLogs(parsed.all.map(String)) : [],
      backend: Array.isArray(parsed.backend) ? trimLogs(parsed.backend.map(String)) : [],
      frontend: Array.isArray(parsed.frontend) ? trimLogs(parsed.frontend.map(String)) : [],
    };
  } catch {
    return { all: [], backend: [], frontend: [] };
  }
}

function saveLogStore(): void {
  window.localStorage.setItem(LOG_STORAGE_KEY, JSON.stringify(logStore));
}

function trimLogs(lines: string[]): string[] {
  if (lines.length <= MAX_LOG_LINES) {
    return lines;
  }

  return lines.slice(lines.length - MAX_LOG_LINES);
}

function statusLabel(value: string | null | undefined): string {
  return value || "unknown";
}

function setStatusClass(el: HTMLSpanElement, status?: string): void {
  el.className = "process-status";
  el.textContent = statusLabel(status);
  if (status) {
    el.classList.add(`status-${status}`);
  }
}

function formatMdns(state: DesktopState): string {
  return state.mdns.running ? `mDNS active: ${state.mdns.ip || "pending IP"}` : `mDNS inactive`;
}

function isProcessName(value: string): value is ProcessName {
  return value === "backend" || value === "frontend";
}

function appendLog(target: string, line: string): void {
  logStore.all = trimLogs([...logStore.all, line]);
  if (isProcessName(target)) {
    logStore[target] = trimLogs([...logStore[target], line]);
  }

  saveLogStore();
}

function clearAllLogs(): void {
  logStore = { all: [], backend: [], frontend: [] };
  saveLogStore();
}

function clearActiveTabLogs(): void {
  logStore[activeTab] = [];
  saveLogStore();
}

function setLogs(pre: HTMLPreElement, lines: string[]): void {
  pre.textContent = lines.join("\n");
  pre.scrollTop = pre.scrollHeight;
}

function requiredElement<T extends HTMLElement>(id: string): T {
  const el = document.getElementById(id);
  if (!el) {
    throw new Error(`Missing renderer element: #${id}`);
  }

  return el as T;
}

function mainElements(): MainElements {
  return {
    mdnsStatus: document.getElementById("mdns-status") as HTMLParagraphElement | null,
    logs: document.getElementById("logs") as HTMLPreElement | null,
    clearLogs: document.getElementById("clear-logs") as HTMLButtonElement | null,
    openFrontend: requiredElement<HTMLButtonElement>("open-frontend"),
    openDetailsPage: requiredElement<HTMLButtonElement>("open-details-page"),
    statusBackend: requiredElement<HTMLSpanElement>("status-backend"),
    statusFrontend: requiredElement<HTMLSpanElement>("status-frontend"),
    actionButtons: Array.from(
      document.querySelectorAll("button[data-action]"),
    ) as HTMLButtonElement[],
  };
}

function detailsElements(): DetailsElements {
  return {
    mdnsStatus: requiredElement<HTMLParagraphElement>("mdns-status"),
    backToMain: requiredElement<HTMLButtonElement>("back-to-main"),
    tabButtons: Array.from(document.querySelectorAll("button[data-tab]")) as HTMLButtonElement[],
    detailsTitle: requiredElement<HTMLHeadingElement>("details-title"),
    detailsLogsTitle: requiredElement<HTMLHeadingElement>("details-logs-title"),
    detailsStatus: requiredElement<HTMLDivElement>("details-status"),
    detailsPid: requiredElement<HTMLDivElement>("details-pid"),
    detailsPort: requiredElement<HTMLDivElement>("details-port"),
    detailsRestarts: requiredElement<HTMLDivElement>("details-restarts"),
    detailsLastExit: requiredElement<HTMLDivElement>("details-last-exit"),
    detailsLastSignal: requiredElement<HTMLDivElement>("details-last-signal"),
    detailsLogs: requiredElement<HTMLPreElement>("details-logs"),
    clearTabLogs: requiredElement<HTMLButtonElement>("clear-tab-logs"),
  };
}

function renderMain(state: DesktopState, elements: MainElements): void {
  latestState = state;
  if (elements.mdnsStatus) {
    elements.mdnsStatus.textContent = formatMdns(state);
  }
  setStatusClass(elements.statusBackend, state.processes.backend.status);
  setStatusClass(elements.statusFrontend, state.processes.frontend.status);
  if (elements.logs) {
    setLogs(elements.logs, logStore.all);
  }
}

function processLabel(name: ProcessName): string {
  return name === "frontend" ? "Frontend" : "Backend";
}

function renderDetails(state: DesktopState, elements: DetailsElements): void {
  latestState = state;
  const process = state.processes[activeTab];
  const label = processLabel(activeTab);

  elements.mdnsStatus.textContent = formatMdns(state);
  elements.detailsTitle.textContent = `${label} Details`;
  elements.detailsLogsTitle.textContent = `${label} Logs`;
  elements.detailsStatus.textContent = statusLabel(process.status);
  elements.detailsPid.textContent = process.pid === null ? "-" : String(process.pid);
  elements.detailsPort.textContent = String(process.port);
  elements.detailsRestarts.textContent = String(process.restarts);
  elements.detailsLastExit.textContent =
    process.lastExitCode === null ? "-" : String(process.lastExitCode);
  elements.detailsLastSignal.textContent = process.lastSignal || "-";

  setLogs(elements.detailsLogs, logStore[activeTab]);
}

function setMainActionsBusy(elements: MainElements, disabled: boolean): void {
  for (const button of elements.actionButtons) {
    button.disabled = disabled;
  }
}

async function runProcessAction(
  action: string | null,
  target: string | null,
  elements: MainElements,
): Promise<void> {
  if (!action || !target) {
    return;
  }

  setMainActionsBusy(elements, true);

  try {
    if (action === "start") {
      await window.desktopApi.startProcess(target as ProcessName | "all");
    } else if (action === "stop") {
      await window.desktopApi.stopProcess(target as ProcessName | "all");
    } else if (action === "restart") {
      await window.desktopApi.restartProcess(target as ProcessName | "all");
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    appendLog("system", `[renderer:error] ${message}`);
  } finally {
    setMainActionsBusy(elements, false);
  }
}

function wireMainPage(elements: MainElements): void {
  for (const button of elements.actionButtons) {
    const action = button.getAttribute("data-action");
    const target = button.getAttribute("data-target");

    button.addEventListener("click", () => {
      void runProcessAction(action, target, elements);
    });
  }

  if (elements.clearLogs) {
    elements.clearLogs.addEventListener("click", () => {
      clearAllLogs();
      if (elements.logs) {
        setLogs(elements.logs, logStore.all);
      }
    });
  }

  elements.openFrontend.addEventListener("click", async () => {
    const networkUrl = latestState?.processes.frontend.networkUrl;
    if (!networkUrl) {
      return;
    }

    try {
      await window.desktopApi.openExternal(networkUrl);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      appendLog("system", `[renderer:error] ${message}`);
    }
  });

  elements.openDetailsPage.addEventListener("click", () => {
    window.location.assign("./details.html");
  });
}

function setActiveTab(elements: DetailsElements, tab: ProcessName): void {
  activeTab = tab;
  for (const button of elements.tabButtons) {
    button.classList.toggle("active", button.dataset.tab === tab);
  }
}

function wireDetailsPage(elements: DetailsElements): void {
  elements.backToMain.addEventListener("click", () => {
    window.location.assign("./index.html");
  });

  for (const button of elements.tabButtons) {
    button.addEventListener("click", () => {
      const tab = button.dataset.tab;
      if (!tab || !isProcessName(tab)) {
        return;
      }

      setActiveTab(elements, tab);
      if (latestState) {
        renderDetails(latestState, elements);
      } else {
        setLogs(elements.detailsLogs, logStore[activeTab]);
      }
    });
  }

  elements.clearTabLogs.addEventListener("click", () => {
    clearActiveTabLogs();
    setLogs(elements.detailsLogs, logStore[activeTab]);
  });
}

function processPayloadLog(payload: ProcessLogPayload): string[] {
  return String(payload.message || "")
    .replace(/\r/g, "")
    .split("\n")
    .map((line) => line.trimEnd())
    .filter(Boolean);
}

async function bootstrapMain(): Promise<void> {
  const elements = mainElements();
  wireMainPage(elements);
  if (elements.logs) {
    setLogs(elements.logs, logStore.all);
  }

  const unsubscribeState = window.desktopApi.onState((state) => {
    renderMain(state, elements);
  });

  const unsubscribeLog = window.desktopApi.onLog((payload) => {
    const lines = processPayloadLog(payload);
    for (const line of lines) {
      appendLog(payload.target, line);
    }
    if (elements.logs) {
      setLogs(elements.logs, logStore.all);
    }
  });

  window.addEventListener("beforeunload", () => {
    unsubscribeState();
    unsubscribeLog();
  });

  const initialState = await window.desktopApi.getStatus();
  renderMain(initialState, elements);
}

async function bootstrapDetails(): Promise<void> {
  const elements = detailsElements();
  wireDetailsPage(elements);
  setActiveTab(elements, activeTab);
  setLogs(elements.detailsLogs, logStore[activeTab]);

  const unsubscribeState = window.desktopApi.onState((state) => {
    renderDetails(state, elements);
  });

  const unsubscribeLog = window.desktopApi.onLog((payload) => {
    const lines = processPayloadLog(payload);
    for (const line of lines) {
      appendLog(payload.target, line);
    }
    setLogs(elements.detailsLogs, logStore[activeTab]);
  });

  window.addEventListener("beforeunload", () => {
    unsubscribeState();
    unsubscribeLog();
  });

  const initialState = await window.desktopApi.getStatus();
  renderDetails(initialState, elements);
}

async function bootstrap(): Promise<void> {
  if (!window.desktopApi) {
    throw new Error("desktopApi bridge was not loaded. Check preload configuration.");
  }

  const mode = document.body.dataset.page === "details" ? "details" : "main";
  if (mode === "details") {
    await bootstrapDetails();
    return;
  }

  await bootstrapMain();
}

void bootstrap().catch((error) => {
  const message = error instanceof Error ? error.message : String(error);
  appendLog("system", `[renderer:fatal] ${message}`);

  const mainLogs = document.getElementById("logs") as HTMLPreElement | null;
  if (mainLogs) {
    setLogs(mainLogs, logStore.all);
  }

  const detailsLogs = document.getElementById("details-logs") as HTMLPreElement | null;
  if (detailsLogs) {
    setLogs(detailsLogs, logStore[activeTab]);
  }
});
