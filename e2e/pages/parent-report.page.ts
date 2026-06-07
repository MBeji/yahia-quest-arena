import { type Page, type Locator, expect } from "@playwright/test";

/** Parent report (`/parent-report`): link students by alliance code, view reports. */
export class ParentReportPage {
  constructor(private readonly page: Page) {}

  get codeInput(): Locator {
    return this.page.getByPlaceholder(/code eleve/i);
  }
  get relationInput(): Locator {
    return this.page.getByPlaceholder(/relation/i);
  }
  get associer(): Locator {
    return this.page.getByRole("button", { name: /associer/i });
  }
  /** A linked student row/name in the parent's view. */
  student(name: string): Locator {
    return this.page.getByText(name, { exact: false });
  }

  async goto(): Promise<void> {
    await this.page.goto("/parent-report");
  }

  /**
   * Enter an alliance code and submit. Retries the fill to beat the hydration
   * window — a controlled-input fill before React attaches onChange leaves the
   * component state empty, so the "Associer" button stays disabled.
   */
  async link(code: string): Promise<void> {
    await expect(async () => {
      await this.codeInput.fill(code);
      await expect(this.associer).toBeEnabled({ timeout: 1000 });
    }).toPass({ timeout: 15_000 });
    await this.associer.click();
  }
}
