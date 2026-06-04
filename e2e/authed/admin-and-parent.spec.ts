import { test, expect } from "@playwright/test";
import { STORAGE_STATE } from "../helpers/users";

/**
 * Admin + parent role journeys (role-gated nav and pages).
 */
test.describe("Admin", () => {
  test.use({ storageState: STORAGE_STATE.admin });

  test("can open the subscriptions admin page", async ({ page }) => {
    await page.goto("/admin/subscriptions");
    await expect(page).toHaveURL(/\/admin\/subscriptions/);
    // The page must not bounce to an access-denied/back-to-hall state for an admin.
    await expect(page.getByText(/access denied|accès refusé/i)).toHaveCount(0);
  });

  test("sees admin nav entries on the dashboard", async ({ page }) => {
    await page.goto("/dashboard");
    await expect(page.locator('a[href="/admin/subscriptions"]').first()).toBeVisible({
      timeout: 15_000,
    });
  });
});

test.describe("Parent", () => {
  test.use({ storageState: STORAGE_STATE.parent });

  test("can open the parent report page", async ({ page }) => {
    await page.goto("/parent-report");
    await expect(page).toHaveURL(/\/parent-report/);
    await expect(page.getByText(/access denied|accès refusé/i)).toHaveCount(0);
  });
});
