// @vitest-environment node
import { describe, expect, it } from "vitest";

import { VERCEL_ROUTES } from "../vercel-routes.mjs";

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
