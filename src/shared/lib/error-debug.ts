/**
 * Build the optional `?debug=1` diagnostic text for the root error boundary.
 *
 * The error identity (`name: message`) is already surfaced to the visitor by the
 * boundary and is client-safe. The **stack trace** exposes internal module
 * structure, so it is withheld in production: an anonymous visitor never receives
 * a stack, while mobile forensics keep the error name + message. Outside
 * production the full stack is included for local diagnosis.
 */
export function buildErrorDebugText(
  error: { name?: string; message?: string; stack?: string },
  isProduction: boolean,
): string {
  const identity = `${error.name ?? "Error"}: ${error.message ?? ""}`;
  if (isProduction) return identity;
  return `${identity}\n${error.stack ?? "(no stack)"}`;
}
