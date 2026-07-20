import { test, expect } from "../fixtures";
import { PracticePage } from "../pages/public-practice.page";

/**
 * Native question types — phase B1 `numeric` (étude 03, lot B1.3; spec
 * docs/interactive-question-types.md). An anonymous visitor plays a mission
 * carrying a native numeric question: the entry is hard-LTR with the decimal
 * mobile keyboard (R-4), a malformed value cannot be validated, and the run
 * completes to a result screen (R-3: never a crashed session).
 *
 * The numeric mission is reproducible from the committed e2e fixtures
 * (scripts/e2e/seed-fixture-content.mjs); a missing one is a LOUD failure, not a
 * silent skip (see e2e/public-anon/catalogue-coverage.spec.ts).
 */
test.describe("Native question types (B1 — numeric)", () => {
  test("a numeric mission renders the LTR numeric entry and completes anonymously", async ({
    page,
    adminDb,
  }) => {
    const exerciseId = await adminDb.numericExerciseId();
    expect(exerciseId, `numeric mission missing — run \`npm run e2e:seed-content\``).toBeTruthy();

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
      } else {
        const group = practice.questionGroups.first();
        if (!(await group.isVisible().catch(() => false))) break;
        await group.getByRole("radio").first().click();
      }
      await practice.submitAndSettle();
    }

    expect(sawNumeric).toBe(true);
    await expect(practice.score).toBeVisible({ timeout: 15_000 });
    await expect(page).not.toHaveURL(/\/auth/);
  });
});
