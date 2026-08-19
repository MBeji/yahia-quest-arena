import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Logging out clears the session and the auth guard bounces back to /auth. Driven
// from the lighter leaderboard page (same nav banner) to avoid the dashboard's 3D
// radar WebGL stalls.
//
// La déconnexion n'est plus un bouton du header : elle vit dans le menu de
// l'engrenage (et dans la page /parametrage). Les deux chemins sont couverts ici —
// c'est le geste par lequel un utilisateur quitte l'application, il ne doit pas
// dépendre d'une seule surface.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Logout", () => {
  test.describe.configure({ timeout: 60_000 });

  test("signing out from the settings menu returns to the auth screen", async ({
    leaderboard,
    page,
    nav,
  }) => {
    await leaderboard.goto();
    // Retry to beat the hydration window (the sign-out handler must be attached).
    await expect(async () => {
      await nav.openSettings();
      // FR default (GAP-010) labels it "Déconnexion"; EN "Sign out".
      await nav.settingsMenu.getByRole("button", { name: /sign out|déconnexion/i }).click();
      await expect(page).toHaveURL(/\/auth/, { timeout: 3000 });
    }).toPass({ timeout: 30_000 });
  });

  test("signing out from the settings page returns to the auth screen", async ({ page }) => {
    await page.goto("/parametrage");
    const signOut = page.getByTestId("settings-sign-out");
    await expect(async () => {
      await signOut.click();
      await expect(page).toHaveURL(/\/auth/, { timeout: 3000 });
    }).toPass({ timeout: 30_000 });
  });
});

// Regression net (hérité) : le rôle admin a la nav la plus longue. Ces liens
// vivent dans une bande scrollable horizontalement à barre masquée ; les actions
// de compte doivent rester épinglées EN DEHORS d'elle, sinon elles sortent par la
// droite et deviennent inatteignables (c'est arrivé). Ce que l'on garde en vue a
// changé de nature : ce n'est plus le bouton de déconnexion mais l'ENGRENAGE, qui
// le contient désormais — perdre l'engrenage, c'est perdre à la fois la
// déconnexion, la langue, le thème et le son d'un coup. On vérifie qu'il est dans
// le viewport, pas seulement présent : `toBeVisible` ne verrait pas un
// débordement, `toBeInViewport` si.
test.describe("Logout — les réglages restent atteignables avec toute la nav admin", () => {
  test.use({ storageState: STORAGE_STATE.admin });
  test.describe.configure({ timeout: 60_000 });

  test("l'engrenage est dans le viewport malgré la largeur de la nav admin", async ({
    leaderboard,
    page,
    nav,
  }) => {
    await leaderboard.goto();
    await expect(nav.settingsTrigger).toBeVisible();
    await expect(nav.settingsTrigger).toBeInViewport();
    // Et il porte bien la déconnexion, sinon le filet ne garderait qu'une coquille.
    await nav.openSettings();
    await expect(
      nav.settingsMenu.getByRole("button", { name: /sign out|déconnexion/i }),
    ).toBeVisible();
    // La nav admin tient maintenant en UNE entrée « Console » au lieu de six.
    await expect(page.getByRole("banner").locator('a[href="/console"]')).toBeVisible();
  });
});
