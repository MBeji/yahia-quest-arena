/**
 * Provision the TEST Supabase project: apply ALL migrations (schema + generated
 * content + shop items + RPCs) via the Supabase CLI. Idempotent — the CLI tracks
 * applied migrations, so re-running only pushes what's new.
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
import { normalizeDbUrl } from "./_env.mjs";

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

console.log("[e2e] Applying migrations to the TEST project via `supabase db push`…");
try {
  execSync(`${cli} db push --db-url "${DB_URL}" --include-all`, {
    stdio: "inherit",
    env,
  });
  console.log("[e2e] TEST database is up to date.");
} catch {
  console.error(
    [
      "",
      "`supabase db push` failed. Common fixes:",
      "  • Install the CLI from the public registry:",
      "      npm i -g supabase --registry=https://registry.npmjs.org",
      '    then re-run:  supabase db push --db-url "$TEST_SUPABASE_DB_URL" --include-all',
      "  • Verify TEST_SUPABASE_DB_URL is the *direct* connection URI (port 5432).",
      "  • Ensure the password in the URI is URL-encoded.",
    ].join("\n"),
  );
  process.exit(1);
}
