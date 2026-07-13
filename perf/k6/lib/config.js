// Shared configuration for the k6 load suite.
//
// All scenarios target the Supabase PostgREST layer directly (the same RPC/REST
// surface the SSR server functions call). This isolates the database + RLS +
// PostgREST tier — the part of the stack that scales the hardest — from the
// Vercel SSR layer, so a red run points at the DB, not at cold starts.
//
// NEVER point this at production. Use a dedicated load-test Supabase project
// seeded with throwaway users. The runner refuses the known prod ref as a guard.
import { fail } from "k6";

// Known production project ref — the suite refuses to run against it.
// Mirrors PROD_REFS in scripts/e2e/_env.mjs; keep in sync.
const PROD_REF = "fasrenmmrkqjoobrztbp";

export const SUPABASE_URL = (__ENV.LOAD_SUPABASE_URL || "").replace(/\/+$/, "");
export const ANON_KEY = __ENV.LOAD_SUPABASE_ANON_KEY || "";

// Comma-separated list of pre-minted user JWTs (access tokens) for seeded
// load-test students. Each VU picks one by index so concurrent virtual users
// exercise distinct rows (distinct profiles, sessions, attempts) — a single
// shared token would serialize on one profile's FOR UPDATE lock and hide
// real contention. Mint them with scripts/perf/mint-load-tokens.mjs.
export const USER_JWTS = (__ENV.LOAD_USER_JWTS || "")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);

// Optional fixtures so write scenarios hit real rows. Comma-separated UUIDs.
export const EXERCISE_IDS = (__ENV.LOAD_EXERCISE_IDS || "")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);
export const SUBJECT_IDS = (__ENV.LOAD_SUBJECT_IDS || "")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);

export function assertConfig({ needUsers = true, needExercises = false } = {}) {
  if (!SUPABASE_URL) fail("LOAD_SUPABASE_URL is required");
  if (!ANON_KEY) fail("LOAD_SUPABASE_ANON_KEY is required");
  if (SUPABASE_URL.includes(PROD_REF)) {
    fail(
      `Refusing to load-test the known production ref (${PROD_REF}). Use a dedicated test project.`,
    );
  }
  if (needUsers && USER_JWTS.length === 0) {
    fail("LOAD_USER_JWTS is required (comma-separated seeded user access tokens)");
  }
  if (needExercises && EXERCISE_IDS.length === 0) {
    fail("LOAD_EXERCISE_IDS is required for gameplay scenarios (comma-separated exercise UUIDs)");
  }
}

// Round-robin a fixture list by the VU id so virtual users spread across rows.
export function pick(list, vu) {
  return list[(vu - 1) % list.length];
}
