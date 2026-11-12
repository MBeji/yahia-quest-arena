import type { Page } from "@playwright/test";
import { test, expect } from "../fixtures";
import { ResumeCardPage } from "../pages/resume-card.page";

/**
 * Étude 38 lot 5 — LA CONTINUITÉ DU VISITEUR : son appareil se souvient de lui trente jours.
 *
 * Tier PUBLIC : pas de backend, donc pas de chapitre à LIRE ici — la mémoire est posée telle que
 * le lecteur l'écrit, et on prouve tout ce qui suit : la carte sur l'accueil et sur /programme,
 * son lien, « oublier », l'échéance, l'absence de saut de mise en page et d'erreur d'hydratation.
 * Le parcours entier, lecture d'un vrai chapitre comprise, vit dans `public-anon/`.
 */
// Un identifiant au format du catalogue (UUID) : le lecteur refuse d'emblée tout autre format.
const CHAPTER = { id: "0e2e0000-0000-4000-8000-000000000038", title: "Les fractions" };

/** Les erreurs de console qui trahiraient un écart entre le rendu serveur et le client. */
function watchHydration(page: Page): string[] {
  const seen: string[] = [];
  page.on("console", (message) => {
    if (message.type() === "error" && /hydrat|did not match/i.test(message.text())) {
      seen.push(message.text());
    }
  });
  page.on("pageerror", (error) => seen.push(error.message));
  return seen;
}

test.describe("La continuité du visiteur — la carte « Reprendre » (é38 lot 5)", () => {
  test("revenir sur l'accueil : la carte propose le chapitre lu, et son lien y ramène", async ({
    page,
  }) => {
    const resume = new ResumeCardPage(page);
    const hydration = watchHydration(page);
    await resume.seed(CHAPTER);

    await page.goto("/");
    await expect(resume.card).toBeVisible({ timeout: 15_000 });
    await expect(resume.title).toHaveText(CHAPTER.title);
    await expect(resume.link).toHaveAttribute("href", `/chapitre/${CHAPTER.id}`);
    expect(hydration).toEqual([]);

    await resume.link.click();
    await expect(page).toHaveURL(new RegExp(`/chapitre/${CHAPTER.id}$`));
  });

  test("« oublier » : la carte disparaît, l'appareil ne retient plus rien, même après rechargement", async ({
    page,
  }) => {
    const resume = new ResumeCardPage(page);
    await resume.seed(CHAPTER);
    await page.goto("/");
    await expect(resume.card).toBeVisible({ timeout: 15_000 });

    await resume.forget.click();
    await expect(resume.card).toHaveCount(0);
    expect(await resume.remembered()).toBeNull();

    await page.reload();
    await expect(page.locator("h1").first()).toBeVisible();
    await expect(resume.card).toHaveCount(0);
  });

  test("trente jours passés : plus de carte", async ({ page }) => {
    const resume = new ResumeCardPage(page);
    // Le positif apparié : la même mémoire, à 29 jours, montre la carte.
    await resume.seed(CHAPTER, 29);
    await page.goto("/");
    await expect(resume.card).toBeVisible({ timeout: 15_000 });

    await page.evaluate(([key, entry]) => window.localStorage.setItem(key, JSON.stringify(entry)), [
      ResumeCardPage.LAST_CHAPTER_KEY,
      { ...CHAPTER, lang: "fr", at: Date.now() - 31 * 24 * 60 * 60 * 1000 },
    ] as const);
    await page.reload();
    await expect(page.locator("h1").first()).toBeVisible();
    await expect(resume.card).toHaveCount(0);
  });

  test("la carte ne pousse rien : le titre de l'accueil est au même endroit avec et sans elle", async ({
    page,
  }) => {
    const resume = new ResumeCardPage(page);
    const h1 = page.locator("h1").first();

    // L'en-tête change de hauteur quand la session est lue (ses liens de compte arrivent) : on ne
    // mesure qu'une fois cet état atteint, sans quoi on comparerait deux moments, pas deux pages.
    const settled = page.locator('header a[href="/signup"]').first();

    await page.goto("/");
    await expect(settled).toBeVisible({ timeout: 15_000 });
    // Sans mémoire, pas de carte — et la position de référence du titre.
    await expect(resume.card).toHaveCount(0);
    const without = await h1.boundingBox();

    await page.evaluate(([key, entry]) => window.localStorage.setItem(key, JSON.stringify(entry)), [
      ResumeCardPage.LAST_CHAPTER_KEY,
      { ...CHAPTER, lang: "fr", at: Date.now() - 24 * 60 * 60 * 1000 },
    ] as const);
    await page.reload();
    await expect(settled).toBeVisible({ timeout: 15_000 });
    await expect(resume.card).toBeVisible({ timeout: 15_000 });
    const withCard = await h1.boundingBox();

    expect(without).not.toBeNull();
    expect(withCard).not.toBeNull();
    expect(Math.abs((withCard?.y ?? 0) - (without?.y ?? 0))).toBeLessThanOrEqual(1);
  });

  test("un stockage illisible : l'accueil d'avant, sans carte et sans erreur", async ({ page }) => {
    const resume = new ResumeCardPage(page);
    const hydration = watchHydration(page);
    await page.addInitScript(
      (key) => window.localStorage.setItem(key, "{pas du json"),
      ResumeCardPage.LAST_CHAPTER_KEY,
    );
    await page.goto("/");
    await expect(page.locator("h1").first()).toBeVisible();
    await expect(page.getByTestId("placement-door")).toBeVisible();
    await expect(resume.card).toHaveCount(0);
    expect(hydration).toEqual([]);
  });
});
