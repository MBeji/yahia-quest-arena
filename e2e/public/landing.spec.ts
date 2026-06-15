import { test, expect } from "../fixtures";

/**
 * Landing page — public, no backend/auth. A reliable SSR + hydration smoke test.
 * Locale-independent selectors (brand, route hrefs, section anchors).
 */
test.describe("Landing page", () => {
  test("renders the hero, sections and auth CTAs", async ({ page, landing }) => {
    await landing.goto();

    await expect(page).toHaveTitle(/Na9ra Nal3ab/i);
    await expect(landing.brand).toBeVisible();
    await expect(landing.signupCta).toBeVisible();
    await expect(landing.loginCta).toBeVisible();
    await expect(landing.section("features")).toBeAttached();
    await expect(landing.section("subjects")).toBeAttached();
    await expect(landing.section("ranks")).toBeAttached();
  });

  test("exposes the reduce-animations accessibility toggle", async ({ landing }) => {
    await landing.goto();
    await expect(landing.reduceAnimationsToggle).toBeVisible();
    await landing.reduceAnimationsToggle.click();
    await expect(landing.section("features")).toBeAttached();
  });

  test("navigates to signup from the landing CTA", async ({ page, landing }) => {
    await landing.goto();
    await landing.signupCta.click();
    // `/signup` is a thin redirect route to the auth page in signup mode.
    await expect(page).toHaveURL(/\/auth\?mode=signup/);
  });
});
