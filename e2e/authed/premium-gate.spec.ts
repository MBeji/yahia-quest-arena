import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

// Per-parcours premium gate — enforced SERVER-SIDE by resolve_exercise_access.
//
// C8 note: the pivot removed the matiere hub's VISUAL premium lock ("à débloquer")
// — that's the deferred L2 gameplay layer. The gate itself is unchanged: opening a
// difficulty>=2 mission of a PREMIUM concours parcours WITHOUT an entitlement is
// rejected server-side and the in-quest "Parcours premium" paywall renders; WITH a
// live entitlement it does not. (On the TEST project the per-user entitlement model
// is real — the beta "open to all" override is a prod/beta concern, not applied
// here — so the paywall genuinely renders for the free student.)
//
// We probe a difficulty>=2 mission of a PREMIUM concours parcours so the ONLY gate
// in play is the entitlement. The two seeded students differ only by entitlement
// state (seed grants the premium student both concours parcours, the free student
// none); we assert that precondition via adminDb.hasEntitlement, then the resulting
// /quest UI, without mutating shared state (reset does not clear grants).

test.describe("Per-parcours premium gate — student WITHOUT an entitlement is paywalled", () => {
  test.use({ storageState: STORAGE_STATE.free });

  test("opening a premium-parcours mission shows the paywall", async ({ quest, adminDb }) => {
    const { id: parcoursId } = await adminDb.premiumConcoursParcours();
    const freeUserId = await adminDb.userIdByEmail(TEST_USERS.free.email);
    // Precondition: the free student holds NO entitlement on this premium parcours.
    expect(await adminDb.hasEntitlement(freeUserId, parcoursId)).toBe(false);

    const { exerciseId } = await adminDb.premiumParcoursExercise();

    // Opening it directly is rejected server-side → the in-quest "Parcours premium"
    // paywall renders (the gate runs before the chapter quiz gate).
    await quest.goto(exerciseId);
    await expect(quest.paywallPremiumText).toBeVisible({ timeout: 15_000 });
  });
});

test.describe("Per-parcours premium gate — student WITH an entitlement is unlocked", () => {
  test.use({ storageState: STORAGE_STATE.premium });

  test("the same premium-parcours mission is NOT paywalled", async ({ quest, adminDb }) => {
    const { id: parcoursId } = await adminDb.premiumConcoursParcours();
    const premiumUserId = await adminDb.userIdByEmail(TEST_USERS.premium.email);
    // Precondition: the premium student holds a live entitlement on this parcours
    // (granted by the seed via admin_grant_parcours).
    expect(await adminDb.hasEntitlement(premiumUserId, parcoursId)).toBe(true);

    const { exerciseId } = await adminDb.premiumParcoursExercise();

    await quest.goto(exerciseId);
    // The entitlement gate is passed, so the session resolves to a real state: the
    // QCM options OR — since concours parcours are SCHOOL subjects — the chapter
    // comprehension quiz-lock (a SEPARATE gate). Either way, the "Parcours premium"
    // paywall must NOT appear (that's the free-vs-entitled differentiator). Wait for
    // a definitive post-"preparing" state before asserting the paywall's absence.
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
    await expect(quest.paywallPremiumText).toHaveCount(0);
  });
});
