import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Phase gratuite (étude 15, lot 2 — arbitrage Q-2 du 2026-07-10): every parcours
// is FREE (`parcours.is_premium = false` everywhere), so resolve_exercise_access
// opens every mission and the "Parcours premium" paywall is UNREACHABLE for
// students. These specs pin that: a difficulty>=2 mission of an EX-premium
// concours parcours opens for BOTH seeded students (the free one holds no
// entitlement — entitlements are dormant infrastructure until étude 01).
//
// When étude 01 reinstates premium, restore the old locked-vs-entitled pair from
// git history (this file, pre-lot-2).

test.describe("Phase gratuite — student WITHOUT an entitlement", () => {
  test.use({ storageState: STORAGE_STATE.free });

  test("a difficulty>=2 concours mission opens without any paywall", async ({ quest, adminDb }) => {
    const { exerciseId } = await adminDb.premiumParcoursExercise();

    await quest.goto(exerciseId);
    // The session resolves to a real state: the QCM options OR — concours
    // parcours are SCHOOL subjects — the chapter comprehension quiz-lock (a
    // SEPARATE, pedagogical gate). Never the premium paywall.
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
    await expect(quest.paywallPremiumText).toHaveCount(0);
  });
});

test.describe("Phase gratuite — student WITH a (dormant) entitlement", () => {
  test.use({ storageState: STORAGE_STATE.premium });

  test("the same mission opens identically", async ({ quest, adminDb }) => {
    const { exerciseId } = await adminDb.premiumParcoursExercise();

    await quest.goto(exerciseId);
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
    await expect(quest.paywallPremiumText).toHaveCount(0);
  });
});
