import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

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

// LA CONTRE-ÉPREUVE, sans laquelle les deux `toHaveCount(0)` ci-dessus ne mesurent
// rien. Ils ont d'ailleurs passé À VIDE : `enterButton` visait le nom accessible
// ANGLAIS d'un CTA rendu en français par défaut (GAP-010), donc un sélecteur qui ne
// pouvait désigner personne — la classe de défaut de l'issue #733, exactement celle
// que #796 a trouvée sur `dashboard.adminNavLink`. Un négatif n'est opposable que
// s'il est appairé à un positif sur LE MÊME sélecteur ; c'est ce test-ci.
//
// Le cobaye est le compte ADMIN, et pas un des deux élèves : ceux-là, les tests
// ci-dessus les exigent justement VERROUILLÉS, et leur ouvrir la porte reviendrait à
// éteindre ce qu'on veut garder. Aucune autre spec n'observe la progression de
// l'admin, la mise en scène ne croise donc personne — et `reset-gameplay.mjs` la rend
// au run suivant (`attempts` et `dungeon_runs` sont dans GAMEPLAY_TABLES).
test.describe("Dungeon CTA — la contre-épreuve du verrou", () => {
  test.use({ storageState: STORAGE_STATE.admin });

  test("un compte qui a franchi le prérequis voit le CTA", async ({ dungeon, adminDb }) => {
    const userId = await adminDb.userIdByEmail(TEST_USERS.admin.email);
    const unlocked = await adminDb.unlockDungeonPrereq(userId);
    test.skip(!unlocked, "Catalogue de test trop mince : pas 2 matières × 3 chapitres à jouer.");

    await dungeon.goto();
    // Le CTA est là — donc le sélecteur DÉSIGNE quelque chose, et les deux
    // `toHaveCount(0)` d'au-dessus mesurent enfin une absence, pas un vide.
    await expect(dungeon.enterButton).toBeVisible({ timeout: 15_000 });
    // …et le verrou, lui, a bien disparu. `lockedGate` est le miroir du même
    // raisonnement : les deux tests d'au-dessus le prouvent matchable, celui-ci
    // prouve qu'il sait aussi ne pas matcher.
    await expect(dungeon.lockedGate).toHaveCount(0);
  });
});
