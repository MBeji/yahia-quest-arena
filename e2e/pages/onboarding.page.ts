import { type Page, type Locator } from "@playwright/test";

/** Onboarding wizard (`/onboarding`): grade → subject → difficulty → confirm. */
export class OnboardingPage {
  constructor(private readonly page: Page) {}

  /** The wizard's "Suivant" advance button (present on every step). */
  get nextButton(): Locator {
    return this.page.getByRole("button", { name: /suivant|next/i });
  }

  async goto(): Promise<void> {
    await this.page.goto("/onboarding");
  }
}
