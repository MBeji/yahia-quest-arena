import { type Page, type Locator } from "@playwright/test";

/** Subject page (`/subject/$id`): chapters, missions, and the premium gate. */
export class SubjectPage {
  constructor(private readonly page: Page) {}

  get missionLinks(): Locator {
    return this.page.locator('a[href^="/quest/"]');
  }
  /** Mission tiles locked behind the chapter comprehension quiz (school program
   * only after the gate change). Non-link tiles tagged data-testid="mission-locked". */
  get lockedMissions(): Locator {
    return this.page.getByTestId("mission-locked");
  }
  /**
   * Difficulty 3+ premium lock label shown to free users. The wording follows
   * the subject's content language: FR "Abonnement requis", EN "Subscription
   * required", AR "يتطلب اشتراكًا".
   */
  get premiumLock(): Locator {
    return this.page.getByText(/abonnement requis|subscription required|يتطلب اشتراك/i);
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
