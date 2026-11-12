import { onlineManager } from "@tanstack/react-query";
import { isSessionRefusalError } from "@/shared/integrations/supabase/auth-rejection";
import { RATE_LIMITED_CODE } from "@/shared/lib/client-error-codes";

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
// Deux autres causes ont rejoint la session morte le 2026-11-12 (étude 38, R-15),
// parce que l'élève peut quelque chose à chacune et que ce n'est pas le même geste :
// le RÉSEAU manque (attendre qu'il revienne), ou le serveur a refusé pour trop
// d'appels (code stable `RATE_LIMITED` — patienter une minute). Avant, la première
// s'affichait « Failed to fetch » et la seconde en français, dans les trois langues.
//
// Le reste continue de passer tel quel, à dessein : ces messages-là viennent de
// nos propres server fns (« Exercise not found », les refus de gate), et les
// aplatir en « une erreur est survenue » ferait perdre à l'élève ET au
// développeur la seule information utile de l'écran.
// =============================================================================

/** Les libellés nécessaires — la forme de `t.errors`, sans le reste. */
export type ErrorLabels = {
  sessionExpired: string;
  errorFallback: string;
  offline: string;
  rateLimited: string;
};

/**
 * Ce que `fetch` lève quand la requête n'a pas atteint le serveur — un libellé par
 * moteur (Chromium, WebKit, Gecko). Un navigateur peut échouer ainsi AVANT d'avoir
 * annoncé `offline` : un réseau mobile qui décroche ne prévient pas.
 */
const FETCH_FAILURES = [
  "Failed to fetch",
  "Load failed",
  "NetworkError when attempting to fetch resource.",
];

/** L'appel a-t-il échoué faute de réseau ? */
export function isNetworkFailure(error: unknown): boolean {
  if (!onlineManager.isOnline()) return true;
  return error instanceof TypeError && FETCH_FAILURES.includes(error.message);
}

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
  if (error instanceof Error && error.message === RATE_LIMITED_CODE) return labels.rateLimited;
  if (isNetworkFailure(error)) return labels.offline;
  return error instanceof Error ? error.message : labels.errorFallback;
}
