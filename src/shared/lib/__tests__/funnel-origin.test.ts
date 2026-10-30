// @vitest-environment node
import { describe, it, expect, beforeEach, vi } from "vitest";

/**
 * Étude 38 lot 0 — D'OÙ VENAIT LE VISITEUR QUI CRÉE UN COMPTE.
 *
 * Le module garde son état dans une variable de module : chaque test repart d'un
 * module NEUF (`vi.resetModules`), sinon l'ordre des tests déciderait du résultat.
 */
async function fresh() {
  vi.resetModules();
  return import("../funnel-origin");
}

describe("funnel-origin", () => {
  let mod: Awaited<ReturnType<typeof fresh>>;
  beforeEach(async () => {
    mod = await fresh();
  });

  it("ne sait rien avant la première page : un lien direct vers /auth n'est pas du contenu", () => {
    expect(mod.isFromContent(null)).toBe(false);
  });

  it.each([
    "/chapitre/abc",
    "/matiere/math-9eme",
    "/exercice/0b8f",
    "/niveau/ecole-1ere-base",
    "/programme",
    "/programme?cycle=college",
    "/programme/lycee/3eme",
    "/extras",
  ])("%s est du contenu", (path) => {
    mod.notePageForFunnel(path);
    expect(mod.isFromContent(null)).toBe(true);
  });

  it.each(["/", "/suivi", "/conditions", "/confidentialite", "/dashboard", "/programmes-speciaux"])(
    "%s n'est pas du contenu",
    (path) => {
      mod.notePageForFunnel(path);
      expect(mod.isFromContent(null)).toBe(false);
    },
  );

  it("traverser le tunnel n'efface pas la page d'où l'on venait", () => {
    mod.notePageForFunnel("/chapitre/c1");
    for (const funnel of ["/auth", "/auth?mode=signup", "/login", "/signup", "/auth#x"]) {
      mod.notePageForFunnel(funnel);
      expect(mod.isFromContent(null), funnel).toBe(true);
    }
  });

  it("un retour gardé répond AVANT la dernière page : c'est là qu'on ramène le visiteur", () => {
    mod.notePageForFunnel("/");
    expect(mod.isFromContent("/chapitre/c1")).toBe(true);
    mod.notePageForFunnel("/chapitre/c1");
    expect(mod.isFromContent("/dashboard")).toBe(false);
  });

  it("une page qui n'est pas du contenu efface l'origine", () => {
    mod.notePageForFunnel("/chapitre/c1");
    mod.notePageForFunnel("/");
    expect(mod.isFromContent(null)).toBe(false);
  });

  it("un chemin qui ressemble au tunnel sans l'être n'est PAS ignoré", () => {
    mod.notePageForFunnel("/chapitre/c1");
    mod.notePageForFunnel("/authors");
    expect(mod.isFromContent(null)).toBe(false);
  });
});
