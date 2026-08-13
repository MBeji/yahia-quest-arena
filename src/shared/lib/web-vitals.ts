/**
 * Dependency-free Real User Monitoring — finding M-1 of docs/performance-audit.md.
 *
 * The audit's standing complaint was that the team can see 500s but is blind to
 * p95 growth: `monitoring.ts` captures ERRORS only, and nothing measures what a
 * real student's browser actually experiences. This closes the client half of
 * that gap.
 *
 * Why not the `web-vitals` package: same reason `monitoring.ts` hand-rolls
 * Sentry envelopes — the index chunk has a hard 450 kB budget and every
 * kilobyte here is on the critical path. `PerformanceObserver` gives us the
 * numbers directly.
 *
 * What it reports, once per page view, as the `web_vitals` product event:
 * - **LCP** largest contentful paint (ms) — loading
 * - **CLS** cumulative layout shift (unitless) — visual stability
 * - **INP** interaction to next paint (ms) — responsiveness
 * - **FCP** first contentful paint (ms), **TTFB** time to first byte (ms)
 *
 * Guarantees, matching `monitoring.ts`:
 * - **Never throws** — every entry point is wrapped; the worst case is no metric.
 * - **No-op where unsupported** (SSR, old browsers, no PerformanceObserver).
 * - **No PII** — timings and a coarse route path only.
 * - **Sent once**, on the first terminal signal (`visibilitychange` → hidden, or
 *   `pagehide`). A bfcache restore does not re-arm it: the numbers would describe
 *   a page load that did not happen.
 */
import { captureProductEvent } from "@/shared/lib/product-analytics";

/** Google's "good" thresholds — kept here so a dashboard needs no extra logic. */
const GOOD = { lcp: 2500, cls: 0.1, inp: 200, fcp: 1800, ttfb: 800 } as const;
/** Upper bound of "needs improvement"; above it is "poor". */
const POOR = { lcp: 4000, cls: 0.25, inp: 500, fcp: 3000, ttfb: 1800 } as const;

type MetricName = keyof typeof GOOD;

function rate(name: MetricName, value: number): "good" | "needs-improvement" | "poor" {
  if (value <= GOOD[name]) return "good";
  if (value <= POOR[name]) return "needs-improvement";
  return "poor";
}

const metrics: Partial<Record<MetricName, number>> = {};
let sent = false;
let started = false;

/** `PerformanceObserver` throws on entry types a browser does not know. */
function observe(type: string, cb: (entries: PerformanceEntry[]) => void): void {
  try {
    const po = new PerformanceObserver((list) => {
      try {
        cb(list.getEntries());
      } catch {
        /* a bad entry must never break the page */
      }
    });
    // `buffered` replays entries that fired before this code ran — without it
    // LCP/FCP are routinely missed, since they happen during hydration.
    po.observe({ type, buffered: true } as PerformanceObserverInit);
  } catch {
    /* unsupported entry type — that metric is simply absent */
  }
}

/**
 * CLS is NOT the plain sum of every shift: it is the largest *session window*,
 * where a window ends after a 1 s gap or 5 s of total duration. Summing instead
 * would systematically over-report long-lived pages — and a metric that reads
 * worse than reality gets ignored, which is the same as not having it.
 */
function trackCls(): void {
  let current = 0;
  let firstTs = 0;
  let lastTs = 0;

  observe("layout-shift", (entries) => {
    for (const entry of entries) {
      const shift = entry as PerformanceEntry & { value: number; hadRecentInput: boolean };
      // Shifts within 500 ms of a user interaction are expected, not a defect.
      if (shift.hadRecentInput) continue;

      if (current && (entry.startTime - lastTs > 1000 || entry.startTime - firstTs > 5000)) {
        current = 0;
      }
      if (current === 0) firstTs = entry.startTime;
      lastTs = entry.startTime;
      current += shift.value;

      metrics.cls = Math.max(metrics.cls ?? 0, current);
    }
  });
}

function trackInp(): void {
  observe("event", (entries) => {
    for (const entry of entries) {
      const ev = entry as PerformanceEntry & { duration: number; interactionId?: number };
      // Only real interactions carry an interactionId; ignore the rest.
      if (!ev.interactionId) continue;
      metrics.inp = Math.max(metrics.inp ?? 0, ev.duration);
    }
  });
}

function readNavigationTimings(): void {
  try {
    const nav = performance.getEntriesByType("navigation")[0] as
      PerformanceNavigationTiming | undefined;
    if (nav && nav.responseStart > 0) metrics.ttfb = nav.responseStart;
  } catch {
    /* navigation timing unavailable */
  }
}

/** Build the payload; exported for tests so they need no browser. */
export function buildVitalsPayload(
  values: Partial<Record<MetricName, number>>,
  path: string,
): Record<string, unknown> | null {
  const payload: Record<string, unknown> = { path };
  let any = false;

  for (const name of Object.keys(GOOD) as MetricName[]) {
    const value = values[name];
    if (value === undefined || !Number.isFinite(value)) continue;
    any = true;
    // CLS is unitless and small; the others are milliseconds and only useful whole.
    payload[name] = name === "cls" ? Math.round(value * 1000) / 1000 : Math.round(value);
    payload[`${name}_rating`] = rate(name, value);
  }

  // Nothing measured (very short visit, or an unsupported browser) → send nothing
  // rather than a row of nulls that would drag every dashboard average around.
  return any ? payload : null;
}

function flush(): void {
  if (sent) return;
  sent = true;
  try {
    readNavigationTimings();
    const payload = buildVitalsPayload(metrics, window.location.pathname);
    if (payload) captureProductEvent("web_vitals", payload);
  } catch {
    /* never let telemetry break a page teardown */
  }
}

/**
 * Start collecting. Safe to call more than once — only the first call arms it.
 * Call from the root once the app is mounted, next to `initAnalytics()`.
 */
export function initWebVitals(): void {
  try {
    if (started) return;
    if (typeof window === "undefined" || typeof PerformanceObserver === "undefined") return;
    started = true;

    observe("largest-contentful-paint", (entries) => {
      // The LAST entry wins: LCP is revised upward as bigger elements paint.
      const last = entries[entries.length - 1];
      if (last) metrics.lcp = last.startTime;
    });

    observe("paint", (entries) => {
      for (const entry of entries) {
        if (entry.name === "first-contentful-paint") metrics.fcp = entry.startTime;
      }
    });

    trackCls();
    trackInp();

    // `visibilitychange` is the reliable terminal signal on mobile, where
    // `beforeunload`/`unload` are routinely skipped; `pagehide` covers the rest.
    document.addEventListener(
      "visibilitychange",
      () => {
        if (document.visibilityState === "hidden") flush();
      },
      { capture: true },
    );
    window.addEventListener("pagehide", flush, { capture: true });
  } catch {
    /* RUM must never break startup */
  }
}

/** Test-only: clear module state between cases. */
export function __resetWebVitalsForTests(): void {
  for (const key of Object.keys(metrics) as MetricName[]) delete metrics[key];
  sent = false;
  started = false;
}
