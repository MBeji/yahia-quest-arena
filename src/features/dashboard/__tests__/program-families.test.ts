import { describe, it, expect } from "vitest";
import { buildPrograms, type ProgramParcours } from "../program-families";

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
