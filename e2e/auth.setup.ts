import { test as setup, expect } from "@playwright/test";
import { TEST_USERS, STORAGE_STATE, E2E_PASSWORD, type Role } from "./helpers/users";

/**
 * Setup project: logs each seeded test account in through the REAL login UI and
 * saves its authenticated browser state to e2e/.auth/<role>.json, which the
 * authed specs reuse. Doubles as a per-role login smoke test.
 *
 * Requires the test Supabase project + seeded users (`npm run e2e:seed`).
 *
 * NOTE: this is an SSR app — a click can land *before* React hydrates, in which
 * case the browser does a native form submit (page reload) and never calls
 * Supabase. We therefore re-navigate + fill + submit inside expect.toPass()
 * until the client-side sign-in request (POST /auth/v1/token) actually fires.
 * Each retry starts from a fresh navigation, so a pre-hydration reload can't
 * livelock the loop. The dev server's first (cold) compile is slow, hence the
 * generous per-test timeout.
 */
for (const role of Object.keys(TEST_USERS) as Role[]) {
  setup(`authenticate as ${role}`, async ({ page }) => {
    setup.setTimeout(120_000);
    const { email } = TEST_USERS[role];

    await expect(async () => {
      await page.goto("/auth?mode=login");
      await page.waitForTimeout(2000); // let React hydrate before interacting
      await page.locator('input[type="email"]').fill(email);
      await page.locator('input[type="password"]').fill(E2E_PASSWORD);
      await Promise.all([
        page.waitForResponse(
          (r) => r.url().includes("/auth/v1/token") && r.request().method() === "POST",
          { timeout: 8000 },
        ),
        page.locator('button[type="submit"]').click(),
      ]);
    }).toPass({ timeout: 90_000 });

    await page.waitForURL(/\/dashboard/, { timeout: 20_000 });
    await expect(page).toHaveURL(/\/dashboard/);

    await page.context().storageState({ path: STORAGE_STATE[role] });
  });
}
