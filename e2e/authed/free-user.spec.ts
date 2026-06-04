import { test, expect } from "@playwright/test";
import { STORAGE_STATE } from "../helpers/users";

/**
 * FREE student journey. Reuses the authenticated browser state captured by the
 * setup project. Needs the test Supabase project + seeded content (run all
 * migrations + content there). Selectors are intentionally resilient; adjust
 * after the first real run if the UI copy differs.
 */
test.use({ storageState: STORAGE_STATE.free });

test.describe("Free student", () => {
  test("lands on the dashboard with subject cards", async ({ page }) => {
    await page.goto("/dashboard");
    await expect(page).toHaveURL(/\/dashboard/);
    // At least one subject "path" card links to a subject page.
    await expect(page.locator('a[href^="/subject/"]').first()).toBeVisible({ timeout: 15_000 });
  });

  test("sees the daily objective widget (not stuck empty)", async ({ page }) => {
    await page.goto("/dashboard");
    // The daily goal row should render a progress like "x/3" once goals are ensured.
    await expect(page.getByText(/\/\s*3/).first()).toBeVisible({ timeout: 15_000 });
  });

  test("hitting a premium (difficulty 3+) mission shows the paywall + beta CTA", async ({
    page,
  }) => {
    await page.goto("/dashboard");
    await page.locator('a[href^="/subject/"]').first().click();
    await expect(page).toHaveURL(/\/subject\//);

    // A difficulty 3+ exercise shows the "Abonnement requis" lock for free users.
    const premiumExercise = page
      .locator('a[href^="/quest/"]')
      .filter({ hasText: /requis/i })
      .first();
    await premiumExercise.click();

    // The quest page renders the subscription paywall (plan prices + free beta CTA).
    await expect(page.getByText(/premium/i).first()).toBeVisible({ timeout: 15_000 });
    await expect(page.getByRole("button", { name: /bêta|beta/i })).toBeVisible();
  });
});
