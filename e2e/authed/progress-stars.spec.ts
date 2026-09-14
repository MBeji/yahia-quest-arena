import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/**
 * ÉTOILES DE CHAPITRE & SCEAUX DE MATIÈRE — étude 34, lot 2, bout en bout.
 *
 * Ce que les tests unitaires ne peuvent pas prouver, et qui est pourtant le cœur
 * de l'étude : que la RPC `get_subject_progress` est bien câblée, que ses RLS la
 * laissent passer pour un élève ordinaire, et qu'une mission réussie **allume**
 * vraiment un cran — c'est-à-dire que le trigger `record_progress_stars` a écrit
 * au grand livre et que le hub l'a relu. Trois pièces (SQL, server fn, écran) que
 * seul un parcours réel met bout à bout.
 *
 * Le décor est celui de `quiz-gate.spec.ts` — une matière SCOLAIRE gratuite, donc
 * le quiz est le seul verrou en jeu — et les deux tests tournent EN SÉRIE parce
 * que le second mute l'état (il passe un quiz et une mission).
 */
test.use({ storageState: STORAGE_STATE.free });

test.describe.serial("Étoiles de chapitre & sceaux de matière (é34)", () => {
  test("le hub connecté montre l'état de la matière, pas la promesse de l'anonyme", async ({
    subject,
    adminDb,
  }) => {
    const subjectId = await adminDb.freeSchoolSubjectId();
    await subject.goto(subjectId);

    // Le bloc existe, avec ses quatre cachets — acquis ou en attente, mais présents :
    // un sceau à gagner se voit, sinon il ne motive personne (RISK-1).
    await expect(subject.seals).toBeVisible({ timeout: 20_000 });
    await expect(subject.sealMarks).toHaveCount(4);

    // Connecté ⇒ les compteurs d'effort, jamais la promesse (R-16 ne vaut que sans compte).
    await expect(subject.effort).toBeVisible();
    await expect(subject.anonPromise).toHaveCount(0);
  });

  test("réussir le quiz puis la mission d'un chapitre ALLUME un cran", async ({
    subject,
    quest,
    adminDb,
  }) => {
    test.setTimeout(240_000);
    const subjectId = await adminDb.freeSchoolSubjectId();
    const pair = await adminDb.chapterQuizAndMission(subjectId);
    test.skip(!pair, "No chapter with both a quiz and a mission on the test project.");
    if (!pair) return; // narrow the type (test.skip already aborted when null)

    // 1. La porte du chapitre : sans elle, aucune étoile ne tombe (R-4).
    const quizKey = await adminDb.answerKey(pair.quizId);
    await quest.goto(pair.quizId);
    await quest.answerAllCorrectly(quizKey);
    await expect(quest.score).toBeVisible({ timeout: 15_000 });

    // 2. La mission la plus basse du chapitre, réussie sans se précipiter —
    //    `answerAllCorrectly` respecte déjà le plancher anti-farm, qui est le même
    //    seuil que l'anti-précipitation de R-3 (≥ 4 s/question).
    const missionKey = await adminDb.answerKey(pair.missionId);
    await quest.goto(pair.missionId);
    await quest.answerAllCorrectly(missionKey);
    await expect(quest.score).toBeVisible({ timeout: 15_000 });

    // 3. Le hub relit le grand livre : au moins un cran est acquis. C'est la chaîne
    //    complète — trigger → `user_chapter_stars` → `get_subject_progress` → jauge.
    await subject.goto(subjectId);
    await expect(subject.seals).toBeVisible({ timeout: 20_000 });
    await expect(subject.litRungs.first()).toBeVisible({ timeout: 20_000 });
  });
});
