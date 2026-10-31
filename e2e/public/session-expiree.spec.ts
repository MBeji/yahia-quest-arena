import type { Page } from "@playwright/test";
import { test, expect } from "../fixtures";

/**
 * Étude 38 lot 3 (R-7) — /auth DIT QUE LA SESSION A EXPIRÉ.
 *
 * Tier PUBLIC : pas de backend. On pose dans la mémoire de l'appareil l'état que laisse
 * `useExitOnRefusedSession` — la page quittée, avec la raison `expired` — et on regarde l'écran de
 * connexion dans un vrai navigateur, hydratation comprise. La moitié qui produit cet état (un refus de
 * session qui atteint l'écran) et celle qui ramène après la reconnexion exigent un compte : elles
 * vivent dans `e2e/authed/session-invalidation.spec.ts` et dans les tests unitaires de la page.
 */
const KEY = "na9ra.returnTo.v1";

async function keepReturn(page: Page, path: string, reason?: "expired"): Promise<void> {
  await page.evaluate(
    ([key, kept, why]) =>
      window.localStorage.setItem(
        key,
        JSON.stringify({ path: kept, at: Date.now(), ...(why ? { reason: why } : {}) }),
      ),
    [KEY, path, reason ?? ""] as const,
  );
}

test.describe("/auth après une session qui a expiré (é38 lot 3)", () => {
  test("le dit en tête du formulaire de connexion", async ({ page }) => {
    await page.goto("/auth?mode=login");
    await keepReturn(page, "/quest/ex-1", "expired");
    await page.goto("/auth?mode=login");

    await expect(page.getByTestId("auth-session-expired")).toBeVisible({ timeout: 30_000 });
  });

  test("ne le dit pas pour un retour ordinaire", async ({ page }) => {
    await page.goto("/auth?mode=login");
    await keepReturn(page, "/chapitre/c1");
    await page.goto("/auth?mode=login");

    await expect(page.locator('input[type="email"]')).toBeVisible({ timeout: 30_000 });
    await expect(page.getByTestId("auth-session-expired")).toHaveCount(0);
  });

  test("ne le dit pas en inscription", async ({ page }) => {
    await page.goto("/auth?mode=signup");
    await keepReturn(page, "/quest/ex-1", "expired");
    await page.goto("/auth?mode=signup");

    await expect(page.locator('input[type="email"]')).toBeVisible({ timeout: 30_000 });
    await expect(page.getByTestId("auth-session-expired")).toHaveCount(0);
  });
});
