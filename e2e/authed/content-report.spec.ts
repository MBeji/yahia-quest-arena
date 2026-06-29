import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// "Report an error" (content report): a student can flag a question from the
// quest results screen and gets a confirmation. We reach results via a school
// subject's comprehension quiz (always accessible, no premium gate).
test.use({ storageState: STORAGE_STATE.free });

test.describe("Content report", () => {
  test("flag a question from the results screen", async ({ quest, adminDb }) => {
    test.setTimeout(60_000);
    // Open the comprehension quiz directly — it's always accessible (no quiz/premium
    // gate), so we reliably reach the results screen. (The Référence matiere hub no
    // longer surfaces an "always-open first mission"; all exercise tiles are quest
    // links, some gated, so we don't click the first one blindly.)
    const subjectId = await adminDb.schoolSubjectId();
    const quizId = await adminDb.quizExerciseId(subjectId);
    await quest.goto(quizId);

    await quest.answerAll();
    await expect(quest.score).toBeVisible({ timeout: 15_000 });

    await quest.reportButton.click();
    await quest.reportTextarea.fill("E2E automated check — flagging this item for review.");
    await quest.reportSend.click();
    await expect(quest.reportSent).toBeVisible();
  });
});
