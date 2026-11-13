import { test, expect } from "../fixtures";
import { KeepRowPage, chapterLinkIn } from "../pages/keep-row.page";
import { PracticePage } from "../pages/public-practice.page";
import { LessonReaderPage } from "../pages/public-reader.page";
import { QuestPage } from "../pages/quest.page";

/**
 * Étude 40 lot 4 — « GARDER CE CHAPITRE » : le lien de reprise et le partage d'une réussite, pour
 * un visiteur SANS COMPTE (US-7, US-8). Tier `public-anon` : jouer un quiz exige les lectures
 * anonymes du projet de TEST.
 *
 * Rien ne quitte le test : la feuille de partage est absente, `window.open` et le presse-papiers
 * sont des sondes (`KeepRowPage.shapeDevice`), et toute requête vers `wa.me` est coupée.
 */

test("quiz réussi, sans feuille de partage ⇒ les deux gestes ; chacun ouvre wa.me avec le lien du CHAPITRE", async ({
  page,
  adminDb,
}) => {
  test.setTimeout(180_000);
  const subjectId = await adminDb.freeSchoolSubjectId();
  const quizId = await adminDb.quizExerciseId(subjectId);
  const key = await adminDb.answerKey(quizId);
  const practice = new PracticePage(page);
  const keep = new KeepRowPage(page);
  const towardsWhatsapp: string[] = [];
  page.on("request", (request) => {
    if (new URL(request.url()).hostname.endsWith("wa.me")) towardsWhatsapp.push(request.url());
  });

  await keep.shapeDevice({ whatsapp: true });
  await practice.goto(quizId);
  await practice.firstQuestionVisible();
  // Jamais pendant le quiz : la rangée appartient à l'écran de résultat.
  await expect(keep.row).toHaveCount(0);

  await new QuestPage(page).answerAllCorrectly(key);
  await expect(practice.score).toBeVisible({ timeout: 15_000 });

  // Les deux gestes, au-dessus de l'invitation au compte ; aucun champ de saisie (R-15).
  await expect(keep.send).toBeVisible({ timeout: 15_000 });
  await expect(keep.shareSuccess).toBeVisible();
  await expect(keep.row.locator("input, textarea, select")).toHaveCount(0);
  const rowBox = await keep.row.boundingBox();
  const signupBox = await practice.accountInvite.boundingBox();
  expect(rowBox && signupBox && rowBox.y < signupBox.y).toBe(true);

  // « Partager ma réussite » ⇒ wa.me, SANS destinataire, avec le score et le lien `?src=share`.
  await keep.shareSuccess.click();
  await expect.poll(() => keep.whatsappTexts()).toHaveLength(1);
  const [success] = await keep.whatsappTexts();
  expect(success).toContain(`${key.length}/${key.length}`);
  const shared = chapterLinkIn(success);
  expect(shared.src).toBe("share");

  // « M'envoyer la suite » ⇒ le MÊME chapitre, `?src=resume_link` ; jamais l'adresse de l'exercice.
  await keep.send.click();
  await expect.poll(() => keep.whatsappTexts()).toHaveLength(2);
  const resume = (await keep.whatsappTexts())[1];
  expect(chapterLinkIn(resume)).toMatchObject({ src: "resume_link", chapterId: shared.chapterId });
  expect(`${success} ${resume}`).not.toContain(quizId);

  // WhatsApp a pris le relais : pas de confirmation de copie, et aucune requête n'est partie.
  await expect(keep.copied).toHaveText("");
  expect(await keep.copiedTexts()).toEqual([]);
  expect(towardsWhatsapp).toEqual([]);
});

test("quiz raté, ni feuille de partage ni WhatsApp ⇒ « M'envoyer la suite » seul, copie et confirmation ; le lien ramène au chapitre, ?src= retiré", async ({
  page,
  adminDb,
}) => {
  test.setTimeout(150_000);
  const subjectId = await adminDb.freeSchoolSubjectId();
  const quizId = await adminDb.quizExerciseId(subjectId);
  const practice = new PracticePage(page);
  const keep = new KeepRowPage(page);

  await keep.shapeDevice({ whatsapp: false });
  await practice.goto(quizId);
  await practice.firstQuestionVisible();
  // Expédié (bien moins de 4 s par question) : quel que soit le score, ce n'est pas une réussite.
  // `answerAll` rejoue le premier clic tant que l'hydratation ne l'a pas pris.
  await new QuestPage(page).answerAll();
  await expect(practice.score).toBeVisible({ timeout: 15_000 });

  // Un échec ne se partage pas (R-17) : un seul geste.
  await expect(keep.send).toBeVisible({ timeout: 15_000 });
  await expect(keep.shareSuccess).toHaveCount(0);
  await expect(keep.copied).toHaveText("");

  // Ni l'un ni l'autre ⇒ le texte est copié, et la rangée le dit.
  await keep.send.click();
  await expect(keep.copied).not.toHaveText("", { timeout: 10_000 });
  const [copied] = await keep.copiedTexts();
  const link = chapterLinkIn(copied);
  expect(link.src).toBe("resume_link");

  // Ouvrir le lien ⇒ le chapitre (pas l'exercice), et l'adresse affichée redevient propre.
  await page.goto(link.path);
  await expect(new LessonReaderPage(page).heading).toBeVisible({ timeout: 15_000 });
  await expect
    .poll(() => new URL(page.url()).pathname + new URL(page.url()).search, { timeout: 15_000 })
    .toBe(`/chapitre/${link.chapterId}`);
});

test("bas d'un cours, sans compte ⇒ « M'envoyer ce cours » au-dessus de l'invitation au compte", async ({
  page,
  adminDb,
}) => {
  const chapterId = await adminDb.fixtureLessonChapterId();
  const reader = new LessonReaderPage(page);
  const keep = new KeepRowPage(page);

  await keep.shapeDevice({ whatsapp: true });
  await reader.goto(chapterId);
  await expect(reader.heading).toBeVisible();
  await expect(keep.send).toBeVisible({ timeout: 15_000 });
  // Un cours n'est pas une réussite : un seul geste.
  await expect(keep.shareSuccess).toHaveCount(0);
  const rowBox = await keep.row.boundingBox();
  const signupBox = await reader.accountInvite.boundingBox();
  expect(rowBox && signupBox && rowBox.y < signupBox.y).toBe(true);

  // Le clic est rejoué tant que l'hydratation ne l'a pas pris : la sonde dit quand il a porté.
  await expect(async () => {
    await keep.send.click();
    expect(await keep.whatsappTexts()).not.toHaveLength(0);
  }).toPass({ timeout: 20_000 });
  expect(chapterLinkIn((await keep.whatsappTexts())[0])).toMatchObject({
    src: "resume_link",
    chapterId,
  });
});
