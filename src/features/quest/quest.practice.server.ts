// La correction PUBLIQUE, sans session ni XP — ce que l'élève sans compte (ou
// connecté, en entraînement libre) reçoit quand il valide. Sortie de
// `quest.server.ts` (2026-10-30), à 746 lignes de code pour un plafond de 750 :
// elle ne partage rien avec le chemin qui enregistre une tentative. Texte
// déplacé à l'identique.

import { createServerFn } from "@tanstack/react-start";
import { getRequest } from "@tanstack/react-start/server";
import { z } from "zod";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { isRateLimited, isRateLimitedLocal } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";
import { MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";
import { assertAnswerFormats } from "@/features/quest/answer-format-guard";

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
 * and parent content yield an empty, non-reviewable result. The RPC withholds the
 * `explanation` from anonymous callers (auth.uid() IS NULL) — hint-economy content
 * (audit #1) — so `correctChoice` is set but `explanation` is null for visitors.
 */
export const checkAnswersPublic = createServerFn({ method: "POST" })
  .middleware([optionalSupabaseAuth])
  .validator((d) =>
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
  .validator((d) =>
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
