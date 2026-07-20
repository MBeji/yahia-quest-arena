#!/usr/bin/env node
/**
 * Migration-chain reconstructibility gate.
 *
 * Replays `supabase/migrations/**` STATICALLY — in version order, accumulating
 * the content ids each statement creates — and fails on anything that would
 * break `supabase db reset` on a BLANK database.
 *
 * Why this exists (2026-07-20). Étude 24 lot 4 (#544) removed the GENERATED
 * content migrations from the public repo. They had been carrying, invisibly,
 * two things the remaining migrations depended on: the parent rows their
 * INSERTs referenced, and a per-subject `prune` that wiped inherited content
 * before the pgTAP fixtures ran. Four separate breakages followed, each found
 * by hand-dispatching `db-tests.yml` (~4 min a round) because pgTAP does NOT
 * run on PRs — nightly and `workflow_dispatch` only:
 *
 *   1. #548 — `20260604140000_content_quality_pass_delta.sql` inserted questions
 *             whose exercises no longer existed (`questions_exercise_id_fkey`).
 *   2. #549 — `exercises_mode_check` only allowed `challenge` through an
 *             idempotent guard that travelled with the generated migrations.
 *   3. #552 — `20260604{15,17,18,19}0000` inserted exercises referencing
 *             chapters and subjects that no longer existed.
 *   4. #557 — four pgTAP fixtures collided with inherited content ids that the
 *             vanished `prune` used to delete (`duplicate key`).
 *
 * A static replay found all four at once. This script IS that replay, wired
 * into `ci:verify` so a required check speaks up pre-merge instead of a nightly
 * four hours later.
 *
 * What it checks:
 *   A. Content foreign keys along the chain — `chapters.subject_id`,
 *      `exercises.chapter_id`, `exercises.subject_id`, `questions.exercise_id`.
 *   B. pgTAP fixture ids (`supabase/tests/*.sql`) colliding, IN THE SAME TABLE,
 *      with an id the migrations create — the #557 `duplicate key`.
 *   C. Two migrations sharing one 14-digit version (near-miss the same day
 *      between `20260720190000_exercises_mode_check.sql` and étude 22 lot 5).
 *
 * Deliberately NOT checked: `UPDATE`s (none in the repo touch an id or an FK)
 * and `DELETE`s (there are none on the content tables — the chain is purely
 * additive there, so an id, once created, is never taken away).
 *
 * Pure helpers are exported and unit-tested; `main()` does the fs plumbing and
 * runs only when the file is executed directly.
 *
 *   node scripts/db/check-migration-chain.mjs [--verbose]
 *   node scripts/db/check-migration-chain.mjs --migrations <dir> --tests <dir>
 *
 * The directory overrides exist so the replay can be pointed at a `git archive`
 * of an older revision — which is how this script was validated against the
 * four breakages above before being wired into the gate.
 */
import { readFileSync, readdirSync } from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const MIGRATIONS_DIR = "supabase/migrations";
const TESTS_DIR = "supabase/tests";

/** Cap on annotations per category — a broken chain yields hundreds at once. */
const MAX_ANNOTATIONS = 20;

/** A migration filename must start with a 14-digit `YYYYMMDDHHMMSS_` stamp. */
const VERSION_RE = /^(\d{14})_/;

/**
 * The content chain, child → parent. Ids live in different namespaces per table
 * (`subjects.id` is TEXT — `french`, `math` —, the other three are UUID), so a
 * reference is only ever resolved against its own parent table.
 */
export const CONTENT_FKS = {
  subjects: [],
  chapters: [{ column: "subject_id", parent: "subjects" }],
  exercises: [
    { column: "chapter_id", parent: "chapters" },
    { column: "subject_id", parent: "subjects" },
  ],
  questions: [{ column: "exercise_id", parent: "exercises" }],
};

/** Tables whose rows this replay tracks. */
export const CONTENT_TABLES = Object.keys(CONTENT_FKS);

// ---------------------------------------------------------------------------
// SQL scanning
// ---------------------------------------------------------------------------

/**
 * Split a SQL file into statements, character by character.
 *
 * This CANNOT be a line-oriented regex. The content migrations embed whole
 * Markdown documents inside single-quoted literals, so `--`, `;` and newlines
 * all occur as DATA:
 *   - `--` opens a Markdown horizontal rule, not a comment (40+ in one file);
 *   - `;` appears in French coordinate notation (`A(1 ; 2)`);
 *   - one `lesson_content` literal spans ~420 lines.
 *
 * Precedence is the whole game: a single-quoted string is OPAQUE, and `''`
 * inside it is an escaped quote, not a terminator. Dollar-quoting is honoured
 * (PL/pgSQL bodies elsewhere in the chain) but only ever recognised OUTSIDE a
 * string — the 66 `$$` in the content files are LaTeX display-math delimiters
 * sitting inside literals, and a scanner that looked for `$$` first would
 * swallow the rest of the file.
 *
 * Comments are replaced by a single space so `foo--x\nbar` cannot become
 * `foobar`.
 *
 * @param {string} sql
 * @returns {string[]} statements, comment-free, string literals intact
 */
export function splitStatements(sql) {
  const statements = [];
  let buf = "";
  let i = 0;

  const flush = () => {
    if (buf.trim()) statements.push(buf.trim());
    buf = "";
  };

  while (i < sql.length) {
    const c = sql[i];

    // Single-quoted literal — opaque, `''` does not terminate it.
    if (c === "'") {
      const end = skipQuoted(sql, i, "'");
      buf += sql.slice(i, end);
      i = end;
      continue;
    }

    // Double-quoted identifier — same rule, `""` escapes.
    if (c === '"') {
      const end = skipQuoted(sql, i, '"');
      buf += sql.slice(i, end);
      i = end;
      continue;
    }

    // Line comment.
    if (c === "-" && sql[i + 1] === "-") {
      const nl = sql.indexOf("\n", i);
      buf += " ";
      i = nl === -1 ? sql.length : nl; // leave the \n for the next iteration
      continue;
    }

    // Block comment — nestable in PostgreSQL.
    if (c === "/" && sql[i + 1] === "*") {
      let depth = 1;
      let j = i + 2;
      while (j < sql.length && depth > 0) {
        if (sql[j] === "/" && sql[j + 1] === "*") {
          depth += 1;
          j += 2;
        } else if (sql[j] === "*" && sql[j + 1] === "/") {
          depth -= 1;
          j += 2;
        } else {
          j += 1;
        }
      }
      buf += " ";
      i = j;
      continue;
    }

    // Dollar-quoted body. Unreachable from inside a literal (see above), so the
    // LaTeX `$$` of the corpus never lands here.
    if (c === "$") {
      const tag = matchDollarTag(sql, i);
      if (tag) {
        const close = sql.indexOf(tag, i + tag.length);
        if (close !== -1) {
          const end = close + tag.length;
          buf += sql.slice(i, end);
          i = end;
          continue;
        }
        // Unterminated: fall through and treat `$` as an ordinary character
        // rather than swallowing the remainder of the file.
      }
    }

    if (c === ";") {
      flush();
      i += 1;
      continue;
    }

    buf += c;
    i += 1;
  }

  flush();
  return statements;
}

/** Index just past the quoted run starting at `start` (doubled quote escapes). */
function skipQuoted(sql, start, quote) {
  let i = start + 1;
  while (i < sql.length) {
    if (sql[i] === quote) {
      if (sql[i + 1] === quote) {
        i += 2;
        continue;
      }
      return i + 1;
    }
    i += 1;
  }
  return sql.length;
}

/** `$$` or `$tag$` at `i`, or null. */
function matchDollarTag(sql, i) {
  const m = /^\$([A-Za-z_][A-Za-z0-9_]*)?\$/.exec(sql.slice(i, i + 64));
  return m ? m[0] : null;
}

/** Index just past the `)` matching the `(` at `openIdx` — string-aware. */
function matchParen(text, openIdx) {
  let depth = 0;
  let i = openIdx;
  while (i < text.length) {
    const c = text[i];
    if (c === "'" || c === '"') {
      i = skipQuoted(text, i, c);
      continue;
    }
    if (c === "(") depth += 1;
    else if (c === ")") {
      depth -= 1;
      if (depth === 0) return i + 1;
    }
    i += 1;
  }
  return -1;
}

/** Split on commas that are not nested in parens/brackets nor inside a literal. */
export function splitTopLevelCommas(text) {
  const parts = [];
  let depth = 0;
  let start = 0;
  let i = 0;
  while (i < text.length) {
    const c = text[i];
    if (c === "'" || c === '"') {
      i = skipQuoted(text, i, c);
      continue;
    }
    if (c === "(" || c === "[") depth += 1;
    else if (c === ")" || c === "]") depth -= 1;
    else if (c === "," && depth === 0) {
      parts.push(text.slice(start, i).trim());
      start = i + 1;
    }
    i += 1;
  }
  parts.push(text.slice(start).trim());
  return parts;
}

/**
 * The value of a field that is a plain literal, else null (an expression whose
 * value this static pass cannot know). A trailing cast is tolerated.
 */
export function literalOf(field) {
  const m = /^'((?:[^']|'')*)'\s*(?:::\s*[A-Za-z_][A-Za-z0-9_ ]*)?$/.exec(field.trim());
  return m ? m[1].replace(/''/g, "'") : null;
}

/** Read `( … ), ( … ), …` starting at `fromIdx`; returns raw field arrays. */
function readTupleList(text, fromIdx) {
  const tuples = [];
  let i = fromIdx;
  for (;;) {
    while (i < text.length && /\s/.test(text[i])) i += 1;
    if (text[i] !== "(") break;
    const end = matchParen(text, i);
    if (end === -1) break;
    tuples.push(splitTopLevelCommas(text.slice(i + 1, end - 1)));
    i = end;
    while (i < text.length && /\s/.test(text[i])) i += 1;
    if (text[i] === ",") {
      i += 1;
      continue;
    }
    break;
  }
  return { tuples, endIdx: i };
}

const INSERT_HEAD_RE = /INSERT\s+INTO\s+(?:public\.)?([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)/i;

function columnNames(list) {
  return list
    .split(",")
    .map((c) => c.trim().toLowerCase())
    .filter(Boolean);
}

/**
 * Parse an INSERT into a content table into `{ table, columns, rows, guards }`,
 * or null when the statement is not one.
 *
 * Two shapes exist in the chain, and only two:
 *
 *   A. `INSERT INTO public.T (cols) VALUES (…), (…) [ON CONFLICT …];`
 *      Unguarded — a dangling reference here FAILS the migration.
 *
 *   B. `INSERT INTO public.T (cols) SELECT v.… FROM (VALUES (…), (…))
 *      AS v(cols) WHERE EXISTS (SELECT 1 FROM public.P p WHERE p.id = v.fk)
 *      [AND EXISTS (…)] ON CONFLICT (id) DO UPDATE SET …;`
 *      Guarded — these are exactly the `WHERE EXISTS` guards #548/#552 added,
 *      and they CANNOT produce an orphan: a row whose parent is missing is
 *      simply not inserted. Note the guard is NOT the tail of the statement —
 *      `ON CONFLICT … DO UPDATE` follows it.
 *
 * In shape B the tuple columns come from the `AS v(…)` alias, not from the
 * INSERT header: the header names the target columns, the alias names the
 * tuple fields, and only the latter is what `WHERE EXISTS` references.
 */
export function parseContentInsert(statement) {
  const head = INSERT_HEAD_RE.exec(statement);
  if (!head) return null;
  const table = head[1].toLowerCase();
  if (!CONTENT_TABLES.includes(table)) return null;

  const afterHead = head.index + head[0].length;
  const rest = statement.slice(afterHead);

  // Shape A — `VALUES` directly after the column list.
  const directValues = /^\s*VALUES\s*(?=\()/i.exec(rest);
  if (directValues) {
    const { tuples } = readTupleList(rest, directValues[0].length);
    return {
      table,
      columns: columnNames(head[2]),
      rows: tuples,
      guards: [],
      guarded: false,
    };
  }

  // Shape B — `… FROM (VALUES …) AS alias(cols) WHERE EXISTS …`.
  const fromValues = /\bFROM\s*\(\s*VALUES\s*(?=\()/i.exec(rest);
  if (!fromValues) return null;

  const valuesStart = fromValues.index + fromValues[0].length;
  const { tuples, endIdx } = readTupleList(rest, valuesStart);
  const tail = rest.slice(endIdx);

  const alias = /^\s*\)\s*(?:AS\s+)?[A-Za-z_][A-Za-z0-9_]*\s*\(([^)]*)\)/i.exec(tail);
  if (!alias) return null;

  return {
    table,
    columns: columnNames(alias[1]),
    rows: tuples,
    ...parseGuards(tail.slice(alias[0].length)),
  };
}

const GUARD_RE =
  /EXISTS\s*\(\s*SELECT\s+1\s+FROM\s+(?:public\.)?([A-Za-z_][A-Za-z0-9_]*)\s+([A-Za-z_][A-Za-z0-9_]*)\s+WHERE\s+\2\s*\.\s*id\s*=\s*[A-Za-z_][A-Za-z0-9_]*\s*\.\s*([A-Za-z_][A-Za-z0-9_]*)/gi;

/**
 * Collect the `EXISTS (SELECT 1 FROM parent p WHERE p.id = v.fk)` guards.
 *
 * `NOT EXISTS` inverts the meaning, so a statement carrying one is reported as
 * guarded-but-opaque: its rows are neither FK-checked (we cannot tell which
 * survive) nor added to the created set. That is the conservative side — it can
 * only under-report, never invent an orphan. No such statement exists today.
 */
function parseGuards(tail) {
  if (/\bNOT\s+EXISTS\b/i.test(tail)) return { guards: [], guarded: true, opaque: true };
  const guards = [];
  for (const m of tail.matchAll(GUARD_RE)) {
    guards.push({ parent: m[1].toLowerCase(), column: m[3].toLowerCase() });
  }
  return { guards, guarded: guards.length > 0, opaque: false };
}

/** Map a raw tuple onto its column names; non-literal fields become null. */
function rowValues(columns, tuple) {
  const row = {};
  for (let i = 0; i < columns.length; i += 1) {
    row[columns[i]] = i < tuple.length ? literalOf(tuple[i]) : undefined;
  }
  return row;
}

// ---------------------------------------------------------------------------
// Chain replay
// ---------------------------------------------------------------------------

/**
 * Replay the migrations in version order and collect every reference that would
 * point at a row a blank database does not have.
 *
 * Guards are EVALUATED rather than merely detected: for each row of a guarded
 * INSERT we test the guard against the ids accumulated so far, so a row that a
 * blank DB would skip contributes no id — and its children, guarded in turn,
 * cascade out the same way. That is how the two subjects the generated corpus
 * used to own (`sciences-vie-terre`, `fr-mastery`) resolve to silence instead
 * of noise: every statement touching them is guarded.
 *
 * @param {Array<{ file: string, sql: string }>} files - sorted by version
 */
export function replayMigrations(files) {
  const created = Object.fromEntries(CONTENT_TABLES.map((t) => [t, new Set()]));
  const orphans = [];
  let unresolved = 0;

  for (const { file, sql } of files) {
    for (const statement of splitStatements(sql)) {
      const insert = parseContentInsert(statement);
      if (!insert) continue;

      for (const tuple of insert.rows) {
        const row = rowValues(insert.columns, tuple);

        if (insert.opaque) continue;

        // A guarded row that a blank DB would filter out: no insert, no id.
        const survives = insert.guards.every((g) => {
          const value = row[g.column];
          return value != null && created[g.parent]?.has(value);
        });
        if (!survives) continue;

        for (const fk of CONTENT_FKS[insert.table]) {
          const value = row[fk.column];
          if (value === undefined) continue; // column absent from this INSERT
          if (value === null) {
            unresolved += 1; // expression, not a literal — unknowable statically
            continue;
          }
          if (insert.guards.some((g) => g.column === fk.column)) continue; // guarded
          if (!created[fk.parent].has(value)) {
            orphans.push({
              file,
              table: insert.table,
              column: fk.column,
              parent: fk.parent,
              value,
              guarded: insert.guarded,
            });
          }
        }

        const id = row.id;
        if (typeof id === "string") created[insert.table].add(id);
      }
    }
  }

  return { created, orphans, unresolved };
}

/**
 * Collapse orphans to one entry per distinct (file, table, column, value).
 *
 * One missing parent is typically referenced by many rows — the four waves
 * produced 187 raw findings for 108 distinct references. Reporting each row
 * would bury the signal: what an author must fix is the *reference*, and the
 * row count is only there to convey the blast radius.
 */
export function summarizeOrphans(orphans) {
  const byKey = new Map();
  for (const o of orphans) {
    const key = `${o.file} ${o.table} ${o.column} ${o.value}`;
    const seen = byKey.get(key);
    if (seen) seen.rows += 1;
    else byKey.set(key, { ...o, rows: 1 });
  }
  return [...byKey.values()];
}

// ---------------------------------------------------------------------------
// pgTAP fixtures
// ---------------------------------------------------------------------------

const GENERATE_SERIES_RE = /\bFROM\s+generate_series\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)/i;
const CONCAT_SERIES_RE =
  /^\(\s*'((?:[^']|'')*)'\s*\|\|\s*[A-Za-z_][A-Za-z0-9_]*\s*\)\s*(?:::\s*[A-Za-z_][A-Za-z0-9_]*)?$/;

/**
 * Ids a pgTAP fixture inserts into a content table.
 *
 * Fixtures use three shapes, the third of which builds ids by concatenation:
 *   `SELECT ('e3000000-…-00000000000' || g)::uuid … FROM generate_series(1, 5) AS g`
 * — expanded here, because an unexpanded prefix would hide a real collision.
 *
 * `ON CONFLICT` on the target absorbs a duplicate, so such a statement cannot
 * raise `duplicate key` and is skipped.
 */
export function parseFixtureInsert(statement) {
  const head = INSERT_HEAD_RE.exec(statement);
  if (!head) return null;
  const table = head[1].toLowerCase();
  if (!CONTENT_TABLES.includes(table)) return null;
  if (/\bON\s+CONFLICT\b/i.test(statement)) return null;

  const columns = columnNames(head[2]);
  const idIndex = columns.indexOf("id");
  if (idIndex === -1) return null; // generated id — cannot collide

  const rest = statement.slice(head.index + head[0].length);
  const ids = [];

  const directValues = /^\s*VALUES\s*(?=\()/i.exec(rest);
  if (directValues) {
    const { tuples } = readTupleList(rest, directValues[0].length);
    for (const tuple of tuples) {
      const id = literalOf(tuple[idIndex] ?? "");
      if (id) ids.push(id);
    }
    return { table, ids };
  }

  const select = /^\s*SELECT\b/i.exec(rest);
  if (!select) return null;

  const series = GENERATE_SERIES_RE.exec(rest);
  const projection = splitTopLevelCommas(
    rest.slice(select[0].length, series ? series.index : rest.length),
  );
  const field = projection[idIndex];
  if (!field) return { table, ids };

  const literal = literalOf(field);
  if (literal) return { table, ids: [literal] };

  const concat = CONCAT_SERIES_RE.exec(field.trim());
  if (concat && series) {
    const prefix = concat[1].replace(/''/g, "'");
    for (let n = Number(series[1]); n <= Number(series[2]); n += 1) ids.push(`${prefix}${n}`);
  }
  return { table, ids };
}

/**
 * Compare fixture ids against the ids the migrations create on a blank DB.
 *
 * Same table = a hard `duplicate key` the moment the fixture runs (#557): the
 * content tables carry no `ON CONFLICT` escape in the fixtures. Different
 * tables = harmless today (the PK is per table) but one table change away from
 * becoming the same bug, so it is reported as advisory only.
 *
 * Fixture-vs-fixture collisions are NOT a finding: every pgTAP file is wrapped
 * in `BEGIN; … ROLLBACK;`, so two files may reuse an id freely.
 */
export function findFixtureCollisions(files, created) {
  const collisions = [];
  const overlaps = [];

  for (const { file, sql } of files) {
    for (const statement of splitStatements(sql)) {
      const fixture = parseFixtureInsert(statement);
      if (!fixture) continue;
      for (const id of fixture.ids) {
        if (created[fixture.table]?.has(id)) {
          collisions.push({ file, table: fixture.table, id });
          continue;
        }
        const other = CONTENT_TABLES.find((t) => t !== fixture.table && created[t]?.has(id));
        if (other) overlaps.push({ file, table: fixture.table, id, migrationTable: other });
      }
    }
  }

  return { collisions, overlaps };
}

// ---------------------------------------------------------------------------
// Duplicate versions
// ---------------------------------------------------------------------------

/**
 * Two migrations sharing a 14-digit version. Supabase keys `schema_migrations`
 * by that version, so one of the pair is silently never recorded — and on a
 * blank DB the apply order between them is undefined. Near-miss on 2026-07-20
 * between `20260720190000_exercises_mode_check.sql` and étude 22 lot 5.
 */
export function findDuplicateVersions(filenames) {
  const byVersion = new Map();
  for (const name of filenames) {
    const version = path.basename(name).match(VERSION_RE)?.[1];
    if (!version) continue;
    byVersion.set(version, [...(byVersion.get(version) ?? []), path.basename(name)]);
  }
  return [...byVersion.entries()]
    .filter(([, names]) => names.length > 1)
    .map(([version, names]) => ({ version, files: names.sort() }));
}

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

function readSqlDir(dir) {
  return readdirSync(dir)
    .filter((name) => name.endsWith(".sql"))
    .sort()
    .map((name) => ({
      file: `${dir}/${name}`,
      sql: readFileSync(path.join(dir, name), "utf8"),
    }));
}

function flag(name, fallback) {
  const i = process.argv.indexOf(name);
  return i !== -1 && process.argv[i + 1] ? process.argv[i + 1] : fallback;
}

function main() {
  const verbose = process.argv.includes("--verbose");
  const migrationsDir = flag("--migrations", MIGRATIONS_DIR);
  const testsDir = flag("--tests", TESTS_DIR);

  const migrations = readSqlDir(migrationsDir);
  const tests = readSqlDir(testsDir);

  const duplicates = findDuplicateVersions(migrations.map((m) => m.file));
  const { created, orphans, unresolved } = replayMigrations(migrations);
  const { collisions, overlaps } = findFixtureCollisions(tests, created);

  const counts = CONTENT_TABLES.map((t) => `${t}=${created[t].size}`).join(" ");
  console.log(
    `[migration-chain] replayed ${migrations.length} migrations, ${tests.length} pgTAP files — rows on a blank DB: ${counts}`,
  );
  if (unresolved && verbose) {
    console.log(`[migration-chain] ${unresolved} reference(s) were expressions, not literals.`);
  }

  for (const dup of duplicates) {
    console.error(
      `::error file=${migrationsDir}/${dup.files[0]}::Duplicate migration version ${dup.version}: ` +
        `${dup.files.join(", ")}. Supabase keys schema_migrations by version — one of them would ` +
        `never be recorded. Re-timestamp all but one.`,
    );
  }

  const distinctOrphans = summarizeOrphans(orphans);
  for (const o of distinctOrphans.slice(0, MAX_ANNOTATIONS)) {
    const scope = o.rows > 1 ? ` (${o.rows} rows)` : "";
    console.error(
      `::error file=${o.file}::Orphan reference: ${o.table}.${o.column} = "${o.value}"${scope} has ` +
        `no row in ${o.parent} at this point of the chain. A blank database cannot be rebuilt — the ` +
        `migration fails on ${o.table}_${o.column}_fkey. Either add the parent, or guard the ` +
        `INSERT with WHERE EXISTS (SELECT 1 FROM public.${o.parent} p WHERE p.id = v.${o.column}) ` +
        `as #548/#552 did.`,
    );
  }
  if (distinctOrphans.length > MAX_ANNOTATIONS) {
    console.error(
      `::error::… and ${distinctOrphans.length - MAX_ANNOTATIONS} more orphan reference(s) not ` +
        `annotated. Run \`npm run db:check-chain\` locally for the full list.`,
    );
  }

  for (const c of collisions.slice(0, MAX_ANNOTATIONS)) {
    console.error(
      `::error file=${c.file}::Fixture id "${c.id}" (${c.table}) is also created by the migrations. ` +
        `pgTAP fixtures insert without ON CONFLICT, so this is a duplicate key on a blank DB (#557). ` +
        `Move the fixture into the reserved test namespace (7e57<file-number>-…).`,
    );
  }
  if (collisions.length > MAX_ANNOTATIONS) {
    console.error(
      `::error::… and ${collisions.length - MAX_ANNOTATIONS} more fixture collision(s) not annotated.`,
    );
  }

  if (overlaps.length) {
    console.log(
      `[migration-chain] note: ${overlaps.length} fixture id(s) also exist in the migrations but in a ` +
        `DIFFERENT table — harmless today (per-table PK), fragile if either side moves table.` +
        (verbose ? "" : " Re-run with --verbose to list them."),
    );
    if (verbose) {
      for (const o of overlaps) {
        console.log(`  ${o.file}: ${o.id} — fixture ${o.table} vs migration ${o.migrationTable}`);
      }
    }
  }

  const failures = duplicates.length + distinctOrphans.length + collisions.length;
  if (failures > 0) {
    throw new Error(
      `${distinctOrphans.length} orphan reference(s) across ${orphans.length} row(s), ` +
        `${collisions.length} fixture collision(s), ${duplicates.length} duplicate version(s) ` +
        `— see annotations above.`,
    );
  }
  console.log("[migration-chain] OK — a blank database rebuilds from this chain.");
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
