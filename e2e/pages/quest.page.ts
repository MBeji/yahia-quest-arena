import { type Page, type Locator } from "@playwright/test";

/** Quest page (`/quest/$id`): the QCM runner, plus the premium paywall / quiz lock. */
export class QuestPage {
  constructor(private readonly page: Page) {}

  // Subscription paywall (shown when a free user opens a difficulty 3+ / premium mission).
  get paywallPremiumText(): Locator {
    return this.page.getByText(/premium/i).first();
  }
  get betaCta(): Locator {
    return this.page.getByRole("button", { name: /bêta|beta/i });
  }

  async goto(id: string): Promise<void> {
    await this.page.goto(`/quest/${id}`);
  }
}
