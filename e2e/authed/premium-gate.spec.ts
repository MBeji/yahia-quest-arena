import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Premium access model: difficulty 1-2 is free for everyone; difficulty 3+ ("the
// higher level") requires an active subscription, enforced server-side. We probe
// it on a FREE, NON-school subject so the ONLY gate in play is the premium gate
// (no comprehension-quiz confound).

test.describe("Premium difficulty gate — free student is locked out", () => {
  test.use({ storageState: STORAGE_STATE.free });

  test("a difficulty 3+ mission shows the lock and the quest shows the paywall", async ({
    subject,
    quest,
    adminDb,
  }) => {
    const { exerciseId, subjectId } = await adminDb.premiumDifficultyExercise();

    // On the subject page, the advanced mission is flagged "subscription required".
    await subject.goto(subjectId);
    await expect(subject.premiumLock.first()).toBeVisible();

    // Opening it directly is rejected server-side → the in-quest paywall renders.
    await quest.goto(exerciseId);
    await expect(quest.paywallPremiumText).toBeVisible();
  });
});

test.describe("Premium difficulty gate — subscriber is unlocked", () => {
  test.use({ storageState: STORAGE_STATE.premium });

  test("a premium student can open the same difficulty 3+ mission", async ({ quest, adminDb }) => {
    const { exerciseId } = await adminDb.premiumDifficultyExercise();

    await quest.goto(exerciseId);
    // No paywall: the QCM itself renders (at least two options) for a subscriber.
    await expect(quest.options.first()).toBeVisible();
    expect(await quest.options.count()).toBeGreaterThanOrEqual(2);
  });
});
