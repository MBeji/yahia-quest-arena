import { isSessionRefusalError } from "@/shared/integrations/supabase/auth-rejection";

// =============================================================================
// CE QU'ON MONTRE À L'ÉLÈVE quand un appel a échoué.
//
// Le réflexe `e instanceof Error ? e.message : fallback` remonte le message du
// SERVEUR tel quel. C'est utile au développeur et illisible pour l'élève dès que
// le message n'est pas traduit — « Unauthorized: Invalid token » au milieu d'une
// interface arabe, signalé en fin de quiz. Un seul cas mérite aujourd'hui d'être
// nommé dans sa langue, parce qu'il est le seul dont l'élève puisse quelque
// chose : sa session est morte, il faut se reconnecter. Le refus « pas d'en-tête
// d'autorisation » y a rejoint le jeton refusé le 2026-08-31 — c'est la MÊME
// chose pour l'élève (sa session ne produit plus de jeton), et sa formulation
// anglaise n'avait rien à faire à l'écran.
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
 * Un refus de session n'arrive ici qu'APRÈS le rejeu de `mutations.retry` (qui
 * repart avec un jeton neuf, le drapeau d'`auth-attacher` ayant été armé par le
 * premier échec) : y parvenir signifie donc une session bel et bien morte, pas
 * un simple hoquet — d'où une phrase qui envoie se reconnecter plutôt qu'une qui
 * invite à réessayer.
 */
export function userFacingError(error: unknown, labels: ErrorLabels): string {
  if (isSessionRefusalError(error)) return labels.sessionExpired;
  return error instanceof Error ? error.message : labels.errorFallback;
}
