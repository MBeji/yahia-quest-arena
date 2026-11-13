import { devices } from "@playwright/test";
import { test, expect } from "../fixtures";
import { InstallInvitePage } from "../pages/install-invite.page";
import { PracticePage } from "../pages/public-practice.page";
import { QuestPage } from "../pages/quest.page";

/**
 * Étude 40 lot 3 — L'INVITATION À INSTALLER, sur l'écran de résultat d'un visiteur SANS COMPTE
 * (US-5, US-6). Tier `public-anon` : jouer un quiz exige les lectures anonymes du projet de TEST.
 *
 * Le quiz est réussi « pour de vrai » : la clé vient du projet de test (service role), le lecteur
 * est le même que celui de la quête connectée, et le rythme respecte l'anti-précipitation
 * (≥ 4 s par question) — sans quoi un quiz juste mais expédié n'est pas une réussite.
 */

const pixel = devices["Pixel 7"];
const iphone = devices["iPhone 13"];

test.describe("L'invitation à installer — Chromium Android (é40 lot 3, US-5)", () => {
  test.use({
    userAgent: pixel.userAgent,
    viewport: pixel.viewport,
    deviceScaleFactor: pixel.deviceScaleFactor,
    isMobile: true,
    hasTouch: true,
  });

  test("événement reçu, quiz réussi ⇒ la carte ; le bouton ouvre la fenêtre du navigateur ; acceptée, elle disparaît pour toujours", async ({
    page,
    adminDb,
  }) => {
    test.setTimeout(180_000);
    const subjectId = await adminDb.freeSchoolSubjectId();
    const quizId = await adminDb.quizExerciseId(subjectId);
    const key = await adminDb.answerKey(quizId);
    const practice = new PracticePage(page);
    const invite = new InstallInvitePage(page);

    await practice.goto(quizId);
    await practice.firstQuestionVisible();
    // Le navigateur annonce que l'application est installable — bien avant l'écran de résultat.
    await invite.offerNativeInstall("accepted");
    // Jamais à l'arrivée (R-11) : pendant le quiz, rien.
    await expect(invite.card).toHaveCount(0);

    await new QuestPage(page).answerAllCorrectly(key);
    await expect(practice.score).toBeVisible({ timeout: 15_000 });

    // La carte, sous les actions et AVANT l'invitation au compte, qui reste en dernier.
    await expect(invite.card).toBeVisible();
    await expect(invite.card).toHaveAttribute("data-platform", "native");
    await expect(invite.steps).toHaveCount(0);
    const cardBox = await invite.card.boundingBox();
    const signupBox = await practice.accountInvite.boundingBox();
    expect(cardBox && signupBox && cardBox.y < signupBox.y).toBe(true);
    expect(await invite.remembered()).toMatchObject({ dismissed: 0 });

    // Un geste ouvre la fenêtre du navigateur ; acceptée ⇒ plus de carte, plus jamais.
    await invite.cta.click();
    await expect.poll(() => invite.promptCount()).toBe(1);
    await expect(invite.card).toHaveCount(0);
    await expect.poll(async () => (await invite.remembered())?.dismissed).toBe(2);
  });

  test("quiz raté ⇒ rien, même si l'application est installable", async ({ page, adminDb }) => {
    test.setTimeout(120_000);
    const subjectId = await adminDb.freeSchoolSubjectId();
    const quizId = await adminDb.quizExerciseId(subjectId);
    const practice = new PracticePage(page);
    const invite = new InstallInvitePage(page);

    await practice.goto(quizId);
    await practice.firstQuestionVisible();
    await invite.offerNativeInstall();
    // Expédié (bien moins de 4 s par question) : quel que soit le score, ce n'est pas une réussite.
    await practice.playThrough();

    // Le pied de résultat est là (l'invitation au compte) — et la carte n'y est pas.
    await expect(practice.accountInvite).toBeVisible({ timeout: 15_000 });
    await expect(invite.card).toHaveCount(0);
    expect(await invite.remembered()).toBeNull();
  });
});

test.describe("L'invitation à installer — Safari iPhone (é40 lot 3, US-6)", () => {
  // L'agent et l'écran d'un iPhone, dans le Chromium du projet : la détection lit l'agent.
  test.use({
    userAgent: iphone.userAgent,
    viewport: iphone.viewport,
    deviceScaleFactor: iphone.deviceScaleFactor,
    isMobile: true,
    hasTouch: true,
  });

  test("non installé, quiz réussi ⇒ la carte en deux gestes, sans bouton d'action ; « Plus tard » la referme", async ({
    page,
    adminDb,
  }) => {
    test.setTimeout(180_000);
    const subjectId = await adminDb.freeSchoolSubjectId();
    const quizId = await adminDb.quizExerciseId(subjectId);
    const key = await adminDb.answerKey(quizId);
    const practice = new PracticePage(page);
    const invite = new InstallInvitePage(page);

    await practice.goto(quizId);
    await practice.firstQuestionVisible();
    await new QuestPage(page).answerAllCorrectly(key);
    await expect(practice.score).toBeVisible({ timeout: 15_000 });

    await expect(invite.card).toBeVisible();
    await expect(invite.card).toHaveAttribute("data-platform", "ios");
    await expect(invite.steps).toHaveCount(2);
    await expect(invite.cta).toHaveCount(0);

    // Refus ⇒ la carte se referme, l'appareil le retient (pas avant 14 jours).
    await invite.later.click();
    await expect(invite.card).toHaveCount(0);
    expect(await invite.remembered()).toMatchObject({ dismissed: 1 });
  });
});
