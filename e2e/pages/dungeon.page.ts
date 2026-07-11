import { type Page, type Locator } from "@playwright/test";

/** Dungeon page (`/dungeon`): timed boss mode behind a progress/level gate. */
export class DungeonPage {
  constructor(private readonly page: Page) {}

  /** Progress lock ("Donjon verrouillé") — shown to a user who has not attempted
   * enough distinct subjects/chapters yet. Phase gratuite (étude 15, lot 2): the
   * former concours-entitlement premium gate is gone, this is the first gate. */
  get lockedGate(): Locator {
    return this.page.getByText(/donjon verrouillé/i);
  }
  /** The CTA to start a run (only present once access is fully granted). */
  get enterButton(): Locator {
    return this.page.getByRole("button", { name: /enter the infinite dungeon/i });
  }

  async goto(): Promise<void> {
    await this.page.goto("/dungeon");
  }
}
