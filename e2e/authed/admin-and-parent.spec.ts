import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/** Role-gated nav and pages for admin + parent accounts. */
test.describe("Admin", () => {
  test.use({ storageState: STORAGE_STATE.admin });

  test("can open the subscriptions admin page", async ({ page }) => {
    await page.goto("/admin/subscriptions");
    await expect(page).toHaveURL(/\/admin\/subscriptions/);
    await expect(page.getByText(/access denied|accès refusé/i)).toHaveCount(0);
  });

  test("sees admin nav entries on the dashboard", async ({ dashboard }) => {
    await dashboard.goto();
    await expect(dashboard.adminNavLink).toBeVisible({ timeout: 15_000 });
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
