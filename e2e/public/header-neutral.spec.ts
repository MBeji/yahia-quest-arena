import { test, expect } from "../fixtures";

/**
 * Étude 38 lot 1 (R-6) — L'EN-TÊTE PUBLIC NE DEVINE PAS L'ÉTAT DU COMPTE.
 *
 * Le serveur rend la page sans savoir qui la lit. Avant, il écrivait « Connexion · Créer mon
 * compte » pour tout le monde — faux pour un élève déjà connecté, qui le lisait une demi-seconde
 * à chaque chargement. Maintenant le HTML rendu ne porte NI l'une NI l'autre invitation, ni le
 * HUD : seuls les réglages et l'aide, puis la lecture de la session complète le bloc. Même règle
 * pour les invitations de la vitrine (R-6 vaut pour « toute invitation »).
 *
 * Tier PUBLIC (sans backend) : on prouve la moitié visiteur. Les assertions passent par
 * `data-testid`, jamais par un libellé — la langue de l'application n'est pas celle du test.
 */
test.describe("En-tête public — neutre avant la lecture de la session (é38 lot 1)", () => {
  test.describe("HTML rendu côté serveur, sans JavaScript", () => {
    test.use({ javaScriptEnabled: false });

    test("ni « Connexion » ni « Créer mon compte » : le serveur ne sait pas qui lit", async ({
      page,
    }) => {
      await page.goto("/");

      // Le bloc neutre est bien là…
      await expect(page.getByTestId("settings-trigger")).toBeVisible();
      // …et il ne dit rien du compte.
      await expect(page.getByTestId("header-signup")).toHaveCount(0);
      await expect(page.getByTestId("header-login")).toHaveCount(0);
      await expect(page.getByTestId("header-login-phone")).toHaveCount(0);
    });

    test("la vitrine non plus : le bloc « jeu » n'offre aucun lien tant que la session n'est pas lue", async ({
      page,
    }) => {
      await page.goto("/");

      await expect(page.getByTestId("game-block")).toBeAttached();
      await expect(page.getByTestId("game-block").locator("a")).toHaveCount(0);
    });
  });

  test("la page hydratée, le visiteur sans session voit son invitation", async ({ page }) => {
    await page.goto("/");

    // La lecture de session d'un visiteur est locale : l'invitation arrive juste après l'hydratation.
    await expect(page.getByTestId("header-signup")).toBeVisible({ timeout: 30_000 });
    await expect(page.getByTestId("game-block").getByRole("link")).toBeVisible();
  });
});
