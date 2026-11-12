import { test, expect } from "../fixtures";
import { PracticePage } from "../pages/public-practice.page";
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

  /**
   * Le cas le plus coûteux pour un visiteur qui revient : il a réussi le quiz de compréhension
   * d'un chapitre, et sa mission s'ouvrait pourtant sur le verrou dès l'onglet suivant (la réussite
   * vivait en `sessionStorage`). Elle vit maintenant sur l'appareil, trente jours.
   *
   * La réussite est POSÉE telle que le lecteur l'écrit : la clé de réponse n'atteint jamais le
   * client, un visiteur de test ne peut donc pas réussir un quiz « pour de vrai » à coup sûr.
   */
  test("quiz réussi la veille : dans un onglet neuf, la mission du même chapitre s'ouvre sur la question, pas sur le verrou", async ({
    page,
    context,
    adminDb,
  }) => {
    const subjectId = await adminDb.freeSchoolSubjectId();
    const pair = await adminDb.chapterQuizAndMission(subjectId);
    test.skip(!pair, "aucun chapitre de fixture ne porte à la fois un quiz et une mission");
    if (!pair) return;

    // 1. Sans mémoire : le verrou — c'est le positif apparié, et la source de l'identifiant du chapitre.
    const practice = new PracticePage(page);
    await practice.goto(pair.missionId);
    await expect(practice.lockTitle).toBeVisible({ timeout: 15_000 });
    const lessonHref = await practice.lockLessonLink.getAttribute("href");
    const chapterId = lessonHref?.split("/chapitre/")[1]?.split(/[?#]/)[0];
    expect(chapterId).toBeTruthy();

    // 2. L'appareil retient la réussite d'hier.
    await page.evaluate(
      ([key, id]) =>
        window.localStorage.setItem(
          key,
          JSON.stringify({ [id]: Date.now() - 24 * 60 * 60 * 1000 }),
        ),
      [ResumeCardPage.QUIZ_PASSED_KEY, chapterId as string] as const,
    );

    // 3. Un onglet NEUF (même appareil, `sessionStorage` vide) : la question, pas le verrou.
    const tab = await context.newPage();
    const inNewTab = new PracticePage(tab);
    await inNewTab.goto(pair.missionId);
    await expect(inNewTab.questionCard).toBeVisible({ timeout: 15_000 });
    await expect(inNewTab.lockTitle).toHaveCount(0);
    expect(await tab.evaluate(() => window.sessionStorage.length)).toBe(0);
    await tab.close();
  });
});
