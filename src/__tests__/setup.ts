import "@testing-library/jest-dom/vitest";

// Unit tests are hermetic — they must never see the repo-root `.env.test`
// (the DOCUMENTED local e2e setup, see e2e/README.md). The suite includes
// scripts/**/__tests__ whose modules import scripts/e2e/_env.mjs for its pure
// helpers; that module's side effect dotenv-loads `.env.test` into process.env
// of the SHARED vitest worker, and the server-side Supabase modules read
// process.env.SUPABASE_URL — flipping in-process server-fn tests from mocks to
// real network calls (5s timeouts). setupFiles run before each test file's
// imports, so purging here shields every file deterministically. Tests that
// need these vars set them explicitly (e.g. auth-middleware.test.ts).
for (const key of [
  "SUPABASE_URL",
  "SUPABASE_PUBLISHABLE_KEY",
  "SUPABASE_SERVICE_ROLE_KEY",
  "VITE_SUPABASE_URL",
  "VITE_SUPABASE_PUBLISHABLE_KEY",
  "E2E_USER_PASSWORD",
  "TEST_SUPABASE_DB_URL",
]) {
  delete process.env[key];
}
