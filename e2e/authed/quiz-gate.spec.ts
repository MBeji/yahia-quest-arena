import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/**
 * Comprehension-quiz gate — SCHOOL program only, enforced SERVER-SIDE (chantier C8).
 *
 * The matiere hub is the public « Référence » register now: it shows no per-mission
 * visual lock (that gameplay layer is deferred to L2). The gate itself is unchanged
 * and lives in the server (`startExerciseSession`): opening a school mission before
 * its chapter quiz is passed yields the quiz-lock screen on `/quest`; passing the
 * quiz unlocks the chapter's missions. Non-school subjects have no quiz gate.
 *
 * We pick a FREE (non-concours) school subject so the ONLY gate in play is the quiz
 * (no per-parcours entitlement paywall). Lock + unlock run SERIALLY on the same
 * chapter so the unlock (the only test here that mutates state by passing the quiz)
 * runs after the lock assertion. CI runs reset-gameplay first (no quiz passed yet).
 */
test.use({ storageState: STORAGE_STATE.free });

test.describe.serial("Comprehension-quiz gate — school program (server-side)", () => {
  test("a school chapter's mission is quiz-locked until its quiz is passed", async ({
    quest,
    adminDb,
  }) => {
    const subjectId = await adminDb.freeSchoolSubjectId();
    const pair = await adminDb.chapterQuizAndMission(subjectId);
    test.skip(!pair, "No chapter with both a quiz and a mission on the test project.");
    if (!pair) return; // narrow the type (test.skip already aborted when null)

    await quest.goto(pair.missionId);
    await expect(quest.quizLock).toBeVisible({ timeout: 15_000 });
  });

  test("passing the chapter quiz unlocks its missions", async ({ quest, adminDb }) => {
    test.setTimeout(150_000);
    const subjectId = await adminDb.freeSchoolSubjectId();
    const pair = await adminDb.chapterQuizAndMission(subjectId);
    test.skip(!pair, "No chapter with both a quiz and a mission on the test project.");
    if (!pair) return; // narrow the type (test.skip already aborted when null)

    // Pass the chapter's comprehension quiz (answer everything correctly, paced past
    // the anti-farm floor so the ≥80% pass registers).
    const key = await adminDb.answerKey(pair.quizId);
    await quest.goto(pair.quizId);
    await quest.answerAllCorrectly(key);
    await expect(quest.score).toBeVisible({ timeout: 15_000 });

    // The same chapter's mission now opens to the QCM (no quiz-lock).
    await quest.goto(pair.missionId);
    await expect(quest.options.first()).toBeVisible({ timeout: 20_000 });
  });
});

test.describe("Non-school missions have no quiz gate", () => {
  test("a non-school mission opens directly to the QCM", async ({ quest, adminDb }) => {
    const subjectId = await adminDb.nonSchoolSubjectId();
    const missionId = await adminDb.freeExerciseId(subjectId);
    await quest.goto(missionId);
    await expect(quest.options.first()).toBeVisible({ timeout: 20_000 });
  });
});
