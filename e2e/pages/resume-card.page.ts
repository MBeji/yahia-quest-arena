import { type Page, type Locator } from "@playwright/test";

/**
 * La carte « Reprendre » du visiteur sans compte (étude 38 lot 5) — sur l'accueil et sur
 * `/programme`. Ses libellés sont traduits : tout passe par des `data-testid`.
 */
export class ResumeCardPage {
  /** Les deux clés de l'appareil, telles que `anon-continuity.ts` les écrit. */
  static readonly LAST_CHAPTER_KEY = "na9ra.anon.lastChapter.v1";
  static readonly QUIZ_PASSED_KEY = "na9ra.anon.quizPassed.v1";

  constructor(private readonly page: Page) {}

  get card(): Locator {
    return this.page.getByTestId("resume-card");
  }
  get link(): Locator {
    return this.page.getByTestId("resume-card-link");
  }
  get title(): Locator {
    return this.page.getByTestId("resume-card-title");
  }
  get forget(): Locator {
    return this.page.getByTestId("resume-card-forget");
  }

  /** Ce que l'appareil retient du dernier chapitre — `null` s'il ne retient rien. */
  remembered(): Promise<{ id: string; title: string } | null> {
    return this.page.evaluate((key) => {
      const raw = window.localStorage.getItem(key);
      return raw ? (JSON.parse(raw) as { id: string; title: string }) : null;
    }, ResumeCardPage.LAST_CHAPTER_KEY);
  }

  /** Fait comme si ce visiteur avait lu `chapter` il y a `daysAgo` jours (avant tout chargement). */
  async seed(chapter: { id: string; title: string; lang?: string }, daysAgo = 1): Promise<void> {
    await this.page.addInitScript(
      ([key, entry, flag]) => {
        // Une seule fois par onglet : sans cette garde, chaque navigation réécrirait la mémoire
        // et « oublier » ne pourrait jamais être constaté après un rechargement.
        if (window.sessionStorage.getItem(flag)) return;
        window.sessionStorage.setItem(flag, "1");
        window.localStorage.setItem(key, JSON.stringify(entry));
      },
      [
        ResumeCardPage.LAST_CHAPTER_KEY,
        { lang: "fr", ...chapter, at: Date.now() - daysAgo * 24 * 60 * 60 * 1000 },
        "e2e.resume-seeded",
      ] as const,
    );
  }
}
