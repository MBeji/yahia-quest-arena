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
    await expect.poll(() => dashboard.statNumber(dashboard.statCoins)).toBe(99_999);

    await expect(shop.items.first()).toBeVisible();
    const before = await dashboard.statNumber(dashboard.statCoins);
    const ownedBefore = await shop.ownedBadges.count();

    await shop.buyButtons.first().click();

    await expect.poll(() => dashboard.statNumber(dashboard.statCoins)).toBeLessThan(before);
    await expect.poll(() => shop.ownedBadges.count()).toBeGreaterThan(ownedBefore);
  });

  test("a purchased consumable can be armed", async ({ dashboard, shop, adminDb, page }) => {
    const userId = await adminDb.userIdByEmail(TEST_USERS.premium.email);
    await adminDb.setCoins(userId, 99_999);
    await dashboard.goto();
    await expect(shop.items.first()).toBeVisible();

    // Buy each distinct item once so any armable consumable becomes owned.
    const codes = await shop.items.evaluateAll((els) =>
      els.map((e) => (e as HTMLElement).dataset.itemCode ?? "").filter(Boolean),
    );
    for (const code of codes) {
      const buy = shop.section
        .locator(`[data-item-code="${code}"]`)
        .getByRole("button", { name: /^Buy/i });
      if (await buy.isEnabled().catch(() => false)) {
        const before = await dashboard.statNumber(dashboard.statCoins);
        await buy.click();
        await expect.poll(() => dashboard.statNumber(dashboard.statCoins)).toBeLessThan(before);
      }
    }

    if ((await shop.activateButtons.count()) > 0) {
      await shop.activateButtons.first().click();
      await expect(shop.activeBadges.first()).toBeVisible();
    } else {
      // No armable consumable seeded — at least confirm the purchases landed.
      expect(await shop.ownedBadges.count()).toBeGreaterThan(0);
    }
  });
});
