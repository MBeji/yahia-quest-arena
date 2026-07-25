/**
 * Shared env bootstrap for every e2e tooling script (seed / reset / db push).
 *
 * - Loads `.env.test` (repo root) for LOCAL runs so you don't have to export the
 *   TEST project vars by hand. In CI the file is absent and the workflow provides
 *   env directly, so `override: false` never clobbers the CI-provided values.
 * - Hard safety net: refuses to run if anything resolved here points at
 *   production — the Supabase project or the deployed app. e2e tooling must only
 *   ever touch the TEST project.
 *
 * Import this for its side effects FIRST, before reading any SUPABASE_* var:
 *   import "./_env.mjs";
 */
import { existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import dotenv from "dotenv";

import { findProdTarget, prodRefusalMessage } from "../shared/prod-targets.mjs";

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..", "..");
const envTestPath = resolve(repoRoot, ".env.test");

if (existsSync(envTestPath)) {
  dotenv.config({ path: envTestPath, override: false });
}

// What production looks like — Supabase ref AND app hosts — lives in one place
// (`scripts/shared/prod-targets.mjs`), so no guard can drift from another.

/**
 * Normalize a Supabase API URL pasted from the dashboard: trim whitespace and
 * accidental wrapping quotes, add the https:// scheme when missing, drop a
 * trailing slash. supabase-js hard-rejects scheme-less URLs ("Invalid
 * supabaseUrl") — the exact failure that broke the nightly e2e-auth seeding.
 *
 * Common misconfiguration: the POSTGRES connection string pasted where the API
 * URL belongs. The project ref is recoverable from it (pooler username
 * `postgres.<ref>` or direct host `db.<ref>.supabase.co`), so derive
 * `https://<ref>.supabase.co` instead of failing on hostname "postgresql".
 */
export function normalizeSupabaseUrl(raw) {
  if (!raw) return raw;
  let url = raw.trim().replace(/^['"]|['"]$/g, "");
  const pg = url.match(/^postgres(?:ql)?:\/\/([^@]*)@([^/:?]+)/i);
  if (pg) {
    const user = pg[1].split(":")[0];
    const ref =
      user.match(/^postgres\.([a-z0-9]+)$/i)?.[1] ??
      pg[2].match(/^db\.([a-z0-9]+)\.supabase\.co$/i)?.[1];
    if (ref) {
      console.warn(
        `[e2e] The Supabase URL is a Postgres connection string — derived the API URL https://${ref}.supabase.co from its project ref. Fix the variable/secret.`,
      );
      return `https://${ref}.supabase.co`;
    }
    return url; // unrecognizable DB URI: let the caller fail loudly
  }
  if (url && !/^https?:\/\//i.test(url)) url = `https://${url}`;
  return url.replace(/\/+$/, "");
}

/**
 * Parse the migration versions the Supabase CLI asks us to mark as `reverted`
 * when `db push` aborts on a history drift ("Remote migration versions not found
 * in local migrations directory" — typically after a migration was
 * re-timestamped). The CLI prints the exact repair command(s), e.g.
 *   supabase migration repair --status reverted 20260628094836
 * so we harvest those versions verbatim rather than guessing. We ONLY ever
 * collect `--status reverted` versions (safe: drops an orphan history row so a
 * renamed migration can re-apply); never `--status applied`, which would mask
 * genuinely missing DDL. Returns a de-duplicated list (order preserved).
 *
 * The CLI puts EVERY drifted version on a SINGLE line, space-separated:
 *   supabase migration repair --status reverted 20260602142000 20260602143000 …
 * so the trailing run must be captured whole. Capturing only the first version
 * left the other ~200 behind after the étude 24 corpus scission dropped the
 * generated content migrations: each run repaired one version, retried once,
 * and failed again — blocking e2e-auth before a single test could run.
 * `[ \t]` (not `\s`) keeps the run on its own line so digits from following
 * lines can never be harvested.
 */
export function parseDriftedRevertVersions(output) {
  if (!output) return [];
  const versions = new Set();
  const re = /migration\s+repair\s+--status\s+reverted\s+((?:\d{6,}[ \t]*)+)/gi;
  let m;
  while ((m = re.exec(output))) {
    for (const version of m[1].trim().split(/[ \t]+/)) versions.add(version);
  }
  return [...versions];
}

// Side effect: every e2e script reads these straight from process.env — fix
// them once here so seed/reset/doctor all see a well-formed URL.
for (const key of ["SUPABASE_URL", "TEST_SUPABASE_URL", "VITE_SUPABASE_URL"]) {
  if (process.env[key]) process.env[key] = normalizeSupabaseUrl(process.env[key]);
}

// The Postgres connection-string normalizer is shared with the PROD migration
// tooling (scripts/db/push-prod.mjs). Its implementation lives in a guard-free
// module so neither side imports the other's safety net (this file refuses prod;
// push-prod refuses test). Re-exported so existing importers — setup-test-db.mjs
// and the regression test — keep resolving it from here.
export { normalizeDbUrl } from "../shared/db-url.mjs";

/**
 * Throw-and-exit if anything configured here targets production — the Supabase
 * project OR the deployed app. `PLAYWRIGHT_BASE_URL` counts: the prod deployment
 * serves with its own prod secrets, so a browser pointed at it writes to prod
 * even when every Supabase var below is TEST (#614).
 */
export function assertNotProd() {
  const hit = findProdTarget([
    process.env.SUPABASE_URL,
    process.env.TEST_SUPABASE_URL,
    process.env.VITE_SUPABASE_URL,
    process.env.TEST_SUPABASE_DB_URL,
    process.env.SUPABASE_DB_URL,
    process.env.PLAYWRIGHT_BASE_URL,
  ]);
  if (hit) {
    console.error(
      `[e2e] Refusing to run: ${prodRefusalMessage(hit)} Use a dedicated TEST project.`,
    );
    process.exit(1);
  }
}

assertNotProd();
