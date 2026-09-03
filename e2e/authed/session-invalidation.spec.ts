import type { Locator, Page } from "@playwright/test";
import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/**
 * UNE SESSION QUI MEURT EN COURS DE ROUTE N'EST JAMAIS UN CUL-DE-SAC.
 *
 * POURQUOI CE FICHIER EXISTE
 * ---------------------------------------------------------------------------
 * Deux pannes en trois semaines, la même forme : l'élève reste devant un écran
 * dont rien ne le sort. « Failed to load dashboard » (#931, deux fois), puis le
 * bouton « Valider » grisé sans fin (#914/#915). #933 a fermé la porte CÔTÉ
 * TYPES — `Record<AuthFailure, AuthRefusal>` fait échouer `tsc` sur un refus
 * dont la conduite client n'est pas déclarée — et l'unitaire couvre la table.
 *
 * Mais rien ne vérifiait la propriété DANS UN VRAI NAVIGATEUR : la table peut
 * être exhaustive et juste, et l'application quand même se figer, parce que la
 * reprise passe par le stockage local, le rafraîchissement de jeton et le
 * routeur — trois étages qu'aucun test unitaire ne traverse. C'est le second
 * lot de #938.
 *
 * CE QUE LE TEST AFFIRME, ET CE QU'IL N'AFFIRME PAS
 * ---------------------------------------------------------------------------
 * Il n'exige PAS une issue précise : selon l'état du jeton, se rattraper avec
 * un jeton neuf est aussi correct que renvoyer vers la connexion. Il exige
 * qu'il y ait une issue — donc il interdit la TROISIÈME, la seule qui soit un
 * défaut : rester sur la frontière d'erreur racine.
 *
 * C'est pour ça que l'assertion négative porte sur `root-error-boundary` et non
 * sur un message : `errorTitle` existe en fr/en/ar, et un test qui épingle une
 * langue ne mesure plus rien le jour où la suite tourne dans une autre.
 */

test.use({ storageState: STORAGE_STATE.free });

/** Les clés de session de supabase-js dans `localStorage` (`sb-<ref>-auth-token`, parfois découpée). */
async function sessionKeys(page: Page): Promise<string[]> {
  return page.evaluate(() =>
    Object.keys(localStorage).filter((k) => k.startsWith("sb-") && k.includes("auth-token")),
  );
}

/** Casse les jetons SANS toucher à la forme : le client croit avoir une session, le serveur la refuse. */
async function corruptSession(page: Page): Promise<number> {
  return page.evaluate(() => {
    const keys = Object.keys(localStorage).filter(
      (k) => k.startsWith("sb-") && k.includes("auth-token"),
    );
    for (const k of keys) {
      const raw = localStorage.getItem(k);
      if (!raw) continue;
      try {
        const parsed = JSON.parse(raw) as Record<string, unknown>;
        parsed.access_token = "invalid.invalid.invalid";
        parsed.refresh_token = "invalid-refresh-token";
        localStorage.setItem(k, JSON.stringify(parsed));
      } catch {
        // Session découpée en morceaux (`…auth-token.0`) : le JSON n'est pas
        // parsable morceau par morceau. La casser franchement fait le même
        // office — un jeton illisible est un jeton refusé.
        localStorage.setItem(k, "not-a-session");
      }
    }
    return keys.length;
  });
}

/** Supprime la session : le client n'a plus rien à envoyer (`NO_HEADER`). */
async function dropSession(page: Page): Promise<number> {
  return page.evaluate(() => {
    const keys = Object.keys(localStorage).filter(
      (k) => k.startsWith("sb-") && k.includes("auth-token"),
    );
    for (const k of keys) localStorage.removeItem(k);
    return keys.length;
  });
}

/**
 * L'issue attendue : le tableau de bord se peuple, OU on est renvoyé vers la
 * connexion. Jamais la frontière d'erreur racine.
 */
async function expectAnExit(
  page: Page,
  dashboard: { statLevel: Locator; subjectCards: Locator },
): Promise<void> {
  const errorBoundary = page.getByTestId("root-error-boundary");
  await expect(async () => {
    const onAuth = /\/auth/.test(page.url());
    const loaded = await dashboard.statLevel
      .or(dashboard.subjectCards.first())
      .first()
      .isVisible()
      .catch(() => false);
    expect(
      onAuth || loaded,
      `ni tableau de bord peuplé ni retour vers /auth — url: ${page.url()}`,
    ).toBe(true);
  }).toPass({ timeout: 30_000 });
  // L'assertion qui compte : le cul-de-sac n'est pas là. Vérifiée APRÈS la
  // sortie, sinon un écran d'erreur transitoire pendant la reprise la ferait
  // tomber pour rien.
  await expect(errorBoundary).toBeHidden();
}

test.describe("Session invalidée en cours de route (#938)", () => {
  test.describe.configure({ timeout: 90_000 });

  test("des jetons cassés ne laissent pas l'élève sur l'écran d'erreur", async ({
    page,
    dashboard,
  }) => {
    await dashboard.goto();
    // Contrôle positif : sans lui, un `localStorage` vide (session jamais
    // écrite) rendrait le test vert sans avoir rien invalidé.
    expect(await sessionKeys(page), "aucune session en localStorage").not.toHaveLength(0);

    expect(await corruptSession(page)).toBeGreaterThan(0);
    await page.goto("/dashboard");
    await expectAnExit(page, dashboard);
  });

  test("une session supprimée renvoie vers la connexion, sans écran d'erreur", async ({
    page,
    dashboard,
  }) => {
    await dashboard.goto();
    expect(await dropSession(page)).toBeGreaterThan(0);
    await page.goto("/dashboard");
    // Ici l'issue est déterminée : sans session, le garde de `_authenticated`
    // renvoie vers `/auth` — c'est ce que le tier public vérifie déjà pour un
    // visiteur déconnecté (`e2e/public/auth-redirects.spec.ts`). Ce qui est
    // neuf, c'est que la session meurt APRÈS le chargement de l'application.
    await expect(page).toHaveURL(/\/auth/, { timeout: 30_000 });
    await expect(page.getByTestId("root-error-boundary")).toBeHidden();
  });
});
