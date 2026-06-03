import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { exerciseSchema, questionSchema, subjectMetaSchema } from "../schema.ts";
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
    });
    expect(result.success).toBe(true);
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
    },
    chapters: [
      {
        slug: "01-foo",
        meta: { title: "الفصل", description: "d", displayOrder: 1, sources: [] },
        lesson: "# cours",
        summary: "## résumé",
        quiz: {
          title: "اختبار الفهم",
          questions: [
            {
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
                  prompt: "2+2 ?",
                  options: [
                    { id: "a", text: "3" },
                    { id: "b", text: "4" },
                  ],
                  correctOption: "b",
                  explanation: "= 4",
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

  it("serializes question options as jsonb", () => {
    expect(sql).toContain(`'[{"id":"a","text":"3"},{"id":"b","text":"4"}]'::jsonb`);
  });
});

describe("question difficulty ordering", () => {
  const q = (prompt: string, difficulty: number) => ({
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
      }),
    );
    writeFileSync(
      join(badSubject, "01-x", "chapter.json"),
      JSON.stringify({ title: "t", description: "d", displayOrder: 1 }),
    );
    expect(() => loadSubject(badSubject)).toThrow(ContentValidationError);
  });
});
