import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

/**
 * PREMIUM student journey. The student holds a live entitlement on both Concours
 * parcours (seeded via admin_grant_parcours), so — unlike the free student —
 * opening a premium-parcours mission does NOT hit the "Parcours premium" paywall.
 */
test.use({ storageState: STORAGE_STATE.premium });

test.describe("Premium student", () => {
  test("dashboard loads", async ({ page, dashboard }) => {
    await dashboard.goto();
    await expect(page).toHaveURL(/\/dashboard/);
    await expect(dashboard.firstSubject()).toBeVisible({ timeout: 15_000 });
  });

  test("opening a premium-parcours mission does NOT show the paywall", async ({
    quest,
    adminDb,
  }) => {
    const { id: parcoursId } = await adminDb.premiumConcoursParcours();
    const premiumUserId = await adminDb.userIdByEmail(TEST_USERS.premium.email);
    // The premium student's seeded entitlement is live.
    expect(await adminDb.hasEntitlement(premiumUserId, parcoursId)).toBe(true);

    // A difficulty>=2 mission of the premium parcours (outside the free preview).
    const { exerciseId } = await adminDb.premiumParcoursExercise();
    await quest.goto(exerciseId);

    // The entitlement gate is passed → the session resolves to the QCM or, since
    // concours parcours are SCHOOL subjects, the chapter quiz-lock (a separate gate).
    // Neither is the "Parcours premium" paywall, and there's no beta CTA.
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
    await expect(quest.paywallPremiumText).toHaveCount(0);
    await expect(quest.betaCta).toHaveCount(0);
  });
});
