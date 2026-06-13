import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

// Shop economy (gamification): coins are spent on purchases and purchased
// consumables can be armed. Uses the premium account so it never collides with
// the free-account gating specs. Coins are set deterministically via the admin
// DB, then we assert relative changes in the UI.
test.use({ storageState: STORAGE_STATE.premium });

test.describe("Academy shop", () => {
  test("buying an item spends coins and marks it owned", async ({ dashboard, shop, adminDb }) => {
    const userId = await adminDb.userIdByEmail(TEST_USERS.premium.email);
    await adminDb.setCoins(userId, 99_999);

    await dashboard.goto();
    await expect(dashboard.statCoins).toBeVisible();
    await expect
      .poll(() => dashboard.statNumber(dashboard.statCoins), { timeout: 15_000 })
      .toBe(99_999);

    await expect(shop.items.first()).toBeVisible();
    const before = await dashboard.statNumber(dashboard.statCoins);
    const ownedBefore = await shop.ownedBadges.count();

    await shop.buyButtons.first().click();

    await expect
      .poll(() => dashboard.statNumber(dashboard.statCoins), { timeout: 15_000 })
      .toBeLessThan(before);
    await expect
      .poll(() => shop.ownedBadges.count(), { timeout: 15_000 })
      .toBeGreaterThan(ownedBefore);
  });

  test("a purchased consumable can be armed", async ({ dashboard, shop, adminDb }) => {
    test.setTimeout(60_000);
    const userId = await adminDb.userIdByEmail(TEST_USERS.premium.email);
    await adminDb.setCoins(userId, 99_999);
    await dashboard.goto();

    // Buy a known armable consumable (the coin potion) and arm it — targeted, so
    // it stays fast/robust under full-suite load (no bulk-buy loop).
    const card = shop.section.locator('[data-item-code="potion_coins"]');
    await expect(card).toBeVisible({ timeout: 15_000 });
    // Bilingual labels (FR default since GAP-010): "Acheter"/"Buy", "Activer"/"Activate".
    await card.getByRole("button", { name: /^(Acheter|Buy)/i }).click();

    // Once owned, the potion becomes armable → "Activer" appears in its card.
    await card.getByRole("button", { name: /^(Activer|Activate)/i }).click({ timeout: 15_000 });
    await expect(shop.activeBadges.first()).toBeVisible({ timeout: 15_000 });
  });
});
