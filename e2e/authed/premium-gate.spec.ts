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

/**
 * L'INVARIANT DE LA PHASE GRATUITE, PRIS À SA CAUSE.
 *
 * Les deux tests d'interface ci-dessous portaient chacun un
 * `expect(quest.paywallPremiumText).toHaveCount(0)`. Ce négatif était ORPHELIN
 * (issue #733) et il ne pouvait pas cesser de l'être : `SubscriptionPaywall` ne se
 * monte que sur un refus de `resolve_exercise_access`, refus qu'AUCUN compte ne
 * peut provoquer tant qu'aucun parcours n'est premium. Écrire le positif apparié
 * aurait demandé de basculer `parcours.is_premium` — un drapeau de catalogue
 * GLOBAL que les specs voisines lisent au même moment (`fullyParallel`), et qu'un
 * échec en cours de route laisserait levé pour tout le reste de la suite.
 *
 * Alors on mesure la cause au lieu de l'absence de sa conséquence. Celle-ci est
 * falsifiable : une seule ligne repassée à `is_premium = true` fait rougir ce
 * test — et c'est très exactement le seul changement capable de ressusciter le
 * paywall. Il nomme au passage le parcours fautif, ce qu'un `toHaveCount(0)` sur
 * un mot traduit ne faisait pas.
 */
test.describe("Phase gratuite — l'invariant à sa source", () => {
  test("aucun parcours n'est premium", async ({ adminDb }) => {
    expect(await adminDb.premiumParcoursIds()).toEqual([]);
  });
});

test.describe("Phase gratuite — student WITHOUT an entitlement", () => {
  test.use({ storageState: STORAGE_STATE.free });

  test("a difficulty>=2 concours mission opens without any paywall", async ({ quest, adminDb }) => {
    const { exerciseId } = await adminDb.premiumParcoursExercise();

    await quest.goto(exerciseId);
    // The session resolves to a real state: the QCM options OR — concours
    // parcours are SCHOOL subjects — the chapter comprehension quiz-lock (a
    // SEPARATE, pedagogical gate). Ni l'un ni l'autre n'est le paywall, dont
    // l'absence est acquise en amont par le test d'invariant ci-dessus.
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
  });
});

test.describe("Phase gratuite — student WITH a (dormant) entitlement", () => {
  test.use({ storageState: STORAGE_STATE.premium });

  test("the same mission opens identically", async ({ quest, adminDb }) => {
    const { exerciseId } = await adminDb.premiumParcoursExercise();

    await quest.goto(exerciseId);
    await expect(quest.options.first().or(quest.quizLock)).toBeVisible({ timeout: 20_000 });
  });
});
