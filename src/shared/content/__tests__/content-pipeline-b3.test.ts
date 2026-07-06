import { describe, expect, it } from "vitest";
import { questionSchema } from "../schema.ts";
import { buildMigrationSql } from "../sql-builder.ts";

// Phase-B3 pipeline coverage (étude 03, lot B3.4): the native multi-select
// schema member (proper-subset integrity, wire-safe ids) and its per-type SQL
// emission. Split from content-pipeline.test.ts (max-lines cap).

describe("schema validation — B3 multi-select type", () => {
  const multiBase = {
    type: "multi",
    prompt: "Coche TOUTES les propriétés vraies d'un carré.",
    options: [
      { id: "a", text: "quatre côtés égaux" },
      { id: "b", text: "quatre angles droits" },
      { id: "c", text: "diagonales de longueurs différentes" },
    ],
    answerKey: { correct: ["a", "b"] },
    explanation:
      "Un carré a quatre côtés égaux et quatre angles droits ; ses diagonales sont égales (c est faux).",
  };

  it("accepts a native multi question whose key is a proper subset of the options", () => {
    expect(questionSchema.safeParse(multiBase).success).toBe(true);
  });

  it("rejects a correct set that isn't a proper subset (all options correct)", () => {
    expect(
      questionSchema.safeParse({ ...multiBase, answerKey: { correct: ["a", "b", "c"] } }).success,
    ).toBe(false);
  });

  it("rejects a correct set with fewer than 2 ids or duplicate/unknown ids", () => {
    expect(questionSchema.safeParse({ ...multiBase, answerKey: { correct: ["a"] } }).success).toBe(
      false,
    );
    expect(
      questionSchema.safeParse({ ...multiBase, answerKey: { correct: ["a", "a"] } }).success,
    ).toBe(false);
    expect(
      questionSchema.safeParse({ ...multiBase, answerKey: { correct: ["a", "z"] } }).success,
    ).toBe(false);
  });

  it("rejects B3 option ids that would break the CSV wire format", () => {
    expect(
      questionSchema.safeParse({
        ...multiBase,
        options: [
          { id: "a:1", text: "x" },
          { id: "b", text: "y" },
          { id: "c", text: "z" },
        ],
        answerKey: { correct: ["a:1", "b"] },
      }).success,
    ).toBe(false);
  });

  it("emits options AND answer_key for the multi type", () => {
    const sql = buildMigrationSql({
      meta: {
        id: "b3-subj",
        nameFr: "B3",
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
          slug: "01-b3",
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
              slug: "ex-b3",
              data: {
                title: "multi",
                difficulty: 2,
                mode: "practice" as const,
                xpReward: 75,
                rewardCoins: 15,
                displayOrder: 1,
                questions: [
                  {
                    type: "multi" as const,
                    prompt: "Coche tout ce qui est vrai.",
                    options: [
                      { id: "a", text: "vrai 1" },
                      { id: "b", text: "faux" },
                      { id: "c", text: "vrai 2" },
                    ],
                    answerKey: { correct: ["a", "c"] },
                    explanation: "a et c sont vrais ; b est faux.",
                  },
                ],
              },
            },
          ],
        },
      ],
    });
    expect(sql).toContain(`'{"correct":["a","c"]}'::jsonb`);
    // multi carries its items in options (unlike numeric) and no correct_option.
    expect(sql).toContain(
      `'[{"id":"a","text":"vrai 1"},{"id":"b","text":"faux"},{"id":"c","text":"vrai 2"}]'::jsonb, NULL`,
    );
    expect(sql).toContain("'multi', ");
  });
});
