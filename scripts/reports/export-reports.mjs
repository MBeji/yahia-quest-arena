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
import { PROD_SUPABASE_REF, prodTargetReason } from "../shared/prod-targets.mjs";

/**
 * Refuse to export from anything but PRODUCTION.
 *
 * This is the mirror image of the e2e guard: those tools must NEVER touch prod,
 * this one must ONLY touch prod — same posture as `scripts/db/push-prod.mjs`.
 *
 * Why it exists: pointed at the TEST project, this script produces a perfectly
 * well-formed export of the wrong database. Nothing fails, nothing warns — the
 * triage loop simply goes blind to real users while looking busy. That happened:
 * from 2026-07-17 to 2026-07-27 the triage read TEST, where the nightly e2e
 * suite files one `content_reports` row and `reset-gameplay` wipes it before the
 * next run. The result reads exactly like a daily write to production
 * (a new report id every morning, always the same message) — and was reported as
 * such in #614 and #638. An empty file would have been noticed; a plausible one
 * was not. Hence the assertion: a silent wrong answer is worse than a loud stop.
 *
 * @param {string} url the `SUPABASE_URL` this run would read
 * @returns {string} the same url, when it is production
 * @throws {Error} when it is not
 */
export function assertProdReportSource(url) {
  if (prodTargetReason(url) === "supabase") return url;
  throw new Error(
    `[reports] Refusing to export: SUPABASE_URL does not point at PRODUCTION ` +
      `(expected the project ref ${PROD_SUPABASE_REF}, got ${url}). ` +
      `The triage file must describe the reports REAL users filed — reading any ` +
      `other project yields a plausible export of the wrong database. ` +
      `In CI, check the PROD_SUPABASE_URL / PROD_SUPABASE_SERVICE_ROLE_KEY secrets.`,
  );
}

/**
 * Refuse a `SUPABASE_URL` that is not a URL at all — and say so by name.
 *
 * `assertProdReportSource` above answers "is this the right PROJECT?" and, by
 * design, accepts a bare host or even the bare ref (`prodTargetReason` matches
 * the ref as a substring). `createClient` answers a different question and is
 * far stricter: it trims, then demands an explicit `http://`/`https://` scheme.
 * A value can therefore clear the prod guard and still be unusable — and the
 * only thing the operator sees is supabase-js's own message, which names
 * neither the secret nor the workflow:
 *
 *     [reports] Export failed: Invalid supabaseUrl: Must be a valid HTTP or HTTPS URL.
 *
 * That is not hypothetical. Between 2026-07-29 14:35 and 2026-08-09 the
 * `PROD_SUPABASE_URL` secret lost its scheme, and every scheduled triage failed
 * on that one line — 6 runs a day, ~66 in all, on an unchanged tree (the run at
 * 10:58 and the one at 14:35 were the SAME commit, a129d7de). The workflow's own
 * pre-flight could not catch it: it only tests that the secret is non-empty, so
 * a malformed value walks straight past it. Eleven days of user reports went
 * untriaged behind an error that pointed at a library.
 *
 * So this check exists to name the culprit, not to repair it. Expanding a bare
 * host into `https://…` would be guessing at the operator's intent and would
 * paper over a misconfigured secret — the same "plausible but wrong" failure
 * `assertProdReportSource` was written to prevent. A loud, precise stop is the
 * whole point.
 *
 * The rule mirrors supabase-js's own (trim, then require the scheme) so the two
 * cannot drift apart and re-open this exact gap.
 *
 * @param {string} url the `SUPABASE_URL` this run would hand to `createClient`
 * @returns {string} the trimmed url, when it is usable
 * @throws {Error} when it carries no http(s) scheme
 */
export function assertUsableSupabaseUrl(url) {
  const trimmed = String(url).trim();
  if (/^https?:\/\//i.test(trimmed)) return trimmed;
  throw new Error(
    `[reports] Refusing to export: SUPABASE_URL is not a usable URL — it carries no ` +
      `http(s):// scheme (got ${JSON.stringify(url)}). ` +
      `Expected the full API URL, scheme included: https://${PROD_SUPABASE_REF}.supabase.co ` +
      `— a bare host or a bare project ref clears the production guard above and then ` +
      `dies inside supabase-js. In CI, fix the PROD_SUPABASE_URL secret of report-triage.yml.`,
  );
}

/** Shape a raw content_reports row (with its joined exercise) for the export. */
export function flattenContentReport(row) {
  return {
    id: row.id,
    createdAt: row.created_at,
    // Account identity, needed for the two abuse duties the skill already states but the
    // export could not support: the deterministic burst detection of the triage pre-gate
    // (scripts/ci/report-triage-pregate.mjs) and the "Abus / récidive" section of the Phase 5
    // report. It is an opaque auth UUID — never surfaced to a student, never a display name.
    userId: row.user_id ?? null,
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
    userId: row.user_id ?? null, // see flattenContentReport
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

  // Right project first (the safety property), then usable at all (well-formedness):
  // a wrong project must be named as such whether or not it carries a scheme.
  let apiUrl;
  try {
    assertProdReportSource(url);
    apiUrl = assertUsableSupabaseUrl(url);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }

  const { createClient } = await import("@supabase/supabase-js");
  const supabase = createClient(apiUrl, serviceKey, { auth: { persistSession: false } });

  const [bugs, contents] = await Promise.all([
    supabase
      .from("bug_reports")
      .select("id, created_at, user_id, message, page, status")
      .eq("status", "open")
      .order("created_at", { ascending: true }),
    supabase
      .from("content_reports")
      .select(
        "id, created_at, user_id, message, exercise_id, question_id, status, exercises(title, subject_id)",
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
