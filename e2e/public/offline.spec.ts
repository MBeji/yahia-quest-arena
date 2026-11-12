import { test, expect } from "../fixtures";

/**
 * Étude 38 lot 4 (R-9) — LE RÉSEAU SE VOIT.
 *
 * Avant, quand le réseau tombait, rien ne le disait : les écrans gardaient leur squelette et
 * l'élève concluait que le site était cassé. Un bandeau le dit maintenant dans les deux
 * coquilles, et s'efface seul au retour — sans rechargement.
 *
 * CE QUE CE TIER PROUVE, ET CE QU'IL LAISSE À UN AUTRE. Ici (serveur de dev, sans backend) :
 * le bandeau de la coquille publique, dans les deux sens. L'état « en attente du réseau » d'une
 * page et la page de repli du service worker se prouvent dans `npm run smoke:shell`, sur le
 * bundle de production : le serveur de dev redemande ses modules à chaque navigation (hors
 * ligne, le clic finit en erreur du navigateur) et n'enregistre pas le service worker.
 *
 * Assertions par `data-testid`, jamais par un libellé : la langue du test n'est pas celle de
 * l'application.
 */
test.describe("Hors connexion — le bandeau de la coquille publique (é38 lot 4)", () => {
  test("le réseau tombe : le bandeau le dit ; il revient : le bandeau s'efface, sans rechargement", async ({
    page,
    context,
  }) => {
    await page.goto("/");
    // La page est hydratée quand la lecture de session a rendu l'invitation de l'en-tête.
    await expect(page.getByTestId("header-signup")).toBeVisible({ timeout: 30_000 });

    const banner = page.getByTestId("network-banner");
    // En ligne : la région d'annonce existe déjà (un lecteur d'écran n'annonce un changement
    // que dans une région qu'il connaissait), et elle est vide.
    await expect(banner).toHaveAttribute("role", "status");
    await expect(banner).toBeEmpty();

    // Un rechargement effacerait ce marqueur.
    await page.evaluate(() => {
      (window as unknown as { __sameDocument: boolean }).__sameDocument = true;
    });

    await context.setOffline(true);
    await expect(banner).not.toBeEmpty();
    await expect(banner).toBeVisible();
    // Le bandeau n'a pas pris le focus : rien n'interrompt l'élève qui tape.
    expect(await banner.evaluate((node) => node.contains(document.activeElement))).toBe(false);

    await context.setOffline(false);
    await expect(banner).toBeEmpty();
    expect(
      await page.evaluate(
        () => (window as unknown as { __sameDocument?: boolean }).__sameDocument === true,
      ),
    ).toBe(true);
  });

  test("le bandeau reste sous l'en-tête quand la page défile, sans élargir l'écran", async ({
    page,
    context,
  }) => {
    await page.goto("/");
    await expect(page.getByTestId("header-signup")).toBeVisible({ timeout: 30_000 });
    await context.setOffline(true);

    const banner = page.getByTestId("network-banner");
    await expect(banner).not.toBeEmpty();
    await page.evaluate(() => window.scrollTo(0, 800));

    await expect(banner).toBeInViewport();
    const header = await page.locator("[data-public-header]").boundingBox();
    const box = await banner.boundingBox();
    expect(box).not.toBeNull();
    expect(header).not.toBeNull();
    expect(Math.abs(box!.y - (header!.y + header!.height))).toBeLessThanOrEqual(1);
    expect(
      await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth),
    ).toBe(true);
  });
});
