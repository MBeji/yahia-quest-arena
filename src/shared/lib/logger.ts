import { captureException } from "./monitoring";
import { redactDeep, redactSecrets } from "./redact";

type LogLevel = "info" | "warn" | "error";

type LogMeta = Record<string, unknown>;

function safeMeta(meta?: LogMeta): LogMeta | undefined {
  if (!meta) return undefined;
  // Clés sensibles ET valeurs en forme de secret, à toute profondeur (`redact.ts`).
  return redactDeep(meta) as LogMeta;
}

function write(level: LogLevel, message: string, meta?: LogMeta) {
  const payload = {
    ts: new Date().toISOString(),
    level,
    message: redactSecrets(message),
    ...safeMeta(meta),
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
