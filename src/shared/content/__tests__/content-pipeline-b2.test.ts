import { describe, expect, it } from "vitest";
import { questionSchema } from "../schema.ts";
import { buildMigrationSql } from "../sql-builder.ts";

// Phase-B2 pipeline coverage (étude 03, lot B2.4): the native ordering/matching
// schema members (permutation/bijection integrity, wire-safe ids) and their
// per-type SQL emission. Split from content-pipeline.test.ts (max-lines cap).

describe("schema validation — B2 board types", () => {
  const orderingBase = {
    type: "ordering",
    prompt: "Range les étapes.",
    options: [
      { id: "a", text: "étape 1" },
      { id: "b", text: "étape 2" },
      { id: "c", text: "étape 3" },
    ],
    answerKey: { order: ["b", "a", "c"] },
    explanation: "D'abord b, puis a, puis c.",
  };

  it("accepts a native ordering question whose key is a permutation of the steps", () => {
    expect(questionSchema.safeParse(orderingBase).success).toBe(true);
  });

  it("rejects an ordering key that is not an exact permutation of the option ids", () => {
    expect(
      questionSchema.safeParse({ ...orderingBase, answerKey: { order: ["b", "a", "d"] } }).success,
    ).toBe(false);
    expect(
      questionSchema.safeParse({ ...orderingBase, answerKey: { order: ["b", "a", "a"] } }).success,
    ).toBe(false);
  });

  it("rejects B2 option ids that would break the CSV wire format", () => {
    expect(
      questionSchema.safeParse({
        ...orderingBase,
        options: [
          { id: "a,b", text: "étape 1" },
          { id: "b", text: "étape 2" },
          { id: "c", text: "étape 3" },
        ],
        answerKey: { order: ["a,b", "b", "c"] },
      }).success,
    ).toBe(false);
  });

  const matchingBase = {
    type: "matching",
    prompt: "Associe chaque calcul à son résultat.",
    options: [
      { id: "l1", text: "la moitié de 10" },
      { id: "l2", text: "le double de 4" },
      { id: "r1", text: "5" },
      { id: "r2", text: "8" },
    ],
    answerKey: {
      pairs: [
        ["l1", "r1"],
        ["l2", "r2"],
      ],
    },
    explanation: "10 ÷ 2 = 5 et 4 × 2 = 8.",
  };

  it("accepts a native matching question whose pairs form a bijection", () => {
    expect(questionSchema.safeParse(matchingBase).success).toBe(true);
  });

  it("rejects matching pairs that skip or reuse a side", () => {
    expect(
      questionSchema.safeParse({
        ...matchingBase,
        answerKey: {
          pairs: [
            ["l1", "r1"],
            ["l1", "r2"],
          ],
        },
      }).success,
    ).toBe(false);
    expect(
      questionSchema.safeParse({
        ...matchingBase,
        options: matchingBase.options.slice(0, 3),
        answerKey: {
          pairs: [
            ["l1", "r1"],
            ["l2", "r1"],
          ],
        },
      }).success,
    ).toBe(false);
  });

  it("emits options AND answer_key for the B2 board types", () => {
    const sql = buildMigrationSql({
      meta: {
        id: "b2-subj",
        nameFr: "B2",
        description: "d",
        attribute: "Esprit",
        colorToken: "subject-math",
        icon: "Brain",
        displayOrder: 1,
        contentLanguage: "fr" as const,
        themeId: "muscle-cerveau",
        gradeSlug: null,
        isPremium: false,
      },
      chapters: [
        {
          slug: "01-b2",
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
              },
            ],
          },
          exercises: [
            {
              slug: "ex-b2",
              data: {
                title: "boards",
                difficulty: 2,
                mode: "practice" as const,
                xpReward: 75,
                rewardCoins: 15,
                displayOrder: 1,
                questions: [
                  {
                    type: "ordering" as const,
                    prompt: "Range.",
                    options: [
                      { id: "a", text: "un" },
                      { id: "b", text: "deux" },
                      { id: "c", text: "trois" },
                    ],
                    answerKey: { order: ["c", "a", "b"] },
                    explanation: "c, a, b.",
                  },
                  {
                    type: "matching" as const,
                    prompt: "Associe.",
                    options: [
                      { id: "l1", text: "G1" },
                      { id: "l2", text: "G2" },
                      { id: "r1", text: "D1" },
                      { id: "r2", text: "D2" },
                    ],
                    answerKey: {
                      pairs: [
                        ["l1", "r2"],
                        ["l2", "r1"],
                      ] as [string, string][],
                    },
                    explanation: "l1-r2, l2-r1.",
                  },
                ],
              },
            },
          ],
        },
      ],
    });
    expect(sql).toContain(`'{"order":["c","a","b"]}'::jsonb`);
    expect(sql).toContain(`'{"pairs":[["l1","r2"],["l2","r1"]]}'::jsonb`);
    // Board types carry their items in options (unlike numeric) and no correct_option.
    expect(sql).toContain(
      `'[{"id":"a","text":"un"},{"id":"b","text":"deux"},{"id":"c","text":"trois"}]'::jsonb, NULL`,
    );
    expect(sql).toContain("'ordering', ");
    expect(sql).toContain("'matching', ");
  });
});
