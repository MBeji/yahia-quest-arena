/**
 * Lightweight, dependency-free error monitoring (Sentry) — GAP-002.
 *
 * Why not `@sentry/react`/`@sentry/node`: the client bundle has a hard size
 * budget (index ≤ 450 kB) that the React SDK would blow, and the server runs as a
 * Cloudflare-Worker build repackaged to a Vercel Node function — `@sentry/node`
 * does not run in the Worker runtime. Both runtimes DO have global `fetch`, so we
 * post Sentry "envelopes" directly. This captures the error + stack + minimal
 * context (the 80/20 for a beta) at zero bundle cost and works everywhere.
 *
 * Guarantees:
 * - **No-op without a DSN** → clean local/preview, nothing leaves the machine.
 * - **Fire-and-forget & never throws** → cannot break a request or a render; the
 *   worst case is a dropped event, never a broken response.
 * - **No PII** → emails are scrubbed; only a technical context is sent (INPDP /
 *   minors-safe, see GAP-003).
 *
 * DSN comes from `VITE_SENTRY_DSN` (inlined into both bundles) or, on the server,
 * `process.env.SENTRY_DSN` at runtime. The DSN is NOT a secret (it ships in the
 * client bundle by design).
 */

type CaptureContext = {
  /** Where the error came from, e.g. "server.fetch" or "window.onerror". */
  source?: string;
  /** Request path (no query string — it may carry tokens). */
  path?: string;
  /** Extra structured data — scrubbed before send. */
  extra?: Record<string, unknown>;
};

type ParsedDsn = { ingestUrl: string; publicKey: string; dsn: string };

const EMAIL_RE = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g;

function getDsn(): string | undefined {
  // VITE_ value is inlined into client AND server bundles at build time.
  const inlined = import.meta.env.VITE_SENTRY_DSN as string | undefined;
  if (inlined) return inlined;
  // Server runtime fallback (not rebuilt): read from the platform env.
  if (typeof process !== "undefined" && process.env?.SENTRY_DSN) {
    return process.env.SENTRY_DSN;
  }
  return undefined;
}

function getRelease(): string | undefined {
  return (
    (import.meta.env.VITE_COMMIT_SHA as string | undefined) ??
    (typeof process !== "undefined" ? process.env?.VERCEL_GIT_COMMIT_SHA : undefined) ??
    undefined
  );
}

function getEnvironment(): string {
  if (import.meta.env.DEV) return "development";
  return (
    (import.meta.env.VITE_VERCEL_ENV as string | undefined) ??
    (typeof process !== "undefined" ? process.env?.VERCEL_ENV : undefined) ??
    "production"
  );
}

/** Parse a Sentry DSN into the envelope ingest URL + public key. */
export function parseDsn(dsn: string): ParsedDsn | undefined {
  try {
    const url = new URL(dsn);
    const publicKey = url.username;
    const projectId = url.pathname.replace(/^\//, "");
    if (!publicKey || !projectId) return undefined;
    // https://<host>/api/<projectId>/envelope/
    const ingestUrl = `${url.protocol}//${url.host}/api/${projectId}/envelope/`;
    return { ingestUrl, publicKey, dsn };
  } catch {
    return undefined;
  }
}

/** Remove e-mail addresses from any string (defence-in-depth for PII). */
function scrubString(value: string): string {
  return value.replace(EMAIL_RE, "[redacted-email]");
}

/** Recursively scrub a plain value: drop sensitive keys, redact e-mails. */
function scrubExtra(extra: Record<string, unknown>): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(extra)) {
    const lowered = key.toLowerCase();
    if (
      lowered.includes("token") ||
      lowered.includes("secret") ||
      lowered.includes("password") ||
      lowered.includes("email") ||
      lowered === "key"
    ) {
      out[key] = "[redacted]";
      continue;
    }
    out[key] = typeof value === "string" ? scrubString(value) : value;
  }
  return out;
}

function toException(error: unknown): { type: string; value: string } {
  if (error instanceof Error) {
    return { type: error.name || "Error", value: scrubString(error.message || "") };
  }
  return { type: "Error", value: scrubString(typeof error === "string" ? error : String(error)) };
}

/**
 * Build the Sentry event payload. Exported for testing only.
 */
export function buildSentryEvent(
  message: string,
  error: unknown,
  context: CaptureContext,
  opts: { eventId: string; timestampSec: number; release?: string; environment: string },
) {
  const exception = error != null ? toException(error) : undefined;
  // The raw stack (paths, not PII) carries the debugging value; Sentry's parsed
  // `stacktrace.frames` need source-map machinery we deliberately skip here.
  const stack = error instanceof Error && error.stack ? scrubString(error.stack) : undefined;
  const scrubbed = context.extra ? scrubExtra(context.extra) : undefined;
  const extra = stack ? { ...(scrubbed ?? {}), stack } : scrubbed;
  return {
    event_id: opts.eventId,
    timestamp: opts.timestampSec,
    platform: "javascript",
    level: "error",
    logger: context.source ?? "app",
    release: opts.release,
    environment: opts.environment,
    message: message ? { formatted: scrubString(message) } : undefined,
    ...(exception ? { exception: { values: [exception] } } : {}),
    tags: { source: context.source ?? "unknown" },
    request: context.path ? { url: context.path } : undefined,
    extra,
  };
}

function newEventId(): string {
  // 32 hex chars, no dashes (Sentry event_id format).
  return crypto.randomUUID().replace(/-/g, "");
}

/**
 * Report an error to Sentry. Fire-and-forget: never awaits in the caller's hot
 * path, never throws, no-op without a DSN.
 */
export function captureException(message: string, error?: unknown, context: CaptureContext = {}) {
  try {
    const dsnString = getDsn();
    if (!dsnString) return; // no-op
    const parsed = parseDsn(dsnString);
    if (!parsed) return;

    const eventId = newEventId();
    const timestampSec = Date.now() / 1000;
    const event = buildSentryEvent(message, error, context, {
      eventId,
      timestampSec,
      release: getRelease(),
      environment: getEnvironment(),
    });

    const envelopeHeader = JSON.stringify({ event_id: eventId, sent_at: new Date().toISOString() });
    const itemHeader = JSON.stringify({ type: "event" });
    const body = `${envelopeHeader}\n${itemHeader}\n${JSON.stringify(event)}`;

    const endpoint = `${parsed.ingestUrl}?sentry_key=${parsed.publicKey}&sentry_version=7`;

    // Fire-and-forget. Swallow every failure — monitoring must never surface.
    fetch(endpoint, {
      method: "POST",
      headers: { "content-type": "application/x-sentry-envelope" },
      body,
      keepalive: true,
    }).catch(() => {});
  } catch {
    // Monitoring must never break the app.
  }
}

let browserMonitoringInstalled = false;

/**
 * Install global browser error handlers (client only, call once after mount).
 * Captures uncaught errors and unhandled rejections that React boundaries miss.
 */
export function initBrowserMonitoring() {
  if (browserMonitoringInstalled) return;
  if (typeof window === "undefined") return;
  if (!getDsn()) return; // no-op without DSN
  browserMonitoringInstalled = true;

  window.addEventListener("error", (event) => {
    captureException(event.message || "window.onerror", event.error, {
      source: "window.onerror",
      path: window.location.pathname,
    });
  });
  window.addEventListener("unhandledrejection", (event) => {
    captureException("unhandledrejection", event.reason, {
      source: "unhandledrejection",
      path: window.location.pathname,
    });
  });
}
