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
import { createMiddleware } from "@tanstack/react-start";
import { supabase } from "./client";

/**
 * L'access token à poser sur l'appel, ou `null` s'il n'y en a pas.
 *
 * POURQUOI CE N'EST PAS UN SIMPLE `getSession()`. `getSession()` rafraîchit
 * DÉJÀ une session expirée (auth-js `__loadSession`) : arriver ici sans jeton
 * signifie donc l'un des deux cas seulement —
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
 * connexion. La zone grise entre les deux — client connecté, jeton irrécupérable
 * sans que la session soit effacée — reste ouverte.
 */
async function resolveAccessToken(): Promise<string | null> {
  const { data, error } = await supabase.auth.getSession();
  const token = data.session?.access_token;
  if (token) return token;
  // Cas 1 : pas de session du tout. Rien à retenter.
  if (!error) return null;
  // Cas 2 : le rafraîchissement a échoué — on lui redonne sa chance.
  const { data: refreshed } = await supabase.auth.refreshSession();
  return refreshed.session?.access_token ?? null;
}

// Must be registered as a global `functionMiddleware` in `src/start.ts`; otherwise
// the browser never attaches the bearer token to serverFn RPCs.
export const attachSupabaseAuth = createMiddleware({ type: "function" }).client(
  async ({ next }) => {
    const token = await resolveAccessToken();
    return next({
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    });
  },
);
