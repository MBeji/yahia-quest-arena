import { type Page, type Locator } from "@playwright/test";

/** Subject page (`/subject/$id`): chapters, missions, and the premium gate. */
export class SubjectPage {
  constructor(private readonly page: Page) {}

  get missionLinks(): Locator {
    return this.page.locator('a[href^="/quest/"]');
  }
  /** Difficulty 3+ premium lock label shown to free users ("Abonnement requis"). */
  get premiumLock(): Locator {
    return this.page.getByText(/abonnement requis/i);
  }
  // Subscription paywall (rendered in-page for a premium/subscription-only subject).
  get paywallPremiumText(): Locator {
    return this.page.getByText(/premium/i).first();
  }
  get betaCta(): Locator {
    return this.page.getByRole("button", { name: /bêta|beta/i });
  }

  async goto(id: string): Promise<void> {
    await this.page.goto(`/subject/${id}`);
  }

  firstMission(): Locator {
    return this.missionLinks.first();
  }

  async openFirstMission(): Promise<void> {
    await this.firstMission().click();
  }
}
