import { type Page, type Locator } from "@playwright/test";

/** Authenticated dashboard (`/dashboard`). */
export class DashboardPage {
  constructor(private readonly page: Page) {}

  get subjectCards(): Locator {
    return this.page.locator('a[href^="/subject/"]');
  }
  /** Daily-objective progress like "x / 3". */
  get dailyGoal(): Locator {
    return this.page.getByText(/\/\s*3/).first();
  }
  /** Admin-only nav entry (absent for non-admins). */
  get adminNavLink(): Locator {
    return this.page.locator('a[href="/admin/subscriptions"]').first();
  }
  /** Hero-header stat chips. */
  get statCoins(): Locator {
    return this.page.getByTestId("stat-coins");
  }
  get statXp(): Locator {
    return this.page.getByTestId("stat-xp");
  }
  get statLevel(): Locator {
    return this.page.getByTestId("stat-level");
  }
  /** Nav link to the leaderboard. */
  get leaderboardLink(): Locator {
    return this.page.locator('a[href="/leaderboard"]').first();
  }

  async goto(): Promise<void> {
    await this.page.goto("/dashboard");
    // SSR cold-start + profile/catalogue fetch can exceed the default 5s assertion
    // timeout, leaving <main> briefly empty. Wait for primary data (the hero stat
    // chips or the first subject card) before returning so specs aren't flaky.
    await this.statLevel
      .or(this.subjectCards.first())
      .first()
      .waitFor({ state: "visible", timeout: 30_000 });
  }

  /** Parse the integer balance out of a stat chip (e.g. "1 234 Coins" → 1234). */
  async statNumber(chip: Locator): Promise<number> {
    const raw = (await chip.textContent()) ?? "";
    const digits = raw.replace(/[^\d]/g, "");
    return digits ? Number.parseInt(digits, 10) : 0;
  }

  firstSubject(): Locator {
    return this.subjectCards.first();
  }

  async openFirstSubject(): Promise<void> {
    await this.firstSubject().click();
  }
}
