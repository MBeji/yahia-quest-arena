import { test, expect } from "../fixtures";
import { TEST_USERS } from "../helpers/users";

// Login negative paths against the real (TEST) backend. Logged-out: override the
// project storage state to an empty session.
test.use({ storageState: { cookies: [], origins: [] } });

test.describe("Auth — login error paths", () => {
  test.describe.configure({ timeout: 90_000 }); // attemptLogin retries the SSR-hydration submit

  test("rejects wrong credentials and stays on /auth", async ({ auth, page }) => {
    await auth.attemptLogin(TEST_USERS.free.email, "DefinitelyWrongPassword123");
    await expect(page.getByText(/incorrect|invalid/i).first()).toBeVisible();
    await expect(page).toHaveURL(/\/auth/);
  });

  test("enforces the 8-character password minimum (client-side)", async ({ auth, page }) => {
    await auth.goto("login");
    // Re-fill each attempt so a pre-hydration native submit (which clears fields)
    // can't make this flaky; once hydrated the inline validation fires with no POST.
    await expect(async () => {
      await auth.email.fill("tester@example.com");
      await auth.password.fill("123");
      await auth.submit.click();
      await expect(page.getByText(/8 caract|8 char/i).first()).toBeVisible({ timeout: 2000 });
    }).toPass({ timeout: 25_000 });
  });
});
