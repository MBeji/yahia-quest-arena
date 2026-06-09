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
   * Per-parcours premium lock badge shown on a difficulty>=2 mission to a user
   * without an entitlement on a premium (concours) parcours. The subject page
   * renders the localized "unlock" label (FR "À débloquer", EN "Unlock", AR
   * "للفتح") next to a lock icon — NOT the quest-page "Parcours premium" copy.
   */
  get premiumLock(): Locator {
    return this.page.getByText(/à débloquer|unlock|للفتح/i);
  }
  /** "✓ Passed" badge shown on a chapter once its comprehension quiz is cleared
   * (FR "✓ Réussi", EN "✓ Passed", AR "✓ ناجح"). */
  get passedBadge(): Locator {
    return this.page.getByText(/réussi|passed|ناجح/i);
  }
  // Generic "premium" copy matcher. NOTE: the premium paywall + beta CTA now render
  // on the QUEST page (opening a gated mission), not on the subject page — the
  // subject page only shows the per-mission `premiumLock` badge. Use the quest Page
  // Object's paywallPremiumText / betaCta for the paywall itself.
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
