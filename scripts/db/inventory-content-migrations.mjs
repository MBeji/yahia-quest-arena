/**
 * Inventory of the CONTENT migrations — step 1 of the étude 24 lot-3 runbook (§4.3).
 *
 * The corpus is leaving the Supabase migration framework (D-3), so the one-shot
 * cleanup needs an exact, reproducible answer to a single question: which
 * migration versions carry authored content and nothing else? Those — and only
 * those — may be marked `reverted` on prod (bookkeeping only, no data touched)
 * once their files are gone, via the sanctioned `db-migrate-prod.yml`
 * `repair-revert` dispatch.
 *
 * Why this script does NOT implement the criterion written in §4.3-1
 * ("migrations qui n'insèrent que dans subjects/chapters/exercises/questions
 * sans DDL") — that criterion selects nothing on the real tree:
 *
 *   1. Every generated migration embeds an idempotent constraint guard
 *      (`DO $$ … exercises_mode_check … END $$`), so "sans DDL" excludes all of
 *      them. The guard is repeated in all 226 files and re-emitted on the
 *      content channel, so it travels WITH the corpus — but a public-only fresh
 *      DB would no longer carry it (flagged below; decide at lot 3b).
 *   2. Subject-scoped pruning also DELETEs from `dungeon_run_questions`, a
 *      gameplay table — a 5th table the criterion does not mention.
 *   3. Hand-written content migrations exist that ALSO seed non-content data:
 *      `20260522170000_seed_content.sql` inserts `badges` and `shop_items`.
 *      Reverting it would silently drop game data from the history.
 *
 * The criterion used instead is provenance, which is exact: a migration belongs
 * to the content channel iff the pipeline generated it (`_generated_*_content`),
 * because that is precisely the set `npm run content:emit` reproduces as
 * `sql/content/<subject>.sql`. Everything else stays public and is reported
 * separately — `content-legacy` in particular is NEVER safe to bulk-revert.
 *
 * Usage:
 *   node scripts/db/inventory-content-migrations.mjs            # human report
 *   node scripts/db/inventory-content-migrations.mjs --versions # repair-revert list
 *   node scripts/db/inventory-content-migrations.mjs --json     # machine readable
 *   … --dir <path>                                              # alternate tree
 */
import { readFileSync, readdirSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { versionOf } from "./check-migration-order.mjs";

/** Tables holding authored pedagogical content — the signature of a content migration. */
export const CONTENT_TABLES = ["subjects", "chapters", "exercises", "questions"];

/**
 * Compiler OUTPUTS written by the very same migrations: the question↔competency
 * junction (étude 07 lot 1) and the competency registry itself. They describe
 * content, so they ride the content channel — but they are not what makes a
 * migration "content" (a schema migration may legitimately create them).
 */
export const COMPILED_TABLES = ["question_competencies", "competencies", "competency_prereqs"];

/**
 * Touched as a CONSEQUENCE of subject-scoped pruning, not as content: removing
 * a question must clear the dungeon rows referencing it. Seeing this table does
 * not make a migration "non-content".
 */
export const CASCADE_TABLES = ["dungeon_run_questions"];

/** Files emitted by the content pipeline — the authoritative provenance mark. */
export const GENERATED_CONTENT_RE = /^\d{14}_generated_.+_content\.sql$/;
export const GENERATED_REGISTRY_RE = /^\d{14}_generated_competences_registry\.sql$/;

/** The idempotent constraint guard every generated migration embeds. */
export const CONSTRAINT_GUARD = "exercises_mode_check";

const DDL_RE = /\b(CREATE|ALTER|DROP)\s+(TABLE|FUNCTION|POLICY|TYPE|INDEX|TRIGGER|VIEW)\b/gi;

/**
 * A write targets a table only in these shapes. `UPDATE` demands a trailing
 * `SET` on purpose: it rules out `FOR UPDATE USING (…)` in an RLS policy and
 * `ON CONFLICT DO UPDATE SET`, neither of which names a table.
 */
const DML_RE =
  /\b(?:INSERT\s+INTO|DELETE\s+FROM)\s+(?:public\.)?([a-z_][a-z0-9_]*)|\bUPDATE\s+(?:public\.)?([a-z_][a-z0-9_]*)\s+SET\b/gi;

/** Drop line comments so prose ("users can update their own row") is not read as SQL. */
export function stripComments(sql) {
  return sql.replace(/--[^\n]*/g, " ");
}

/** Distinct table names the statements of `sql` write to, sorted. */
export function tablesTouched(sql) {
  const found = new Set();
  for (const match of stripComments(sql).matchAll(DML_RE)) {
    const table = match[1] ?? match[2];
    if (table) found.add(table.toLowerCase());
  }
  return [...found].sort();
}

/**
 * Schema DDL classification. `constraint-guard` means the ONLY DDL is the
 * idempotent guard the pipeline embeds — safe to move to the content channel;
 * `schema` means real schema evolution that must stay in the migration
 * framework.
 */
export function ddlKind(sql) {
  const statements = [...sql.matchAll(DDL_RE)].map((m) => m[0]);
  if (statements.length === 0) return "none";
  return sql.includes(CONSTRAINT_GUARD) && statements.every((s) => /ALTER\s+TABLE/i.test(s))
    ? "constraint-guard"
    : "schema";
}

/**
 * Classify one migration.
 *
 * - `content-generated` — pipeline output; reproducible by `content:emit`, so it
 *   is exactly what the content channel replaces. Eligible for repair-revert.
 * - `content-legacy` — hand-written, writes content tables. NOT reproducible by
 *   the emitter and may carry non-content seeds → never bulk-revert; each one
 *   needs a human call at lot 3b.
 * - `schema-ops` — schema/ops; stays public, untouched.
 */
export function classifyMigration(fileName, sql) {
  const version = versionOf(fileName);
  const tables = tablesTouched(sql);
  const generated = GENERATED_CONTENT_RE.test(fileName) || GENERATED_REGISTRY_RE.test(fileName);
  const known = new Set([...CONTENT_TABLES, ...COMPILED_TABLES, ...CASCADE_TABLES]);
  const foreignTables = tables.filter((t) => !known.has(t));
  const touchesContent = tables.some((t) => CONTENT_TABLES.includes(t));

  const kind = generated ? "content-generated" : touchesContent ? "content-legacy" : "schema-ops";

  return { fileName, version, kind, tables, foreignTables, ddl: ddlKind(sql) };
}

/** Classify a whole migrations directory. */
export function inventoryDir(dir) {
  return readdirSync(dir)
    .filter((f) => f.endsWith(".sql"))
    .sort()
    .map((f) => classifyMigration(f, readFileSync(join(dir, f), "utf8")));
}

/** Group a classification list by kind. */
export function groupByKind(entries) {
  return {
    "content-generated": entries.filter((e) => e.kind === "content-generated"),
    "content-legacy": entries.filter((e) => e.kind === "content-legacy"),
    "schema-ops": entries.filter((e) => e.kind === "schema-ops"),
  };
}

function main() {
  const arg = (name) => {
    const i = process.argv.indexOf(`--${name}`);
    return i !== -1 ? process.argv[i + 1] : undefined;
  };
  const has = (name) => process.argv.includes(`--${name}`);

  const dir = resolve(
    arg("dir") ??
      join(dirname(fileURLToPath(import.meta.url)), "..", "..", "supabase", "migrations"),
  );
  const entries = inventoryDir(dir);
  const groups = groupByKind(entries);
  const generated = groups["content-generated"];

  if (has("versions")) {
    // Consumed by the lot-3b repair-revert dispatch — bare list, nothing else.
    process.stdout.write(`${generated.map((e) => e.version).join(" ")}\n`);
    return;
  }

  if (has("json")) {
    process.stdout.write(`${JSON.stringify({ dir, entries }, null, 2)}\n`);
    return;
  }

  const line = (label, n) => `  ${label.padEnd(20)} ${String(n).padStart(4)}\n`;
  process.stdout.write(`\nInventaire des migrations — ${dir}\n\n`);
  process.stdout.write(line("total", entries.length));
  process.stdout.write(line("content-generated", generated.length));
  process.stdout.write(line("content-legacy", groups["content-legacy"].length));
  process.stdout.write(line("schema-ops", groups["schema-ops"].length));

  const guarded = generated.filter((e) => e.ddl === "constraint-guard").length;
  if (guarded > 0) {
    process.stdout.write(
      `\n⚠️  ${guarded} migration(s) générée(s) embarquent le garde de contrainte ` +
        `'${CONSTRAINT_GUARD}'.\n    Idempotent et ré-émis sur le canal contenu, donc il suit le corpus ` +
        `— mais une base\n    fraîche reconstruite depuis le SEUL repo public ne le porterait plus ` +
        `(arbitrage lot 3b).\n`,
    );
  }

  const legacy = groups["content-legacy"];
  if (legacy.length > 0) {
    process.stdout.write(
      `\n⚠️  ${legacy.length} migration(s) de contenu écrite(s) à la main — NON reproductibles par ` +
        `l'émetteur.\n    Ne jamais les révoquer en masse ; celles marquées (+) seedent aussi des ` +
        `données hors contenu :\n`,
    );
    for (const e of legacy) {
      const mark = e.foreignTables.length > 0 ? "+" : " ";
      const extra = e.foreignTables.length > 0 ? ` → ${e.foreignTables.join(", ")}` : "";
      process.stdout.write(`    ${mark} ${e.fileName}${extra}\n`);
    }
  }

  const unexpected = generated.filter((e) => e.foreignTables.length > 0);
  if (unexpected.length > 0) {
    process.stdout.write(
      `\n🛑 ${unexpected.length} migration(s) générée(s) touchent une table inattendue — STOP, ` +
        `escalade :\n`,
    );
    for (const e of unexpected) {
      process.stdout.write(`     ${e.fileName} → ${e.foreignTables.join(", ")}\n`);
    }
  }

  process.stdout.write(
    `\nVersions révocables (${generated.length}) : relancer avec --versions.\n` +
      `Canal de remplacement : npm run content:emit (sql/content/<subject>.sql, repo privé).\n\n`,
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
