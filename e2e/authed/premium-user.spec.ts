import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/**
 * PREMIUM student journey. Key differentiator vs free: opening a difficulty 3+
 * mission does NOT show the subscription paywall.
 */
test.use({ storageState: STORAGE_STATE.premium });

test.describe("Premium student", () => {
  test("dashboard loads", async ({ page, dashboard }) => {
    await dashboard.goto();
    await expect(page).toHaveURL(/\/dashboard/);
    await expect(dashboard.firstSubject()).toBeVisible({ timeout: 15_000 });
  });

  test("opening a premium (difficulty 3+) mission does NOT show the paywall", async ({
    page,
    dashboard,
    subject,
    quest,
  }) => {
    await dashboard.goto();
    await dashboard.openFirstSubject();
    await expect(page).toHaveURL(/\/subject\//);

    // No "Abonnement requis" lock for a subscriber.
    await expect(subject.premiumLock).toHaveCount(0);

    await subject.openFirstMission();
    await expect(page).toHaveURL(/\/quest\//);
    // ...and no subscription paywall on the mission itself.
    await expect(quest.betaCta).toHaveCount(0);
  });
});
