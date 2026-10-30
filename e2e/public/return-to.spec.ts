import type { Page } from "@playwright/test";
import { test, expect } from "../fixtures";

/**
 * Étude 38 lot 1 — LE RETOUR AU POINT DE DÉPART, côté visiteur sans compte.
 *
 * Tier PUBLIC : pas de backend. Ce qu'on peut prouver ici, c'est la moitié qui précède le compte —
 * la page d'où l'on part est RETENUE dans la mémoire de l'appareil avant d'arriver sur /auth. L'autre
 * moitié (se connecter, puis revenir) exige un compte et vit dans les tests unitaires de la page
 * d'authentification, où la session est simulée.
 */
const KEY = "na9ra.returnTo.v1";

/** Le retour gardé, tel que le code l'a écrit — `null` s'il n'y en a pas. */
async function remembered(page: Page): Promise<string | null> {
  return page.evaluate((key) => {
    const raw = window.localStorage.getItem(key);
    return raw ? (JSON.parse(raw) as { path: string }).path : null;
  }, KEY);
}

/**
 * Attend que React ait « hydraté » l'élément. Avant, c'est une ancre inerte : le clic part en navigation
 * complète sans passer par ses gestionnaires — et un test qui clique trop tôt « passe » pour la mauvaise
 * raison (rien n'est retenu, et c'est précisément ce qu'on attendait sur l'accueil). React pose une
 * propriété `__reactProps…` sur chaque nœud qu'il a pris en charge : c'est la sonde la moins fragile.
 */
async function whenHydrated(page: Page, selector: string): Promise<void> {
  await page.waitForFunction(
    (sel) => {
      const el = document.querySelector(sel);
      return !!el && Object.keys(el).some((key) => key.startsWith("__reactProps"));
    },
    selector,
    { timeout: 30_000 },
  );
}

test.describe("Le retour au point de départ — visiteur sans compte (é38 lot 1)", () => {
  test("un lien vers un écran de compte renvoie à /auth ET retient la page voulue", async ({
    page,
  }) => {
    await page.goto("/quest/some-exercise?variant=recall");

    await expect(page).toHaveURL(/\/auth/, { timeout: 15_000 });
    expect(await remembered(page)).toBe("/quest/some-exercise?variant=recall");
  });

  test("« Créer mon compte » de l'en-tête retient la page de contenu où l'on était", async ({
    page,
  }) => {
    await page.goto("/programme");
    await whenHydrated(page, 'header a[href="/signup"]');
    await page.locator('header a[href="/signup"]').click();

    await expect(page).toHaveURL(/\/auth/, { timeout: 15_000 });
    expect(await remembered(page)).toBe("/programme");
  });

  test("depuis l'accueil, rien n'est retenu : le Hall vaut mieux que la vitrine", async ({
    page,
  }) => {
    await page.goto("/");
    await whenHydrated(page, 'header a[href="/signup"]');
    await page.locator('header a[href="/signup"]').click();

    await expect(page).toHaveURL(/\/auth/, { timeout: 15_000 });
    expect(await remembered(page)).toBeNull();
  });

  test("un lien d'invitation partagé écrit le retour ; un retour hostile, non", async ({
    page,
  }) => {
    await page.goto("/auth?mode=signup&returnTo=%2Fmatiere%2Fm1");
    await expect.poll(() => remembered(page)).toBe("/matiere/m1");

    await page.evaluate((key) => window.localStorage.removeItem(key), KEY);
    await page.goto("/auth?mode=signup&returnTo=%2F%2Fevil.tn");
    await expect(page.locator("#auth-email, input[type=email]").first()).toBeVisible();
    expect(await remembered(page)).toBeNull();
  });
});
