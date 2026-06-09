import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The Dungeon is a premium perk reserved to holders of a CONCOURS parcours
// entitlement (family pack included) AND gated behind real prior progress. A
// student WITHOUT an entitlement hits the premium (concours-entitlement) gate; a
// student WITH one but without enough progress hits the progress lock. Neither can
// start a run. The seeded premium student holds the entitlement; the free one doesn't.
test.describe("Dungeon access gate", () => {
  test.describe("student without a concours entitlement", () => {
    test.use({ storageState: STORAGE_STATE.free });

    test("is blocked by the concours-entitlement (premium) gate", async ({ dungeon }) => {
      await dungeon.goto();
      await expect(dungeon.premiumGate).toBeVisible({ timeout: 15_000 });
      await expect(dungeon.enterButton).toHaveCount(0);
    });
  });

  test.describe("entitled student without progress", () => {
    test.use({ storageState: STORAGE_STATE.premium });

    test("passes the premium gate and is blocked by the progress lock", async ({ dungeon }) => {
      await dungeon.goto();
      await expect(dungeon.lockedGate).toBeVisible({ timeout: 15_000 });
      await expect(dungeon.enterButton).toHaveCount(0);
    });
  });
});
