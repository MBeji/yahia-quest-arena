import { type Page, type Locator, expect } from "@playwright/test";

/** Locale labels exactly as shown in the LanguageSwitcher dropdown. */
export type LocaleLabel = "English" | "Français" | "العربية";

/**
 * Shared chrome present on both the public landing and the authenticated shell:
 * the language switcher (and its RTL side effect on <html>). Use from any page.
 */
export class NavBar {
  constructor(private readonly page: Page) {}

  /** The globe button that opens the language menu (aria-label="Change language"). */
  get languageTrigger(): Locator {
    return this.page.getByRole("button", { name: /change language/i });
  }

  /**
   * Open the language menu and pick a locale by its native label. Retries opening
   * the menu so it is robust to the post-SSR hydration window (a click that lands
   * before React attaches the handler is a no-op) and to accidental toggles.
   */
  async changeLanguage(label: LocaleLabel): Promise<void> {
    const option = this.page.getByRole("button", { name: label });
    await expect(async () => {
      if (!(await option.isVisible().catch(() => false))) {
        await this.languageTrigger.click();
      }
      await expect(option).toBeVisible({ timeout: 1500 });
    }).toPass({ timeout: 15_000 });
    await option.click();
  }

  /** Current document direction — "rtl" only when Arabic is active. */
  async htmlDir(): Promise<string | null> {
    return this.page.locator("html").getAttribute("dir");
  }

  /** Current document language code ("en" | "fr" | "ar"). */
  async htmlLang(): Promise<string | null> {
    return this.page.locator("html").getAttribute("lang");
  }
}
