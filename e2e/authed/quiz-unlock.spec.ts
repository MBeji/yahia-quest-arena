import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Quiz gate — UNLOCK side (complements quiz-gate's lock assertion): passing a
// school chapter's comprehension quiz marks it cleared, which unlocks that
// chapter's missions. Answers correctly (matched by text) and paced past the
// anti-farm floor so the ≥80% pass actually registers.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Quiz gate — unlock", () => {
  test("passing a chapter quiz marks it cleared", async ({ subject, quest, adminDb }) => {
    test.setTimeout(150_000);
    const subjectId = await adminDb.schoolSubjectId();

    // Fresh school subject → at least one mission is locked behind its quiz.
    await subject.goto(subjectId);
    await expect(subject.missionLinks.first()).toBeVisible({ timeout: 15_000 }); // page loaded
    expect(await subject.lockedMissions.count()).toBeGreaterThan(0);

    // Pass the first chapter's comprehension quiz (answer everything correctly).
    const quizId = await adminDb.quizExerciseId(subjectId);
    const key = await adminDb.answerKey(quizId);
    await quest.goto(quizId);
    await quest.answerAllCorrectly(key);
    await expect(quest.score).toBeVisible({ timeout: 15_000 });

    // Back on the subject, the chapter now shows the "passed" badge (idempotent).
    await subject.goto(subjectId);
    await expect(subject.passedBadge.first()).toBeVisible({ timeout: 15_000 });
  });
});
