import { logger } from "./logger";

/**
 * Extract a human-useful string from an unknown thrown value. Handles `Error`,
 * strings, and plain objects carrying a string `message` (e.g. a Supabase
 * `PostgrestError`, which is NOT an `Error` instance) — falling back to JSON so a
 * plain object never degrades to the useless `String(obj)` = "[object Object]".
 */
export function errorMessage(error: unknown): string {
  if (error instanceof Error) return error.message;
  if (typeof error === "string") return error;
  if (
    error &&
    typeof error === "object" &&
    "message" in error &&
    typeof (error as { message: unknown }).message === "string"
  ) {
    return (error as { message: string }).message;
  }
  try {
    return JSON.stringify(error) ?? String(error);
  } catch {
    return String(error);
  }
}

/** Log the underlying error, then throw a safe client-facing Error. */
/** Le message d'un refus de cadence — le même partout, pour que l'élève le reconnaisse. */
export const RATE_LIMITED_FR = "Trop de requêtes. Réessaie dans un instant.";

/**
 * L'erreur vient-elle de la borne durable des RPC (`enforce_rpc_rate_limit`,
 * audit S-1) ? Elle lève `SQLSTATE PT429`, message `RATE_LIMITED`, que PostgREST
 * rend en HTTP 429.
 */
export function isRateLimitedError(error: unknown): boolean {
  if (!error || typeof error !== "object") return false;
  const { code, message } = error as { code?: unknown; message?: unknown };
  return code === "PT429" || message === "RATE_LIMITED";
}

export function failWithClientError(context: string, error: unknown, clientMessage: string): never {
  // Un refus de cadence n'est ni une panne ni une erreur générique : l'appelant
  // doit lire « trop de requêtes », et le journal ne doit pas le compter comme
  // une erreur serveur.
  if (isRateLimitedError(error)) {
    logger.warn(`${context}: rate limited`);
    throw new Error(RATE_LIMITED_FR);
  }
  logger.error(context, { error: errorMessage(error) });
  throw new Error(clientMessage);
}
