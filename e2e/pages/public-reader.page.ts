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

  /** The reader's own page title. Scoped to the article header so a `# ` heading
   *  inside the lesson markdown (rendered as `<h1 class="lesson-h1">`) doesn't make
   *  this resolve to two elements. */
  get heading(): Locator {
    return this.page.locator("article header h1");
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
  /** Le bloc « à toi » d'une leçon (étude 35) — la seule chose du lecteur qui change d'état. */
  get check(): Locator {
    return this.page.locator(".lesson-blk--verifie");
  }
  /** Le bouton qui déplie la réponse. Son libellé suit la langue du CONTENU, pas celle de l'UI. */
  get checkToggle(): Locator {
    return this.page.locator(".lesson-check__toggle");
  }
  /** La réponse : présente dans le DOM, invisible tant que le bloc est replié. */
  get checkAnswer(): Locator {
    return this.page.locator(".lesson-check__answer");
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
