import { test, expect } from "../fixtures";
import { DEVICE_VIEWPORTS, expectNoHorizontalOverflow } from "../helpers/viewports";

// Display / responsive coverage across phone → tablet → laptop → desktop on the
// public pages (landing, login, signup): no horizontal overflow and the key
// controls of the Référence public header stay visible at every size.
test.describe("Responsive — public pages", () => {
  for (const vp of DEVICE_VIEWPORTS) {
    test(`${vp.name} (${vp.width}×${vp.height})`, async ({ page, landing, auth, nav }) => {
      await page.setViewportSize({ width: vp.width, height: vp.height });

      // --- Landing ---
      await landing.goto();
      await expect(landing.brand).toBeVisible();
      // Always-visible key controls at every size: the account CTA + the settings
      // menu (the login link is a ≥sm enhancement, hidden on phones by design).
      // Reach the gear through the page object, whose selector is a `data-testid`:
      // a hardcoded aria-label here is exactly what broke when #787 folded the
      // three pop-overs (language, theme, sound) into a single settings menu.
      await expect(landing.signupCta).toBeVisible();
      await expect(nav.settingsTrigger).toBeVisible();
      await expectNoHorizontalOverflow(page);

      // The Référence header keeps Programme reachable at every size: the inline
      // catalogue nav shows it from `sm` up, and a phone-only wrapping row surfaces
      // it below `sm` (so phone visitors never lose the entry point). Exactly one of
      // the two links is visible at any width — assert that, not a single element
      // (a bare `header a[href="/programme"]` now matches both and trips strict mode).
      await expect(page.locator('header a[href="/programme"]:visible')).toHaveCount(1);

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
