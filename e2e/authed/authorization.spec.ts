import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Negative authorization: a free student must not reach admin tooling, and the
// admin entry points must be hidden from them.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Authorization — student boundaries", () => {
  test("the admin area is blocked with an access-denied notice", async ({ page }) => {
    await page.goto("/admin/subscriptions");
    await expect(page.getByText(/administrators only|administrateurs|للمسؤولين/i)).toBeVisible();
  });

  test("the admin nav link is not shown to a student", async ({ dashboard }) => {
    await dashboard.goto();
    await expect(dashboard.adminNavLink).toHaveCount(0);
  });

  test("parent-report shows the alliance-link state, not another student's data", async ({
    page,
  }) => {
    await page.goto("/parent-report");
    // Renders the alliance-code linking UI (no linked students → no foreign data).
    await expect(page.getByText(/alliance code/i).first()).toBeVisible();
  });
});
