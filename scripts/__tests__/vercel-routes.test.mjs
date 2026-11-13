// @vitest-environment node
import { describe, expect, it } from "vitest";

import { readFileSync } from "node:fs";
import { join } from "node:path";

import {
  SHELL_LOCALE_HEADER,
  SHELL_THEME_HEADER,
  SUMMARY_PATH_SOURCE,
  VERCEL_ROUTES,
} from "../vercel-routes.mjs";

/**
 * Rejoue le routage Vercel sur un chemin : les routes à `continue` accumulent
 * leurs en-têtes dans l'ordre jusqu'à `handle: filesystem` ; `src` est une
 * expression régulière sur le chemin entier.
 */
function headersFor(pathname) {
  const headers = {};
  for (const route of VERCEL_ROUTES) {
    if (route.handle === "filesystem") break;
    if (!new RegExp(`^${route.src}$`).test(pathname)) continue;
    Object.assign(headers, route.headers);
    if (!route.continue) break;
  }
  return headers;
}

describe("routes Vercel — Cache-Control des fichiers de public/", () => {
  it("garde les bundles hachés immuables", () => {
    expect(headersFor("/assets/index-DdnE5P9Z.js")["Cache-Control"]).toBe(
      "public, max-age=31536000, immutable",
    );
  });

  it("sert les fontes auto-hébergées immuables : les faces préchargées ne revalident plus jamais", () => {
    for (const font of [
      "/fonts/space-grotesk-latin-var.woff2",
      "/fonts/orbitron-latin-var.woff2",
      "/fonts/space-grotesk-latin-ext-var.woff2",
      "/fonts/noto-kufi-arabic-var.woff2",
      "/fonts/noto-kufi-arabic-brand-var.woff2",
    ]) {
      expect(headersFor(font)["Cache-Control"], font).toBe("public, max-age=31536000, immutable");
    }
  });

  it("laisse icônes, favicon et manifest réutilisés un jour, revalidés en arrière-plan", () => {
    for (const file of [
      "/icons/icon-192.png",
      "/icons/apple-touch-icon.png",
      "/favicon.svg",
      "/manifest.webmanifest",
    ]) {
      expect(headersFor(file)["Cache-Control"], file).toBe(
        "public, max-age=86400, stale-while-revalidate=604800",
      );
    }
  });

  it("laisse le service worker, la page hors-ligne et robots.txt sur le défaut Vercel (revalidation à chaque fois)", () => {
    for (const file of ["/sw.js", "/offline.html", "/robots.txt", "/", "/dashboard"]) {
      expect(headersFor(file)["Cache-Control"], file).toBeUndefined();
    }
  });

  it("pose toujours les en-têtes de sécurité sur chaque réponse", () => {
    for (const file of ["/", "/fonts/orbitron-latin-var.woff2", "/assets/x.js"]) {
      expect(headersFor(file)["X-Frame-Options"], file).toBe("DENY");
      expect(headersFor(file)["X-Content-Type-Options"], file).toBe("nosniff");
    }
  });

  it("finit par le handle filesystem puis le fourre-tout SSR", () => {
    const tail = VERCEL_ROUTES.slice(-2);
    expect(tail[0]).toEqual({ handle: "filesystem" });
    expect(tail[1]).toEqual({ src: "/(.*)", dest: "/index" });
  });
});

/**
 * Rejoue les `transforms` d'en-têtes de requête du routage pour un chemin et un en-tête
 * `Cookie`, comme le routeur de Vercel les applique avant d'appeler la fonction.
 */
function requestHeadersFor(pathname, cookie = "") {
  const cookies = Object.fromEntries(
    cookie
      .split(";")
      .map((part) => part.trim().split("="))
      .filter(([key]) => key),
  );
  const headers = {};
  for (const route of VERCEL_ROUTES) {
    if (route.handle === "filesystem") break;
    if (!new RegExp(route.src).test(pathname)) continue;
    const matches = (route.has ?? []).every(
      (condition) => condition.type === "cookie" && cookies[condition.key] === condition.value,
    );
    if (!matches) continue;
    for (const transform of route.transforms ?? []) {
      if (transform.type === "request.headers" && transform.op === "set") {
        headers[transform.target.key] = transform.args;
      }
    }
  }
  return headers;
}

describe("routes Vercel — la variante des sommaires servis par le CDN", () => {
  it("recopie la langue et le thème des cookies dans les en-têtes de requête", () => {
    expect(
      requestHeadersFor("/niveau/x", "_ga=1; xp-scholars-locale=ar; xp-scholars-theme=dark"),
    ).toEqual({
      [SHELL_LOCALE_HEADER]: "ar",
      [SHELL_THEME_HEADER]: "dark",
    });
    expect(requestHeadersFor("/programme", "xp-scholars-locale=en")).toEqual({
      [SHELL_LOCALE_HEADER]: "en",
      [SHELL_THEME_HEADER]: "reference",
    });
  });

  it("pose les valeurs par défaut sans cookie — ou avec un cookie inconnu", () => {
    for (const cookie of ["", "xp-scholars-locale=de; xp-scholars-theme=light"]) {
      expect(requestHeadersFor("/", cookie)).toEqual({
        [SHELL_LOCALE_HEADER]: "fr",
        [SHELL_THEME_HEADER]: "reference",
      });
    }
  });

  it("ne touche pas aux pages de contenu", () => {
    expect(requestHeadersFor("/matiere/math", "xp-scholars-locale=ar")).toEqual({});
    expect(requestHeadersFor("/chapitre/x")).toEqual({});
  });

  it("garde les chemins et les en-têtes égaux à ceux de src/shared/lib/public-cache.ts", () => {
    const source = readFileSync(
      join(import.meta.dirname, "../../src/shared/lib/public-cache.ts"),
      "utf8",
    );
    const read = (name) => new RegExp(`export const ${name} =\\s*"([^"]+)"`).exec(source)?.[1];
    expect(read("SUMMARY_PATH_SOURCE")).toBe(SUMMARY_PATH_SOURCE);
    expect(read("SHELL_LOCALE_HEADER")).toBe(SHELL_LOCALE_HEADER);
    expect(read("SHELL_THEME_HEADER")).toBe(SHELL_THEME_HEADER);
  });
});
