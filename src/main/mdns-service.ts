import createMdns, { type MdnsQuery, type MdnsServer } from 'multicast-dns';

import type { MdnsState } from '../types';
import { getLocalIPv4 } from './network';

interface MdnsServiceOptions {
  hostname: string;
  ttl: number;
  checkIntervalMs: number;
  onLog: (target: string, stream: string, message: string) => void;
  onStateChange: () => void;
}

export class MdnsService {
  private readonly hostname: string;
  private readonly ttl: number;
  private readonly checkIntervalMs: number;
  private readonly onLog: (target: string, stream: string, message: string) => void;
  private readonly onStateChange: () => void;

  private mdnsServer: MdnsServer | null = null;
  private currentIp: string | null = null;
  private monitorTimer: NodeJS.Timeout | null = null;

  constructor(options: MdnsServiceOptions) {
    this.hostname = options.hostname;
    this.ttl = options.ttl;
    this.checkIntervalMs = options.checkIntervalMs;
    this.onLog = options.onLog;
    this.onStateChange = options.onStateChange;
  }

  getSnapshot(): MdnsState {
    return {
      hostname: this.hostname,
      running: Boolean(this.mdnsServer),
      ip: this.currentIp,
    };
  }

  startMonitor(): void {
    this.monitor();
    this.monitorTimer = setInterval(() => {
      this.monitor();
    }, this.checkIntervalMs);
  }

  stopMonitor(): void {
    if (this.monitorTimer) {
      clearInterval(this.monitorTimer);
      this.monitorTimer = null;
    }

    this.stopResponder();
  }

  private stopResponder(): void {
    if (!this.mdnsServer) {
      return;
    }

    try {
      this.mdnsServer.destroy();
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      this.onLog('mdns', 'error', `Failed to destroy mDNS responder: ${message}`);
    }

    this.mdnsServer = null;
    this.onStateChange();
  }

  private startResponder(ip: string): void {
    this.stopResponder();

    this.mdnsServer = createMdns();

    this.mdnsServer.on('query', payload => {
      const query = payload as MdnsQuery;
      const isQueryForHost = (query.questions || []).some(question => {
        if (!question || typeof question.name !== 'string') {
          return false;
        }

        return question.name.toLowerCase() === this.hostname && question.type === 'A';
      });

      if (!isQueryForHost) {
        return;
      }

      this.mdnsServer?.respond({
        answers: [
          {
            name: this.hostname,
            type: 'A',
            class: 'IN',
            ttl: this.ttl,
            data: ip,
          },
        ],
      });
    });

    this.mdnsServer.on('error', payload => {
      const error = payload as Error;
      this.onLog('mdns', 'error', error.message);
      this.currentIp = null;
      this.stopResponder();
    });

    this.onLog('mdns', 'system', `${this.hostname} -> ${ip}`);
    this.onStateChange();
  }

  private monitor(): void {
    const ip = getLocalIPv4();

    if (!ip) {
      if (this.currentIp) {
        this.onLog('mdns', 'system', 'No network interface found. Stopping responder.');
        this.currentIp = null;
        this.stopResponder();
        this.onStateChange();
      }

      return;
    }

    if (ip !== this.currentIp) {
      this.currentIp = ip;
      this.startResponder(ip);
    }
  }
}
