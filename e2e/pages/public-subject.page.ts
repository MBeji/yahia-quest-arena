import { type Page, type Locator } from "@playwright/test";

/**
 * Public subject hub (`/matiere/$subjectId`) — « Référence » register (chantier C8).
 * Lists a subject's chapters (each → its public course reader) and their exercises.
 * No premium lock and no gameplay progress (that's the connected Jeu register, L2).
 * Exercise links are auth-aware: logged out → free practice (`/exercice`) for
 * EVERY exercise (the comprehension quiz included — the public practice page
 * turns it into an account invite); signed in → the scored quest (`/quest`).
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
  /** Scored-quest links — what a signed-in user sees; empty for an anonymous visitor. */
  get questLinks(): Locator {
    return this.page.locator('main a[href^="/quest/"]');
  }

  /** A specific exercise's free-practice link, matched by its resolved href. */
  exerciseLinkById(exerciseId: string): Locator {
    return this.page.locator(`main a[href="/exercice/${exerciseId}"]`);
  }

  async goto(subjectId: string): Promise<void> {
    await this.page.goto(`/matiere/${subjectId}`);
  }
}
