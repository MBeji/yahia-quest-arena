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
 * Ce que ça ne prétend pas être : un remède au jeton de rafraîchissement
 * DÉFINITIVEMENT mort. Dans ce cas auth-js efface la session et émet
 * `SIGNED_OUT`, et c'est le garde de `_authenticated` qui renvoie vers la
 * connexion.
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
    const token = forced === TIMED_OUT ? null : forced.data.session?.access_token;
    if (token) return token;
    // Le forçage n'a rien donné : on retombe sur le chemin normal, qui saura
    // dire « pas de session » (et le garde de `_authenticated` fera son office).
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
