import { type Page, type Locator, expect } from "@playwright/test";

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

  // --- "Report an error" (content report), shown on the results screen ---
  get reportButton(): Locator {
    return this.page.getByRole("button", { name: /report an error|signaler une erreur/i });
  }
  get reportTextarea(): Locator {
    return this.page.locator("textarea");
  }
  get reportSend(): Locator {
    return this.page.getByRole("button", { name: /^send$|^envoyer$/i });
  }
  get reportSent(): Locator {
    return this.page.getByText(/report sent|rapport envoyé|thanks/i).first();
  }

  async goto(id: string): Promise<void> {
    await this.page.goto(`/quest/${id}`);
  }

  /**
   * Answer the current question and wait for the quest to move on. The quest
   * AUTO-ADVANCES ~1.8s after a choice is recorded, so we select the option
   * (retrying to beat the post-navigation hydration race — a lost click leaves the
   * radios enabled) and then wait for the next question or the results screen,
   * rather than racing the auto-advance with the submit button. `preSelectPauseMs`
   * paces arrival→choice so a graded run clears the server's "too fast" anti-farm
   * floor (≥4s/question; auto-advance alone is ~1.8s, which would be void).
   */
  private async answerCurrent(option: Locator, preSelectPauseMs = 0): Promise<void> {
    const before = (await this.radioGroup.getAttribute("aria-label").catch(() => null)) ?? "";
    if (preSelectPauseMs > 0) await this.page.waitForTimeout(preSelectPauseMs);
    await expect(async () => {
      if (
        await this.options
          .first()
          .isEnabled()
          .catch(() => false)
      ) {
        await option.click();
      }
      // A recorded choice puts the question into feedback state → radios disabled.
      await expect(this.options.first()).toBeDisabled({ timeout: 1000 });
    }).toPass({ timeout: 15_000 });
    // Wait for the auto-advance: the prompt changes, or the results screen appears.
    await expect
      .poll(
        async () => {
          if (await this.score.isVisible().catch(() => false)) return "done";
          const now = await this.radioGroup.getAttribute("aria-label").catch(() => null);
          return now && now !== before ? "next" : "wait";
        },
        { timeout: 12_000 },
      )
      .not.toBe("wait");
  }

  /**
   * Wait until the next question's options render or the results screen appears —
   * skipping the "preparing" screen shown while the secure session is created and
   * the inter-question transitions. Returns false once the score screen is up.
   */
  private async questionReady(): Promise<boolean> {
    await expect(this.options.first().or(this.score)).toBeVisible({ timeout: 20_000 });
    return !(await this.score.isVisible().catch(() => false));
  }

  /**
   * Play the whole quest: pick the first option and advance, question by
   * question, until the results screen (score) appears. Picking the first option
   * each time keeps it deterministic (we assert the flow + scoring, not a perfect
   * score). `maxQuestions` is a safety cap.
   */
  async answerAll(maxQuestions = 60): Promise<void> {
    for (let i = 0; i < maxQuestions; i += 1) {
      if (!(await this.questionReady())) return;
      await this.answerCurrent(this.options.first());
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
    preSelectPauseMs = 3000,
  ): Promise<void> {
    const byPrompt = new Map(answerKey.map((k) => [k.prompt, k.correctText]));
    const maxQuestions = answerKey.length + 5; // safety cap
    for (let i = 0; i < maxQuestions; i += 1) {
      if (!(await this.questionReady())) return;
      const prompt = (await this.radioGroup.getAttribute("aria-label")) ?? "";
      const correctText = byPrompt.get(prompt);
      const option =
        correctText && correctText.length > 0
          ? this.options.filter({ hasText: correctText }).first()
          : this.options.first();
      // Pause before selecting so total per-question time (pause + ~1.8s
      // auto-advance) exceeds MIN_SECONDS_PER_QUESTION (4s) → attempt isn't void.
      await this.answerCurrent(option, preSelectPauseMs);
    }
  }
}
