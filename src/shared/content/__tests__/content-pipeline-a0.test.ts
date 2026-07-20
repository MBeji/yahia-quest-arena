import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { misconceptionRegistrySchema, questionSchema } from "../schema.ts";
import { buildMigrationSql } from "../sql-builder.ts";
import { ContentValidationError, loadMisconceptionRegistry } from "../loader.ts";

// Adaptive-engine A0.3 (étude 04): the server-only misconception tagging path —
// the zod field + the registry + sql-builder routing (tags → distractor_tags,
// STRIPPED from options). Split from content-pipeline.test.ts (max-lines cap).

const mcqBase = {
  type: "mcq" as const,
  prompt: "1/2 + 1/3 = ?",
  options: [
    { id: "a", text: "5/6" },
    { id: "b", text: "2/5", misconceptionTag: "math.frac.add-numerators-and-denominators" },
    { id: "c", text: "1/6" },
  ],
  correctOption: "a",
  explanation: "On réduit au même dénominateur : 3/6 + 2/6 = 5/6. 2/5 additionne à tort.",
};

describe("schema — misconceptionTag on mcq options", () => {
  it("accepts a distractor carrying a well-formed namespaced tag", () => {
    expect(questionSchema.safeParse(mcqBase).success).toBe(true);
  });

  it("rejects a free-text (non-namespaced) tag", () => {
    const bad = {
      ...mcqBase,
      options: [
        { id: "a", text: "5/6" },
        { id: "b", text: "2/5", misconceptionTag: "adds denominators" },
        { id: "c", text: "1/6" },
      ],
    };
    expect(questionSchema.safeParse(bad).success).toBe(false);
  });

  it("rejects a tag on the CORRECT option (a right answer has no misconception)", () => {
    const bad = {
      ...mcqBase,
      options: [
        { id: "a", text: "5/6", misconceptionTag: "math.frac.add-denominators" },
        { id: "b", text: "2/5" },
        { id: "c", text: "1/6" },
      ],
    };
    expect(questionSchema.safeParse(bad).success).toBe(false);
  });
});

describe("registry schema — content/misconceptions.json", () => {
  const entry = { subject: "math", labels: { fr: "f", en: "e", ar: "ا" } };

  it("accepts a namespaced id → {subject, trilingual labels}", () => {
    expect(
      misconceptionRegistrySchema.safeParse({ "math.frac.add-denominators": entry }).success,
    ).toBe(true);
  });

  it("rejects a non-namespaced key", () => {
    expect(misconceptionRegistrySchema.safeParse({ frac: entry }).success).toBe(false);
  });

  it("rejects an entry missing a language label", () => {
    expect(
      misconceptionRegistrySchema.safeParse({
        "math.frac.add-denominators": { subject: "math", labels: { fr: "f", en: "e" } },
      }).success,
    ).toBe(false);
  });
});

describe("sql-builder — tags routed server-side, stripped from options", () => {
  const buildOneMcq = (
    options: Array<{ id: string; text: string; misconceptionTag?: string }>,
    correctOption = "a",
  ) =>
    buildMigrationSql({
      meta: {
        id: "a0-subj",
        nameFr: "A0",
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
          slug: "01-a0",
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
                  { id: "c", text: "3" },
                ],
                correctOption: "a",
                explanation: "e",
              },
            ],
          },
          exercises: [
            {
              slug: "ex-a0",
              data: {
                title: "mcq",
                difficulty: 2,
                mode: "practice" as const,
                xpReward: 75,
                rewardCoins: 15,
                displayOrder: 1,
                questions: [
                  {
                    type: "mcq" as const,
                    prompt: "1/2 + 1/3 = ?",
                    options,
                    correctOption,
                    explanation: "explication assez longue pour passer la QA du contenu.",
                  },
                ],
              },
            },
          ],
        },
      ],
    });

  it("emits distractor_tags keyed by option id and drops the tag from options", () => {
    const sql = buildOneMcq([
      { id: "a", text: "5/6" },
      { id: "b", text: "2/5", misconceptionTag: "math.frac.add-numerators-and-denominators" },
      { id: "c", text: "1/6", misconceptionTag: "math.frac.add-denominators" },
    ]);
    // The server-only map carries both distractors.
    expect(sql).toContain(
      `'{"b":"math.frac.add-numerators-and-denominators","c":"math.frac.add-denominators"}'::jsonb`,
    );
    // options JSONB is stripped back to {id,text} — the tag never reaches the client.
    expect(sql).toContain(
      `'[{"id":"a","text":"5/6"},{"id":"b","text":"2/5"},{"id":"c","text":"1/6"}]'::jsonb`,
    );
    expect(sql).not.toContain("misconceptionTag");
  });

  it("emits distractor_tags NULL when no option is tagged", () => {
    const sql = buildOneMcq([
      { id: "a", text: "5/6" },
      { id: "b", text: "2/5" },
      { id: "c", text: "1/6" },
    ]);
    // The questions INSERT ends with question_type, answer_key, distractor_tags
    // and — since étude 20 lot 1 — the accepted-answer set (default '[]').
    expect(sql).toContain("'mcq', NULL, NULL, '[]'::jsonb)");
  });
});

describe("loadMisconceptionRegistry", () => {
  let dir: string;
  beforeAll(() => {
    dir = mkdtempSync(join(tmpdir(), "misc-registry-"));
  });
  afterAll(() => rmSync(dir, { recursive: true, force: true }));

  it("returns an empty registry when the file is absent (tagging is progressive)", () => {
    expect(loadMisconceptionRegistry(dir)).toEqual({});
  });

  it("throws a ContentValidationError on a malformed registry", () => {
    mkdirSync(dir, { recursive: true });
    writeFileSync(
      join(dir, "misconceptions.json"),
      JSON.stringify({ "not a tag": { subject: "math", labels: { fr: "f", en: "e", ar: "ا" } } }),
    );
    expect(() => loadMisconceptionRegistry(dir)).toThrow(ContentValidationError);
  });

  // The assertion on the REAL content/misconceptions.json moved to the private repo
  // with the corpus (étude 24, lot 3b): it guarded corpus integrity, not loader
  // behaviour, and `content:check` re-runs this very loader over the real registry
  // on every private PR. The loader itself stays covered by the fixtures above.
});
