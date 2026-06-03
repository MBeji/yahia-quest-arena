import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import type { UnlockedBadge } from "@/shared/types/gamification";
import type { Database } from "@/shared/integrations/supabase/types";

/** Error message thrown when an exercise is locked behind its chapter quiz. */
export const QUIZ_LOCKED_MESSAGE =
  "Réussis d'abord le quiz de compréhension du chapitre pour débloquer cet exercice.";

type ProfileSnapshot = Database["public"]["Tables"]["profiles"]["Row"];

type AtomicSubmitResponse = {
  correct: number;
  total: number;
  scorePct: number;
  xpEarned: number;
  coinsEarned: number;
  durationSeconds: number;
  profile: ProfileSnapshot | null;
  unlockedBadges: UnlockedBadge[];
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
    profile:
      row.profile && typeof row.profile === "object" ? (row.profile as ProfileSnapshot) : null,
    unlockedBadges: toUnlockedBadges(row.unlockedBadges),
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
        error: err instanceof Error ? err.message : String(err),
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
    const quizExercises = exercises.filter((e) => e.mode === "quiz");
    const quizPassedByChapter: Record<string, boolean> = {};
    for (const quiz of quizExercises) {
      if (quiz.chapter_id) quizPassedByChapter[quiz.chapter_id] = false;
    }
    const quizIds = quizExercises.map((e) => e.id);
    if (quizIds.length > 0) {
      const { data: passedRows } = await supabase
        .from("attempts")
        .select("exercise_id")
        .eq("user_id", context.userId)
        .in("exercise_id", quizIds)
        .gte("score_pct", QUIZ_PASS_THRESHOLD_PCT);
      const passedQuizIds = new Set((passedRows ?? []).map((r) => r.exercise_id));
      for (const quiz of quizExercises) {
        if (quiz.chapter_id && passedQuizIds.has(quiz.id)) {
          quizPassedByChapter[quiz.chapter_id] = true;
        }
      }
    }

    return {
      subject: subj.data,
      chapters: chaps.data ?? [],
      exercises,
      bestByExercise: best,
      quizPassedByChapter,
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
    const { supabase } = context;
    const [ex, qs] = await Promise.all([
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
    ]);
    if (ex.error) {
      failWithClientError("quest.getExercise", ex.error, "Impossible de charger l'exercice.");
    }
    return { exercise: ex.data, questions: qs.data ?? [] };
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
      .select("id, mode, chapter_id")
      .eq("id", data.exerciseId)
      .single();
    if (exError) {
      failWithClientError(
        "quest.startExerciseSession",
        exError,
        "Impossible de démarrer la session.",
      );
    }

    if (ex.mode !== "quiz" && ex.chapter_id) {
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
          .select("id")
          .eq("user_id", userId)
          .eq("exercise_id", quiz.id)
          .gte("score_pct", QUIZ_PASS_THRESHOLD_PCT)
          .limit(1);
        if (!passed || passed.length === 0) {
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

    const questionMap = new Map((questions ?? []).map((q) => [q.id, q]));

    const review = data.answers.map((answer) => {
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
      profile: atomic.profile,
      review,
      unlockedBadges: atomic.unlockedBadges,
    };
  });
