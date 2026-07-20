import { type Page, type Locator } from "@playwright/test";

/** Leaderboard page (`/leaderboard`): global + per-subject XP rankings. */
export class LeaderboardPage {
  constructor(private readonly page: Page) {}

  get heading(): Locator {
    return this.page.getByRole("heading", { name: /classement|leaderboard/i });
  }
  /** One row per ranked player in the full ranking list. */
  get rows(): Locator {
    return this.page.getByTestId("leaderboard-row");
  }
  /** The "🌍 Global" tab. */
  get globalTab(): Locator {
    return this.page.getByTestId("leaderboard-global-tab");
  }
  /** The "You" chip on the current user's own row (present only if ranked). */
  get meBadge(): Locator {
    return this.page.getByText("You", { exact: true });
  }
  /**
   * The empty-state block, shown when the active board has no ranked hero yet.
   *
   * Matched on the shared EmptyState hook, NOT on copy. The previous locator
   * looked for "aucun héros inscrit" (`leaderboard.emptyGlobal`), which stopped
   * being rendered when étude 15 lot 11 replaced the flat message with the
   * cold-start invitation ("Le classement démarre !"); étude 22 lot 4 then added
   * a third wording for the "Ma classe" cohort. Since `reset-gameplay` wipes all
   * XP before every run, the board is ALWAYS empty in CI — so the dead copy made
   * this locator match nothing at all, and the test failed on a board that was in
   * fact rendering correctly.
   */
  get emptyState(): Locator {
    return this.page.getByTestId("empty-state");
  }
  /** All subject tabs — scoped to the active parcours' subjects (GAP-018). */
  get subjectTabs(): Locator {
    return this.page.getByTestId("leaderboard-subject-tab");
  }
  /** A subject tab, located by the subject's display name. */
  subjectTab(name: string): Locator {
    return this.page.getByRole("button", { name, exact: true });
  }

  async goto(): Promise<void> {
    await this.page.goto("/leaderboard");
  }
}
