/**
 * Shared env bootstrap for every e2e tooling script (seed / reset / db push).
 *
 * - Loads `.env.test` (repo root) for LOCAL runs so you don't have to export the
 *   TEST project vars by hand. In CI the file is absent and the workflow provides
 *   env directly, so `override: false` never clobbers the CI-provided values.
 * - Hard safety net: refuses to run if any resolved Supabase URL points at the
 *   known PRODUCTION project. e2e tooling must only ever touch the TEST project.
 *
 * Import this for its side effects FIRST, before reading any SUPABASE_* var:
 *   import "./_env.mjs";
 */
import { existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import dotenv from "dotenv";

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..", "..");
const envTestPath = resolve(repoRoot, ".env.test");

if (existsSync(envTestPath)) {
  dotenv.config({ path: envTestPath, override: false });
}

/** Project refs that must NEVER be touched by e2e tooling. */
export const PROD_REFS = ["fasrenmmrkqjoobrztbp"];

/**
 * Normalize a Postgres connection string whose PASSWORD may contain raw
 * special characters (`#`, `@`, `%`, spaces…). The Supabase CLI (Go) rejects
 * such URLs with "invalid userinfo" — the exact failure that broke the nightly
 * e2e-auth job when TEST_SUPABASE_DB_URL held an unencoded password.
 *
 * Idempotent: an already-encoded URL round-trips unchanged (decode → encode).
 * Only the userinfo (user:password before the LAST `@`) is rewritten; the
 * host/port/db part is left as-is.
 */
export function normalizeDbUrl(raw) {
  if (!raw) return raw;
  const schemeEnd = raw.indexOf("://");
  const at = raw.lastIndexOf("@");
  if (schemeEnd === -1 || at <= schemeEnd) return raw; // no userinfo — nothing to fix
  const scheme = raw.slice(0, schemeEnd + 3);
  const userinfo = raw.slice(schemeEnd + 3, at);
  const hostPart = raw.slice(at + 1);
  const colon = userinfo.indexOf(":");
  const user = colon === -1 ? userinfo : userinfo.slice(0, colon);
  const pass = colon === -1 ? null : userinfo.slice(colon + 1);
  // Decode first so already-percent-encoded values don't get double-encoded;
  // a bare `%` that isn't a valid escape keeps the raw string.
  const reEncode = (s) => {
    let decoded = s;
    try {
      decoded = decodeURIComponent(s);
    } catch {
      /* raw '%' in the password — encode it as-is */
    }
    return encodeURIComponent(decoded);
  };
  return `${scheme}${reEncode(user)}${pass === null ? "" : `:${reEncode(pass)}`}@${hostPart}`;
}

/** Throw-and-exit if any configured Supabase URL targets production. */
export function assertNotProd() {
  const urls = [
    process.env.SUPABASE_URL,
    process.env.TEST_SUPABASE_URL,
    process.env.VITE_SUPABASE_URL,
    process.env.TEST_SUPABASE_DB_URL,
    process.env.SUPABASE_DB_URL,
  ].filter(Boolean);
  for (const url of urls) {
    if (PROD_REFS.some((ref) => url.includes(ref))) {
      console.error(
        `[e2e] Refusing to run: ${url} targets the PRODUCTION project. Use a dedicated TEST project.`,
      );
      process.exit(1);
    }
  }
}

assertNotProd();
