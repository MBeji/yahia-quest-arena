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
