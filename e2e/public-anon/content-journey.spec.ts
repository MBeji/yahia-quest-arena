import { test, expect } from "../fixtures";
import { SubjectHubPage } from "../pages/public-subject.page";
import { LessonReaderPage } from "../pages/public-reader.page";
import { PracticePage } from "../pages/public-practice.page";

/**
 * THE C8 pivot, end to end and LOGGED OUT: an anonymous visitor reads a course and
 * practises an exercise with immediate correction — and is NEVER bounced to login
 * (étude §9, plan "vérification de bout en bout"). Deterministic content ids come
 * from `adminDb` (service-role) instead of a fragile catalogue walk.
 */
test.describe("Anonymous content journey (no login wall)", () => {
  test("read a course from a subject hub, with the soft account invite", async ({
    page,
    adminDb,
  }) => {
    const subjectId = await adminDb.schoolSubjectId();
    const subject = new SubjectHubPage(page);
    await subject.goto(subjectId);

    // The subject hub renders for an anonymous visitor: chapters with a course link,
    // and — auth-aware — FREE-PRACTICE exercise links (not the scored quest).
    await expect(subject.heading).toBeVisible({ timeout: 15_000 });
    await expect(subject.courseLinks.first()).toBeVisible({ timeout: 15_000 });
    await expect(subject.practiceLinks.first()).toBeVisible();
    await expect(page).not.toHaveURL(/\/auth/);

    // Open the first chapter's course reader.
    await subject.courseLinks.first().click();
    await expect(page).toHaveURL(/\/chapitre\//);

    const reader = new LessonReaderPage(page);
    await expect(reader.content).toBeVisible({ timeout: 15_000 });
    // Reference-register affordances: print, and a soft account invite — reading is
    // free, the account is an invitation (a gain), never a wall.
    await expect(reader.printButton).toBeVisible();
    await expect(reader.accountInvite).toBeVisible();
    await expect(page).not.toHaveURL(/\/auth/);

    // Le contrôle sur place (étude 35) : la réponse est REPLIÉE tant que l'élève ne la
    // demande pas. C'est tout l'intérêt du bloc — une réponse visible d'avance ne fait rien
    // travailler. Le `<details>` est natif : rien à charger, rien à hydrater, et cette
    // assertion est la seule qui le prouve dans un vrai navigateur.
    await expect(reader.check).toBeVisible();
    await expect(reader.checkAnswer).toBeHidden();
    await reader.checkToggle.click();
    await expect(reader.checkAnswer).toBeVisible();

    // When the chapter has a summary, the Cours/Résumé toggle works (body stays).
    if (await reader.summaryTab.isVisible()) {
      await reader.summaryTab.click();
      await expect(reader.content).toBeVisible();
    }
  });

  test("practise an exercise with immediate correction and an account invite", async ({
    page,
    adminDb,
  }) => {
    // A non-school subject is never comprehension-quiz-gated → a clean free-practice
    // target. Its non-quiz mission is correctable by the public check_answers RPC.
    const subjectId = await adminDb.nonSchoolSubjectId();
    const exerciseId = await adminDb.freeExerciseId(subjectId);

    const practice = new PracticePage(page);
    await practice.goto(exerciseId);
    await practice.firstQuestionVisible();

    // Same question-by-question player as the connected quest, login-free.
    await practice.playThrough();

    // The run finishes on a result screen with the score (nothing saved, no XP).
    await expect(practice.score).toBeVisible({ timeout: 15_000 });
    // The « moment d'or »: a non-blocking account invite (gain XP / save / rank).
    await expect(practice.accountInvite).toBeVisible();
    await expect(page).not.toHaveURL(/\/auth/);
  });
});

/**
 * ÉTOILES & SCEAUX VUS SANS COMPTE — étude 34, US-8 / R-16.
 *
 * La promesse de l'étude côté public : le visiteur voit la FORME de ce qu'il
 * gagnerait (les quatre cachets, les crans de chaque chapitre) et une invitation
 * en une ligne — mais **rien ne se calcule sans compte**, et **rien de plus n'est
 * verrouillé**. Ce dernier point est le vrai risque de régression : une surface
 * de progression ajoutée à un écran public est le meilleur moyen d'y glisser un
 * mur sans le vouloir.
 */
test.describe("Hub public — étoiles et sceaux sans compte (é34, US-8)", () => {
  test("montre les cachets en attente et la promesse, sans rien calculer", async ({
    page,
    adminDb,
  }) => {
    const subjectId = await adminDb.nonSchoolSubjectId();
    const hub = new SubjectHubPage(page);
    await hub.goto(subjectId);

    await expect(hub.seals).toBeVisible({ timeout: 20_000 });
    // Les quatre cachets, tous en attente : on voit ce qu'il y a à gagner.
    await expect(hub.sealMarks).toHaveCount(4);
    await expect(page.locator('[data-testid="seal-mark"][data-earned="true"]')).toHaveCount(0);
    await expect(hub.anonPromise).toBeVisible();

    // …et rien d'un compte : aucun cran acquis, aucun compteur d'effort.
    await expect(hub.litRungs).toHaveCount(0);
    await expect(hub.effort).toHaveCount(0);
  });

  test("n'ajoute AUCUN verrou : les missions restent atteignables en entraînement", async ({
    page,
    adminDb,
  }) => {
    const subjectId = await adminDb.nonSchoolSubjectId();
    const hub = new SubjectHubPage(page);
    await hub.goto(subjectId);

    // Une matière hors école n'a pas de porte de quiz : toutes ses missions
    // restent des liens d'entraînement, exactement comme avant l'étude.
    await expect(hub.practiceLinks.first()).toBeVisible({ timeout: 20_000 });
    await expect(hub.questLinks).toHaveCount(0);
  });
});
