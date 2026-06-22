import { type Page, type Locator } from "@playwright/test";

/**
 * Public catalogue — the official 3-parcours programme (`/programme`), the
 * optional extras (`/extras`) and a level page (`/niveau/$parcoursId`). « Référence »
 * register, browsed LOGGED OUT (chantier C8). Selectors are locale-independent
 * (route hrefs + role-based heading), so they survive FR/EN/AR + RTL.
 */
export class CataloguePage {
  constructor(private readonly page: Page) {}

  /** The page H1 (programme / extras / level title). Role-based → locale-agnostic. */
  get heading(): Locator {
    return this.page.getByRole("heading", { level: 1 });
  }
  /** Available level cards link to their level page. `coming_soon` cards render as
   *  non-link divs, so this counts only the navigable levels. */
  get levelLinks(): Locator {
    return this.page.locator('main a[href^="/niveau/"]');
  }
  /** Subject cards on a level page → the public subject hub. */
  get subjectLinks(): Locator {
    return this.page.locator('main a[href^="/matiere/"]');
  }
  /** The "see the extras" cross-link in the programme footer block. */
  get extrasLink(): Locator {
    return this.page.locator('main a[href="/extras"]');
  }

  async gotoProgramme(): Promise<void> {
    await this.page.goto("/programme");
  }
  async gotoExtras(): Promise<void> {
    await this.page.goto("/extras");
  }
  async gotoLevel(parcoursId: string): Promise<void> {
    await this.page.goto(`/niveau/${parcoursId}`);
  }
}
