import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

// Étude 17 — active recall. A free, non-school (never quiz-gated) mission the
// student has MASTERED (100% classic, un-rushed) unlocks a "Rappel" run where the
// same QCM is replayed as free-text recall, worth 1.5× XP. This walks the whole
// arc: master → the hub chip unlocks → play recall as free text → scored review,
// and confirms recall awards XP. The exact ×1.5 multiplier is pinned precisely by
// pgTAP (lot 2, R-5); XP under a shared parallel test user is only monotonic, so
// here we assert a positive gain, not an exact ratio.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Active recall (étude 17)", () => {
  test("master a mission, unlock recall, replay it as free text for boosted XP", async ({
    quest,
    adminDb,
    page,
  }) => {
    test.setTimeout(120_000);

    const seed = await adminDb.recallReadyExercise();
    test.skip(seed === null, "No recall-eligible mission in the test catalogue.");
    const { subjectId, exerciseId, answerKey } = seed!;
    const userId = await adminDb.userIdByEmail(TEST_USERS.free.email);

    // 1. Master the classic run: 100%, paced past the anti-farm floor — the R-3
    //    condition that unlocks recall for this mission.
    await quest.goto(exerciseId);
    await expect(quest.options.first()).toBeVisible({ timeout: 25_000 });
    await quest.answerAllCorrectly(answerKey);
    await expect(quest.score).toBeVisible({ timeout: 15_000 });
    await expect(quest.score).toContainText("100%");

    // 2. The subject hub now surfaces an UNLOCKED recall chip (signed-in only, R-9).
    await page.goto(`/matiere/${subjectId}`);
    await expect(page.getByTestId("recall-chip-unlocked").first()).toBeVisible({
      timeout: 15_000,
    });

    // 3. Play the recall run: banner up, free-text field (no radios), type each
    //    answer. Capture XP just before so the gain is attributable to recall.
    const xpBeforeRecall = (await adminDb.profileStats(userId)).xp;
    await page.goto(`/quest/${exerciseId}?variant=recall`);
    await expect(quest.recallBanner).toBeVisible({ timeout: 25_000 });
    await expect(quest.recallInput).toBeVisible({ timeout: 15_000 });
    expect(await quest.options.count()).toBe(0);

    await quest.answerRecallAll(answerKey);

    // 4. Scored review, and recall awarded (boosted) XP.
    await expect(quest.score).toBeVisible({ timeout: 15_000 });
    expect(await quest.reviewItems.count()).toBeGreaterThan(0);
    await expect
      .poll(async () => (await adminDb.profileStats(userId)).xp, { timeout: 10_000 })
      .toBeGreaterThan(xpBeforeRecall);
  });
});
