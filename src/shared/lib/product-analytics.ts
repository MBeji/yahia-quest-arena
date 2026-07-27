/**
 * PostHog product analytics — client-only, dependency-free (GAP-008).
 *
 * GA4 (`analytics.ts`) answers "how much traffic, from where" — acquisition and
 * SEO. It cannot answer the questions this phase actually needs: does a visitor
 * who lands on a chapter reach a corrected exercise, and does a signed-up
 * student come back next week. That is what PostHog is here for (funnels,
 * retention, per-cohort paths).
 *
 * Why no `posthog-js`: the SDK costs ~60 kB and the client index bundle sits at
 * ~437 kB against a hard 450 kB budget (`scripts/check-bundle-budget.mjs`). We
 * therefore POST capture payloads straight to the ingest endpoint, exactly like
 * `monitoring.ts` posts Sentry envelopes. What we give up is autocapture,
 * heatmaps and **session replay** — the last one deliberately: recording the
 * screens of minors is a data-protection decision (GAP-003/INPDP), not a
 * toggle, and it would need the privacy policy that does not exist yet.
 *
 * Guarantees, same as `monitoring.ts`:
 * - **No-op without a key** → local dev, previews of forks and the unit run send
 *   nothing.
 * - **Production builds only** (`import.meta.env.PROD`).
 * - **Fire-and-forget & never throws** → a broken analytics call must never cost
 *   a render or a navigation.
 * - **No PII** → no e-mail, no name, no Supabase user id. The `distinct_id` is a
 *   random first-party identifier, and every event is sent with
 *   `$process_person_profile: false` (the wire equivalent of the snippet's
 *   `person_profiles: 'identified_only'`): PostHog counts the event without
 *   building a person profile.
 *
 * The project key comes from `VITE_POSTHOG_KEY`, inlined at build time. A
 * PostHog **project** key is public by design — it only allows writing events —
 * but it is kept out of the repo so that no build ships it by accident and so
 * that rotating it is a Vercel change, not a code change.
 */

/** EU ingest origin (data residency: the app serves Tunisian minors). */
export const POSTHOG_DEFAULT_HOST = "https://eu.i.posthog.com";

/** Ingest host — env override wins, else the EU default. Also allow-listed in `csp.ts`. */
export const POSTHOG_HOST = (
  (import.meta.env.VITE_POSTHOG_HOST as string | undefined) ?? POSTHOG_DEFAULT_HOST
).trim();

/** Project key (public, write-only). Empty = the whole module is inert. */
export const POSTHOG_KEY = ((import.meta.env.VITE_POSTHOG_KEY as string | undefined) ?? "").trim();

/** localStorage key holding the anonymous, first-party visitor id. */
const DISTINCT_ID_STORAGE_KEY = "na9ra.ph_did";

/**
 * Whether product analytics should run: a browser, a production build, and a
 * configured project key. Pure gate — exported for tests and callers.
 */
export function isProductAnalyticsEnabled(): boolean {
  return typeof window !== "undefined" && import.meta.env.PROD && POSTHOG_KEY.length > 0;
}

/** In-memory fallback when localStorage is unavailable (private mode, quota, iOS lockdown). */
let memoryDistinctId: string | undefined;

/**
 * Stable anonymous id for this browser. Random UUID, first-party, never derived
 * from anything about the person — it is a counter key, not an identity.
 * Falls back to a per-session in-memory id when storage throws.
 */
export function getDistinctId(): string {
  try {
    const stored = window.localStorage.getItem(DISTINCT_ID_STORAGE_KEY);
    if (stored) return stored;
    const fresh = crypto.randomUUID();
    window.localStorage.setItem(DISTINCT_ID_STORAGE_KEY, fresh);
    return fresh;
  } catch {
    memoryDistinctId ??= crypto.randomUUID();
    return memoryDistinctId;
  }
}

/**
 * Build the capture payload for PostHog's ingest endpoint. Pure — exported for
 * tests. `$process_person_profile: false` keeps the event anonymous (no person
 * profile is created), which is what we want for a public, mostly-anonymous
 * audience of children.
 */
export function buildCaptureBody(params: {
  event: string;
  distinctId: string;
  key: string;
  timestampIso: string;
  properties?: Record<string, unknown>;
}): Record<string, unknown> {
  return {
    api_key: params.key,
    event: params.event,
    distinct_id: params.distinctId,
    timestamp: params.timestampIso,
    properties: {
      ...(params.properties ?? {}),
      $process_person_profile: false,
    },
  };
}

/**
 * Send one event. A no-op unless enabled; swallows every failure. Callers pass
 * only technical properties (content ids, scopes) — never user-supplied text.
 */
export function captureProductEvent(event: string, properties?: Record<string, unknown>): void {
  try {
    if (!isProductAnalyticsEnabled()) return;

    const body = buildCaptureBody({
      event,
      distinctId: getDistinctId(),
      key: POSTHOG_KEY,
      timestampIso: new Date().toISOString(),
      properties,
    });

    // Fire-and-forget. `keepalive` lets the last event of a page survive the
    // navigation that triggered it.
    fetch(`${POSTHOG_HOST}/i/v0/e/`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify(body),
      keepalive: true,
    }).catch(() => {});
  } catch {
    // Analytics must never surface.
  }
}

let lastCapturedPath: string | null = null;

/**
 * Report a `$pageview`. De-dupes consecutive identical paths on its own state
 * (the router can resolve the same location twice) so it stays correct whatever
 * the GA4 integration does — the two sinks share a call site, not a guard.
 *
 * `traffic_type` mirrors GA4's tag (see `resolveTrafficType`): PostHog has no
 * built-in internal-traffic filter, so the property is what lets a report
 * exclude preview and local sessions.
 */
export function capturePageview(path: string, trafficType: string): void {
  if (!isProductAnalyticsEnabled()) return;
  if (path === lastCapturedPath) return;
  lastCapturedPath = path;
  captureProductEvent("$pageview", {
    $current_url: window.location.href,
    $pathname: path,
    $host: window.location.hostname,
    traffic_type: trafficType,
  });
}
