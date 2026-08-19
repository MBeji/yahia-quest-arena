import { describe, it, expect, vi } from "vitest";
import { mkdtempSync, mkdirSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  collectManuelCodes,
  probe,
  sizeFromHeaders,
  sizeIndex,
  verdictFor,
} from "../../../../scripts/content/check-manuel-links.ts";

/** Une réponse fetch minimale — seuls le statut et les en-têtes comptent ici. */
const res = (status: number, headers: Record<string, string> = {}) =>
  ({ status, headers: new Headers(headers) }) as Response;

const OCTETS = 5_686_665; // 102905P00.pdf au registre CNP

describe("sizeFromHeaders", () => {
  it("lit content-length sur une réponse pleine", () => {
    expect(sizeFromHeaders(200, { "content-length": "5686665" })).toBe(OCTETS);
  });

  it("lit la taille TOTALE dans content-range sur un 206", () => {
    // Le content-length d'un 206 vaut la tranche (1 octet), pas le document.
    expect(
      sizeFromHeaders(206, { "content-length": "1", "content-range": "bytes 0-0/5686665" }),
    ).toBe(OCTETS);
  });

  it("rend null quand la taille est absente ou illisible", () => {
    expect(sizeFromHeaders(200, {})).toBeNull();
    expect(sizeFromHeaders(200, { "content-length": "beaucoup" })).toBeNull();
    expect(sizeFromHeaders(206, { "content-range": "bytes 0-0/*" })).toBeNull();
  });
});

describe("verdictFor", () => {
  const pdf = "application/pdf";

  it("ok quand la taille correspond au registre", () => {
    const v = verdictFor({ status: 200, size: OCTETS, contentType: pdf }, OCTETS);
    expect(v.verdict).toBe("ok");
  });

  it("changed quand le document a été republié à la source", () => {
    const v = verdictFor({ status: 200, size: OCTETS + 4096, contentType: pdf }, OCTETS);
    expect(v.verdict).toBe("changed");
    expect(v.reason).toContain(String(OCTETS));
  });

  it("broken quand le document a disparu", () => {
    expect(verdictFor({ status: 404, size: null }, OCTETS).verdict).toBe("broken");
    expect(verdictFor({ status: 410, size: null }, OCTETS).verdict).toBe("broken");
  });

  // Le cas qui a fait corriger la conception. Lancée pour de vrai le 2026-08-19
  // depuis une session dont la passerelle refuse le domaine, la sonde a reçu 403
  // sur les 14 codes et les aurait TOUS déclarés morts. Un intermédiaire qui
  // bloque n'est pas un manuel qui disparaît.
  it("unknown — pas broken — sur 401/403 : ça peut être un proxy ou un WAF", () => {
    for (const status of [401, 403]) {
      const v = verdictFor({ status, size: null }, OCTETS);
      expect(v.verdict).toBe("unknown");
      expect(v.reason).toMatch(/proxy|WAF/);
    }
  });

  it("unknown sur un 200 non-PDF : page d'erreur OU page de défi, on ne tranche pas", () => {
    const v = verdictFor(
      { status: 200, size: 1234, contentType: "text/html; charset=utf-8" },
      OCTETS,
    );
    expect(v.verdict).toBe("unknown");
    expect(v.reason).toContain("pas un PDF");
  });

  it("broken UNIQUEMENT quand le serveur dit que la ressource n'est plus là", () => {
    const broken = [404, 410];
    for (const status of [401, 403, 429, 500, 502, 503]) {
      expect(verdictFor({ status, size: null }, OCTETS).verdict).not.toBe("broken");
    }
    for (const status of broken) {
      expect(verdictFor({ status, size: null }, OCTETS).verdict).toBe("broken");
    }
  });

  it("unknown plutôt qu'un faux broken sur une panne serveur", () => {
    expect(verdictFor({ status: 502, size: null }, OCTETS).verdict).toBe("unknown");
    expect(verdictFor({ status: 503, size: null }, OCTETS).verdict).toBe("unknown");
  });

  it("unknown quand le serveur tait la taille — l'identité est invérifiable", () => {
    expect(verdictFor({ status: 200, size: null, contentType: pdf }, OCTETS).verdict).toBe(
      "unknown",
    );
  });
});

describe("probe", () => {
  it("se contente d'un HEAD — aucun corps n'est téléchargé", async () => {
    const fetchImpl = vi.fn(async (_url: unknown, _init?: RequestInit) =>
      res(200, { "content-length": String(OCTETS), "content-type": "application/pdf" }),
    );
    const v = await probe("https://example.test/102905P00.pdf", OCTETS, {
      fetchImpl: fetchImpl as never,
    });
    expect(v.verdict).toBe("ok");
    expect(fetchImpl).toHaveBeenCalledTimes(1);
    expect(fetchImpl.mock.calls[0][1]).toMatchObject({ method: "HEAD" });
  });

  it("retombe sur un GET d'UN octet quand HEAD n'est pas supporté", async () => {
    const fetchImpl = vi.fn(async (_url: unknown, init: RequestInit | undefined) =>
      init?.method === "HEAD"
        ? res(405)
        : res(206, { "content-range": `bytes 0-0/${OCTETS}`, "content-type": "application/pdf" }),
    );
    const v = await probe("https://example.test/x.pdf", OCTETS, { fetchImpl: fetchImpl as never });
    expect(v.verdict).toBe("ok");
    expect(fetchImpl).toHaveBeenCalledTimes(2);
    expect(fetchImpl.mock.calls[1][1]).toMatchObject({ headers: { Range: "bytes=0-0" } });
  });

  it("retombe aussi sur la tranche quand un 200 tait sa taille", async () => {
    const fetchImpl = vi.fn(async (_url: unknown, init: RequestInit | undefined) =>
      init?.method === "HEAD"
        ? res(200, { "content-type": "application/pdf" })
        : res(206, { "content-range": `bytes 0-0/${OCTETS}` }),
    );
    const v = await probe("https://example.test/x.pdf", OCTETS, { fetchImpl: fetchImpl as never });
    expect(v.verdict).toBe("ok");
    expect(fetchImpl).toHaveBeenCalledTimes(2);
  });

  it("dégrade en unknown — jamais en broken — quand le réseau lâche", async () => {
    const fetchImpl = vi.fn(async () => {
      throw new Error("ETIMEDOUT");
    });
    const v = await probe("https://example.test/x.pdf", OCTETS, { fetchImpl: fetchImpl as never });
    expect(v.verdict).toBe("unknown");
    expect(v.reason).toContain("ETIMEDOUT");
  });
});

describe("collectManuelCodes", () => {
  const write = (dir: string, sub: string, meta: unknown) => {
    mkdirSync(join(dir, sub), { recursive: true });
    writeFileSync(join(dir, sub, "subject.json"), JSON.stringify(meta), "utf8");
  };

  it("ne retient que les codes de MATIÈRE, dédupliqués et triés", () => {
    const dir = mkdtempSync(join(tmpdir(), "manuel-links-"));
    try {
      write(dir, "math", { id: "math", manuels: [{ code: "102905" }] });
      write(dir, "math-8eme", { id: "math-8eme", manuels: [{ code: "102805" }] });
      // Deux matières peuvent citer la même œuvre : une seule requête.
      write(dir, "svt-partage", { id: "svt-partage", manuels: [{ code: "102905" }] });
      // Une matière sans manuel ne produit aucune sonde.
      write(dir, "culture", { id: "culture" });

      expect(collectManuelCodes(dir)).toEqual([
        { code: "102805", subjects: ["math-8eme"] },
        { code: "102905", subjects: ["math", "svt-partage"] },
      ]);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("garde chaque tome d'une œuvre multi-volumes", () => {
    const dir = mkdtempSync(join(tmpdir(), "manuel-links-"));
    try {
      write(dir, "math-1ere", {
        id: "math-1ere",
        manuels: [{ code: "102105P01" }, { code: "102105P02" }],
      });
      expect(collectManuelCodes(dir).map((c) => c.code)).toEqual(["102105P01", "102105P02"]);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});

describe("sizeIndex", () => {
  it("indexe le registre par nom de fichier", () => {
    const idx = sizeIndex({
      documents: [
        { code: "102905", tome: "P00", octets: OCTETS },
        { code: "102105", tome: "P01", octets: 42 },
      ],
    });
    expect(idx.get("102905P00.pdf")).toBe(OCTETS);
    expect(idx.get("102105P01.pdf")).toBe(42);
    expect(idx.get("999999P00.pdf")).toBeUndefined();
  });
});
