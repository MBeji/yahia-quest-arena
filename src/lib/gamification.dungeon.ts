import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { isRateLimited } from "./rate-limit";

/** Dungeon constants */
export const DUNGEON_XP_PER_FLOOR = 15;
export const DUNGEON_COINS_PER_5_FLOORS = 5;
export const DUNGEON_DIFFICULTY_STEP = 5; // Every N floors, difficulty increases

type DungeonQuestionPayload = {
  id: string;
  prompt: string;
  options: unknown;
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
      options: q.options,
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
      throw new Error("Too many dungeon starts. Please slow down.");
    }

    const { data, error } = await supabase.rpc("start_dungeon_run");
    if (error) throw new Error(error.message);

    const runId = typeof data === "string" ? data : "";
    if (!runId) throw new Error("Dungeon run initialization failed.");

    return {
      runId,
      currentFloor: 1,
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
        runId: z.string().uuid(),
        batchSize: z.number().min(1).max(20).default(5),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 10 requests per 10 seconds per user
    if (await isRateLimited(supabase, `dungeon_q_${userId}`, 10, 10_000)) {
      throw new Error("Too many requests. Please slow down.");
    }

    const { data: payload, error } = await supabase.rpc("get_dungeon_questions", {
      p_run_id: data.runId,
      p_batch_size: data.batchSize,
    });
    if (error) throw new Error(error.message);

    return parseDungeonQuestionsPayload(payload);
  });

export const submitDungeonAnswer = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        runId: z.string().uuid(),
        questionId: z.string().uuid(),
        choice: z.string().min(1).max(32),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `dungeon_answer_${userId}`, 40, 60_000)) {
      throw new Error("Too many answers submitted. Please slow down.");
    }

    const { data: payload, error } = await supabase.rpc("submit_dungeon_answer", {
      p_run_id: data.runId,
      p_question_id: data.questionId,
      p_choice: data.choice,
    });
    if (error) throw new Error(error.message);

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
        runId: z.string().uuid(),
        durationSeconds: z.number().min(0),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 3 run submissions per 30 seconds
    if (await isRateLimited(supabase, `dungeon_run_${userId}`, 3, 30_000)) {
      throw new Error("Too many submissions. Please wait.");
    }

    const { data: payload, error } = await supabase.rpc("finalize_dungeon_run", {
      p_run_id: data.runId,
      p_duration_seconds: data.durationSeconds,
    });
    if (error) throw new Error(error.message);

    return parseDungeonFinalizePayload(payload);
  });
