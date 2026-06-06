import { type Page, type Locator } from "@playwright/test";

/** Public landing page (`/`). Selectors are locale-independent (brand, hrefs, anchors). */
export class LandingPage {
  constructor(private readonly page: Page) {}

  get brand(): Locator {
    return this.page.getByRole("link", { name: /XP\s*SCHOLARS/i }).first();
  }
  get signupCta(): Locator {
    return this.page.locator('a[href="/signup"]').first();
  }
  get loginCta(): Locator {
    return this.page.locator('a[href="/login"]').first();
  }
  get reduceAnimationsToggle(): Locator {
    return this.page.getByRole("button", { name: /animations/i });
  }

  async goto(): Promise<void> {
    await this.page.goto("/");
  }

  /** Anchored marketing section, e.g. "features" | "subjects" | "ranks". */
  section(id: string): Locator {
    return this.page.locator(`#${id}`);
  }
}
