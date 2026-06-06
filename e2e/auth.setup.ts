import { test as setup, expect } from "@playwright/test";
import { TEST_USERS, STORAGE_STATE, E2E_PASSWORD, type Role } from "./helpers/users";
import { AuthPage } from "./pages/auth.page";

/**
 * Setup project: logs each seeded account in through the real UI (via AuthPage —
 * SSR-hydration-robust) and saves its authenticated browser state to
 * e2e/.auth/<role>.json, reused by the authed specs. Doubles as a per-role login
 * smoke test. Requires the test Supabase project + seeded users (`npm run e2e:seed`).
 */
for (const role of Object.keys(TEST_USERS) as Role[]) {
  setup(`authenticate as ${role}`, async ({ page }) => {
    setup.setTimeout(120_000); // SSR cold-start + hydration retries need headroom
    await new AuthPage(page).login(TEST_USERS[role].email, E2E_PASSWORD);
    await expect(page).toHaveURL(/\/dashboard/);
    await page.context().storageState({ path: STORAGE_STATE[role] });
  });
}
