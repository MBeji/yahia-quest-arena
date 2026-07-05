import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";
import { isValidAnswerFormat, MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";

/** Dungeon constants */
export const DUNGEON_XP_PER_FLOOR = 15;
export const DUNGEON_COINS_PER_5_FLOORS = 5;
export const DUNGEON_DIFFICULTY_STEP = 5; // Every N floors, difficulty increases

type DungeonQuestionOption = { id: string; text: string };

type DungeonQuestionPayload = {
  id: string;
  prompt: string;
  options: DungeonQuestionOption[];
  /** questions.question_type — drives the per-type <QuestionInput> renderer. */
  questionType: string;
  explanation: string | null;
  exercises?: {
    difficulty?: number;
    subject_id?: string;
    subjects?: { name_fr?: string; color_token?: string; icon?: string };
  };
};

type DungeonQuestionsResponse = {
  currentFloor: number;
  questions: DungeonQuestionPayload[];
};

type DungeonAnswerResponse = {
  isCorrect: boolean;
  nextFloor: number;
  floorsCleared: number;
  totalCorrect: number;
  totalAnswered: number;
  correctChoice: string | null;
  prompt: string;
  explanation: string | null;
  runOver: boolean;
};

type DungeonFinalizeResponse = {
  xpEarned: number;
  coinsEarned: number;
  floorsCleared: number;
  totalCorrect: number;
  totalAnswered: number;
  durationSeconds: number;
};

function parseDungeonQuestionsPayload(value: unknown): DungeonQuestionsResponse {
  if (!value || typeof value !== "object") {
    throw new Error("Unexpected dungeon questions response.");
  }

  const row = value as Record<string, unknown>;
  const rawQuestions = Array.isArray(row.questions) ? row.questions : [];
  const questions = rawQuestions
    .filter((q): q is Record<string, unknown> => q !== null && typeof q === "object")
    .map((q) => ({
      id: typeof q.id === "string" ? q.id : "",
      prompt: typeof q.prompt === "string" ? q.prompt : "",
      options: Array.isArray(q.options) ? (q.options as DungeonQuestionOption[]) : [],
      // Payloads emitted before 20260705170000 carry no type — they are mcq.
      questionType: typeof q.question_type === "string" ? q.question_type : "mcq",
      explanation: typeof q.explanation === "string" ? q.explanation : null,
      exercises:
        q.exercises && typeof q.exercises === "object"
          ? (q.exercises as DungeonQuestionPayload["exercises"])
          : undefined,
    }))
    .filter((q) => q.id.length > 0 && q.prompt.length > 0);

  return {
    currentFloor: Number(row.currentFloor ?? 1),
    questions,
  };
}

function parseDungeonAnswerPayload(value: unknown): DungeonAnswerResponse {
  if (!value || typeof value !== "object") {
    throw new Error("Unexpected dungeon answer response.");
  }

  const row = value as Record<string, unknown>;
  return {
    isCorrect: row.isCorrect === true,
    nextFloor: Number(row.nextFloor ?? 1),
    floorsCleared: Number(row.floorsCleared ?? 0),
    totalCorrect: Number(row.totalCorrect ?? 0),
    totalAnswered: Number(row.totalAnswered ?? 0),
    correctChoice: typeof row.correctChoice === "string" ? row.correctChoice : null,
    prompt: typeof row.prompt === "string" ? row.prompt : "Question",
    explanation: typeof row.explanation === "string" ? row.explanation : null,
    runOver: row.runStatus === "failed" || row.runStatus === "completed",
  };
}

function parseDungeonFinalizePayload(value: unknown): DungeonFinalizeResponse {
  if (!value || typeof value !== "object") {
    throw new Error("Unexpected dungeon finalization response.");
  }

  const row = value as Record<string, unknown>;
  return {
    xpEarned: Number(row.xpEarned ?? 0),
    coinsEarned: Number(row.coinsEarned ?? 0),
    floorsCleared: Number(row.floorsCleared ?? 0),
    totalCorrect: Number(row.totalCorrect ?? 0),
    totalAnswered: Number(row.totalAnswered ?? 0),
    durationSeconds: Number(row.durationSeconds ?? 0),
  };
}

export const startDungeonRun = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `dungeon_start_${userId}`, 5, 30_000)) {
      throw new Error("Trop de départs de donjon. Ralentis un peu.");
    }

    const { data, error } = await supabase.rpc("start_dungeon_run");
    if (error) {
      if (typeof error.message === "string" && error.message.includes("DUNGEON_LOCKED")) {
        throw new Error(
          "Accès au Dungeon refusé : prérequis non atteints ou limite quotidienne atteinte.",
        );
      }
      failWithClientError(
        "dungeon.startDungeonRun: start_dungeon_run RPC failed",
        error,
        "Impossible de démarrer la course.",
      );
    }

    const runId = typeof data === "string" ? data : "";
    if (!runId) throw new Error("Impossible de démarrer la course.");

    return {
      runId,
      currentFloor: 1,
    };
  });

/** Dungeon access state for the current user (gate + UI). */
export const getDungeonAccess = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;

    const { data, error } = await supabase.rpc("get_dungeon_access");
    if (error) {
      failWithClientError(
        "dungeon.getDungeonAccess",
        error,
        "Impossible de vérifier l'accès au Dungeon.",
      );
    }

    const row = Array.isArray(data) ? data[0] : null;
    if (!row) {
      return {
        level: 0,
        maxRunsPerDay: 0,
        runsToday: 0,
        remaining: 0,
        subjectsDone: 0,
        chaptersDone: 0,
        requiredSubjects: 2,
        requiredChapters: 3,
        hasSubscription: false,
        canAccess: false,
        reason: "SUBSCRIPTION" as string,
      };
    }

    return {
      level: row.level,
      maxRunsPerDay: row.max_runs_per_day,
      runsToday: row.runs_today,
      remaining: Math.max(0, row.max_runs_per_day - row.runs_today),
      subjectsDone: row.subjects_done,
      chaptersDone: row.chapters_done,
      requiredSubjects: row.required_subjects,
      requiredChapters: row.required_chapters,
      hasSubscription: row.has_subscription ?? false,
      canAccess: row.can_access,
      reason: row.reason,
    };
  });

/**
 * Fetch a batch of random questions for the dungeon, with difficulty scaling.
 * Returns questions from all subjects, ordered randomly, filtered by difficulty.
 */
export const getDungeonQuestions = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        runId: z.guid(),
        batchSize: z.number().min(1).max(20).default(5),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 10 requests per 10 seconds per user
    if (await isRateLimited(supabase, `dungeon_q_${userId}`, 10, 10_000)) {
      throw new Error("Trop de requêtes. Ralentis un peu.");
    }

    const { data: payload, error } = await supabase.rpc("get_dungeon_questions", {
      p_run_id: data.runId,
      p_batch_size: data.batchSize,
    });
    if (error) {
      failWithClientError(
        "dungeon.getDungeonQuestions: get_dungeon_questions RPC failed",
        error,
        "Impossible de charger les questions du donjon.",
      );
    }

    return parseDungeonQuestionsPayload(payload);
  });

export const submitDungeonAnswer = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        runId: z.guid(),
        questionId: z.guid(),
        // Wide enough for the B2 CSV wire formats (a matching answer of six
        // pairs already exceeds the old 32-char bound).
        choice: z.string().min(1).max(MAX_CHOICE_LENGTH),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `dungeon_answer_${userId}`, 40, 60_000)) {
      throw new Error("Trop de réponses envoyées. Ralentis un peu.");
    }

    // Per-type wire-format validation (docs/interactive-question-types.md): a
    // malformed answer for the question's (client-readable) type is a clear
    // input error, not a silently-wrong floor. Degrades open on a failed fetch —
    // the scoring RPC is garbage-safe either way.
    const { data: questionRow } = await supabase
      .from("questions")
      .select("question_type")
      .eq("id", data.questionId)
      .maybeSingle();
    if (questionRow && !isValidAnswerFormat(questionRow.question_type, data.choice)) {
      failWithClientError(
        "dungeon.submitDungeonAnswer: invalid answer format",
        null,
        "Réponse invalide pour ce type de question.",
      );
    }

    const { data: payload, error } = await supabase.rpc("submit_dungeon_answer", {
      p_run_id: data.runId,
      p_question_id: data.questionId,
      p_choice: data.choice,
    });
    if (error) {
      failWithClientError(
        "dungeon.submitDungeonAnswer: submit_dungeon_answer RPC failed",
        error,
        "Impossible de valider la réponse.",
      );
    }

    return parseDungeonAnswerPayload(payload);
  });

/**
 * Submit the final dungeon run result — awards XP and coins based on floors cleared.
 */
export const submitDungeonRun = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        runId: z.guid(),
        durationSeconds: z.number().min(0),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 3 run submissions per 30 seconds
    if (await isRateLimited(supabase, `dungeon_run_${userId}`, 3, 30_000)) {
      throw new Error("Trop d'envois. Patiente un peu.");
    }

    const { data: payload, error } = await supabase.rpc("finalize_dungeon_run", {
      p_run_id: data.runId,
      p_duration_seconds: data.durationSeconds,
    });
    if (error) {
      failWithClientError(
        "dungeon.submitDungeonRun: finalize_dungeon_run RPC failed",
        error,
        "Impossible de finaliser la course.",
      );
    }

    return parseDungeonFinalizePayload(payload);
  });
