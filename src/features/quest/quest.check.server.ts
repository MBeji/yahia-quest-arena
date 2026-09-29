import { createServerFn } from "@tanstack/react-start";
import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import type { Database } from "@/shared/integrations/supabase/types";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import { MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";
import { assertAnswerFormats } from "@/features/quest/answer-format-guard";
import type { QuestDraftAnswer } from "@/features/quest/quest-draft";

// ---------- Per-question verdict (retour immédiat, levier 01) ----------
/**
 * Corrige UNE question en cours de partie, pour le retour immédiat du lecteur
 * de quête — et FIGE sa réponse dans la session.
 *
 * ⚠️ POURQUOI LA SESSION (migration 20260929120000). Ce verdict montre la bonne
 * réponse avant que le score ne soit calculé. Le verrou qui rendait cela tenable
 * vivait dans le navigateur, et un rechargement l'effaçait : un élève cochait au
 * hasard, lisait la bonne réponse, appuyait sur F5 et la redonnait — comptée
 * juste. Désormais `reveal_session_answer` fige la réponse côté serveur AVANT de
 * la corriger, et `submit_exercise_attempt` note sur la réponse figée : une
 * seconde demande avec un autre choix reçoit le verdict du PREMIER, et `choice`
 * dit lequel — le lecteur l'affiche.
 *
 * Le périmètre reste celui de `check_answers`, dont la RPC tire son verdict : un
 * exercice du catalogue `admin`, jamais un `mode = 'quiz'` (le quiz de
 * compréhension reste non corrigé à l'écran), jamais le Rappel. Hors de ces cas
 * elle ne rend aucune ligne et ne fige rien : on renvoie `null` et le lecteur
 * enchaîne sans verdict (dégradation, pas erreur).
 */
export const checkQuestion = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        exerciseId: z.guid(),
        sessionId: z.guid(),
        questionId: z.guid(),
        choice: z.string().min(1).max(MAX_CHOICE_LENGTH),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Une question corrigée = un appel. Le plafond couvre plusieurs missions
    // enchaînées sans laisser la surface ouverte à un balayage du corpus.
    if (await isRateLimited(supabase, `check_question_${userId}`, 60, 60_000)) {
      throw new Error("Trop de requêtes. Réessaie dans un instant.");
    }

    const answers = [{ questionId: data.questionId, choice: data.choice }];
    await assertAnswerFormats(supabase, "quest.checkQuestion", data.exerciseId, answers);

    const { data: rows, error } = await supabase.rpc("reveal_session_answer", {
      p_session_id: data.sessionId,
      p_question_id: data.questionId,
      p_choice: data.choice,
    });
    if (error) {
      failWithClientError("quest.checkQuestion", error, "Impossible de corriger cette question.");
    }

    const row = rows?.find((candidate) => candidate.question_id === data.questionId);
    if (!row) return null;

    return {
      questionId: row.question_id,
      choice: row.choice,
      isCorrect: row.is_correct === true,
      correctChoice: row.correct_option,
      explanation: row.explanation,
    };
  });

/**
 * Les réponses FIGÉES d'une partie — celles dont la correction a déjà été montrée.
 *
 * Deux lecteurs : le démarrage, qui les rend au lecteur pour qu'un rechargement
 * reprenne la partie là où elle en était, et la soumission, pour que la correction
 * de fin de partie montre la réponse que la note a comptée.
 *
 * Une panne de lecture rend `[]` et ne bloque rien : le verrou, lui, est appliqué
 * par le barème SQL quoi qu'il arrive — seul l'écran perdrait la reprise.
 */
export async function fetchSessionReveals(
  supabase: SupabaseClient<Database>,
  sessionId: string,
): Promise<QuestDraftAnswer[]> {
  const { data, error } = await supabase
    .from("exercise_session_reveals")
    .select("question_id, choice")
    .eq("session_id", sessionId);
  if (error) {
    logger.warn("quest.session-reveals.read-failed", { sessionId, error: error.message });
    return [];
  }
  return (data ?? []).map((row) => ({ questionId: row.question_id, choice: row.choice }));
}
