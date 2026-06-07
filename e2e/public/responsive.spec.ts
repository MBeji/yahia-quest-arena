import { test, expect } from "../fixtures";
import { DEVICE_VIEWPORTS, MD_BREAKPOINT, expectNoHorizontalOverflow } from "../helpers/viewports";

// Display / responsive coverage across phone → tablet → laptop → desktop on the
// public pages (landing, login, signup): no horizontal overflow, key controls
// visible, and the marketing nav collapses below the `md` breakpoint.
test.describe("Responsive — public pages", () => {
  for (const vp of DEVICE_VIEWPORTS) {
    test(`${vp.name} (${vp.width}×${vp.height})`, async ({ page, landing, auth }) => {
      await page.setViewportSize({ width: vp.width, height: vp.height });

      // --- Landing ---
      await landing.goto();
      await expect(landing.brand).toBeVisible();
      await expect(landing.signupCta).toBeVisible();
      await expect(landing.loginCta).toBeVisible();
      await expectNoHorizontalOverflow(page);

      // Marketing nav links are hidden on phones, shown from `md` up.
      const navFeatures = page.locator('a[href="#features"]');
      if (vp.width >= MD_BREAKPOINT) {
        await expect(navFeatures).toBeVisible();
      } else {
        await expect(navFeatures).toBeHidden();
      }

      // --- Login ---
      await auth.goto("login");
      await expect(auth.email).toBeVisible();
      await expect(auth.submit).toBeVisible();
      await expectNoHorizontalOverflow(page);

      // --- Signup ---
      await auth.goto("signup");
      await expect(auth.email).toBeVisible();
      await expectNoHorizontalOverflow(page);
    });
  }
});
