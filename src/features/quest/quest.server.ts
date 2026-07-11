import { createServerFn } from "@tanstack/react-start";
import { getRequest } from "@tanstack/react-start/server";
import { z } from "zod";
import type { SupabaseClient } from "@supabase/supabase-js";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { isRateLimited, isRateLimitedLocal } from "@/shared/lib/rate-limit";
import { MIN_SECONDS_PER_QUESTION, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
import { findAnswerFormatViolation, MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";
import { logger } from "@/shared/lib/logger";
import type { UnlockedBadge } from "@/shared/types/gamification";
import type { Database } from "@/shared/integrations/supabase/types";

/** Error message thrown when an exercise is locked behind its chapter quiz. */
export const QUIZ_LOCKED_MESSAGE =
  "Réussis d'abord le quiz de compréhension du chapitre pour débloquer cet exercice.";

/**
 * Thrown when a premium parcours' mission is started without an entitlement and
 * outside the free preview. The "Parcours premium" prefix is matched by the quest
 * UI to show the paywall; keep it stable.
 */
export const PARCOURS_LOCKED_MESSAGE =
  "Parcours premium : débloque ce parcours pour accéder à cette mission.";
/** Thrown when the resolved parcours is not yet available (coming soon). */
export const PARCOURS_COMING_SOON_MESSAGE =
  "Parcours premium : ce parcours sera bientôt disponible.";

type ProfileSnapshot = Database["public"]["Tables"]["profiles"]["Row"];

/** Thrown when an answer's wire format doesn't match its question's type. */
export const ANSWER_FORMAT_MESSAGE = "Réponse invalide pour ce type de question.";

/**
 * Per-type wire-format validation (docs/interactive-question-types.md): fetch
 * the exercise's (client-readable) question types and reject any answer whose
 * `choice` doesn't match its question's expected format — e.g. a non-numeric
 * string for a `numeric` question. Degrades open when the fetch itself fails:
 * the scoring RPCs are garbage-safe either way, this only improves the error.
 */
async function assertAnswerFormats(
  supabase: SupabaseClient<Database>,
  scope: string,
  exerciseId: string,
  answers: ReadonlyArray<{ questionId: string; choice: string }>,
): Promise<void> {
  const { data: rows, error } = await supabase
    .from("questions")
    .select("id,question_type")
    .eq("exercise_id", exerciseId);
  if (error || !rows) {
    logger.warn(`${scope}: question_type fetch failed — skipping format validation`, {
      exerciseId,
      error: error?.message,
    });
    return;
  }
  const violation = findAnswerFormatViolation(
    new Map(rows.map((row) => [row.id, row.question_type])),
    answers,
  );
  if (violation) {
    failWithClientError(scope, null, ANSWER_FORMAT_MESSAGE);
  }
}

/** Multiplier potion applied to a reward-earning attempt (null when none armed). */
export type PotionApplied = {
  itemCode: string;
  itemName: string;
  xpMultiplier: number;
  coinMultiplier: number;
};

type AtomicSubmitResponse = {
  correct: number;
  total: number;
  scorePct: number;
  xpEarned: number;
  coinsEarned: number;
  durationSeconds: number;
  tooFast: boolean;
  improved: boolean;
  profile: ProfileSnapshot | null;
  unlockedBadges: UnlockedBadge[];
  potionApplied: PotionApplied | null;
  /**
   * True when an armed retry shield suppressed this failed attempt's penalty (it
   * was consumed). The result UI nudges an immediate replay — the higher of the
   * two scores wins via the existing best-score eligibility gate.
   */
  retryShieldUsed: boolean;
};

function toUnlockedBadges(value: unknown): UnlockedBadge[] {
  if (!Array.isArray(value)) return [];

  return value
    .map((entry) => {
      if (!entry || typeof entry !== "object") return null;

      const row = entry as Record<string, unknown>;
      if (
        typeof row.code !== "string" ||
        typeof row.name !== "string" ||
        typeof row.rarity !== "string"
      ) {
        return null;
      }

      return {
        code: row.code,
        name: row.name,
        rarity: row.rarity,
        iconName: typeof row.iconName === "string" || row.iconName === null ? row.iconName : null,
      };
    })
    .filter((badge): badge is UnlockedBadge => badge !== null);
}

function toPotionApplied(value: unknown): PotionApplied | null {
  if (!value || typeof value !== "object") return null;

  const row = value as Record<string, unknown>;
  if (typeof row.itemCode !== "string") return null;

  return {
    itemCode: row.itemCode,
    itemName: typeof row.itemName === "string" ? row.itemName : "",
    xpMultiplier: Number(row.xpMultiplier ?? 1),
    coinMultiplier: Number(row.coinMultiplier ?? 1),
  };
}

function parseAtomicSubmitResponse(payload: unknown): AtomicSubmitResponse {
  if (!payload || typeof payload !== "object") {
    throw new Error("Unexpected quest submission response.");
  }

  const row = payload as Record<string, unknown>;

  return {
    correct: Number(row.correct ?? 0),
    total: Number(row.total ?? 0),
    scorePct: Number(row.scorePct ?? 0),
    xpEarned: Number(row.xpEarned ?? 0),
    coinsEarned: Number(row.coinsEarned ?? 0),
    durationSeconds: Number(row.durationSeconds ?? 0),
    tooFast: row.tooFast === true,
    improved: row.improved === true,
    profile:
      row.profile && typeof row.profile === "object" ? (row.profile as ProfileSnapshot) : null,
    unlockedBadges: toUnlockedBadges(row.unlockedBadges),
    potionApplied: toPotionApplied(row.potionApplied),
    retryShieldUsed: row.retryShieldUsed === true,
  };
}

// ---------- Get a subject with chapters & exercises ----------
export const getSubject = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .inputValidator((d) => z.object({ subjectId: z.string() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const [subj, chaps, exs] = await Promise.all([
      supabase.from("subjects").select("*").eq("id", data.subjectId).single(),
      supabase.from("chapters").select("*").eq("subject_id", data.subjectId).order("display_order"),
      supabase
        .from("exercises")
        .select("*")
        .eq("subject_id", data.subjectId)
        .order("display_order"),
    ]);
    if (subj.error) {
      failWithClientError("quest.getSubject", subj.error, "Impossible de charger la matière.");
    }

    // Best scores are an account concept; anonymous visitors have none. Graceful
    // fallback if the RPC fails, logged so a broken RPC never silently hides progress.
    let bestScoresData: unknown[] = [];
    if (userId) {
      try {
        const bestScores = await supabase.rpc("get_best_scores_by_exercise", {
          p_subject: data.subjectId,
        });
        if (bestScores.error) {
          logger.warn("quest.getSubject: get_best_scores_by_exercise failed", {
            subjectId: data.subjectId,
            error: bestScores.error.message,
          });
        } else if (Array.isArray(bestScores.data)) {
          bestScoresData = bestScores.data;
        }
      } catch (err) {
        logger.warn("quest.getSubject: get_best_scores_by_exercise threw", {
          subjectId: data.subjectId,
          error: errorMessage(err),
        });
      }
    }

    const best: Record<string, number> = {};
    for (const row of bestScoresData) {
      const r = row as Record<string, unknown>;
      if (typeof r.exercise_id !== "string") continue;
      best[r.exercise_id] = Number(r.best_score ?? 0);
    }

    // Comprehension-quiz gate: a chapter's exercises stay locked until the
    // user passes that chapter's mode='quiz' exercise at/above the threshold.
    const exercises = exs.data ?? [];
    // The comprehension-quiz gate applies only to the school program (grade-bound
    // subjects). Non-school themes (culture-générale, muscle-cerveau/IQ, languages)
    // have no theory to validate, so their chapters are never quiz-gated.
    const isSchoolSubject =
      ((subj.data as { grade_id?: string | null } | null)?.grade_id ?? null) !== null;
    const quizExercises = exercises.filter((e) => e.mode === "quiz");
    const quizPassedByChapter: Record<string, boolean> = {};
    for (const quiz of quizExercises) {
      // Non-school chapters start unlocked; school chapters lock until the quiz passes.
      if (quiz.chapter_id) quizPassedByChapter[quiz.chapter_id] = !isSchoolSubject;
    }
    const quizIds = quizExercises.map((e) => e.id);
    if (isSchoolSubject && quizIds.length > 0 && userId) {
      const { data: passedRows } = await supabase
        .from("attempts")
        .select("exercise_id,duration_seconds,total_count")
        .eq("user_id", userId)
        .in("exercise_id", quizIds)
        .gte("score_pct", QUIZ_PASS_THRESHOLD_PCT);
      // A quiz only counts as passed if the qualifying attempt was not rushed
      // (>= 4s/question) — a fast random pass must not unlock the chapter.
      const passedQuizIds = new Set(
        (passedRows ?? [])
          .filter(
            (r) => (r.duration_seconds ?? 0) >= (r.total_count ?? 0) * MIN_SECONDS_PER_QUESTION,
          )
          .map((r) => r.exercise_id),
      );
      for (const quiz of quizExercises) {
        if (quiz.chapter_id && passedQuizIds.has(quiz.id)) {
          quizPassedByChapter[quiz.chapter_id] = true;
        }
      }
    }

    // Parcours access context for premium gating of missions on the page.
    // Assigned on every path below (both try branches + the catch's locked-safe default),
    // so it needs no initializer — and an unread one trips eslint's no-useless-assignment.
    let viewer: { level: number; isPremium: boolean; hasEntitlement: boolean };
    if (!userId) {
      // Anonymous visitor: the public catalogue is open (premium is being retired).
      viewer = { level: 0, isPremium: false, hasEntitlement: true };
    } else {
      try {
        const themeId = (subj.data as { theme_id?: string | null }).theme_id ?? null;
        const gradeId = (subj.data as { grade_id?: string | null }).grade_id ?? null;
        const [viewerProfile, parcoursIdRes] = await Promise.all([
          supabase.from("profiles").select("level").eq("id", userId).maybeSingle(),
          themeId
            ? // resolve_subject_parcours matches grade_id with IS NOT DISTINCT FROM, so a
              // null grade is valid (grade-agnostic themes resolve their own parcours); the
              // generated arg type narrows p_grade to string, hence the cast on the nullable.
              supabase.rpc("resolve_subject_parcours", {
                p_theme: themeId,
                p_grade: gradeId as string,
              })
            : Promise.resolve({ data: null as string | null }),
        ]);
        const level = viewerProfile.data?.level ?? 0;
        const parcoursId = (parcoursIdRes as { data?: string | null }).data ?? null;
        if (parcoursId) {
          const [parcoursRow, entRes] = await Promise.all([
            supabase.from("parcours").select("is_premium").eq("id", parcoursId).maybeSingle(),
            supabase.rpc("has_parcours_entitlement", {
              p_user: userId,
              p_parcours: parcoursId,
            }),
          ]);
          const isPremium = parcoursRow.data?.is_premium ?? false;
          viewer = { level, isPremium, hasEntitlement: isPremium ? entRes.data === true : true };
        } else {
          viewer = { level, isPremium: false, hasEntitlement: true };
        }
      } catch (err) {
        logger.warn("quest.getSubject: parcours access fetch failed", {
          subjectId: data.subjectId,
          error: errorMessage(err),
        });
        viewer = { level: 0, isPremium: true, hasEntitlement: false }; // safe default: show locked
      }
    }

    return {
      subject: subj.data,
      chapters: chaps.data ?? [],
      exercises,
      bestByExercise: best,
      quizPassedByChapter,
      viewer,
    };
  });

// ---------- Get chapter lesson content ----------
export const getChapterLesson = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .inputValidator((d) => z.object({ chapterId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const { data: chapter, error } = await supabase
      .from("chapters")
      .select(
        "id, title, description, lesson_content, summary, subject_id, display_order, subjects(id, name_fr, color_token, icon, content_language, grade_id)",
      )
      .eq("id", data.chapterId)
      .single();
    if (error) {
      failWithClientError("quest.getChapterLesson", error, "Impossible de charger la leçon.");
    }

    // Fetch all sibling chapters for navigation. We only need each sibling's
    // metadata + whether it HAS a lesson — never the lesson body itself. Pulling
    // `lesson_content` here shipped every sibling's full markdown over the wire
    // just to derive a boolean (a subject with N chapters × ~30 KB each). Split
    // into two tiny reads: the metadata for all siblings, and the id-only set of
    // those that actually carry a lesson.
    const [{ data: siblings }, { data: siblingsWithLesson }] = await Promise.all([
      supabase
        .from("chapters")
        .select("id, title, display_order")
        .eq("subject_id", chapter.subject_id)
        .order("display_order"),
      supabase
        .from("chapters")
        .select("id")
        .eq("subject_id", chapter.subject_id)
        .not("lesson_content", "is", null)
        // Preserve the old `!!lesson_content` semantics: an empty string is "no lesson".
        .neq("lesson_content", ""),
    ]);

    const withLesson = new Set((siblingsWithLesson ?? []).map((s) => s.id));
    const allChapters = (siblings ?? []).map((s) => ({
      id: s.id,
      title: s.title,
      display_order: s.display_order,
      hasLesson: withLesson.has(s.id),
    }));

    // Target for the course reader's single « practise this chapter » CTA: the
    // chapter's first non-quiz exercise (real practice — the comprehension quiz
    // is the connected gate, not practice). null → nothing to practise → no CTA.
    // The reader links it auth-aware (signed-in → /quest, anon → /exercice).
    const { data: chapterExercises } = await supabase
      .from("exercises")
      .select("id, mode, display_order")
      .eq("chapter_id", data.chapterId)
      .order("display_order");
    const practiceExerciseId = (chapterExercises ?? []).find((e) => e.mode !== "quiz")?.id ?? null;

    // Quiz-gate affordance for the reader CTA (étude 15, lot 1 — audit §D-4): the
    // chapter's quiz id, whether the gate applies (school subjects only — same
    // rule as getSubject), and — signed-in only — whether THIS user already
    // passed it (score ≥ threshold AND not rushed, mirroring getSubject).
    // Anonymous visitors resolve their pass client-side (sessionStorage, see
    // anon-quiz-gate.ts), so quizPassed stays null for them.
    const quizExerciseId = (chapterExercises ?? []).find((e) => e.mode === "quiz")?.id ?? null;
    const isSchoolSubject =
      ((chapter.subjects as { grade_id?: string | null } | null)?.grade_id ?? null) !== null;
    const quizGated = isSchoolSubject && quizExerciseId !== null;
    let quizPassed: boolean | null = null;
    if (quizGated && userId) {
      const { data: passedRows } = await supabase
        .from("attempts")
        .select("duration_seconds,total_count")
        .eq("user_id", userId)
        .eq("exercise_id", quizExerciseId as string)
        .gte("score_pct", QUIZ_PASS_THRESHOLD_PCT);
      quizPassed = (passedRows ?? []).some(
        (r) => (r.duration_seconds ?? 0) >= (r.total_count ?? 0) * MIN_SECONDS_PER_QUESTION,
      );
    }

    return { chapter, allChapters, practiceExerciseId, quizExerciseId, quizGated, quizPassed };
  });

// ---------- Manuel élève pages (login-gated) ----------

/** A single official-textbook page available to display under a chapter. */
export type ManuelPage = { page: number; url: string };

/** Private Storage bucket holding the watermarked manuel-élève page images. */
const MANUEL_PAGES_BUCKET = "manuel-pages";
/** Signed-URL lifetime — long enough to read the gallery, short enough to expire. */
const MANUEL_SIGNED_URL_TTL_SECONDS = 60 * 60;

/** Shape of `chapters.manuel_ref` we rely on (the build also stores `pages`). */
const manuelRefSchema = z.object({
  code: z.string().regex(/^[A-Za-z0-9_-]+$/),
  pageNumbers: z.array(z.number().int().positive()).min(1),
});

/**
 * Resolve the official student-textbook (manuel élève) pages for a chapter into
 * **signed URLs**, gated to authenticated users. Returns `{ pages: [] }` when the
 * chapter has no `manuel_ref`, the data is malformed, or signing fails — the UI
 * simply hides the « Pages du manuel » section. The images live in a private
 * bucket (RLS = authenticated read); URLs are minted with the caller's JWT, so
 * anonymous visitors can neither call this nor read the objects.
 */
export const getManuelPageUrls = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ chapterId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<{ pages: ManuelPage[] }> => {
    const { supabase } = context;

    const { data: chapter, error } = await supabase
      .from("chapters")
      .select("manuel_ref")
      .eq("id", data.chapterId)
      .single();
    if (error || !chapter) {
      logger.warn("quest.getManuelPageUrls: chapter not found", { chapterId: data.chapterId });
      return { pages: [] };
    }

    const parsed = manuelRefSchema.safeParse(chapter.manuel_ref);
    if (!parsed.success) return { pages: [] }; // no manuel link (or malformed) → hide the section

    const { code, pageNumbers } = parsed.data;
    // Map each storage path back to its page number; de-dupe defensively.
    const pageByPath = new Map(pageNumbers.map((p) => [`${code}/${p}.webp`, p]));
    const paths = [...pageByPath.keys()];

    const { data: signed, error: signError } = await supabase.storage
      .from(MANUEL_PAGES_BUCKET)
      .createSignedUrls(paths, MANUEL_SIGNED_URL_TTL_SECONDS);
    if (signError || !signed) {
      logger.warn("quest.getManuelPageUrls: failed to sign manuel page urls", {
        chapterId: data.chapterId,
      });
      return { pages: [] };
    }

    const pages: ManuelPage[] = signed
      .flatMap((s) => {
        if (s.error || !s.signedUrl || !s.path) return [];
        const page = pageByPath.get(s.path);
        return page ? [{ page, url: s.signedUrl }] : [];
      })
      .sort((a, b) => a.page - b.page);

    return { pages };
  });

// ---------- Public practice correction (anonymous-capable) ----------
export type PracticeReviewItem = {
  questionId: string;
  selectedChoice: string;
  isCorrect: boolean;
  correctChoice: string | null;
  explanation: string | null;
};

function clientIpKey(): string {
  try {
    const headers = getRequest()?.headers;
    const forwarded = headers?.get("x-forwarded-for");
    return forwarded?.split(",")[0]?.trim() || headers?.get("x-real-ip") || "unknown";
  } catch {
    return "unknown";
  }
}

/**
 * Public, stateless correction for anonymous (or signed-in) practice. Calls the
 * SECURITY DEFINER check_answers RPC — no session, no attempt, no XP. Returns the
 * per-question correction for admin practice/boss exercises; comprehension quizzes
 * and parent content yield an empty, non-reviewable result.
 */
export const checkAnswersPublic = createServerFn({ method: "POST" })
  .middleware([optionalSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        exerciseId: z.guid(),
        answers: z
          .array(
            z.object({ questionId: z.guid(), choice: z.string().min(1).max(MAX_CHOICE_LENGTH) }),
          )
          .min(1)
          .max(100),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Anti-abuse. Signed-in callers use the persistent limiter (keyed by user);
    // anonymous ones use a best-effort in-memory limiter by IP (check_rate_limit
    // requires auth.uid()). A distributed anon limiter is a Transverse follow-up.
    const limited = userId
      ? await isRateLimited(supabase, `check_answers_${userId}`, 30, 60_000)
      : isRateLimitedLocal(`check_answers_ip_${clientIpKey()}`, 30, 60_000);
    if (limited) {
      throw new Error("Trop de requêtes. Réessaie dans un instant.");
    }

    await assertAnswerFormats(supabase, "quest.checkAnswersPublic", data.exerciseId, data.answers);

    const { data: rows, error } = await supabase.rpc("check_answers", {
      p_exercise_id: data.exerciseId,
      p_answers: data.answers,
    });
    if (error) {
      failWithClientError(
        "quest.checkAnswersPublic",
        error,
        "Impossible de corriger l'entraînement.",
      );
    }

    const list = Array.isArray(rows)
      ? (rows as Array<{
          question_id: string;
          is_correct: boolean;
          correct_option: string | null;
          explanation: string | null;
        }>)
      : [];
    const byId = new Map(list.map((row) => [row.question_id, row]));

    const review: PracticeReviewItem[] = [];
    for (const answer of data.answers) {
      const row = byId.get(answer.questionId);
      if (!row) continue;
      review.push({
        questionId: answer.questionId,
        selectedChoice: answer.choice,
        isCorrect: row.is_correct,
        correctChoice: row.correct_option,
        explanation: row.explanation,
      });
    }

    const total = review.length;
    const correct = review.filter((item) => item.isCorrect).length;
    const scorePct = total > 0 ? Math.round((correct / total) * 100) : 0;

    return { reviewable: total > 0, correct, total, scorePct, review };
  });

// ---------- Public quiz scoring (anonymous gate parity) ----------
/**
 * Public, stateless SCORING for the comprehension quiz. Mirrors the connected gate
 * WITHOUT leaking it: calls the SECURITY DEFINER `score_quiz` RPC, which returns
 * only the aggregate (correct count + total) for admin mode='quiz' exercises —
 * never per-question correctness, the correct option, or explanations. So an
 * anonymous visitor can self-validate their comprehension and unlock a chapter's
 * practice client-side, exactly like a signed-in student (whose quiz attempts also
 * return a score only). No session, no attempt, no XP.
 */
export const scoreQuizPublic = createServerFn({ method: "POST" })
  .middleware([optionalSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        exerciseId: z.guid(),
        answers: z
          .array(
            z.object({ questionId: z.guid(), choice: z.string().min(1).max(MAX_CHOICE_LENGTH) }),
          )
          .min(1)
          .max(100),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Anti-abuse — same split as checkAnswersPublic: persistent limiter for
    // signed-in callers, best-effort in-memory IP limiter for anonymous ones.
    const limited = userId
      ? await isRateLimited(supabase, `score_quiz_${userId}`, 30, 60_000)
      : isRateLimitedLocal(`score_quiz_ip_${clientIpKey()}`, 30, 60_000);
    if (limited) {
      throw new Error("Trop de requêtes. Réessaie dans un instant.");
    }

    await assertAnswerFormats(supabase, "quest.scoreQuizPublic", data.exerciseId, data.answers);

    const { data: rows, error } = await supabase.rpc("score_quiz", {
      p_exercise_id: data.exerciseId,
      p_answers: data.answers,
    });
    if (error) {
      failWithClientError("quest.scoreQuizPublic", error, "Impossible de corriger le quiz.");
    }

    const row = Array.isArray(rows)
      ? (rows[0] as { correct?: number; total?: number } | undefined)
      : undefined;
    const total = Number(row?.total ?? 0);
    const correct = Number(row?.correct ?? 0);
    const scorePct = total > 0 ? Math.round((correct / total) * 100) : 0;
    return { correct, total, scorePct };
  });

// ---------- Get exercise + questions ----------
export const getExercise = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const [ex, qs] = await Promise.all([
      supabase
        .from("exercises")
        .select(
          "*, subjects(id,name_fr,color_token,icon,content_language,grade_id), chapters(id,title,subject_id)",
        )
        .eq("id", data.exerciseId)
        .single(),
      supabase
        .from("questions")
        .select("id,prompt,options,display_order,question_type")
        .eq("exercise_id", data.exerciseId)
        .order("display_order"),
    ]);
    if (ex.error) {
      failWithClientError("quest.getExercise", ex.error, "Impossible de charger l'exercice.");
    }

    // Hint consumables are an account perk; anonymous practice has none. Each owned
    // unit = one reveal, so we sum the quantities (mirrors consume_hint's filter).
    let hintCharges = 0;
    if (userId) {
      const { data: hintInv } = await supabase
        .from("inventory_items")
        .select("quantity, item:shop_items!inner(item_type, effect_payload)")
        .eq("student_user_id", userId)
        .in("shop_items.item_type", ["booster", "potion"]);
      for (const row of hintInv ?? []) {
        const item = (row as { item?: { effect_payload?: unknown } | null }).item;
        const payload =
          item?.effect_payload && typeof item.effect_payload === "object"
            ? (item.effect_payload as Record<string, unknown>)
            : {};
        if ("hints" in payload || "hintBoost" in payload) {
          hintCharges += Number((row as { quantity?: number }).quantity ?? 0);
        }
      }
    }

    // Direct unlock target for the comprehension-quiz gate: when a non-quiz
    // exercise is gated, the lock screen links straight to the chapter's quiz
    // instead of bouncing the student to the subject hub to hunt for it.
    let chapterQuizId: string | null = null;
    const exRow = ex.data as { chapter_id?: string | null; mode?: string | null } | null;
    if (exRow?.chapter_id && exRow.mode !== "quiz") {
      const { data: quizRow } = await supabase
        .from("exercises")
        .select("id")
        .eq("chapter_id", exRow.chapter_id)
        .eq("mode", "quiz")
        .maybeSingle();
      chapterQuizId = (quizRow as { id?: string } | null)?.id ?? null;
    }

    // The comprehension-quiz gate applies to SCHOOL subjects only (grade-bound):
    // a non-quiz exercise whose chapter has a quiz is gated until that quiz is
    // passed. Non-school themes leave grade_id NULL -> never gated. Computed here
    // so BOTH the connected (`/quest`) and anonymous (`/exercice`) players share
    // one definition of "is this locked behind the quiz?" — the connected start is
    // still enforced server-side in start_exercise_session; the anon player reads
    // this flag and checks the session-local pass state.
    const subjectGradeId =
      (ex.data as { subjects?: { grade_id?: string | null } | null } | null)?.subjects?.grade_id ??
      null;
    const quizGated = chapterQuizId !== null && subjectGradeId !== null;

    return { exercise: ex.data, questions: qs.data ?? [], hintCharges, chapterQuizId, quizGated };
  });

// ---------- Start a secure exercise session ----------
// The start gate is server-authoritative inside the start_exercise_session
// SECURITY DEFINER RPC (GAP-021): it enforces the per-parcours premium gate and
// the school comprehension-quiz gate, then inserts the session as the owner —
// direct client INSERTs on exercise_sessions are revoked, so a session can no
// longer be forged to bypass either gate. This wrapper just invokes the RPC and
// maps its raised gate signals to the localized client messages.
export const startExerciseSession = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: rows, error } = await supabase.rpc("start_exercise_session", {
      p_exercise_id: data.exerciseId,
    });

    if (error) {
      // The RPC raises a stable token per gate; surface the matching message.
      const signal = error.message ?? "";
      if (signal.includes("PARCOURS_COMING_SOON")) {
        failWithClientError("quest.startExerciseSession", null, PARCOURS_COMING_SOON_MESSAGE);
      }
      if (signal.includes("PARCOURS_LOCKED")) {
        failWithClientError("quest.startExerciseSession", null, PARCOURS_LOCKED_MESSAGE);
      }
      if (signal.includes("QUIZ_LOCKED")) {
        failWithClientError("quest.startExerciseSession", null, QUIZ_LOCKED_MESSAGE);
      }
      failWithClientError(
        "quest.startExerciseSession",
        error,
        "Impossible de démarrer la session.",
      );
    }

    const session = rows?.[0];
    if (!session) {
      failWithClientError("quest.startExerciseSession", null, "Impossible de démarrer la session.");
    }

    return {
      sessionId: session.session_id,
      startedAt: session.started_at,
    };
  });

// ---------- Reveal a hint (on-demand consumable) ----------
// Spends one charge of a hint consumable (booster_hint / potion_rappel) to reveal
// a hint for the given question. All ownership/charge validation + the atomic
// decrement happen inside the `consume_hint` SECURITY DEFINER RPC; the hint text
// comes from the question's `explanation` (null/empty → graceful fallback). This
// is purely informational: it grants no XP/coins and never touches scoring or the
// arm/slot system.
export const revealHint = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ questionId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 10 reveals per 10 seconds (the client also guards against
    // re-spending on an already-revealed question).
    if (await isRateLimited(supabase, `hint_${userId}`, 10, 10_000)) {
      throw new Error("Too many hint requests. Please slow down.");
    }

    const { data: result, error } = await supabase.rpc("consume_hint", {
      p_question_id: data.questionId,
    });
    if (error) {
      failWithClientError("quest.revealHint", error, "Impossible de révéler un indice.");
    }

    const row = result && typeof result === "object" ? (result as Record<string, unknown>) : {};
    return {
      questionId: typeof row.questionId === "string" ? row.questionId : data.questionId,
      hint: typeof row.hint === "string" && row.hint.length > 0 ? row.hint : null,
      // A charge is spent only when the RPC actually revealed a hint; when the
      // question has no explanation, consumed is false and no charge was used.
      consumed: row.consumed === true,
      itemCode: typeof row.itemCode === "string" ? row.itemCode : "",
      itemName: typeof row.itemName === "string" ? row.itemName : "",
    };
  });

// ---------- Submit attempt ----------
export const submitAttempt = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        sessionId: z.guid(),
        exerciseId: z.guid(),
        answers: z
          .array(
            z.object({ questionId: z.guid(), choice: z.string().min(1).max(MAX_CHOICE_LENGTH) }),
          )
          .min(1)
          .max(100),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 5 submissions per 10 seconds
    if (await isRateLimited(supabase, `submit_${userId}`, 5, 10_000)) {
      throw new Error("Too many submissions. Please slow down.");
    }

    await assertAnswerFormats(supabase, "quest.submitAttempt", data.exerciseId, data.answers);

    // Comprehension quizzes are validated by the student alone: we never return
    // the correct answers / explanations for a quiz, so they cannot be memorised
    // and the quiz re-passed blindly. Practice/boss get the full end-of-quest
    // correction, built AFTER submit from the get_attempt_review SECURITY DEFINER
    // RPC (the answer key is no longer client-readable — GAP-020).
    const { data: exerciseRow } = await supabase
      .from("exercises")
      .select("mode")
      .eq("id", data.exerciseId)
      .single();
    const isQuiz = (exerciseRow as { mode?: string } | null)?.mode === "quiz";

    type ReviewItem = {
      questionId: string;
      prompt: string;
      selectedChoice: string;
      correctChoice: string;
      isCorrect: boolean;
      explanation: string | null;
    };
    // Ensure today's daily objective & this week's weekly quest rows exist
    // before the atomic RPC increments them (they are created on demand, so a
    // first-of-the-day submission isn't lost). Best-effort: never block a submit.
    await supabase.rpc("ensure_daily_weekly_goals", { p_user: userId });

    const { data: submitData, error: submitErr } = await supabase.rpc("submit_exercise_attempt", {
      p_session_id: data.sessionId,
      p_exercise_id: data.exerciseId,
      p_answers: data.answers,
    });
    if (submitErr) {
      failWithClientError(
        "quest.submitAttempt",
        submitErr,
        "Impossible d'enregistrer votre tentative.",
      );
    }

    // Build the end-of-quest correction from the SECURITY DEFINER review RPC. It
    // returns the answer key only for the caller's now-completed session, and only
    // for non-quiz exercises — so the key is never client-readable before/around
    // answering (GAP-020). We zip the caller's answers against it.
    let review: ReviewItem[] = [];
    if (!isQuiz) {
      // Passing the answers lets the RPC score each one through the same
      // `score_answer` seam as the submit RPC — so a numeric answer inside its
      // tolerance shows as correct in the review, exactly as it was counted.
      const { data: reviewRows } = await supabase.rpc("get_attempt_review", {
        p_session_id: data.sessionId,
        p_answers: data.answers,
      });
      const rows = Array.isArray(reviewRows)
        ? (reviewRows as Array<{
            question_id: string;
            prompt: string;
            correct_option: string | null;
            explanation: string | null;
            is_correct: boolean | null;
          }>)
        : [];
      const byId = new Map(rows.map((r) => [r.question_id, r]));
      // Degrade cleanly: if the review RPC returned nothing (e.g. transient error),
      // surface the score without a half-built correction rather than failing.
      if (byId.size > 0) {
        review = data.answers.map((answer) => {
          const q = byId.get(answer.questionId);
          return {
            questionId: answer.questionId,
            prompt: q?.prompt ?? "Question",
            selectedChoice: answer.choice,
            correctChoice: q?.correct_option ?? "",
            // Server-scored; the string-equality fallback covers a transient
            // pre-migration RPC shape (is_correct absent) — mcq semantics only.
            isCorrect: q ? (q.is_correct ?? q.correct_option === answer.choice) : false,
            explanation: q?.explanation ?? null,
          };
        });
      }
    }

    const atomic = parseAtomicSubmitResponse(submitData);

    return {
      correct: atomic.correct,
      total: atomic.total,
      scorePct: atomic.scorePct,
      xpEarned: atomic.xpEarned,
      coinsEarned: atomic.coinsEarned,
      durationSeconds: atomic.durationSeconds,
      tooFast: atomic.tooFast,
      improved: atomic.improved,
      profile: atomic.profile,
      review,
      reviewHidden: isQuiz,
      unlockedBadges: atomic.unlockedBadges,
      potionApplied: atomic.potionApplied,
      retryShieldUsed: atomic.retryShieldUsed,
    };
  });
