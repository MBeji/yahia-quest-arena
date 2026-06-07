import { test, expect } from "../fixtures";

// Display / responsive smoke on the public landing across phone, tablet and
// desktop widths. The brand + both auth CTAs must stay visible and the page must
// not overflow horizontally (a classic mobile-layout regression).
const VIEWPORTS = [
  { name: "mobile", width: 375, height: 667 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1280, height: 800 },
];

test.describe("Responsive landing", () => {
  for (const vp of VIEWPORTS) {
    test(`renders cleanly at ${vp.name} (${vp.width}px)`, async ({ page, landing }) => {
      await page.setViewportSize({ width: vp.width, height: vp.height });
      await landing.goto();

      await expect(landing.brand).toBeVisible();
      await expect(landing.signupCta).toBeVisible();
      await expect(landing.loginCta).toBeVisible();

      // No horizontal overflow (allow a couple px of sub-pixel rounding).
      const overflow = await page.evaluate(
        () => document.documentElement.scrollWidth - document.documentElement.clientWidth,
      );
      expect(overflow).toBeLessThanOrEqual(3);
    });
  }
});
