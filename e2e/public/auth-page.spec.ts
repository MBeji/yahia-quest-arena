import { test, expect } from "../fixtures";

// Auth form rendering + login↔signup toggle (no submit → no backend needed, runs
// on the public tier). Signup exposes the hero-name field; login does not.
test.describe("Auth page", () => {
  test("renders login and toggles to signup and back", async ({ auth, page }) => {
    await auth.goto("login");
    await expect(auth.heading).toHaveText(/welcome back/i);
    await expect(auth.submit).toHaveText(/enter the arena/i);
    await expect(auth.nameField).toHaveCount(0);

    await auth.toggleModeLink.click();
    await expect(page).toHaveURL(/mode=signup/);
    await expect(auth.heading).toHaveText(/forge your hero/i);
    await expect(auth.nameField).toBeVisible();
    await expect(auth.submit).toHaveText(/forge my hero/i);

    await auth.toggleModeLink.click();
    await expect(page).toHaveURL(/mode=login/);
    await expect(auth.heading).toHaveText(/welcome back/i);
  });
});
