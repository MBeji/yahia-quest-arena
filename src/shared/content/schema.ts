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
  nameFr: z.string().min(1),
  description: z.string().min(1),
  attribute: z.string().min(1),
  colorToken: z.string().min(1),
  icon: z.string().min(1),
  displayOrder: z.number().int().positive(),
  contentLanguage: z.enum(CONTENT_LANGUAGES),
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

/** An exercise file under `<chapter>/exercices/*.json`. */
export const exerciseSchema = z.object({
  title: z.string().min(1),
  difficulty: z.number().int().min(1).max(3),
  mode: z.enum(["practice", "boss"]),
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
  exercises: LoadedExercise[];
}

/** A fully loaded subject and all of its chapters. */
export interface LoadedSubject {
  meta: SubjectMeta;
  chapters: LoadedChapter[];
}
