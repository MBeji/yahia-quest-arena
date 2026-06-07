import { type Page, type Locator } from "@playwright/test";

/** Quest page (`/quest/$id`): the QCM runner, plus the premium paywall / quiz lock. */
export class QuestPage {
  constructor(private readonly page: Page) {}

  // Subscription paywall (shown when a free user opens a difficulty 3+ / premium mission).
  get paywallPremiumText(): Locator {
    return this.page.getByText(/premium/i).first();
  }
  get betaCta(): Locator {
    return this.page.getByRole("button", { name: /bêta|beta/i });
  }

  /** Answer options (radio buttons) of the current question. */
  get options(): Locator {
    return this.page.getByRole("radio");
  }
  /** Submit / advance / finish button (single hook across all states). */
  get submit(): Locator {
    return this.page.getByTestId("quest-submit");
  }
  /** The current question's option group; its aria-label is the exact prompt. */
  get radioGroup(): Locator {
    return this.page.getByRole("radiogroup");
  }
  /** Score line on the results screen (e.g. "4 / 5 … 80%"). */
  get score(): Locator {
    return this.page.getByTestId("quest-score");
  }
  /** Per-question review cards on the results screen (data-correct true/false). */
  get reviewItems(): Locator {
    return this.page.getByTestId("review-item");
  }

  async goto(id: string): Promise<void> {
    await this.page.goto(`/quest/${id}`);
  }

  /**
   * Play the whole quest: pick the first option and advance, question by
   * question, until the results screen (score) appears. Picking the first option
   * each time keeps it deterministic (we assert the flow + scoring, not a perfect
   * score). `maxQuestions` is a safety cap.
   */
  async answerAll(maxQuestions = 60): Promise<void> {
    for (let i = 0; i < maxQuestions; i += 1) {
      if (await this.score.isVisible().catch(() => false)) return;
      if ((await this.options.count()) === 0) return;
      await this.options.first().click();
      // `submit` auto-waits to become enabled (feedback recorded) before clicking.
      await this.submit.click();
    }
  }

  /**
   * Play the whole quest answering CORRECTLY, by matching each question's prompt
   * (the radiogroup's aria-label) to its correct option text from the answer key
   * (the UI shuffles options, so matching by text is the only stable way). Paces
   * each answer to clear the server's "too fast" anti-farm gate (≥4s/question),
   * so a passing attempt actually awards XP/coins. Falls back to the first option
   * if a prompt isn't in the key (e.g. a figure-only question).
   */
  async answerAllCorrectly(
    answerKey: { prompt: string; correctText: string }[],
    msPerQuestion = 4500,
  ): Promise<void> {
    const byPrompt = new Map(answerKey.map((k) => [k.prompt, k.correctText]));
    const maxQuestions = answerKey.length + 5; // safety cap
    for (let i = 0; i < maxQuestions; i += 1) {
      if (await this.score.isVisible().catch(() => false)) return;
      if ((await this.options.count()) === 0) return;
      const prompt = (await this.radioGroup.getAttribute("aria-label")) ?? "";
      const correctText = byPrompt.get(prompt);
      const option =
        correctText && correctText.length > 0
          ? this.options.filter({ hasText: correctText }).first()
          : this.options.first();
      await option.click();
      // Pace to exceed MIN_SECONDS_PER_QUESTION (4s) so the attempt isn't void.
      await this.page.waitForTimeout(msPerQuestion);
      await this.submit.click();
    }
  }
}
