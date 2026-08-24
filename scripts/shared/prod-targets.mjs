/**
 * What "production" looks like — the single source of truth for every guard.
 *
 * Guard-free on purpose (same rule as `db-url.mjs`): this module only *describes*
 * production, it never refuses anything. That lets both directions import it —
 * the tools that must NEVER touch prod (e2e, load tests, gameplay reset) and the
 * one that must ONLY touch prod (`db/push-prod.mjs`) — without either pulling in
 * the other's safety net.
 *
 * Why it exists: the prod project ref used to be copy-pasted in six places, each
 * carrying a "keep in sync" comment. That is a hand-maintained invariant, and it
 * drifted exactly the way you would expect — see #614, where the e2e suite wrote
 * a `content_reports` row into PRODUCTION because the guard checked the Supabase
 * URLs but not the base URL the browser was actually pointed at.
 *
 * TWO ways to reach production, and a guard needs both:
 *   1. the Supabase project directly (`SUPABASE_URL`, service-role writes)
 *   2. the deployed APP (`PLAYWRIGHT_BASE_URL`) — its SSR layer runs with its own
 *      prod secrets, so hitting it writes to prod no matter how clean the local
 *      Supabase env is. This is the vector that #614 took.
 */

/** The production Supabase project ref. Appears in every prod Supabase URL. */
export const PROD_SUPABASE_REF = "fasrenmmrkqjoobrztbp";

/**
 * The production Supabase API URL. Derived, never typed twice.
 *
 * It is NOT a secret — it is the `VITE_SUPABASE_URL` every browser receives in
 * the client bundle — and treating it as one cost 25 days of user-report triage
 * (2026-07-29 → 2026-08-23). The `PROD_SUPABASE_URL` GitHub secret was pasted
 * without its scheme; it cleared `prodTargetReason` (which matches the ref as a
 * substring), then died inside `createClient` on every scheduled run. Nothing in
 * the repository could fix it, because the broken value lived outside the
 * repository.
 *
 * So the report workflows now resolve the URL from HERE instead of from that
 * secret. Only the service-role key stays a secret, because only it is one.
 * A value that is derived cannot drift, and a workflow whose inputs all live in
 * the repo is one a reviewed PR can repair — which is the whole point.
 */
export const PROD_SUPABASE_API_URL = `https://${PROD_SUPABASE_REF}.supabase.co`;

/**
 * Hosts that serve the PRODUCTION app. Matched on the exact host, never as a
 * substring: Vercel preview deployments (`na9ranal3ab-<hash>.vercel.app`) are
 * legitimate e2e targets and must keep passing.
 *
 * All three entries reach production. The official domain is the `.tn`:
 * `www.na9ranal3ab.tn` is canonical and the only host that answers 200, the apex
 * 308s to it, and `na9ranal3ab.vercel.app` 301s to it — a temporary courtesy for
 * whoever bookmarked the Vercel URL, meant to be cut.
 *
 * That last entry stays listed until it actually is, and not out of nostalgia:
 * the 301 preserves the path on every route (sondé 2026-08-19), so any client
 * that follows redirects — Playwright does — lands on PRODUCTION. Dropping it
 * while the redirect lives re-opens #614 through the door #614 came in. The day
 * the alias is cut, this entry goes with it.
 */
export const PROD_APP_HOSTS = ["na9ranal3ab.vercel.app", "na9ranal3ab.tn", "www.na9ranal3ab.tn"];

/** Host of a URL, lowercased and port-stripped; accepts a bare host too. */
function hostOf(value) {
  const trimmed = value.trim();
  const withScheme = /^[a-z][a-z0-9+.-]*:\/\//i.test(trimmed) ? trimmed : `https://${trimmed}`;
  try {
    return new URL(withScheme).hostname.toLowerCase();
  } catch {
    return null;
  }
}

/**
 * Does this value point at production? Returns the reason, or `null`.
 * @param {string | undefined | null} value a URL, or a bare host
 * @returns {"supabase" | "app" | null}
 */
export function prodTargetReason(value) {
  if (!value || typeof value !== "string") return null;
  if (value.includes(PROD_SUPABASE_REF)) return "supabase";
  const host = hostOf(value);
  return host && PROD_APP_HOSTS.includes(host) ? "app" : null;
}

/**
 * First value that points at production, with its reason — or `null` if none do.
 * @param {Array<string | undefined | null>} values
 * @returns {{ value: string, reason: "supabase" | "app" } | null}
 */
export function findProdTarget(values) {
  for (const value of values) {
    const reason = prodTargetReason(value);
    if (reason) return { value, reason };
  }
  return null;
}

/** Human-readable refusal, so every guard says the same thing. */
export function prodRefusalMessage({ value, reason }) {
  return reason === "supabase"
    ? `${value} is the PRODUCTION Supabase project.`
    : `${value} is the PRODUCTION app — its server writes to the prod database.`;
}

/**
 * Does this Playwright project talk to the real (TEST) Supabase backend?
 *
 * Matched by tier PREFIX, not against a closed list, so a new browser variant of
 * an existing tier (`authed-firefox`, `public-anon-mobile`) is guarded the day it
 * is added. Every project declared in `playwright.config.ts` must fall in a known
 * tier — asserted by `scripts/e2e/__tests__/prod-targets.test.mjs`, so an
 * unrecognised tier fails the unit gate instead of running unguarded.
 */
export function isBackendProject(name) {
  return name === "setup" || name.startsWith("authed-") || name.startsWith("public-anon-");
}

/**
 * The `--project` values an argv selects.
 * `null` means none was passed — Playwright then runs EVERY project.
 */
export function selectedProjects(argv) {
  const picked = [];
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === "--project" && argv[i + 1]) picked.push(argv[++i]);
    else if (arg.startsWith("--project=")) picked.push(arg.slice("--project=".length));
  }
  return picked.length > 0 ? picked : null;
}

/**
 * Will this argv run anything that needs the TEST backend?
 *
 * Only `playwright test` runs specs: `show-report`, `codegen` and `--help` load
 * the same config and must not be refused for a missing TEST env.
 */
export function needsTestBackend(argv) {
  if (!argv.includes("test")) return false;
  const picked = selectedProjects(argv);
  if (picked === null) return true; // every project — the authed tier included
  return picked.some(isBackendProject);
}
