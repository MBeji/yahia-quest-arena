// L'AUTHENTIFICATION D'UNE REQUÊTE BRUTE — extrait de `auth-middleware.ts`.
//
// POURQUOI CET EXTRAIT EXISTE
// ---------------------------------------------------------------------------
// Jusqu'ici, une seule porte d'entrée authentifiée existait : la server fn, et
// son middleware. L'étude 11 lot 3 en ouvre une seconde — `POST /api/tutor/stream`,
// interceptée dans `src/server.ts` avant le handler SSR, parce qu'une réponse
// SSE ne passe pas par une server fn (§3.3, D-7).
//
// L'étude le dit en toutes lettres : « extraire de `auth-middleware.ts` un
// helper partagé `resolveSupabaseAuth(request)` (vérification du Bearer JWT +
// client scoped) utilisé par le middleware ET la route — pas de duplication ».
// La duplication serait le vrai danger : deux vérifications de jeton qui
// divergent, c'est une porte qui finit par s'ouvrir moins fort que l'autre.
//
// CE QUI RESTE DANS LE MIDDLEWARE
// ---------------------------------------------------------------------------
// La MISE EN FORME du refus. Une server fn lève une `Error` dont le message
// remonte au client ; la route SSE, elle, rend un statut HTTP. Le helper rend
// donc un RÉSULTAT typé, et chaque appelant l'exprime dans son propre langage.
//
// La distinction entre « jeton rejeté » et « vérification impossible » est
// conservée telle quelle : sur la clé de signature symétrique héritée,
// `getClaims` fait un aller-retour Auth complet, et l'indisponibilité est le
// mode de panne ATTENDU sous charge, pas un cas tordu.

import { createClient, isAuthRetryableFetchError } from "@supabase/supabase-js";
import type { SupabaseClient } from "@supabase/supabase-js";
import type { Database } from "./types";

// `AuthFailure` vit dans `auth-refusals.ts` — la table qui, pour CHAQUE refus,
// porte son message et la conduite du client. Le type y est posé plutôt qu'ici
// parce que le prédicat client doit le lire sans tirer `@supabase/supabase-js`
// (importé plus haut) dans le bundle du navigateur.
export type { AuthFailure } from "./auth-refusals";
import type { AuthFailure } from "./auth-refusals";

export type AuthResolution =
  | {
      readonly ok: true;
      readonly supabase: SupabaseClient<Database>;
      readonly userId: string;
      readonly claims: Record<string, unknown>;
    }
  | { readonly ok: false; readonly failure: AuthFailure; readonly detail?: string };

/** Le jeton porté par l'en-tête, ou la raison précise de son absence. */
export function bearerToken(headers: Headers): { token: string } | { failure: AuthFailure } {
  const header = headers.get("authorization");
  if (!header) return { failure: "NO_HEADER" };
  if (!header.startsWith("Bearer ")) return { failure: "BAD_SCHEME" };
  const token = header.slice("Bearer ".length);
  return token ? { token } : { failure: "EMPTY_TOKEN" };
}

/** Les variables d'environnement manquantes, s'il y en a. Vide = tout est là. */
export function missingSupabaseEnv(): string[] {
  return [
    ...(process.env.SUPABASE_URL ? [] : ["SUPABASE_URL"]),
    ...(process.env.SUPABASE_PUBLISHABLE_KEY ? [] : ["SUPABASE_PUBLISHABLE_KEY"]),
  ];
}

/**
 * Le service Auth a-t-il échoué à RÉPONDRE, plutôt que répondu « ce jeton est
 * mauvais » ? `AuthRetryableFetchError` est l'étiquette d'auth-js pour une
 * panne de transport ; un 429 n'y est pas rangé, mais « nous n'avons pas pu
 * vérifier » est tout aussi vrai, donc il rejoint la même branche.
 */
export function isVerificationUnavailable(error: unknown): boolean {
  if (isAuthRetryableFetchError(error)) return true;
  return (error as { status?: unknown } | null | undefined)?.status === 429;
}

/**
 * Vérifie le Bearer d'une requête et rend un client Supabase PORTANT ce jeton.
 *
 * Client par requête, délibérément : il porte les identifiants de l'appelant et
 * ne doit JAMAIS être hissé en portée module (ce serait la session d'un élève
 * dans la requête d'un autre). Le hisser n'apporterait rien de toute façon —
 * supabase-js garde son cache JWKS dans une map de portée module, indexée par
 * le `storageKey` qu'il dérive du projet, donc tous ces clients partagent déjà
 * la même entrée.
 */
export async function resolveSupabaseAuth(request: Request): Promise<AuthResolution> {
  const missing = missingSupabaseEnv();
  if (missing.length > 0) {
    return { ok: false, failure: "MISCONFIGURED", detail: missing.join(", ") };
  }

  const bearer = bearerToken(request.headers);
  if ("failure" in bearer) return { ok: false, failure: bearer.failure };
  const token = bearer.token;

  const supabase = createClient<Database>(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_PUBLISHABLE_KEY!,
    {
      global: { headers: { Authorization: `Bearer ${token}` } },
      auth: { storage: undefined, persistSession: false, autoRefreshToken: false },
    },
  );

  // ⚠️ `getClaims` ne RETOURNE pas toujours son erreur — il peut la LEVER, et c'est la cause
  // racine de #969 (spec de #938). Un JWT malformé fait échouer le décodage base64 AVANT toute
  // vérification : `invalid.invalid.invalid` produit « Invalid UTF-8 sequence », une exception
  // qui traversait ce helper, le middleware, et arrivait BRUTE au client.
  //
  // Conséquence, et elle est vaste : le client ne recevait pas « Unauthorized: Invalid token »
  // mais « Invalid UTF-8 sequence ». `isSessionRefusalError` répondait donc faux, et TOUTE la
  // chaîne posée derrière ce prédicat restait inerte — le forçage de jeton neuf (#931), la fin
  // de session sur refus prouvé (#1009, #1010), la sortie vers la connexion. Aucune n'était
  // fausse ; aucune n'était atteinte. L'élève restait devant « Impossible de charger le
  // dashboard » et son bouton « Réessayer », qui rejouait l'appel qui échoue.
  //
  // Un jeton qu'on ne peut pas DÉCODER est un jeton invalide, au même titre qu'un jeton mal
  // signé : il rejoint la même ligne de la table. La distinction transport/refus est conservée
  // — une panne de réseau levée ici reste `UNAVAILABLE`, exactement comme si elle était rendue.
  let claims: Awaited<ReturnType<typeof supabase.auth.getClaims>>;
  try {
    claims = await supabase.auth.getClaims(token);
  } catch (cause) {
    return {
      ok: false,
      failure: isVerificationUnavailable(cause) ? "UNAVAILABLE" : "INVALID_TOKEN",
      detail: cause instanceof Error ? cause.message : "getClaims a levé une erreur non typée",
    };
  }

  const { data, error } = claims;
  if (error || !data?.claims) {
    return {
      ok: false,
      failure: isVerificationUnavailable(error) ? "UNAVAILABLE" : "INVALID_TOKEN",
      detail: error?.message ?? "no claims",
    };
  }

  if (!data.claims.sub) {
    return { ok: false, failure: "NO_SUBJECT", detail: "no sub" };
  }

  return {
    ok: true,
    supabase,
    userId: data.claims.sub,
    claims: data.claims as unknown as Record<string, unknown>,
  };
}
