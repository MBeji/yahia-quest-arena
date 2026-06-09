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

  test("opening a premium-parcours mission shows the paywall + beta CTA", async ({
    quest,
    adminDb,
  }) => {
    // Premium is now per-parcours: a free account (no entitlement) opening a gated
    // mission of a premium Concours parcours is rejected server-side and the in-quest
    // "Parcours premium" paywall (with the free beta-access CTA) renders. Opening the
    // mission directly is deterministic — no quest-session / chapter-quiz race, since
    // the entitlement gate runs BEFORE the quiz gate in startExerciseSession.
    const { exerciseId } = await adminDb.premiumParcoursExercise();
    await quest.goto(exerciseId);
    await expect(quest.paywallPremiumText).toBeVisible({ timeout: 15_000 });
    await expect(quest.betaCta).toBeVisible({ timeout: 15_000 });
  });
});
