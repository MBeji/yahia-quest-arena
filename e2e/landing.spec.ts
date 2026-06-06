import { test, expect } from "@playwright/test";

/**
 * Landing page — public, no backend/auth required, so it's a reliable smoke test
 * of SSR + hydration + the premium black & gold redesign across browsers.
 */
test.describe("Landing page", () => {
  test("renders the hero, sections and auth CTAs", async ({ page }) => {
    await page.goto("/");

    await expect(page).toHaveTitle(/XP Scholars/i);

    // Auth call-to-action links (locale-independent: assert on the route hrefs).
    await expect(page.locator('a[href="/signup"]').first()).toBeVisible();
    await expect(page.locator('a[href="/login"]').first()).toBeVisible();

    // Anchored sections exist (features / subjects / ranks).
    await expect(page.locator("#features")).toBeAttached();
    await expect(page.locator("#subjects")).toBeAttached();
    await expect(page.locator("#ranks")).toBeAttached();
  });

  test("exposes the reduce-animations accessibility toggle", async ({ page }) => {
    await page.goto("/");
    const toggle = page.getByRole("button", { name: /animations/i });
    await expect(toggle).toBeVisible();
    // Toggling must not break the page.
    await toggle.click();
    await expect(page.locator("#features")).toBeAttached();
  });

  test("navigates to signup from the landing CTA", async ({ page }) => {
    await page.goto("/");
    await page.locator('a[href="/signup"]').first().click();
    // `/signup` is a thin redirect route to the auth page in signup mode.
    await expect(page).toHaveURL(/\/auth\?mode=signup/);
  });
});
