import { test } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";
import { expectNoSeriousA11yViolations } from "../helpers/a11y";

// Accessibility smoke on the authenticated surfaces (Phase 1 covered only public
// pages). A serious/critical WCAG2 A/AA violation here is a real bug-bounty finding.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Accessibility — authenticated pages", () => {
  test.describe.configure({ timeout: 60_000 });

  test("dashboard", async ({ dashboard, page }) => {
    await dashboard.goto();
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });

  test("leaderboard", async ({ leaderboard, page }) => {
    await leaderboard.goto();
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });

  test("subject page", async ({ subject, adminDb, page }) => {
    await subject.goto(await adminDb.schoolSubjectId());
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });
});
