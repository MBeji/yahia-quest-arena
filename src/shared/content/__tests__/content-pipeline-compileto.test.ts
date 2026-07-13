/**
 * Mutualisation `compileTo` (étude 16 D-4, lot 1) — one authored directory
 * compiled into N per-section subjects.
 *
 * Covers: the subject/chapter/exercise schema extensions, the pure
 * `expandSubjects` expansion (overrides, narrowing filters, error cases,
 * global id uniqueness) and the R-7 invariant — a compiled subject produces
 * byte-identical SQL to a standalone directory with the same compiled
 * identity, so forking a section out of a shared dir is loss-free.
 */
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, describe, expect, it } from "vitest";
import {
  chapterMetaSchema,
  exerciseSchema,
  subjectMetaWithCompileToSchema,
  type ContentExercise,
  type LoadedChapter,
  type LoadedExercise,
  type LoadedSubject,
  type SubjectMeta,
} from "../schema.ts";
import { ContentValidationError, expandSubjects, loadSubject } from "../loader.ts";
import { buildMigrationSql } from "../sql-builder.ts";

// ---------------------------------------------------------------------------
// Fixtures (pure, in-memory — expandSubjects needs no filesystem)
// ---------------------------------------------------------------------------

const question = {
  type: "mcq" as const,
  prompt: "p",
  options: [
    { id: "a", text: "1" },
    { id: "b", text: "2" },
  ],
  correctOption: "a",
  explanation: "e",
};

function makeExercise(slug: string, over: Partial<ContentExercise> = {}): LoadedExercise {
  return {
    slug,
    data: {
      title: slug,
      difficulty: 1,
      mode: "practice",
      xpReward: 50,
      rewardCoins: 10,
      displayOrder: 1,
      questions: [question],
      ...over,
    },
  };
}

function makeChapter(
  slug: string,
  over: { gradeSlugs?: string[]; exercises?: LoadedExercise[]; displayOrder?: number } = {},
): LoadedChapter {
  return {
    slug,
    meta: {
      title: slug,
      description: "d",
      displayOrder: over.displayOrder ?? 1,
      sources: [],
      ...(over.gradeSlugs ? { gradeSlugs: over.gradeSlugs } : {}),
    },
    lesson: "# cours",
    summary: "## résumé",
    quiz: { questions: [question, question, question] },
    exercises: over.exercises ?? [makeExercise("01-pratique")],
  };
}

function makeMeta(over: Partial<SubjectMeta> = {}): SubjectMeta {
  return {
    id: "arabe-bac",
    nameFr: "العربية",
    description: "desc",
    attribute: "Sagesse",
    colorToken: "subject-arabic",
    icon: "BookOpen",
    displayOrder: 1,
    contentLanguage: "ar",
    themeId: "ecole-tn",
    gradeSlug: null,
    isPremium: false,
    ...over,
  };
}

const TWO_TARGETS = [
  { id: "arabe-bac-lettres", gradeSlug: "bac-lettres" },
  { id: "arabe-bac-eco-gestion", gradeSlug: "bac-eco-gestion" },
];

// ---------------------------------------------------------------------------
// Schema extensions
// ---------------------------------------------------------------------------

describe("subjectMetaWithCompileToSchema", () => {
  const base = {
    id: "arabe-bac",
    nameFr: "العربية",
    description: "desc",
    attribute: "Sagesse",
    colorToken: "subject-arabic",
    icon: "BookOpen",
    displayOrder: 1,
    contentLanguage: "ar",
    themeId: "ecole-tn",
  };

  it("accepts a valid shared subject (no root gradeSlug, >= 2 section targets)", () => {
    const r = subjectMetaWithCompileToSchema.safeParse({ ...base, compileTo: TWO_TARGETS });
    expect(r.success).toBe(true);
    if (r.success) expect(r.data.compileTo).toHaveLength(2);
  });

  it("stays backward-compatible for plain subjects", () => {
    expect(
      subjectMetaWithCompileToSchema.safeParse({ ...base, gradeSlug: "9eme-base" }).success,
    ).toBe(true);
  });

  it.each([
    ["root gradeSlug set", { gradeSlug: "bac-lettres", compileTo: TWO_TARGETS }],
    ["fewer than 2 targets", { compileTo: [TWO_TARGETS[0]] }],
    [
      "duplicate target ids",
      { compileTo: [TWO_TARGETS[0], { ...TWO_TARGETS[1], id: "arabe-bac-lettres" }] },
    ],
    [
      "duplicate target gradeSlugs",
      { compileTo: [TWO_TARGETS[0], { id: "x-bac-lettres", gradeSlug: "bac-lettres" }] },
    ],
    [
      "unknown gradeSlug",
      { compileTo: [TWO_TARGETS[0], { id: "arabe-bac-lettre", gradeSlug: "bac-lettre" }] },
    ],
    [
      "legacy flat gradeSlug",
      { compileTo: [TWO_TARGETS[0], { id: "arabe-bac", gradeSlug: "bac" }] },
    ],
    [
      "id not ending with the gradeSlug",
      { compileTo: [TWO_TARGETS[0], { id: "arabe-eco", gradeSlug: "bac-eco-gestion" }] },
    ],
    [
      "target id equal to the source id",
      {
        id: "arabe-bac-lettres",
        compileTo: [TWO_TARGETS[0], TWO_TARGETS[1]],
      },
    ],
  ])("rejects %s", (_label, over) => {
    expect(subjectMetaWithCompileToSchema.safeParse({ ...base, ...over }).success).toBe(false);
  });
});

describe("gradeSlugs narrowing fields", () => {
  it("chapter.json accepts a unique gradeSlugs subset and rejects duplicates", () => {
    const base = { title: "t", description: "d", displayOrder: 1 };
    expect(chapterMetaSchema.safeParse({ ...base, gradeSlugs: ["bac-lettres"] }).success).toBe(
      true,
    );
    expect(chapterMetaSchema.safeParse({ ...base, gradeSlugs: [] }).success).toBe(false);
    expect(
      chapterMetaSchema.safeParse({ ...base, gradeSlugs: ["bac-lettres", "bac-lettres"] }).success,
    ).toBe(false);
  });

  it("exercise files accept gradeSlugs", () => {
    const r = exerciseSchema.safeParse({
      ...makeExercise("04-defi").data,
      gradeSlugs: ["bac-lettres"],
    });
    expect(r.success).toBe(true);
  });
});

// ---------------------------------------------------------------------------
// expandSubjects — expansion, filters, errors
// ---------------------------------------------------------------------------

describe("expandSubjects", () => {
  it("passes plain subjects through unchanged", () => {
    const plain: LoadedSubject = {
      meta: makeMeta({ id: "math", gradeSlug: "9eme-base" }),
      chapters: [makeChapter("01-x")],
    };
    const out = expandSubjects([plain]);
    expect(out).toHaveLength(1);
    expect(out[0]).toBe(plain);
  });

  it("expands one shared subject into one compiled subject per target", () => {
    const shared: LoadedSubject = {
      meta: makeMeta({
        compileTo: [
          TWO_TARGETS[0],
          { ...TWO_TARGETS[1], nameFr: "خاص", description: "spéciale éco" },
        ],
      }),
      chapters: [makeChapter("01-x")],
    };
    const out = expandSubjects([shared]);
    expect(out.map((s) => s.meta.id)).toEqual(["arabe-bac-lettres", "arabe-bac-eco-gestion"]);
    expect(out.map((s) => s.meta.gradeSlug)).toEqual(["bac-lettres", "bac-eco-gestion"]);
    // nameFr/description default to the source, per-target overrides win.
    expect(out[0].meta.nameFr).toBe("العربية");
    expect(out[0].meta.description).toBe("desc");
    expect(out[1].meta.nameFr).toBe("خاص");
    expect(out[1].meta.description).toBe("spéciale éco");
    // The compiled meta never carries compileTo (the id that reaches SQL is final).
    expect(out[0].meta.compileTo).toBeUndefined();
    expect(out[1].meta.compileTo).toBeUndefined();
  });

  it("filters chapters and exercises by their gradeSlugs narrowing", () => {
    const shared: LoadedSubject = {
      meta: makeMeta({ compileTo: TWO_TARGETS }),
      chapters: [
        makeChapter("01-commun", {
          exercises: [
            makeExercise("01-pratique"),
            makeExercise("04-defi-lettres", { gradeSlugs: ["bac-lettres"], difficulty: 4 }),
          ],
        }),
        makeChapter("02-lettres-seulement", { gradeSlugs: ["bac-lettres"], displayOrder: 2 }),
      ],
    };
    const [lettres, eco] = expandSubjects([shared]);
    expect(lettres.chapters.map((c) => c.slug)).toEqual(["01-commun", "02-lettres-seulement"]);
    expect(lettres.chapters[0].exercises.map((e) => e.slug)).toEqual([
      "01-pratique",
      "04-defi-lettres",
    ]);
    expect(eco.chapters.map((c) => c.slug)).toEqual(["01-commun"]);
    expect(eco.chapters[0].exercises.map((e) => e.slug)).toEqual(["01-pratique"]);
  });

  it.each([
    [
      "chapter gradeSlugs without compileTo",
      {
        meta: makeMeta({ id: "math", gradeSlug: "9eme-base" }),
        chapters: [makeChapter("01-x", { gradeSlugs: ["bac-lettres"] })],
      },
    ],
    [
      "exercise gradeSlugs without compileTo",
      {
        meta: makeMeta({ id: "math", gradeSlug: "9eme-base" }),
        chapters: [
          makeChapter("01-x", {
            exercises: [makeExercise("01-p", { gradeSlugs: ["bac-lettres"] })],
          }),
        ],
      },
    ],
    [
      "chapter narrowing outside the targets",
      {
        meta: makeMeta({ compileTo: TWO_TARGETS }),
        chapters: [makeChapter("01-x", { gradeSlugs: ["bac-math"] })],
      },
    ],
    [
      "exercise narrowing outside the chapter's effective set",
      {
        meta: makeMeta({ compileTo: TWO_TARGETS }),
        chapters: [
          makeChapter("01-x", {
            gradeSlugs: ["bac-lettres"],
            exercises: [makeExercise("01-p", { gradeSlugs: ["bac-eco-gestion"] })],
          }),
        ],
      },
    ],
    [
      "a target left with zero chapters",
      {
        meta: makeMeta({ compileTo: TWO_TARGETS }),
        chapters: [makeChapter("01-x", { gradeSlugs: ["bac-lettres"] })],
      },
    ],
  ])("throws on %s", (_label, subject) => {
    expect(() => expandSubjects([subject as LoadedSubject])).toThrow(ContentValidationError);
  });

  it("throws when a compiled id collides with a physical subject id", () => {
    const physical: LoadedSubject = {
      meta: makeMeta({ id: "arabe-bac-lettres", gradeSlug: "bac-lettres" }),
      chapters: [makeChapter("01-x")],
    };
    const shared: LoadedSubject = {
      meta: makeMeta({ compileTo: TWO_TARGETS }),
      chapters: [makeChapter("01-x")],
    };
    expect(() => expandSubjects([physical, shared])).toThrow(/arabe-bac-lettres/);
  });

  it("throws when two shared subjects compile the same target id", () => {
    const a: LoadedSubject = {
      meta: makeMeta({ compileTo: TWO_TARGETS }),
      chapters: [makeChapter("01-x")],
    };
    const b: LoadedSubject = {
      meta: makeMeta({ id: "arabe-bac-bis", compileTo: [...TWO_TARGETS] }),
      chapters: [makeChapter("01-x")],
    };
    expect(() => expandSubjects([a, b])).toThrow(/globally unique/);
  });
});

// ---------------------------------------------------------------------------
// R-7 — fork-without-loss: compiled identity drives the SQL, not the source dir
// ---------------------------------------------------------------------------

describe("fork stability (étude 16 R-7)", () => {
  it("a compiled target and a standalone dir with the same identity emit identical SQL", () => {
    const chapters = [
      makeChapter("01-commun", {
        exercises: [
          makeExercise("01-pratique"),
          makeExercise("04-defi-lettres", { gradeSlugs: ["bac-lettres"], difficulty: 4 }),
        ],
      }),
    ];
    const shared: LoadedSubject = {
      meta: makeMeta({ compileTo: TWO_TARGETS }),
      chapters,
    };
    const compiledLettres = expandSubjects([shared])[0];

    // The "fork": the same content moved to a dedicated directory whose
    // subject.json carries the compiled identity directly. (The lingering
    // exercise-level gradeSlugs marker is irrelevant to the SQL — the builder
    // reads named fields only — so the fork may keep or drop it.)
    const standalone: LoadedSubject = {
      meta: makeMeta({ id: "arabe-bac-lettres", gradeSlug: "bac-lettres" }),
      chapters,
    };

    expect(buildMigrationSql(compiledLettres)).toBe(buildMigrationSql(standalone));
  });
});

// ---------------------------------------------------------------------------
// Filesystem integration — a real shared directory loads and expands
// ---------------------------------------------------------------------------

describe("shared directory end to end", () => {
  const root = mkdtempSync(join(tmpdir(), "content-compileto-"));

  afterAll(() => {
    rmSync(root, { recursive: true, force: true });
  });

  it("loadSubject + expandSubjects compile a shared dir into its targets", () => {
    const dir = join(root, "arabe-bac");
    const chapterDir = join(dir, "01-nahw");
    const exDir = join(chapterDir, "exercices");
    mkdirSync(exDir, { recursive: true });

    writeFileSync(
      join(dir, "subject.json"),
      JSON.stringify({
        id: "arabe-bac",
        nameFr: "العربية",
        description: "desc",
        attribute: "Sagesse",
        colorToken: "subject-arabic",
        icon: "BookOpen",
        displayOrder: 1,
        contentLanguage: "ar",
        themeId: "ecole-tn",
        compileTo: TWO_TARGETS,
      }),
    );
    writeFileSync(
      join(chapterDir, "chapter.json"),
      JSON.stringify({ title: "النحو", description: "d", displayOrder: 1 }),
    );
    writeFileSync(join(chapterDir, "cours.md"), "# cours");
    writeFileSync(join(chapterDir, "resume.md"), "## résumé");
    writeFileSync(
      join(chapterDir, "quiz.json"),
      JSON.stringify({ questions: [question, question, question] }),
    );
    writeFileSync(
      join(exDir, "01-pratique.json"),
      JSON.stringify(makeExercise("01-pratique").data),
    );
    writeFileSync(
      join(exDir, "04-defi.json"),
      JSON.stringify({
        ...makeExercise("04-defi", { difficulty: 4, mode: "challenge", displayOrder: 2 }).data,
        gradeSlugs: ["bac-lettres"],
      }),
    );

    const compiled = expandSubjects([loadSubject(dir)]);
    expect(compiled.map((s) => s.meta.id)).toEqual(["arabe-bac-lettres", "arabe-bac-eco-gestion"]);
    expect(compiled[0].chapters[0].exercises.map((e) => e.slug)).toEqual([
      "01-pratique",
      "04-defi",
    ]);
    expect(compiled[1].chapters[0].exercises.map((e) => e.slug)).toEqual(["01-pratique"]);
  });
});
