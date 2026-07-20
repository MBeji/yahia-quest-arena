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

  test("a non-school family subject lists its missions", async ({ subject, adminDb }) => {
    const cultureId = await adminDb.subjectIdByTheme("culture-generale");
    expect(
      cultureId,
      `culture-generale subject missing — run \`npm run e2e:seed-content\``,
    ).toBeTruthy();

    await subject.goto(cultureId as string);
    // The hub lists the subject's missions. That non-school missions have NO quiz
    // gate is asserted server-side in quiz-gate.spec ("non-school opens directly");
    // the Référence hub itself shows no visual lock (that gameplay layer is L2).
    await expect(subject.missionLinks.first()).toBeVisible({ timeout: 15_000 });
  });
});
