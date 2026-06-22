import { test, expect } from "../fixtures";
import { DEVICE_VIEWPORTS, SM_BREAKPOINT, expectNoHorizontalOverflow } from "../helpers/viewports";

// Display / responsive coverage across phone → tablet → laptop → desktop on the
// public pages (landing, login, signup): no horizontal overflow and the key
// controls of the Référence public header stay visible at every size.
test.describe("Responsive — public pages", () => {
  for (const vp of DEVICE_VIEWPORTS) {
    test(`${vp.name} (${vp.width}×${vp.height})`, async ({ page, landing, auth }) => {
      await page.setViewportSize({ width: vp.width, height: vp.height });

      // --- Landing ---
      await landing.goto();
      await expect(landing.brand).toBeVisible();
      // Always-visible key controls at every size: the account CTA + the language
      // switcher (the login link is a ≥sm enhancement, hidden on phones by design).
      await expect(landing.signupCta).toBeVisible();
      await expect(page.getByRole("button", { name: /change language/i })).toBeVisible();
      await expectNoHorizontalOverflow(page);

      // The Référence header's catalogue nav (Programme/Extras) yields to the
      // switcher on phones: hidden below `sm`, shown from `sm` up.
      const navProgramme = page.locator('header a[href="/programme"]');
      if (vp.width >= SM_BREAKPOINT) {
        await expect(navProgramme).toBeVisible();
      } else {
        await expect(navProgramme).toBeHidden();
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
