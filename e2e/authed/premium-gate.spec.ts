import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

// Premium access model (per-parcours entitlements): a PREMIUM concours parcours is
// gated behind a live entitlement. The free preview (the chapter comprehension quiz
// + every difficulty-1 mission) is open to everyone; a difficulty>=2 mission is
// locked without an entitlement and enforced server-side by resolve_exercise_access.
//
// We probe a difficulty>=2 mission of a PREMIUM concours parcours (e.g. concours-9eme)
// so the ONLY gate in play is the entitlement. The two seeded students differ only
// by their entitlement state (seed grants the premium student both concours parcours,
// the free student none); we assert that precondition via adminDb.hasEntitlement and
// then the resulting UI, without mutating shared state (reset does not clear grants).

test.describe("Per-parcours premium gate — student WITHOUT an entitlement is locked out", () => {
  test.use({ storageState: STORAGE_STATE.free });

  test("a premium-parcours mission shows the lock and the quest shows the paywall", async ({
    subject,
    quest,
    adminDb,
  }) => {
    const { id: parcoursId } = await adminDb.premiumConcoursParcours();
    const freeUserId = await adminDb.userIdByEmail(TEST_USERS.free.email);
    // Precondition: the free student holds NO entitlement on this premium parcours.
    expect(await adminDb.hasEntitlement(freeUserId, parcoursId)).toBe(false);

    const { exerciseId, subjectId } = await adminDb.premiumParcoursExercise();

    // On the subject page, the gated (difficulty>=2) mission shows the lock badge.
    await subject.goto(subjectId);
    await expect(subject.premiumLock.first()).toBeVisible({ timeout: 15_000 });

    // Opening it directly is rejected server-side → the in-quest "Parcours premium"
    // paywall renders.
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
