import { test, expect } from "@playwright/test";

/**
 * Auth redirects — PUBLIC (no real backend needed; works with dummy Supabase
 * env because getSession() resolves to "no session" from empty local storage).
 * Runs in the standard E2E workflow alongside the landing smoke tests.
 */
test.describe("Auth redirects (logged out)", () => {
  test("a protected route redirects to /auth", async ({ page }) => {
    await page.goto("/dashboard");
    await expect(page).toHaveURL(/\/auth/, { timeout: 15_000 });
  });

  test("the /auth page shows the login form", async ({ page }) => {
    await page.goto("/auth?mode=login");
    await expect(page.locator('input[type="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
    await expect(page.locator('button[type="submit"]')).toBeVisible();
  });

  test("a Continue with Google button is present", async ({ page }) => {
    await page.goto("/auth?mode=login");
    await expect(page.getByRole("button", { name: /google/i })).toBeVisible();
  });
});
