import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Onboarding wizard smoke: the route renders the intent-picker first step
// (concours vs explorer). Smoke only — we don't pick a path, to avoid mutating
// the shared account's parcours.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Onboarding", () => {
  test("the wizard renders", async ({ onboarding, page }) => {
    await onboarding.goto();
    await expect(page).toHaveURL(/\/onboarding/);
    await expect(onboarding.heading).toBeVisible({ timeout: 15_000 });
    // The intent step is interactive (two choices), not just a static title.
    await expect(onboarding.intentChoices.first()).toBeVisible();
  });
});
