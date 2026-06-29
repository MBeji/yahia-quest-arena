import { test, expect } from "../fixtures";

/**
 * Legacy English content paths are kept as 301 redirects to the renamed public FR
 * routes (chantier C8). They must resolve for an ANONYMOUS visitor without a login
 * bounce — the redirect is a `beforeLoad`, which runs before the auth guard.
 */
test.describe("Legacy content routes 301-redirect (logged out)", () => {
  test("/subject/$id → /matiere/$id", async ({ page, adminDb }) => {
    const subjectId = await adminDb.nonSchoolSubjectId();
    await page.goto(`/subject/${subjectId}`);
    await expect(page).toHaveURL(new RegExp(`/matiere/${subjectId}`));
    await expect(page).not.toHaveURL(/\/auth/);
  });

  test("/lesson/$id → /chapitre/$id", async ({ page, adminDb }) => {
    const subjectId = await adminDb.schoolSubjectId();
    // Derive a real chapter id from the subject hub (its course links carry it),
    // so the redirect target is an actually-existing chapter.
    await page.goto(`/matiere/${subjectId}`);
    const firstCourse = page.locator('main a[href^="/chapitre/"]').first();
    await expect(firstCourse).toBeVisible({ timeout: 15_000 });
    const chapterId = (await firstCourse.getAttribute("href"))?.split("/chapitre/")[1] ?? "";
    expect(chapterId, "expected a chapter id in the course link href").toBeTruthy();

    await page.goto(`/lesson/${chapterId}`);
    await expect(page).toHaveURL(new RegExp(`/chapitre/${chapterId}`));
    await expect(page).not.toHaveURL(/\/auth/);
  });
});
