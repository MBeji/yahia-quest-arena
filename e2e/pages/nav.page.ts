import { type Page, type Locator, expect } from "@playwright/test";

/** Locale labels exactly as shown in the settings menu. */
export type LocaleLabel = "English" | "Français" | "العربية";

/**
 * Shared chrome present on both the public landing and the authenticated shell:
 * the settings menu (langue, thème, son) and its RTL side effect on <html>.
 *
 * Depuis la consolidation du menu, ce n'est plus un globe dédié mais UN engrenage
 * — le même dans les deux coquilles. Il est ciblé par `data-testid` et non par son
 * aria-label : celui-ci est traduit, et le défaut de l'application est le français
 * (GAP-010), donc un sélecteur par texte ne survivrait pas au premier changement
 * de langue que ces specs provoquent elles-mêmes.
 */
export class NavBar {
  constructor(private readonly page: Page) {}

  /** L'engrenage qui ouvre le menu de réglages. */
  get settingsTrigger(): Locator {
    return this.page.getByTestId("settings-trigger");
  }

  /** Le pop-over lui-même, une fois ouvert. */
  get settingsMenu(): Locator {
    return this.page.getByTestId("settings-menu");
  }

  /**
   * Ouvre le menu s'il ne l'est pas déjà. Réessaie pour absorber la fenêtre
   * d'hydratation post-SSR (un clic qui atterrit avant que React n'ait attaché
   * son gestionnaire est un non-événement) et les bascules accidentelles.
   */
  async openSettings(): Promise<void> {
    await expect(async () => {
      if (!(await this.settingsMenu.isVisible().catch(() => false))) {
        await this.settingsTrigger.click();
      }
      await expect(this.settingsMenu).toBeVisible({ timeout: 1500 });
    }).toPass({ timeout: 15_000 });
  }

  /** Referme le menu — sinon le pop-over reste au-dessus du contenu de la page. */
  async closeSettings(): Promise<void> {
    if (await this.settingsMenu.isVisible().catch(() => false)) {
      await this.page.keyboard.press("Escape");
      await expect(this.settingsMenu).toBeHidden();
    }
  }

  /** Ouvre le menu, choisit une locale par son libellé natif, referme. */
  async changeLanguage(label: LocaleLabel): Promise<void> {
    await this.openSettings();
    await this.settingsMenu.getByRole("menuitemradio", { name: label }).click();
    await this.closeSettings();
  }

  /** Vérifie que le CONTRÔLE reflète la locale active, pas seulement le document. */
  async expectActiveLanguage(label: LocaleLabel): Promise<void> {
    await this.openSettings();
    await expect(this.settingsMenu.getByRole("menuitemradio", { name: label })).toHaveAttribute(
      "aria-checked",
      "true",
    );
    await this.closeSettings();
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
