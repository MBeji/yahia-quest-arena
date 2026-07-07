import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";
import { DEVICE_VIEWPORTS, expectNoHorizontalOverflow } from "../helpers/viewports";

// Phone widths where the connected header is tightest — iPhone 13 (390) is the
// device from the "affichage décalé à gauche / ne couvre pas l'écran" report.
const PHONE_VIEWPORTS = [
  { name: "iPhone SE", width: 375, height: 667 },
  { name: "iPhone 13", width: 390, height: 844 },
  { name: "iPhone 14 Pro Max", width: 430, height: 932 },
] as const;

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

// The connected header (logo + AccountHud chip + language/theme/sound switchers +
// sign-out) packs the most controls of any surface; on a ~390px phone it used to
// overflow the viewport — pushing every in-flow element into a narrow left column
// with a dark gutter on the right (the fixed bottom nav stayed full width, the
// exact signature of the iPhone-13 report). Guard the tightest phone widths here
// explicitly, and the admin account too — its extra nav entries make its header
// the worst case (they live in the horizontally-scrollable nav strip, so they
// must scroll internally rather than widen the document).
test.describe("Responsive — connected header fits phones", () => {
  for (const vp of PHONE_VIEWPORTS) {
    test(`student dashboard header — ${vp.name} (${vp.width}×${vp.height})`, async ({
      page,
      dashboard,
    }) => {
      await page.setViewportSize({ width: vp.width, height: vp.height });
      await dashboard.goto();
      await expectNoHorizontalOverflow(page);
    });
  }

  test.describe("admin (busiest header)", () => {
    test.use({ storageState: STORAGE_STATE.admin });
    for (const vp of PHONE_VIEWPORTS) {
      test(`admin console header — ${vp.name} (${vp.width}×${vp.height})`, async ({ page }) => {
        await page.setViewportSize({ width: vp.width, height: vp.height });
        await page.goto("/admin/subscriptions");
        await expect(page.locator("main")).toBeVisible();
        await expectNoHorizontalOverflow(page);
      });
    }
  });
});
