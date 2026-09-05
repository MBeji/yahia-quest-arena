import { describe, it, expect } from "vitest";
import { join } from "node:path";

import { PROGRAMMES_DIR, PROGRAMMES_REL } from "../../../../scripts/content/programmes-io.ts";
import { CORPUS_JSON_REL } from "../../../../scripts/content/check-manuel-links.ts";

/**
 * Le registre de transcription vit sous `content/` depuis l'étude 32 (lot 5) — il était rangé
 * sous `.claude/skills/…/references/`, c'est-à-dire un registre de DONNÉES dans un dossier
 * d'INSTRUCTIONS, ce qui imposait un second symlink à la recette locale comme à la CI.
 *
 * Ces tests tiennent la seule chose qui compte encore : le chemin est déclaré UNE fois et tous
 * ses dérivés en descendent. Trois fichiers en gardaient chacun leur copie, et c'est ce qui
 * faisait du déménagement un chantier à quatre fichiers plutôt qu'à un.
 */
describe("le chemin du registre de transcription", () => {
  it("est déclaré une seule fois, sous `content/`", () => {
    expect(PROGRAMMES_REL).toBe("content/programmes-officiels");
  });

  it("ne porte plus le chemin de compatibilité de la bascule", () => {
    // Deux emplacements maintenus après le déménagement seraient un shim, et le premier
    // lecteur qui en trouve deux ne sait plus lequel fait foi.
    expect(PROGRAMMES_REL).not.toContain(".claude/skills");
    expect(PROGRAMMES_DIR).not.toContain(".claude/skills");
  });

  it("est la racine de tout ce qui en dérive, sans le recopier", () => {
    expect(PROGRAMMES_DIR.endsWith(join("content", "programmes-officiels"))).toBe(true);
    expect(CORPUS_JSON_REL).toBe(join(PROGRAMMES_REL, "suivi/corpus-cnp.json"));
  });
});
