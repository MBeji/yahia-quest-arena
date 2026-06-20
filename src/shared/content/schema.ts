import { z } from "zod";

/**
 * Validation schemas for the versioned content pipeline.
 *
 * Pedagogical content lives as plain files under `content/<subject>/...`
 * (see content/README.md) and is compiled into idempotent Supabase
 * migrations by `scripts/content/build.ts`. These schemas are the single
 * source of truth for the shape of those files: anything that does not
 * validate never reaches the database.
 */

export const CONTENT_LANGUAGES = ["ar", "fr", "en"] as const;
export type ContentLanguage = (typeof CONTENT_LANGUAGES)[number];

/** A url, or a short free-form reference to a local repo / book. */
const sourceRefSchema = z.string().min(3, "a source reference must be at least 3 characters");

/** `subject.json` — maps onto the `subjects` table (one per subject). */
export const subjectMetaSchema = z.object({
  id: z.string().regex(/^[a-z][a-z0-9-]*$/, "subject id must be kebab-case (e.g. 'math')"),
  /**
   * The subject's display name, written in its OWN `contentLanguage`
   * (ar → "الرياضيات", en → "English", fr → "Français"). The field name is
   * legacy — it predates multilingual subjects — and is kept only for
   * DB/column compatibility (`subjects.name_fr`); the value is native, not French.
   */
  nameFr: z.string().min(1),
  description: z.string().min(1),
  attribute: z.string().min(1),
  colorToken: z.string().min(1),
  icon: z.string().min(1),
  displayOrder: z.number().int().positive(),
  contentLanguage: z.enum(CONTENT_LANGUAGES),
  /**
   * Theme this subject belongs to (FK → `themes.id`). Required: every subject
   * lives under exactly one theme, e.g. `ecole-tn` (Tunisian school program) or
   * a standalone module theme such as `francais`.
   */
  themeId: z.string().regex(/^[a-z][a-z0-9-]*$/, "themeId must be kebab-case (e.g. 'ecole-tn')"),
  /**
   * Grade within the theme's ladder, referenced by its stable `grades.slug`
   * (e.g. `9eme-base`). `null` for grade-agnostic subjects — only graded themes
   * (today `ecole-tn`) carry a grade. The compiled SQL resolves the slug to the
   * grade UUID, so content never hard-codes ids. Defaults to `null`.
   */
  gradeSlug: z.string().min(1).nullable().default(null),
  /**
   * Premium module: when true, the whole subject (chapters, exercises, quiz) is
   * reserved to users with an active subscription (gated server-side). Used by
   * the standalone "Maîtrise du français" module. Defaults to false.
   */
  isPremium: z.boolean().default(false),
});
export type SubjectMeta = z.infer<typeof subjectMetaSchema>;

/** `chapter.json` — maps onto a row in `chapters`. */
export const chapterMetaSchema = z.object({
  title: z.string().min(1),
  description: z.string().min(1),
  displayOrder: z.number().int().positive(),
  /** Provenance: URLs / repos / books the chapter was built from. */
  sources: z.array(sourceRefSchema).default([]),
});
export type ChapterMeta = z.infer<typeof chapterMetaSchema>;

const optionSchema = z.object({
  id: z.string().min(1),
  text: z.string().min(1),
});

export const questionSchema = z
  .object({
    prompt: z.string().min(1),
    options: z.array(optionSchema).min(2).max(6),
    correctOption: z.string().min(1),
    explanation: z.string().min(1),
    /**
     * Per-question difficulty (1 = easy … 3 = hard). Questions within an
     * exercise/quiz are emitted ordered by ascending difficulty. Optional;
     * untagged questions default to medium (2) for ordering.
     */
    difficulty: z.number().int().min(1).max(3).optional(),
  })
  .refine((q) => new Set(q.options.map((o) => o.id)).size === q.options.length, {
    message: "option ids must be unique",
    path: ["options"],
  })
  .refine((q) => q.options.some((o) => o.id === q.correctOption), {
    message: "correctOption must match one of the option ids",
    path: ["correctOption"],
  });
export type ContentQuestion = z.infer<typeof questionSchema>;

/**
 * `quiz.json` — the mandatory comprehension quiz of a chapter. Compiled into
 * an `exercises` row with `mode='quiz'` that gates the chapter's exercises.
 */
export const quizSchema = z.object({
  title: z.string().min(1).optional(),
  questions: z.array(questionSchema).min(3).max(10),
});
export type ContentQuiz = z.infer<typeof quizSchema>;

/** An exercise file under `<chapter>/exercices/*.json`. */
export const exerciseSchema = z.object({
  title: z.string().min(1),
  /**
   * Exercise tier: 1 (easy) … 3 (boss). 4 is the premium "Défi élite" tier —
   * exercises clearly above the chapter average, gated behind a paid
   * subscription + a minimum player level (see startExerciseSession).
   */
  difficulty: z.number().int().min(1).max(4),
  mode: z.enum(["practice", "boss", "challenge"]),
  xpReward: z.number().int().positive(),
  rewardCoins: z.number().int().nonnegative(),
  displayOrder: z.number().int().positive(),
  questions: z.array(questionSchema).min(1).max(50),
});
export type ContentExercise = z.infer<typeof exerciseSchema>;

/** A fully loaded exercise (file contents + its source slug). */
export interface LoadedExercise {
  slug: string;
  data: ContentExercise;
}

/** A fully loaded chapter: metadata + markdown bodies + exercises. */
export interface LoadedChapter {
  slug: string;
  meta: ChapterMeta;
  /** Full theoretical course (markdown), stored in `chapters.lesson_content`. */
  lesson: string;
  /** Course summary (markdown), stored in `chapters.summary`. */
  summary: string;
  /** Mandatory comprehension quiz (compiled to a `mode='quiz'` exercise). */
  quiz: ContentQuiz;
  exercises: LoadedExercise[];
}

/** A fully loaded subject and all of its chapters. */
export interface LoadedSubject {
  meta: SubjectMeta;
  chapters: LoadedChapter[];
}
