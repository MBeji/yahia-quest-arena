// LES QUESTIONS OUVERTES, côté lecteur de quête — étude 33.
//
// Deux gestes, aux deux bouts d'une mission :
//
//   * AVANT — `filterOpenQuestions` retire du jeu servi les `short_answer` quand
//     le mode IA de l'élève ne les couvre pas. La base applique exactement la
//     même porte au dénominateur du score (`is_question_in_play`), et c'est ce
//     qui rend le retrait honnête : une question retirée de l'écran ET du total,
//     jamais de l'un sans l'autre ;
//   * APRÈS — `arbitrateQuestOpenAnswers` fait juger par un modèle les réponses
//     libres que l'ensemble déterministe a refusées, AVANT que la RPC ne note.
//
// Ce module vit à côté de `quest.server.ts` plutôt que dedans pour la raison qui
// a déjà sorti `quest.training.ts` : ce fichier est à sa limite `max-lines`, et
// une porte de dix lignes n'a pas à la faire sauter.
//
// POURQUOI L'IMPORT DE `@/features/ai/ai-call.server` EST ASSUMÉ ICI
// ---------------------------------------------------------------------------
// Une feature n'en importe pas une autre — sauf pour PARLER AU MODÈLE, qui n'a
// qu'une porte. `features/tutor` a franchi cette frontière deux fois (é11 lots 1
// et 3, `tutor.server.ts` et `tutor.stream.server.ts`) et le précédent est
// documenté sur place. On le suit, au lieu d'inventer une troisième règle.
//
// Ce qui NE traverse pas : l'orchestration elle-même, qui vit dans
// `shared/integrations/ai/open-answer.server.ts` parce que la logique « juger
// une réponse libre » n'appartient pas à la quête. Elle reçoit `callAi` en
// paramètre — `shared/` ne doit pas importer `features/`, ce serait inverser la
// dépendance plutôt que la traverser.

import { callAi } from "@/features/ai/ai-call.server";
import { arbitrateOpenAnswers } from "@/shared/integrations/ai/open-answer.server";
import type { Database } from "@/shared/integrations/supabase/types";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";

/** Le type natif des questions ouvertes (étude 20 volet B). */
export const OPEN_QUESTION_TYPE = "short_answer";

/** Une question telle que `getExercise` la sert — seul son type nous intéresse. */
type ServedQuestion = { question_type?: string | null };

/**
 * Le client, réduit au SEUL appel dont cette porte a besoin — et dont la forme
 * vient des types GÉNÉRÉS, donc de la base.
 *
 * Deux raisons de ne pas demander ici un `SupabaseClient<Database>` entier :
 * la porte n'utilise qu'une RPC, et exiger le client complet obligerait son
 * test à en monter une contrefaçon entière pour exercer dix lignes. Ce qui
 * compte est que `p_student` et le type de retour ne soient plus recopiés à la
 * main : ils l'ont été tant que la RPC était plus récente que `types.ts`, et
 * le commentaire qui le justifiait a survécu à sa raison (#1074).
 */
export type OpenQuestionsGate = {
  rpc: (
    fn: "can_play_open_questions",
    args: Database["public"]["Functions"]["can_play_open_questions"]["Args"],
  ) => PromiseLike<{
    data: Database["public"]["Functions"]["can_play_open_questions"]["Returns"] | null;
    error: { message: string } | null;
  }>;
};

/**
 * La porte, lue en base — jamais recalculée ici.
 *
 * `can_play_open_questions` est la MÊME fonction que celle dont dépend le
 * dénominateur du score. Un second calcul côté TypeScript (« la ligne
 * d'activation porte-t-elle `open_answer` ? ») rendrait la bonne réponse
 * aujourd'hui et divergerait le jour où la porte gagne une condition — et la
 * divergence se paierait en questions notées mais jamais servies.
 *
 * DEGRADE EN FERMÉ. Une lecture qui échoue rend `false` : au pire l'élève joue
 * une mission d'une question de moins, notée sur ce qu'il a vu. L'inverse —
 * degrader en ouvert — servirait une question libre sans juge, c'est-à-dire
 * exactement ce que l'arbitrage du propriétaire interdit.
 */
export async function canPlayOpenQuestions(
  supabase: OpenQuestionsGate,
  userId: string | null | undefined,
): Promise<boolean> {
  if (!userId) return false;

  try {
    const { data, error } = await supabase.rpc("can_play_open_questions", { p_student: userId });
    if (error) {
      logger.warn("quest.openQuestions.gate", { error: error.message });
      return false;
    }
    return data === true;
  } catch (cause) {
    logger.warn("quest.openQuestions.gate", { error: errorMessage(cause) });
    return false;
  }
}

/**
 * Le jeu servi, privé de ses questions ouvertes quand la porte est fermée.
 *
 * Pure et générique sur la forme de la question : `getExercise` sert des lignes
 * de `questions`, le Rappel sert un jeu reconstruit, et aucune des deux n'a à
 * connaître cette règle.
 */
export function filterOpenQuestions<Q extends ServedQuestion>(
  questions: readonly Q[],
  openAllowed: boolean,
): Q[] {
  if (openAllowed) return [...questions];
  return questions.filter((q) => (q.question_type ?? "mcq") !== OPEN_QUESTION_TYPE);
}

/**
 * Fait arbitrer les réponses libres refusées, avant la notation.
 *
 * NE LÈVE JAMAIS et ne rend rien : la note se calcule en base, à partir de la
 * base. Ce geste ne fait qu'y déposer, le cas échéant, le verdict d'un juge sur
 * une réponse que l'ensemble authored ne connaissait pas.
 */
export async function arbitrateQuestOpenAnswers(
  userId: string,
  answers: ReadonlyArray<{ questionId: string; choice: string }>,
): Promise<void> {
  await arbitrateOpenAnswers({
    studentUserId: userId,
    answers,
    // `callAi` porte déjà l'accès, l'énergie, le budget, l'egress et la
    // comptabilité. On ne lui ajoute rien : l'arbitrage est un appel comme un
    // autre, sur une surface de plus.
    judge: (request) => callAi(request),
  });
}
