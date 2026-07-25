import { defineConfig, devices } from "@playwright/test";
import { existsSync } from "node:fs";
import dotenv from "dotenv";

import {
  findProdTarget,
  needsTestBackend,
  prodRefusalMessage,
} from "./scripts/shared/prod-targets.mjs";

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

// Hard safety net: never run e2e against production — by EITHER route.
// `PLAYWRIGHT_BASE_URL` is in the list because pointing the browser at the prod
// deployment writes to the prod database through its SSR secrets, however clean
// the local Supabase env is. That is the hole #614 fell through: a test filed a
// real `content_reports` row in production while this check saw only TEST URLs.
const prodTarget = findProdTarget([
  process.env.SUPABASE_URL,
  process.env.VITE_SUPABASE_URL,
  process.env.PLAYWRIGHT_BASE_URL,
]);
if (prodTarget) {
  throw new Error(
    `[e2e] Refusing to run: ${prodRefusalMessage(prodTarget)} Point .env.test (and PLAYWRIGHT_BASE_URL) at the TEST project.`,
  );
}

// …and the other half of the same hole: a backend tier with NO Supabase env at all
// slipped through, because the check above has nothing to reject when both vars are
// `undefined`. `npm run dev` then resolved them from the repo-root `.env` —
// production — through Vite's loadEnv file fallback. ABSENT is as fatal as WRONG.
const backendRun = needsTestBackend(process.argv);
if (backendRun && !(process.env.SUPABASE_URL && process.env.VITE_SUPABASE_URL)) {
  throw new Error(
    "[e2e] Refusing to run the authenticated / public-anon tier without an explicit TEST backend: " +
      "SUPABASE_URL and VITE_SUPABASE_URL are unset, so the dev server would resolve them from the " +
      "repo-root `.env` (potentially PRODUCTION). Create `.env.test` from `.env.test.example` (TEST " +
      "project only), or run `npm run test:e2e` for the backendless public tier.",
  );
}

// The backendless public tier never calls Supabase — pin it to the same dummy pair
// CI injects (.github/workflows/e2e.yml) so a LOCAL run behaves like CI instead of
// silently rendering production, and so the spawned dev server has nothing left to
// resolve from a file either.
const DUMMY_BACKEND: Record<string, string> = {
  VITE_SUPABASE_URL: "https://example.supabase.co",
  VITE_SUPABASE_PUBLISHABLE_KEY: "e2e-dummy-key",
  SUPABASE_URL: "https://example.supabase.co",
  SUPABASE_PUBLISHABLE_KEY: "e2e-dummy-key",
};
if (!backendRun && !existsSync(".env.test")) {
  for (const [key, value] of Object.entries(DUMMY_BACKEND)) process.env[key] ??= value;
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

// The backend the spawned dev server must use — handed over EXPLICITLY. Inheriting
// process.env is not enough: Vite's loadEnv fills any VITE_* var still missing from
// the repo-root `.env`, and the SSR layer reads `process.env.SUPABASE_URL` directly.
// Resolved above (TEST project, or the dummy pair for the backendless tier), so
// nothing is left to resolve from a file. Only configured values are forwarded — an
// unset optional stays unset, so the app's own "missing env" error still names it.
const webServerEnv = Object.fromEntries(
  [
    "VITE_SUPABASE_URL",
    "VITE_SUPABASE_PUBLISHABLE_KEY",
    "SUPABASE_URL",
    "SUPABASE_PUBLISHABLE_KEY",
    "SUPABASE_SERVICE_ROLE_KEY",
  ]
    .map((key) => [key, process.env[key]] as const)
    .filter((pair): pair is readonly [string, string] => !!pair[1]),
);

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
    // Play the app in its reduced-motion register. Not a test crutch: it is a
    // real, shipped accessibility path — `useReducedMotion()` (motion/react)
    // makes `questionSlide` return `{ initial: false }`, so a question mounts
    // in place instead of sliding for 0.3s. Without it Playwright's
    // actionability check keeps reporting "element is not stable" while a
    // question animates in, and every click into a freshly-mounted question is
    // a coin toss — the flake behind the public-anon timeouts.
    reducedMotion: "reduce",
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
        // Explicit, never file-resolved — see webServerEnv above.
        env: webServerEnv,
        reuseExistingServer: !process.env.CI,
        timeout: 120_000,
      },
});
