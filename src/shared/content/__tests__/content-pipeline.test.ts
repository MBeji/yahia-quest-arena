import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import {
  chapterMetaSchema,
  exerciseSchema,
  parseManuelPages,
  questionSchema,
  subjectMetaSchema,
} from "../schema.ts";
import { ContentValidationError, loadAllSubjects, loadSubject } from "../loader.ts";
import {
  buildMigrationSql,
  chapterId,
  exerciseId,
  questionId,
  sqlJson,
  sqlString,
  uuidV5,
} from "../sql-builder.ts";

describe("schema validation", () => {
  it("accepts a well-formed subject", () => {
    const result = subjectMetaSchema.safeParse({
      id: "math",
      nameFr: "Mathématiques",
      description: "desc",
      attribute: "Force",
      colorToken: "subject-math",
      icon: "Calculator",
      displayOrder: 1,
      contentLanguage: "ar",
      themeId: "ecole-tn",
      gradeSlug: "9eme-base",
    });
    expect(result.success).toBe(true);
  });

  it("defaults isPremium to false and accepts a premium subject", () => {
    const base = {
      id: "fr-mastery",
      nameFr: "Maîtrise du français",
      description: "desc",
      attribute: "Sagesse",
      colorToken: "subject-french",
      icon: "BookOpen",
      displayOrder: 6,
      contentLanguage: "fr" as const,
      themeId: "francais",
    };
    const def = subjectMetaSchema.parse(base);
    expect(def.isPremium).toBe(false);
    // gradeSlug defaults to null for grade-agnostic subjects.
    expect(def.gradeSlug).toBeNull();
    const prem = subjectMetaSchema.parse({ ...base, isPremium: true });
    expect(prem.isPremium).toBe(true);
  });

  it("requires a theme and rejects a non-kebab themeId", () => {
    const base = {
      id: "math",
      nameFr: "x",
      description: "x",
      attribute: "x",
      colorToken: "x",
      icon: "x",
      displayOrder: 1,
      contentLanguage: "ar" as const,
    };
    // themeId is mandatory: every subject belongs to exactly one theme.
    expect(subjectMetaSchema.safeParse(base).success).toBe(false);
    expect(subjectMetaSchema.safeParse({ ...base, themeId: "Ecole TN" }).success).toBe(false);
    expect(subjectMetaSchema.safeParse({ ...base, themeId: "ecole-tn" }).success).toBe(true);
  });

  it("rejects an invalid content language", () => {
    const result = subjectMetaSchema.safeParse({
      id: "math",
      nameFr: "x",
      description: "x",
      attribute: "x",
      colorToken: "x",
      icon: "x",
      displayOrder: 1,
      contentLanguage: "es",
      themeId: "ecole-tn",
    });
    expect(result.success).toBe(false);
  });

  it("rejects a non-kebab subject id", () => {
    const result = subjectMetaSchema.safeParse({
      id: "Math 1",
      nameFr: "x",
      description: "x",
      attribute: "x",
      colorToken: "x",
      icon: "x",
      displayOrder: 1,
      contentLanguage: "ar",
      themeId: "ecole-tn",
    });
    expect(result.success).toBe(false);
  });

  it("rejects a question whose correctOption is not an option id", () => {
    const result = questionSchema.safeParse({
      prompt: "2 + 2 = ?",
      options: [
        { id: "a", text: "3" },
        { id: "b", text: "4" },
      ],
      correctOption: "z",
      explanation: "4",
    });
    expect(result.success).toBe(false);
  });

  it("rejects duplicate option ids", () => {
    const result = questionSchema.safeParse({
      prompt: "p",
      options: [
        { id: "a", text: "1" },
        { id: "a", text: "2" },
      ],
      correctOption: "a",
      explanation: "e",
    });
    expect(result.success).toBe(false);
  });

  it("defaults an untyped question to mcq (every existing file stays valid — D-4)", () => {
    const result = questionSchema.safeParse({
      prompt: "2 + 2 = ?",
      options: [
        { id: "a", text: "3" },
        { id: "b", text: "4" },
      ],
      correctOption: "b",
      explanation: "4",
    });
    expect(result.success).toBe(true);
    if (result.success) expect(result.data.type).toBe("mcq");
  });

  it("accepts a native numeric question (typed key, no options)", () => {
    const result = questionSchema.safeParse({
      type: "numeric",
      prompt: "Calcule 6 × 7.",
      answerKey: { value: 42, tolerance: 0.5, unit: "cm" },
      explanation: "6 × 7 = 42.",
    });
    expect(result.success).toBe(true);
    if (result.success && result.data.type === "numeric") {
      expect(result.data.answerKey.value).toBe(42);
    }
  });

  it("rejects a numeric question without its answerKey, or with a negative tolerance", () => {
    expect(
      questionSchema.safeParse({ type: "numeric", prompt: "p", explanation: "e" }).success,
    ).toBe(false);
    expect(
      questionSchema.safeParse({
        type: "numeric",
        prompt: "p",
        answerKey: { value: 1, tolerance: -0.1 },
        explanation: "e",
      }).success,
    ).toBe(false);
  });

  it("rejects the not-yet-shipped 'multi' type (the B3 authoring ban is the schema)", () => {
    const result = questionSchema.safeParse({
      type: "multi",
      prompt: "p",
      options: [
        { id: "a", text: "1" },
        { id: "b", text: "2" },
      ],
      answerKey: { correct: ["a", "b"] },
      explanation: "e",
    });
    expect(result.success).toBe(false);
  });

  it("rejects an exercise with an out-of-range difficulty", () => {
    const result = exerciseSchema.safeParse({
      title: "t",
      difficulty: 5,
      mode: "practice",
      xpReward: 50,
      rewardCoins: 10,
      displayOrder: 1,
      questions: [
        {
          prompt: "p",
          options: [
            { id: "a", text: "1" },
            { id: "b", text: "2" },
          ],
          correctOption: "a",
          explanation: "e",
        },
      ],
    });
    expect(result.success).toBe(false);
  });

  it("accepts a premium 'challenge' exercise at the elite difficulty tier", () => {
    const result = exerciseSchema.safeParse({
      title: "Défi élite",
      difficulty: 4,
      mode: "challenge",
      xpReward: 300,
      rewardCoins: 60,
      displayOrder: 4,
      questions: [
        {
          prompt: "p",
          options: [
            { id: "a", text: "1" },
            { id: "b", text: "2" },
          ],
          correctOption: "a",
          explanation: "e",
          difficulty: 3,
        },
      ],
    });
    expect(result.success).toBe(true);
  });
});

describe("manuel page mapping", () => {
  it("expands single pages, ranges, and comma lists (sorted, de-duped)", () => {
    expect(parseManuelPages("12")).toEqual([12]);
    expect(parseManuelPages("12-15")).toEqual([12, 13, 14, 15]);
    expect(parseManuelPages("12-15, 18, 20-21")).toEqual([12, 13, 14, 15, 18, 20, 21]);
    expect(parseManuelPages("20, 12, 12-13")).toEqual([12, 13, 20]);
  });

  it("throws on a descending range or a malformed token", () => {
    expect(() => parseManuelPages("15-12")).toThrow();
    expect(() => parseManuelPages("12-")).toThrow();
    expect(() => parseManuelPages("abc")).toThrow();
  });

  it("accepts a chapter with a well-formed manuel link, and makes it optional", () => {
    expect(
      chapterMetaSchema.safeParse({
        title: "t",
        description: "d",
        displayOrder: 1,
        manuel: { code: "103304", pages: "12-15, 18" },
      }).success,
    ).toBe(true);
    // A chapter without a manuel link still validates (optional field).
    expect(
      chapterMetaSchema.safeParse({ title: "t", description: "d", displayOrder: 1 }).success,
    ).toBe(true);
  });

  it("rejects a manuel with an invalid page expression or code", () => {
    const base = { title: "t", description: "d", displayOrder: 1 };
    expect(
      chapterMetaSchema.safeParse({ ...base, manuel: { code: "x", pages: "15-12" } }).success,
    ).toBe(false);
    expect(
      chapterMetaSchema.safeParse({ ...base, manuel: { code: "x", pages: "0" } }).success,
    ).toBe(false);
    expect(
      chapterMetaSchema.safeParse({ ...base, manuel: { code: "x", pages: "abc" } }).success,
    ).toBe(false);
    expect(
      chapterMetaSchema.safeParse({ ...base, manuel: { code: "bad code", pages: "12" } }).success,
    ).toBe(false);
  });
});

describe("deterministic ids", () => {
  it("produces a valid, stable v5 uuid", () => {
    const a = uuidV5("math/01-foo");
    const b = uuidV5("math/01-foo");
    expect(a).toBe(b);
    expect(a).toMatch(/^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/);
  });

  it("derives distinct ids per level", () => {
    const ch = chapterId("math", "01-foo");
    const ex = exerciseId("math", "01-foo", "ex1");
    const q1 = questionId("math", "01-foo", "ex1", 1);
    const q2 = questionId("math", "01-foo", "ex1", 2);
    expect(new Set([ch, ex, q1, q2]).size).toBe(4);
  });
});

describe("sql escaping", () => {
  it("doubles single quotes", () => {
    expect(sqlString("l'eau")).toBe("'l''eau'");
  });

  it("emits a jsonb literal", () => {
    expect(sqlJson([{ id: "a", text: "x" }])).toBe(`'[{"id":"a","text":"x"}]'::jsonb`);
  });
});

describe("buildMigrationSql", () => {
  const subject = {
    meta: {
      id: "math",
      nameFr: "Mathématiques",
      description: "desc",
      attribute: "Force",
      colorToken: "subject-math",
      icon: "Calculator",
      displayOrder: 1,
      contentLanguage: "ar" as const,
      themeId: "ecole-tn",
      gradeSlug: "9eme-base",
      isPremium: false,
    },
    chapters: [
      {
        slug: "01-foo",
        meta: {
          title: "الفصل",
          description: "d",
          displayOrder: 1,
          sources: [],
          manuel: { code: "103304", pages: "12-15" },
        },
        lesson: "# cours",
        summary: "## résumé",
        quiz: {
          title: "اختبار الفهم",
          questions: [
            {
              type: "mcq" as const,
              prompt: "س؟",
              options: [
                { id: "a", text: "1" },
                { id: "b", text: "2" },
              ],
              correctOption: "a",
              explanation: "ج",
            },
          ],
        },
        exercises: [
          {
            slug: "ex1",
            data: {
              title: "exo",
              difficulty: 1,
              mode: "practice" as const,
              xpReward: 50,
              rewardCoins: 10,
              displayOrder: 1,
              questions: [
                {
                  type: "mcq" as const,
                  prompt: "2+2 ?",
                  options: [
                    { id: "a", text: "3" },
                    { id: "b", text: "4" },
                  ],
                  correctOption: "b",
                  explanation: "= 4",
                },
                {
                  type: "numeric" as const,
                  prompt: "Calcule 6 × 7.",
                  answerKey: { value: 42, tolerance: 0 },
                  explanation: "6 × 7 = 42.",
                },
              ],
            },
          },
        ],
      },
    ],
  };

  const sql = buildMigrationSql(subject);

  it("upserts the subject with its content language", () => {
    expect(sql).toContain("INSERT INTO public.subjects");
    expect(sql).toContain("ON CONFLICT (id) DO UPDATE SET");
    expect(sql).toContain("'ar'");
  });

  it("uses deterministic chapter/exercise/question ids", () => {
    expect(sql).toContain(sqlString(chapterId("math", "01-foo")));
    expect(sql).toContain(sqlString(exerciseId("math", "01-foo", "ex1")));
    expect(sql).toContain(sqlString(questionId("math", "01-foo", "ex1", 1)));
  });

  it("stores lesson and summary on the chapter", () => {
    expect(sql).toContain("lesson_content");
    expect(sql).toContain("summary");
  });

  it("emits the chapter manuel_ref as jsonb with expanded page numbers", () => {
    expect(sql).toContain("display_order, manuel_ref) VALUES");
    expect(sql).toContain('"code":"103304"');
    expect(sql).toContain('"pages":"12-15"');
    expect(sql).toContain('"pageNumbers":[12,13,14,15]');
    expect(sql).toContain("manuel_ref = EXCLUDED.manuel_ref");
  });

  it("emits manuel_ref NULL for a chapter without a manuel link", () => {
    const noManuel = buildMigrationSql({
      meta: subject.meta,
      chapters: [
        {
          ...subject.chapters[0],
          meta: { title: "t", description: "d", displayOrder: 1, sources: [] },
        },
      ],
    });
    // Column is always present; the value is the SQL literal NULL (no payload).
    expect(noManuel).toContain("display_order, manuel_ref) VALUES");
    expect(noManuel).toMatch(/, 1, NULL\)/);
    expect(noManuel).not.toContain('"code":');
  });

  it("prunes stale admin content without touching parent content", () => {
    expect(sql).toContain("source = 'admin' AND id NOT IN");
    expect(sql).not.toContain("source = 'parent'");
  });

  it("clears RESTRICT-referencing dungeon rows before pruning questions", () => {
    expect(sql).toContain("dungeon_run_questions");
    expect(sql).toContain("to_regclass('public.dungeon_run_questions')");
  });

  it("emits the chapter comprehension quiz as a mode='quiz' exercise", () => {
    expect(sql).toContain(sqlString(exerciseId("math", "01-foo", "quiz")));
    expect(sql).toContain("'quiz'");
  });

  it("emits the subject is_premium flag", () => {
    expect(sql).toContain("is_premium");
    expect(sql).toContain("is_premium = EXCLUDED.is_premium");
  });

  it("emits the subject theme and resolves the grade by (theme, slug)", () => {
    expect(sql).toContain("'ecole-tn'");
    expect(sql).toContain(
      "SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'",
    );
    expect(sql).toContain("theme_id = EXCLUDED.theme_id");
    expect(sql).toContain("grade_id = EXCLUDED.grade_id");
  });

  it("emits grade_id NULL for a grade-agnostic subject (no grades lookup)", () => {
    const agnostic = buildMigrationSql({
      meta: { ...subject.meta, themeId: "francais", gradeSlug: null },
      chapters: subject.chapters,
    });
    expect(agnostic).toContain("'francais'");
    expect(agnostic).not.toContain("SELECT id FROM public.grades");
    expect(agnostic).toMatch(/'francais', NULL\)/);
  });

  it("self-contains the exercises mode CHECK (incl. 'challenge') so it never blocks", () => {
    expect(sql).toContain("exercises_mode_check");
    expect(sql).toContain("CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'))");
  });

  it("serializes question options as jsonb", () => {
    expect(sql).toContain(`'[{"id":"a","text":"3"},{"id":"b","text":"4"}]'::jsonb`);
  });

  it("emits per-type columns: mcq keeps its historical key, numeric carries answer_key", () => {
    expect(sql).toContain(
      "prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES",
    );
    expect(sql).toContain("question_type = EXCLUDED.question_type");
    expect(sql).toContain("answer_key = EXCLUDED.answer_key");
    expect(sql).toContain("distractor_tags = EXCLUDED.distractor_tags");
    // mcq: typed 'mcq', no answer_key, no distractor_tags.
    expect(sql).toContain("'mcq', NULL, NULL)");
    // numeric: empty options, NULL correct_option, its typed jsonb key.
    expect(sql).toContain(`'numeric', '{"value":42,"tolerance":0}'::jsonb`);
    expect(sql).toContain("'[]'::jsonb, NULL");
  });
});

describe("question difficulty ordering", () => {
  const q = (prompt: string, difficulty: number) => ({
    type: "mcq" as const,
    prompt,
    options: [
      { id: "a", text: "1" },
      { id: "b", text: "2" },
    ],
    correctOption: "a" as const,
    explanation: "e",
    difficulty,
  });

  const sql = buildMigrationSql({
    meta: {
      id: "math",
      nameFr: "M",
      description: "d",
      attribute: "Force",
      colorToken: "subject-math",
      icon: "Calculator",
      displayOrder: 1,
      contentLanguage: "ar" as const,
      themeId: "ecole-tn",
      gradeSlug: "9eme-base",
      isPremium: false,
    },
    chapters: [
      {
        slug: "01-foo",
        meta: { title: "t", description: "d", displayOrder: 1, sources: [] },
        lesson: "l",
        summary: "s",
        quiz: { questions: [q("QZ", 1)] },
        exercises: [
          {
            slug: "ex1",
            data: {
              title: "exo",
              difficulty: 2,
              mode: "practice" as const,
              xpReward: 50,
              rewardCoins: 10,
              displayOrder: 1,
              // Intentionally out of order: hard, easy, medium.
              questions: [q("HARD", 3), q("EASY", 1), q("MEDIUM", 2)],
            },
          },
        ],
      },
    ],
  });

  it("emits questions from easiest to hardest regardless of source order", () => {
    expect(sql.indexOf("EASY")).toBeLessThan(sql.indexOf("MEDIUM"));
    expect(sql.indexOf("MEDIUM")).toBeLessThan(sql.indexOf("HARD"));
  });
});

describe("loader", () => {
  let root: string;

  beforeAll(() => {
    root = mkdtempSync(join(tmpdir(), "content-test-"));
    const subjectDir = join(root, "math");
    const chapterDir = join(subjectDir, "01-foo");
    const exDir = join(chapterDir, "exercices");
    mkdirSync(exDir, { recursive: true });

    writeFileSync(
      join(subjectDir, "subject.json"),
      JSON.stringify({
        id: "math",
        nameFr: "Mathématiques",
        description: "desc",
        attribute: "Force",
        colorToken: "subject-math",
        icon: "Calculator",
        displayOrder: 1,
        contentLanguage: "ar",
        themeId: "ecole-tn",
        gradeSlug: "9eme-base",
      }),
    );
    writeFileSync(
      join(chapterDir, "chapter.json"),
      JSON.stringify({ title: "الفصل", description: "d", displayOrder: 1, sources: [] }),
    );
    writeFileSync(join(chapterDir, "cours.md"), "# cours");
    writeFileSync(join(chapterDir, "resume.md"), "## résumé");
    writeFileSync(
      join(chapterDir, "quiz.json"),
      JSON.stringify({
        title: "اختبار الفهم",
        questions: [
          {
            prompt: "q1",
            options: [
              { id: "a", text: "1" },
              { id: "b", text: "2" },
            ],
            correctOption: "a",
            explanation: "e",
          },
          {
            prompt: "q2",
            options: [
              { id: "a", text: "1" },
              { id: "b", text: "2" },
            ],
            correctOption: "b",
            explanation: "e",
          },
          {
            prompt: "q3",
            options: [
              { id: "a", text: "1" },
              { id: "b", text: "2" },
            ],
            correctOption: "a",
            explanation: "e",
          },
        ],
      }),
    );
    writeFileSync(
      join(exDir, "01-pratique.json"),
      JSON.stringify({
        title: "exo",
        difficulty: 1,
        mode: "practice",
        xpReward: 50,
        rewardCoins: 10,
        displayOrder: 1,
        questions: [
          {
            prompt: "p",
            options: [
              { id: "a", text: "1" },
              { id: "b", text: "2" },
            ],
            correctOption: "a",
            explanation: "e",
          },
        ],
      }),
    );
  });

  afterAll(() => {
    rmSync(root, { recursive: true, force: true });
  });

  it("loads a subject tree end to end", () => {
    const subject = loadSubject(join(root, "math"));
    expect(subject.meta.id).toBe("math");
    expect(subject.chapters).toHaveLength(1);
    expect(subject.chapters[0].lesson).toBe("# cours");
    expect(subject.chapters[0].summary).toBe("## résumé");
    expect(subject.chapters[0].quiz.questions).toHaveLength(3);
    expect(subject.chapters[0].exercises).toHaveLength(1);
  });

  it("discovers subjects from a content root", () => {
    const subjects = loadAllSubjects(root);
    expect(subjects.map((s) => s.meta.id)).toEqual(["math"]);
  });

  it("throws a ContentValidationError on a missing lesson file", () => {
    const badSubject = join(root, "bad");
    mkdirSync(join(badSubject, "01-x"), { recursive: true });
    writeFileSync(
      join(badSubject, "subject.json"),
      JSON.stringify({
        id: "bad",
        nameFr: "x",
        description: "x",
        attribute: "x",
        colorToken: "x",
        icon: "x",
        displayOrder: 1,
        contentLanguage: "fr",
        themeId: "ecole-tn",
        gradeSlug: "9eme-base",
      }),
    );
    writeFileSync(
      join(badSubject, "01-x", "chapter.json"),
      JSON.stringify({ title: "t", description: "d", displayOrder: 1 }),
    );
    expect(() => loadSubject(badSubject)).toThrow(ContentValidationError);
  });
});
