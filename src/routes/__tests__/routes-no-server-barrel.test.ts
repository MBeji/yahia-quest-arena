// @vitest-environment node
import { readFileSync, readdirSync } from "node:fs";
import { join, relative } from "node:path";
import { describe, expect, it } from "vitest";

/**
 * Une COQUILLE DE ROUTE ne doit jamais importer une barrel qui mêle composants
 * client et modules serveur.
 *
 * Ce que ça a coûté, le 2026-08-27 : `_authenticated.tsx` et `_public.tsx` ont
 * pris `AiLauncher` depuis `@/features/ai`. Cette barrel réexporte aussi
 * `ai-credentials.server`, qui tire `egress.server` → `node:dns`. En dev, Vite
 * sert les modules NON bundlés : le client a donc vraiment chargé ce graphe,
 * `node:dns` a été externalisé, l'accès a LEVÉ, et la frontière d'erreur racine
 * a attrapé avant tout routage. Les QUATRE routes gardées ont cessé de rediriger
 * un visiteur déconnecté, et le nightly a rougi cinq nuits — pendant que la
 * production allait bien, son build élaguant ce que le dev server charge.
 *
 * Le défaut est INVISIBLE pour `tsc`, pour le lint et pour `build:check` : seul
 * le dev server le montre. D'où ce test statique, qui coûte une lecture de
 * fichier et rattrape la classe entière.
 */
const ROUTES_DIR = join(process.cwd(), "src", "routes");

/** Les barrels qui exportent au moins un module `*.server` à côté de composants. */
const MIXED_BARRELS = ["@/features/ai"];

function routeFiles(dir: string, out: string[] = []): string[] {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      if (entry.name !== "__tests__") routeFiles(full, out);
    } else if (/\.tsx?$/.test(full) && !full.endsWith(".gen.ts")) {
      out.push(full);
    }
  }
  return out;
}

describe("les routes n'importent pas une barrel client+serveur", () => {
  it("aucune route n'importe une barrel mixte", () => {
    const coupables: string[] = [];
    for (const file of routeFiles(ROUTES_DIR)) {
      const src = readFileSync(file, "utf8");
      for (const barrel of MIXED_BARRELS) {
        // `from "@/features/ai"` exactement — pas `@/features/ai/components/…`.
        if (src.includes(`from "${barrel}"`)) {
          coupables.push(`${relative(process.cwd(), file)} → ${barrel}`);
        }
      }
    }
    expect(coupables).toEqual([]);
  });

  it("la garde voit encore les fautes — contrôle négatif", () => {
    // Si ce jour-là la détection avait existé, elle aurait vu cette ligne.
    const faute = 'import { AiLauncher } from "@/features/ai";';
    expect(MIXED_BARRELS.some((b) => faute.includes(`from "${b}"`))).toBe(true);
    // Et elle ne confond pas l'import PROFOND, qui est le remède.
    const remede = 'import { AiLauncher } from "@/features/ai/components/ai-launcher";';
    expect(MIXED_BARRELS.some((b) => remede.includes(`from "${b}"`))).toBe(false);
  });
});
