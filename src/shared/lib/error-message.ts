import { isRejectedTokenError } from "@/shared/integrations/supabase/auth-rejection";

// =============================================================================
// CE QU'ON MONTRE À L'ÉLÈVE quand un appel a échoué.
//
// Le réflexe `e instanceof Error ? e.message : fallback` remonte le message du
// SERVEUR tel quel. C'est utile au développeur et illisible pour l'élève dès que
// le message n'est pas traduit — « Unauthorized: Invalid token » au milieu d'une
// interface arabe, signalé en fin de quiz. Un seul cas mérite aujourd'hui d'être
// nommé dans sa langue, parce qu'il est le seul dont l'élève puisse quelque
// chose : sa session est morte, il faut se reconnecter.
//
// Le reste continue de passer tel quel, à dessein : ces messages-là viennent de
// nos propres server fns (« Exercise not found », les refus de gate), et les
// aplatir en « une erreur est survenue » ferait perdre à l'élève ET au
// développeur la seule information utile de l'écran.
// =============================================================================

/** Les deux libellés nécessaires — la forme de `t.errors`, sans le reste. */
export type ErrorLabels = {
  sessionExpired: string;
  errorFallback: string;
};

/**
 * Le message à afficher pour cet échec.
 *
 * Un jeton refusé n'arrive ici qu'APRÈS le rejeu de `mutations.retry` (qui
 * repart avec un jeton neuf) : y parvenir signifie donc une session bel et bien
 * morte, pas un simple hoquet — d'où une phrase qui envoie se reconnecter
 * plutôt qu'une qui invite à réessayer.
 */
export function userFacingError(error: unknown, labels: ErrorLabels): string {
  if (isRejectedTokenError(error)) return labels.sessionExpired;
  return error instanceof Error ? error.message : labels.errorFallback;
}
