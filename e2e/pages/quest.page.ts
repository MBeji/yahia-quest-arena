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

  // --- Active recall (étude 17) ---
  /** The recall-mode banner shown atop a `?variant=recall` run. */
  get recallBanner(): Locator {
    return this.page.getByTestId("recall-banner");
  }
  /** The recall free-text answer field (replaces the radios in a recall run). */
  get recallInput(): Locator {
    return this.page.getByTestId("recall-answer-input");
  }
  /** The current question's prompt (rendered as an <h2> by the player). */
  get prompt(): Locator {
    return this.page.locator("h2").first();
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
   * so a passing attempt actually awards XP/coins.
   *
   * This helper NEVER guesses. If a rendered prompt is missing from the key, its
   * correct text is empty, or the correct option can't be uniquely identified, it
   * THROWS with the offending prompt + the rendered options. It used to fall back
   * to clicking `this.options.first()` — a blind guess that turned a broken answer
   * key into a non-deterministic sub-100% score (right by luck some of the time,
   * because the UI reshuffles options every render) instead of a self-diagnosing
   * failure. See issue #363.
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
      if (!byPrompt.has(prompt)) {
        throw new Error(
          [
            "answerAllCorrectly: the rendered question is not in the answer key, so it",
            "cannot be answered correctly (the classic run must reach 100%).",
            `  rendered prompt: ${JSON.stringify(prompt)}`,
            "  answer-key prompts:",
            ...answerKey.map((k) => `    ${JSON.stringify(k.prompt)}`),
          ].join("\n"),
        );
      }
      const correctText = (byPrompt.get(prompt) ?? "").trim();
      if (correctText.length === 0) {
        throw new Error(
          [
            "answerAllCorrectly: the answer key has no correct text for this question,",
            "so the right option can't be chosen. Likely `correct_option` matches no",
            "option id, or the correct option is figure-only (see e2e/helpers/db.ts).",
            `  prompt: ${JSON.stringify(prompt)}`,
          ].join("\n"),
        );
      }
      const option = this.options.nth(await this.correctOptionIndex(prompt, correctText));
      // Pause before selecting so per-question time exceeds
      // MIN_SECONDS_PER_QUESTION (4s) → attempt isn't void. Validation is manual
      // now (no auto-advance), so the whole budget must come from this pause.
      await this.answerCurrent(option, preSelectPauseMs);
    }
  }

  /**
   * Index of the rendered option whose text matches the answer-key `correctText`.
   * The match is exact-first and NEVER guesses (issue #363):
   *
   *  - Each rendered radio reads as "<displayId> <option text>" (the A/B/C badge
   *    then the text). We strip the leading display-id token and compare the rest
   *    to `correctText` for EQUALITY — so a short answer like "3" matches the "3"
   *    option and not the "13"/"30" distractors. The previous `.includes()`
   *    substring match picked the FIRST option that merely contained the text,
   *    which the per-render option shuffle made non-deterministic — the varying
   *    sub-100% score in #363.
   *  - Arabic options isolate their inline LTR math runs with Unicode directional
   *    isolates (U+2066 LRI … U+2069 PDI — see src/shared/lib/bidi.ts), e.g.
   *    "ax + b = 0 حيث a ≠ 0" renders as "⁦ax + b = 0 ⁩حيث⁦ a ≠ 0⁩". We strip the
   *    isolates before comparing.
   *  - A UNIQUE substring match is still accepted (a figure/whitespace safety
   *    valve), but ambiguity or no match THROWS with the prompt, the expected text
   *    and every rendered option — a self-diagnosing failure, never a blind
   *    `options.first()` guess.
   */
  private async correctOptionIndex(prompt: string, correctText: string): Promise<number> {
    // Directional isolates are U+2066 (LRI) … U+2069 (PDI). Matched by code
    // point rather than a literal-char regex so no invisible chars live in source.
    const stripIsolates = (s: string): string =>
      [...s]
        .filter((c) => (c.codePointAt(0) ?? 0) < 0x2066 || (c.codePointAt(0) ?? 0) > 0x2069)
        .join("");
    // Collapse whitespace (the radio's flex layout can insert a newline between
    // the display-id badge and the text) and trim, on both sides of every compare.
    const norm = (s: string): string => stripIsolates(s).replace(/\s+/g, " ").trim();
    const target = norm(correctText);
    const rawTexts = await this.options.allInnerTexts();
    const options = rawTexts.map((raw) => {
      const normalized = norm(raw);
      // Drop the leading "A "/"B "… display-id badge to isolate the option's own text.
      return { raw, normalized, body: normalized.replace(/^\S+\s+/, "") };
    });
    const exact = options
      .map((o, idx) => ({ o, idx }))
      .filter(({ o }) => o.body === target || o.normalized === target);
    if (exact.length === 1) return exact[0].idx;
    const substring = options
      .map((o, idx) => ({ o, idx }))
      .filter(({ o }) => o.normalized.includes(target));
    if (exact.length === 0 && substring.length === 1) return substring[0].idx;
    throw new Error(
      [
        "correctOptionIndex: cannot uniquely identify the correct option — refusing",
        "to guess (a blind pick yields a non-deterministic score, issue #363).",
        `  prompt: ${JSON.stringify(prompt)}`,
        `  correctText: ${JSON.stringify(target)}`,
        `  exact/display-id matches: ${exact.length} · substring matches: ${substring.length}`,
        "  rendered options:",
        ...options.map((o, i) => `    [${i}] ${JSON.stringify(o.normalized)}`),
      ].join("\n"),
    );
  }

  /**
   * Play a whole RECALL run (étude 17): for each question, read the prompt, look
   * up its correct answer text in the key, type it into the free-text field, and
   * submit. Matches by prompt because the recall set is a subset (only eligible
   * questions) served in its own order. Paces each answer past the server's "too
   * fast" anti-farm floor (≥4s/question) so the pass actually awards (boosted) XP.
   */
  async answerRecallAll(
    answerKey: { prompt: string; correctText: string }[],
    preSelectPauseMs = 4500,
  ): Promise<void> {
    // Directional isolates (U+2066…U+2069) wrap inline LTR runs in Arabic prompts;
    // strip them so a rendered prompt matches its raw answer-key string.
    const strip = (s: string): string =>
      [...s]
        .filter((c) => (c.codePointAt(0) ?? 0) < 0x2066 || (c.codePointAt(0) ?? 0) > 0x2069)
        .join("")
        .trim();
    const byPrompt = new Map(answerKey.map((k) => [strip(k.prompt), k.correctText]));
    const maxQuestions = answerKey.length + 5; // safety cap
    for (let i = 0; i < maxQuestions; i += 1) {
      await expect(this.recallInput.or(this.score)).toBeVisible({ timeout: 20_000 });
      if (await this.score.isVisible().catch(() => false)) return;
      const before = strip((await this.prompt.innerText().catch(() => "")) ?? "");
      const answer = byPrompt.get(before) ?? "";
      if (preSelectPauseMs > 0) await this.page.waitForTimeout(preSelectPauseMs);
      await this.recallInput.fill(answer);
      await expect(this.submit).toBeEnabled({ timeout: 5000 });
      await this.submit.click();
      await expect
        .poll(
          async () => {
            if (await this.score.isVisible().catch(() => false)) return "done";
            const now = strip((await this.prompt.innerText().catch(() => "")) ?? "");
            return now && now !== before ? "next" : "wait";
          },
          { timeout: 12_000 },
        )
        .not.toBe("wait");
    }
  }
}
