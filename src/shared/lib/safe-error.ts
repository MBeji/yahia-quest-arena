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
export function failWithClientError(context: string, error: unknown, clientMessage: string): never {
  logger.error(context, { error: errorMessage(error) });
  throw new Error(clientMessage);
}
