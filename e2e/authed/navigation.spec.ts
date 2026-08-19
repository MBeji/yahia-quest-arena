import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The authenticated nav shell routes correctly. Driven from the leaderboard page
// (the banner is identical on every authed page, and it's lighter than the 3D
// dashboard). Targeted by href, not link text, so it stays robust to the UI
// locale (the labels are translated; the FR-default switch — GAP-010 — renamed
// them "Aventure"/"Donjon"/"Hall des Héros").
test.use({ storageState: STORAGE_STATE.free });

const NAV = [
  { href: "/parcours", url: /\/parcours/ },
  // « Découvrir » converged onto the public catalogue (chantier L2.A) — the nav now
  // points at /programme (the old /themes hub is a 301 redirect to it).
  { href: "/programme", url: /\/programme/ },
  // Étude 15 lot 5 (D-4): Donjon/Duels/Classement are grouped under the /arene pole,
  // so the primary nav points at /arene (not /dungeon directly).
  { href: "/arene", url: /\/arene/ },
  { href: "/dashboard", url: /\/dashboard/ },
];

test.describe("Primary navigation", () => {
  test.describe.configure({ timeout: 60_000 });

  for (const item of NAV) {
    test(`nav → ${item.url.source}`, async ({ leaderboard, page }) => {
      await leaderboard.goto();
      await page.getByRole("banner").locator(`a[href="${item.href}"]`).first().click();
      await expect(page).toHaveURL(item.url);
    });
  }

  test("the brand returns to the dashboard", async ({ leaderboard, page }) => {
    await leaderboard.goto();
    await page
      .getByRole("banner")
      .getByRole("link", { name: /na9ra\s*nal3ab/i })
      .click();
    await expect(page).toHaveURL(/\/dashboard/);
  });

  test("the Arène pole links to the three competitive screens", async ({ page }) => {
    await page.goto("/arene");
    for (const href of ["/dungeon", "/duel", "/leaderboard"]) {
      await expect(page.locator(`main a[href="${href}"]`).first()).toBeVisible({ timeout: 15_000 });
    }
  });

  // Le menu est le SEUL chemin vers la page de paramétrage : il n'y a pas
  // d'entrée « Paramétrage » dans la barre du bas (arbitrage : les onglets
  // restent réservés aux destinations fréquentes).
  test("l'engrenage mène à la page de paramétrage", async ({ leaderboard, page, nav }) => {
    await leaderboard.goto();
    await nav.openSettings();
    await nav.settingsMenu.getByRole("link").click();
    await expect(page).toHaveURL(/parametrage/);
  });

  test("le pôle Paramétrage porte ses six sections", async ({ page }) => {
    await page.goto("/parametrage");
    // Les réglages rapides du menu s'y retrouvent en entier…
    await expect(page.getByRole("switch")).toHaveCount(2, { timeout: 15_000 });
    await expect(page.getByRole("menuitemradio")).toHaveCount(5);
    // …plus ce que le menu ne porte pas : compte, parcours, mentions.
    await expect(page.getByTestId("settings-sign-out")).toBeVisible();
    for (const href of ["/boutique", "/programme", "/conditions", "/confidentialite"]) {
      await expect(page.locator(`main a[href="${href}"]`).first()).toBeVisible();
    }
    // …et la sixième, arrivée avec la suppression de compte (GAP-024).
    await expect(page.getByTestId("settings-delete-account")).toBeVisible();
  });

  // ⚠️ CE TEST NE CONFIRME JAMAIS LA SUPPRESSION, et ne le doit jamais : il tourne
  // sous le compte partagé `STORAGE_STATE.free`, dont l'état d'authentification est
  // réutilisé par toute la suite. Aller au bout effacerait la fixture — la suite
  // entière deviendrait rouge, et rien ne dirait pourquoi. Ce qui est vérifié ici
  // est exactement la garde : que le bouton REFUSE de s'armer.
  test("la suppression de compte ne s'arme que sur la bonne adresse", async ({ page }) => {
    await page.goto("/parametrage");
    await page.getByTestId("settings-delete-account").click();

    const confirm = page.getByTestId("settings-delete-confirm");
    await expect(confirm).toBeVisible({ timeout: 15_000 });
    // Boîte ouverte, champ vide : le geste destructeur est hors de portée.
    await expect(confirm).toBeDisabled();

    // Une adresse plausible mais autre ne l'arme pas davantage.
    await page.getByTestId("settings-delete-confirm-email").fill("quelquun-dautre@example.tn");
    await expect(confirm).toBeDisabled();

    await page.getByRole("button", { name: /annuler|cancel|إلغاء/i }).click();
    await expect(confirm).toBeHidden();
  });
});

// La nav de l'admin passait de dix liens à cinq : les six consoles (plus
// « Économie », que RIEN ne liait) vivent dans le pôle /console.
test.describe("Console — le pôle d'administration", () => {
  test.use({ storageState: STORAGE_STATE.admin });
  test.describe.configure({ timeout: 60_000 });

  test("le pôle liste les sept consoles, dont l'orpheline « Économie »", async ({ page }) => {
    await page.goto("/console");
    for (const href of [
      "/parent-report",
      "/admin/subscriptions",
      "/admin/beta-requests",
      "/admin/content-reports",
      "/admin/bug-reports",
      "/admin/parcours-interest",
      "/admin/economie",
    ]) {
      await expect(page.locator(`main a[href="${href}"]`).first()).toBeVisible({ timeout: 15_000 });
    }
  });

  test("la nav ne porte plus les six liens admin, seulement l'entrée Console", async ({ page }) => {
    await page.goto("/leaderboard");
    const banner = page.getByRole("banner");
    await expect(banner.locator('a[href="/console"]')).toBeVisible();
    for (const href of ["/admin/subscriptions", "/admin/beta-requests", "/admin/bug-reports"]) {
      await expect(banner.locator(`a[href="${href}"]`)).toHaveCount(0);
    }
  });
});
