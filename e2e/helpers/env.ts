/**
 * Single source of truth for the e2e environment. The app (dev server) reads the
 * VITE_/SUPABASE_ vars; the DB helpers and seed/reset scripts additionally need
 * the service-role key. All point at a DEDICATED test Supabase project — see
 * e2e/README.md.
 */

/** Shared password for all seeded test accounts (also used by `npm run e2e:seed`). */
export const E2E_PASSWORD = process.env.E2E_USER_PASSWORD ?? "E2e-Test-Passw0rd!";

/** Test-project URL the app + DB helpers talk to. */
export const SUPABASE_URL = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL ?? "";

/** Service-role key — privileged, server/CI only; never shipped to the browser. */
export const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";

/** Anon/publishable key — the browser-safe key. Used by the public-anon tier to
 *  probe the anon REST surface directly and assert the RLS invariants (the same
 *  key the app ships to anonymous visitors). */
export const SUPABASE_ANON_KEY =
  process.env.SUPABASE_PUBLISHABLE_KEY ?? process.env.VITE_SUPABASE_PUBLISHABLE_KEY ?? "";

/** Resolve the admin (service-role) config, failing fast with a clear message. */
export function requireAdminEnv(): { url: string; serviceRoleKey: string } {
  if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
    throw new Error(
      "[e2e] SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required (same vars as `npm run e2e:seed`). See e2e/README.md.",
    );
  }
  return { url: SUPABASE_URL, serviceRoleKey: SUPABASE_SERVICE_ROLE_KEY };
}

/** Resolve the public (anon) config for direct REST probes, failing fast. */
export function requirePublicEnv(): { url: string; anonKey: string } {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
    throw new Error(
      "[e2e] SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY are required for the anon REST probes. See e2e/README.md.",
    );
  }
  return { url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY };
}
