import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Logging out clears the session and the auth guard bounces back to /auth. Driven
// from the lighter leaderboard page (same nav banner) to avoid the dashboard's 3D
// radar WebGL stalls.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Logout", () => {
  test.describe.configure({ timeout: 60_000 });

  test("signing out returns to the auth screen", async ({ leaderboard, page }) => {
    await leaderboard.goto();
    // FR default (GAP-010) labels it "Déconnexion"; EN "Sign out".
    const signOut = page.getByRole("banner").getByRole("button", { name: /sign out|déconnexion/i });
    // Retry to beat the hydration window (the sign-out handler must be attached).
    await expect(async () => {
      await signOut.click();
      await expect(page).toHaveURL(/\/auth/, { timeout: 3000 });
    }).toPass({ timeout: 30_000 });
  });
});

// Regression net: the admin role has the MOST nav links (dashboard, parcours,
// themes, dungeon, ranking, admin, subscriptions, beta, content-reports). Those
// links live in a horizontally-scrollable nav with a hidden scrollbar; the
// account actions (language, theme, SIGN-OUT) must stay pinned OUTSIDE it, or
// sign-out scrolls off the right edge and becomes unreachable (it did). We assert
// the button is actually within the viewport, not merely present — toBeInViewport
// fails when it overflows off-screen, which a plain toBeVisible would not catch.
test.describe("Logout — sign-out stays reachable with the full admin nav", () => {
  test.use({ storageState: STORAGE_STATE.admin });
  test.describe.configure({ timeout: 60_000 });

  test("the sign-out button is within the viewport despite the admin nav width", async ({
    leaderboard,
    page,
  }) => {
    await leaderboard.goto();
    const signOut = page.getByRole("banner").getByRole("button", { name: /sign out|déconnexion/i });
    await expect(signOut).toBeVisible();
    await expect(signOut).toBeInViewport();
  });
});
