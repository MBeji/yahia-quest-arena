import { logger } from "./logger";

/** Log the underlying error, then throw a safe client-facing Error. */
export function failWithClientError(context: string, error: unknown, clientMessage: string): never {
  logger.error(context, {
    error: error instanceof Error ? error.message : String(error),
  });
  throw new Error(clientMessage);
}
