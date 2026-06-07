import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The core gameplay loop end-to-end: open a free, non-school exercise (no quiz
// gate, no premium gate), answer every QCM question, and reach the scored review.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Core gameplay loop — free non-school exercise", () => {
  test("answer a QCM end-to-end and see the scored review", async ({ quest, adminDb }) => {
    const subjectId = await adminDb.nonSchoolSubjectId();
    const exerciseId = await adminDb.freeExerciseId(subjectId);
    await quest.goto(exerciseId);

    // QCM renders (no quiz-lock, no paywall): at least two radio options.
    await expect(quest.options.first()).toBeVisible();
    expect(await quest.options.count()).toBeGreaterThanOrEqual(2);

    await quest.answerAll();

    // Results screen: score with a percentage + one review card per question.
    await expect(quest.score).toBeVisible();
    await expect(quest.score).toContainText("%");
    expect(await quest.reviewItems.count()).toBeGreaterThan(0);
  });
});
