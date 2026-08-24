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

/**
 * Pourquoi une requête n'a pas d'identité. Chaque appelant le traduit à sa façon.
 *
 * La granularité n'est pas décorative : le middleware distinguait déjà ces six
 * cas dans ses messages, et les fondre en « pas de jeton » aurait fait perdre au
 * développeur la différence entre « le client n'a pas pu produire de jeton »
 * (rafraîchissement raté — la panne du 2026-08-18) et « le client envoie un
 * schéma d'autorisation qui n'existe pas ». Une extraction doit être à
 * comportement constant, messages compris.
 */
export type AuthFailure =
  /** Aucun en-tête `Authorization` — typiquement un rafraîchissement raté côté client. */
  | "NO_HEADER"
  /** En-tête présent, mais pas `Bearer `. */
  | "BAD_SCHEME"
  /** `Bearer ` suivi de rien. */
  | "EMPTY_TOKEN"
  /** Jeton expiré, malformé, signé par une autre clé — se reconnecter. */
  | "INVALID_TOKEN"
  /** Jeton vérifié, mais sans `sub` : il n'identifie personne. */
  | "NO_SUBJECT"
  /** Le service Auth n'a pas RÉPONDU — réessayer a du sens. */
  | "UNAVAILABLE"
  /** Variables d'environnement manquantes : c'est une panne de déploiement. */
  | "MISCONFIGURED";

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

  const { data, error } = await supabase.auth.getClaims(token);
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
