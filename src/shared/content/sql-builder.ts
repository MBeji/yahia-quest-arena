import { createHash } from "node:crypto";
import type { LoadedSubject } from "./schema.ts";

/**
 * Pure helpers that turn a {@link LoadedSubject} into an idempotent SQL
 * migration. No filesystem access here so it stays trivially testable.
 */

/** Fixed namespace so generated ids are stable across machines and runs. */
export const CONTENT_UUID_NAMESPACE = "5f1d6b6e-2a4c-5e7b-9c3a-7d2e1f0a8b44";

/** Deterministic RFC-4122 v5 UUID (SHA-1 based) for a given name. */
export function uuidV5(name: string, namespace: string = CONTENT_UUID_NAMESPACE): string {
  const nsBytes = Buffer.from(namespace.replace(/-/g, ""), "hex");
  const hash = createHash("sha1").update(nsBytes).update(Buffer.from(name, "utf8")).digest();
  const bytes = hash.subarray(0, 16);
  bytes[6] = (bytes[6] & 0x0f) | 0x50; // version 5
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // RFC variant
  const hex = bytes.toString("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20, 32)}`;
}

export const chapterId = (subjectId: string, chapterSlug: string): string =>
  uuidV5(`${subjectId}/${chapterSlug}`);

export const exerciseId = (subjectId: string, chapterSlug: string, exerciseSlug: string): string =>
  uuidV5(`${subjectId}/${chapterSlug}/${exerciseSlug}`);

export const questionId = (
  subjectId: string,
  chapterSlug: string,
  exerciseSlug: string,
  index: number,
): string => uuidV5(`${subjectId}/${chapterSlug}/${exerciseSlug}/q${index}`);

/** Single-quote a string literal for SQL, escaping embedded quotes. */
export function sqlString(value: string): string {
  return `'${value.replace(/'/g, "''")}'`;
}

/** Serialize a value as a jsonb literal. */
export function sqlJson(value: unknown): string {
  return `${sqlString(JSON.stringify(value))}::jsonb`;
}

const sqlIdList = (ids: string[]): string => ids.map(sqlString).join(", ");

/**
 * Build an idempotent migration for one subject. Re-running it converges
 * the database to exactly the supplied content:
 *  - subject / chapters / exercises / questions are upserted by id,
 *  - admin-authored rows for the subject that are no longer present are
 *    pruned (parent-authored exercises are never touched).
 */
export function buildMigrationSql(subject: LoadedSubject): string {
  const { meta, chapters } = subject;
  const subjectId = meta.id;

  const chapterIds: string[] = [];
  const exerciseIds: string[] = [];
  const questionIds: string[] = [];

  const out: string[] = [];
  out.push(
    "-- =========================================================",
    `-- GENERATED FILE — do not edit by hand.`,
    `-- Subject: ${subjectId} (${meta.nameFr})`,
    `-- Regenerate with: npm run content:build`,
    `-- Source of truth: content/${subjectId}/`,
    "-- =========================================================",
    "",
  );

  // --- Subject (upsert) ---
  out.push(
    "INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language) VALUES",
    `  (${sqlString(subjectId)}, ${sqlString(meta.nameFr)}, ${sqlString(meta.description)}, ${sqlString(
      meta.attribute,
    )}, ${sqlString(meta.colorToken)}, ${sqlString(meta.icon)}, ${meta.displayOrder}, ${sqlString(
      meta.contentLanguage,
    )})`,
    "ON CONFLICT (id) DO UPDATE SET",
    "  name_fr = EXCLUDED.name_fr,",
    "  description = EXCLUDED.description,",
    "  attribute = EXCLUDED.attribute,",
    "  color_token = EXCLUDED.color_token,",
    "  icon = EXCLUDED.icon,",
    "  display_order = EXCLUDED.display_order,",
    "  content_language = EXCLUDED.content_language;",
    "",
  );

  // Pre-compute ids so cleanup can reference the managed set.
  for (const chapter of chapters) {
    chapterIds.push(chapterId(subjectId, chapter.slug));
    for (const exercise of chapter.exercises) {
      const exId = exerciseId(subjectId, chapter.slug, exercise.slug);
      exerciseIds.push(exId);
      exercise.data.questions.forEach((_q, i) => {
        questionIds.push(questionId(subjectId, chapter.slug, exercise.slug, i + 1));
      });
    }
  }

  // --- Prune replaced admin content (safe: parent content untouched) ---
  out.push("-- Prune admin-authored content that is no longer in the source tree.");
  if (questionIds.length > 0) {
    // Gameplay tables (e.g. dungeon_run_questions) reference questions with
    // ON DELETE RESTRICT, which would block the prune. Clear those references
    // first for the admin questions that are about to be removed. Guarded so
    // the migration also runs on databases without the dungeon tables.
    out.push(
      "DO $$",
      "BEGIN",
      "  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN",
      "    DELETE FROM public.dungeon_run_questions d",
      "    USING public.questions q, public.exercises e",
      "    WHERE d.question_id = q.id",
      "      AND q.exercise_id = e.id",
      `      AND e.subject_id = ${sqlString(subjectId)}`,
      "      AND e.source = 'admin'",
      `      AND q.id NOT IN (${sqlIdList(questionIds)});`,
      "  END IF;",
      "END $$;",
    );
  }
  if (exerciseIds.length > 0) {
    out.push(
      `DELETE FROM public.exercises WHERE subject_id = ${sqlString(subjectId)} AND source = 'admin' AND id NOT IN (${sqlIdList(
        exerciseIds,
      )});`,
    );
    if (questionIds.length > 0) {
      out.push(
        `DELETE FROM public.questions WHERE exercise_id IN (${sqlIdList(exerciseIds)}) AND id NOT IN (${sqlIdList(
          questionIds,
        )});`,
      );
    }
  }
  if (chapterIds.length > 0) {
    out.push(
      `DELETE FROM public.chapters c WHERE c.subject_id = ${sqlString(subjectId)} AND c.id NOT IN (${sqlIdList(
        chapterIds,
      )}) AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);`,
    );
  }
  out.push("");

  // --- Chapters (upsert) ---
  for (const chapter of chapters) {
    const id = chapterId(subjectId, chapter.slug);
    out.push(
      "INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES",
      `  (${sqlString(id)}, ${sqlString(subjectId)}, ${sqlString(chapter.meta.title)}, ${sqlString(
        chapter.meta.description,
      )}, ${sqlString(chapter.lesson)}, ${sqlString(chapter.summary)}, ${chapter.meta.displayOrder})`,
      "ON CONFLICT (id) DO UPDATE SET",
      "  subject_id = EXCLUDED.subject_id,",
      "  title = EXCLUDED.title,",
      "  description = EXCLUDED.description,",
      "  lesson_content = EXCLUDED.lesson_content,",
      "  summary = EXCLUDED.summary,",
      "  display_order = EXCLUDED.display_order;",
      "",
    );
  }

  // --- Exercises (upsert) ---
  for (const chapter of chapters) {
    const chId = chapterId(subjectId, chapter.slug);
    for (const exercise of chapter.exercises) {
      const exId = exerciseId(subjectId, chapter.slug, exercise.slug);
      const ex = exercise.data;
      out.push(
        "INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES",
        `  (${sqlString(exId)}, ${sqlString(chId)}, ${sqlString(subjectId)}, ${sqlString(ex.title)}, ${ex.difficulty}, ${ex.xpReward}, ${ex.rewardCoins}, ${sqlString(
          ex.mode,
        )}, 'admin', ${ex.displayOrder})`,
        "ON CONFLICT (id) DO UPDATE SET",
        "  chapter_id = EXCLUDED.chapter_id,",
        "  subject_id = EXCLUDED.subject_id,",
        "  title = EXCLUDED.title,",
        "  difficulty = EXCLUDED.difficulty,",
        "  xp_reward = EXCLUDED.xp_reward,",
        "  reward_coins = EXCLUDED.reward_coins,",
        "  mode = EXCLUDED.mode,",
        "  display_order = EXCLUDED.display_order;",
        "",
      );

      ex.questions.forEach((q, i) => {
        const qId = questionId(subjectId, chapter.slug, exercise.slug, i + 1);
        out.push(
          "INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES",
          `  (${sqlString(qId)}, ${sqlString(exId)}, ${sqlString(q.prompt)}, ${sqlJson(
            q.options,
          )}, ${sqlString(q.correctOption)}, ${sqlString(q.explanation)}, ${i + 1})`,
          "ON CONFLICT (id) DO UPDATE SET",
          "  exercise_id = EXCLUDED.exercise_id,",
          "  prompt = EXCLUDED.prompt,",
          "  options = EXCLUDED.options,",
          "  correct_option = EXCLUDED.correct_option,",
          "  explanation = EXCLUDED.explanation,",
          "  display_order = EXCLUDED.display_order;",
          "",
        );
      });
    }
  }

  return out.join("\n");
}
