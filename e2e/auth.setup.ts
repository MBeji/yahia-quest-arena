import { test as setup, expect } from "@playwright/test";
import { TEST_USERS, STORAGE_STATE, E2E_PASSWORD, type Role } from "./helpers/users";

/**
 * Setup project: logs in each seeded test account through the REAL login UI and
 * saves its authenticated browser state to e2e/.auth/<role>.json. The authed
 * specs then reuse that state (via test.use({ storageState })) — fast and
 * avoids re-logging in for every test. This also doubles as a real login smoke
 * test for each role.
 *
 * Requires the test Supabase project + seeded users (`npm run e2e:seed`).
 */
for (const role of Object.keys(TEST_USERS) as Role[]) {
  setup(`authenticate as ${role}`, async ({ page }) => {
    const { email } = TEST_USERS[role];

    await page.goto("/auth?mode=login");

    // Robust, locale-independent selectors (the form labels are i18n/â€‘free here).
    await page.locator('input[type="email"]').fill(email);
    await page.locator('input[type="password"]').fill(E2E_PASSWORD);
    await page.locator('button[type="submit"]').click();

    // On success the app redirects authenticated users to the dashboard.
    await page.waitForURL(/\/dashboard/, { timeout: 20_000 });
    await expect(page).toHaveURL(/\/dashboard/);

    await page.context().storageState({ path: STORAGE_STATE[role] });
  });
}
