import { type Page, type Locator } from "@playwright/test";

/**
 * Public practice screen (`/exercice/$exerciseId`) — « mode entraînement » (chantier
 * C8, L1.5). An anonymous visitor answers the QCM and, on « Corriger », gets an
 * immediate correction (right/wrong + explanation + score) via the public
 * `check_answers` RPC — nothing recorded, no XP. The end screen invites account
 * creation as a gain. The action button + score carry stable `data-testid`s (i18n
 * labels); options are matched by ARIA role.
 */
export class PracticePage {
  constructor(private readonly page: Page) {}

  get heading(): Locator {
    return this.page.getByRole("heading", { level: 1 });
  }
  /** One radiogroup per question. */
  get questionGroups(): Locator {
    return this.page.getByRole("radiogroup");
  }
  get checkButton(): Locator {
    return this.page.getByTestId("practice-check");
  }
  /** The score summary — only present once corrected. */
  get score(): Locator {
    return this.page.getByTestId("practice-score");
  }
  /** The end-of-practice account invitation shown to an anonymous visitor. */
  get accountInvite(): Locator {
    return this.page.locator('main a[href="/signup"]');
  }
  /** « Revoir le cours » — links back to the exercise's chapter (when known). */
  get reviewCourseLink(): Locator {
    return this.page.getByTestId("practice-review-course");
  }

  async goto(exerciseId: string): Promise<void> {
    await this.page.goto(`/exercice/${exerciseId}`);
  }

  /**
   * Answer every question by picking its first option. Correctness is irrelevant —
   * the journey asserts that the correction renders (score + per-option feedback),
   * not a particular score. Waits for the first question so it's not racing the
   * `useQuery` content fetch.
   */
  async answerAll(): Promise<void> {
    await this.questionGroups.first().waitFor({ state: "visible", timeout: 15_000 });
    const count = await this.questionGroups.count();
    for (let i = 0; i < count; i += 1) {
      await this.questionGroups.nth(i).getByRole("radio").first().click();
    }
  }
}
