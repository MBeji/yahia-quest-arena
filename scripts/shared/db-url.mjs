/**
 * Shared, side-effect-free Postgres connection-string normalizer.
 *
 * Extracted from scripts/e2e/_env.mjs so BOTH the TEST e2e tooling (which must
 * never touch prod) and the PROD migration tooling (scripts/db/push-prod.mjs)
 * reuse the exact same password-encoding logic — without importing each other's
 * safety guards (e2e refuses prod; push-prod refuses test).
 *
 * Normalize a Postgres connection string whose PASSWORD may contain raw special
 * characters (`#`, `@`, `%`, spaces…). The Supabase CLI (Go) rejects such URLs
 * with "invalid userinfo". Idempotent: an already-encoded URL round-trips
 * unchanged (decode → encode). Only the userinfo (user:password before the LAST
 * `@`) is rewritten; the host/port/db part is left as-is.
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
