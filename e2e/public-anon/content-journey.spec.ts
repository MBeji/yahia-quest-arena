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
    await expect(practice.heading).toBeVisible({ timeout: 15_000 });

    await practice.answerAll();
    await practice.checkButton.click();

    // Immediate correction: a score appears (nothing saved, no XP, no login).
    await expect(practice.score).toBeVisible({ timeout: 15_000 });
    // The « moment d'or »: a non-blocking account invite (gain XP / save / rank).
    await expect(practice.accountInvite).toBeVisible();
    await expect(page).not.toHaveURL(/\/auth/);
  });
});
