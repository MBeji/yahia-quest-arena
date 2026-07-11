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

  test("opening an ex-premium concours mission shows NO paywall (phase gratuite)", async ({
    quest,
    adminDb,
  }) => {
    // Phase gratuite (étude 15, lot 2): every parcours is FREE, so the free
    // account opens a difficulty>=2 concours mission without any paywall — the
    // only remaining gate is the pedagogical chapter quiz (a separate lock).
    const { exerciseId } = await adminDb.premiumParcoursExercise();
    await quest.goto(exerciseId);
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
    await expect(quest.paywallPremiumText).toHaveCount(0);
  });
});
