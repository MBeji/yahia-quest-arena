/**
 * Content pipeline CLI.
 *
 * Reads the versioned content tree under `content/`, validates every file
 * against the Zod schemas, and (unless `--check`) emits one idempotent
 * Supabase migration per COMPILED subject into `supabase/migrations/`.
 * A shared directory (`compileTo`, étude 16 D-4) expands to N compiled
 * subjects — and therefore N migration files — in one run.
 *
 * Run with Node's built-in TypeScript support:
 *   node --experimental-strip-types scripts/content/build.ts [options]
 *
 * Options:
 *   --check                 Validate only; write nothing. Exits 1 on error.
 *   --subject <dir>         Restrict to a single subject DIRECTORY (default:
 *                           all). The value is the source folder name under
 *                           content/ — for a shared dir this regenerates every
 *                           compiled target it declares.
 *   --competences           Emit ONLY the competency-registry migration
 *                           (content/competences/*.json — étude 07 D-1);
 *                           subjects are validated but not regenerated.
 *   --content-dir <path>    Content root (default: content).
 *   --out-dir <path>        Migrations output dir (default: supabase/migrations).
 *   --timestamp <stamp>     Override the YYYYMMDDHHMMSS migration prefix.
 *   --sql-dir <path>        Emit STABLE per-subject files (<subjectId>.sql) into
 *                           <path> instead of timestamped migrations — the
 *                           content-SQL channel of étude 24 (D-3): the corpus
 *                           leaves the Supabase migration framework, which
 *                           cannot host two repos on one database. Idempotent
 *                           by construction (UUIDv5 upsert + subject-scoped
 *                           prune), so a stable name regenerated in place is
 *                           safe to replay and yields a readable per-subject
 *                           diff. Ignored by --check.
 *
 * The core logic lives in src/shared/content (typed, linted, unit-tested);
 * this file is only the thin filesystem + CLI shell.
 */
import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { argv, cwd, exit, stderr, stdout } from "node:process";
import {
  COMPETENCES_SQL_FILE_NAME,
  buildCompetencyRegistryMigrationSql,
  buildMigrationSql,
  contentSqlFileName,
} from "../../src/shared/content/sql-builder.ts";
import {
  ContentValidationError,
  expandSubjects,
  loadAllSubjects,
  loadCompetencyRegistries,
  loadMisconceptionRegistry,
  loadSubject,
  loadVideosRegistry,
} from "../../src/shared/content/loader.ts";

function getFlag(name: string): string | undefined {
  const i = argv.indexOf(`--${name}`);
  return i !== -1 ? argv[i + 1] : undefined;
}
const hasFlag = (name: string): boolean => argv.includes(`--${name}`);

function defaultTimestamp(): string {
  const d = new Date();
  const pad = (n: number) => String(n).padStart(2, "0");
  return (
    `${d.getUTCFullYear()}${pad(d.getUTCMonth() + 1)}${pad(d.getUTCDate())}` +
    `${pad(d.getUTCHours())}${pad(d.getUTCMinutes())}${pad(d.getUTCSeconds())}`
  );
}

/** Add `seconds` to a YYYYMMDDHHMMSS stamp (keeps files ordered & unique). */
function bumpTimestamp(stamp: string, seconds: number): string {
  const y = +stamp.slice(0, 4);
  const mo = +stamp.slice(4, 6);
  const da = +stamp.slice(6, 8);
  const h = +stamp.slice(8, 10);
  const mi = +stamp.slice(10, 12);
  const s = +stamp.slice(12, 14);
  const d = new Date(Date.UTC(y, mo - 1, da, h, mi, s + seconds));
  const pad = (n: number) => String(n).padStart(2, "0");
  return (
    `${d.getUTCFullYear()}${pad(d.getUTCMonth() + 1)}${pad(d.getUTCDate())}` +
    `${pad(d.getUTCHours())}${pad(d.getUTCMinutes())}${pad(d.getUTCSeconds())}`
  );
}

function main(): void {
  const root = cwd();
  const contentDir = resolve(root, getFlag("content-dir") ?? "content");
  const outDir = resolve(root, getFlag("out-dir") ?? "supabase/migrations");
  // étude 24 D-3: when set, the corpus is emitted as stable per-subject files
  // outside the migration framework (see the --sql-dir note above).
  const sqlDirFlag = getFlag("sql-dir");
  const sqlDir = sqlDirFlag ? resolve(root, sqlDirFlag) : undefined;
  const checkOnly = hasFlag("check");
  const competencesOnly = hasFlag("competences");
  const onlySubject = getFlag("subject");
  const baseStamp = getFlag("timestamp") ?? defaultTimestamp();

  // Validate the misconception registry structure up front (étude 04 D-4) so a
  // malformed content/misconceptions.json fails content:check; usage of unknown
  // tags is cross-checked by content:qa.
  loadMisconceptionRegistry(contentDir);

  // Same guarantee for the competency family registries (étude 07 D-1): shape,
  // trilingual labels, same-family prereqs and DAG-ness (R-3) all fail
  // content:check; usage of unknown ids is cross-checked by content:qa.
  const competencyRegistries = loadCompetencyRegistries(contentDir);

  // Curated-video registry (étude 23 D-2): validate its structure up front (a
  // malformed content/videos.json fails content:check) and resolve chapter/
  // exercise refs into the compiled JSONB columns; unknown/non-active/lang
  // mismatches are cross-checked by content:qa.
  const videosRegistry = loadVideosRegistry(contentDir);

  // Expansion (étude 16 D-4): shared `compileTo` dirs become their compiled
  // per-section subjects here; everything downstream keys on compiled ids.
  // In all-subjects mode expandSubjects proves global id uniqueness by itself;
  // in --subject mode the sibling directories are not loaded, so guard the
  // cheap cross-dir case (a target id shadowing a physical dir) explicitly —
  // the full cross-dir check runs in CI via `content:check` (all subjects).
  const subjects = expandSubjects(
    onlySubject ? [loadSubject(join(contentDir, onlySubject))] : loadAllSubjects(contentDir),
  );
  if (onlySubject) {
    for (const s of subjects) {
      if (s.meta.id !== onlySubject && existsSync(join(contentDir, s.meta.id, "subject.json"))) {
        throw new ContentValidationError(
          `Compiled subject id '${s.meta.id}' collides with the physical directory content/${s.meta.id}`,
        );
      }
    }
  }

  if (subjects.length === 0) {
    stderr.write(`No subjects found under ${contentDir}\n`);
    exit(1);
  }

  let chapterTotal = 0;
  let exerciseTotal = 0;
  let questionTotal = 0;

  subjects.forEach((subject, index) => {
    const chapters = subject.chapters.length;
    const exercises = subject.chapters.reduce((n, c) => n + c.exercises.length, 0);
    const questions = subject.chapters.reduce(
      (n, c) => n + c.exercises.reduce((m, e) => m + e.data.questions.length, 0),
      0,
    );
    chapterTotal += chapters;
    exerciseTotal += exercises;
    questionTotal += questions;

    stdout.write(
      `✓ ${subject.meta.id}: ${chapters} chapters, ${exercises} exercises, ${questions} questions\n`,
    );

    // --competences regenerates the registry only: subjects are validated
    // (they still count in the summary) but their migrations stay untouched.
    if (checkOnly || competencesOnly) return;

    const sql = buildMigrationSql(subject, videosRegistry);
    // Same SQL either way — only the destination and the naming differ: a
    // one-shot timestamped migration, or the stable file the content channel
    // regenerates in place (étude 24 D-3).
    const dir = sqlDir ?? outDir;
    const fileName = sqlDir
      ? contentSqlFileName(subject.meta.id)
      : `${bumpTimestamp(baseStamp, index)}_generated_${subject.meta.id}_content.sql`;
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, fileName), `${sql}\n`, "utf8");
    stdout.write(`  → ${fileName}\n`);
  });

  if (competencyRegistries.length > 0) {
    const competencyTotal = competencyRegistries.reduce((n, r) => n + r.competencies.length, 0);
    stdout.write(
      `✓ competences: ${competencyRegistries.length} family(ies), ${competencyTotal} competencies\n`,
    );
    if (competencesOnly && !checkOnly) {
      const sql = buildCompetencyRegistryMigrationSql(competencyRegistries);
      // The registries follow the corpus into the private repo (étude 24 D-6),
      // so they ride the same channel as the subjects.
      const dir = sqlDir ?? outDir;
      const fileName = sqlDir
        ? COMPETENCES_SQL_FILE_NAME
        : `${baseStamp}_generated_competences_registry.sql`;
      mkdirSync(dir, { recursive: true });
      writeFileSync(join(dir, fileName), `${sql}\n`, "utf8");
      stdout.write(`  → ${fileName}\n`);
    }
  } else if (competencesOnly) {
    stderr.write(`No competency registries found under ${join(contentDir, "competences")}\n`);
    exit(1);
  }

  stdout.write(
    `\n${checkOnly ? "Validated" : "Built"} ${subjects.length} subject(s): ` +
      `${chapterTotal} chapters, ${exerciseTotal} exercises, ${questionTotal} questions.\n`,
  );
}

try {
  main();
} catch (err) {
  if (err instanceof ContentValidationError) {
    stderr.write(`\n✗ ${err.message}\n`);
  } else {
    stderr.write(`\n✗ Unexpected error: ${(err as Error).stack ?? String(err)}\n`);
  }
  exit(1);
}
