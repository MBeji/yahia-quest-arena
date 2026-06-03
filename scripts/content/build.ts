/**
 * Content pipeline CLI.
 *
 * Reads the versioned content tree under `content/`, validates every file
 * against the Zod schemas, and (unless `--check`) emits one idempotent
 * Supabase migration per subject into `supabase/migrations/`.
 *
 * Run with Node's built-in TypeScript support:
 *   node --experimental-strip-types scripts/content/build.ts [options]
 *
 * Options:
 *   --check                 Validate only; write nothing. Exits 1 on error.
 *   --subject <id>          Restrict to a single subject (default: all).
 *   --content-dir <path>    Content root (default: content).
 *   --out-dir <path>        Migrations output dir (default: supabase/migrations).
 *   --timestamp <stamp>     Override the YYYYMMDDHHMMSS migration prefix.
 *
 * The core logic lives in src/shared/content (typed, linted, unit-tested);
 * this file is only the thin filesystem + CLI shell.
 */
import { mkdirSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { argv, cwd, exit, stderr, stdout } from "node:process";
import { buildMigrationSql } from "../../src/shared/content/sql-builder.ts";
import {
  ContentValidationError,
  loadAllSubjects,
  loadSubject,
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
  const checkOnly = hasFlag("check");
  const onlySubject = getFlag("subject");
  const baseStamp = getFlag("timestamp") ?? defaultTimestamp();

  const subjects = onlySubject
    ? [loadSubject(join(contentDir, onlySubject))]
    : loadAllSubjects(contentDir);

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

    if (checkOnly) return;

    const sql = buildMigrationSql(subject);
    const stamp = bumpTimestamp(baseStamp, index);
    const fileName = `${stamp}_generated_${subject.meta.id}_content.sql`;
    mkdirSync(outDir, { recursive: true });
    writeFileSync(join(outDir, fileName), `${sql}\n`, "utf8");
    stdout.write(`  → ${fileName}\n`);
  });

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
