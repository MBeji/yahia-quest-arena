import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/** FREE student journey (reuses the stored free-account session). */
test.use({ storageState: STORAGE_STATE.free });

test.describe("Free student", () => {
  test("lands on the dashboard with subject cards", async ({ page, dashboard }) => {
    await dashboard.goto();
    await expect(page).toHaveURL(/\/dashboard/);
    await expect(dashboard.firstSubject()).toBeVisible({ timeout: 15_000 });
  });

  test("sees the daily objective widget (not stuck empty)", async ({ dashboard }) => {
    await dashboard.goto();
    await expect(dashboard.dailyGoal).toBeVisible({ timeout: 15_000 });
  });

  test("opening a premium module shows the paywall + beta CTA", async ({ subject, adminDb }) => {
    // A free account opening a premium (subscription-only) subject gets the
    // subscription paywall rendered straight on the subject page — deterministic,
    // with no quest-session / chapter-quiz race.
    await subject.goto(await adminDb.premiumSubjectId());
    await expect(subject.paywallPremiumText).toBeVisible({ timeout: 15_000 });
    await expect(subject.betaCta).toBeVisible({ timeout: 15_000 });
  });
});
