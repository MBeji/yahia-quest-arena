// @vitest-environment node
import { describe, expect, it, vi } from "vitest";

import { placementTranslations } from "@/lib/i18n/placement";
import { placementBandFor } from "@/shared/constants/placement";

import {
  buildShareText,
  formatScoreOn20,
  placementShareUrl,
  sharePlacementText,
  splitChapters,
} from "../placement-bilan";

/**
 * Étude 39 — le bilan côté client : il lit, il ne juge pas. Ce qu'on épingle ici :
 *   - le miroir client des bandes (R-6) dit la même chose aux bornes que `placement_band` ;
 *   - ce qui tient vient d'abord, puis à revoir, dans l'ordre du programme (R-7) ;
 *   - le texte de partage porte la note au-dessus du plancher, la tait en dessous (RISK-2), et
 *     ouvre LE MÊME test (US-3) ;
 *   - partager tombe sur la copie quand la feuille de partage manque, et n'échoue jamais.
 */
const s = placementTranslations("fr").placement.summary;

describe("placementBandFor — le miroir des quatre bandes (R-6)", () => {
  it("classe aux bornes exactement comme le SQL", () => {
    expect(placementBandFor(20)).toBe("solide");
    expect(placementBandFor(16)).toBe("solide");
    expect(placementBandFor(15.9)).toBe("en-route");
    expect(placementBandFor(12)).toBe("en-route");
    expect(placementBandFor(11.9)).toBe("consolider");
    expect(placementBandFor(8)).toBe("consolider");
    expect(placementBandFor(7.9)).toBe("reprendre");
    expect(placementBandFor(0)).toBe("reprendre");
  });

  it("une note illisible est la bande la plus prudente, jamais une exception", () => {
    expect(placementBandFor(Number.NaN)).toBe("reprendre");
  });
});

describe("splitChapters — ce qui tient d'abord (R-7)", () => {
  it("sépare et range dans l'ordre du programme", () => {
    const { held, toReview } = splitChapters([
      {
        chapterId: "c3",
        title: "Trois",
        displayOrder: 3,
        correct: 0,
        total: 1,
        held: false,
        hasLesson: true,
      },
      {
        chapterId: "c1",
        title: "Un",
        displayOrder: 1,
        correct: 2,
        total: 2,
        held: true,
        hasLesson: true,
      },
      {
        chapterId: "c2",
        title: "Deux",
        displayOrder: 2,
        correct: 1,
        total: 2,
        held: false,
        hasLesson: false,
      },
    ]);
    expect(held.map((c) => c.chapterId)).toEqual(["c1"]);
    expect(toReview.map((c) => c.chapterId)).toEqual(["c2", "c3"]);
  });
});

describe("formatScoreOn20 — la note comme on la dit", () => {
  it("entier sans décimale, sinon une décimale, virgule en français", () => {
    expect(formatScoreOn20(14, "fr")).toBe("14");
    expect(formatScoreOn20(13.3, "fr")).toBe("13,3");
    expect(formatScoreOn20(13.3, "en")).toBe("13.3");
    expect(formatScoreOn20(13.3, "ar")).toBe("13.3");
    expect(formatScoreOn20(16.66, "en")).toBe("16.7");
  });
});

describe("buildShareText — la phrase partagée (US-3, RISK-2)", () => {
  const facts = {
    scoreOn20: 14,
    subjectName: "Mathématiques",
    gradeName: "9ᵉ année",
    subjectId: "math",
    percentile: null,
  };

  it("porte la note, la matière, la classe et le lien qui rouvre le même test", () => {
    const text = buildShareText(facts, s, "fr");
    expect(text).toContain("14/20");
    expect(text).toContain("Mathématiques");
    expect(text).toContain("9ᵉ année");
    expect(text).toContain("https://www.na9ranal3ab.tn/test-de-niveau?matiere=math");
  });

  it("sous 8/20, tait le chiffre — l'élève peut l'ajouter lui-même", () => {
    const text = buildShareText({ ...facts, scoreOn20: 6 }, s, "fr");
    expect(text).not.toContain("6/20");
    expect(text).toContain("test de niveau");
    expect(text).toContain("?matiere=math");
  });

  it("ajoute le rang quand il existe, et seulement au-dessus du plancher", () => {
    expect(buildShareText({ ...facts, percentile: 72 }, s, "fr")).toMatch(
      /^Mieux que 72 % des élèves/,
    );
    expect(buildShareText({ ...facts, scoreOn20: 5, percentile: 10 }, s, "fr")).not.toContain(
      "10 %",
    );
  });

  it("une matière libre sans classe n'affiche pas de parenthèses vides", () => {
    const text = buildShareText({ ...facts, gradeName: null }, s, "fr");
    expect(text).not.toContain("()");
  });

  it("le lien de partage encode l'identifiant de matière", () => {
    expect(placementShareUrl("a b")).toBe(
      "https://www.na9ranal3ab.tn/test-de-niveau?matiere=a%20b",
    );
  });
});

describe("sharePlacementText — la feuille de partage, sinon la copie, jamais une erreur", () => {
  it("préfère la feuille de partage de l'appareil", async () => {
    const share = vi.fn().mockResolvedValue(undefined);
    const writeText = vi.fn();
    expect(await sharePlacementText("x", { share, clipboard: { writeText } } as never)).toBe(
      "share",
    );
    expect(writeText).not.toHaveBeenCalled();
  });

  it("retombe sur la copie quand la feuille est refusée ou absente", async () => {
    const share = vi.fn().mockRejectedValue(new Error("AbortError"));
    const writeText = vi.fn().mockResolvedValue(undefined);
    expect(await sharePlacementText("x", { share, clipboard: { writeText } } as never)).toBe(
      "copy",
    );
    expect(await sharePlacementText("x", { clipboard: { writeText } } as never)).toBe("copy");
  });

  it("sans rien, ne fait rien — et le dit", async () => {
    expect(await sharePlacementText("x", undefined)).toBe("none");
    expect(await sharePlacementText("x", {} as never)).toBe("none");
  });
});
