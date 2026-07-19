/**
 * Google Analytics 4 (gtag.js) — client-only, dependency-free.
 *
 * Loads Google's gtag.js and reports a `page_view` on every SPA navigation.
 * Mirrors the `monitoring.ts` philosophy: no npm dependency (the client bundle
 * has a hard size budget), a no-op unless enabled, and it never throws —
 * analytics must never break a render or a navigation.
 *
 * CSP: the loader is an *external* `<script src>` (governed by the `script-src`
 * host allowlist — googletagmanager.com is allowed there, see `csp.ts`) and every
 * gtag call runs as plain JS, so there is NO inline `<script>` to nonce. The
 * collect beacons go to the google-analytics.com origins allowed in `connect-src`.
 *
 * The Measurement ID comes from `VITE_GA_MEASUREMENT_ID` (inlined into the client
 * bundle at build time), defaulting to the project's production data stream. A
 * GA4 Measurement ID is public by design — it is NOT a secret and ships in the
 * client bundle either way.
 *
 * Enabled only in a production build (`import.meta.env.PROD`) with a non-empty ID,
 * so local dev and the unit run never pollute the analytics stream.
 *
 * Developer-traffic tagging: the `config` call stamps every hit with a
 * `traffic_type` parameter — `developer` on local hosts and Vercel preview
 * deployments (production builds too, e.g. `vite preview`/smoke runs and the
 * per-branch `*.vercel.app` URLs), `production` everywhere else — so a GA4
 * "Internal traffic" data filter on the value `developer` can permanently
 * exclude those sessions from reports (see `resolveTrafficType`).
 */

declare global {
  interface Window {
    dataLayer?: unknown[];
    gtag?: (...args: unknown[]) => void;
  }
}

/** Default GA4 Measurement ID (public) for the production data stream. */
const DEFAULT_MEASUREMENT_ID = "G-H0JRQ7192V";

/** The active GA4 Measurement ID — env override wins, else the project default. */
export const GA_MEASUREMENT_ID = (
  (import.meta.env.VITE_GA_MEASUREMENT_ID as string | undefined) ?? DEFAULT_MEASUREMENT_ID
).trim();

/**
 * Whether analytics should run: a browser, a production build, and a configured
 * Measurement ID. Pure gate — exported for tests and callers.
 */
export function isAnalyticsEnabled(): boolean {
  return typeof window !== "undefined" && import.meta.env.PROD && GA_MEASUREMENT_ID.length > 0;
}

let installed = false;
let lastTrackedPath: string | null = null;

/** GA4 `traffic_type` values this app emits (see `resolveTrafficType`). */
export type TrafficType = "developer" | "production";

/**
 * The Vercel default domain that serves REAL production traffic today — the
 * custom `na9ranal3ab.tn` domain is bought but not wired yet (STATUS.md), so
 * this one hostname must never be tagged `developer`, unlike every other
 * `*.vercel.app` host (per-branch/per-deploy previews).
 */
const PRODUCTION_VERCEL_HOSTNAME = "na9ranal3ab.vercel.app";

/**
 * Classify a hostname for GA4 data filters: `developer` for local hosts
 * (localhost/loopback — covers `vite preview` and smoke runs of the prod
 * bundle) and Vercel preview deployments, `production` for everything else.
 * Suffix match, not `includes`, so a hostname like `vercel.app.example.com`
 * is never mis-tagged. Pure — exported for tests.
 */
export function resolveTrafficType(hostname: string): TrafficType {
  const host = hostname.toLowerCase();
  const isLocalHost =
    host === "localhost" ||
    host === "127.0.0.1" ||
    host === "::1" ||
    host === "[::1]" ||
    host.endsWith(".localhost");
  const isVercelPreview = host.endsWith(".vercel.app") && host !== PRODUCTION_VERCEL_HOSTNAME;
  return isLocalHost || isVercelPreview ? "developer" : "production";
}

/**
 * Build the GA `page_path` from a TanStack Router location: pathname + the RAW
 * search string. `location.search` is the PARSED params object — string-
 * concatenating it throws a TypeError in every browser (it is prototype-less:
 * Safari says "No default value", V8 "Cannot convert object to primitive
 * value"), which is exactly what took production down on 2026-07-01. The
 * strict `string` types here make tsc reject any future object slip.
 */
export function pagePathFromLocation(location: { pathname: string; searchStr: string }): string {
  const { pathname, searchStr } = location;
  return typeof searchStr === "string" && searchStr.length > 0 ? pathname + searchStr : pathname;
}

/**
 * Invoke gtag so that third-party internals can never break the app: once
 * gtag.js loads it REPLACES `dataLayer.push` with its own processor, so every
 * later gtag call executes Google's code synchronously in OUR stack (effects,
 * router subscriptions) — an uncaught throw there would reach the root error
 * boundary and blank the whole page.
 */
function safeGtag(...args: unknown[]): void {
  try {
    window.gtag?.(...args);
  } catch {
    // Analytics failures are always swallowed — never break a render.
  }
}

/**
 * Load gtag.js and initialise the data stream. Idempotent; a no-op unless
 * enabled. The initial `page_view` is suppressed (`send_page_view: false`) so
 * `trackPageview` owns every page_view — the first load and each SPA navigation
 * are counted exactly once.
 */
export function initAnalytics(): void {
  if (installed || !isAnalyticsEnabled()) return;
  installed = true;

  const loader = document.createElement("script");
  loader.async = true;
  loader.src = `https://www.googletagmanager.com/gtag/js?id=${encodeURIComponent(GA_MEASUREMENT_ID)}`;
  document.head.appendChild(loader);

  window.dataLayer = window.dataLayer ?? [];
  // The canonical shim: push the exotic `arguments` object, NOT a rest-param
  // array. gtag.js tells its commands apart from ordinary dataLayer messages
  // by that exact shape — with plain arrays it mis-processes the queue and,
  // once its own `dataLayer.push` processor is installed, throws synchronously
  // inside the caller's stack (prod incident 2026-07-01: "No default value"
  // surfaced by the root error boundary). Keep this shape-identical to
  // Google's official snippet.
  window.gtag = function gtag() {
    // eslint-disable-next-line prefer-rest-params -- gtag.js requires the `arguments` object (see above)
    (window.dataLayer as unknown[]).push(arguments);
  };

  safeGtag("js", new Date());
  // `traffic_type` set on the config command applies to every event of the
  // stream — the GA4 "Internal traffic" data filter matches on its value.
  safeGtag("config", GA_MEASUREMENT_ID, {
    send_page_view: false,
    traffic_type: resolveTrafficType(window.location.hostname),
  });
}

/**
 * Report a SPA `page_view`. A no-op unless enabled and gtag is present; de-dupes
 * consecutive identical paths (the router can resolve the same location twice).
 */
export function trackPageview(path: string): void {
  if (!isAnalyticsEnabled() || typeof window.gtag !== "function") return;
  if (path === lastTrackedPath) return;
  lastTrackedPath = path;
  safeGtag("event", "page_view", {
    page_path: path,
    page_location: window.location.href,
    page_title: typeof document !== "undefined" ? document.title : undefined,
  });
}

/** Where a curated explainer video was opened (étude 23 observability). */
export type VideoOpenContext = "lesson" | "result";

/**
 * Report a curated-video play (étude 23 R-13): the single product metric of the
 * feature — real usage before extending the curation campaign. No-op unless
 * analytics is enabled and gtag is present; never throws. Fired when the facade
 * is clicked and the iframe is mounted (never before — no third-party request
 * happens until this point, R-4).
 */
export function trackVideoOpen(params: {
  videoId: string;
  context: VideoOpenContext;
  subjectId: string;
}): void {
  if (!isAnalyticsEnabled() || typeof window.gtag !== "function") return;
  safeGtag("event", "video_open", {
    video_id: params.videoId,
    context: params.context,
    subject_id: params.subjectId,
  });
}
