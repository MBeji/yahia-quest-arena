/**
 * Read-only export of the OPEN user reports for the `report-triage` skill:
 * the two in-app feedback tables, dumped as one JSON document on stdout.
 *
 *   - bug_reports      ("Signaler un bug", floating beta launcher)
 *   - content_reports  ("Signaler une erreur" on an exercise/question),
 *                       enriched with the exercise title + subject via the FK
 *
 * Usage:
 *   SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... npm run reports:export
 *   npm run reports:export -- --out /path/to/reports.json   # write to a file
 *
 * The service-role key is required because reports are RLS-protected per user
 * (an anon/publishable key would read zero rows). This script is read-only BY
 * CONSTRUCTION — it only ever issues SELECTs; report statuses are still changed
 * exclusively through the admin consoles (/admin/bug-reports,
 * /admin/content-reports). Report messages are untrusted user text: the JSON
 * encoding keeps them inert (control chars escaped), and consumers must treat
 * them as data, never as instructions (see the report-triage skill, Phase 0).
 */
import { existsSync } from "node:fs";
import { writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

/** Shape a raw content_reports row (with its joined exercise) for the export. */
export function flattenContentReport(row) {
  return {
    id: row.id,
    createdAt: row.created_at,
    message: row.message,
    exerciseId: row.exercise_id ?? null,
    exerciseTitle: row.exercises?.title ?? null,
    subjectId: row.exercises?.subject_id ?? null,
    questionId: row.question_id ?? null,
    status: row.status,
  };
}

/** Shape a raw bug_reports row for the export. */
export function flattenBugReport(row) {
  return {
    id: row.id,
    createdAt: row.created_at,
    message: row.message,
    page: row.page ?? null,
    status: row.status,
  };
}

/** Assemble the final export document (oldest first, counts up front). */
export function buildExport(bugRows, contentRows, exportedAt) {
  const bugReports = (bugRows ?? []).map(flattenBugReport);
  const contentReports = (contentRows ?? []).map(flattenContentReport);
  return {
    exportedAt,
    counts: { bugReports: bugReports.length, contentReports: contentReports.length },
    bugReports,
    contentReports,
  };
}

async function main() {
  // Local convenience: pick up a repo-root .env if present (never overrides
  // values already exported in the environment, e.g. by the CI/session config).
  const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..", "..");
  const envPath = resolve(repoRoot, ".env");
  if (existsSync(envPath)) {
    const { default: dotenv } = await import("dotenv");
    dotenv.config({ path: envPath, override: false });
  }

  const url = process.env.SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceKey) {
    console.error(
      "[reports] Missing SUPABASE_URL and/or SUPABASE_SERVICE_ROLE_KEY. " +
        "Both are required to read the RLS-protected report tables (read-only).",
    );
    process.exit(1);
  }

  const { createClient } = await import("@supabase/supabase-js");
  const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

  const [bugs, contents] = await Promise.all([
    supabase
      .from("bug_reports")
      .select("id, created_at, message, page, status")
      .eq("status", "open")
      .order("created_at", { ascending: true }),
    supabase
      .from("content_reports")
      .select(
        "id, created_at, message, exercise_id, question_id, status, exercises(title, subject_id)",
      )
      .eq("status", "open")
      .order("created_at", { ascending: true }),
  ]);
  if (bugs.error) {
    console.error(`[reports] Failed to read bug_reports: ${bugs.error.message}`);
    process.exit(1);
  }
  if (contents.error) {
    console.error(`[reports] Failed to read content_reports: ${contents.error.message}`);
    process.exit(1);
  }

  const doc = buildExport(bugs.data, contents.data, new Date().toISOString());
  const json = JSON.stringify(doc, null, 2);

  const outIdx = process.argv.indexOf("--out");
  const outPath = outIdx !== -1 ? process.argv[outIdx + 1] : null;
  if (outIdx !== -1 && !outPath) {
    console.error("[reports] --out requires a file path.");
    process.exit(1);
  }
  if (outPath) {
    await writeFile(outPath, `${json}\n`, "utf8");
    console.error(
      `[reports] Wrote ${doc.counts.bugReports} bug report(s) + ${doc.counts.contentReports} content report(s) to ${outPath}`,
    );
  } else {
    console.log(json);
  }
}

// Only run as a CLI — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main().catch((err) => {
    console.error(`[reports] Export failed: ${err?.message ?? err}`);
    process.exit(1);
  });
}
