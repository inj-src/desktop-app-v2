import { contextBridge, ipcRenderer } from 'electron';
import type { DesktopApi, DesktopState, ProcessLogPayload, ProcessName } from './types';

const desktopApi: DesktopApi = {
  getStatus: () => ipcRenderer.invoke('desktop:status:get') as Promise<DesktopState>,
  startProcess: name => ipcRenderer.invoke('desktop:process:start', name),
  stopProcess: name => ipcRenderer.invoke('desktop:process:stop', name),
  restartProcess: name => ipcRenderer.invoke('desktop:process:restart', name),
  openExternal: url => ipcRenderer.invoke('desktop:open-external', url),
  onState: callback => {
    const listener = (_event: Electron.IpcRendererEvent, state: DesktopState) => callback(state);
    ipcRenderer.on('desktop:state', listener);

    return () => {
      ipcRenderer.removeListener('desktop:state', listener);
    };
  },
  onLog: callback => {
    const listener = (_event: Electron.IpcRendererEvent, payload: ProcessLogPayload) =>
      callback(payload);
    ipcRenderer.on('desktop:log', listener);

    return () => {
      ipcRenderer.removeListener('desktop:log', listener);
    };
  },
};

contextBridge.exposeInMainWorld('desktopApi', desktopApi);
