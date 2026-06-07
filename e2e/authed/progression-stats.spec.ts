import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

// Progression (gamification): the hero stat chips are present, and completing an
// exercise correctly actually awards XP. We answer correctly (matching options by
// text, since the UI shuffles them) and pace the run past the anti-farm "too
// fast" floor so the reward is granted — then verify XP rose in the DB.
test.use({ storageState: STORAGE_STATE.free });

test.describe("XP & coins progression", () => {
  test("the hero header shows level, XP and coins", async ({ dashboard }) => {
    await dashboard.goto();
    await expect(dashboard.statLevel).toBeVisible();
    await expect(dashboard.statXp).toBeVisible();
    await expect(dashboard.statCoins).toBeVisible();
  });

  test("passing a free exercise awards XP", async ({ quest, adminDb }) => {
    // Paces ≥4.5s/question to clear the anti-farm floor, so allow ample time.
    test.setTimeout(150_000);
    // Use culture-générale (plain-text questions) for reliable text matching.
    const subjectId = await adminDb.subjectIdByTheme("culture-generale");
    test.skip(!subjectId, "culture-générale content not applied to the test project.");
    const exerciseId = await adminDb.freeExerciseId(subjectId as string);
    const key = await adminDb.answerKey(exerciseId);

    const userId = await adminDb.userIdByEmail(TEST_USERS.free.email);
    const before = await adminDb.profileStats(userId);

    await quest.goto(exerciseId);
    await quest.answerAllCorrectly(key);

    await expect(quest.score).toBeVisible();
    await expect(quest.score).toContainText("%");

    // A passing, not-too-fast attempt grants XP — visible in the profile.
    await expect
      .poll(async () => (await adminDb.profileStats(userId)).xp, { timeout: 15_000 })
      .toBeGreaterThan(before.xp);
  });
});
