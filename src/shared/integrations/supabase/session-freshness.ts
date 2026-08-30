// UN JETON FRAIS AVANT UNE MUTATION CRITIQUE — et une seule course pour tous.
//
// POURQUOI CE MODULE N'EST PAS DANS `auth-attacher.ts`. Le même raisonnement que
// pour `auth-rejection.ts` : `auth-attacher` exécute `createMiddleware(...)` à
// L'IMPORT, donc quiconque veut seulement rafraîchir une session tirerait tout
// le middleware dans son sillage. Ici on n'importe que le client, qui est inerte
// à l'import (Proxy à init paresseuse).
//
// CE QUE ÇA AJOUTE À `auth-attacher`, QUI RATTRAPE DÉJÀ UN REFUS. L'attacheur
// est RÉACTIF : il apprend qu'un jeton est mauvais parce que le serveur vient de
// le refuser, et arme le suivant. Ce module est PRÉVENTIF : avant une écriture
// qu'on ne veut pas perdre, on regarde le temps qu'il reste au jeton et on le
// renouvelle si la marge est trop courte. Les deux se complètent — l'un évite le
// refus, l'autre le rattrape.
import { supabase } from "./client";

/**
 * En dessous de cette marge, le jeton est considéré comme trop court pour une
 * mutation et se renouvelle avant l'appel.
 *
 * 120 s, et pas la marge de 90 s d'auth-js, DÉLIBÉRÉMENT : à 90 s on rejouerait
 * exactement la décision de `__loadSession`, qui est celle dont on se méfie. Ce
 * qu'on veut, c'est décider AVANT elle — sinon on ne fait que lui redemander son
 * avis, et un jeton qu'elle juge encore bon repart tel quel.
 */
export const REFRESH_MARGIN_SECONDS = 120;

/**
 * La course en cours, s'il y en a une. C'est TOUT le mutex : dix appelants qui
 * constatent la péremption en même temps rejoignent la même promesse au lieu de
 * lancer dix `refreshSession()`.
 *
 * POURQUOI ÇA COMPTE ICI PLUS QU'AILLEURS. Chaque `refreshSession()` fait TOURNER
 * le refresh token (rotation), et le précédent devient invalide. Dix
 * rafraîchissements concurrents, c'est donc neuf jetons morts et un
 * `Invalid Refresh Token: Already Used` — la course exacte qu'on essaie de
 * corriger. Un correctif qui la recréerait serait pire que le bug.
 */
let inFlight: { readonly promise: Promise<string | null>; readonly forced: boolean } | null = null;

/**
 * Le jeton d'accès, renouvelé s'il est trop court (ou si `force`).
 *
 * Rend `null` quand il n'y a pas de session — le visiteur anonyme, ou une
 * session définitivement morte. L'appelant décide ce que ça veut dire chez lui ;
 * ce module ne redirige rien.
 *
 * @param force Ignorer le TTL et rafraîchir quoi qu'il arrive. C'est le geste à
 *   faire après un refus serveur : l'horloge locale vient de prouver qu'elle
 *   ment, lui redemander son avis n'aurait aucun sens.
 */
export function ensureFreshSession(force = false): Promise<string | null> {
  const current = inFlight;
  if (current) {
    // Une course non forcée est un sur-ensemble suffisant d'une autre non
    // forcée : on la rejoint. Mais une demande FORCÉE qui rejoindrait une course
    // non forcée pourrait recevoir le jeton que l'horloge locale juge encore
    // bon — précisément celui qu'on vient de faire refuser. Elle s'enchaîne donc
    // APRÈS, au lieu de se confondre avec elle.
    if (!force || current.forced) return current.promise;
    return current.promise.then(() => ensureFreshSession(true));
  }

  const promise = refreshIfNeeded(force).finally(() => {
    if (inFlight?.promise === promise) inFlight = null;
  });
  inFlight = { promise, forced: force };
  return promise;
}

/**
 * L'expiration du dernier jeton VU, en secondes UNIX — ou `undefined` si aucune
 * session n'est encore passée par ici.
 *
 * POURQUOI ON LA MÉMORISE. La télémétrie du refus (`client-log.ts`) a besoin du
 * TTL restant, et elle en a besoin dans un chemin d'ERREUR : y appeler
 * `getSession()` déclencherait une lecture asynchrone — et, sur une session
 * abîmée, potentiellement un rafraîchissement — au pire moment. Une valeur déjà
 * connue, lue sans rien réveiller, suffit à répondre à la seule question posée :
 * l'appareil se croyait-il encore dans les temps ?
 */
let lastExpiresAt: number | undefined;

export function lastKnownExpiry(): number | undefined {
  return lastExpiresAt;
}

function remember(expiresAt: number | undefined): void {
  if (typeof expiresAt === "number" && Number.isFinite(expiresAt)) lastExpiresAt = expiresAt;
}

async function refreshIfNeeded(force: boolean): Promise<string | null> {
  if (force) {
    const { data } = await supabase.auth.refreshSession();
    remember(data.session?.expires_at);
    return data.session?.access_token ?? null;
  }

  const { data } = await supabase.auth.getSession();
  const session = data.session;
  if (!session) return null;
  remember(session.expires_at);

  if (secondsUntilExpiry(session.expires_at) > REFRESH_MARGIN_SECONDS) {
    return session.access_token;
  }

  const refreshed = await supabase.auth.refreshSession();
  remember(refreshed.data.session?.expires_at);
  // Un rafraîchissement raté ne doit pas effacer un jeton encore utilisable :
  // le serveur tranchera, et `auth-attacher` rattrapera son refus.
  return refreshed.data.session?.access_token ?? session.access_token;
}

/**
 * Le temps qu'il reste au jeton, en secondes. `expires_at` est un instant UNIX
 * en secondes ; absent, on répond 0 — « traite-le comme périmé » est le défaut
 * sûr, il déclenche un rafraîchissement au lieu d'en sauter un.
 */
export function secondsUntilExpiry(expiresAt: number | undefined): number {
  if (typeof expiresAt !== "number" || !Number.isFinite(expiresAt)) return 0;
  return Math.round(expiresAt - Date.now() / 1000);
}

/** Oublie la course en cours et l'expiration mémorisée — réservé aux tests. */
export function resetSessionFreshnessForTests(): void {
  inFlight = null;
  lastExpiresAt = undefined;
}
