import { type Page, type Locator } from "@playwright/test";

/**
 * Public course reader (`/chapitre/$chapterId`) — « Référence » register (chantier
 * C8, L1.4). Reading NEVER requires an account: course/summary toggle, print, and
 * a soft account invitation at the bottom. The action buttons carry stable
 * `data-testid`s (their labels are i18n), the body uses the `.lesson-content`
 * class, and the invite is matched by its signup href.
 */
export class LessonReaderPage {
  constructor(private readonly page: Page) {}

  get heading(): Locator {
    return this.page.getByRole("heading", { level: 1 });
  }
  /** The rendered course/summary markdown body. */
  get content(): Locator {
    return this.page.locator(".lesson-content");
  }
  get courseTab(): Locator {
    return this.page.getByTestId("lesson-tab-course");
  }
  /** Only rendered when the chapter has a summary. */
  get summaryTab(): Locator {
    return this.page.getByTestId("lesson-tab-summary");
  }
  get printButton(): Locator {
    return this.page.getByTestId("lesson-print");
  }
  /** The « practise this chapter » CTA — present when the chapter has a non-quiz exercise. */
  get practiceCta(): Locator {
    return this.page.getByTestId("lesson-practice-cta");
  }
  /** The soft account invitation (an upsell to play, never a wall). */
  get accountInvite(): Locator {
    return this.page.locator('aside a[href="/signup"]');
  }

  async goto(chapterId: string): Promise<void> {
    await this.page.goto(`/chapitre/${chapterId}`);
  }
}
