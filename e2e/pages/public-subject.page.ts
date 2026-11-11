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

  // --- Étoiles & sceaux vus sans compte (étude 34, R-16) --------------------
  /** Le bloc « état de la matière » — présent pour tous, vide sans compte. */
  get seals(): Locator {
    return this.page.getByTestId("subject-seals");
  }
  /** Les quatre cachets — tous en attente pour un visiteur sans compte. */
  get sealMarks(): Locator {
    return this.page.getByTestId("seal-mark");
  }
  /** « Connecte-toi pour garder tes étoiles » — la promesse, jamais un verrou. */
  get anonPromise(): Locator {
    return this.page.getByTestId("seal-anon-promise");
  }
  /** Les compteurs d'effort — jamais rendus sans compte (rien ne se calcule). */
  get effort(): Locator {
    return this.page.getByTestId("subject-effort");
  }
  /** Les crans ACQUIS — aucun ne peut l'être sans compte. */
  get litRungs(): Locator {
    return this.page.locator('[data-testid^="star-rung-"][data-lit="true"]');
  }

  /** A specific exercise's free-practice link, matched by its resolved href. */
  exerciseLinkById(exerciseId: string): Locator {
    return this.page.locator(`main a[href="/exercice/${exerciseId}"]`);
  }

  async goto(subjectId: string): Promise<void> {
    await this.page.goto(`/matiere/${subjectId}`);
  }
}
