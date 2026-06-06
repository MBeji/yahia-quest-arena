import { defineConfig, devices } from "@playwright/test";

/**
 * Playwright end-to-end config — runs REAL browser journeys against the app.
 * NOT runnable in the restricted build sandbox (it blocks the browser download).
 *
 * Two tiers of tests:
 *  • PUBLIC (landing + logged-out auth redirects): need no real backend, run in
 *    the standard `E2E` workflow with dummy Supabase env.  → projects: public-*
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
// The dev server (@lovable.dev/vite-tanstack-config) serves on 8080 by default,
// not Vite's 5173. Override with PORT or PLAYWRIGHT_BASE_URL if a run needs to.
const baseURL = process.env.PLAYWRIGHT_BASE_URL ?? `http://localhost:${process.env.PORT ?? 8080}`;

const PUBLIC_SPECS = /(landing|auth-redirects)\.spec\.ts/;
const AUTHED_SPECS = /authed\/.*\.spec\.ts/;

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? "github" : "list",
  use: {
    baseURL,
    trace: "on-first-retry",
  },
  projects: [
    // ---- Public (no backend) ----
    { name: "public-chromium", testMatch: PUBLIC_SPECS, use: { ...devices["Desktop Chrome"] } },
    { name: "public-mobile", testMatch: PUBLIC_SPECS, use: { ...devices["Pixel 7"] } },

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
