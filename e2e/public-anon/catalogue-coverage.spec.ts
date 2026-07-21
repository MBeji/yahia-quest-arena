import { test, expect } from "../fixtures";

/**
 * Catalogue-coverage preflight — the single LOUD gate that stops a thin TEST
 * catalogue from masquerading as a green suite.
 *
 * Since étude 24 (#544) the pedagogical corpus no longer travels in migrations,
 * so `supabase db push` rebuilds only the legacy `mcq` seed. The question types
 * and non-school families the suite exercises are (re)seeded from committed
 * fixtures by `npm run e2e:seed-content` (scripts/e2e/seed-fixture-content.mjs).
 * When one is missing, the spec that covers it skips cleanly — individually
 * invisible, so the whole suite can report green while covering far less than it
 * appears to. This preflight FAILS instead, naming exactly what is missing and
 * how to fix it, so a coverage gap can never hide behind a green run.
 */
const FIX = "missing from the TEST catalogue — run `npm run e2e:seed-content`";

test.describe("Catalogue coverage (reproducible fixtures)", () => {
  test("every native question type the suite covers resolves", async ({ adminDb }) => {
    expect(await adminDb.numericExerciseId(), `numeric mission ${FIX}`).toBeTruthy();
    expect(await adminDb.boardExerciseId(), `ordering/matching mission ${FIX}`).toBeTruthy();
    expect(await adminDb.multiExerciseId(), `multi mission ${FIX}`).toBeTruthy();
    expect(await adminDb.recallReadyExercise(), `recall-eligible mission ${FIX}`).not.toBeNull();
  });

  test("the non-school families the suite covers have subjects", async ({ adminDb }) => {
    expect(
      await adminDb.subjectIdByTheme("culture-generale"),
      `culture-generale ${FIX}`,
    ).toBeTruthy();
    const slugs = await adminDb.themeSlugsWithSubjects();
    for (const family of ["culture-generale", "muscle-cerveau"]) {
      expect(slugs, `family '${family}' ${FIX}`).toContain(family);
    }
  });
});
