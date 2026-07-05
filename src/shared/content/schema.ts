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

/**
 * Expand a manuel page-range expression into a sorted, de-duplicated list of
 * 1-based page numbers. Single pages and inclusive ranges, comma-separated:
 *   "12"            → [12]
 *   "12-15"         → [12, 13, 14, 15]
 *   "12-15, 18, 20" → [12, 13, 14, 15, 18, 20]
 * Throws on a malformed token or a descending range (start > end).
 */
export function parseManuelPages(pages: string): number[] {
  const out: number[] = [];
  for (const raw of pages.split(",")) {
    const seg = raw.trim();
    if (seg === "") continue;
    const range = seg.match(/^(\d+)\s*-\s*(\d+)$/);
    if (range) {
      const start = Number(range[1]);
      const end = Number(range[2]);
      if (start > end) throw new Error(`manuel page range "${seg}" is descending (start > end)`);
      for (let p = start; p <= end; p++) out.push(p);
    } else if (/^\d+$/.test(seg)) {
      out.push(Number(seg));
    } else {
      throw new Error(`manuel page token "${seg}" is not a page number or range`);
    }
  }
  return [...new Set(out)].sort((a, b) => a - b);
}

/** `chapter.json` — maps onto a row in `chapters`. */
export const chapterMetaSchema = z.object({
  title: z.string().min(1),
  description: z.string().min(1),
  displayOrder: z.number().int().positive(),
  /** Provenance: URLs / repos / books the chapter was built from. */
  sources: z.array(sourceRefSchema).default([]),
  /**
   * Optional link to the official student textbook (manuel élève): the CNP
   * book `code` plus the `pages` covering this chapter (a 1-based range
   * expression — "12-15", "12, 14-16"). Compiled into the `chapters.manuel_ref`
   * JSONB column and surfaced as a login-gated "Pages du manuel" gallery under
   * the course. Both fields are required when `manuel` is present.
   */
  manuel: z
    .object({
      code: z.string().regex(/^[A-Za-z0-9_-]+$/, "manuel.code must be an alphanumeric book code"),
      pages: z.string().min(1),
    })
    .refine(
      (m) => {
        try {
          const ps = parseManuelPages(m.pages);
          return ps.length > 0 && ps.every((p) => p >= 1);
        } catch {
          return false;
        }
      },
      {
        message: "manuel.pages must be a 1-based page range like '12-15' or '12, 14-16'",
        path: ["pages"],
      },
    )
    .optional(),
});
export type ChapterMeta = z.infer<typeof chapterMetaSchema>;

const optionSchema = z.object({
  id: z.string().min(1),
  text: z.string().min(1),
});

const questionCoreSchema = z.object({
  prompt: z.string().min(1),
  explanation: z.string().min(1),
  /**
   * Per-question difficulty (1 = easy … 3 = hard). Questions within an
   * exercise/quiz are emitted ordered by ascending difficulty. Optional;
   * untagged questions default to medium (2) for ordering.
   */
  difficulty: z.number().int().min(1).max(3).optional(),
});

/** The classic QCM — `type` may be omitted in files (defaulted to 'mcq'). */
const mcqQuestionSchema = questionCoreSchema.extend({
  type: z.literal("mcq"),
  options: z.array(optionSchema).min(2).max(6),
  correctOption: z.string().min(1),
});

/** Typed key of a native `numeric` question → `questions.answer_key`. */
export const numericAnswerKeySchema = z.object({
  /** The canonical answer (standard Western-digit notation). */
  value: z.number().finite(),
  /** Accepted absolute deviation; omitted = exact match (0). */
  tolerance: z.number().nonnegative().finite().optional(),
  /** Optional unit label — informative only; the unit hint belongs in the prompt. */
  unit: z.string().min(1).optional(),
});
export type NumericAnswerKey = z.infer<typeof numericAnswerKeySchema>;

/**
 * Native free-numeric-entry question (Tier B, phase B1 — see
 * docs/interactive-question-types.md). No options: the student types the
 * number; the server scores `abs(x − value) <= tolerance` via `score_answer`.
 */
const numericQuestionSchema = questionCoreSchema.extend({
  type: z.literal("numeric"),
  answerKey: numericAnswerKeySchema,
});

/**
 * Ids used in the B2 wire formats travel inside CSV/pair encodings, so they
 * may not contain `,`, `:` or whitespace. Kebab/alnum, like the `a`–`d` and
 * `l1`/`r1` conventions.
 */
const wireIdSchema = z
  .string()
  .regex(/^[A-Za-z0-9_-]+$/, "B2 option ids must be alphanumeric (no ',', ':' or spaces)");

const wireOptionSchema = z.object({ id: wireIdSchema, text: z.string().min(1) });

/**
 * Native drag-&-drop sequencing question (Tier B, phase B2): `options` are the
 * steps (shuffled at render); `answerKey.order` is the correct id sequence —
 * validated below as an exact permutation of the option ids.
 */
const orderingQuestionSchema = questionCoreSchema.extend({
  type: z.literal("ordering"),
  options: z.array(wireOptionSchema).min(3).max(6),
  answerKey: z.object({ order: z.array(wireIdSchema).min(3).max(6) }),
});

/**
 * Native drag-&-drop pair-alignment question (Tier B, phase B2): `options`
 * carry the fixed left items (`l…` ids) and the movable right items (`r…`
 * ids); `answerKey.pairs` is the correct left→right association — validated
 * below as a bijection between the two sides.
 */
const matchingQuestionSchema = questionCoreSchema.extend({
  type: z.literal("matching"),
  options: z.array(wireOptionSchema).min(4).max(12),
  answerKey: z.object({
    pairs: z
      .array(z.tuple([wireIdSchema, wireIdSchema]))
      .min(2)
      .max(6),
  }),
});

/**
 * A question file entry — discriminated on `type`, defaulting to `'mcq'` so
 * every pre-existing content file stays valid without edits (spec D-4).
 * The not-yet-shipped `multi` (phase B3) is NOT a member: authoring it stays
 * schema-rejected until its phase ships.
 */
export const questionSchema = z
  .preprocess(
    (val) =>
      val !== null && typeof val === "object" && !("type" in val)
        ? { ...(val as Record<string, unknown>), type: "mcq" }
        : val,
    z.discriminatedUnion("type", [
      mcqQuestionSchema,
      numericQuestionSchema,
      orderingQuestionSchema,
      matchingQuestionSchema,
    ]),
  )
  .superRefine((q, ctx) => {
    if (q.type === "numeric") return;
    if (new Set(q.options.map((o) => o.id)).size !== q.options.length) {
      ctx.addIssue({ code: "custom", message: "option ids must be unique", path: ["options"] });
    }
    if (q.type === "mcq") {
      if (!q.options.some((o) => o.id === q.correctOption)) {
        ctx.addIssue({
          code: "custom",
          message: "correctOption must match one of the option ids",
          path: ["correctOption"],
        });
      }
      return;
    }
    if (q.type === "ordering") {
      // The key must arrange EXACTLY the authored steps (a permutation).
      const ids = q.options.map((o) => o.id).sort();
      const order = [...q.answerKey.order].sort();
      if (ids.length !== order.length || ids.some((id, i) => id !== order[i])) {
        ctx.addIssue({
          code: "custom",
          message: "answerKey.order must be a permutation of the option ids",
          path: ["answerKey", "order"],
        });
      }
      return;
    }
    // matching: options split into l*/r* sides; pairs must be a bijection.
    const lefts = q.options.filter((o) => o.id.startsWith("l")).map((o) => o.id);
    const rights = q.options.filter((o) => o.id.startsWith("r")).map((o) => o.id);
    if (lefts.length + rights.length !== q.options.length) {
      ctx.addIssue({
        code: "custom",
        message: "matching option ids must start with 'l' (left) or 'r' (right)",
        path: ["options"],
      });
      return;
    }
    if (lefts.length < 2 || lefts.length !== rights.length) {
      ctx.addIssue({
        code: "custom",
        message: "matching needs >= 2 left items and as many right items",
        path: ["options"],
      });
      return;
    }
    const pairLefts = q.answerKey.pairs.map(([l]) => l).sort();
    const pairRights = q.answerKey.pairs.map(([, r]) => r).sort();
    const wantLefts = [...lefts].sort();
    const wantRights = [...rights].sort();
    if (
      pairLefts.length !== wantLefts.length ||
      pairLefts.some((id, i) => id !== wantLefts[i]) ||
      pairRights.some((id, i) => id !== wantRights[i])
    ) {
      ctx.addIssue({
        code: "custom",
        message: "answerKey.pairs must pair every left id with every right id exactly once",
        path: ["answerKey", "pairs"],
      });
    }
  });
export type ContentQuestion = z.infer<typeof questionSchema>;
export type ContentMcqQuestion = Extract<ContentQuestion, { type: "mcq" }>;
export type ContentNumericQuestion = Extract<ContentQuestion, { type: "numeric" }>;
export type ContentOrderingQuestion = Extract<ContentQuestion, { type: "ordering" }>;
export type ContentMatchingQuestion = Extract<ContentQuestion, { type: "matching" }>;

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
