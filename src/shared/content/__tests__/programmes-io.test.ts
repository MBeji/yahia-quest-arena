import { describe, it, expect, afterAll } from "vitest";
import { mkdtempSync, mkdirSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

import {
  PROGRAMMES_REL_CANDIDATES,
  resolveProgrammesRel,
} from "../../../../scripts/content/programmes-io.ts";

/**
 * L'arbre `programmes-officiels/` déménage du skill vers `content/` (étude 32, lot 5). Il vit
 * dans l'AUTRE dépôt, donc le déplacement ne peut pas être atomique : le moteur doit connaître
 * les deux emplacements le temps de la bascule. Ces tests fixent l'ordre de préférence et le
 * comportement quand rien n'existe — c'est là que se cache le faux « rien à faire » redouté.
 */
const temps: string[] = [];
const sandbox = (): string => {
  const dir = mkdtempSync(join(tmpdir(), "programmes-io-"));
  temps.push(dir);
  return dir;
};
afterAll(() => {
  for (const dir of temps) rmSync(dir, { recursive: true, force: true });
});

const NEUF = "content/programmes-officiels";
const LEGACY = ".claude/skills/content-ecole-tn/references/programmes-officiels";

describe("resolveProgrammesRel", () => {
  it("déclare les deux emplacements, le neuf en premier", () => {
    expect([...PROGRAMMES_REL_CANDIDATES]).toEqual([NEUF, LEGACY]);
  });

  it("prend l'emplacement LEGACY tant que le corpus n'a pas bougé", () => {
    const root = sandbox();
    mkdirSync(join(root, LEGACY), { recursive: true });
    expect(resolveProgrammesRel(root)).toBe(LEGACY);
  });

  it("prend le NEUF dès qu'il existe", () => {
    const root = sandbox();
    mkdirSync(join(root, NEUF), { recursive: true });
    expect(resolveProgrammesRel(root)).toBe(NEUF);
  });

  it("préfère le NEUF quand les deux coexistent — le temps d'une bascule", () => {
    // Cas réel du jour de la migration : le corpus porte le nouveau chemin, un clone en
    // retard porte encore l'ancien. Sans ordre fixe, deux sessions liraient deux registres.
    const root = sandbox();
    mkdirSync(join(root, LEGACY), { recursive: true });
    mkdirSync(join(root, NEUF), { recursive: true });
    expect(resolveProgrammesRel(root)).toBe(NEUF);
  });

  it("rend le NEUF quand aucun n'existe — le message doit envoyer là où l'arbre DOIT être", () => {
    // Ce cas est le normal dans le dépôt public : le registre vit au privé. L'important est
    // que l'erreur nomme la destination, pas un chemin que plus personne ne doit créer.
    expect(resolveProgrammesRel(sandbox())).toBe(NEUF);
  });
});
