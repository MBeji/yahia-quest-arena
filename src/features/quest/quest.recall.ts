import type { SupabaseClient } from "@supabase/supabase-js";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import type { Database } from "@/shared/integrations/supabase/types";
import { RECALL_LOCKED_MESSAGE, RECALL_NOT_ELIGIBLE_MESSAGE } from "./recall-messages";

type Supabase = SupabaseClient<Database>;

/** A single recall per-question verdict, as returned by the submit RPC (D-4). */
export type RecallVerdict = { questionId: string; isCorrect: boolean };

/**
 * Parse the recall `perQuestion` verdicts from the submit RPC payload. Returns
 * null for a classic run (or a legacy shape) so the review falls back to its
 * classic path. The verdicts are authoritative — the free text was scored
 * server-side through the normalization seam, never re-derived on the TS side.
 */
export function toPerQuestion(value: unknown): RecallVerdict[] | null {
  if (!Array.isArray(value)) return null;
  return value
    .map((entry) => {
      if (!entry || typeof entry !== "object") return null;
      const row = entry as Record<string, unknown>;
      if (typeof row.questionId !== "string") return null;
      return { questionId: row.questionId, isCorrect: row.isCorrect === true };
    })
    .filter((v): v is RecallVerdict => v !== null);
}

/**
 * Recall mode (étude 17). The RPC raises a stable token per gate; the localized
 * surfaces live in the zero-import `recall-messages.ts` module (importing them
 * from `quest.server` into a client route would pull server code into the client
 * `index` chunk). Re-exported here for consumers that already reach for this
 * helper module; `quest.server.ts` raises them.
 */
export { RECALL_LOCKED_MESSAGE, RECALL_NOT_ELIGIBLE_MESSAGE };

/** A recall play-set question — prompt only, options empty by construction (R-1). */
export type RecallQuestion = {
  id: string;
  prompt: string;
  options: never[];
  display_order: number;
  question_type: "mcq";
};

/**
 * Recall play set for a mission: the eligible questions, prompt only. The answer
 * key never reaches the client — options are empty by construction (R-1), the
 * answer is typed then scored server-side. A failed RPC surfaces the not-eligible
 * message (the mission can't be played in recall).
 */
export async function fetchRecallQuestions(
  supabase: Supabase,
  exerciseId: string,
): Promise<RecallQuestion[]> {
  const { data: rows, error } = await supabase.rpc("get_recall_questions", {
    p_exercise_id: exerciseId,
  });
  if (error) {
    failWithClientError("quest.getExercise", error, RECALL_NOT_ELIGIBLE_MESSAGE);
  }
  return (Array.isArray(rows) ? rows : []).map((r) => ({
    id: r.id,
    prompt: r.prompt,
    options: [],
    display_order: r.display_order,
    question_type: "mcq" as const,
  }));
}

/** One row of the end-of-quest correction. */
export type AttemptReviewItem = {
  questionId: string;
  prompt: string;
  selectedChoice: string;
  correctChoice: string;
  isCorrect: boolean;
  explanation: string | null;
};

/**
 * Build the end-of-quest correction from the SECURITY DEFINER review RPC. It
 * returns the answer key only for the caller's now-completed session, so the key
 * is never client-readable before/around answering (GAP-020). We zip the caller's
 * answers against it. In recall the per-question verdict is the submit RPC's
 * authoritative `perQuestion` (D-4) and `correct_option` is the option TEXT;
 * otherwise the server `is_correct` is used (string-equality only as a transient
 * pre-migration fallback, mcq semantics). Degrades to empty on a missing RPC.
 */
export async function buildAttemptReview(
  supabase: Supabase,
  sessionId: string,
  answers: Array<{ questionId: string; choice: string }>,
  opts: { isRecall: boolean; perQuestion: RecallVerdict[] | null },
): Promise<AttemptReviewItem[]> {
  const { data: reviewRows } = await supabase.rpc("get_attempt_review", {
    p_session_id: sessionId,
    p_answers: answers,
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
  if (byId.size === 0) return [];
  const verdictById = new Map((opts.perQuestion ?? []).map((v) => [v.questionId, v.isCorrect]));
  return answers.map((answer) => {
    const q = byId.get(answer.questionId);
    return {
      questionId: answer.questionId,
      prompt: q?.prompt ?? "Question",
      selectedChoice: answer.choice,
      correctChoice: q?.correct_option ?? "",
      isCorrect: opts.isRecall
        ? (verdictById.get(answer.questionId) ?? q?.is_correct ?? false)
        : q
          ? (q.is_correct ?? q.correct_option === answer.choice)
          : false,
      explanation: q?.explanation ?? null,
    };
  });
}

/** Per-mission recall availability for a subject hub (étude 17). */
export type RecallAvailability = {
  eligibleByExercise: Record<string, number>;
  unlockedByExercise: Record<string, boolean>;
  bestByExercise: Record<string, number>;
};

const EMPTY_RECALL_AVAILABILITY: RecallAvailability = {
  eligibleByExercise: {},
  unlockedByExercise: {},
  bestByExercise: {},
};

/**
 * Recall availability for every mission of a subject — an account concept: how
 * many questions are recall-eligible per mission, whether the mode is unlocked
 * (classic mastered), and the best recall score so far. One round-trip; graceful
 * fallback to empty (same posture as best scores) so a missing/failed RPC never
 * breaks the hub.
 */
export async function fetchRecallAvailability(
  supabase: Supabase,
  subjectId: string,
): Promise<RecallAvailability> {
  const out: RecallAvailability = {
    eligibleByExercise: {},
    unlockedByExercise: {},
    bestByExercise: {},
  };
  try {
    const availability = await supabase.rpc("get_recall_availability", { p_subject_id: subjectId });
    if (availability.error) {
      logger.warn("quest.getSubject: get_recall_availability failed", {
        subjectId,
        error: availability.error.message,
      });
      return EMPTY_RECALL_AVAILABILITY;
    }
    if (Array.isArray(availability.data)) {
      for (const row of availability.data) {
        const r = row as Record<string, unknown>;
        if (typeof r.exercise_id !== "string") continue;
        out.eligibleByExercise[r.exercise_id] = Number(r.eligible_count ?? 0);
        out.unlockedByExercise[r.exercise_id] = r.unlocked === true;
        if (r.best_recall_pct != null)
          out.bestByExercise[r.exercise_id] = Number(r.best_recall_pct);
      }
    }
  } catch (err) {
    logger.warn("quest.getSubject: get_recall_availability threw", {
      subjectId,
      error: errorMessage(err),
    });
    return EMPTY_RECALL_AVAILABILITY;
  }
  return out;
}
