import { app, dialog, type BrowserWindow, type MessageBoxOptions } from "electron";
import { autoUpdater, type ProgressInfo, type UpdateInfo } from "electron-updater";

interface UpdaterServiceOptions {
  getMainWindow: () => BrowserWindow | null;
  onLog: (target: string, stream: string, message: string) => void;
  onPrepareInstall: () => Promise<void>;
}

export class UpdaterService {
  private readonly getMainWindow: () => BrowserWindow | null;
  private readonly onLog: (target: string, stream: string, message: string) => void;
  private readonly onPrepareInstall: () => Promise<void>;

  private started = false;
  private updateAvailabilityPromptShown = false;
  private installPromptShown = false;
  private installInProgress = false;

  constructor(options: UpdaterServiceOptions) {
    this.getMainWindow = options.getMainWindow;
    this.onLog = options.onLog;
    this.onPrepareInstall = options.onPrepareInstall;
  }

  start(): void {
    if (this.started) {
      return;
    }

    if (!app.isPackaged && process.env.ENABLE_DEV_UPDATER !== "true") {
      this.onLog("updater", "system", "Auto-update check skipped in development mode.");
      return;
    }

    this.started = true;

    autoUpdater.autoDownload = false;
    autoUpdater.autoInstallOnAppQuit = true;

    autoUpdater.on("checking-for-update", () => {
      this.onLog("updater", "system", "Checking for updates...");
    });

    autoUpdater.on("update-available", (info) => {
      this.onLog("updater", "system", `Update available: ${info.version}`);
      this.handleUpdateAvailable(info);
    });

    autoUpdater.on("update-not-available", () => {
      this.onLog("updater", "system", "No update available.");
    });

    autoUpdater.on("download-progress", (progress) => {
      this.handleDownloadProgress(progress);
    });

    autoUpdater.on("update-downloaded", (info) => {
      this.onLog("updater", "system", `Update downloaded: ${info.version}`);
      this.handleUpdateDownloaded(info);
    });

    autoUpdater.on("error", (error) => {
      this.onLog("updater", "error", error?.message || String(error));
    });

    void autoUpdater.checkForUpdates().catch((error) => {
      this.onLog("updater", "error", error?.message || String(error));
    });
  }

  private handleDownloadProgress(progress: ProgressInfo): void {
    const percent = Number.isFinite(progress.percent) ? progress.percent.toFixed(1) : "0.0";
    this.onLog(
      "updater",
      "system",
      `Downloading update: ${percent}% (${formatBytes(progress.transferred)}/${formatBytes(progress.total)})`,
    );
  }

  private handleUpdateAvailable(info: UpdateInfo): void {
    if (this.updateAvailabilityPromptShown) {
      return;
    }

    this.updateAvailabilityPromptShown = true;

    void this.promptForDownload(info).catch((error) => {
      this.onLog("updater", "error", error?.message || String(error));
    });
  }

  private handleUpdateDownloaded(info: UpdateInfo): void {
    if (this.installPromptShown) {
      return;
    }

    this.installPromptShown = true;

    void this.promptForInstall(info).catch((error) => {
      this.onLog("updater", "error", error?.message || String(error));
    });
  }

  private async promptForDownload(info: UpdateInfo): Promise<void> {
    const sizeText = formatUpdateDownloadSize(info);
    const detail = sizeText
      ? `Download size: ${sizeText}\n\nDo you want to download and install this update now?`
      : "Do you want to download and install this update now?";

    const response = await this.showMessageBox({
      type: "info",
      title: "Update Available",
      message: `Version ${info.version} is available.`,
      detail,
      buttons: ["Download Update", "Later"],
      defaultId: 0,
      cancelId: 1,
      noLink: true,
    });

    if (response !== 0) {
      this.onLog("updater", "system", "Update dialog dismissed for this app session.");
      return;
    }

    this.onLog("updater", "system", "User accepted update download.");
    await autoUpdater.downloadUpdate();
  }

  private async promptForInstall(info: UpdateInfo): Promise<void> {
    const response = await this.showMessageBox({
      type: "info",
      title: "Update Ready",
      message: `Version ${info.version} has been downloaded.`,
      detail: "Restart now to install the update?",
      buttons: ["Restart and Install", "Later"],
      defaultId: 0,
      cancelId: 1,
      noLink: true,
    });

    if (response !== 0) {
      this.onLog("updater", "system", "Install dialog dismissed for this app session.");
      return;
    }

    await this.installDownloadedUpdate();
  }

  private async installDownloadedUpdate(): Promise<void> {
    if (this.installInProgress) {
      return;
    }

    this.installInProgress = true;
    this.onLog("updater", "system", "Preparing app shutdown for update installation...");

    try {
      await this.onPrepareInstall();
    } catch (error) {
      this.installInProgress = false;
      throw error;
    }

    this.onLog("updater", "system", "Quitting and installing update...");
    autoUpdater.quitAndInstall(false, true);
  }

  private async showMessageBox(options: MessageBoxOptions): Promise<number> {
    const parentWindow = this.getMainWindow();
    if (parentWindow && !parentWindow.isDestroyed()) {
      const result = await dialog.showMessageBox(parentWindow, options);
      return result.response;
    }

    const result = await dialog.showMessageBox(options);
    return result.response;
  }
}

function formatBytes(input: number): string {
  if (!Number.isFinite(input) || input <= 0) {
    return "0 B";
  }

  const units = ["B", "KB", "MB", "GB", "TB"];
  let value = input;
  let index = 0;

  while (value >= 1024 && index < units.length - 1) {
    value /= 1024;
    index += 1;
  }

  return `${value.toFixed(value >= 10 || index === 0 ? 0 : 1)} ${units[index]}`;
}

function formatUpdateDownloadSize(info: UpdateInfo): string | null {
  const files = Array.isArray(info.files) ? info.files : [];
  const totalSize = files.reduce((sum, file) => {
    const size = Number(file?.size);
    if (!Number.isFinite(size) || size <= 0) {
      return sum;
    }

    return sum + size;
  }, 0);

  if (totalSize <= 0) {
    return null;
  }

  return formatMegabytes(totalSize);
}

function formatMegabytes(input: number): string {
  if (!Number.isFinite(input) || input <= 0) {
    return "0 MB";
  }

  const valueInMb = input / (1024 * 1024);
  return `${valueInMb.toFixed(1)} MB`;
}
