// @vitest-environment node
import { describe, it, expect } from "vitest";
import { isImmersiveAppPath, isImmersivePublicPath } from "../immersive-paths";

describe("écrans immersifs — là où la barre d'onglets se retire", () => {
  it.each(["/quest/abc", "/onboarding", "/examen/blanc-1", "/lesson/ch-1"])(
    "coquille connectée : %s est immersif",
    (path) => {
      expect(isImmersiveAppPath(path)).toBe(true);
    },
  );

  // `/examens` est la LISTE des examens : sans la barre oblique de `examen/`, elle perdait
  // ses onglets. Le hall du donjon et un duel gardent les leurs (étude 15, D-4).
  it.each(["/dashboard", "/examens", "/dungeon", "/duel", "/duel/d1", "/arene", "/parcours"])(
    "coquille connectée : %s garde sa navigation",
    (path) => {
      expect(isImmersiveAppPath(path)).toBe(false);
    },
  );

  it.each(["/exercice/abc", "/test-de-niveau/session-1"])(
    "coquille publique : %s est immersif",
    (path) => {
      expect(isImmersivePublicPath(path)).toBe(true);
    },
  );

  // L'ENTRÉE du test de niveau (choisir sa classe) n'est pas la passation.
  it.each([
    "/",
    "/programme",
    "/programme/lycee/bac",
    "/niveau/ecole-7eme-base",
    "/matiere/math-7eme",
    "/chapitre/c1",
    "/extras",
    "/test-de-niveau",
  ])("coquille publique : %s garde sa navigation", (path) => {
    expect(isImmersivePublicPath(path)).toBe(false);
  });
});
