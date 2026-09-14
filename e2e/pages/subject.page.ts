import { type Page, type Locator } from "@playwright/test";

/**
 * Subject hub (`/matiere/$id`) — the public « Référence » register page (chantier
 * C8), reached by both anonymous AND signed-in visitors. The legacy `/subject/$id`
 * path 301-redirects here. For a signed-in visitor, exercise links route to the
 * scored quest (`/quest`); the comprehension quiz also routes to `/quest`.
 *
 * NOTE (C8): the old subject page's VISUAL state — per-mission quiz locks
 * (`mission-locked`), per-parcours premium locks ("à débloquer"), and the chapter
 * "✓ passed" badge — is NOT rendered on this Référence hub. That gameplay layer is
 * deferred to L2 (re-enrichment of the connected hub); meanwhile the quiz + premium
 * gates remain enforced SERVER-SIDE on `/quest`: quiz-gate asserts the quiz lock via
 * `QuestPage.quizLock`, et premium-gate vérifie la phase gratuite à sa source — aucun
 * parcours n'est premium — puisque le paywall lui-même est inatteignable (issue #733).
 */
export class SubjectPage {
  constructor(private readonly page: Page) {}

  /** Exercise/quest links on the hub (for a signed-in visitor → `/quest/$id`). */
  get missionLinks(): Locator {
    return this.page.locator('a[href^="/quest/"]');
  }
  /** Each chapter's "read the course" link → the public reader. */
  get courseLinks(): Locator {
    return this.page.locator('a[href^="/chapitre/"]');
  }

  // --- Étoiles de chapitre & sceaux de matière (étude 34) -------------------
  /** Le bloc « état de la matière » : sceaux, prochain sceau, effort. */
  get seals(): Locator {
    return this.page.getByTestId("subject-seals");
  }
  /** Les quatre cachets de sceau — `data-earned` dit lesquels sont inscrits. */
  get sealMarks(): Locator {
    return this.page.getByTestId("seal-mark");
  }
  /** La promesse faite à l'anonyme (R-16) — absente dès qu'on est connecté. */
  get anonPromise(): Locator {
    return this.page.getByTestId("seal-anon-promise");
  }
  /** Les compteurs d'effort — présents pour un compte, jamais pour l'anonyme. */
  get effort(): Locator {
    return this.page.getByTestId("subject-effort");
  }
  /** Tous les crans de jauge de la page (tous chapitres confondus). */
  get rungs(): Locator {
    return this.page.locator('[data-testid^="star-rung-"]');
  }
  /** Les crans ACQUIS — ceux qui se lisent au grand livre. */
  get litRungs(): Locator {
    return this.page.locator('[data-testid^="star-rung-"][data-lit="true"]');
  }

  async goto(id: string): Promise<void> {
    await this.page.goto(`/matiere/${id}`);
  }

  firstMission(): Locator {
    return this.missionLinks.first();
  }

  async openFirstMission(): Promise<void> {
    await this.firstMission().click();
  }
}
