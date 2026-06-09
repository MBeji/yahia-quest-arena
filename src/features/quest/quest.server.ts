import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { MIN_SECONDS_PER_QUESTION, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
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
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ subjectId: z.string() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
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

    // Best scores RPC — graceful fallback if it fails, but log it so a broken
    // RPC never silently hides completion progress again.
    let bestScoresData: unknown[] = [];
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
    if (isSchoolSubject && quizIds.length > 0) {
      const { data: passedRows } = await supabase
        .from("attempts")
        .select("exercise_id,duration_seconds,total_count")
        .eq("user_id", context.userId)
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
    let viewer: { level: number; isPremium: boolean; hasEntitlement: boolean } = {
      level: 0,
      isPremium: false,
      hasEntitlement: true,
    };
    try {
      const themeId = (subj.data as { theme_id?: string | null }).theme_id ?? null;
      const gradeId = (subj.data as { grade_id?: string | null }).grade_id ?? null;
      const [viewerProfile, parcoursIdRes] = await Promise.all([
        supabase.from("profiles").select("level").eq("id", context.userId).maybeSingle(),
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
            p_user: context.userId,
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
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ chapterId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: chapter, error } = await supabase
      .from("chapters")
      .select(
        "id, title, description, lesson_content, summary, subject_id, display_order, subjects(id, name_fr, color_token, icon, content_language)",
      )
      .eq("id", data.chapterId)
      .single();
    if (error) {
      failWithClientError("quest.getChapterLesson", error, "Impossible de charger la leçon.");
    }

    // Fetch all sibling chapters for navigation
    const { data: siblings } = await supabase
      .from("chapters")
      .select("id, title, display_order, lesson_content")
      .eq("subject_id", chapter.subject_id)
      .order("display_order");

    const allChapters = (siblings ?? []).map((s) => ({
      id: s.id,
      title: s.title,
      display_order: s.display_order,
      hasLesson: !!s.lesson_content,
    }));

    return { chapter, allChapters };
  });

// ---------- Get exercise + questions ----------
export const getExercise = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const [ex, qs, hintInv] = await Promise.all([
      supabase
        .from("exercises")
        .select("*, subjects(id,name_fr,color_token,icon), chapters(id,title,subject_id)")
        .eq("id", data.exerciseId)
        .single(),
      supabase
        .from("questions")
        .select("id,prompt,options,display_order")
        .eq("exercise_id", data.exerciseId)
        .order("display_order"),
      // Total reveal charges the user owns (hint consumables: booster_hint /
      // potion_rappel). Each owned unit = one reveal, so we sum the quantities.
      // Mirrors the consume_hint RPC's eligibility filter.
      supabase
        .from("inventory_items")
        .select("quantity, item:shop_items!inner(item_type, effect_payload)")
        .eq("student_user_id", userId)
        .in("shop_items.item_type", ["booster", "potion"]),
    ]);
    if (ex.error) {
      failWithClientError("quest.getExercise", ex.error, "Impossible de charger l'exercice.");
    }

    let hintCharges = 0;
    for (const row of hintInv.data ?? []) {
      const item = (row as { item?: { effect_payload?: unknown } | null }).item;
      const payload =
        item?.effect_payload && typeof item.effect_payload === "object"
          ? (item.effect_payload as Record<string, unknown>)
          : {};
      if ("hints" in payload || "hintBoost" in payload) {
        hintCharges += Number((row as { quantity?: number }).quantity ?? 0);
      }
    }

    return { exercise: ex.data, questions: qs.data ?? [], hintCharges };
  });

// ---------- Start a secure exercise session ----------
export const startExerciseSession = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Enforce the comprehension-quiz gate: practice/boss exercises cannot be
    // started until the chapter's quiz is passed. Quizzes themselves are open.
    const { data: ex, error: exError } = await supabase
      .from("exercises")
      .select("id, mode, difficulty, chapter_id, subjects(grade_id)")
      .eq("id", data.exerciseId)
      .single();
    if (exError) {
      failWithClientError(
        "quest.startExerciseSession",
        exError,
        "Impossible de démarrer la session.",
      );
    }

    // Parcours entitlement gate (server-authoritative): resolve_exercise_access
    // resolves the exercise's parcours, premium status, the caller's entitlement,
    // and whether the exercise is inside the free preview, then returns `allowed`.
    const { data: accessRows, error: accessError } = await supabase.rpc("resolve_exercise_access", {
      p_exercise: data.exerciseId,
    });
    if (accessError) {
      logger.warn("quest.startExerciseSession: resolve_exercise_access failed", {
        exerciseId: data.exerciseId,
        error: accessError.message,
      });
    }
    const access = Array.isArray(accessRows) ? accessRows[0] : accessRows;
    // Fail closed: if access is unknown (RPC error) or not allowed, block.
    if (!access || access.allowed !== true) {
      failWithClientError(
        "quest.startExerciseSession",
        null,
        access?.reason === "PARCOURS_COMING_SOON"
          ? PARCOURS_COMING_SOON_MESSAGE
          : PARCOURS_LOCKED_MESSAGE,
      );
    }

    // The comprehension-quiz gate applies only to the school program (subjects
    // bound to a grade). Non-school themes (culture-générale, muscle-cerveau/IQ,
    // language tracks) have no theory to validate, so they are never quiz-gated.
    const subjectRel = ex.subjects as
      | { grade_id?: string | null }
      | { grade_id?: string | null }[]
      | null;
    const subjectRow = Array.isArray(subjectRel) ? subjectRel[0] : subjectRel;
    const isSchoolSubject = (subjectRow?.grade_id ?? null) !== null;

    if (isSchoolSubject && ex.mode !== "quiz" && ex.chapter_id) {
      const { data: quiz } = await supabase
        .from("exercises")
        .select("id")
        .eq("chapter_id", ex.chapter_id)
        .eq("mode", "quiz")
        .maybeSingle();
      // Only gate when a quiz actually exists for the chapter (graceful for
      // legacy chapters without one).
      if (quiz) {
        const { data: passed } = await supabase
          .from("attempts")
          .select("duration_seconds,total_count")
          .eq("user_id", userId)
          .eq("exercise_id", quiz.id)
          .gte("score_pct", QUIZ_PASS_THRESHOLD_PCT);
        // The qualifying quiz pass must not be rushed (>= 4s/question), otherwise
        // a fast random pass could unlock the chapter without comprehension.
        const genuinelyPassed = (passed ?? []).some(
          (r) => (r.duration_seconds ?? 0) >= (r.total_count ?? 0) * MIN_SECONDS_PER_QUESTION,
        );
        if (!genuinelyPassed) {
          failWithClientError("quest.startExerciseSession", null, QUIZ_LOCKED_MESSAGE);
        }
      }
    }

    const { data: session, error } = await supabase
      .from("exercise_sessions")
      .insert({ user_id: userId, exercise_id: data.exerciseId })
      .select("id,started_at")
      .single();

    if (error) {
      failWithClientError(
        "quest.startExerciseSession",
        error,
        "Impossible de démarrer la session.",
      );
    }

    return {
      sessionId: session.id,
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
  .inputValidator((d) => z.object({ questionId: z.string().uuid() }).parse(d))
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
        sessionId: z.string().uuid(),
        exerciseId: z.string().uuid(),
        answers: z
          .array(z.object({ questionId: z.string().uuid(), choice: z.string() }))
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

    const { data: questions, error: questionErr } = await supabase
      .from("questions")
      .select("id,prompt,correct_option,explanation")
      .eq("exercise_id", data.exerciseId);
    if (questionErr) {
      failWithClientError(
        "quest.submitAttempt",
        questionErr,
        "Impossible de charger les questions.",
      );
    }

    // Comprehension quizzes must be validated by the student alone: we never
    // return the correct answers / explanations to the client for a quiz, so they
    // cannot be memorised and the quiz re-passed blindly. The score + pass/fail
    // are still returned. Practice/boss keep the full end-of-quest correction.
    const { data: exerciseRow } = await supabase
      .from("exercises")
      .select("mode")
      .eq("id", data.exerciseId)
      .single();
    const isQuiz = (exerciseRow as { mode?: string } | null)?.mode === "quiz";

    const questionMap = new Map((questions ?? []).map((q) => [q.id, q]));

    type ReviewItem = {
      questionId: string;
      prompt: string;
      selectedChoice: string;
      correctChoice: string;
      isCorrect: boolean;
      explanation: string | null;
    };
    const review: ReviewItem[] = isQuiz
      ? []
      : data.answers.map((answer) => {
          const question = questionMap.get(answer.questionId);

          return {
            questionId: answer.questionId,
            prompt: question?.prompt ?? "Question",
            selectedChoice: answer.choice,
            correctChoice: question?.correct_option ?? "",
            isCorrect: question?.correct_option === answer.choice,
            explanation: question?.explanation ?? null,
          };
        });
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
