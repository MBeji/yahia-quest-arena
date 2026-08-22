import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/**
 * Mode IA — étude 29 lot 2. Deux parcours, et ce sont les deux que l'étude §5
 * nomme comme critères d'acceptation.
 *
 * 1. LE PARCOURS « MODE ÉTEINT » (R-1). Le projet TEST n'a pas de
 *    `AI_KEY_ENC_KEY` : le coffre est fermé, donc le chemin famille est éteint,
 *    donc la section « Mode IA » des Réglages doit être **absente** — pas grisée,
 *    pas « bientôt ». C'est l'état par défaut de tout le monde, et c'est le seul
 *    état que la CI peut observer sans clé réelle.
 *
 *    Ce test attrape la régression la plus probable de tout le lot : quelqu'un
 *    déplace l'enveloppe `<Section>` de la section vers la page, et un cartouche
 *    « Mode IA » vide apparaît chez chaque famille qui n'a rien branché.
 *
 * 2. `/parametrage` DEPUIS LE SHELL PARENT (§2.1, point 2). Le parent a un shell
 *    « Suivi-only » : pas de nav de jeu, un seul lien vers `/parent-report`. Si
 *    l'entrée Réglages n'était accessible que depuis la nav élève, le
 *    propriétaire de la clé ne pourrait littéralement pas atteindre l'écran où il
 *    la saisit. L'étude en fait un critère d'acceptation, pas un détail.
 */

test.describe("Mode IA — l'état éteint est complet", () => {
  test.use({ storageState: STORAGE_STATE.free });

  test("aucune surface IA dans les Réglages sans coffre configuré", async ({ page }) => {
    await page.goto("/parametrage");
    await page.waitForLoadState("networkidle");

    // La page elle-même est bien là — c'est l'absence qu'on mesure, pas une panne.
    await expect(page.getByTestId("settings-pseudo")).toBeVisible({ timeout: 15_000 });

    // R-1 : rien. Ni le bouton d'attache, ni un formulaire, ni un en-tête vide.
    await expect(page.getByTestId("ai-attach")).toHaveCount(0);
    await expect(page.getByTestId("ai-form")).toHaveCount(0);
    await expect(page.getByTestId("ai-secret")).toHaveCount(0);
  });
});

test.describe("Mode IA — le porteur de clé doit pouvoir atteindre l'écran", () => {
  test.use({ storageState: STORAGE_STATE.parent });

  test("un parent atteint /parametrage depuis son shell Suivi-only", async ({ page }) => {
    await page.goto("/parent-report");
    await page.waitForLoadState("networkidle");

    // L'engrenage est épinglé hors de la nav scrollable, donc présent dans les
    // DEUX coquilles. C'est ce fait que le test garde.
    await page.getByTestId("settings-trigger").click();
    await page.getByTestId("settings-menu").getByRole("link").first().click();

    await expect(page).toHaveURL(/\/parametrage/);
    await expect(page.getByText(/access denied|accès refusé/i)).toHaveCount(0);
  });
});
