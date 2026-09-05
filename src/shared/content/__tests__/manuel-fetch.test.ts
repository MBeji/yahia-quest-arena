import { describe, expect, it, vi } from "vitest";
import { existsSync, mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { downloadManuel } from "../../../../scripts/content/fetch-manuel.ts";
import { CNP_MANUEL_BASE_URL } from "../manuel-cnp";
import {
  NETWORK_POLICY_MESSAGE,
  classifyFetchError,
  classifyResponse,
  looksLikePdf,
  parsePages,
  planManuelDownload,
  renderArgs,
} from "../manuel-fetch";

const PDF_BYTES = new TextEncoder().encode("%PDF-1.7\n%âãÏÓ\n1 0 obj\n<<>>\nendobj\n%%EOF\n");
const HTML_BYTES = new TextEncoder().encode(
  "<!doctype html><html><body>Access denied</body></html>",
);

/** L'erreur exacte qu'undici lève quand le proxy de l'environnement refuse l'hôte (constatée 2026-09-05). */
function proxyRefusal(): Error {
  const inner = Object.assign(new Error("Proxy response (403) !== 200 when HTTP Tunneling"), {
    name: "AbortError",
    code: "UND_ERR_ABORTED",
  });
  const cancelled = new Error("Request was cancelled.", { cause: inner });
  return new TypeError("fetch failed", { cause: cancelled });
}

function response(
  status: number,
  body: Uint8Array,
  headers: Record<string, string> = {},
): Response {
  return new Response(body.slice(), { status, headers });
}

describe("planManuelDownload", () => {
  it("dérive l'URL et le nom de fichier du code, dans le dossier demandé", () => {
    const plan = planManuelDownload("102905", "/var/tmp/manuels/");
    expect(plan).toEqual({
      code: "102905",
      url: `${CNP_MANUEL_BASE_URL}/102905P00.pdf`,
      fileName: "102905P00.pdf",
      file: "/var/tmp/manuels/102905P00.pdf",
    });
    expect(planManuelDownload("102105P02", "out")?.file).toBe("out/102105P02.pdf");
  });

  it("refuse un code qui pourrait sortir du magasin", () => {
    expect(planManuelDownload("../etc/passwd", "out")).toBeNull();
    expect(planManuelDownload("", "out")).toBeNull();
  });
});

describe("looksLikePdf", () => {
  it("reconnaît la signature %PDF- et rien d'autre", () => {
    expect(looksLikePdf(PDF_BYTES)).toBe(true);
    expect(looksLikePdf(HTML_BYTES)).toBe(false);
    expect(looksLikePdf(new Uint8Array([0x25, 0x50]))).toBe(false);
  });
});

describe("classifyFetchError", () => {
  it("lit le refus du proxy deux causes plus bas et nomme le lot 0, pas une panne du CNP", () => {
    const v = classifyFetchError(proxyRefusal(), {
      HTTPS_PROXY: "http://127.0.0.1:1",
      NODE_USE_ENV_PROXY: "1",
    });
    expect(v.kind).toBe("network-policy");
    expect(v.message).toBe(NETWORK_POLICY_MESSAGE);
    expect(v.message).toMatch(/lot 0/);
  });

  it("nomme NODE_USE_ENV_PROXY quand la session a un proxy que Node n'utilise pas", () => {
    const v = classifyFetchError(
      new TypeError("fetch failed", {
        cause: Object.assign(new Error("connect ETIMEDOUT"), { code: "ETIMEDOUT" }),
      }),
      {
        HTTPS_PROXY: "http://127.0.0.1:1",
      },
    );
    expect(v.kind).toBe("network");
    expect(v.message).toMatch(/NODE_USE_ENV_PROXY=1/);
    expect(v.message).toMatch(/ETIMEDOUT/);
  });

  it("rapporte la cause d'une panne ordinaire, sans inventer de politique réseau", () => {
    const v = classifyFetchError(new Error("getaddrinfo ENOTFOUND www.cnp.com.tn"), {});
    expect(v).toEqual({
      kind: "network",
      message: "échec réseau : getaddrinfo ENOTFOUND www.cnp.com.tn",
    });
    expect(classifyFetchError(undefined, {}).message).toMatch(/cause inconnue/);
  });
});

describe("classifyResponse", () => {
  const head = PDF_BYTES.subarray(0, 8);

  it("un 403 signé par le bac à sable est la politique réseau, un 403 nu est une erreur HTTP", () => {
    expect(
      classifyResponse({ status: 403, denyReason: "host_not_allowed", contentType: null, head })
        ?.kind,
    ).toBe("network-policy");
    expect(classifyResponse({ status: 403, denyReason: null, contentType: null, head })).toEqual({
      kind: "http",
      message: "HTTP 403",
    });
  });

  it("404 = code inconnu du CNP ; 200 sans %PDF- = page d'erreur ; 200 PDF = rien à signaler", () => {
    expect(
      classifyResponse({ status: 404, denyReason: null, contentType: "text/html", head })?.kind,
    ).toBe("not-found");
    const notPdf = classifyResponse({
      status: 200,
      denyReason: null,
      contentType: "text/html",
      head: HTML_BYTES,
    });
    expect(notPdf?.kind).toBe("not-pdf");
    expect(notPdf?.message).toContain("text/html");
    expect(
      classifyResponse({ status: 200, denyReason: null, contentType: "application/pdf", head }),
    ).toBeNull();
  });
});

describe("parsePages / renderArgs", () => {
  it("lit une plage, une page, rien — et refuse le reste", () => {
    expect(parsePages("18-24")).toEqual({ first: 18, last: 24 });
    expect(parsePages("7")).toEqual({ first: 7, last: 7 });
    expect(parsePages(undefined)).toEqual({});
    expect(parsePages("  ")).toEqual({});
    expect(parsePages("b")).toBeNull();
    expect(parsePages("9-3")).toBeNull();
    expect(parsePages("0")).toBeNull();
  });

  it("construit l'argv de pdftoppm, à 150 dpi par défaut", () => {
    expect(renderArgs({ file: "a.pdf", outPrefix: "a-p", first: 18, last: 24 })).toEqual([
      "-r",
      "150",
      "-png",
      "-f",
      "18",
      "-l",
      "24",
      "a.pdf",
      "a-p",
    ]);
    expect(renderArgs({ file: "a.pdf", outPrefix: "a-p", dpi: 120 })).toEqual([
      "-r",
      "120",
      "-png",
      "a.pdf",
      "a-p",
    ]);
  });
});

describe("downloadManuel", () => {
  it("écrit le PDF reçu et rend sa taille", async () => {
    const dir = mkdtempSync(join(tmpdir(), "manuel-fetch-"));
    try {
      const fetchImpl = vi.fn(async () =>
        response(200, PDF_BYTES, { "content-type": "application/pdf" }),
      );
      const file = join(dir, "sub", "102905P00.pdf");
      const r = await downloadManuel("https://example.test/102905P00.pdf", file, {
        fetchImpl: fetchImpl as never,
      });
      expect(r).toMatchObject({ ok: true, file, bytes: PDF_BYTES.length });
      expect(readFileSync(file)).toEqual(Buffer.from(PDF_BYTES));
      expect(fetchImpl).toHaveBeenCalledWith(
        "https://example.test/102905P00.pdf",
        expect.objectContaining({ redirect: "follow" }),
      );
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("n'écrit RIEN quand la réponse n'est pas un PDF ou que le CNP ne connaît pas le code", async () => {
    const dir = mkdtempSync(join(tmpdir(), "manuel-fetch-"));
    try {
      const file = join(dir, "x.pdf");
      const html = await downloadManuel("https://example.test/x.pdf", file, {
        fetchImpl: (async () =>
          response(200, HTML_BYTES, { "content-type": "text/html" })) as never,
      });
      expect(html).toMatchObject({ ok: false, failure: { kind: "not-pdf" } });
      const missing = await downloadManuel("https://example.test/x.pdf", file, {
        fetchImpl: (async () => response(404, HTML_BYTES)) as never,
      });
      expect(missing).toMatchObject({ ok: false, failure: { kind: "not-found" } });
      expect(existsSync(file)).toBe(false);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("traduit le refus du proxy en « politique réseau, lot 0 »", async () => {
    const r = await downloadManuel("https://example.test/x.pdf", "/nonexistent/x.pdf", {
      fetchImpl: (async () => {
        throw proxyRefusal();
      }) as never,
      environment: { HTTPS_PROXY: "http://127.0.0.1:1", NODE_USE_ENV_PROXY: "1" },
    });
    expect(r).toEqual({
      ok: false,
      failure: { kind: "network-policy", message: NETWORK_POLICY_MESSAGE },
    });
  });
});
