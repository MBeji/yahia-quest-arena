import { createHash } from "node:crypto";
import {
  TYPABLE_CHARSET,
  expandMorphologicalVariants,
  isRecallEligible,
  normalizeRecallText,
} from "./free-answer.ts";
import { parseManuelPages, toCompiledVideo } from "./schema.ts";
import type {
  CompetencyRegistry,
  CompiledVideo,
  ContentQuestion,
  LoadedSubject,
  MisconceptionRegistry,
  VideoRegistry,
} from "./schema.ts";

/**
 * Pure helpers that turn a {@link LoadedSubject} into an idempotent SQL
 * migration. No filesystem access here so it stays trivially testable.
 */

/** Fixed namespace so generated ids are stable across machines and runs. */
export const CONTENT_UUID_NAMESPACE = "5f1d6b6e-2a4c-5e7b-9c3a-7d2e1f0a8b44";

/** Modest rewards for passing a chapter comprehension quiz. */
export const QUIZ_XP_REWARD = 20;
export const QUIZ_COIN_REWARD = 5;

/**
 * Deterministic RFC-4122 v5 UUID (SHA-1 based) for a given name.
 *
 * SHA-1 here is mandated by the v5 spec, not a security choice: this derives a
 * stable, public content id (chapter/exercise/question), never a secret or an
 * authentication token. Swapping the hash would silently change every id
 * already upserted into prod, breaking the ON CONFLICT / prune keying across
 * the whole content catalogue (see "Content pipeline" in CLAUDE.md). CodeQL's
 * js/weak-cryptographic-algorithm alert on this line is a dismissed false
 * positive — it assumes a security context that doesn't apply to id derivation.
 */
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

/** Deterministic id of a competency, derived from its stable slug (étude 07 R-1). */
export const competencyId = (slug: string): string => uuidV5(`competency/${slug}`);

/**
 * File name of a subject's content SQL on the content channel (étude 24 D-3).
 *
 * Deliberately STABLE — no timestamp: outside the migration framework the SQL is
 * regenerated in place and replayed idempotently (UUIDv5 upsert + subject-scoped
 * prune), so the same subject always owns the same file. That kills the
 * timestamp-ordering bug class (#97 → #227 → #229) for content and keeps the
 * per-subject diff readable.
 */
export const contentSqlFileName = (subjectId: string): string => `${subjectId}.sql`;

/** Stable file name of the competency registry on the same channel (D-6). */
export const COMPETENCES_SQL_FILE_NAME = "_competences_registry.sql";

/** Single-quote a string literal for SQL, escaping embedded quotes. */
export function sqlString(value: string): string {
  return `'${value.replace(/'/g, "''")}'`;
}

/** Serialize a value as a jsonb literal. */
export function sqlJson(value: unknown): string {
  return `${sqlString(JSON.stringify(value))}::jsonb`;
}

const sqlIdList = (ids: string[]): string => ids.map(sqlString).join(", ");

/** Borne de l'ensemble accepté — miroir du `.max(24)` du schéma zod (étude 20 R-2). */
export const ACCEPTED_ANSWERS_MAX = 24;

/**
 * L'ensemble accepté émis pour une question : ce que l'auteur a écrit (Tier B),
 * plus les variantes morphologiques mécaniques (Tier A, étude 20 lot 2).
 *
 * Trois gardes, dans cet ordre :
 *  - seules les questions qui CONSOMMENT l'ensemble en reçoivent : les `mcq`
 *    éligibles au Rappel, et les `short_answer` (toujours actives — lot 7).
 *    Ailleurs, en ajouter serait du bruit que personne ne lit ;
 *  - R-4 : une variante égale (après normalisation) à un élément DÉCLARÉ FAUX
 *    est écartée. La question reste jouable, seule la variante tombe — c'est
 *    ce qui préserve le « zéro exclusion » (D-2) ;
 *  - la borne des 24 : l'auteur passe d'abord, Tier A ne peut pas l'évincer.
 */
export function withMorphologicalVariants(
  q: ContentQuestion,
  language: "ar" | "fr" | "en",
): string[] {
  const authored = q.acceptedAnswers ?? [];

  // Les deux consommateurs de l'ensemble accepté, et leurs « éléments déclarés
  // faux » respectifs : les distracteurs d'un QCM rejoué en Rappel, les erreurs
  // attendues d'une question libre (étude 20 R-4, généralisé au lot 7).
  let canonical: string;
  let declaredWrong: Set<string>;
  if (q.type === "short_answer") {
    canonical = q.answerKey.text;
    declaredWrong = new Set((q.expectedMistakes ?? []).map((m) => normalizeRecallText(m.text)));
  } else if (q.type === "mcq") {
    const options = q.options ?? [];
    if (
      !isRecallEligible({ type: q.type, prompt: q.prompt, options, correctOption: q.correctOption })
    )
      return [...authored];
    canonical = options.find((o) => o.id === q.correctOption)?.text ?? "";
    declaredWrong = new Set(
      options.filter((o) => o.id !== q.correctOption).map((o) => normalizeRecallText(o.text)),
    );
  } else {
    return [...authored];
  }
  const seen = new Set([normalizeRecallText(canonical), ...authored.map(normalizeRecallText)]);

  const out = [...authored];
  for (const variant of expandMorphologicalVariants(canonical, language)) {
    if (out.length >= ACCEPTED_ANSWERS_MAX) break;
    const n = normalizeRecallText(variant);
    if (n === "" || !TYPABLE_CHARSET.test(n)) continue;
    if (declaredWrong.has(n) || seen.has(n)) continue;
    seen.add(n);
    out.push(variant);
  }
  return out;
}

/**
 * Build an idempotent migration for one subject. Re-running it converges
 * the database to exactly the supplied content:
 *  - subject / chapters / exercises / questions are upserted by id,
 *  - admin-authored rows for the subject that are no longer present are
 *    pruned (parent-authored exercises are never touched).
 */
export function buildMigrationSql(subject: LoadedSubject, videos: VideoRegistry = {}): string {
  const { meta, chapters } = subject;
  const subjectId = meta.id;

  // Resolve chapter/exercise video refs (étude 23) → compiled display objects.
  // Only `active` entries are compiled (R-12): a ref to an unknown or non-active
  // video is dropped here and reported as an error by content:qa — so passing a
  // video to `broken` and rebuilding the referencing subjects removes it from the
  // DB. The compiled shape carries no free URL (D-10).
  const resolveVideos = (refs: readonly string[] | undefined): CompiledVideo[] =>
    (refs ?? []).flatMap((ref) => {
      const entry = videos[ref];
      return entry && entry.status === "active" ? [toCompiledVideo(ref, entry)] : [];
    });

  const chapterIds: string[] = [];
  const exerciseIds: string[] = [];
  const questionIds: string[] = [];
  /** question → competency mappings asserted by this subject (étude 07 D-2). */
  const competencyRows: Array<{ questionId: string; competencyId: string; isPrimary: boolean }> =
    [];

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

  // --- Exercise modes the pipeline uses (self-contained, idempotent) ---
  // Kept here so a generated migration always allows every mode it inserts,
  // regardless of which earlier migration last touched the CHECK constraint
  // (no cross-migration ordering dependency for new modes like 'challenge').
  out.push(
    "DO $$",
    "BEGIN",
    "  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN",
    "    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;",
    "  END IF;",
    "  ALTER TABLE public.exercises",
    "    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));",
    "END $$;",
    "",
  );

  // --- Subject (upsert) ---
  // grade_id is resolved from the stable (theme_id, slug) pair so content never
  // hard-codes a UUID; NULL for grade-agnostic subjects (e.g. language modules).
  const gradeIdSql = meta.gradeSlug
    ? `(SELECT id FROM public.grades WHERE theme_id = ${sqlString(meta.themeId)} AND slug = ${sqlString(
        meta.gradeSlug,
      )})`
    : "NULL";
  // Optional manuel élève PDF link: store the authored volume list (label
  // normalized to null). NULL when unset, so re-upserting a subject that lost
  // its manuel link clears it.
  const manuelRefsSql = meta.manuels
    ? sqlJson(meta.manuels.map((m) => ({ code: m.code, label: m.label ?? null })))
    : "NULL";
  out.push(
    "INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium, theme_id, grade_id, manuel_refs) VALUES",
    `  (${sqlString(subjectId)}, ${sqlString(meta.nameFr)}, ${sqlString(meta.description)}, ${sqlString(
      meta.attribute,
    )}, ${sqlString(meta.colorToken)}, ${sqlString(meta.icon)}, ${meta.displayOrder}, ${sqlString(
      meta.contentLanguage,
    )}, ${meta.isPremium}, ${sqlString(meta.themeId)}, ${gradeIdSql}, ${manuelRefsSql})`,
    "ON CONFLICT (id) DO UPDATE SET",
    "  name_fr = EXCLUDED.name_fr,",
    "  description = EXCLUDED.description,",
    "  attribute = EXCLUDED.attribute,",
    "  color_token = EXCLUDED.color_token,",
    "  icon = EXCLUDED.icon,",
    "  display_order = EXCLUDED.display_order,",
    "  content_language = EXCLUDED.content_language,",
    "  is_premium = EXCLUDED.is_premium,",
    "  theme_id = EXCLUDED.theme_id,",
    "  grade_id = EXCLUDED.grade_id,",
    "  manuel_refs = EXCLUDED.manuel_refs;",
    "",
  );

  // Pre-compute ids so cleanup can reference the managed set. Every chapter
  // has a mandatory comprehension quiz (slug "quiz", a mode='quiz' exercise).
  for (const chapter of chapters) {
    chapterIds.push(chapterId(subjectId, chapter.slug));
    exerciseIds.push(exerciseId(subjectId, chapter.slug, "quiz"));
    chapter.quiz.questions.forEach((_q, i) => {
      questionIds.push(questionId(subjectId, chapter.slug, "quiz", i + 1));
    });
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
    // Optional manuel link: store the authored {code, pages} plus the expanded
    // pageNumbers so the UI/render pipeline never re-parses the range. NULL when
    // unset, so re-upserting a chapter that lost its manuel link clears it.
    const manuel = chapter.meta.manuel;
    const manuelSql = manuel
      ? sqlJson({
          code: manuel.code,
          pages: manuel.pages,
          pageNumbers: parseManuelPages(manuel.pages),
        })
      : "NULL";
    // Curated explainer videos (étude 23): an ordered array of compiled display
    // objects, always present ('[]' when none — the column is NOT NULL DEFAULT '[]').
    const videosSql = sqlJson(resolveVideos(chapter.meta.videos));
    out.push(
      "INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref, videos) VALUES",
      `  (${sqlString(id)}, ${sqlString(subjectId)}, ${sqlString(chapter.meta.title)}, ${sqlString(
        chapter.meta.description,
      )}, ${sqlString(chapter.lesson)}, ${sqlString(chapter.summary)}, ${chapter.meta.displayOrder}, ${manuelSql}, ${videosSql})`,
      "ON CONFLICT (id) DO UPDATE SET",
      "  subject_id = EXCLUDED.subject_id,",
      "  title = EXCLUDED.title,",
      "  description = EXCLUDED.description,",
      "  lesson_content = EXCLUDED.lesson_content,",
      "  summary = EXCLUDED.summary,",
      "  display_order = EXCLUDED.display_order,",
      "  manuel_ref = EXCLUDED.manuel_ref,",
      "  videos = EXCLUDED.videos;",
      "",
    );
  }

  // --- Exercises (upsert) ---
  const emitExercise = (
    chId: string,
    exId: string,
    slug: string,
    chapterSlug: string,
    title: string,
    difficulty: number,
    xpReward: number,
    rewardCoins: number,
    mode: string,
    displayOrder: number,
    questions: ContentQuestion[],
    correctionVideoSql: string,
  ) => {
    out.push(
      "INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order, correction_video) VALUES",
      `  (${sqlString(exId)}, ${sqlString(chId)}, ${sqlString(subjectId)}, ${sqlString(title)}, ${difficulty}, ${xpReward}, ${rewardCoins}, ${sqlString(
        mode,
      )}, 'admin', ${displayOrder}, ${correctionVideoSql})`,
      "ON CONFLICT (id) DO UPDATE SET",
      "  chapter_id = EXCLUDED.chapter_id,",
      "  subject_id = EXCLUDED.subject_id,",
      "  title = EXCLUDED.title,",
      "  difficulty = EXCLUDED.difficulty,",
      "  xp_reward = EXCLUDED.xp_reward,",
      "  reward_coins = EXCLUDED.reward_coins,",
      "  mode = EXCLUDED.mode,",
      "  display_order = EXCLUDED.display_order,",
      "  correction_video = EXCLUDED.correction_video;",
      "",
    );
    // Order questions from easiest to hardest (stable; untagged = medium).
    const ordered = questions
      .map((q, i) => ({ q, i }))
      .sort((a, b) => (a.q.difficulty ?? 2) - (b.q.difficulty ?? 2) || a.i - b.i)
      .map((e) => e.q);
    ordered.forEach((q, i) => {
      const qId = questionId(subjectId, chapterSlug, slug, i + 1);
      // Evaluated competencies (étude 07 D-2/R-2): the authored ids become
      // junction rows against the compiled registry; first id = primary.
      (q.competencies ?? []).forEach((competencySlug, k) => {
        competencyRows.push({
          questionId: qId,
          competencyId: competencyId(competencySlug),
          isPrimary: k === 0,
        });
      });
      // Per-type columns (Tier B — docs/interactive-question-types.md): mcq keeps
      // the historical shape (options + correct_option, no answer_key); numeric
      // carries its typed key and no options; ordering/matching carry BOTH the
      // items (options) and their typed key. `answer_key` is server-only (never
      // client-granted), which is fine for generated SQL applied as the owner.
      // Client options carry only {id, text}: any server-only misconceptionTag
      // (mcq distractors, étude 04 D-4) is STRIPPED here and routed into the
      // server-only distractor_tags map below — never sent to the client.
      // `short_answer` rejoint `numeric` : aucune proposition à rendre (étude 20
      // R-11) — l'élève tape, il ne choisit pas.
      const optionsSql =
        q.type === "numeric" || q.type === "short_answer"
          ? "'[]'::jsonb"
          : sqlJson(q.options.map((o) => ({ id: o.id, text: o.text })));
      const correctOptionSql = q.type === "mcq" ? sqlString(q.correctOption) : "NULL";
      // distractor_tags: { optionId: tag } for mcq distractors that name an error
      // (server-only column — R-1). NULL when the question carries no tag.
      const distractorTags =
        q.type === "mcq"
          ? Object.fromEntries(
              q.options
                .filter((o) => o.misconceptionTag)
                .map((o) => [o.id, o.misconceptionTag as string]),
            )
          : {};
      const distractorTagsSql =
        Object.keys(distractorTags).length > 0 ? sqlJson(distractorTags) : "NULL";
      const answerKeySql =
        q.type === "numeric"
          ? sqlJson({
              value: q.answerKey.value,
              ...(q.answerKey.tolerance !== undefined ? { tolerance: q.answerKey.tolerance } : {}),
              ...(q.answerKey.unit !== undefined ? { unit: q.answerKey.unit } : {}),
            })
          : q.type === "ordering"
            ? sqlJson({ order: q.answerKey.order })
            : q.type === "matching"
              ? sqlJson({ pairs: q.answerKey.pairs })
              : q.type === "multi"
                ? sqlJson({ correct: q.answerKey.correct })
                : // `short_answer` (étude 20 R-11) : la canonique, et les erreurs
                  // attendues — le pendant des distracteurs tagués, server-only
                  // comme le reste de la clé. Les autres formulations JUSTES ne
                  // sont pas ici : elles vont dans `accepted_answers` (D-8).
                  q.type === "short_answer"
                  ? sqlJson({
                      text: q.answerKey.text,
                      ...(q.expectedMistakes?.length
                        ? {
                            mistakes: q.expectedMistakes.map((m) => ({
                              text: m.text,
                              tag: m.misconceptionTag,
                            })),
                          }
                        : {}),
                    })
                  : "NULL";
      // accepted_answers (étude 20 R-2): the accepted-answer SET, server-only
      // like the key itself. The authored text is emitted RAW and readable —
      // normalisation happens in SQL at scoring time (D-3), so there is a
      // single source of truth for it. Absent ⇒ '[]' = canonical answer only,
      // i.e. étude 17 behaviour unchanged.
      // Tier A (lot 2) complète l'ensemble authoré par les variantes
      // morphologiques mécaniques de la clé — le gisement « article », qui ne
      // demande aucun modèle. Dérivé, donc calculé ici plutôt que dupliqué dans
      // le corpus.
      const acceptedAnswers = withMorphologicalVariants(q, subject.meta.contentLanguage);
      const acceptedAnswersSql = acceptedAnswers.length ? sqlJson(acceptedAnswers) : "'[]'::jsonb";
      out.push(
        "INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags, accepted_answers) VALUES",
        `  (${sqlString(qId)}, ${sqlString(exId)}, ${sqlString(q.prompt)}, ${optionsSql}, ${correctOptionSql}, ${sqlString(
          q.explanation,
        )}, ${i + 1}, ${sqlString(q.type)}, ${answerKeySql}, ${distractorTagsSql}, ${acceptedAnswersSql})`,
        "ON CONFLICT (id) DO UPDATE SET",
        "  exercise_id = EXCLUDED.exercise_id,",
        "  prompt = EXCLUDED.prompt,",
        "  options = EXCLUDED.options,",
        "  correct_option = EXCLUDED.correct_option,",
        "  explanation = EXCLUDED.explanation,",
        "  display_order = EXCLUDED.display_order,",
        "  question_type = EXCLUDED.question_type,",
        "  answer_key = EXCLUDED.answer_key,",
        "  distractor_tags = EXCLUDED.distractor_tags,",
        "  accepted_answers = EXCLUDED.accepted_answers;",
        "",
      );
    });
  };

  for (const chapter of chapters) {
    const chId = chapterId(subjectId, chapter.slug);
    // Mandatory comprehension quiz first (mode='quiz', display_order 0).
    emitExercise(
      chId,
      exerciseId(subjectId, chapter.slug, "quiz"),
      "quiz",
      chapter.slug,
      chapter.quiz.title ?? chapter.meta.title,
      1,
      QUIZ_XP_REWARD,
      QUIZ_COIN_REWARD,
      "quiz",
      0,
      chapter.quiz.questions,
      "NULL",
    );
    for (const exercise of chapter.exercises) {
      const ex = exercise.data;
      // Dedicated correction video (étude 23 R-6): overrides the chapter fallback
      // on the failure screen. NULL when unset or the ref is unknown/non-active.
      const [correctionVideo] = resolveVideos(ex.correctionVideo ? [ex.correctionVideo] : []);
      emitExercise(
        chId,
        exerciseId(subjectId, chapter.slug, exercise.slug),
        exercise.slug,
        chapter.slug,
        ex.title,
        ex.difficulty,
        ex.xpReward,
        ex.rewardCoins,
        ex.mode,
        ex.displayOrder,
        ex.questions,
        correctionVideo ? sqlJson(correctionVideo) : "NULL",
      );
    }
  }

  // --- Question → competency mappings (étude 07 D-2) ---
  // Converge the junction to exactly the authored `competencies` fields: prune
  // mappings this subject no longer asserts, then upsert the asserted ones.
  // Guarded with to_regclass (same pattern as the dungeon prune) so migrations
  // regenerated for stacks predating the étude-07 schema still apply cleanly.
  out.push(
    "-- Converge question → competency mappings for this subject (étude 07 D-2).",
    "DO $$",
    "BEGIN",
    "  IF to_regclass('public.question_competencies') IS NOT NULL THEN",
    "    DELETE FROM public.question_competencies qc",
    "    USING public.questions q, public.exercises e",
    "    WHERE qc.question_id = q.id",
    "      AND q.exercise_id = e.id",
    `      AND e.subject_id = ${sqlString(subjectId)}`,
    "      AND e.source = 'admin'" + (competencyRows.length > 0 ? "" : ";"),
    ...(competencyRows.length > 0
      ? [
          `      AND (qc.question_id, qc.competency_id) NOT IN (${competencyRows
            .map((r) => `(${sqlString(r.questionId)}::uuid, ${sqlString(r.competencyId)}::uuid)`)
            .join(", ")});`,
          "    INSERT INTO public.question_competencies (question_id, competency_id, is_primary) VALUES",
          competencyRows
            .map(
              (r) =>
                `      (${sqlString(r.questionId)}, ${sqlString(r.competencyId)}, ${r.isPrimary})`,
            )
            .join(",\n"),
          "    ON CONFLICT (question_id, competency_id) DO UPDATE SET is_primary = EXCLUDED.is_primary;",
        ]
      : []),
    "  END IF;",
    "END $$;",
    "",
  );

  return out.join("\n");
}

/**
 * Compile the competency family registries (étude 07 D-1) into one idempotent
 * migration: upsert every competency (stable UUIDv5 of the slug — R-1), prune
 * the ones a family no longer declares (family-scoped, cascades to edges and
 * junction rows), and rebuild each family's prerequisite edges. Regenerate
 * with `npm run content:build -- --competences` whenever a registry changes.
 */
export function buildCompetencyRegistryMigrationSql(registries: CompetencyRegistry[]): string {
  const out: string[] = [
    "-- =========================================================",
    "-- GENERATED FILE — do not edit by hand.",
    `-- Competency graph registry (étude 07 D-1) — families: ${registries
      .map((r) => r.family)
      .join(", ")}`,
    "-- Regenerate with: npm run content:build -- --competences",
    "-- Source of truth: content/competences/*.json",
    "-- =========================================================",
    "",
  ];

  for (const registry of registries) {
    const family = registry.family;
    const slugs = registry.competencies.map((c) => c.id);

    out.push(`-- --- Family: ${family} (${registry.competencies.length} competencies) ---`);
    out.push(
      "INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES",
      registry.competencies
        .map(
          (c) =>
            `  (${sqlString(competencyId(c.id))}, ${sqlString(c.id)}, ${sqlString(family)}, ${sqlString(
              c.labels.fr,
            )}, ${sqlString(c.labels.en)}, ${sqlString(c.labels.ar)})`,
        )
        .join(",\n"),
      "ON CONFLICT (id) DO UPDATE SET",
      "  slug = EXCLUDED.slug,",
      "  family = EXCLUDED.family,",
      "  label_fr = EXCLUDED.label_fr,",
      "  label_en = EXCLUDED.label_en,",
      "  label_ar = EXCLUDED.label_ar;",
      "",
      "-- Prune competencies this family no longer declares (R-1: deprecation,",
      "-- never rename). FK cascades clean the edges and question mappings —",
      "-- c'est précisément pourquoi la purge est GARDÉE : voir purgeGuardSql.",
      purgeGuardSql({
        scope: `compétences de la famille « ${family} »`,
        table: "public.competencies",
        where: `family = ${sqlString(family)}`,
        doomedWhere: `family = ${sqlString(family)} AND slug NOT IN (${sqlIdList(slugs)})`,
        collateral: "les mappings question → compétence (question_competencies) partent en CASCADE",
      }),
      "",
      "-- Rebuild the family's prerequisite edges (R-3: same-family DAG).",
      "DELETE FROM public.competency_prereqs cp",
      "USING public.competencies c",
      `WHERE cp.competency_id = c.id AND c.family = ${sqlString(family)};`,
    );

    const edges = registry.competencies.flatMap((c) =>
      c.prereqs.map((p) => `  (${sqlString(competencyId(c.id))}, ${sqlString(competencyId(p))})`),
    );
    if (edges.length > 0) {
      out.push(
        "INSERT INTO public.competency_prereqs (competency_id, prereq_id) VALUES",
        edges.join(",\n"),
        "ON CONFLICT (competency_id, prereq_id) DO NOTHING;",
      );
    }
    out.push("");
  }

  return out.join("\n");
}

/**
 * Au-delà de cette part du périmètre effacée en une fois, la purge d'un registre
 * REFUSE de s'appliquer. Un tiers est large pour une dépréciation ordinaire (on
 * retire quelques ids), et étroit pour un accident (un registre tronqué en rend
 * la quasi-totalité « non déclarée »).
 */
const PURGE_MAX_SHARE = 0.34;

/**
 * Une purge de registre qui refuse de se suicider (garde fail-closed).
 *
 * Le SQL compilé d'un registre converge la base vers le fichier : il upserte ce
 * qui est déclaré, puis **efface ce qui ne l'est plus**. C'est correct tant que le
 * fichier est intact — et catastrophique s'il ne l'est pas. Un registre tronqué
 * (merge malheureux, écriture partielle, mauvais drapeau) rend presque tout
 * « non déclaré », et `apply-content.yml` applique la purge sans broncher :
 * idempotente, journalisée, irréprochable, et destructrice. Pour les compétences,
 * la casse ne s'arrête pas au registre — `question_competencies` part en CASCADE,
 * donc le tagging du corpus avec.
 *
 * La garde compte les lignes condamnées AVANT d'effacer et lève si elles pèsent
 * plus de {@link PURGE_MAX_SHARE} du périmètre. Elle ne juge pas l'intention : une
 * dépréciation massive VOULUE est légitime, elle exige seulement une main humaine
 * plutôt qu'un `workflow_dispatch` de routine. Le message dit les deux nombres,
 * parce qu'un refus qui n'explique pas ce qu'il a vu se contourne au hasard.
 *
 * Une base vide passe toujours (0 condamné) : le premier `apply` d'un registre
 * n'est pas une purge.
 */
function purgeGuardSql(opts: {
  /** Ce que la purge touche, en français, pour le message d'erreur. */
  scope: string;
  table: string;
  /** Le périmètre converge par ce registre (dénominateur). */
  where: string;
  /** Les lignes que la purge effacerait (numérateur). */
  doomedWhere: string;
  /** Ce qui part en plus, par cascade — nommé dans le refus. */
  collateral: string;
}): string {
  // Le message part dans un littéral SQL : toute apostrophe du français doit être
  // doublée, sinon « qu'ils » referme la chaîne et le fichier ne compile plus.
  // (Attrapé à l'exécution, pas à la relecture — d'où le test qui rejoue le SQL.)
  const message =
    `PURGE REFUSÉE — ${opts.scope} : % lignes sur % seraient effacées ` +
    `(plus de ${Math.round(PURGE_MAX_SHARE * 100)} %%). ${opts.collateral}. ` +
    `Un registre tronqué ressemble exactement à ça. Si la dépréciation est VOULUE, ` +
    `appliquer en deux temps ou lever la garde sciemment.`;

  return [
    "DO $purge$",
    "DECLARE",
    "  v_scope INT;",
    "  v_doomed INT;",
    "BEGIN",
    `  SELECT count(*) INTO v_scope FROM ${opts.table} WHERE ${opts.where};`,
    `  SELECT count(*) INTO v_doomed FROM ${opts.table} WHERE ${opts.doomedWhere};`,
    `  IF v_scope > 0 AND v_doomed::numeric / v_scope > ${PURGE_MAX_SHARE} THEN`,
    `    RAISE EXCEPTION ${sqlString(message)}, v_doomed, v_scope;`,
    "  END IF;",
    `  DELETE FROM ${opts.table} WHERE ${opts.doomedWhere};`,
    "END",
    "$purge$;",
  ].join("\n");
}

/** Stable file name of the misconception registry on the same channel (D-6). */
export const MISCONCEPTIONS_SQL_FILE_NAME = "_misconceptions_registry.sql";

/**
 * Compile `content/misconceptions.json` into the vocabulary the student actually
 * reads (étude 04 lot A1.2b).
 *
 * `get_attempt_review` rend un TAG ; cette table porte la phrase. Le tag reste
 * l'identité — il est la clé primaire, et il est STABLE à vie (on déprécie, on ne
 * renomme jamais, même règle que les slugs et les ids de compétences).
 *
 * Idempotent et rejouable, comme tout ce qui passe par `apply-content.yml` : upsert
 * de chaque entrée, puis purge des tags que le registre ne déclare plus. La purge
 * est **globale** et non scopée par matière — contrairement aux compétences, dont
 * chaque famille a son propre fichier : ici il n'y a qu'UN registre, donc ce qui
 * n'y est plus n'existe plus. Rien n'y a de FK entrante ; une question qui porterait
 * encore un tag purgé se dégrade en « erreur non nommée » (R-A1.2-3), elle ne casse
 * pas — et `content:qa` refuse de toute façon un tag hors registre.
 *
 * Régénérer avec `npm run content:build -- --misconceptions`.
 */
export function buildMisconceptionRegistryMigrationSql(registry: MisconceptionRegistry): string {
  const tags = Object.keys(registry).sort();
  const out: string[] = [
    "-- =========================================================",
    "-- GENERATED FILE — do not edit by hand.",
    `-- Misconception registry (étude 04 A1.2b) — ${tags.length} tag(s)`,
    "-- Regenerate with: npm run content:build -- --misconceptions",
    "-- Source of truth: content/misconceptions.json",
    "-- =========================================================",
    "",
  ];

  if (tags.length === 0) {
    // Un registre vide ne doit pas produire un DELETE sans garde qui viderait la
    // table : « rien à dire » n'est pas « tout effacer ».
    out.push("-- Registre vide : rien à écrire, et surtout rien à purger.", "");
    return out.join("\n");
  }

  out.push(
    "INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar, competency) VALUES",
    tags
      .map((tag) => {
        const entry = registry[tag]!;
        // `competency` (A12) est optionnelle : une erreur sans compétence propre
        // écrit NULL, et le bloc de correction se dégrade sans exercice proposé.
        const competency = entry.competency ? sqlString(entry.competency) : "NULL";
        return `  (${sqlString(tag)}, ${sqlString(entry.subject)}, ${sqlString(
          entry.labels.fr,
        )}, ${sqlString(entry.labels.en)}, ${sqlString(entry.labels.ar)}, ${competency})`;
      })
      .join(",\n"),
    "ON CONFLICT (tag) DO UPDATE SET",
    "  subject = EXCLUDED.subject,",
    "  label_fr = EXCLUDED.label_fr,",
    "  label_en = EXCLUDED.label_en,",
    "  label_ar = EXCLUDED.label_ar,",
    "  competency = EXCLUDED.competency;",
    "",
    "-- Purge des tags que le registre ne déclare plus (dépréciation, jamais",
    "-- renommage), sous la même garde que les compétences : rien n'a de FK vers",
    "-- cette table, mais un vocabulaire tronqué rend muettes toutes les erreurs",
    "-- qu'il nommait — une panne silencieuse, donc exactement celle qu'on rate.",
    purgeGuardSql({
      scope: "vocabulaire des misconceptions",
      table: "public.misconceptions",
      where: "TRUE",
      doomedWhere: `tag NOT IN (${sqlIdList(tags)})`,
      collateral: "toutes les erreurs qu'ils nomment redeviennent anonymes dans la correction",
    }),
    "",
  );

  return out.join("\n");
}
