import { test, expect } from "../fixtures";
import { LessonReaderPage } from "../pages/public-reader.page";
import { ResumeCardPage } from "../pages/resume-card.page";

/**
 * Étude 38 lot 5 — LE PARCOURS ENTIER DU VISITEUR QUI REVIENT, sans compte et sur un vrai chapitre :
 * il lit un cours, revient sur l'accueil, y trouve la carte « Reprendre », la suit ; puis il demande
 * à l'appareil d'oublier. Tier `public-anon` : lire un chapitre exige les lectures anonymes du
 * projet de TEST.
 */
test.describe("Le visiteur qui revient (é38 lot 5)", () => {
  test("lire un chapitre, revenir sur /, voir la carte, la suivre — puis « oublier »", async ({
    page,
    adminDb,
  }) => {
    const chapterId = await adminDb.fixtureLessonChapterId();
    const reader = new LessonReaderPage(page);
    const resume = new ResumeCardPage(page);

    // 1. Il lit le cours — l'appareil le retient, sous son titre.
    await page.goto(`/chapitre/${chapterId}`);
    await expect(reader.content).toBeVisible({ timeout: 15_000 });
    const title = (await reader.heading.innerText()).trim();
    await expect.poll(() => resume.remembered()).toMatchObject({ id: chapterId });

    // 2. Il revient sur l'accueil (un chargement complet, comme le lendemain) : la carte est là.
    await page.goto("/");
    await expect(resume.card).toBeVisible({ timeout: 15_000 });
    await expect(resume.title).toHaveText(title);

    // 3. Il la suit : il retombe sur son cours.
    await resume.link.click();
    await expect(page).toHaveURL(new RegExp(`/chapitre/${chapterId}$`));
    await expect(reader.content).toBeVisible({ timeout: 15_000 });

    // 4. Elle l'attend aussi sur le programme — et « oublier » l'efface partout.
    await page.goto("/programme");
    await expect(resume.card).toBeVisible({ timeout: 15_000 });
    await resume.forget.click();
    await expect(resume.card).toHaveCount(0);
    expect(await resume.remembered()).toBeNull();

    await page.goto("/");
    await expect(page.locator("h1").first()).toBeVisible();
    await expect(resume.card).toHaveCount(0);
  });
});
