import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The Dungeon is a PREMIUM feature AND gated behind real prior progress. A free
// student hits the subscription paywall; a subscriber without enough progress
// hits the progress lock. Neither can start a run.
test.describe("Dungeon access gate", () => {
  test.describe("free student", () => {
    test.use({ storageState: STORAGE_STATE.free });

    test("is blocked by the subscription paywall", async ({ dungeon }) => {
      await dungeon.goto();
      await expect(dungeon.premiumGate).toBeVisible({ timeout: 15_000 });
      await expect(dungeon.enterButton).toHaveCount(0);
    });
  });

  test.describe("subscriber without progress", () => {
    test.use({ storageState: STORAGE_STATE.premium });

    test("is blocked by the progress lock", async ({ dungeon }) => {
      await dungeon.goto();
      await expect(dungeon.lockedGate).toBeVisible({ timeout: 15_000 });
      await expect(dungeon.enterButton).toHaveCount(0);
    });
  });
});
