import { captureException } from "./monitoring";
import { redactDeep, redactSecrets } from "./redact";

type LogLevel = "info" | "warn" | "error";

type LogMeta = Record<string, unknown>;

function safeMeta(meta?: LogMeta): LogMeta | undefined {
  if (!meta) return undefined;
  // Clés sensibles ET valeurs en forme de secret, à toute profondeur (`redact.ts`).
  return redactDeep(meta) as LogMeta;
}

/** Une pile au-delà de cette taille n'apprend plus rien et noie la ligne. */
const MAX_STACK_CHARS = 4000;

/**
 * Une `Error` n'a aucune propriété énumérable : `JSON.stringify` la rend `{}`.
 * Sans cette mise à plat, `logger.error("…", { error })` — la convention de tout
 * le serveur — écrivait `"error":{}` : ni message ni pile dans la ligne, et le
 * diagnostic d'un 500 ne tenait plus qu'à Sentry, qui est éteint sans DSN.
 *
 * Un niveau de `cause` seulement : c'est là que vit l'erreur d'origine quand on
 * l'enveloppe, et une chaîne plus longue n'a jamais été observée ici.
 */
function serializeError(error: Error, withCause = true): Record<string, unknown> {
  const out: Record<string, unknown> = { name: error.name, message: error.message };
  if (error.stack) out.stack = error.stack.slice(0, MAX_STACK_CHARS);
  if (withCause && error.cause instanceof Error) out.cause = serializeError(error.cause, false);
  return out;
}

/** Les valeurs de premier niveau seulement — là où la convention pose l'erreur. */
function serializable(meta?: LogMeta): LogMeta | undefined {
  if (!meta) return undefined;
  const out: LogMeta = {};
  for (const [key, value] of Object.entries(meta)) {
    out[key] = value instanceof Error ? serializeError(value) : value;
  }
  return out;
}

function write(level: LogLevel, message: string, meta?: LogMeta) {
  const payload = {
    ts: new Date().toISOString(),
    level,
    message: redactSecrets(message),
    // L'erreur est mise à plat D'ABORD (message, pile, cause), la rédaction en
    // profondeur passe ENSUITE : une clé sensible reste masquée, et un secret
    // recopié dans un message ou une pile l'est aussi.
    ...safeMeta(serializable(meta)),
  };

  const line = JSON.stringify(payload);
  if (level === "error") {
    console.error(line);
    // Forward to Sentry (no-op without a DSN). The Error object, if any, is
    // conventionally passed as meta.error; the rest becomes scrubbed context.
    const { error, ...rest } = (meta ?? {}) as { error?: unknown } & LogMeta;
    captureException(message, error, { source: "logger", extra: safeMeta(rest) });
    return;
  }

  if (level === "warn") {
    console.warn(line);
    return;
  }

  console.info(line);
}

export const logger = {
  info: (message: string, meta?: LogMeta) => write("info", message, meta),
  warn: (message: string, meta?: LogMeta) => write("warn", message, meta),
  error: (message: string, meta?: LogMeta) => write("error", message, meta),
};
