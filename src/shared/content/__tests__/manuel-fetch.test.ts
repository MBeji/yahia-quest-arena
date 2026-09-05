import { describe, expect, it, vi } from "vitest";
import { existsSync, mkdtempSync, readFileSync, rmSync, statSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { defaultOutDir, downloadManuel } from "../../../../scripts/content/fetch-manuel.ts";
import { CNP_MANUEL_BASE_URL } from "../manuel-cnp";
import {
  CURL_USER_AGENT,
  NETWORK_POLICY_MESSAGE,
  classifyCurlFailure,
  classifyDownloadedHead,
  curlArgs,
  looksLikePdf,
  parseCurlReport,
  parsePages,
  planManuelDownload,
  renderArgs,
} from "../manuel-fetch";

const PDF_BYTES = new TextEncoder().encode("%PDF-1.7\n%âãÏÓ\n1 0 obj\n<<>>\nendobj\n%%EOF\n");
const HTML_BYTES = new TextEncoder().encode(
  "<!doctype html><html><body>Access denied</body></html>",
);

/**
 * Le refus exact du proxy d'environnement, tel que curl --fail le rend (constaté 2026-09-05) :
 * exit 22, les MÊMES mots qu'un 403 du site, mais aucun code HTTP et un CONNECT à 403.
 */
const PROXY_REFUSAL = {
  status: 22,
  stdout: "000 403 ",
  stderr: "curl: (22) The requested URL returned error: 403\n",
};

/** Le même refus sans --fail (une sonde en -I) : exit 56 et le message qui nomme le tunnel. */
const PROXY_REFUSAL_56 = {
  status: 56,
  stdout: "000 403 ",
  stderr: "curl: (56) CONNECT tunnel failed, response 403\n",
};

/** Un faux curl : écrit `body` dans le fichier `-o`, rend le rapport `-w`. */
function fakeCurl(body: Uint8Array | null, report = "200 200 application/pdf") {
  return vi.fn((args: string[]) => {
    const file = args[args.indexOf("-o") + 1];
    if (body) writeFileSync(file, body);
    return { status: 0, stdout: report, stderr: "" };
  });
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

describe("looksLikePdf / classifyDownloadedHead", () => {
  it("reconnaît la signature %PDF- et rien d'autre", () => {
    expect(looksLikePdf(PDF_BYTES)).toBe(true);
    expect(looksLikePdf(HTML_BYTES)).toBe(false);
    expect(looksLikePdf(new Uint8Array([0x25, 0x50]))).toBe(false);
  });

  it("un PDF passe ; une page HTML est nommée avec son type", () => {
    expect(classifyDownloadedHead(PDF_BYTES.subarray(0, 8), "application/pdf")).toBeNull();
    const v = classifyDownloadedHead(HTML_BYTES.subarray(0, 8), "text/html");
    expect(v?.kind).toBe("not-pdf");
    expect(v?.message).toContain("text/html");
    expect(classifyDownloadedHead(HTML_BYTES.subarray(0, 8), null)?.message).toContain(
      "type inconnu",
    );
  });
});

describe("curlArgs / parseCurlReport", () => {
  it("pin le schéma https, échoue sur HTTP ≥ 400, écrit dans le fichier et rapporte code, CONNECT et type", () => {
    const args = curlArgs("https://example.test/x.pdf", "/tmp/x.pdf", 42);
    expect(args).toContain("--fail");
    expect(args.slice(args.indexOf("--proto"), args.indexOf("--proto") + 2)).toEqual([
      "--proto",
      "=https",
    ]);
    expect(args.slice(args.indexOf("--max-time"), args.indexOf("--max-time") + 2)).toEqual([
      "--max-time",
      "42",
    ]);
    expect(args.slice(args.indexOf("-A"), args.indexOf("-A") + 2)).toEqual(["-A", CURL_USER_AGENT]);
    expect(args.slice(args.indexOf("-o"), args.indexOf("-o") + 2)).toEqual(["-o", "/tmp/x.pdf"]);
    expect(args[args.indexOf("-w") + 1]).toBe("%{http_code} %{http_connect} %{content_type}");
    expect(args.at(-1)).toBe("https://example.test/x.pdf");
  });

  it("lit le rapport -w, avec ou sans type", () => {
    expect(parseCurlReport("200 200 application/pdf\n")).toEqual({
      status: 200,
      connect: 200,
      contentType: "application/pdf",
    });
    expect(parseCurlReport("000 403 ")).toEqual({ status: 0, connect: 403, contentType: null });
    expect(parseCurlReport("")).toEqual({ status: 0, connect: 0, contentType: null });
  });
});

describe("classifyCurlFailure", () => {
  it("le CONNECT 403 du proxy est la politique réseau et nomme le lot 0 — même quand curl dit « error: 403 »", () => {
    for (const refusal of [PROXY_REFUSAL, PROXY_REFUSAL_56]) {
      const v = classifyCurlFailure(refusal);
      expect(v.kind).toBe("network-policy");
      expect(v.message).toBe(NETWORK_POLICY_MESSAGE);
      expect(v.message).toMatch(/lot 0/);
    }
  });

  it("un 403 du SITE (CONNECT 200) reste une erreur HTTP ; 404 = code inconnu du CNP", () => {
    expect(
      classifyCurlFailure({
        status: 22,
        stdout: "403 200 text/html",
        stderr: "curl: (22) The requested URL returned error: 403\n",
      }),
    ).toEqual({ kind: "http", message: "HTTP 403" });
    expect(
      classifyCurlFailure({
        status: 22,
        stdout: "404 200 text/html",
        stderr: "curl: (22) The requested URL returned error: 404\n",
      }).kind,
    ).toBe("not-found");
    expect(
      classifyCurlFailure({
        status: 22,
        stdout: "",
        stderr: "curl: (22) The requested URL returned error: 503",
      }),
    ).toEqual({ kind: "http", message: "HTTP 503" });
    expect(classifyCurlFailure({ status: 22, stdout: "", stderr: "" }).message).toBe("HTTP ?");
  });

  it("distingue le délai, l'absence de curl et une panne ordinaire", () => {
    expect(
      classifyCurlFailure({
        status: 28,
        stdout: "000 000 ",
        stderr: "curl: (28) Operation timed out",
      }).message,
    ).toMatch(/délai/);
    expect(classifyCurlFailure({ status: null, stdout: "", stderr: "" })).toEqual({
      kind: "network",
      message: "curl indisponible sur ce poste",
    });
    expect(
      classifyCurlFailure({
        status: 6,
        stdout: "000 000 ",
        stderr: "curl: (6) Could not resolve host: www.cnp.com.tn\n",
      }),
    ).toEqual({
      kind: "network",
      message: "curl 6 : curl: (6) Could not resolve host: www.cnp.com.tn",
    });
    expect(classifyCurlFailure({ status: 7, stdout: "", stderr: "" }).message).toMatch(
      /cause inconnue/,
    );
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
  it("écrit le PDF reçu dans un dossier privé et rend sa taille", () => {
    const dir = mkdtempSync(join(tmpdir(), "manuel-fetch-"));
    try {
      const run = fakeCurl(PDF_BYTES);
      const file = join(dir, "sub", "102905P00.pdf");
      const r = downloadManuel("https://example.test/102905P00.pdf", file, { run, timeoutS: 9 });
      expect(r).toMatchObject({ ok: true, file, bytes: PDF_BYTES.length });
      expect(readFileSync(file)).toEqual(Buffer.from(PDF_BYTES));
      expect(statSync(join(dir, "sub")).mode & 0o777).toBe(0o700);
      const args = run.mock.calls[0][0];
      expect(args.at(-1)).toBe("https://example.test/102905P00.pdf");
      expect(args).toContain("9");
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("ne laisse RIEN derrière lui quand la réponse n'est pas un PDF ou que curl a échoué", () => {
    const dir = mkdtempSync(join(tmpdir(), "manuel-fetch-"));
    try {
      const file = join(dir, "x.pdf");
      const html = downloadManuel("https://example.test/x.pdf", file, {
        run: fakeCurl(HTML_BYTES, "200 200 text/html"),
      });
      expect(html).toMatchObject({ ok: false, failure: { kind: "not-pdf" } });
      expect(existsSync(file)).toBe(false);

      const missing = downloadManuel("https://example.test/x.pdf", file, {
        run: () => ({
          status: 22,
          stdout: "404 200 text/html",
          stderr: "curl: (22) The requested URL returned error: 404",
        }),
      });
      expect(missing).toMatchObject({ ok: false, failure: { kind: "not-found" } });

      const refused = downloadManuel("https://example.test/x.pdf", file, {
        run: () => PROXY_REFUSAL,
      });
      expect(refused).toEqual({
        ok: false,
        failure: { kind: "network-policy", message: NETWORK_POLICY_MESSAGE },
      });
      expect(existsSync(file)).toBe(false);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("n'écrase jamais un fichier existant — même par un lien préparé à l'avance", () => {
    const dir = mkdtempSync(join(tmpdir(), "manuel-fetch-"));
    try {
      const file = join(dir, "x.pdf");
      writeFileSync(file, "garde-moi");
      const run = fakeCurl(PDF_BYTES);
      const r = downloadManuel("https://example.test/x.pdf", file, { run });
      expect(r).toMatchObject({ ok: false, failure: { kind: "exists" } });
      expect(run).not.toHaveBeenCalled();
      expect(readFileSync(file, "utf8")).toBe("garde-moi");
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});

describe("defaultOutDir", () => {
  it("est un cache sous le HOME de l'utilisateur, jamais le répertoire temporaire partagé", () => {
    expect(defaultOutDir("/home/mohamed")).toBe(join("/home/mohamed", ".cache", "yqa-manuels"));
    expect(defaultOutDir()).not.toContain(tmpdir());
  });
});
