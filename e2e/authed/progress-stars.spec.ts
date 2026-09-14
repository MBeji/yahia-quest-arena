import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/**
 * ÉTOILES DE CHAPITRE & SCEAUX DE MATIÈRE — étude 34, lots 2 et 4, bout en bout.
 *
 * Ce que les tests unitaires ne peuvent pas prouver, et qui est pourtant le cœur
 * de l'étude : que la RPC `get_subject_progress` est bien câblée, que ses RLS la
 * laissent passer pour un élève ordinaire, et qu'une mission réussie **allume**
 * vraiment un cran — c'est-à-dire que le trigger `record_progress_stars` a écrit
 * au grand livre et que le hub l'a relu. Trois pièces (SQL, server fn, écran) que
 * seul un parcours réel met bout à bout. Le lot 4 y ajoute la CÉLÉBRATION : que
 * l'écran de résultat sache, au moment où l'étoile tombe, qu'elle vient de tomber.
 *
 * Le décor est celui de `quiz-gate.spec.ts` — une matière SCOLAIRE gratuite, donc
 * le quiz est le seul verrou en jeu — et les deux tests tournent EN SÉRIE parce
 * que le second mute l'état (il passe un quiz et tout le cran 1 d'un chapitre).
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

  test("réussir le quiz puis TOUT le cran 1 d'un chapitre fête la première étoile", async ({
    subject,
    quest,
    adminDb,
  }) => {
    const subjectId = await adminDb.freeSchoolSubjectId();
    const plan = await adminDb.chapterFirstStarPlan(subjectId);
    test.skip(!plan, "No chapter with a quiz and a tier-1 mission on the test project.");
    if (!plan) return; // narrow the type (test.skip already aborted when null)
    // Chaque mission se joue au rythme de l'anti-farm (≥ 4 s/question), donc le
    // budget suit le DÉCOR et n'est pas une constante devinée : un chapitre à trois
    // missions de socle coûte trois fois celui d'un chapitre qui n'en a qu'une.
    test.setTimeout(120_000 + plan.missionIds.length * 120_000);

    // 1. La porte du chapitre : sans elle, aucune étoile ne tombe (R-4).
    const quizKey = await adminDb.answerKey(plan.quizId);
    await quest.goto(plan.quizId);
    await quest.answerAllCorrectly(quizKey);
    await expect(quest.score).toBeVisible({ timeout: 15_000 });

    // 2. TOUTES les missions du cran 1, réussies sans se précipiter —
    //    `answerAllCorrectly` respecte déjà le plancher anti-farm, qui est le même
    //    seuil que l'anti-précipitation de R-3 (≥ 4 s/question).
    //
    //    ⚠️ Toutes, et pas une seule : l'étoile ⭐ n'est inscrite que lorsque le cran
    //    est COMPLET (R-8). Une spec qui n'en jouerait qu'une allumerait un cran sans
    //    rien célébrer, et attendrait un bloc que le serveur a raison de ne pas donner.
    for (const missionId of plan.missionIds) {
      const missionKey = await adminDb.answerKey(missionId);
      await quest.goto(missionId);
      await quest.answerAllCorrectly(missionKey);
      await expect(quest.score).toBeVisible({ timeout: 15_000 });
    }

    // 3. L'écran de résultat de la DERNIÈRE mission fête l'étoile (lot 4, R-12). Le
    //    bloc n'existe que si le serveur a répondu `starAfter > starBefore` : sa
    //    présence prouve d'un coup le trigger, le grand livre, `get_attempt_progress`
    //    et le rendu. Le négatif apparié — un exercice réussi qui ne change rien ne
    //    fête rien — est vérifié au palier unitaire (`star-celebration.test.tsx`), le
    //    seul où l'absence soit une vraie absence et pas un chargement en retard.
    await expect(quest.starBlock).toBeVisible({ timeout: 20_000 });

    // 4. Le hub relit le grand livre : le cran est acquis. C'est la chaîne complète —
    //    trigger → `user_chapter_stars` → `get_subject_progress` → jauge.
    await subject.goto(subjectId);
    await expect(subject.seals).toBeVisible({ timeout: 20_000 });
    await expect(subject.litRungs.first()).toBeVisible({ timeout: 20_000 });
  });
});
