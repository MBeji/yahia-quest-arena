import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// "Report an error" (content report): a student can flag a question from the
// quest results screen and gets a confirmation. We reach results via a school
// subject's comprehension quiz (always accessible, no premium gate).
test.use({ storageState: STORAGE_STATE.free });

test.describe("Content report", () => {
  test("flag a question from the results screen", async ({ subject, quest, adminDb, page }) => {
    test.setTimeout(60_000);
    await subject.goto(await adminDb.schoolSubjectId());

    // First accessible mission on a school subject = the comprehension quiz.
    await subject.missionLinks.first().click();
    await expect(page).toHaveURL(/\/quest\//);

    await quest.answerAll();
    await expect(quest.score).toBeVisible({ timeout: 15_000 });

    await quest.reportButton.click();
    await quest.reportTextarea.fill("E2E automated check — flagging this item for review.");
    await quest.reportSend.click();
    await expect(quest.reportSent).toBeVisible();
  });
});
