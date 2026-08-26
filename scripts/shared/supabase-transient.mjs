/**
 * What counts as a TRANSIENT Supabase failure for the scheduled report jobs, and
 * how many times it is worth trying again.
 *
 * Why this exists — the evidence, not a hunch. On 2026-08-26 four scheduled runs
 * died on the same upstream message, on an arbre that had not moved and with a
 * service-role secret last rotated a month earlier (2026-07-27):
 *
 *   report-triage  02:03  `[reports] Failed to read bug_reports: JWT issued at future`
 *   report-triage  05:00  `[reports] Failed to read content_reports: JWT issued at future`
 *   report-apply   07:29  `[reports] Failed to read bug_reports: JWT issued at future`
 *   report-triage  09:06  `[reports] Failed to read bug_reports: JWT issued at future`
 *                  13:29  green again, with no change on either side
 *
 * `JWT issued at future` is the provider refusing a token whose `iat` is ahead of
 * ITS clock. Nothing in this repo can issue that token differently, and no PR can
 * repair it — it is the "entrée hors dépôt" case of `docs/agents/zero-intervention.md`.
 * Two things ARE ours, and this module is both:
 *
 *   1. a short blip must not cost a red cron and a guard issue — hence the retry;
 *   2. a long outage must be readable in one glance instead of re-investigated from
 *      scratch by the next session — hence `transientHint()`, which names the cause
 *      in the failure message rather than leaving a bare provider string.
 *
 * Deliberately NOT retried: permission, RLS, schema and validation errors. Those
 * are OUR bugs, and retrying them only delays the red by a few seconds.
 */

/**
 * Upstream conditions that a second attempt can plausibly clear: clock skew on
 * the auth path, and the ordinary transport failures of a cross-internet call.
 * Kept as an explicit allow-list — anything unlisted fails on the first try.
 */
export const TRANSIENT_PATTERNS = [
  /JWT issued at future/i,
  /fetch failed/i,
  /socket hang up/i,
  /ECONNRESET/i,
  /ETIMEDOUT/i,
  /EAI_AGAIN/i,
  /\b(?:502|503|504)\b/,
  /Gateway ?Time-?out/i,
  /Service Unavailable/i,
];

/** True when `message` names a condition worth one more attempt. */
export function isTransient(message) {
  if (!message) return false;
  const text = typeof message === "string" ? message : String(message?.message ?? message);
  return TRANSIENT_PATTERNS.some((re) => re.test(text));
}

/**
 * The sentence appended to a transient failure that survived every attempt, so
 * the run's log carries its own diagnosis. Empty for anything else — a real bug
 * must not be dressed up as someone else's outage.
 */
export function transientHint(message) {
  if (!isTransient(message)) return "";
  return (
    " — condition transitoire côté fournisseur, encore là après plusieurs essais. " +
    "Aucune PR ne la répare : voir docs/agents/gardes.md § « JWT issued at future »."
  );
}

/** Attempt delays in ms. Three retries, ~14 s total — enough for a blip, not for an outage. */
export const RETRY_DELAYS_MS = [1_000, 3_000, 10_000];

const wait = (ms) => new Promise((r) => setTimeout(r, ms));

/**
 * Runs a Supabase query, retrying only while it fails transiently.
 *
 * `run` must resolve to supabase-js's `{ data, error }` shape; the result of the
 * LAST attempt is returned as-is, so callers keep their existing error handling
 * and simply see fewer transient reds.
 *
 * @template T
 * @param {() => Promise<{ data: T, error: { message: string } | null }>} run
 * @param {object} [options]
 * @param {string} [options.label] what is being read/written, for the log line
 * @param {(msg: string) => void} [options.onRetry] defaults to stderr
 * @param {number[]} [options.delays] injectable so tests do not sleep
 * @param {(ms: number) => Promise<void>} [options.sleep] injectable clock
 */
export async function withTransientRetry(run, options = {}) {
  const {
    label = "query",
    onRetry = (msg) => console.error(msg),
    delays = RETRY_DELAYS_MS,
    sleep = wait,
  } = options;

  let result = await run();
  for (let attempt = 0; attempt < delays.length; attempt += 1) {
    if (!result?.error || !isTransient(result.error.message)) return result;
    onRetry(
      `[reports] ${label}: ${result.error.message} — nouvel essai ${attempt + 1}/${delays.length} dans ${delays[attempt]} ms`,
    );
    await sleep(delays[attempt]);
    result = await run();
  }
  return result;
}
