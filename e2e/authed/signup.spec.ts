import { test, expect } from "../fixtures";

// Signup happy-path. Creates a real (throwaway) auth user in the TEST project via
// the UI, then deletes it in afterEach. Logged-out session.
test.use({ storageState: { cookies: [], origins: [] } });

test.describe("Signup", () => {
  test.describe.configure({ timeout: 90_000 });

  let createdEmail = "";

  test.afterEach(async ({ adminDb }) => {
    if (createdEmail) {
      await adminDb.deleteUserByEmail(createdEmail).catch(() => {});
      createdEmail = "";
    }
  });

  test("a new account can be created", async ({ auth, page, adminDb }) => {
    // UI signup needs the project to auto-confirm (or have working SMTP). Test
    // projects with confirmation on but no mailer can't complete it → skip cleanly.
    test.skip(
      !(await adminDb.authAutoconfirm()),
      "Project requires email confirmation without autoconfirm/SMTP — UI signup happy-path can't complete here.",
    );

    // @example.com (RFC-reserved) is format-valid for Supabase; the .test TLD used
    // by the seeded accounts is rejected by UI signup (those bypass via admin API).
    createdEmail = `e2e-signup-${Date.now()}@example.com`;
    await auth.attemptSignup("E2E Signup Hero", createdEmail, "E2e-Signup-Pass1");

    // Auto-confirm → session → dashboard.
    await expect(page).toHaveURL(/\/dashboard/, { timeout: 20_000 });
  });
});
