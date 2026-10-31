import { test, expect } from "../fixtures";

/**
 * AVEC « RÉDUIRE LES ANIMATIONS », LE FORMULAIRE DE CONNEXION EST VISIBLE.
 *
 * Trouvé par l'audit d'affichage du 2026-10-31 : sous cette préférence — réglage d'accessibilité,
 * mais aussi économiseur de batterie et mode « supprimer les animations » d'Android —, la carte de
 * /auth et de /auth/reset restait à `opacity: 0` POUR TOUJOURS. Le serveur, qui ne connaît pas la
 * préférence, rend l'état de départ de l'animation (`style="opacity:0;transform:scale(.95)"`) ; le
 * client ne le rejouait pas. Personne, dans ce cas, ne pouvait se connecter ni s'inscrire.
 *
 * `toBeVisible` ne verrait rien : Playwright tient un élément à `opacity: 0` pour visible. C'est
 * donc l'opacité CALCULÉE qu'on lit, et une fois la page hydratée (le HTML serveur est à 0 pour tout
 * le monde, y compris sans la préférence). Tier PUBLIC : pas de backend.
 */
test.use({ reducedMotion: "reduce" });

for (const path of ["/auth?mode=login", "/auth?mode=signup", "/auth?mode=forgot", "/auth/reset"]) {
  test(`${path} : la carte est visible une fois la page hydratée`, async ({ page }) => {
    await page.goto(path);

    await expect(page.getByTestId("auth-card")).toHaveCSS("opacity", "1", { timeout: 30_000 });
  });
}

test("sans la préférence, la même carte est visible aussi (le mouvement normal n'est pas touché)", async ({
  browser,
}) => {
  const context = await browser.newContext({ reducedMotion: "no-preference" });
  const page = await context.newPage();
  await page.goto("/auth?mode=login");

  await expect(page.getByTestId("auth-card")).toHaveCSS("opacity", "1", { timeout: 30_000 });
  await context.close();
});
