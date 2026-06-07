import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

// Parent ↔ student linking happy-path: a parent associates a student with their
// alliance code (the student's user id, formatted) and the student then appears
// in the parent's view. The link write is a SECURITY DEFINER RPC; we only drive
// the real UI here.
test.use({ storageState: STORAGE_STATE.parent });

/** Mirror of formatStudentAllianceCode: uuid → HEX, grouped in 4s. */
function allianceCode(userId: string): string {
  return (
    userId
      .replace(/-/g, "")
      .toUpperCase()
      .match(/.{1,4}/g)
      ?.join("-") ?? ""
  );
}

test.describe("Parent ↔ student linking", () => {
  test.describe.configure({ timeout: 60_000 });

  test("a parent links a student via their alliance code", async ({ parentReport, adminDb }) => {
    const parentId = await adminDb.userIdByEmail(TEST_USERS.parent.email);
    const studentId = await adminDb.userIdByEmail(TEST_USERS.free.email);
    // Links persist across runs (not in the gameplay reset) → start clean.
    await adminDb.clearParentLinks(parentId);

    await parentReport.goto();
    await parentReport.link(allianceCode(studentId));

    // The seeded free account ("Free Student") now shows in the parent's list.
    await expect(parentReport.student("Free Student").first()).toBeVisible({ timeout: 15_000 });
  });
});
