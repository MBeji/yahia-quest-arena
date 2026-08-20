import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

/**
 * "PREMIUM" student journey. The student still holds a live (now DORMANT)
 * entitlement on both Concours parcours — phase gratuite (étude 15, lot 2):
 * every parcours is free, so the paywall must not appear for anyone; this spec
 * keeps the entitled account exercised so étude 01 can re-differentiate later.
 *
 * Ce spec portait deux `toHaveCount(0)` de plus — `quest.paywallPremiumText` et
 * `quest.betaCta` — supprimés avec leurs getters (issue #733). Aucun des deux ne
 * pouvait rougir : le paywall ne se monte que sur un refus de
 * `resolve_exercise_access` que la phase gratuite rend impossible, et le CTA
 * « bêta testeur » vit À L'INTÉRIEUR de ce paywall. `betaCta` cumulait d'ailleurs
 * le second défaut que le README interdit : il visait un libellé TRADUIT
 * (`t.betaAccess.cta`) et ne désignait déjà personne en arabe, où le mot rendu est
 * « تجريبي ». Ce qu'ils prétendaient couvrir l'est pour de bon ailleurs :
 * l'invariant de la phase gratuite dans `premium-gate.spec.ts` (pris à sa cause,
 * donc falsifiable), et le paywall lui-même au palier unitaire, APPARIÉ —
 * `beta-access-request.test.tsx` exige le CTA présent quand aucune demande
 * n'existe, et absent sinon.
 */
test.use({ storageState: STORAGE_STATE.premium });

test.describe("Premium student", () => {
  test("dashboard loads", async ({ page, dashboard }) => {
    await dashboard.goto();
    await expect(page).toHaveURL(/\/dashboard/);
    await expect(dashboard.firstSubject()).toBeVisible({ timeout: 15_000 });
  });

  test("the live entitlement opens a premium-parcours mission", async ({ quest, adminDb }) => {
    const { id: parcoursId } = await adminDb.premiumConcoursParcours();
    const premiumUserId = await adminDb.userIdByEmail(TEST_USERS.premium.email);
    // The premium student's seeded entitlement is live.
    expect(await adminDb.hasEntitlement(premiumUserId, parcoursId)).toBe(true);

    // A difficulty>=2 mission of the premium parcours (outside the free preview).
    const { exerciseId } = await adminDb.premiumParcoursExercise();
    await quest.goto(exerciseId);

    // The entitlement gate is passed → the session resolves to the QCM or, since
    // concours parcours are SCHOOL subjects, the chapter quiz-lock (a separate gate).
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
  });
});
