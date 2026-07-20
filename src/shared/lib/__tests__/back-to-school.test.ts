/**
 * Fenêtre de rentrée — étude 22, R-4.
 *
 * Les cas qui comptent sont les BORNES et le passage d'année : c'est là qu'une bannière se met
 * à mentir, soit en s'affichant hors saison, soit en reproposant une promotion à quelqu'un qui
 * vient de choisir sa classe.
 */
import { describe, it, expect } from "vitest";
import {
  isWithinBackToSchoolWindow,
  schoolYearKey,
  schoolYearStartUtc,
  shouldOfferPromotion,
  resolvePromotionTarget,
  type PromotionGrade,
} from "../back-to-school";

const at = (iso: string) => new Date(iso);

const gTheme = (
  id: string,
  slug: string,
  name_fr: string,
  display_order: number,
  theme_id: string,
  is_selectable = true,
): PromotionGrade => ({ id, slug, name_fr, display_order, theme_id, is_selectable });

const g = (id: string, slug: string, name_fr: string, order: number, selectable = true) =>
  gTheme(id, slug, name_fr, order, "ecole-tn", selectable);

describe("isWithinBackToSchoolWindow", () => {
  it("s'ouvre le 1er septembre et se ferme le 31 octobre, bornes incluses", () => {
    expect(isWithinBackToSchoolWindow(at("2026-09-01T00:00:00Z"))).toBe(true);
    expect(isWithinBackToSchoolWindow(at("2026-10-31T23:59:00Z"))).toBe(true);
  });

  it("reste fermée la veille et le lendemain", () => {
    expect(isWithinBackToSchoolWindow(at("2026-08-31T23:59:00Z"))).toBe(false);
    expect(isWithinBackToSchoolWindow(at("2026-11-01T00:00:00Z"))).toBe(false);
  });

  it("est fermée le reste de l'année", () => {
    expect(isWithinBackToSchoolWindow(at("2027-01-15T12:00:00Z"))).toBe(false);
    expect(isWithinBackToSchoolWindow(at("2027-06-30T12:00:00Z"))).toBe(false);
  });
});

describe("schoolYearStartUtc / schoolYearKey", () => {
  it("en octobre, l'année scolaire a commencé en septembre de la même année civile", () => {
    expect(schoolYearStartUtc(at("2026-10-15T12:00:00Z")).toISOString()).toBe(
      "2026-09-01T00:00:00.000Z",
    );
    expect(schoolYearKey(at("2026-10-15T12:00:00Z"))).toBe("2026-2027");
  });

  it("en janvier, elle a commencé en septembre de l'année civile PRÉCÉDENTE", () => {
    // Le piège : sans cette bascule, un élève ayant choisi sa classe en octobre 2026 se
    // verrait reproposer une promotion en janvier 2027.
    expect(schoolYearStartUtc(at("2027-01-15T12:00:00Z")).toISOString()).toBe(
      "2026-09-01T00:00:00.000Z",
    );
    expect(schoolYearKey(at("2027-01-15T12:00:00Z"))).toBe("2026-2027");
  });

  it("le 31 août appartient encore à l'année scolaire précédente", () => {
    expect(schoolYearKey(at("2026-08-31T12:00:00Z"))).toBe("2025-2026");
  });

  it("change de saison le 1er septembre — la clé de rejet ne survit pas d'une année à l'autre", () => {
    expect(schoolYearKey(at("2026-09-01T00:00:00Z"))).toBe("2026-2027");
  });
});

describe("shouldOfferPromotion", () => {
  const inWindow = at("2026-09-10T12:00:00Z");

  it("ne propose rien hors de la fenêtre, même si le choix est ancien", () => {
    expect(
      shouldOfferPromotion({
        parcoursSetAt: "2024-03-01T00:00:00Z",
        now: at("2027-02-01T12:00:00Z"),
      }),
    ).toBe(false);
  });

  it("propose quand le choix précède la rentrée courante", () => {
    expect(shouldOfferPromotion({ parcoursSetAt: "2025-09-15T00:00:00Z", now: inWindow })).toBe(
      true,
    );
  });

  it("ne propose RIEN à qui vient de choisir sa classe cette rentrée", () => {
    // Le cas le plus embarrassant : proposer de changer de classe le lendemain du choix.
    expect(shouldOfferPromotion({ parcoursSetAt: "2026-09-05T00:00:00Z", now: inWindow })).toBe(
      false,
    );
  });

  it("traite un horodatage absent comme antérieur (comptes d'avant la migration)", () => {
    expect(shouldOfferPromotion({ parcoursSetAt: null, now: inWindow })).toBe(true);
    expect(shouldOfferPromotion({ parcoursSetAt: undefined, now: inWindow })).toBe(true);
  });

  it("traite une date illisible comme antérieure plutôt que de se taire", () => {
    // Une donnée corrompue ne doit pas priver l'élève de sa rentrée ; l'action reste un choix.
    expect(shouldOfferPromotion({ parcoursSetAt: "pas-une-date", now: inWindow })).toBe(true);
  });

  it("accepte indifféremment une Date ou une chaîne ISO", () => {
    expect(shouldOfferPromotion({ parcoursSetAt: at("2025-09-15T00:00:00Z"), now: inWindow })).toBe(
      true,
    );
  });
});

describe("resolvePromotionTarget", () => {
  // Le catalogue réel, réduit à ce qui compte : les années plates, les trois devenues
  // non sélectionnables à l'ouverture du lycée, et quelques nœuds de section.
  const grades = [
    g("g8", "8eme-base", "8ème année de base", 8),
    g("g9", "9eme-base", "9ème année de base", 9),
    g("g10", "1ere-sec", "1ère année secondaire", 10),
    g("g11", "2eme-sec", "2ème année secondaire", 11, false),
    g("g12", "3eme-sec", "3ème année secondaire", 12, false),
    g("g13", "bac", "Baccalauréat", 13, false),
    g("g14", "2eme-sec-sciences", "2ème Sciences", 14),
    g("g15", "2eme-sec-lettres", "2ème Lettres", 15),
    g("g18", "3eme-sec-math", "3ème Mathématiques", 18),
    g("g24", "bac-math", "Bac Mathématiques", 24),
  ];

  it("propose la classe suivante en un clic quand elle est directement choisissable", () => {
    expect(resolvePromotionTarget(grades, "g8")).toEqual({
      gradeId: "g9",
      gradeSlug: "9eme-base",
      gradeName: "9ème année de base",
      isSectionDrilldown: false,
    });
  });

  it("emmène choisir sa SECTION quand l'année suivante se décline", () => {
    // De 1ère secondaire, on entre en 2ème — qui a quatre sections : la bannière ne peut pas
    // décider à la place de l'élève.
    expect(resolvePromotionTarget(grades, "g10")).toEqual({
      gradeId: "g11",
      gradeSlug: "2eme-sec",
      gradeName: "2ème année secondaire",
      isSectionDrilldown: true,
    });
  });

  it("depuis une SECTION, passe à l'année suivante — pas à la section d'à côté", () => {
    // Le piège du display_order : les seize sections se suivent, donc un tri naïf enverrait
    // un élève de 2ème Sciences (14) en 2ème Lettres (15).
    expect(resolvePromotionTarget(grades, "g14")).toEqual({
      gradeId: "g12",
      gradeSlug: "3eme-sec",
      gradeName: "3ème année secondaire",
      isSectionDrilldown: true,
    });
  });

  it("ne propose rien depuis une classe terminale de bac (Q-3)", () => {
    expect(resolvePromotionTarget(grades, "g24")).toBeNull();
  });

  it("ne propose rien sans grade — un parcours libre n'a pas de rentrée", () => {
    expect(resolvePromotionTarget(grades, null)).toBeNull();
    expect(resolvePromotionTarget(grades, "inconnu")).toBeNull();
  });

  it("ne franchit jamais la frontière d'un thème", () => {
    const autre = [...grades, gTheme("x1", "niveau-1", "Niveau 1", 1, "culture-generale")];
    expect(resolvePromotionTarget(autre, "x1")).toBeNull();
  });
});
