/**
 * Upload an official CNP student-textbook (manuel élève) PDF to the private
 * `manuel-eleve` Storage bucket, at the path convention `<code>.pdf` consumed
 * by getSubjectManuels (« Manuel officiel » card on the subject page).
 *
 * The PDF is uploaded AS-IS (decision 2026-07-16: no watermark — the official
 * book, login is the gate). The bucket is PRIVATE (RLS: read = authenticated
 * only); uploads use the service-role key, which bypasses RLS — so this script
 * runs out-of-band, never in the app.
 *
 * SECRETS: read from process.env (SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY).
 * Never hard-code them. Supply them with Node's native --env-file, e.g.
 *   PROD : node --env-file=.env      scripts/manuel/upload-pdf.mjs ... --upload
 *   TEST : node --env-file=.env.test scripts/manuel/upload-pdf.mjs ... --upload
 * The script prints the target project ref before uploading — eyeball it.
 *
 * Usage:
 *   node [--env-file=<.env>] scripts/manuel/upload-pdf.mjs \
 *     --pdf  <path/to/source.pdf> \
 *     --code <book code, e.g. 102306 or 102105P01> \
 *     [--upload]              (actually PUT; default: dry-run, checks only)
 *     [--verify]              (after upload: sign a URL + fetch it back, byte-check)
 *     [--bucket manuel-eleve]
 *
 * Exit non-zero on any check/upload/verify failure.
 */
import { existsSync, readFileSync, statSync } from "node:fs";
import { createClient } from "@supabase/supabase-js";

const argv = process.argv.slice(2);
const flag = (name, dflt) => {
  const i = argv.indexOf(`--${name}`);
  return i !== -1 && argv[i + 1] && !argv[i + 1].startsWith("--") ? argv[i + 1] : dflt;
};
const has = (name) => argv.includes(`--${name}`);

const pdfPath = flag("pdf");
const code = flag("code");
const bucket = flag("bucket", "manuel-eleve");
const doUpload = has("upload");
const doVerify = has("verify");

if (!pdfPath || !code) {
  console.error("Missing required flag(s). Need --pdf and --code. See header for usage.");
  process.exit(2);
}
if (!existsSync(pdfPath)) {
  console.error(`PDF not found: ${pdfPath}`);
  process.exit(2);
}
if (!/^[A-Za-z0-9_-]+$/.test(code)) {
  console.error(`Invalid --code "${code}" (alphanumeric/_/- only).`);
  process.exit(2);
}

const bytes = readFileSync(pdfPath);
const mb = statSync(pdfPath).size / (1024 * 1024);
// %PDF magic — refuse to ship something that is not actually a PDF.
if (bytes.subarray(0, 5).toString("latin1") !== "%PDF-") {
  console.error(`${pdfPath} does not look like a PDF (missing %PDF header).`);
  process.exit(2);
}
// Mirror the bucket's file_size_limit so failures happen here, with a clear message.
if (bytes.length > 62914560) {
  console.error(`${pdfPath} is ${mb.toFixed(1)} MB — over the bucket's 60 MB cap. Recompress it.`);
  process.exit(2);
}
console.log(`manuel pdf — ${code}.pdf  (${mb.toFixed(1)} MB, source: ${pdfPath})`);

if (!doUpload && !doVerify) {
  console.log("dry-run OK (pass --upload to actually PUT to the bucket).");
  process.exit(0);
}

const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!url || !key) {
  console.error(
    "Upload/verify need SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY in the env " +
      "(supply via: node --env-file=<.env|.env.test> ...).",
  );
  process.exit(2);
}
const ref = url.replace(/^https?:\/\//, "").split(".")[0];
console.log(`target: ${ref}.supabase.co  bucket=${bucket}`);
const supabase = createClient(url, key, { auth: { persistSession: false } });

if (doUpload) {
  const { error } = await supabase.storage
    .from(bucket)
    .upload(`${code}.pdf`, bytes, { contentType: "application/pdf", upsert: true });
  if (error) {
    console.error(`upload ${code}.pdf failed: ${error.message}`);
    process.exit(1);
  }
  console.log(`  → uploaded ${bucket}/${code}.pdf`);
}

if (doVerify) {
  const { data: signed, error: signErr } = await supabase.storage
    .from(bucket)
    .createSignedUrl(`${code}.pdf`, 120);
  if (signErr || !signed?.signedUrl) {
    console.error(`verify: could not sign ${code}.pdf: ${signErr?.message ?? "no url"}`);
    process.exit(1);
  }
  const res = await fetch(signed.signedUrl);
  const back = Buffer.from(await res.arrayBuffer());
  if (res.status !== 200 || back.length !== bytes.length) {
    console.error(
      `verify: signed URL round-trip mismatch for ${code}.pdf ` +
        `(status ${res.status}, ${back.length} vs ${bytes.length} bytes)`,
    );
    process.exit(1);
  }
  console.log(`  ✓ signed-URL round-trip (${back.length} B, HTTP ${res.status})`);
}
