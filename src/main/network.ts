import os from 'node:os';

export function getLocalIPv4(): string | null {
  const networkInterfaces = os.networkInterfaces();

  for (const details of Object.values(networkInterfaces)) {
    if (!Array.isArray(details)) {
      continue;
    }

    for (const info of details) {
      if (!info || info.internal || info.family !== 'IPv4') {
        continue;
      }

      return info.address;
    }
  }

  return null;
}
