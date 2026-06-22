import { test, expect } from "../fixtures";

/**
 * Landing page — public, no backend/auth (the `/` route renders a static
 * <PublicLanding/>, no Supabase call). A reliable SSR + hydration smoke test of
 * the C8 pivot: the « Référence » register entry (family promise, 3 persona
 * doors, 3-parcours preview, free proof, one secondary "apprends en jouant"
 * block). Selectors are locale-independent (brand, hrefs, data-testids).
 */
test.describe("Landing page (Référence register)", () => {
  test("leads with the free family promise, persona doors and the 3 parcours", async ({
    page,
    landing,
  }) => {
    await landing.goto();

    await expect(page).toHaveTitle(/Na9ra Nal3ab/i);
    await expect(landing.brand).toBeVisible();
    await expect(landing.heroTitle).toBeVisible();
    // The account CTA is an invitation (play/XP), never a wall — always present.
    await expect(landing.signupCta).toBeVisible();
    // Both catalogue entries (official programme + optional extras).
    await expect(landing.programmeCta).toBeVisible();
    await expect(landing.extrasCta).toBeVisible();
    // The 3 persona doors and the 3 parcours-cycle cards.
    await expect(landing.personaDoors).toHaveCount(3);
    await expect(landing.cycleCards).toHaveCount(3);
    // The single Jeu (RPG) block — the only place the game register surfaces.
    await expect(landing.gameBlock).toBeAttached();
  });

  test("the login link is present in the public header", async ({ landing }) => {
    await landing.goto();
    // Hidden on mobile by CSS (sm:inline-block) but always in the DOM, so assert
    // attachment rather than visibility to stay viewport-agnostic.
    await expect(landing.loginCta).toBeAttached();
  });

  test("navigates to signup from the header account CTA", async ({ page, landing }) => {
    await landing.goto();
    await landing.signupCta.click();
    // `/signup` is a thin redirect route to the auth page in signup mode.
    await expect(page).toHaveURL(/\/auth\?mode=signup/);
  });
});
