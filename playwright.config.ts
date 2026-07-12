import { defineConfig, devices } from "@playwright/test";
import { existsSync } from "node:fs";
import dotenv from "dotenv";

// --- TEST-project env (local convenience) ------------------------------------
// Load `.env.test` (repo root) so a LOCAL run — and the dev server we spawn via
// `webServer` — targets the dedicated TEST Supabase project, never your `.env`
// (which may be production). CI has no `.env.test` and injects env through the
// workflow, so this is a no-op there. `override: true` so a stale shell var
// can't silently redirect the run.
if (existsSync(".env.test")) {
  dotenv.config({ path: ".env.test", override: true });
  const required = [
    "SUPABASE_URL",
    "SUPABASE_PUBLISHABLE_KEY",
    "VITE_SUPABASE_URL",
    "VITE_SUPABASE_PUBLISHABLE_KEY",
    "SUPABASE_SERVICE_ROLE_KEY",
    "E2E_USER_PASSWORD",
  ];
  const missing = required.filter((k) => {
    const v = process.env[k];
    return !v || v.includes("your-") || v.includes("<");
  });
  if (missing.length > 0) {
    throw new Error(
      `[e2e] .env.test is present but incomplete: ${missing.join(", ")}. ` +
        "Fill it from .env.test.example (TEST project only), or delete it to run the public tier against your .env.",
    );
  }
}

// Hard safety net: never run e2e against the production project.
const PROD_REFS = ["fasrenmmrkqjoobrztbp"];
for (const maybeUrl of [process.env.SUPABASE_URL, process.env.VITE_SUPABASE_URL]) {
  if (maybeUrl && PROD_REFS.some((ref) => maybeUrl.includes(ref))) {
    throw new Error(
      `[e2e] Refusing to run: ${maybeUrl} is the PRODUCTION project. Point .env.test at the TEST project.`,
    );
  }
}

/**
 * Playwright end-to-end config — runs REAL browser journeys against the app.
 * NOT runnable in the restricted build sandbox (it blocks the browser download).
 *
 * Three tiers of tests:
 *  • PUBLIC (landing + logged-out auth redirects): need no real backend, run in
 *    the standard `E2E` workflow with dummy Supabase env.  → projects: public-*
 *  • PUBLIC-ANON (logged-out C8 content journeys): no login, but need the real
 *    TEST backend (anon reads real catalogue/course/exercise data). Run in the
 *    `E2E (authenticated)` workflow.  → project: public-anon-chromium
 *  • AUTHENTICATED (free/premium/admin/parent journeys): need the TEST Supabase
 *    project + seeded users. The `setup` project logs each role in through the
 *    UI and saves its storage state; the `authed-*` project reuses it.
 *
 * Local:
 *   npx playwright install chromium
 *   npm run test:e2e          # public only (no backend)
 *   npm run e2e:seed          # seed test users (needs SUPABASE_SERVICE_ROLE_KEY)
 *   npm run test:e2e:auth     # authenticated journeys (needs the test project)
 *
 * Point at an already-running server with PLAYWRIGHT_BASE_URL=https://…
 */
// The dev server (inline TanStack Start config, see vite.config.ts) serves on 8080 by
// default, not Vite's 5173. Override with PORT or PLAYWRIGHT_BASE_URL if a run needs to.
const baseURL = process.env.PLAYWRIGHT_BASE_URL ?? `http://localhost:${process.env.PORT ?? 8080}`;

// Folder-based convention: drop a spec in the right folder and it's picked up
// automatically — no config change needed.
//   • e2e/public/      — backendless (dummy Supabase): SSR/landing/auth smoke.
//   • e2e/public-anon/  — LOGGED-OUT but needs the real TEST backend (anon reads
//                         real content): the C8 public content journeys.
//   • e2e/authed/      — logged-in journeys against the TEST backend.
// `public/` must NOT match `public-anon/`, so anchor it to a literal slash.
const PUBLIC_SPECS = /public\/[^/]*\.spec\.ts$/;
const PUBLIC_ANON_SPECS = /public-anon\/.*\.spec\.ts/;
const AUTHED_SPECS = /authed\/.*\.spec\.ts/;

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  // The authed suite drives ONE dev server + a shared (free-tier) TEST DB, so high
  // parallelism saturates them and causes cascading timeouts. Cap the workers.
  workers: process.env.CI ? 2 : 4,
  // HTML report on both (CI uploads it as an artifact); GitHub annotations in CI.
  reporter: process.env.CI
    ? [["github"], ["html", { open: "never" }]]
    : [["list"], ["html", { open: "never" }]],
  // Slightly higher than the 5s default: the authed suite hits a single dev server
  // + shared TEST DB under heavy parallelism, so first-loads can exceed 5s.
  expect: { timeout: 10_000 },
  use: {
    baseURL,
    trace: "on-first-retry",
    screenshot: "only-on-failure",
    video: "retain-on-failure",
  },
  projects: [
    // ---- Public (no backend) ----
    { name: "public-chromium", testMatch: PUBLIC_SPECS, use: { ...devices["Desktop Chrome"] } },
    { name: "public-mobile", testMatch: PUBLIC_SPECS, use: { ...devices["Pixel 7"] } },

    // ---- Public-anon (LOGGED OUT, but needs the real TEST backend) ----
    // The C8 content journeys: an anonymous visitor reads real catalogue/course/
    // exercise data. No `setup` dependency and no storageState → logged out; but
    // runs in the e2e-auth workflow because it needs the TEST project's anon reads.
    {
      name: "public-anon-chromium",
      testMatch: PUBLIC_ANON_SPECS,
      use: { ...devices["Desktop Chrome"] },
    },

    // ---- Authenticated (needs the test Supabase project + seeded users) ----
    { name: "setup", testMatch: /auth\.setup\.ts/, use: { ...devices["Desktop Chrome"] } },
    {
      name: "authed-chromium",
      testMatch: AUTHED_SPECS,
      dependencies: ["setup"],
      use: { ...devices["Desktop Chrome"] },
    },
  ],
  // Spawn the dev server only when no external base URL was provided.
  webServer: process.env.PLAYWRIGHT_BASE_URL
    ? undefined
    : {
        command: "npm run dev",
        url: baseURL,
        reuseExistingServer: !process.env.CI,
        timeout: 120_000,
      },
});
