import { defineConfig, devices } from "@playwright/test";

/**
 * Playwright end-to-end config — runs REAL browser journeys against the app.
 *
 * Runs locally and in CI, NOT in the restricted build sandbox (the sandbox
 * blocks the Playwright browser download). Setup:
 *   npm i                       # @playwright/test is a devDependency
 *   npx playwright install chromium
 *   npm run test:e2e
 *
 * By default Playwright starts the dev server itself. Point at an already-running
 * server (e.g. a Vercel preview) with PLAYWRIGHT_BASE_URL=https://… npm run test:e2e
 * — in that case it won't spawn a local server.
 */
const baseURL = process.env.PLAYWRIGHT_BASE_URL ?? `http://localhost:${process.env.PORT ?? 5173}`;

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
    { name: "chromium", use: { ...devices["Desktop Chrome"] } },
    { name: "mobile", use: { ...devices["Pixel 7"] } },
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
