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
 * gates remain enforced SERVER-SIDE on `/quest` (asserted by quiz-gate / premium-gate
 * via the QuestPage's quizLock / paywall).
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
