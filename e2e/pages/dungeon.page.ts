import { type Page, type Locator } from "@playwright/test";

/** Dungeon page (`/dungeon`): timed boss mode behind a progress/level gate. */
export class DungeonPage {
  constructor(private readonly page: Page) {}

  /** Progress lock ("Donjon verrouillé") — shown to a subscriber without enough
   * distinct subjects/chapters attempted yet. */
  get lockedGate(): Locator {
    return this.page.getByText(/donjon verrouillé/i);
  }
  /** Subscription paywall — the Dungeon is a premium feature, so free users are
   * gated here before the progress gate. */
  get premiumGate(): Locator {
    return this.page.getByText(/premium feature|reserved for subscribed/i).first();
  }
  /** The CTA to start a run (only present once access is fully granted). */
  get enterButton(): Locator {
    return this.page.getByRole("button", { name: /enter the infinite dungeon/i });
  }

  async goto(): Promise<void> {
    await this.page.goto("/dungeon");
  }
}
