import { type Page, type Locator } from "@playwright/test";

/**
 * Academy Shop — rendered inside the dashboard (`/dashboard`), not a standalone
 * route. Scopes every query to the shop section so it never collides with the
 * badges grid or the inventory sidebar (which also has "Activer" buttons).
 */
export class ShopPage {
  constructor(private readonly page: Page) {}

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
