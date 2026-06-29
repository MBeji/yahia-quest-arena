import { type Page, type Locator, expect } from "@playwright/test";

/** Quest page (`/quest/$id`): the QCM runner, plus the premium paywall / quiz lock. */
export class QuestPage {
  constructor(private readonly page: Page) {}

  // Premium paywall (SubscriptionPaywall) — shown when a user without an entitlement
  // opens a premium-parcours mission outside the free preview. Matches both the
  // "Parcours premium" denial copy and the paywall's "Premium Feature" title.
  get paywallPremiumText(): Locator {
    return this.page.getByText(/premium/i).first();
  }
  get betaCta(): Locator {
    return this.page.getByRole("button", { name: /bêta|beta/i });
  }
  /** Chapter comprehension-quiz lock screen (school subjects): shown when the
   * mission is reachable (entitlement OK) but the chapter quiz isn't passed yet.
   * FR "Exercice verrouillé", EN "Exercise locked", AR "التمرين مقفل". */
  get quizLock(): Locator {
    return this.page.getByText(/exercice verrouillé|exercise locked|التمرين مقفل/i).first();
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
    // FR default (GAP-010): "Merci ! Signalement envoyé." — match on "signalement
    // envoyé", not "rapport"; EN: "Thanks! Report sent."
    return this.page.getByText(/report sent|signalement envoyé|thanks|merci/i).first();
  }

  async goto(id: string): Promise<void> {
    await this.page.goto(`/quest/${id}`);
  }

  /**
   * Answer the current question and wait for the quest to move on. Validation is
   * MANUAL: selecting an option only highlights it (freely changeable), and
   * nothing advances until the "Valider" button is clicked. We select the option
   * (retrying to beat the post-navigation hydration race — a lost click leaves the
   * submit button disabled), click submit, then wait for the next question or the
   * results screen. `preSelectPauseMs` paces arrival→choice so a graded run clears
   * the server's "too fast" anti-farm floor (≥4s/question).
   */
  private async answerCurrent(option: Locator, preSelectPauseMs = 0): Promise<void> {
    const before = (await this.radioGroup.getAttribute("aria-label").catch(() => null)) ?? "";
    if (preSelectPauseMs > 0) await this.page.waitForTimeout(preSelectPauseMs);
    await expect(async () => {
      await option.click();
      // The chosen option is marked selected, which enables the submit button.
      await expect(option).toHaveAttribute("aria-checked", "true", { timeout: 1000 });
      await expect(this.submit).toBeEnabled({ timeout: 1000 });
    }).toPass({ timeout: 15_000 });
    // Validation is the only way to advance: click "Valider".
    await this.submit.click();
    // Wait for the advance: the prompt changes, or the results screen appears.
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
    preSelectPauseMs = 4500,
  ): Promise<void> {
    const byPrompt = new Map(answerKey.map((k) => [k.prompt, k.correctText]));
    const maxQuestions = answerKey.length + 5; // safety cap
    for (let i = 0; i < maxQuestions; i += 1) {
      if (!(await this.questionReady())) return;
      const prompt = (await this.radioGroup.getAttribute("aria-label")) ?? "";
      const correctText = byPrompt.get(prompt);
      const option =
        correctText && correctText.length > 0
          ? this.options.nth(await this.correctOptionIndex(correctText))
          : this.options.first();
      // Pause before selecting so per-question time exceeds
      // MIN_SECONDS_PER_QUESTION (4s) → attempt isn't void. Validation is manual
      // now (no auto-advance), so the whole budget must come from this pause.
      await this.answerCurrent(option, preSelectPauseMs);
    }
  }

  /**
   * Index of the rendered option matching the answer-key text. Arabic options
   * isolate their inline LTR math runs with Unicode directional isolates
   * (U+2066 LRI … U+2069 PDI — see src/shared/lib/bidi.ts), so the rendered text
   * no longer contains the raw answer-key string as a contiguous substring (e.g.
   * "ax + b = 0 حيث a ≠ 0" renders as "⁦ax + b = 0 ⁩حيث⁦ a ≠ 0⁩"). Strip the
   * isolates before matching; fall back to the first option when none match.
   */
  private async correctOptionIndex(correctText: string): Promise<number> {
    // Directional isolates are U+2066 (LRI) … U+2069 (PDI). Matched by code
    // point rather than a literal-char regex so no invisible chars live in source.
    const stripIsolates = (s: string): string =>
      [...s]
        .filter((c) => (c.codePointAt(0) ?? 0) < 0x2066 || (c.codePointAt(0) ?? 0) > 0x2069)
        .join("");
    const texts = await this.options.allInnerTexts();
    const idx = texts.findIndex((t) => stripIsolates(t).includes(correctText));
    return idx >= 0 ? idx : 0;
  }
}
