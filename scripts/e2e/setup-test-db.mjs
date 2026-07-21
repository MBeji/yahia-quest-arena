/**
 * Provision the TEST Supabase project's SCHEMA: apply ALL migrations (tables,
 * RLS, RPCs, and the hand-written seed migrations — badges/shop items plus the
 * legacy `mcq` seed catalogue) via the Supabase CLI. Idempotent — the CLI tracks
 * applied migrations, so re-running only pushes what's new.
 *
 * ⚠️ This does NOT provision the pedagogical corpus. Since étude 24 (#544) the
 * generated content left this repo for the private one and no longer travels in
 * migrations, so `db push` alone yields only the legacy `mcq` seed — no native
 * question types (numeric/ordering/matching/multi), no culture-générale family.
 * The self-contained e2e fixture catalogue that the suite's coverage depends on
 * is seeded SEPARATELY by `npm run e2e:seed-content`
 * (scripts/e2e/seed-fixture-content.mjs), run right after this in `e2e:setup`.
 *
 * Needs the TEST database connection string (NOT the API URL):
 *   Supabase → Project Settings → Database → Connection string → URI.
 * Put it in `.env.test` as TEST_SUPABASE_DB_URL (loaded automatically), e.g.
 *   TEST_SUPABASE_DB_URL=postgresql://postgres:[PASSWORD]@db.<ref>.supabase.co:5432/postgres
 *
 *   npm run e2e:db:push
 *
 * ⚠️ TEST project only — the prod ref is rejected by _env.mjs.
 */
import { execSync } from "node:child_process";
import { normalizeDbUrl, parseDriftedRevertVersions } from "./_env.mjs";

// Percent-encode a raw password in the URI so the Supabase CLI (Go) accepts it
// ("invalid userinfo" guard — see normalizeDbUrl).
const DB_URL = normalizeDbUrl(process.env.TEST_SUPABASE_DB_URL ?? process.env.SUPABASE_DB_URL);

if (!DB_URL) {
  console.error(
    [
      "Missing TEST_SUPABASE_DB_URL (the TEST project's Postgres connection string).",
      "Find it in Supabase → Project Settings → Database → Connection string → URI,",
      "then add it to .env.test:",
      "  TEST_SUPABASE_DB_URL=postgresql://postgres:[PASSWORD]@db.<ref>.supabase.co:5432/postgres",
    ].join("\n"),
  );
  process.exit(1);
}

// The user's global npm registry may be a mirror that lacks the Supabase CLI
// binary; force the public registry just for this CLI fetch (see e2e/README.md).
const env = { ...process.env, npm_config_registry: "https://registry.npmjs.org" };

// Prefer a CLI already on PATH (CI installs it via supabase/setup-cli); fall
// back to npx for local runs without a global install.
const cli = (() => {
  try {
    execSync("supabase --version", { stdio: "ignore" });
    return "supabase";
  } catch {
    return "npx --yes supabase";
  }
})();

// Run `db push` capturing its output so we can detect (and auto-heal) a
// migration-history drift, while still streaming everything to the console.
function dbPush() {
  try {
    const out = execSync(`${cli} db push --db-url "${DB_URL}" --include-all`, {
      encoding: "utf8",
      env,
    });
    process.stdout.write(out);
    return { ok: true };
  } catch (err) {
    const output = `${err.stdout ?? ""}${err.stderr ?? ""}`;
    process.stderr.write(output);
    return { ok: false, output };
  }
}

console.log("[e2e] Applying migrations to the TEST project via `supabase db push`…");
let result = dbPush();

// Auto-heal a history drift: a migration version still recorded in the TEST
// project's history but no longer present locally (typically after a migration
// was re-timestamped) makes `db push` abort. The CLI prints the exact
// `migration repair --status reverted <version>` to run; harvest those, apply
// them, then retry the push ONCE. TEST-only — `_env.mjs` already refuses any
// prod ref, so this can never touch production.
if (!result.ok) {
  const drifted = parseDriftedRevertVersions(result.output);
  if (drifted.length > 0) {
    console.log(
      `[e2e] Migration-history drift on TEST — marking orphan version(s) as reverted: ${drifted.join(", ")}`,
    );
    for (const version of drifted) {
      execSync(`${cli} migration repair --status reverted ${version} --db-url "${DB_URL}"`, {
        stdio: "inherit",
        env,
      });
    }
    console.log("[e2e] Retrying `supabase db push` after repair…");
    result = dbPush();
  }
}

if (result.ok) {
  console.log("[e2e] TEST database is up to date.");
} else {
  console.error(
    [
      "",
      "`supabase db push` failed. Common fixes:",
      "  • Install the CLI from the public registry:",
      "      npm i -g supabase --registry=https://registry.npmjs.org",
      '    then re-run:  supabase db push --db-url "$TEST_SUPABASE_DB_URL" --include-all',
      "  • Verify TEST_SUPABASE_DB_URL is the *direct* connection URI (port 5432).",
      "  • Ensure the password in the URI is URL-encoded.",
      "  • Migration-history drift the auto-repair could not parse? Repair by hand:",
      '      supabase migration repair --status reverted <version> --db-url "$TEST_SUPABASE_DB_URL"',
    ].join("\n"),
  );
  process.exit(1);
}
