import { test, expect } from "../fixtures";
import { CataloguePage } from "../pages/public-catalogue.page";

/**
 * Public catalogue browsed LOGGED OUT against the real TEST backend (anon reads).
 * The C8 pivot: the official 3-parcours programme + the optional extras are public
 * — no account, no premium, no login wall. (Page objects are instantiated locally:
 * this is a self-contained tier; only `adminDb`/`page` come from the fixtures.)
 */
test.describe("Public catalogue (logged out)", () => {
  test("the programme lists navigable levels and cross-links the extras", async ({ page }) => {
    const catalogue = new CataloguePage(page);
    await catalogue.gotoProgramme();

    await expect(catalogue.heading).toBeVisible({ timeout: 15_000 });
    // The TEST project has content, so at least one produced level is navigable.
    await expect(catalogue.levelLinks.first()).toBeVisible({ timeout: 15_000 });
    // The optional extras live on their own page, cross-linked from the programme.
    await expect(catalogue.extrasLink).toBeVisible();
    await expect(page).not.toHaveURL(/\/auth/);
  });

  test("opening a level shows that level, still logged out", async ({ page }) => {
    const catalogue = new CataloguePage(page);
    await catalogue.gotoProgramme();
    await catalogue.levelLinks.first().waitFor({ state: "visible", timeout: 15_000 });
    await catalogue.levelLinks.first().click();

    await expect(page).toHaveURL(/\/niveau\//);
    // Its subjects may be present or "bientôt", but we must not be bounced to login.
    await expect(catalogue.heading).toBeVisible({ timeout: 15_000 });
    await expect(page).not.toHaveURL(/\/auth/);
  });

  test("the extras page is public and lists optional tracks", async ({ page }) => {
    const catalogue = new CataloguePage(page);
    await catalogue.gotoExtras();

    await expect(catalogue.heading).toBeVisible({ timeout: 15_000 });
    // Each extra (langues, culture générale, muscle-cerveau…) links to its level page.
    await expect(catalogue.levelLinks.first()).toBeVisible({ timeout: 15_000 });
    await expect(page).not.toHaveURL(/\/auth/);
  });
});
