import { describe, it, expect } from "vitest";
import { auditLesson, isSpatialChapter } from "../../../../scripts/content/qa-checks.ts";

/**
 * Gate contenu des LEÇONS — étude 18, lot 4.
 *
 * Jusqu'ici `content:qa` ne lisait QUE les questions : les 541 `cours.md` / `resume.md`
 * étaient hors de tout contrôle déterministe. C'est précisément pour cela que la dérive
 * « aucune figure en géométrie » a pu durer sans qu'aucune CI ne bronche — et que le
 * premier passage a révélé 46 violations de notation dans 22 fichiers.
 */

const SVG = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>';
const errors = (md: string, opts?: { spatial?: boolean }) =>
  auditLesson(md, "test/chapitre/cours", opts).filter((f) => f.level === "error");
const warns = (md: string, opts?: { spatial?: boolean }) =>
  auditLesson(md, "test/chapitre/cours", opts).filter((f) => f.level === "warn");

describe("auditLesson", () => {
  describe("directives `:::`", () => {
    it("accepte les huit types authorables", () => {
      expect(errors("::: definition\nUn énoncé.\n:::")).toEqual([]);
      expect(errors(`::: figure Le triangle ABC\n${SVG}\n:::`)).toEqual([]);
    });

    it("refuse un type inconnu", () => {
      const flags = errors("::: nawak\nDu texte.\n:::");
      expect(flags).toHaveLength(1);
      expect(flags[0].msg).toMatch(/unknown block directive/);
    });

    it("refuse une directive jamais fermée", () => {
      const flags = errors("::: piege\nJamais fermé.");
      expect(flags.some((f) => /never closed/.test(f.msg))).toBe(true);
    });

    it("refuse un `:::` orphelin", () => {
      const flags = errors("Du texte.\n:::");
      expect(flags.some((f) => /stray/.test(f.msg))).toBe(true);
    });

    it("refuse une `::: figure` sans légende — toute figure de cours est légendée (R-9)", () => {
      const flags = errors(`::: figure\n${SVG}\n:::`);
      expect(flags.some((f) => /no caption/.test(f.msg))).toBe(true);
    });
  });

  describe("figures", () => {
    it("refuse un cours qui DÉSIGNE une figure sans en porter aucune — le contrôle le plus discriminant", () => {
      // L'élève est envoyé vers une image qui n'existe pas.
      expect(
        errors("Observe le triangle ci-dessous.").some((f) => /points at a figure/.test(f.msg)),
      ).toBe(true);
      expect(
        errors("لاحظ المثلّث في الشكل المجاور.").some((f) => /points at a figure/.test(f.msg)),
      ).toBe(true);
    });

    it("laisse passer la même prose dès qu'une figure est là", () => {
      expect(errors(`Observe le triangle ci-dessous.\n\n${SVG}`)).toEqual([]);
    });

    it("avertit sur un chapitre spatial dépourvu de tout dessin (axe 5)", () => {
      const flags = warns("Le théorème de Thalès énonce que…", { spatial: true });
      expect(flags.some((f) => /no figure at all/.test(f.msg))).toBe(true);
    });

    it("n'avertit pas quand le chapitre spatial est illustré", () => {
      expect(warns(`Thalès.\n\n${SVG}`, { spatial: true })).toEqual([]);
    });

    it("refuse un `<svg>` sans viewBox — il s'effondrerait au rendu", () => {
      const flags = errors("<svg><circle cx='5' cy='5' r='4'/></svg>");
      expect(flags.some((f) => /viewBox/.test(f.msg))).toBe(true);
    });
  });

  describe("notation — ces contrôles n'avaient JAMAIS tourné sur une leçon", () => {
    it("refuse la virgule arabe comme séparateur dans une notation (46 cas trouvés au 1er passage)", () => {
      const flags = errors("الموضع (2، 3) في الشبكة.");
      expect(flags.some((f) => /Arabic comma/.test(f.msg))).toBe(true);
    });

    it("accepte le point-virgule, le séparateur normatif", () => {
      expect(errors("الموضع (2 ; 3) في الشبكة.")).toEqual([]);
    });

    it("laisse la virgule arabe tranquille dans la PROSE — la règle ne vise que la notation", () => {
      expect(errors("هذا مثلّث، وهذا مربّع.")).toEqual([]);
    });
  });

  describe("isSpatialChapter", () => {
    it("reconnaît les familles de FORMES", () => {
      for (const slug of [
        "08-thales",
        "09-triangle-rectangle-trigo",
        "10-angles-cercle",
        "11-vecteurs-translation",
        "13-geometrie-espace",
        "23-solides-cube-pave",
        "17-perimetre",
        // Deux familles que la première version de la liste laissait passer, découvertes
        // en illustrant math-1ere-sec : une rotation et des sections de solides.
        "07-quart-tour",
        "08-sections-planes",
        // Le primaire (6 ans) — les plus visuels de tous, ajoutés le 2026-07-14 après
        // le signalement de «التموقع في الفضاء» resté sans la moindre image.
        "07-reperage-espace",
        "06-formes-geometriques",
        "10-lignes",
        "07-formes-lignes",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(true);
      }
    });

    it("reconnaît les familles GRAPHIQUES — une fonction sans sa droite décrit ce qu'il fallait montrer", () => {
      for (const slug of [
        "12-fonctions-lineaires",
        "14-fonctions-affines",
        "06-fonctions-lineaires-affines",
        "16-exploitation-information",
        "07-statistiques",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(true);
      }
    });

    it("ne réclame pas de figure là où la notion n'est ni spatiale ni graphique", () => {
      for (const slug of [
        "01-nombres-reels",
        "03-calcul-litteral",
        "09-activites-numeriques-i",
        "11-activites-algebriques",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(false);
      }
    });
  });
});
