import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { competencyRegistrySchema, findCompetencyCycle, questionSchema } from "../schema.ts";
import {
  buildCompetencyRegistryMigrationSql,
  buildMigrationSql,
  competencyId,
} from "../sql-builder.ts";
import { ContentValidationError, loadCompetencyRegistries } from "../loader.ts";
import {
  auditCompetencyRefs,
  type CompetencyVocabulary,
} from "../../../../scripts/content/qa-checks.ts";
import type { CompetencyRegistry, LoadedSubject } from "../schema.ts";

// Knowledge graph, lot 1 (étude 07): the competency registries + the per-question
// `competencies` field + their compilation (registry migration, junction rows).

const entry = (id: string, prereqs: string[] = []) => ({
  id,
  labels: { fr: "Libellé", en: "Label", ar: "تسمية" },
  prereqs,
});

// `unknown`-friendly on purpose: negative fixtures feed safeParse with bad shapes.
const registry = (over: Record<string, unknown> = {}): unknown => ({
  family: "math",
  subjectPrefixes: ["math"],
  competencies: [entry("math.frac.sens"), entry("math.frac.add-sous", ["math.frac.sens"])],
  ...over,
});

describe("schema — competency registry (étude 07 D-1, R-1/R-3)", () => {
  it("accepts a well-formed family registry", () => {
    expect(competencyRegistrySchema.safeParse(registry()).success).toBe(true);
  });

  it("rejects a non-namespaced or mis-segmented id", () => {
    for (const bad of ["thales", "math.thales", "math.geo.thales.direct", "math.geo.Thalès"]) {
      expect(
        competencyRegistrySchema.safeParse(registry({ competencies: [entry(bad)] })).success,
      ).toBe(false);
    }
  });

  it("rejects an id outside the family namespace", () => {
    expect(
      competencyRegistrySchema.safeParse(registry({ competencies: [entry("physique.mec.forces")] }))
        .success,
    ).toBe(false);
  });

  it("rejects a missing language label", () => {
    const bad = registry({
      competencies: [{ id: "math.frac.sens", labels: { fr: "f", en: "e" }, prereqs: [] }],
    });
    expect(competencyRegistrySchema.safeParse(bad).success).toBe(false);
  });

  it("rejects duplicate ids", () => {
    expect(
      competencyRegistrySchema.safeParse(
        registry({ competencies: [entry("math.frac.sens"), entry("math.frac.sens")] }),
      ).success,
    ).toBe(false);
  });

  it("rejects a prereq not declared in the family (R-3: same-family edges only)", () => {
    expect(
      competencyRegistrySchema.safeParse(
        registry({ competencies: [entry("math.frac.sens", ["math.frac.unknown"])] }),
      ).success,
    ).toBe(false);
  });

  it("rejects a self-prereq and a prerequisite cycle (R-3: DAG)", () => {
    expect(
      competencyRegistrySchema.safeParse(
        registry({ competencies: [entry("math.frac.sens", ["math.frac.sens"])] }),
      ).success,
    ).toBe(false);
    expect(
      competencyRegistrySchema.safeParse(
        registry({
          competencies: [
            entry("math.a.un", ["math.a.deux"]),
            entry("math.a.deux", ["math.a.trois"]),
            entry("math.a.trois", ["math.a.un"]),
          ],
        }),
      ).success,
    ).toBe(false);
  });
});

describe("findCompetencyCycle", () => {
  it("returns null on a DAG and the offending path on a cycle", () => {
    expect(
      findCompetencyCycle([entry("math.a.un"), entry("math.a.deux", ["math.a.un"])]),
    ).toBeNull();
    const cycle = findCompetencyCycle([
      entry("math.a.un", ["math.a.deux"]),
      entry("math.a.deux", ["math.a.un"]),
    ]);
    expect(cycle).not.toBeNull();
    expect(cycle![0]).toBe(cycle![cycle!.length - 1]);
  });

  it("ignores edges to undeclared ids (reported separately by the schema)", () => {
    expect(findCompetencyCycle([entry("math.a.un", ["math.a.ailleurs"])])).toBeNull();
  });
});

describe("schema — per-question competencies field (R-2, every type)", () => {
  const mcq = {
    type: "mcq" as const,
    prompt: "1/2 + 1/3 = ?",
    options: [
      { id: "a", text: "5/6" },
      { id: "b", text: "2/5" },
    ],
    correctOption: "a",
    explanation: "Réduction au même dénominateur.",
  };

  it("accepts 1–3 namespaced ids (first = primary) on mcq and numeric alike", () => {
    expect(questionSchema.safeParse({ ...mcq, competencies: ["math.frac.add-sous"] }).success).toBe(
      true,
    );
    expect(
      questionSchema.safeParse({
        type: "numeric",
        prompt: "1,5 + 2,25 = ?",
        answerKey: { value: 3.75 },
        explanation: "Addition décimale posée rang par rang.",
        competencies: ["math.num.add-sous-decimaux", "math.num.decimaux-sens"],
      }).success,
    ).toBe(true);
  });

  it("rejects an empty list, more than 3 ids, duplicates, and free text", () => {
    expect(questionSchema.safeParse({ ...mcq, competencies: [] }).success).toBe(false);
    expect(
      questionSchema.safeParse({
        ...mcq,
        competencies: ["math.a.un", "math.a.deux", "math.a.trois", "math.a.quatre"],
      }).success,
    ).toBe(false);
    expect(
      questionSchema.safeParse({
        ...mcq,
        competencies: ["math.frac.add-sous", "math.frac.add-sous"],
      }).success,
    ).toBe(false);
    expect(questionSchema.safeParse({ ...mcq, competencies: ["fractions"] }).success).toBe(false);
  });
});

describe("sql-builder — registry migration + junction rows (D-1/D-2)", () => {
  it("derives stable deterministic uuids from slugs (R-1)", () => {
    expect(competencyId("math.geo.thales-direct")).toBe(competencyId("math.geo.thales-direct"));
    expect(competencyId("math.geo.thales-direct")).not.toBe(
      competencyId("math.geo.thales-reciproque"),
    );
  });

  it("emits upsert + family-scoped prune + edge rebuild for a registry", () => {
    const sql = buildCompetencyRegistryMigrationSql([
      registry() as CompetencyRegistry,
    ] as CompetencyRegistry[]);
    expect(sql).toContain("INSERT INTO public.competencies");
    expect(sql).toContain(`'${competencyId("math.frac.sens")}'`);
    expect(sql).toContain("DELETE FROM public.competencies WHERE family = 'math' AND slug NOT IN");
    expect(sql).toContain("DELETE FROM public.competency_prereqs");
    expect(sql).toContain(
      `('${competencyId("math.frac.add-sous")}', '${competencyId("math.frac.sens")}')`,
    );
    expect(sql).toContain("ON CONFLICT (competency_id, prereq_id) DO NOTHING;");
  });

  const subjectWith = (competencies?: string[]): LoadedSubject => ({
    meta: {
      id: "kg-subj",
      nameFr: "KG",
      description: "d",
      attribute: "Esprit",
      colorToken: "subject-math",
      icon: "Brain",
      displayOrder: 1,
      contentLanguage: "fr" as const,
      themeId: "ecole-tn",
      gradeSlug: null,
      isPremium: false,
    },
    chapters: [
      {
        slug: "01-kg",
        meta: { title: "t", description: "d", displayOrder: 1, sources: [] },
        lesson: "l",
        summary: "s",
        quiz: {
          questions: [
            {
              type: "mcq" as const,
              prompt: "q",
              options: [
                { id: "a", text: "1" },
                { id: "b", text: "2" },
              ],
              correctOption: "a",
              explanation: "e",
              ...(competencies ? { competencies } : {}),
            },
          ],
        },
        exercises: [],
      },
    ],
  });

  it("compiles the authored competencies into junction upserts (first = primary)", () => {
    const sql = buildMigrationSql(subjectWith(["math.frac.add-sous", "math.frac.sens"]));
    expect(sql).toContain("INSERT INTO public.question_competencies");
    expect(sql).toContain(`'${competencyId("math.frac.add-sous")}', true`);
    expect(sql).toContain(`'${competencyId("math.frac.sens")}', false`);
    expect(sql).toContain("(qc.question_id, qc.competency_id) NOT IN");
    expect(sql).toContain("IF to_regclass('public.question_competencies') IS NOT NULL");
  });

  it("still prunes (converges to zero) when the subject asserts no mapping", () => {
    const sql = buildMigrationSql(subjectWith());
    expect(sql).toContain("DELETE FROM public.question_competencies");
    expect(sql).not.toContain("INSERT INTO public.question_competencies");
  });
});

describe("loadCompetencyRegistries", () => {
  let dir: string;
  beforeAll(() => {
    dir = mkdtempSync(join(tmpdir(), "competences-"));
  });
  afterAll(() => rmSync(dir, { recursive: true, force: true }));

  it("returns an empty list when the directory is absent (progressive rollout)", () => {
    expect(loadCompetencyRegistries(dir)).toEqual([]);
  });

  it("throws when the file name does not match the declared family", () => {
    mkdirSync(join(dir, "competences"), { recursive: true });
    writeFileSync(join(dir, "competences", "maths.json"), JSON.stringify(registry()));
    expect(() => loadCompetencyRegistries(dir)).toThrow(ContentValidationError);
    rmSync(join(dir, "competences", "maths.json"));
  });

  it("throws a ContentValidationError on a malformed registry (cycle)", () => {
    writeFileSync(
      join(dir, "competences", "math.json"),
      JSON.stringify(
        registry({
          competencies: [entry("math.a.un", ["math.a.deux"]), entry("math.a.deux", ["math.a.un"])],
        }),
      ),
    );
    expect(() => loadCompetencyRegistries(dir)).toThrow(ContentValidationError);
  });

  it("loads and validates the real content/competences registries (Q-1: 55-70 for math)", () => {
    const registries = loadCompetencyRegistries(join(process.cwd(), "content"));
    const math = registries.find((r) => r.family === "math");
    expect(math).toBeDefined();
    expect(math!.competencies.length).toBeGreaterThanOrEqual(55);
    expect(math!.competencies.length).toBeLessThanOrEqual(70);
    // Flagship cross-chapter edge: Thalès depends on proportionality (§1).
    const thales = math!.competencies.find((c) => c.id === "math.geo.thales-direct");
    expect(thales!.prereqs).toContain("math.prop.situations");
  });
});

describe("auditCompetencyRefs (content:qa vocabulary + family coverage)", () => {
  const vocab: CompetencyVocabulary = {
    ids: new Set(["math.frac.sens", "math.frac.add-sous"]),
    subjectPrefixes: new Map([["math", ["math"]]]),
  };

  it("flags an undeclared competency id as an error", () => {
    const flags = auditCompetencyRefs(
      { competencies: ["math.frac.unknown"] },
      "math",
      vocab,
      "math/ch/ex · Q1",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0]!.level).toBe("error");
    expect(flags[0]!.msg).toContain("content/competences/math.json");
  });

  it("warns when the family does not cover the tagging subject", () => {
    const flags = auditCompetencyRefs(
      { competencies: ["math.frac.sens"] },
      "francais-6eme",
      vocab,
      "francais-6eme/ch/ex · Q1",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0]!.level).toBe("warn");
  });

  it("accepts a declared id on a covered subject (exact id or grade variant)", () => {
    for (const subjectId of ["math", "math-6eme"]) {
      expect(
        auditCompetencyRefs({ competencies: ["math.frac.sens"] }, subjectId, vocab, "w"),
      ).toEqual([]);
    }
    expect(auditCompetencyRefs({}, "math", vocab, "w")).toEqual([]);
  });
});
