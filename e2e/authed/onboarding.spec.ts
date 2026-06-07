import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Onboarding wizard smoke: the route renders the multi-step wizard (grade → …).
// Smoke only — we don't complete it, to avoid mutating the shared account's grade.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Onboarding", () => {
  test("the wizard renders", async ({ onboarding, page }) => {
    await onboarding.goto();
    await expect(page).toHaveURL(/\/onboarding/);
    await expect(onboarding.nextButton).toBeVisible({ timeout: 15_000 });
  });
});
