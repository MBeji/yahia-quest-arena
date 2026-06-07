import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";
import { DEVICE_VIEWPORTS, expectNoHorizontalOverflow } from "../helpers/viewports";

// Responsive / graphical coverage of the authenticated app across phone → tablet
// → laptop → desktop: the dashboard, leaderboard and a subject page render their
// key content with no horizontal overflow at every size.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Responsive — authenticated app", () => {
  for (const vp of DEVICE_VIEWPORTS) {
    test(`${vp.name} (${vp.width}×${vp.height})`, async ({
      page,
      dashboard,
      leaderboard,
      subject,
      adminDb,
    }) => {
      await page.setViewportSize({ width: vp.width, height: vp.height });

      // Dashboard (goto waits for primary data).
      await dashboard.goto();
      await expect(dashboard.statLevel.or(dashboard.subjectCards.first()).first()).toBeVisible();
      await expectNoHorizontalOverflow(page);

      // Leaderboard.
      await leaderboard.goto();
      await expect(leaderboard.heading).toBeVisible();
      await expectNoHorizontalOverflow(page);

      // A subject page.
      await subject.goto(await adminDb.schoolSubjectId());
      await expect(subject.missionLinks.first()).toBeVisible({ timeout: 15_000 });
      await expectNoHorizontalOverflow(page);
    });
  }
});
