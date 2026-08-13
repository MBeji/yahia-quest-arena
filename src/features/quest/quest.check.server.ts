import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";
import { MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";
import { assertAnswerFormats } from "@/features/quest/answer-format-guard";

// ---------- Per-question verdict (retour immédiat, levier 01) ----------
/**
 * Corrige UNE question en cours de partie, pour le retour immédiat du lecteur
 * de quête. Le donjon fait déjà exactement cela (`submit_dungeon_answer`) ; ici
 * on s'appuie sur la RPC `check_answers` déjà en place plutôt que d'ouvrir une
 * seconde voie de correction — donc **aucune migration**, aucun changement du
 * chemin de scoring.
 *
 * Ce que la RPC garantit, et qui borne ce qu'on expose : elle ne répond QUE pour
 * un exercice du catalogue `admin` et JAMAIS pour un `mode = 'quiz'` — le quiz de
 * compréhension reste non corrigé à l'écran (l'élève se valide seul). Hors de ces
 * cas elle ne rend aucune ligne : on renvoie alors `null` et le lecteur enchaîne
 * sans verdict, exactement comme avant ce lot (dégradation, pas erreur).
 *
 * Le verdict n'arrive qu'APRÈS que la réponse a été verrouillée côté client
 * (`answeredQuestionRef`), et le score final reste calculé par
 * `submit_exercise_attempt` sur la réponse ainsi figée : voir le vrai risque et
 * son périmètre au-dessus de `ExercisePlayer`.
 */
export const checkQuestion = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        exerciseId: z.guid(),
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

    const { data: rows, error } = await supabase.rpc("check_answers", {
      p_exercise_id: data.exerciseId,
      p_answers: answers,
    });
    if (error) {
      failWithClientError("quest.checkQuestion", error, "Impossible de corriger cette question.");
    }

    const row = Array.isArray(rows)
      ? (
          rows as Array<{
            question_id: string;
            is_correct: boolean;
            correct_option: string | null;
            explanation: string | null;
          }>
        ).find((candidate) => candidate.question_id === data.questionId)
      : undefined;
    if (!row) return null;

    return {
      questionId: row.question_id,
      isCorrect: row.is_correct === true,
      correctChoice: row.correct_option,
      explanation: row.explanation,
    };
  });
