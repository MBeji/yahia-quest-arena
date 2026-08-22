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

  test("opening an ex-premium concours mission resolves to a playable state", async ({
    quest,
    adminDb,
  }) => {
    // Phase gratuite (étude 15, lot 2): every parcours is FREE, so the free
    // account opens a difficulty>=2 concours mission without any paywall — the
    // only remaining gate is the pedagogical chapter quiz (a separate lock).
    //
    // Ce que ce test ne prétend plus dire : « et le paywall n'apparaît pas ». Il
    // portait un `expect(quest.paywallPremiumText).toHaveCount(0)` que rien dans le
    // code ne pouvait faire rougir (issue #733) — l'absence tenait à la donnée, pas
    // au produit. Cet invariant-là est mesuré à sa cause dans `premium-gate.spec.ts`.
    const { exerciseId } = await adminDb.premiumParcoursExercise();
    await quest.goto(exerciseId);
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
  });
});
