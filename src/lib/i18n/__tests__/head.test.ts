// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Titres d'onglet dans la langue de la requête (issue #1228,
 * `route-titles-french-only`). `head()` tourne hors de React : le titre se lit dans
 * le catalogue que `router.tsx` a chargé avant le rendu. La langue de la requête est
 * simulée ici — hors navigateur, `getShellLocale` n'a ni cookie ni en-tête.
 */
const requete = vi.hoisted(() => ({ locale: "fr" as "fr" | "en" | "ar" }));
vi.mock("../shell-locale", () => ({ getShellLocale: () => requete.locale }));

describe("pageTitle", () => {
  beforeEach(() => {
    vi.resetModules();
    requete.locale = "fr";
  });

  it("sans cookie : le titre français, celui que lisent les robots", async () => {
    const { pageTitle } = await import("../head");
    expect(pageTitle((t) => t.public.titles.programme)).toBe(
      "Programme scolaire tunisien · Na9ra Nal3ab",
    );
  });

  it("cookie arabe : libellé et marque en arabe", async () => {
    requete.locale = "ar";
    const { loadCatalogue } = await import("../catalogues");
    const ar = await loadCatalogue("ar");
    const { pageTitle, headCatalogue } = await import("../head");
    expect(headCatalogue()).toBe(ar);
    expect(pageTitle((t) => t.common.leaderboard)).toBe(`${ar.common.leaderboard} · نقرا نلعب`);
    expect(pageTitle((t) => t.common.leaderboard)).not.toContain("Classement");
  });

  it("cookie anglais : libellé anglais, marque latine", async () => {
    requete.locale = "en";
    const { loadCatalogue } = await import("../catalogues");
    await loadCatalogue("en");
    const { pageTitle } = await import("../head");
    expect(pageTitle((t) => t.public.titles.suivi)).toBe("My child's progress · Na9ra Nal3ab");
  });

  it("catalogue absent (chunk en échec) : français entier, jamais un mélange", async () => {
    requete.locale = "ar";
    const { pageTitle, headCatalogue } = await import("../head");
    const { loadedCatalogue } = await import("../catalogues");
    expect(headCatalogue()).toBe(loadedCatalogue("fr"));
    expect(pageTitle((t) => t.common.leaderboard)).toBe("Classement · Na9ra Nal3ab");
  });
});
