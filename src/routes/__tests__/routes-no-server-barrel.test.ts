// @vitest-environment node
import { readFileSync, readdirSync } from "node:fs";
import { join, relative } from "node:path";
import { describe, expect, it } from "vitest";

/**
 * PERSONNE n'importe une barrel qui mêle composants client et modules serveur.
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
 * Ce que ça a coûté UNE SECONDE FOIS, et pourquoi le périmètre a changé : la
 * garde ne regardait que `src/routes/**`. Or l'arête vivante ne partait pas
 * d'une route — `features/tutor/digest.server.ts` importait la barrel, et
 * `dashboard.tsx` importe le composant `tutor-digest` qui l'importe. La suite
 * e2e authentifiée est restée à 32 échecs stables pendant six nuits et une
 * dizaine de merges (#909). Le périmètre couvre donc aussi `src/features/**`,
 * ce qui est de toute façon ce qu'AGENTS.md demande : « Features never import
 * other features — share via `src/shared/` ».
 *
 * Le défaut est INVISIBLE pour `tsc`, pour le lint et pour `build:check` : seul
 * le dev server le montre. D'où ce test statique, qui coûte une lecture de
 * fichier et rattrape la classe entière. Son compagnon
 * `client-graph-no-node-builtins.test.ts` ferme la même classe par le GRAPHE,
 * sans dépendre du nom d'une barrel.
 */
const SCANNED = [join(process.cwd(), "src", "routes"), join(process.cwd(), "src", "features")];

/** Les barrels qui exportent au moins un module `*.server` à côté de composants. */
const MIXED_BARRELS = ["@/features/ai"];

/**
 * Le fichier de la barrel elle-même : son en-tête cite son propre chemin pour
 * dire de ne pas l'importer. Le détecteur lit le fichier brut (c'est ce qui le
 * rend infaillible sur la forme), il faut donc l'exclure explicitement.
 */
const SOI_MEME = new Set(
  MIXED_BARRELS.flatMap((b) => {
    const dossier = join(process.cwd(), b.replace("@/", "src/"));
    return [join(dossier, "index.ts"), join(dossier, "index.tsx")];
  }),
);

function tsFiles(dir: string, out: string[] = []): string[] {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      if (entry.name !== "__tests__") tsFiles(full, out);
    } else if (/\.tsx?$/.test(full) && !full.endsWith(".gen.ts")) {
      out.push(full);
    }
  }
  return out;
}

describe("personne n'importe une barrel client+serveur", () => {
  it("aucune route ni aucune feature n'importe une barrel mixte", () => {
    const coupables: string[] = [];
    for (const dir of SCANNED) {
      for (const file of tsFiles(dir)) {
        if (SOI_MEME.has(file)) continue;
        const src = readFileSync(file, "utf8");
        for (const barrel of MIXED_BARRELS) {
          // `from "@/features/ai"` exactement — pas `@/features/ai/components/…`.
          if (src.includes(`from "${barrel}"`)) {
            coupables.push(`${relative(process.cwd(), file)} → ${barrel}`);
          }
        }
      }
    }
    expect(coupables).toEqual([]);
  });

  it("la garde voit encore les fautes — contrôle négatif", () => {
    // Si ce jour-là la détection avait existé, elle aurait vu cette ligne.
    const faute = 'import { AiLauncher } from "@/features/ai";';
    expect(MIXED_BARRELS.some((b) => faute.includes(`from "${b}"`))).toBe(true);
    // Et elle ne confond pas l'import PROFOND avec la barrel : cette assertion
    // prouve la SPÉCIFICITÉ du détecteur, elle n'affirme PAS qu'un import
    // profond suffit à sortir `node:*` du graphe — c'est le travail de
    // `client-graph-no-node-builtins.test.ts`, et #909 a montré qu'il ne suffit
    // pas.
    const importProfond = 'import { AiLauncher } from "@/features/ai/components/ai-launcher";';
    expect(MIXED_BARRELS.some((b) => importProfond.includes(`from "${b}"`))).toBe(false);
  });
});
