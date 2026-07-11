import { type Page, type Locator } from "@playwright/test";

/**
 * Academy Shop — étude 15 lot 6 (D-5) moved it (with the badges + radar +
 * inventory) off the dashboard to the dedicated `/boutique` route. Scopes every
 * query to the shop section so it never collides with the badges grid or the
 * inventory sidebar (which also has "Activer" buttons).
 */
export class ShopPage {
  constructor(private readonly page: Page) {}

  async goto(): Promise<void> {
    await this.page.goto("/boutique");
    await this.section.waitFor({ state: "visible", timeout: 15_000 }).catch(() => {});
  }

  get section(): Locator {
    return this.page.getByTestId("shop");
  }
  get items(): Locator {
    return this.section.getByTestId("shop-item");
  }
  /** Buy buttons (aria-label="Acheter <name>" / "Buy <name>"); disabled when unaffordable. */
  get buyButtons(): Locator {
    return this.section.getByRole("button", { name: /^(Acheter|Buy)/i });
  }
  /** Activate buttons for armable consumables the user owns. */
  get activateButtons(): Locator {
    return this.section.getByRole("button", { name: /^(Activer|Activate)/i });
  }
  /** Ownership chips ("En stock x…", "Possédé", "Équipé" — FR default, EN tolerated). */
  get ownedBadges(): Locator {
    return this.section.getByText(/En stock|Possédé|Équipé|In stock|Owned|Equipped/);
  }
  /** Armed chips ("Actif · …") shown after a consumable is activated. */
  get activeBadges(): Locator {
    return this.section.getByText(/Actif ·/);
  }
}
