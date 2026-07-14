import { describe, it, expect } from "vitest";
import {
  BLOCK_LABELS,
  DIRECTIVE_TYPES,
  asContentLang,
  isDirectiveType,
  markerBlockType,
  type LessonBlockType,
} from "@/shared/lib/lesson-blocks";

describe("lesson-blocks", () => {
  describe("BLOCK_LABELS", () => {
    it("libelle chaque type de bloc dans les trois langues de contenu", () => {
      const types: LessonBlockType[] = [...DIRECTIVE_TYPES, "insight"];
      for (const type of types) {
        for (const lang of ["fr", "en", "ar"] as const) {
          expect(BLOCK_LABELS[type]?.[lang], `${type}/${lang}`).toBeTruthy();
        }
      }
    });

    it("n'expose aucun libellé orphelin (la table close ne dérive pas)", () => {
      const known = new Set<string>([...DIRECTIVE_TYPES, "insight"]);
      expect(Object.keys(BLOCK_LABELS).filter((k) => !known.has(k))).toEqual([]);
    });
  });

  describe("isDirectiveType", () => {
    it("accepte les types authorables et rejette le reste (R-6, liste close)", () => {
      expect(isDirectiveType("definition")).toBe(true);
      expect(isDirectiveType("piege")).toBe(true);
      expect(isDirectiveType("nawak")).toBe(false);
      // `insight` naît d'une promotion `> 💡` : il n'est PAS authorable en directive.
      expect(isDirectiveType("insight")).toBe(false);
    });
  });

  describe("markerBlockType", () => {
    it("reconnaît les quatre callouts normatifs du style-guide", () => {
      expect(markerBlockType("⚠️ piège")).toEqual({ type: "piege", rest: "piège" });
      expect(markerBlockType("🗡️ astuce")).toEqual({ type: "astuce", rest: "astuce" });
      expect(markerBlockType("💡 idée")).toEqual({ type: "insight", rest: "idée" });
      expect(markerBlockType("🏆 clôture")).toEqual({ type: "retenir", rest: "clôture" });
    });

    it("tolère l'absence du sélecteur de variante (U+FE0F)", () => {
      expect(markerBlockType("⚠ sans variante")).toEqual({
        type: "piege",
        rest: "sans variante",
      });
    });

    it("rend null sur une citation ordinaire — la promotion est conservatrice", () => {
      expect(markerBlockType("Une citation.")).toBeNull();
      expect(markerBlockType("🎯 emoji non normatif")).toBeNull();
      expect(markerBlockType("")).toBeNull();
    });
  });

  describe("asContentLang", () => {
    it("réduit `subjects.content_language` (texte libre en base) à une langue connue", () => {
      expect(asContentLang("ar", "fr")).toBe("ar");
      expect(asContentLang("en", "fr")).toBe("en");
      expect(asContentLang(null, "ar")).toBe("ar");
      expect(asContentLang("klingon", "fr")).toBe("fr");
    });
  });
});
