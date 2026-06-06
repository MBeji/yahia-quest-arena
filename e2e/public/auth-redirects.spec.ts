import { test, expect } from "../fixtures";

/**
 * Auth redirects — PUBLIC (works with dummy Supabase env: getSession() resolves
 * to "no session" from empty local storage).
 */
test.describe("Auth redirects (logged out)", () => {
  test("a protected route redirects to /auth", async ({ page }) => {
    await page.goto("/dashboard");
    await expect(page).toHaveURL(/\/auth/, { timeout: 15_000 });
  });

  test("the /auth page shows the login form", async ({ auth }) => {
    await auth.goto("login");
    await expect(auth.email).toBeVisible();
    await expect(auth.password).toBeVisible();
    await expect(auth.submit).toBeVisible();
  });

  test("a Continue with Google button is present", async ({ auth }) => {
    await auth.goto("login");
    await expect(auth.google).toBeVisible();
  });
});
