import { test, expect } from "../fixtures";

/**
 * Auth boundary — PUBLIC tier (works with dummy Supabase env: getSession()
 * resolves to "no session" from empty local storage, and the public content
 * routes are `useQuery`-based so the `_public` shell still renders even when the
 * dummy backend can't return data).
 *
 * This guards the heart of the C8 pivot: **account surfaces stay behind the
 * login wall, but content surfaces never redirect to login**. If a content route
 * is accidentally moved back under `_authenticated` (or given a `beforeLoad`
 * redirect), the "public content" cases below fail.
 */

// Surfaces intrinsically tied to the account — must still require login.
const GUARDED_ROUTES = ["/dashboard", "/dungeon", "/leaderboard", "/onboarding"];

// Content surfaces opened to anonymous visitors by the pivot. The param values
// need not resolve here (the dummy backend returns nothing) — we only assert the
// public shell rendered and we were NOT bounced to /auth. The real end-to-end
// render is covered by the public-anon tier.
const PUBLIC_CONTENT_ROUTES = [
  "/programme",
  "/extras",
  "/niveau/ecole-1ere-base",
  "/matiere/francais-a1",
  "/chapitre/some-chapter",
  "/exercice/some-exercise",
];

test.describe("Account routes stay behind the login wall", () => {
  for (const path of GUARDED_ROUTES) {
    test(`${path} redirects a logged-out visitor to /auth`, async ({ page }) => {
      await page.goto(path);
      await expect(page).toHaveURL(/\/auth/, { timeout: 15_000 });
    });
  }
});

test.describe("Content routes are public — no login wall (C8 pivot)", () => {
  for (const path of PUBLIC_CONTENT_ROUTES) {
    test(`${path} renders the public shell without redirecting to /auth`, async ({ page }) => {
      await page.goto(path);
      // The account CTA lives only in the PublicHeader — absent from the
      // authenticated shell. Unlike the catalogue nav (hidden < sm), it is visible
      // at EVERY viewport (so this holds on the public-mobile project too). Its
      // presence, together with the not-/auth check, proves we are on the public
      // (`_public`) coquille and were not bounced to login — and it would unmount
      // on a post-hydration guard redirect.
      await expect(page.locator('header a[href="/signup"]')).toBeVisible({ timeout: 15_000 });
      await expect(page).not.toHaveURL(/\/auth/);
    });
  }
});

test.describe("Auth page", () => {
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
