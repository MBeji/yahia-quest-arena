import { test, expect } from "../fixtures";
import { expectNoSeriousA11yViolations } from "../helpers/a11y";

// Accessibility smoke on the public (no-backend) surfaces. Runs on desktop +
// mobile (both public projects). A serious/critical WCAG 2 A/AA violation here
// is a real finding for the bug-bounty campaign.
test.describe("Accessibility — public pages", () => {
  test("landing page has no serious/critical a11y violations", async ({ page }) => {
    await page.goto("/");
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });

  test("login page has no serious/critical a11y violations", async ({ page }) => {
    await page.goto("/auth?mode=login");
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });

  test("signup page has no serious/critical a11y violations", async ({ page }) => {
    await page.goto("/auth?mode=signup");
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });
});

// Audit d'affichage du 2026-10-31 (issue #1228) — ce que l'audit a trouvé hors des trois
// pages ci-dessus, épinglé là où un navigateur seul peut le voir.
test.describe("Accessibilité — reliquat de l'audit d'affichage", () => {
  test("le panneau des réglages ouvert tient son contrat ARIA", async ({ page, nav }) => {
    await page.goto("/");
    await page.waitForLoadState("networkidle");
    await nav.openSettings();
    // `role="menu"` y contenait des interrupteurs et des `menuitemradio` mal rangés :
    // axe `aria-required-children`, critique.
    await expect(nav.settingsMenu.getByRole("radiogroup")).toHaveCount(2);
    await expectNoSeriousA11yViolations(page);
  });

  test("la page 404 a un contenu principal, un titre et deux issues", async ({ page }) => {
    await page.goto("/cette-page-n-existe-pas");
    await page.waitForLoadState("networkidle");
    const main = page.getByRole("main");
    await expect(main).toHaveCount(1);
    await expect(main.getByRole("heading", { level: 1 })).toBeVisible();
    await expect(main.locator('a[href="/"]')).toBeVisible();
    await expect(main.locator('a[href="/programme"]')).toBeVisible();
    await expectNoSeriousA11yViolations(page);
  });

  // Le doigt, pas la souris : 44 px de côté pour toute cible de la coquille publique.
  // Les liens de navigation en faisaient 36, ceux du pied de page 16.
  for (const path of ["/", "/programme", "/cette-page-n-existe-pas"]) {
    test(`téléphone — aucune cible tactile sous 44 px sur ${path}`, async ({ page, hasTouch }) => {
      // La garde de 44 px se pose en `pointer: coarse` : elle n'existe que sur un
      // appareil tactile, donc seul le projet téléphone peut la mesurer.
      test.skip(!hasTouch, "cibles tactiles : projet téléphone seulement");
      await page.setViewportSize({ width: 390, height: 839 });
      await page.goto(path);
      await page.waitForLoadState("networkidle");
      const small = await page.evaluate(() =>
        Array.from(
          document.querySelectorAll<HTMLElement>(
            "header a[href], header button, footer a[href], footer button, main a[href], main button",
          ),
        )
          .map((el) => ({ el, rect: el.getBoundingClientRect() }))
          .filter(({ el, rect }) => {
            if (rect.width === 0 || rect.height === 0) return false;
            // Un lien DANS une phrase suit la ligne de texte (exception « inline » de
            // WCAG 2.5.8) ; tout le reste est une cible à part entière.
            if (getComputedStyle(el).display === "inline") return false;
            return rect.height < 43.5 || rect.width < 43.5;
          })
          .map(
            ({ el, rect }) =>
              `${el.tagName.toLowerCase()} « ${(el.getAttribute("aria-label") ?? el.textContent ?? "").trim().slice(0, 40)} » ${Math.round(rect.width)}×${Math.round(rect.height)}`,
          ),
      );
      expect(small, `cibles sous 44 px :\n${small.join("\n")}`).toEqual([]);
    });
  }

  test("téléphone — l'en-tête public ne grossit pas pour autant", async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 839 });
    await page.goto("/");
    await page.waitForLoadState("networkidle");
    const height = await page
      .locator("[data-public-header]")
      .evaluate((el) => el.getBoundingClientRect().height);
    // 168 px avant ce lot (rangée de liens à 36 px, deux lignes) ; 150 px après, avec
    // toutes les cibles à 44. Le plafond est ce qu'il mesurait AVANT : agrandir une
    // cible ne doit jamais se payer en hauteur d'écran.
    expect(height).toBeLessThanOrEqual(168);
  });
});
