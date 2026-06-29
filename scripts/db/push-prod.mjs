/**
 * Apply Supabase migrations to the PRODUCTION database — the ONLY sanctioned way
 * to run prod migrations. Mirrors scripts/e2e/setup-test-db.mjs but targets prod
 * and carries the INVERSE safety guard (must be prod, never test).
 *
 * Driven by .github/workflows/db-migrate-prod.yml (auto on merge to `main` when
 * supabase/migrations/** change, or manual dispatch). NEVER run prod migrations
 * by hand — author the migration, let the workflow apply it. See CLAUDE.md §7.
 *
 * Needs PROD_SUPABASE_DB_URL (the prod Postgres URI — the same secret that
 * db-backup.yml uses). Modes:
 *   --mode push        (default) apply pending migrations  (`supabase db push`)
 *   --mode list        read-only diff local vs remote      (`supabase migration list`)
 *   --mode repair-all  one-time bootstrap: record every local migration as
 *                      already-applied WITHOUT running it — adopts a DB whose
 *                      history table is out of sync after manual SQL-editor applies.
 */
import { execSync } from "node:child_process";
import { readdirSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { normalizeDbUrl } from "../shared/db-url.mjs";

/** The prod project ref the URL MUST contain (mirror of e2e `PROD_REFS`). */
export const PROD_REF = "fasrenmmrkqjoobrztbp";
/** The TEST project ref the URL must NEVER contain. */
export const TEST_REF = "pqegdnwdtbjtplcthxyp";

/**
 * Fail closed unless the URL unambiguously targets PRODUCTION: present, carries
 * the prod ref, and does not carry the test ref. Returns the url on success;
 * throws otherwise. Pure + exported so it is unit-tested.
 */
export function assertProdDbUrl(url) {
  if (!url) {
    throw new Error("PROD_SUPABASE_DB_URL is empty — set the prod Postgres URI secret.");
  }
  if (url.includes(TEST_REF)) {
    throw new Error(`Refusing to run: the URL targets the TEST project (${TEST_REF}), not prod.`);
  }
  if (!url.includes(PROD_REF)) {
    throw new Error(
      `Refusing to run: the URL does not contain the known prod ref (${PROD_REF}). ` +
        `Aborting to avoid touching the wrong database.`,
    );
  }
  return url;
}

/** All distinct 14-digit migration versions present locally, ascending. */
export function localMigrationVersions(migrationsDir) {
  const versions = readdirSync(migrationsDir)
    .filter((f) => f.endsWith(".sql"))
    .map((f) => f.match(/^(\d{14})_/)?.[1])
    .filter((v) => Boolean(v));
  return [...new Set(versions)].sort();
}

function main() {
  const modeArg = process.argv.indexOf("--mode");
  const mode = modeArg !== -1 ? process.argv[modeArg + 1] : "push";
  const url = assertProdDbUrl(normalizeDbUrl(process.env.PROD_SUPABASE_DB_URL));

  // The user's global npm registry may be a mirror lacking the Supabase CLI
  // binary; force the public registry just for the CLI fetch (see e2e/README.md).
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
  const run = (cmd) => execSync(cmd, { stdio: "inherit", env });

  if (mode === "list") {
    console.log("[db] PROD migration status (read-only):");
    run(`${cli} migration list --db-url "${url}"`);
    return;
  }

  if (mode === "repair-all") {
    const migrationsDir = resolve(
      dirname(fileURLToPath(import.meta.url)),
      "..",
      "..",
      "supabase",
      "migrations",
    );
    const versions = localMigrationVersions(migrationsDir);
    if (versions.length === 0) throw new Error(`No migrations found under ${migrationsDir}`);
    console.log(
      `[db] BOOTSTRAP: marking ${versions.length} local migration(s) as already-applied on PROD ` +
        `(no SQL executed)…`,
    );
    run(`${cli} migration repair --status applied ${versions.join(" ")} --db-url "${url}"`);
    console.log("[db] Done. Re-run with `--mode list` to confirm 0 pending.");
    return;
  }

  if (mode !== "push") {
    throw new Error(`Unknown --mode "${mode}" (expected push | list | repair-all).`);
  }

  console.log("[db] Applying PENDING migrations to PRODUCTION via `supabase db push`…");
  run(`${cli} db push --db-url "${url}"`);
  console.log("[db] PROD database is up to date.");
}

// Run only when executed directly (`node scripts/db/push-prod.mjs`), never on
// import — the unit test imports the pure helpers above and must not trigger a
// real run / process.exit inside the test worker.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
