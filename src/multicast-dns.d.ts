declare module 'multicast-dns' {
  export interface MdnsQuestion {
    name?: string;
    type?: string;
  }

  export interface MdnsQuery {
    questions?: MdnsQuestion[];
  }

  export interface MdnsAnswer {
    name: string;
    type: 'A';
    class: 'IN';
    ttl: number;
    data: string;
  }

  export interface MdnsServer {
    on: (event: 'query' | 'error', callback: (payload: unknown) => void) => void;
    respond: (payload: { answers: MdnsAnswer[] }) => void;
    destroy: () => void;
  }

  export default function createMdns(): MdnsServer;
}
