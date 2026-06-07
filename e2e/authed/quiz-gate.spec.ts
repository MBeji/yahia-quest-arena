import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The comprehension-quiz gate must apply to the SCHOOL program only. Non-school
// themes (culture-générale, muscle-cerveau/IQ, language tracks) expose their
// missions directly. Assumes a fresh free account (CI runs reset-gameplay first,
// so no quiz has been passed yet).
test.use({ storageState: STORAGE_STATE.free });

test.describe("Comprehension-quiz gate — school program only", () => {
  test("a school subject locks its missions until the quiz is passed", async ({
    subject,
    adminDb,
    page,
  }) => {
    const id = await adminDb.schoolSubjectId();
    await subject.goto(id);

    // Page loaded: the always-clickable quiz tile(s) are present.
    await expect(page.locator('a[href^="/quest/"]').first()).toBeVisible();
    // Fresh free user → no quiz passed → at least one locked mission tile.
    await expect(subject.lockedMissions.first()).toBeVisible();
    expect(await subject.lockedMissions.count()).toBeGreaterThan(0);
  });

  test("a non-school subject never locks missions on the quiz", async ({
    subject,
    adminDb,
    page,
  }) => {
    const id = await adminDb.nonSchoolSubjectId();
    await subject.goto(id);

    await expect(page.locator('a[href^="/quest/"]').first()).toBeVisible();
    await expect(subject.lockedMissions).toHaveCount(0);
  });
});
