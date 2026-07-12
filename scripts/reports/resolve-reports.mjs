/**
 * Closure writer of the report-triage pipeline: marks user reports
 * `resolved` (or `dismissed`) in bug_reports / content_reports once the fix
 * that addresses them has MERGED to main (deploy is automatic from there).
 *
 * Driven by report-close.yml, which passes the merged PR's body: the reports
 * to close are identified by the trailer lines the triage agent appends,
 * exactly one per report:
 *
 *   Report-Id: <uuid> (bug)        → bug_reports
 *   Report-Id: <uuid> (content)    → content_reports
 *
 * Usage:
 *   SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... \
 *     node scripts/reports/resolve-reports.mjs --body-file pr-body.txt [--status resolved]
 *
 * Safety model — this is the ONLY write path in the pipeline, and it is
 * narrow by construction: strict UUID parsing (anything else in the body is
 * ignored), a two-value status whitelist, and the UPDATE only touches rows
 * still `open` (re-running on an already-closed report is a no-op).
 * `resolved_by` stays NULL: there is no acting admin user in this context —
 * the merged PR referenced by the trailer is the audit trail.
 */
import { readFile } from "node:fs/promises";
import { pathToFileURL } from "node:url";

export const TABLES = { bug: "bug_reports", content: "content_reports" };
const STATUSES = ["resolved", "dismissed"];

/**
 * Extract the report trailers from a PR body. Strict on purpose: full-line
 * match, canonical UUID shape, known channel — untrusted surrounding text
 * cannot smuggle anything else in. Returns de-duplicated, lowercased ids.
 */
export function parseReportTrailers(text) {
  const out = { bug: [], content: [] };
  if (!text) return out;
  const re =
    /^\s*Report-Id:\s*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})\s*\((bug|content)\)\s*$/gim;
  let m;
  while ((m = re.exec(text))) {
    const list = out[m[2].toLowerCase()];
    const id = m[1].toLowerCase();
    if (!list.includes(id)) list.push(id);
  }
  return out;
}

async function main() {
  const bodyIdx = process.argv.indexOf("--body-file");
  const bodyPath = bodyIdx !== -1 ? process.argv[bodyIdx + 1] : null;
  if (!bodyPath) {
    console.error("[reports] --body-file <path> is required.");
    process.exit(1);
  }
  const statusIdx = process.argv.indexOf("--status");
  const status = statusIdx !== -1 ? process.argv[statusIdx + 1] : "resolved";
  if (!STATUSES.includes(status)) {
    console.error(`[reports] Invalid --status "${status}" (allowed: ${STATUSES.join(", ")}).`);
    process.exit(1);
  }

  const trailers = parseReportTrailers(await readFile(bodyPath, "utf8"));
  const total = trailers.bug.length + trailers.content.length;
  if (total === 0) {
    console.log("[reports] No Report-Id trailer found — nothing to close.");
    return;
  }

  const url = process.env.SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceKey) {
    console.error("[reports] Missing SUPABASE_URL and/or SUPABASE_SERVICE_ROLE_KEY.");
    process.exit(1);
  }
  const { createClient } = await import("@supabase/supabase-js");
  const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

  for (const [channel, table] of Object.entries(TABLES)) {
    const ids = trailers[channel];
    if (ids.length === 0) continue;
    const { data, error } = await supabase
      .from(table)
      .update({ status, resolved_at: new Date().toISOString() })
      .in("id", ids)
      .eq("status", "open")
      .select("id");
    if (error) {
      console.error(`[reports] Failed to update ${table}: ${error.message}`);
      process.exit(1);
    }
    const touched = data?.length ?? 0;
    console.log(
      `[reports] ${table}: ${touched}/${ids.length} report(s) marked ${status}` +
        (touched < ids.length ? " (the rest were already closed or unknown)" : ""),
    );
  }
}

// Only run as a CLI — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main().catch((err) => {
    console.error(`[reports] Close failed: ${err?.message ?? err}`);
    process.exit(1);
  });
}
