import { describe, expect, it, vi } from "vitest";
import { EventEmitter } from "node:events";

import {
  assertUrlShape,
  egressRequest,
  isBlockedAddress,
  resolveEgressTarget,
  type EgressLookup,
  type EgressTarget,
  type HttpsRequestFn,
} from "../egress.server";
import { AiError } from "../errors";

/**
 * Les SEPT conditions de sortie de R-6 — étude 29 §5.
 *
 * Q-4 a ouvert l'adresse du fournisseur à la saisie libre. Ce fichier est la
 * contrepartie exigée par RISK-7, et l'étude nomme précisément les cas à
 * couvrir : « et pas seulement les faciles ». On les prend un par un.
 */

const publicLookup: EgressLookup = async () => [{ address: "93.184.216.34", family: 4 }];

function expectRefusal(fn: () => unknown, detail?: string) {
  try {
    fn();
  } catch (error) {
    expect(error).toBeInstanceOf(AiError);
    expect((error as AiError).code).toBe("AI_HOST_NOT_ALLOWED");
    if (detail) expect((error as AiError).detail).toBe(detail);
    return;
  }
  throw new Error("attendu : un refus, obtenu : aucune exception");
}

describe("R-6 conditions 1 et 2 — https et port 443, rien d'autre", () => {
  it("accepte une adresse https sans port explicite", () => {
    expect(assertUrlShape("https://api.example.com/v1").hostname).toBe("api.example.com");
  });

  it("accepte un :443 explicite (que l'API URL normalise en port vide)", () => {
    expect(assertUrlShape("https://api.example.com:443/v1").hostname).toBe("api.example.com");
  });

  it("refuse http", () =>
    expectRefusal(() => assertUrlShape("http://api.example.com"), "protocol"));

  it("refuse un schéma exotique", () =>
    expectRefusal(() => assertUrlShape("file:///etc/passwd"), "protocol"));

  it("refuse un port autre que 443", () =>
    expectRefusal(() => assertUrlShape("https://api.example.com:8443/v1"), "port"));

  it("refuse des identifiants dans l'URL", () =>
    expectRefusal(() => assertUrlShape("https://user:pass@api.example.com"), "credentials_in_url"));
});

describe("R-6 condition 3 — aucun littéral IP, sous AUCUNE forme", () => {
  // Les quatre écritures de 127.0.0.1. `isIP()` n'en reconnaît qu'une : c'est
  // pour cela que la garde porte sur la FORME du nom, pas sur `isIP` seul.
  it("refuse la forme pointée v4", () =>
    expectRefusal(() => assertUrlShape("https://127.0.0.1/v1"), "ip_literal"));

  it("refuse la forme décimale (2130706433 = 127.0.0.1)", () =>
    expectRefusal(() => assertUrlShape("https://2130706433/v1"), "ip_literal"));

  it("refuse la forme hexadécimale (0x7f000001)", () =>
    expectRefusal(() => assertUrlShape("https://0x7f000001/v1")));

  it("refuse la forme octale (0177.0.0.1)", () =>
    expectRefusal(() => assertUrlShape("https://0177.0.0.1/v1"), "ip_literal"));

  it("refuse un littéral IPv6", () =>
    expectRefusal(() => assertUrlShape("https://[::1]/v1"), "ip_literal"));

  it("refuse une IP publique en littéral — la règle ne dépend pas de la plage", () =>
    expectRefusal(() => assertUrlShape("https://93.184.216.34/v1"), "ip_literal"));

  it("refuse un nom sans point (localhost, nom de machine interne)", () => {
    expectRefusal(() => assertUrlShape("https://localhost/v1"), "hostname_shape");
    expectRefusal(() => assertUrlShape("https://gpu-box/v1"), "hostname_shape");
  });
});

describe("R-6 condition 4 — l'IP résolue doit être publique", () => {
  it("refuse loopback, privé, CGNAT, lien-local, multicast et réservé", () => {
    for (const address of [
      "127.0.0.1",
      "10.1.2.3",
      "172.16.0.1",
      "172.31.255.255",
      "192.168.1.1",
      "100.64.0.1", // CGNAT
      "169.254.1.1", // lien-local
      "0.0.0.0",
      "224.0.0.1", // multicast
      "255.255.255.255",
      "198.18.0.1", // bancs d'essai
    ]) {
      expect(isBlockedAddress(address), address).toBe(true);
    }
  });

  it("refuse 169.254.169.254 — l'adresse de métadonnées du cloud, cible n° 1 d'un SSRF", () => {
    expect(isBlockedAddress("169.254.169.254")).toBe(true);
  });

  it("refuse les formes IPv6 équivalentes, y compris l'IPv4 encapsulée", () => {
    for (const address of [
      "::1",
      "::",
      "fd00::1", // unique local
      "fe80::1", // lien-local
      "ff02::1", // multicast
      "::ffff:127.0.0.1", // IPv4 encapsulée
      "::ffff:169.254.169.254",
      "64:ff9b::10.0.0.1", // NAT64
      "2001:db8::1", // documentation
    ]) {
      expect(isBlockedAddress(address), address).toBe(true);
    }
  });

  it("laisse passer une adresse publique", () => {
    expect(isBlockedAddress("93.184.216.34")).toBe(false);
    expect(isBlockedAddress("2606:2800:220:1:248:1893:25c8:1946")).toBe(false);
  });

  it("refuse tout ce qui n'est ni v4 ni v6", () => {
    expect(isBlockedAddress("pas-une-ip")).toBe(true);
    expect(isBlockedAddress("")).toBe(true);
  });

  it("refuse un nom qui résout vers une plage privée", async () => {
    const lookup: EgressLookup = async () => [{ address: "10.0.0.5", family: 4 }];
    await expect(resolveEgressTarget("https://evil.example.com/v1", lookup)).rejects.toMatchObject({
      code: "AI_HOST_NOT_ALLOWED",
      detail: "private_address",
    });
  });

  it("refuse un nom qui résout vers une IP publique ET une IP privée", async () => {
    // Un nom à moitié valide est un nom hostile : on juge TOUTES les adresses.
    const lookup: EgressLookup = async () => [
      { address: "93.184.216.34", family: 4 },
      { address: "169.254.169.254", family: 4 },
    ];
    await expect(
      resolveEgressTarget("https://sneaky.example.com/v1", lookup),
    ).rejects.toMatchObject({ detail: "private_address" });
  });

  it("refuse une résolution vide ou en échec", async () => {
    await expect(
      resolveEgressTarget("https://a.example.com", async () => []),
    ).rejects.toMatchObject({ detail: "dns_empty" });
    await expect(
      resolveEgressTarget("https://a.example.com", async () => {
        throw new Error("NXDOMAIN");
      }),
    ).rejects.toMatchObject({ detail: "dns_failure" });
  });

  it("rend la cible épinglée quand tout est propre", async () => {
    const target = await resolveEgressTarget("https://api.example.com/v1", publicLookup);
    expect(target.address).toBe("93.184.216.34");
    expect(target.family).toBe(4);
    expect(target.url.hostname).toBe("api.example.com");
  });
});

describe("R-6 — la liste de REFUS s'ajoute aux sept conditions (Q-4)", () => {
  it("refuse un hôte de la liste et ses sous-domaines", () => {
    expectRefusal(() => assertUrlShape("https://metadata.google.internal/x"), "denylist");
    expectRefusal(() => assertUrlShape("https://a.metadata.google.internal/x"), "denylist");
  });
});

// ---------------------------------------------------------------------------
// Conditions 5 à 7 : la requête. Un faux `https.request` remplace le réseau.
// ---------------------------------------------------------------------------

type FakeResponse = { statusCode: number; chunks: string[] };

/**
 * Faux transport. Il CAPTURE les options passées à `https.request` — c'est par
 * elles que se prouve l'épinglage d'IP : le test appelle la fonction `lookup`
 * que nous avons fournie et vérifie qu'elle rend l'adresse validée sans jamais
 * re-résoudre le nom.
 */
function fakeTransport(response: FakeResponse) {
  const captured: { options?: Record<string, unknown> } = {};
  const requestFn = ((options: Record<string, unknown>, callback: (res: EventEmitter) => void) => {
    captured.options = options;
    const res = new EventEmitter() as EventEmitter & { statusCode: number; destroy: () => void };
    res.statusCode = response.statusCode;
    res.destroy = () => {};
    const req = new EventEmitter() as EventEmitter & {
      write: () => void;
      end: () => void;
      destroy: () => void;
    };
    req.write = () => {};
    req.destroy = () => {};
    req.end = () => {
      queueMicrotask(() => {
        callback(res);
        for (const chunk of response.chunks) res.emit("data", Buffer.from(chunk));
        res.emit("end");
      });
    };
    return req;
  }) as unknown as HttpsRequestFn;
  return { requestFn, captured };
}

const target: EgressTarget = {
  url: new URL("https://api.example.com/v1/chat/completions"),
  address: "93.184.216.34",
  family: 4,
};

describe("R-6 condition 5 — l'IP est ÉPINGLÉE (la garde anti-DNS-rebinding)", () => {
  it("se connecte à l'IP validée, et NE re-résout pas le nom", async () => {
    const { requestFn, captured } = fakeTransport({ statusCode: 200, chunks: ["{}"] });
    await egressRequest(target, { method: "POST", headers: {}, body: "{}" }, requestFn);

    // Le nom sert au TLS (SNI + certificat) ; l'adresse sert à la connexion.
    expect(captured.options?.servername).toBe("api.example.com");
    expect(captured.options?.hostname).toBe("api.example.com");
    expect(captured.options?.port).toBe(443);

    // Le scénario du rebinding : entre la validation et la connexion, le DNS
    // rend maintenant l'adresse de métadonnées. La fonction `lookup` que nous
    // passons à Node ne l'interroge pas — elle rend l'IP déjà validée.
    const lookup = captured.options?.lookup as (
      host: string,
      opts: { all?: boolean },
      cb: (e: null, a: string, f: number) => void,
    ) => void;
    const seen = vi.fn();
    lookup("api.example.com", {}, seen);
    expect(seen).toHaveBeenCalledWith(null, "93.184.216.34", 4);
  });

  it("sait aussi répondre à la forme `all: true` que Node peut demander", async () => {
    const { requestFn, captured } = fakeTransport({ statusCode: 200, chunks: ["{}"] });
    await egressRequest(target, { method: "POST", headers: {} }, requestFn);
    const lookup = captured.options?.lookup as (
      host: string,
      opts: { all?: boolean },
      cb: (e: null, a: { address: string; family: number }[]) => void,
    ) => void;
    const seen = vi.fn();
    lookup("api.example.com", { all: true }, seen);
    expect(seen).toHaveBeenCalledWith(null, [{ address: "93.184.216.34", family: 4 }]);
  });
});

describe("R-6 condition 6 — aucune redirection suivie", () => {
  it("refuse un 302 au lieu de le suivre", async () => {
    // Sans ce refus, un `302` vers 169.254.169.254 annulerait les quatre
    // premières conditions à lui seul.
    const { requestFn } = fakeTransport({ statusCode: 302, chunks: [] });
    await expect(
      egressRequest(target, { method: "POST", headers: {} }, requestFn),
    ).rejects.toMatchObject({ code: "AI_HOST_NOT_ALLOWED", detail: "redirect" });
  });

  it("refuse aussi un 301 et un 307", async () => {
    for (const statusCode of [301, 307]) {
      const { requestFn } = fakeTransport({ statusCode, chunks: [] });
      await expect(
        egressRequest(target, { method: "POST", headers: {} }, requestFn),
      ).rejects.toMatchObject({ detail: "redirect" });
    }
  });
});

describe("R-6 condition 7 — délai et taille plafonnés", () => {
  it("refuse une réponse au-delà du plafond de taille", async () => {
    const { requestFn } = fakeTransport({ statusCode: 200, chunks: ["x".repeat(4096)] });
    await expect(
      egressRequest(target, { method: "POST", headers: {}, maxBytes: 1024 }, requestFn),
    ).rejects.toMatchObject({ code: "AI_HOST_NOT_ALLOWED", detail: "response_too_large" });
  });

  it("laisse passer une réponse sous le plafond", async () => {
    const { requestFn } = fakeTransport({ statusCode: 200, chunks: ['{"ok":true}'] });
    const res = await egressRequest(
      target,
      { method: "POST", headers: {}, maxBytes: 1024 },
      requestFn,
    );
    expect(res).toEqual({ status: 200, body: '{"ok":true}' });
  });

  it("passe le délai à la couche transport", async () => {
    const { requestFn, captured } = fakeTransport({ statusCode: 200, chunks: ["{}"] });
    await egressRequest(target, { method: "POST", headers: {}, timeoutMs: 1234 }, requestFn);
    expect(captured.options?.timeout).toBe(1234);
  });

  it("re-type une erreur de transport — le corps d'origine ne sort jamais (R-5)", async () => {
    const requestFn = ((_options: unknown, _callback: unknown) => {
      const req = new EventEmitter() as EventEmitter & {
        write: () => void;
        end: () => void;
        destroy: () => void;
      };
      req.write = () => {};
      req.destroy = () => {};
      req.end = () => {
        queueMicrotask(() => req.emit("error", new Error("ECONNRESET https://api.example.com")));
      };
      return req;
    }) as unknown as HttpsRequestFn;

    const failure = await egressRequest(target, { method: "POST", headers: {} }, requestFn).catch(
      (e: unknown) => e,
    );
    expect(failure).toBeInstanceOf(AiError);
    // Le message ne contient QUE le code : ni l'hôte du parent, ni le texte brut.
    expect((failure as AiError).message).toBe("AI_PROVIDER_DOWN");
    expect((failure as AiError).message).not.toContain("api.example.com");
  });
});
