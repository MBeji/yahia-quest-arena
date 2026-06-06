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

  async goto(): Promise<void> {
    await this.page.goto("/dashboard");
  }

  firstSubject(): Locator {
    return this.subjectCards.first();
  }

  async openFirstSubject(): Promise<void> {
    await this.firstSubject().click();
  }
}
