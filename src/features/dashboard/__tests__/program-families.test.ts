import { describe, it, expect } from "vitest";
import {
  buildLyceeYears,
  buildPrograms,
  flagshipLabel,
  lyceeYearOf,
  type ProgramParcours,
} from "../program-families";

const P = (over: Partial<ProgramParcours> & { id: string; theme_id: string }): ProgramParcours => ({
  name_fr: over.id,
  status: "available",
  is_premium: false,
  hasEntitlement: true,
  grade_cycle: null,
  grade_order: null,
  ...over,
});

const CATALOGUE: ProgramParcours[] = [
  P({
    id: "concours-9eme",
    theme_id: "ecole-tn",
    grade_cycle: "college",
    grade_order: 9,
    is_premium: true,
  }),
  P({
    id: "ecole-7eme-base",
    theme_id: "ecole-tn",
    grade_cycle: "college",
    grade_order: 7,
    status: "coming_soon",
  }),
  P({
    id: "ecole-1ere-base",
    theme_id: "ecole-tn",
    grade_cycle: "primaire",
    grade_order: 1,
    status: "coming_soon",
  }),
  P({
    id: "concours-bac",
    theme_id: "ecole-tn",
    grade_cycle: "secondaire",
    grade_order: 13,
    status: "coming_soon",
  }),
  P({ id: "arabe", theme_id: "arabe" }),
  P({ id: "anglais", theme_id: "anglais" }),
  P({ id: "francais", theme_id: "francais" }),
  P({ id: "culture-generale", theme_id: "culture-generale" }),
  P({ id: "muscle-cerveau", theme_id: "muscle-cerveau" }),
  P({ id: "ib", theme_id: "ib", status: "coming_soon" }),
];

describe("buildPrograms", () => {
  it("returns the 5 root programs in display order", () => {
    const progs = buildPrograms(CATALOGUE);
    expect(progs.map((p) => p.id)).toEqual(["tunisien", "langues", "culture", "cerveau", "ib"]);
  });

  it("groups the Tunisian program by cycle, ordered by grade", () => {
    const tn = buildPrograms(CATALOGUE).find((p) => p.id === "tunisien")!;
    expect(tn.kind).toBe("school");
    expect(tn.total).toBe(4);
    expect(tn.cycles.map((c) => c.cycle)).toEqual(["primaire", "college", "secondaire"]);
    const college = tn.cycles.find((c) => c.cycle === "college")!;
    // sorted by grade_order: 7ème before 9ème.
    expect(college.classes.map((p) => p.id)).toEqual(["ecole-7eme-base", "concours-9eme"]);
  });

  it("orders the language sub-parcours anglais → francais → arabe (config order, not input order)", () => {
    const langues = buildPrograms(CATALOGUE).find((p) => p.id === "langues")!;
    expect(langues.kind).toBe("languages");
    expect(langues.languages.map((p) => p.id)).toEqual(["anglais", "francais", "arabe"]);
  });

  it("resolves culture / cerveau to a single enter-able parcours", () => {
    const progs = buildPrograms(CATALOGUE);
    const culture = progs.find((p) => p.id === "culture")!;
    const cerveau = progs.find((p) => p.id === "cerveau")!;
    expect(culture.kind).toBe("enter");
    expect(culture.parcours?.id).toBe("culture-generale");
    expect(cerveau.parcours?.id).toBe("muscle-cerveau");
  });

  it("marks IB as coming_soon with its votable parcours", () => {
    const ib = buildPrograms(CATALOGUE).find((p) => p.id === "ib")!;
    expect(ib.kind).toBe("coming_soon");
    expect(ib.comingSoon).toBe(true);
    expect(ib.parcours?.id).toBe("ib");
  });

  it("tolerates a missing program (no IB seeded yet → empty, not crashing)", () => {
    const ib = buildPrograms(CATALOGUE.filter((p) => p.theme_id !== "ib")).find(
      (p) => p.id === "ib",
    )!;
    expect(ib.parcours).toBeNull();
    expect(ib.total).toBe(0);
  });
});

// flagshipConcours + the dashboard concours banner were removed in étude 15
// lot 2 (phase gratuite, arbitrage Q-2 — plus de focus concours). flagshipLabel
// survives: the public catalogue still compacts concours card labels with it.

describe("flagshipLabel", () => {
  it("drops the verbose 'Préparation Concours' prefix so the class reads clearly", () => {
    expect(flagshipLabel("Préparation Concours 9ème")).toBe("9ème");
    expect(flagshipLabel("Préparation Concours Bac")).toBe("Bac");
    expect(flagshipLabel("Préparation 6ème")).toBe("6ème");
    expect(flagshipLabel("9ème")).toBe("9ème");
  });
});

// ---------------------------------------------------------------------------
// Lycée drill-down (étude 16 lot 3 — D-3/D-5, R-1/R-2)
// ---------------------------------------------------------------------------

describe("buildPrograms — R-1 legacy filter", () => {
  it("drops a parcours whose grade is non-selectable (flat legacy node)", () => {
    const withLegacy: ProgramParcours[] = [
      ...CATALOGUE.map((p) =>
        p.id === "concours-bac" ? { ...p, grade_slug: "bac", grade_selectable: false } : p,
      ),
      P({
        id: "concours-bac-math",
        theme_id: "ecole-tn",
        grade_cycle: "secondaire",
        grade_order: 24,
        grade_slug: "bac-math",
        grade_selectable: true,
      }),
    ];
    const tn = buildPrograms(withLegacy).find((p) => p.id === "tunisien")!;
    const secondaire = tn.cycles.find((c) => c.cycle === "secondaire")!;
    expect(secondaire.classes.map((p) => p.id)).toEqual(["concours-bac-math"]);
  });

  it("keeps rows without the flag (grade_selectable undefined = selectable)", () => {
    const tn = buildPrograms(CATALOGUE).find((p) => p.id === "tunisien")!;
    expect(tn.total).toBe(4);
  });
});

describe("lyceeYearOf", () => {
  it("maps the 17 secondary slugs to their year and everything else to null", () => {
    expect(lyceeYearOf("1ere-sec")).toBe("1ere");
    expect(lyceeYearOf("2eme-sec")).toBe("2eme");
    expect(lyceeYearOf("2eme-sec-sciences")).toBe("2eme");
    expect(lyceeYearOf("3eme-sec-eco-gestion")).toBe("3eme");
    expect(lyceeYearOf("bac")).toBe("bac");
    expect(lyceeYearOf("bac-sciences-exp")).toBe("bac");
    expect(lyceeYearOf("9eme-base")).toBeNull();
    expect(lyceeYearOf(null)).toBeNull();
    expect(lyceeYearOf(undefined)).toBeNull();
  });
});

describe("buildLyceeYears", () => {
  const S = (id: string, slug: string, status = "coming_soon") =>
    P({
      id,
      theme_id: "ecole-tn",
      grade_cycle: "secondaire",
      grade_slug: slug,
      grade_selectable: true,
      status,
    });

  it("groups sections by year, 1ère as a direct class, seed order preserved", () => {
    const years = buildLyceeYears([
      S("ecole-1ere-sec", "1ere-sec", "available"),
      S("ecole-2eme-sec-sciences", "2eme-sec-sciences"),
      S("ecole-2eme-sec-lettres", "2eme-sec-lettres"),
      S("concours-bac-math", "bac-math", "available"),
      S("concours-bac-lettres", "bac-lettres"),
    ]);
    expect(years.map((g) => g.year)).toEqual(["1ere", "2eme", "bac"]);
    expect(years[0].direct?.id).toBe("ecole-1ere-sec");
    expect(years[0].sections).toEqual([]);
    expect(years[1].sections.map((p) => p.id)).toEqual([
      "ecole-2eme-sec-sciences",
      "ecole-2eme-sec-lettres",
    ]);
    expect(years[1].available).toBe(0);
    expect(years[2].sections.map((p) => p.id)).toEqual([
      "concours-bac-math",
      "concours-bac-lettres",
    ]);
    expect(years[2].available).toBe(1);
  });

  it("skips years absent from the catalogue and ignores non-lycée rows", () => {
    const years = buildLyceeYears([
      S("concours-bac-math", "bac-math"),
      P({ id: "concours-9eme", theme_id: "ecole-tn", grade_slug: "9eme-base" }),
    ]);
    expect(years.map((g) => g.year)).toEqual(["bac"]);
  });
});
