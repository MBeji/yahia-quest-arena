import { describe, it, expect } from "vitest";
import { readFileSync, existsSync, statSync } from "node:fs";
import { resolve } from "node:path";

const ROOT = resolve(import.meta.dirname, "../..");
const CSS = readFileSync(resolve(ROOT, "src/styles.css"), "utf-8");
const ROOT_ROUTE = readFileSync(resolve(ROOT, "src/routes/__root.tsx"), "utf-8");

/** Les fichiers déclarés par les @font-face, dans l'ordre de la feuille. */
const DECLARED = [...CSS.matchAll(/url\("(\/fonts\/[^"]+)"\)/g)].map((m) => m[1]);

describe("Fontes auto-hébergées (levier 06)", () => {
  it("déclare les trois familles utilisées par le design system", () => {
    for (const family of ["Orbitron", "Space Grotesk", "Noto Kufi Arabic"]) {
      expect(CSS).toContain(`font-family: "${family}"`);
    }
  });

  it("chaque fichier déclaré existe VRAIMENT dans public/ — un 404 de fonte est muet", () => {
    expect(DECLARED.length).toBeGreaterThan(0);
    for (const href of DECLARED) {
      const file = resolve(ROOT, "public", href.replace(/^\//, ""));
      expect(existsSync(file), `${href} déclaré mais absent`).toBe(true);
      expect(statSync(file).size).toBeGreaterThan(1000);
    }
  });

  it("porte un unicode-range par face : sans lui, l'arabe se télécharge pour tout le monde", () => {
    const faces = CSS.split("@font-face").slice(1);
    expect(faces.length).toBe(DECLARED.length);
    for (const face of faces) {
      expect(face.slice(0, face.indexOf("}"))).toContain("unicode-range:");
    }
  });

  it("ne précharge QUE les deux faces latines, et en mode CORS", () => {
    const preloaded = [...ROOT_ROUTE.matchAll(/href: "(\/fonts\/[^"]+)"/g)].map((m) => m[1]);
    expect(preloaded).toEqual([
      "/fonts/space-grotesk-latin-var.woff2",
      "/fonts/orbitron-latin-var.woff2",
    ]);
    // Sans `crossOrigin`, le préchargement ne matche pas la requête de la fonte
    // et le fichier part deux fois — un préchargement qui coûte au lieu de servir.
    expect(ROOT_ROUTE).toContain('crossOrigin: "anonymous"');
  });

  it("ne charge plus rien depuis Google : ni feuille, ni preconnect", () => {
    expect(ROOT_ROUTE).not.toContain("fonts.googleapis.com");
    expect(ROOT_ROUTE).not.toContain("fonts.gstatic.com");
  });
});
