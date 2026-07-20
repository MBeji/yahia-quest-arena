import { test, expect } from "../fixtures";
import { PracticePage } from "../pages/public-practice.page";

/**
 * Native question types — phase B2 `ordering`/`matching` (étude 03, lot B2.4;
 * spec docs/interactive-question-types.md). An anonymous visitor plays a
 * mission carrying native board questions: the board renders with its
 * tap-to-order arrows, the initial arrangement is auto-registered (the
 * validate button is enabled without any interaction), rearranging via the
 * arrows works, and the run completes to a result screen (R-3: never a
 * crashed session).
 *
 * Skips cleanly while the TEST catalogue has no board mission yet.
 */
test.describe("Native question types (B2 — ordering/matching)", () => {
  test("a board mission renders, rearranges via arrows and completes anonymously", async ({
    page,
    adminDb,
  }) => {
    const exerciseId = await adminDb.boardExerciseId();
    test.skip(!exerciseId, "No board mission in the TEST catalogue yet (lot B2.4 seeds one).");

    const practice = new PracticePage(page);
    await practice.goto(exerciseId!);
    await practice.firstQuestionVisible();

    let sawBoard = false;
    for (let i = 0; i < 50; i += 1) {
      if (await practice.score.isVisible().catch(() => false)) break;

      const ordering = await practice.orderingBoard.isVisible().catch(() => false);
      const matching = await practice.matchingBoard.isVisible().catch(() => false);
      if (ordering || matching) {
        if (!sawBoard) {
          sawBoard = true;
          // The initial arrangement is auto-registered — validation is
          // possible without any drag (no stuck session).
          await expect(practice.submitButton).toBeEnabled();
          // Tap-to-order accessibility path: an enabled arrow rearranges the
          // board without any drag, and validation stays possible.
          const board = ordering ? practice.orderingBoard : practice.matchingBoard;
          const boardArrows = board.locator("button:not([disabled])");
          if ((await boardArrows.count()) > 0) {
            await boardArrows.first().click();
          }
          await expect(practice.submitButton).toBeEnabled();
        }
      } else if (await practice.numericInput.isVisible().catch(() => false)) {
        await practice.numericInput.fill("42");
      } else {
        const group = practice.questionGroups.first();
        if (!(await group.isVisible().catch(() => false))) break;
        await group.getByRole("radio").first().click();
      }
      await practice.submitAndSettle();
    }

    expect(sawBoard).toBe(true);
    await expect(practice.score).toBeVisible({ timeout: 15_000 });
    await expect(page).not.toHaveURL(/\/auth/);
  });
});
