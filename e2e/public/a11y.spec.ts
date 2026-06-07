import { test } from "../fixtures";
import { expectNoSeriousA11yViolations } from "../helpers/a11y";

// Accessibility smoke on the public (no-backend) surfaces. Runs on desktop +
// mobile (both public projects). A serious/critical WCAG 2 A/AA violation here
// is a real finding for the bug-bounty campaign.
test.describe("Accessibility — public pages", () => {
  test("landing page has no serious/critical a11y violations", async ({ page }) => {
    await page.goto("/");
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });

  test("login page has no serious/critical a11y violations", async ({ page }) => {
    await page.goto("/auth?mode=login");
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });

  test("signup page has no serious/critical a11y violations", async ({ page }) => {
    await page.goto("/auth?mode=signup");
    await page.waitForLoadState("networkidle");
    await expectNoSeriousA11yViolations(page);
  });
});
