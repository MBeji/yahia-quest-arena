// Attaches the caller's bearer token to every server-fn RPC — CLIENT side.
//
// NOT generated, despite the header this file used to carry: nothing produces
// it and `guard-generated.mjs` does not list it (only `types.ts` is).
//
// ⚠️ This `.client()` middleware is the ONLY thing that puts a token on a
// server-fn call, and it reads the session from localStorage. Consequence, and
// it is architectural: **the server never holds a session**, so a route
// `loader` running at SSR cannot call an authenticated server fn — it would be
// rejected as unauthorized. Real SSR prefetching of authenticated data needs
// cookie-borne sessions first. See finding C1-fe in docs/performance-audit.md.
//
// Étant le seul poseur de jeton, il est aussi le seul témoin de son REFUS : il
// le retient (`markTokenRejected`) pour que l'appel suivant force un jeton
// neuf. Il ne rejoue rien lui-même — voir le commentaire du `catch`, qui dit
// pourquoi c'est structurellement impossible ici.
import { createMiddleware } from "@tanstack/react-start";
import { isAuthRetryableFetchError } from "@supabase/supabase-js";
import { reportClientError } from "@/shared/lib/client-log";
import { isSessionRefusalError } from "./auth-rejection";
import { supabase } from "./client";

/**
 * Au-delà, on cesse d'ATTENDRE le service Auth et on rend la main.
 *
 * POURQUOI UNE LIMITE. Poser le jeton est la première chose que fait tout appel
 * de server fn : tant qu'elle n'a pas rendu, la mutation reste `isPending` — et
 * dans le lecteur de mission, `isPending` GRISE le bouton « Valider ». Une
 * lecture de session qui ne revient jamais ne donne donc pas une erreur, elle
 * donne un bouton mort avec sa roulette, dont seul un rechargement sort. Ce
 * n'est pas théorique : auth-js sérialise l'accès à la session derrière un
 * verrou (`navigator.locks`) et réessaie un rafraîchissement en échec avec
 * temporisation — exactement la situation d'un jeton refusé, celle-là même que
 * ce fichier vient d'apprendre à rattraper d'un `refreshSession()` de plus.
 *
 * 8 s est délibérément large : un aller-retour Auth sain se compte en dizaines
 * de millisecondes, et un réseau mobile lent doit pouvoir aboutir. Ce n'est pas
 * un budget de performance, c'est le seuil au-delà duquel l'élève est devant un
 * écran figé. Passé ce délai on part SANS jeton : le serveur refuse, l'échec se
 * voit, et la reprise (`mutations.retry`) rejoue l'appel. Une erreur bornée vaut
 * mieux qu'un gel sans fin.
 */
const AUTH_CALL_TIMEOUT_MS = 8_000;

/** Ce que rend la course quand le service Auth n'a pas répondu à temps. */
const TIMED_OUT = Symbol("auth-call-timed-out");

async function withAuthTimeout<T>(call: Promise<T>): Promise<T | typeof TIMED_OUT> {
  let timer: ReturnType<typeof setTimeout> | undefined;
  try {
    return await Promise.race([
      call,
      new Promise<typeof TIMED_OUT>((resolve) => {
        timer = setTimeout(() => resolve(TIMED_OUT), AUTH_CALL_TIMEOUT_MS);
      }),
    ]);
  } finally {
    // Sans ça, chaque appel laisserait derrière lui une minuterie de 8 s — et,
    // sous Node, de quoi tenir le processus de test éveillé d'autant.
    clearTimeout(timer);
  }
}

/**
 * Le serveur a-t-il refusé le dernier jeton posé ? Mémoire d'un seul cran, lue
 * et effacée par le prochain `resolveAccessToken()`.
 */
let rejectedToken = false;

/** Retient qu'un jeton vient d'être refusé (voir le middleware plus bas). */
export function markTokenRejected(): void {
  rejectedToken = true;
}

/** Lit ET efface le drapeau : le forçage ne vaut que pour l'appel suivant. */
function consumeRejectedToken(): boolean {
  const wasRejected = rejectedToken;
  rejectedToken = false;
  return wasRejected;
}

/** Remet le drapeau à zéro — réservé aux tests. */
export function resetRejectedTokenForTests(): void {
  rejectedToken = false;
}

/**
 * Ce rafraîchissement a-t-il échoué DÉFINITIVEMENT, ou seulement pour cette fois ?
 *
 * La distinction décide d'une déconnexion, donc elle doit pencher du bon côté :
 * dans le doute, on répond « transitoire » et l'élève garde sa session. Seul un
 * REFUS du serveur (4xx qui n'est pas un 429) compte comme terminal — le jeton
 * de rafraîchissement a été présenté et rejeté. Une panne de transport, une
 * limitation de débit ou un 5xx ne disent rien de la validité du jeton : ils
 * disent qu'on n'a pas pu demander.
 *
 * `isAuthRetryableFetchError` est l'étiquette d'auth-js pour le transport ; le
 * 429 n'y est pas rangé, d'où la ligne qui suit. C'est le même partage que
 * `isVerificationUnavailable` côté serveur (`auth-request.ts`) — écrit deux fois
 * à dessein : ce fichier est CLIENT, et importer `auth-request.ts` ferait entrer
 * le SDK serveur dans le bundle du navigateur (voir l'en-tête d'`auth-refusals.ts`).
 */
function isTerminalRefreshFailure(error: unknown): boolean {
  if (!error) return false;
  if (isAuthRetryableFetchError(error)) return false;
  const { status } = error as { status?: unknown };
  // La PREUVE, et rien d'autre : le service Auth a répondu, et sa réponse est un
  // refus (4xx, hors 429 qui dit « trop de demandes », pas « mauvais jeton »).
  // Tout le reste — 5xx, statut absent, forme d'erreur inconnue — retombe sur
  // `false`. C'est volontairement l'inverse d'un `return true` final : la SORTIE
  // est un geste destructeur (l'élève perd sa session), donc elle se mérite par
  // une preuve positive, jamais par défaut.
  return typeof status === "number" && status >= 400 && status < 500 && status !== 429;
}

/**
 * Termine LOCALEMENT une session dont le serveur a refusé les deux jetons.
 *
 * POURQUOI LE CLIENT DOIT LE FAIRE LUI-MÊME, alors qu'auth-js sait effacer une
 * session. Parce qu'auth-js ne le fait PAS dans ce cas précis, et c'est
 * délibéré de sa part : à l'échec d'un rafraîchissement il ne détruit la session
 * que si l'`access_token` est déjà périmé selon `expires_at` ; sinon il la
 * PRÉSERVE, en supposant qu'un jeton non expiré fonctionne encore
 * (`GoTrueClient`, branche « proactive refresh failed, access token still
 * valid »). L'hypothèse est raisonnable en général et fausse ici : nous savons,
 * nous, que le serveur vient de REFUSER cet access token. auth-js ne connaît que
 * l'horloge ; le middleware, lui, a vu le refus. C'est exactement l'information
 * qui manque au SDK, et c'est pour ça que la décision revient à ce fichier.
 *
 * `scope: "local"` et pas un `signOut()` complet : les jetons sont morts, un
 * aller-retour de révocation échouerait de toute façon, et on ne veut pas faire
 * dépendre la SORTIE de l'élève d'un appel réseau qui peut pendre. Effacer le
 * stockage émet `SIGNED_OUT`, `useAuth` remet `user` à `null`, et le garde de
 * `_authenticated` renvoie vers `/auth`. C'est l'issue que la spec exige — elle
 * n'en impose aucune en particulier, elle interdit le cul-de-sac.
 */
async function endDeadSession(): Promise<void> {
  try {
    // Borné comme tout le reste : un `signOut` qui pend derrière le verrou
    // d'auth-js rendrait le bouton « Valider » gris sans fin — la panne même
    // que ce fichier a déjà corrigée une fois (#914/#915).
    await withAuthTimeout(supabase.auth.signOut({ scope: "local" }));
  } catch (error) {
    // Une déconnexion locale qui échoue ne doit pas masquer le refus d'origine :
    // on le journalise et on rend la main. L'appel partira sans jeton, le
    // serveur refusera, et l'erreur restera VISIBLE — ce qui vaut mieux qu'une
    // exception avalée par le middleware.
    reportClientError({
      stage: "token-attach",
      errMessage: `local sign-out after terminal refresh failure: ${
        error instanceof Error ? error.message : String(error)
      }`,
    });
  }
}

/**
 * L'access token à poser sur l'appel, ou `null` s'il n'y en a pas.
 *
 * POURQUOI CE N'EST PAS UN SIMPLE `getSession()`. `getSession()` rafraîchit
 * DÉJÀ une session expirée (auth-js `__loadSession`) : arriver ici sans jeton
 * signifie donc l'un de ces deux cas —
 *
 *   1. personne n'est connecté (`error` nul) — le cas de tout visiteur anonyme,
 *      et il n'y a rien à retenter ;
 *   2. le RAFRAÎCHISSEMENT A ÉCHOUÉ (`error` non nul) : auth-js rend alors
 *      `session: null` et le middleware serveur voit un appel SANS en-tête.
 *
 * Le cas 2 est celui qui se voyait en production : le client se croit connecté
 * (rien n'a effacé la session, `onAuthStateChange` n'a pas émis `SIGNED_OUT`),
 * donc aucune redirection vers la connexion ne se déclenche, mais plus aucune
 * server fn n'aboutit. L'écran affiche « Failed to load dashboard », son bouton
 * « Réessayer » rejoue le même appel — et seule une déconnexion/reconnexion
 * manuelle en sortait. Signalé le 2026-08-18, deux fois dans la soirée.
 *
 * Une SEULE reprise explicite, et uniquement dans le cas 2 : une panne de
 * rafraîchissement passagère (réseau mobile, 5xx de l'Auth, retour d'onglet en
 * veille) redevient alors un simple ralentissement au lieu d'un blocage. Le
 * visiteur anonyme, lui, ne paie rien : on sort sur `error` nul avant tout
 * appel — et `refreshSession()` sans session stockée échoue de toute façon
 * localement, sans aller-retour réseau.
 *
 * ⚠️ LE JETON DE RAFRAÎCHISSEMENT DÉFINITIVEMENT MORT — ce que ce bloc affirmait,
 * et qui était FAUX. Il disait : « dans ce cas auth-js efface la session et émet
 * `SIGNED_OUT`, et c'est le garde de `_authenticated` qui renvoie vers la
 * connexion. » auth-js ne fait cela que si l'`access_token` est AUSSI périmé
 * selon `expires_at` ; tant que cette date est dans le futur, il PRÉSERVE la
 * session à dessein. Une session dont les deux jetons sont refusés mais dont
 * l'`expires_at` est intact n'était donc effacée par personne : `getSession()`
 * rendait le même jeton refusé à chaque appel, le garde ne voyait jamais
 * `user === null`, et l'élève restait sur un écran dont rien ne le sortait
 * (#938 → #969). La sortie est posée plus bas, dans le cas 3.
 *
 * CAS 3, ET IL MANQUAIT — le jeton RENDU est refusé par le serveur. Les deux
 * cas ci-dessus supposent qu'un jeton rendu est un bon jeton ; c'est faux, et
 * c'est la panne « Unauthorized: Invalid token » signalée en fin de quiz. La
 * raison est dans auth-js : `__loadSession` ne juge de la péremption que sur
 * `expires_at * 1000 - Date.now() < EXPIRY_MARGIN_MS` (90 s) — donc sur
 * L'HORLOGE DE L'APPAREIL, jamais sur celle du serveur, et sans jamais
 * vérifier la signature. Une horloge en RETARD de plus de 90 s fait donc rendre
 * un jeton réellement périmé, et le ticker d'`autoRefreshToken` — qui lit la
 * même horloge — ne se déclenche pas davantage : l'élève est enfermé, et le
 * reste. Même issue, fenêtre plus étroite, si le jeton expire entre la lecture
 * et la vérification côté serveur (réseau lent, démarrage à froid).
 *
 * D'où le drapeau ci-dessus : après un refus, on ne DEMANDE plus son avis à
 * l'horloge locale, on force `refreshSession()` — un aller-retour qui fait
 * émettre un jeton neuf par le serveur, seule autorité sur l'heure et sur la
 * signature. C'est ce qui referme la zone grise « client connecté, jeton
 * irrécupérable sans que la session soit effacée ».
 *
 * ⚠️ EXPORTÉE depuis é11 lot 3, et une seule raison le justifie : le chat du
 * tuteur n'est pas une server fn, c'est un `fetch` vers `/api/tutor/stream`. Il
 * doit poser le MÊME jeton, obtenu de la MÊME façon. Une seconde lecture de
 * session, écrite « juste pour le chat », perdrait la reprise du cas 2 — et
 * rejouerait exactement la panne du 2026-08-18.
 */
export async function resolveAccessToken(): Promise<string | null> {
  // Cas 3 : le serveur vient de REFUSER ce jeton. `getSession()` le rendrait
  // pourtant tel quel — il ne juge de la péremption que sur `expires_at` et
  // l'horloge locale —, donc on force la seule chose qui ne dépend ni de l'une
  // ni de l'autre : un aller-retour de rafraîchissement.
  if (consumeRejectedToken()) {
    const forced = await withAuthTimeout(supabase.auth.refreshSession());
    if (forced !== TIMED_OUT) {
      const token = forced.data.session?.access_token;
      if (token) return token;
      // Le serveur a refusé l'access token ET vient de refuser le refresh token :
      // cette session est morte, et personne d'autre ne le sait. Retomber sur le
      // chemin normal serait ici une BOUCLE, pas un repli — `getSession()` ne
      // vérifie aucune signature et rendrait exactement le jeton qu'on vient de
      // faire refuser, indéfiniment. On termine donc la session localement, ce
      // qui rend la main au garde de `_authenticated`.
      if (isTerminalRefreshFailure(forced.error)) {
        await endDeadSession();
        return null;
      }
    }
    // Échec NON terminal (délai dépassé, transport, 429, 5xx) : on ne déconnecte
    // personne pour une panne passagère. On retombe sur le chemin normal, qui
    // repartira du jeton stocké — c'est le comportement d'avant, et il est bon
    // tant que le refus n'est pas prouvé définitif.
  }

  const current = await withAuthTimeout(supabase.auth.getSession());
  if (current === TIMED_OUT) return null;
  const { data, error } = current;
  const token = data.session?.access_token;
  if (token) return token;
  // Cas 1 : pas de session du tout. Rien à retenter.
  if (!error) return null;
  // Cas 2 : le rafraîchissement a échoué — on lui redonne sa chance.
  const refreshed = await withAuthTimeout(supabase.auth.refreshSession());
  if (refreshed === TIMED_OUT) return null;
  return refreshed.data.session?.access_token ?? null;
}

// Must be registered as a global `functionMiddleware` in `src/start.ts`; otherwise
// the browser never attaches the bearer token to serverFn RPCs.
export const attachSupabaseAuth = createMiddleware({ type: "function" }).client(
  async ({ next }) => {
    const token = await resolveAccessToken();
    try {
      return await next({
        headers: token ? { Authorization: `Bearer ${token}` } : {},
      });
    } catch (error) {
      // ⚠️ ON NE REJOUE PAS ICI, et ce n'est pas un oubli. `executeMiddleware`
      // (@tanstack/start-client-core) consomme sa liste par `shift()` sur une
      // portée PARTAGÉE : un second `next()` la trouverait vide, rendrait le
      // contexte tel quel — et l'appel HTTP n'aurait jamais lieu. Le rejeu
      // silencieux d'un `undefined` serait pire que la panne qu'il corrige.
      //
      // Ce middleware fait donc la seule moitié qui lui revient : RETENIR le
      // refus, pour que le prochain appel parte avec un jeton neuf. L'autre
      // moitié — redemander — appartient à l'appelant (`mutations.retry`).
      if (isSessionRefusalError(error)) {
        // Étant le seul poseur de jeton, il est aussi le seul à voir TOUS les
        // refus — y compris ceux d'appels qui ne passent pas par la file. La
        // mesure est prise ici, avant que `markTokenRejected` ne fasse forcer
        // un jeton neuf au prochain appel.
        //
        // « Refus » couvre les deux moitiés depuis le 2026-08-31 : le jeton
        // POSÉ et refusé, et le jeton ABSENT — ce dernier étant précisément ce
        // que produisent les deux issues sans jeton de `resolveAccessToken`
        // (rafraîchissement en échec, ou dépassement des 8 s). Ne reconnaître
        // que le premier laissait le second sans le moindre rattrapage : voir
        // le bloc du haut de `auth-rejection.ts`.
        reportClientError({
          stage: "token-attach",
          errMessage: error instanceof Error ? error.message : String(error),
        });
        markTokenRejected();
      }
      throw error;
    }
  },
);
