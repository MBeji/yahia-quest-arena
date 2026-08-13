import type { SupabaseClient } from "@supabase/supabase-js";
import { findAnswerFormatViolation } from "@/shared/lib/answer-formats";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import type { Database } from "@/shared/integrations/supabase/types";

/** Thrown when an answer's wire format doesn't match its question's type. */
export const ANSWER_FORMAT_MESSAGE = "Réponse invalide pour ce type de question.";

/**
 * Per-type wire-format validation (docs/interactive-question-types.md): fetch
 * the exercise's (client-readable) question types and reject any answer whose
 * `choice` doesn't match its question's expected format — e.g. a non-numeric
 * string for a `numeric` question. Degrades open when the fetch itself fails:
 * the scoring RPCs are garbage-safe either way, this only improves the error.
 *
 * Vit dans son propre module parce que TROIS surfaces serveur l'appellent
 * (soumission, correction publique, verdict par question) et que la dernière est
 * arrivée dans un fichier `quest.server` déjà au plafond de lignes.
 */
export async function assertAnswerFormats(
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
