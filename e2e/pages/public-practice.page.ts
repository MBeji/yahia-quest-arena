import { type Page, type Locator, expect } from "@playwright/test";

/**
 * Public practice/quiz screen (`/exercice/$exerciseId`) — now the SAME
 * question-by-question player as the connected quest, in its login-free register.
 * An anonymous visitor answers one question at a time (select an option → submit),
 * reaches a result screen with the score (nothing saved, no XP), and a soft
 * account invite. School chapters are comprehension-quiz-gated: a gated exercise
 * shows the quiz-lock screen until the chapter's quiz is passed this session.
 * Stable hooks: the submit button + score carry `data-testid`s; options are
 * matched by ARIA role.
 */
export class PracticePage {
  constructor(private readonly page: Page) {}

  /** One radiogroup for the current question. */
  get questionGroups(): Locator {
    return this.page.getByRole("radiogroup");
  }
  /** Native numeric entry (question_type='numeric' — Tier B, phase B1). */
  get numericInput(): Locator {
    return this.page.getByTestId("numeric-answer-input");
  }
  /** Native drag-&-drop boards (ordering/matching — Tier B, phase B2). */
  get orderingBoard(): Locator {
    return this.page.getByTestId("ordering-board");
  }
  get matchingBoard(): Locator {
    return this.page.getByTestId("matching-board");
  }
  /** Native multi-select checkbox list (question_type='multi' — Tier B, phase B3). */
  get multiCheckboxes(): Locator {
    return this.page.getByRole("checkbox");
  }
  get submitButton(): Locator {
    return this.page.getByTestId("quest-submit");
  }
  /** The result-screen score — only present once the run finishes. */
  get score(): Locator {
    return this.page.getByTestId("quest-score");
  }
  /** The "Question X / Y" counter — changes exactly when the run advances. */
  get progressCounter(): Locator {
    return this.page.getByTestId("quest-progress");
  }
  /** End-of-run account invitation shown to an anonymous visitor. */
  get accountInvite(): Locator {
    return this.page.locator('main a[href="/signup"]');
  }
  /** The playing-screen « leave » link — returns to the subject hub. */
  get leaveLink(): Locator {
    return this.page.locator('a[href^="/matiere/"]').first();
  }
  /** The quiz-lock « take the quiz » CTA (anon → public quiz flow). */
  get takeQuizLink(): Locator {
    return this.page.locator('a[href^="/exercice/"]').first();
  }

  async goto(exerciseId: string): Promise<void> {
    await this.page.goto(`/exercice/${exerciseId}`);
  }

  /**
   * Tick the first multi checkbox **idempotently**. `click()` toggles, so on a
   * question the loop revisits (the player keeps the LAST question mounted while
   * its submit RPC is in flight) a blind re-click UNCHECKS the answer and
   * disables submission — the flake behind the nightly's public-anon failures.
   */
  async checkFirstMultiBox(): Promise<void> {
    const box = this.multiCheckboxes.first();
    if ((await box.getAttribute("aria-checked")) !== "true") {
      await box.click();
    }
  }

  /**
   * Submit the current question and wait for a REAL transition — the counter
   * changing (next question mounted) or the result screen. Replaces a fixed
   * sleep, which raced `submit_exercise_attempt` (200–800 ms from a CI runner)
   * and let the loop act on a question that was already answered.
   */
  async submitAndSettle(): Promise<void> {
    const before = await this.progressCounter.textContent().catch(() => null);
    await this.submitButton.click();
    await expect
      .poll(
        async () => {
          if (await this.score.isVisible().catch(() => false)) return "settled";
          const now = await this.progressCounter.textContent().catch(() => null);
          return now === before ? "pending" : "settled";
        },
        { timeout: 15_000 },
      )
      .toBe("settled");
  }

  /** Waits for the first question so a play step isn't racing the content fetch. */
  async firstQuestionVisible(): Promise<void> {
    // Type-aware: mcq mounts a radiogroup, numeric an input, B2 types a board,
    // multi a checkbox group.
    await this.questionGroups
      .first()
      .or(this.numericInput)
      .or(this.orderingBoard)
      .or(this.matchingBoard)
      .or(this.multiCheckboxes.first())
      .first()
      .waitFor({ state: "visible", timeout: 15_000 });
  }

  /**
   * Play the whole exercise question-by-question until the result screen
   * appears — type-aware: picks the first option (mcq), types a number
   * (numeric), submits the auto-filled arrangement (ordering/matching
   * boards), or checks one box (multi). Correctness is irrelevant — the
   * journey asserts the run completes and a score renders, not a particular
   * score.
   */
  async playThrough(): Promise<void> {
    await this.firstQuestionVisible();
    for (let i = 0; i < 50; i += 1) {
      if (await this.score.isVisible().catch(() => false)) break;
      if (await this.numericInput.isVisible().catch(() => false)) {
        await this.numericInput.fill("42");
      } else if (
        (await this.orderingBoard.isVisible().catch(() => false)) ||
        (await this.matchingBoard.isVisible().catch(() => false))
      ) {
        // The boards auto-register their initial arrangement — submit as-is.
      } else if (
        await this.multiCheckboxes
          .first()
          .isVisible()
          .catch(() => false)
      ) {
        await this.checkFirstMultiBox();
      } else {
        const group = this.questionGroups.first();
        if (!(await group.isVisible().catch(() => false))) break;
        await group.getByRole("radio").first().click();
      }
      await this.submitAndSettle();
    }
    await this.score.waitFor({ state: "visible", timeout: 15_000 });
  }
}
