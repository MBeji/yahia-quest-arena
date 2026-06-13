import { type Page, type Locator } from "@playwright/test";

/** Onboarding wizard (`/onboarding`): intent → parcours → confirm. */
export class OnboardingPage {
  constructor(private readonly page: Page) {}

  /** Step 0 heading — "Que veux-tu faire ?" / "What do you want to do?".
   * The first step is an intent picker (concours vs explorer) with no "Next"
   * button, so the heading is the stable smoke signal that the wizard rendered. */
  get heading(): Locator {
    return this.page.getByRole("heading", {
      name: /que veux-tu faire|what do you want to do/i,
    });
  }

  /** The two intent choices on step 0 (concours / explorer). */
  get intentChoices(): Locator {
    return this.page.getByRole("button", {
      name: /concours|explore|j'explore|i prepare|je prépare/i,
    });
  }

  async goto(): Promise<void> {
    await this.page.goto("/onboarding");
  }
}
