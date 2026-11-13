import { test, expect } from "@playwright/test";

/**
 * Étude 40 lot 3 (R-14) — le manifeste servi : l'icône d'écran d'accueil ouvre `/?src=pwa`, la
 * source d'entrée que la mesure du retour (lot 0) sait lire. Sans base : tier `public`.
 */
test("le manifeste rend start_url « /?src=pwa », un id stable et le scope inchangé", async ({
  request,
}) => {
  const res = await request.get("/manifest.webmanifest");
  expect(res.ok()).toBe(true);
  const manifest = (await res.json()) as Record<string, unknown>;
  expect(manifest.start_url).toBe("/?src=pwa");
  expect(manifest.id).toBe("/");
  expect(manifest.scope).toBe("/");
  expect(manifest.display).toBe("standalone");
});

test("la page d'accueil déclare ce manifeste", async ({ page }) => {
  await page.goto("/");
  await expect(page.locator('link[rel="manifest"]')).toHaveAttribute(
    "href",
    "/manifest.webmanifest",
  );
});
