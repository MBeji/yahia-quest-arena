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
  window.gtag = function gtag(...args: unknown[]) {
    // gtag's contract is "push the argument list as one dataLayer entry"; the
    // library slices each entry, so an array is equivalent to the classic
    // `arguments` object the inline snippet pushes.
    (window.dataLayer as unknown[]).push(args);
  };

  window.gtag("js", new Date());
  window.gtag("config", GA_MEASUREMENT_ID, { send_page_view: false });
}

/**
 * Report a SPA `page_view`. A no-op unless enabled and gtag is present; de-dupes
 * consecutive identical paths (the router can resolve the same location twice).
 */
export function trackPageview(path: string): void {
  if (!isAnalyticsEnabled() || typeof window.gtag !== "function") return;
  if (path === lastTrackedPath) return;
  lastTrackedPath = path;
  window.gtag("event", "page_view", {
    page_path: path,
    page_location: window.location.href,
    page_title: typeof document !== "undefined" ? document.title : undefined,
  });
}
