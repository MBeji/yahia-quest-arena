import { test, expect } from "@playwright/test";
import { STORAGE_STATE } from "../helpers/users";

/**
 * PREMIUM student journey. The key differentiator vs a free user: opening a
 * difficulty 3+ mission does NOT show the subscription paywall (they may still
 * hit the comprehension-quiz gate, but never the "subscribe" wall).
 */
test.use({ storageState: STORAGE_STATE.premium });

test.describe("Premium student", () => {
  test("dashboard loads", async ({ page }) => {
    await page.goto("/dashboard");
    await expect(page).toHaveURL(/\/dashboard/);
    await expect(page.locator('a[href^="/subject/"]').first()).toBeVisible({ timeout: 15_000 });
  });

  test("opening a premium (difficulty 3+) mission does NOT show the paywall", async ({ page }) => {
    await page.goto("/dashboard");
    await page.locator('a[href^="/subject/"]').first().click();
    await expect(page).toHaveURL(/\/subject\//);

    // Premium users should NOT see the "Abonnement requis" lock on difficulty 3+.
    await expect(page.getByText(/abonnement requis/i)).toHaveCount(0);

    // Open the first available mission; the subscription paywall must not appear.
    await page.locator('a[href^="/quest/"]').first().click();
    await expect(page).toHaveURL(/\/quest\//);
    await expect(page.getByRole("button", { name: /bêta|beta/i })).toHaveCount(0);
  });
});
