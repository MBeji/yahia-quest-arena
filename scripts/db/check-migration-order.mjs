/**
 * Fail a PR whose added Supabase migration sorts BEFORE a migration already on
 * the base branch — the exact gap that let a back-dated migration (PR #97,
 * `20260613210000_…`) silently break `db-migrate-prod` on every push to `main`
 * for ~2 weeks (#227), then cascade into a TEST-DB drift failure (#229).
 *
 * Supabase applies migrations in lexical (= chronological, fixed-width 14-digit
 * timestamp) order and refuses to insert one *before* the last-applied remote
 * migration without `--include-all`. So a new migration MUST sort after every
 * migration already merged to the base branch. This check enforces that
 * mechanically, pre-merge, instead of discovering it in prod.
 *
 * Driven by `.github/workflows/migration-gate.yml`. Pure helpers are exported
 * and unit-tested; `main()` does the git plumbing and runs only when executed
 * directly.
 *
 *   node scripts/db/check-migration-order.mjs --base origin/main
 */
import { execSync } from "node:child_process";
import { pathToFileURL } from "node:url";

/** A migration filename must start with a 14-digit `YYYYMMDDHHMMSS_` stamp. */
export const VERSION_RE = /^(\d{14})_/;

/** Extract the 14-digit version from a path/filename, or null if it has none. */
export function versionOf(file) {
  const base = file.split("/").pop() ?? file;
  return base.match(VERSION_RE)?.[1] ?? null;
}

/**
 * Compare PR-added migration files against the versions already on the base
 * branch. A violation is an added file that is either untimestamped or sorts at
 * or before the newest migration already on base (so it would be inserted out of
 * order). Pure — git plumbing lives in `main()`.
 *
 * @param {string[]} baseVersions - 14-digit versions already on the base branch
 * @param {string[]} addedFiles   - migration filenames added by the PR
 * @returns {{ maxBase: string | null, violations: Array<object> }}
 */
export function findOrderingViolations(baseVersions, addedFiles) {
  const maxBase = baseVersions.length ? [...baseVersions].sort().at(-1) : null;
  const violations = [];
  for (const file of addedFiles) {
    const version = versionOf(file);
    if (!version) {
      violations.push({ file, reason: "untimestamped" });
      continue;
    }
    if (maxBase && version <= maxBase) {
      violations.push({ file, version, maxBase, reason: "out-of-order" });
    }
  }
  return { maxBase, violations };
}

const MIGRATIONS_GLOB = "supabase/migrations";

function gitLines(cmd) {
  return execSync(cmd, { encoding: "utf8" })
    .split("\n")
    .map((l) => l.trim())
    .filter(Boolean);
}

function main() {
  const baseArg = process.argv.indexOf("--base");
  const base = baseArg !== -1 ? process.argv[baseArg + 1] : "origin/main";

  // Migrations ADDED by this PR (relative to the merge-base with the target).
  const addedFiles = gitLines(
    `git diff --name-only --diff-filter=A "${base}...HEAD" -- ${MIGRATIONS_GLOB}`,
  ).filter((f) => f.endsWith(".sql"));

  // Every migration already present on the base branch tip — the newest of these
  // is the watermark a new migration must sort after.
  const baseVersions = gitLines(`git ls-tree -r --name-only "${base}" -- ${MIGRATIONS_GLOB}`)
    .filter((f) => f.endsWith(".sql"))
    .map(versionOf)
    .filter(Boolean);

  if (addedFiles.length === 0) {
    console.log("[migration-order] No new migrations in this PR — nothing to check.");
    return;
  }

  const { maxBase, violations } = findOrderingViolations(baseVersions, addedFiles);
  console.log(
    `[migration-order] base=${base} newest-on-base=${maxBase ?? "(none)"} ` +
      `added=${addedFiles.length}`,
  );

  if (violations.length === 0) {
    console.log("[migration-order] OK — every added migration sorts after the base.");
    return;
  }

  for (const v of violations) {
    if (v.reason === "untimestamped") {
      console.error(
        `::error file=${v.file}::Migration "${v.file}" has no leading 14-digit ` +
          `YYYYMMDDHHMMSS_ timestamp — rename it to the standard format.`,
      );
    } else {
      console.error(
        `::error file=${v.file}::Out-of-order migration: ${v.version} sorts at/before ` +
          `the newest migration already on ${base} (${v.maxBase}). Supabase applies ` +
          `migrations in timestamp order and refuses to insert one before the last ` +
          `applied — re-timestamp this file to sort AFTER ${v.maxBase} (CLAUDE.md §7).`,
      );
    }
  }
  throw new Error(
    `${violations.length} migration(s) would be inserted out of order — see annotations above.`,
  );
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
