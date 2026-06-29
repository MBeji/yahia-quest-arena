import { test, expect } from "../fixtures";
import { SubjectHubPage } from "../pages/public-subject.page";
import { LessonReaderPage } from "../pages/public-reader.page";
import { PracticePage } from "../pages/public-practice.page";

/**
 * GAP-044 — public navigation BETWEEN screens, logged out. The content-journey
 * spec proves each screen RENDERS (reached via direct goto); this proves the
 * TRANSITIONS a learner actually takes — cours → exercice (the « practise this
 * chapter » CTA), exercice → cours (« revoir le cours »), and an anonymous quiz
 * tap from a subject hub landing on the account invite rather than the login
 * wall. These click-through paths are exactly what goto()-based specs miss, so a
 * missing or mis-routed link slips through green. Deterministic ids come from
 * `adminDb` (service-role).
 */
test.describe("Anonymous inter-screen navigation (cours ↔ exercice)", () => {
  test("course reader → « practise » CTA → free practice (never the login wall)", async ({
    page,
    adminDb,
  }) => {
    // A non-school subject is never comprehension-quiz-gated → the CTA routes an
    // anon straight to a publicly-correctable practice exercise.
    const subjectId = await adminDb.nonSchoolSubjectId();
    const target = await adminDb.chapterWithPractice(subjectId);
    if (!target)
      throw new Error("test subject has no practiceable chapter (apply content to TEST?)");
    const { chapterId, exerciseId } = target;

    const reader = new LessonReaderPage(page);
    await reader.goto(chapterId);
    await expect(reader.heading).toBeVisible({ timeout: 15_000 });

    // The fix: a reader goes straight from the lesson to its practice.
    await expect(reader.practiceCta).toBeVisible();
    await reader.practiceCta.click();

    // Anon → free practice on THAT exercise, never bounced to login.
    await expect(page).toHaveURL(new RegExp(`/exercice/${exerciseId}`));
    await expect(page).not.toHaveURL(/\/auth/);

    // …and it really practises (immediate correction, no account needed).
    const practice = new PracticePage(page);
    await practice.answerAll();
    await practice.checkButton.click();
    await expect(practice.score).toBeVisible({ timeout: 15_000 });
  });

  test("practice → « revoir le cours » → back to the course reader", async ({ page, adminDb }) => {
    const subjectId = await adminDb.nonSchoolSubjectId();
    const target = await adminDb.chapterWithPractice(subjectId);
    if (!target)
      throw new Error("test subject has no practiceable chapter (apply content to TEST?)");
    const { chapterId, exerciseId } = target;

    const practice = new PracticePage(page);
    await practice.goto(exerciseId);
    await expect(practice.heading).toBeVisible({ timeout: 15_000 });

    // The fix: practice links back to the very chapter it belongs to.
    await expect(practice.reviewCourseLink).toBeVisible();
    await practice.reviewCourseLink.click();

    await expect(page).toHaveURL(new RegExp(`/chapitre/${chapterId}`));
    const reader = new LessonReaderPage(page);
    await expect(reader.heading).toBeVisible({ timeout: 15_000 });
    await expect(page).not.toHaveURL(/\/auth/);
  });

  test("anonymous quiz tap lands on the account invite, not the login wall", async ({
    page,
    adminDb,
  }) => {
    // A school subject has a comprehension quiz (mode='quiz').
    const subjectId = await adminDb.schoolSubjectId();
    const quizId = await adminDb.quizExerciseId(subjectId);

    const subject = new SubjectHubPage(page);
    await subject.goto(subjectId);
    await expect(subject.heading).toBeVisible({ timeout: 15_000 });

    // An anon never gets a scored-quest link — the quiz routes to public practice
    // too, so tapping it can't bounce them to login.
    await expect(subject.questLinks).toHaveCount(0);

    const quizLink = subject.exerciseLinkById(quizId);
    await expect(quizLink).toBeVisible();
    await quizLink.click();

    await expect(page).toHaveURL(new RegExp(`/exercice/${quizId}`));
    await expect(page).not.toHaveURL(/\/auth/);
    // The quiz is presented as an account invite, not fake-corrected.
    await expect(page.getByText(/Quiz de compréhension/)).toBeVisible();
  });
});
