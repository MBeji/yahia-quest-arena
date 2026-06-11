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
  /** Empty-state message shown when no hero has any XP yet. */
  get emptyState(): Locator {
    return this.page.getByText(/aucun héros inscrit|aucun score|no heroes registered yet/i);
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
