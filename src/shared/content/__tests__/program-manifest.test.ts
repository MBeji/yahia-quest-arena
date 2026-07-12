import { describe, expect, it } from "vitest";
import {
  auditChapter,
  auditGrade,
  programManifestSchema,
  type ProgramManifest,
} from "../program-manifest.ts";
import type {
  ContentExercise,
  ContentQuestion,
  LoadedChapter,
  LoadedExercise,
  LoadedSubject,
} from "../schema.ts";

// --- fixtures -------------------------------------------------------------

const question = (over: Partial<ContentQuestion> = {}): ContentQuestion => ({
  type: "mcq",
  prompt: "prompt",
  options: [
    { id: "a", text: "A" },
    { id: "b", text: "B" },
  ],
  correctOption: "a",
  explanation: "because A",
  ...(over as object),
});

const exercise = (
  slug: string,
  mode: ContentExercise["mode"],
  over: Partial<ContentExercise> = {},
): LoadedExercise => ({
  slug,
  data: {
    title: "ex",
    difficulty: mode === "boss" ? 3 : 1,
    mode,
    xpReward: 50,
    rewardCoins: 10,
    displayOrder: 1,
    questions: [question()],
    ...over,
  },
});

const chapter = (slug: string, over: Partial<LoadedChapter> = {}): LoadedChapter => ({
  slug,
  meta: { title: "t", description: "d", displayOrder: 1, sources: [] },
  lesson: "course body",
  summary: "summary body",
  quiz: { questions: [question(), question(), question()] },
  exercises: [exercise("01-pratique", "practice"), exercise("02-boss", "boss")],
  ...over,
});

const subject = (
  id: string,
  contentLanguage: LoadedSubject["meta"]["contentLanguage"],
  chapters: LoadedChapter[],
): LoadedSubject => ({
  meta: {
    id,
    nameFr: "N",
    description: "d",
    attribute: "Force",
    colorToken: "c",
    icon: "i",
    displayOrder: 1,
    contentLanguage,
    themeId: "ecole-tn",
    gradeSlug: "1ere-base",
    isPremium: false,
  },
  chapters,
});

const manifest = (over: Partial<ProgramManifest> = {}): ProgramManifest => ({
  grade: "1ere-base",
  sealed: false,
  subjects: [
    {
      id: "math-1ere",
      contentLanguage: "ar",
      chapters: [
        { slug: "01-a", notion: "A", optional: false },
        { slug: "02-b", notion: "B", optional: false },
      ],
    },
  ],
  ...over,
});

// --- auditChapter ---------------------------------------------------------

describe("auditChapter", () => {
  it("flags a complete chapter as complete with no issues", () => {
    const c = auditChapter(chapter("01-a"));
    expect(c.complete).toBe(true);
    expect(c.hasBoss).toBe(true);
    expect(c.issues).toHaveLength(0);
  });

  it("is incomplete when there is no mission", () => {
    const c = auditChapter(chapter("01-a", { exercises: [] }));
    expect(c.complete).toBe(false);
    expect(c.exerciseCount).toBe(0);
    expect(c.issues.join(" ")).toContain("aucune mission");
  });

  it("notes a missing boss but stays complete (advisory)", () => {
    const c = auditChapter(chapter("01-a", { exercises: [exercise("01-pratique", "practice")] }));
    expect(c.complete).toBe(true);
    expect(c.hasBoss).toBe(false);
    expect(c.issues.join(" ")).toContain("boss");
  });

  it("is incomplete when the course or summary is blank", () => {
    const c = auditChapter(chapter("01-a", { lesson: "   ", summary: "" }));
    expect(c.complete).toBe(false);
    expect(c.hasCourse).toBe(false);
    expect(c.hasSummary).toBe(false);
  });

  it("is incomplete when the quiz is empty", () => {
    const c = auditChapter(chapter("01-a", { quiz: { questions: [] } }));
    expect(c.complete).toBe(false);
    expect(c.hasQuiz).toBe(false);
  });
});

// --- auditGrade -----------------------------------------------------------

describe("auditGrade", () => {
  it("reports a fully covered, complete subject with no findings", () => {
    const subjects = [subject("math-1ere", "ar", [chapter("01-a"), chapter("02-b")])];
    const g = auditGrade(manifest(), subjects);
    expect(g.findingCount).toBe(0);
    expect(g.subjects[0].present).toBe(true);
    expect(g.subjects[0].coveragePct).toBe(100);
    expect(g.subjects[0].presentExpected).toBe(2);
  });

  it("flags a subject absent from the catalogue", () => {
    const g = auditGrade(manifest(), []);
    const s = g.subjects[0];
    expect(s.present).toBe(false);
    expect(s.coveragePct).toBe(0);
    expect(s.missingChapters).toEqual(["01-a", "02-b"]);
    expect(s.findings[0].level).toBe("missing-subject");
  });

  it("flags a missing chapter", () => {
    const subjects = [subject("math-1ere", "ar", [chapter("01-a")])];
    const g = auditGrade(manifest(), subjects);
    const s = g.subjects[0];
    expect(s.missingChapters).toEqual(["02-b"]);
    expect(s.coveragePct).toBe(50);
    expect(s.findings.some((f) => f.level === "missing-chapter")).toBe(true);
  });

  it("does not flag an optional missing chapter", () => {
    const m = manifest({
      subjects: [
        {
          id: "math-1ere",
          contentLanguage: "ar",
          chapters: [
            { slug: "01-a", notion: "A", optional: false },
            { slug: "02-b", notion: "B", optional: true },
          ],
        },
      ],
    });
    const subjects = [subject("math-1ere", "ar", [chapter("01-a")])];
    const g = auditGrade(m, subjects);
    expect(g.subjects[0].missingChapters).toHaveLength(0);
    expect(g.findingCount).toBe(0);
  });

  it("flags an off-program chapter", () => {
    const subjects = [
      subject("math-1ere", "ar", [chapter("01-a"), chapter("02-b"), chapter("99-extra")]),
    ];
    const g = auditGrade(manifest(), subjects);
    const s = g.subjects[0];
    expect(s.offProgramChapters).toEqual(["99-extra"]);
    expect(s.findings.some((f) => f.level === "off-program")).toBe(true);
  });

  it("flags an incomplete present chapter", () => {
    const subjects = [
      subject("math-1ere", "ar", [chapter("01-a"), chapter("02-b", { exercises: [] })]),
    ];
    const g = auditGrade(manifest(), subjects);
    const s = g.subjects[0];
    expect(s.findings.some((f) => f.level === "incomplete")).toBe(true);
    expect(s.chapterCompleteness.some((c) => c.slug === "02-b" && !c.complete)).toBe(true);
  });

  it("flags a language mismatch", () => {
    const subjects = [subject("math-1ere", "fr", [chapter("01-a"), chapter("02-b")])];
    const g = auditGrade(manifest(), subjects);
    expect(g.subjects[0].languageOk).toBe(false);
    expect(g.subjects[0].findings.some((f) => f.level === "language")).toBe(true);
  });

  it("skips chapter coverage when the chapter list is not codified", () => {
    const m = manifest({ subjects: [{ id: "math-1ere", contentLanguage: "ar", chapters: [] }] });
    const subjects = [subject("math-1ere", "ar", [chapter("01-a")])];
    const g = auditGrade(m, subjects);
    const s = g.subjects[0];
    expect(s.chaptersCodified).toBe(false);
    expect(s.coveragePct).toBeNull();
    expect(s.offProgramChapters).toHaveLength(0);
    expect(s.missingChapters).toHaveLength(0);
  });

  it("carries the grade's sealed flag and totals findings", () => {
    const g = auditGrade(manifest({ sealed: true }), []);
    expect(g.sealed).toBe(true);
    expect(g.findingCount).toBeGreaterThan(0);
  });
});

// --- schema ---------------------------------------------------------------

describe("programManifestSchema", () => {
  it("parses a valid manifest and defaults sealed/optional", () => {
    const parsed = programManifestSchema.parse({
      grade: "1ere-base",
      subjects: [
        { id: "math-1ere", contentLanguage: "ar", chapters: [{ slug: "01-a", notion: "A" }] },
      ],
    });
    expect(parsed.sealed).toBe(false);
    expect(parsed.subjects[0].chapters[0].optional).toBe(false);
  });

  it("rejects a manifest with no subjects", () => {
    expect(() => programManifestSchema.parse({ grade: "x", subjects: [] })).toThrow();
  });

  it("rejects a non-kebab chapter slug", () => {
    const bad = {
      grade: "x",
      subjects: [
        { id: "math-1ere", contentLanguage: "ar", chapters: [{ slug: "Bad_Slug", notion: "n" }] },
      ],
    };
    expect(() => programManifestSchema.parse(bad)).toThrow();
  });
});
