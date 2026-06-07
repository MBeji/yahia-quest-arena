import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The catalogue must include the four content families, and the three non-school
// families must be playable WITHOUT a mandatory theory course (no quiz gate).
//   • ecole-tn        → national school program
//   • culture-generale→ general knowledge
//   • muscle-cerveau  → IQ training
//   • francais        → language program (the seeded language track with content)
test.use({ storageState: STORAGE_STATE.free });

const REQUIRED_FAMILIES = ["ecole-tn", "culture-generale", "muscle-cerveau", "francais"];

test.describe("Content families", () => {
  test("the four families are present in the catalogue", async ({ adminDb }) => {
    const slugs = await adminDb.themeSlugsWithSubjects();
    for (const family of REQUIRED_FAMILIES) {
      expect(slugs, `family theme '${family}' missing — apply its content`).toContain(family);
    }
  });

  test("a non-school family is playable with no theory gate", async ({ subject, adminDb }) => {
    const cultureId = await adminDb.subjectIdByTheme("culture-generale");
    test.skip(!cultureId, "culture-générale content not applied to the test project.");

    await subject.goto(cultureId as string);
    // Missions are directly available…
    await expect(subject.missionLinks.first()).toBeVisible();
    // …and nothing is locked behind a comprehension quiz (non-school rule).
    await expect(subject.lockedMissions).toHaveCount(0);
  });
});
