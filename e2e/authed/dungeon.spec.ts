import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Phase gratuite (étude 15, lot 2): the Dungeon is no longer a premium perk —
// get_dungeon_access lost its SUBSCRIPTION reason. Its ENGAGEMENT gates are
// intact: a fresh student (no attempts) is blocked by the progress lock
// (2 subjects / 3 chapters), whatever their (dormant) entitlement state. Both
// seeded students therefore land on the same progress lock, never a paywall.
test.describe("Dungeon access gate (phase gratuite)", () => {
  test.describe("student without a (dormant) entitlement", () => {
    test.use({ storageState: STORAGE_STATE.free });

    test("passes the open premium door and is blocked by the progress lock", async ({
      dungeon,
    }) => {
      await dungeon.goto();
      await expect(dungeon.lockedGate).toBeVisible({ timeout: 15_000 });
      await expect(dungeon.enterButton).toHaveCount(0);
    });
  });

  test.describe("student with a (dormant) entitlement", () => {
    test.use({ storageState: STORAGE_STATE.premium });

    test("is blocked by the same progress lock", async ({ dungeon }) => {
      await dungeon.goto();
      await expect(dungeon.lockedGate).toBeVisible({ timeout: 15_000 });
      await expect(dungeon.enterButton).toHaveCount(0);
    });
  });
});
