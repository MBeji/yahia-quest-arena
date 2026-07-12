import { test, expect } from "../fixtures";
import { PracticePage } from "../pages/public-practice.page";

/**
 * Native question types — phase B1 `numeric` (étude 03, lot B1.3; spec
 * docs/interactive-question-types.md). An anonymous visitor plays a mission
 * carrying a native numeric question: the entry is hard-LTR with the decimal
 * mobile keyboard (R-4), a malformed value cannot be validated, and the run
 * completes to a result screen (R-3: never a crashed session).
 *
 * Skips cleanly while the TEST catalogue has no numeric mission yet — the
 * content lot (B1.4) lifts the authoring ban and seeds the first one.
 */
test.describe("Native question types (B1 — numeric)", () => {
  test("a numeric mission renders the LTR numeric entry and completes anonymously", async ({
    page,
    adminDb,
  }) => {
    const exerciseId = await adminDb.numericExerciseId();
    test.skip(!exerciseId, "No numeric mission in the TEST catalogue yet (lot B1.4 seeds one).");

    const practice = new PracticePage(page);
    await practice.goto(exerciseId!);
    await practice.firstQuestionVisible();

    let sawNumeric = false;
    for (let i = 0; i < 50; i += 1) {
      if (await practice.score.isVisible().catch(() => false)) break;

      if (await practice.numericInput.isVisible().catch(() => false)) {
        if (!sawNumeric) {
          sawNumeric = true;
          // R-4: numbers are standard LTR notation, even inside an RTL subject.
          await expect(practice.numericInput).toHaveAttribute("dir", "ltr");
          await expect(practice.numericInput).toHaveAttribute("inputmode", "decimal");
          // A malformed value cannot be validated (mirrors the server contract).
          await practice.numericInput.fill("abc");
          await expect(practice.submitButton).toBeDisabled();
        }
        await practice.numericInput.fill("42");
        await practice.submitButton.click();
      } else {
        const group = practice.questionGroups.first();
        if (!(await group.isVisible().catch(() => false))) break;
        await group.getByRole("radio").first().click();
        await practice.submitButton.click();
      }
      await page.waitForTimeout(200);
    }

    expect(sawNumeric).toBe(true);
    await expect(practice.score).toBeVisible({ timeout: 15_000 });
    await expect(page).not.toHaveURL(/\/auth/);
  });
});
