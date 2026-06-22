import { type Page, type Locator } from "@playwright/test";

/**
 * Public subject hub (`/matiere/$subjectId`) — « Référence » register (chantier C8).
 * Lists a subject's chapters (each → its public course reader) and their exercises.
 * No premium lock and no gameplay progress (that's the connected Jeu register, L2).
 * Exercise links are auth-aware: logged out → free practice (`/exercice`); the
 * comprehension quiz stays the connected gate (`/quest`).
 */
export class SubjectHubPage {
  constructor(private readonly page: Page) {}

  get heading(): Locator {
    return this.page.getByRole("heading", { level: 1 });
  }
  /** Each chapter's "read the course" button → the public reader. */
  get courseLinks(): Locator {
    return this.page.locator('main a[href^="/chapitre/"]');
  }
  /** Free-practice exercise links — what an anonymous visitor sees (auth-aware). */
  get practiceLinks(): Locator {
    return this.page.locator('main a[href^="/exercice/"]');
  }
  /** Scored-quest links — only for signed-in users, plus the comprehension quiz. */
  get questLinks(): Locator {
    return this.page.locator('main a[href^="/quest/"]');
  }

  async goto(subjectId: string): Promise<void> {
    await this.page.goto(`/matiere/${subjectId}`);
  }
}
