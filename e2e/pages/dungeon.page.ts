import { type Page, type Locator } from "@playwright/test";

/** Dungeon page (`/dungeon`): timed boss mode behind a progress/level gate. */
export class DungeonPage {
  constructor(private readonly page: Page) {}

  /** Progress lock ("Donjon verrouillé") — shown to a user WITH a concours
   * entitlement who has not attempted enough distinct subjects/chapters yet. */
  get lockedGate(): Locator {
    return this.page.getByText(/donjon verrouillé/i);
  }
  /** Concours-entitlement gate — the Dungeon is a premium perk reserved to holders
   * of a concours parcours entitlement, so a user without one is gated here (the
   * live SubscriptionPaywall, title "Premium Feature") before the progress gate. */
  get premiumGate(): Locator {
    return this.page.getByText(/premium/i).first();
  }
  /** The CTA to start a run (only present once access is fully granted). */
  get enterButton(): Locator {
    return this.page.getByRole("button", { name: /enter the infinite dungeon/i });
  }

  async goto(): Promise<void> {
    await this.page.goto("/dungeon");
  }
}
