import { type Page, type Locator } from "@playwright/test";

/** Authenticated dashboard (`/dashboard`). */
export class DashboardPage {
  constructor(private readonly page: Page) {}

  get subjectCards(): Locator {
    // Dashboard subject cards now link to the public subject hub `/matiere/$id`
    // (chantier C8 renamed `/subject` → `/matiere`).
    return this.page.locator('a[href^="/matiere/"]');
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
    // SSR cold-start + profile/catalogue fetch can leave <main> briefly empty.
    // Best-effort wait for primary data (hero stat chips or the first subject
    // card) so data-dependent specs aren't flaky — but DON'T fail here: some
    // dashboards (e.g. the admin account with no grade) render neither, and those
    // specs only assert nav/role. Each spec still waits on what it actually needs.
    await this.statLevel
      .or(this.subjectCards.first())
      .first()
      .waitFor({ state: "visible", timeout: 15_000 })
      .catch(() => {});
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
