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
