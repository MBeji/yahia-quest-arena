import { test, expect } from "../fixtures";

// Auth form rendering + login↔signup toggle (no submit → no backend needed, runs
// on the public tier). Signup exposes the hero-name field; login does not.
// The app's default locale is FRENCH (GAP-010); assertions accept FR (default)
// and tolerate EN, like the page object's toggleModeLink.
test.describe("Auth page", () => {
  test("renders login and toggles to signup and back", async ({ auth, page }) => {
    await auth.goto("login");
    await expect(auth.heading).toHaveText(/bon retour, guerrier|welcome back, warrior/i);
    await expect(auth.submit).toHaveText(/entrer dans l['’]arène|enter the arena/i);
    await expect(auth.nameField).toHaveCount(0);

    await auth.toggleModeLink.click();
    await expect(page).toHaveURL(/mode=signup/);
    await expect(auth.heading).toHaveText(/forge (ton héros|your hero)/i);
    await expect(auth.nameField).toBeVisible();
    await expect(auth.submit).toHaveText(/forger mon héros|forge my hero/i);

    await auth.toggleModeLink.click();
    await expect(page).toHaveURL(/mode=login/);
    await expect(auth.heading).toHaveText(/bon retour, guerrier|welcome back, warrior/i);
  });
});
