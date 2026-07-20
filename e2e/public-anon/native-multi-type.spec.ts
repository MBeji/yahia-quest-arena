import { test, expect } from "../fixtures";
import { PracticePage } from "../pages/public-practice.page";

/**
 * Native question types — phase B3 `multi` (étude 03, lot B3.4; spec
 * docs/interactive-question-types.md). An anonymous visitor plays a mission
 * carrying a native multi-select question: the checkbox list renders with the
 * explicit "select ALL that apply" mention (US-3), checking boxes enables
 * submission, and the run completes to a result screen (R-3: never a crashed
 * session).
 *
 * The multi mission is reproducible from the committed e2e fixtures
 * (scripts/e2e/seed-fixture-content.mjs); a missing one is a LOUD failure, not a
 * silent skip (see e2e/public-anon/catalogue-coverage.spec.ts).
 */
test.describe("Native question types (B3 — multi)", () => {
  test("a multi mission renders checkboxes and completes anonymously", async ({
    page,
    adminDb,
  }) => {
    const exerciseId = await adminDb.multiExerciseId();
    expect(exerciseId, `multi mission missing — run \`npm run e2e:seed-content\``).toBeTruthy();

    const practice = new PracticePage(page);
    await practice.goto(exerciseId!);
    await practice.firstQuestionVisible();

    let sawMulti = false;
    for (let i = 0; i < 50; i += 1) {
      if (await practice.score.isVisible().catch(() => false)) break;

      if (
        await practice.multiCheckboxes
          .first()
          .isVisible()
          .catch(() => false)
      ) {
        if (!sawMulti) {
          sawMulti = true;
          // Submission is blocked with nothing checked (no partial answer).
          await expect(practice.submitButton).toBeDisabled();
        }
        await practice.checkFirstMultiBox();
        await expect(practice.submitButton).toBeEnabled();
      } else if (await practice.numericInput.isVisible().catch(() => false)) {
        await practice.numericInput.fill("42");
      } else if (
        (await practice.orderingBoard.isVisible().catch(() => false)) ||
        (await practice.matchingBoard.isVisible().catch(() => false))
      ) {
        // auto-filled arrangement — submit as-is
      } else {
        const group = practice.questionGroups.first();
        if (!(await group.isVisible().catch(() => false))) break;
        await group.getByRole("radio").first().click();
      }
      await practice.submitAndSettle();
    }

    expect(sawMulti).toBe(true);
    await expect(practice.score).toBeVisible({ timeout: 15_000 });
    await expect(page).not.toHaveURL(/\/auth/);
  });
});
