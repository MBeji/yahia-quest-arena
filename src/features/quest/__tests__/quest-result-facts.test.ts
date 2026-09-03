import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("@/shared/lib/product-events", () => ({ trackProductEvent: vi.fn() }));
import { trackProductEvent } from "@/shared/lib/product-events";

import {
  levelCrossedBy,
  emitQuestResultTelemetry,
  type FinishedQuest,
} from "../quest-result-facts";

/**
 * Étude 31 lot 1 — les faits d'une quête terminée.
 *
 * Deux propriétés valent d'être tenues ici plutôt que derrière le rendu complet
 * du lecteur :
 *
 *   1. ⭐ LE PALIER NE SE DÉCLENCHE PAS SUR UN REJEU. Sur un résultat relu, le
 *      profil rendu est l'ACTUEL — il a pu gagner de l'XP entre-temps — donc la
 *      soustraction `xp - xpEarned` ne désigne plus le niveau d'avant. La
 *      célébration tomberait au hasard, et l'événement `level_up` compterait des
 *      montées qui n'ont pas eu lieu.
 *   2. ⭐ LA QUÊTE ANONYME COMPTE QUAND MÊME. Le visiteur sans compte est celui
 *      que US-10 cherche à convertir : l'effacer du funnel ferait trouver la
 *      conversion excellente.
 */

function quest(over: Partial<FinishedQuest> = {}): FinishedQuest {
  return {
    scorePct: 80,
    xpEarned: 50,
    replayed: false,
    profile: { level: 3, xp: 410 },
    unlockedBadges: [],
    ...over,
  };
}

describe("levelCrossedBy", () => {
  it("rend le niveau atteint quand la tentative fait franchir un palier", () => {
    // 410 XP → niveau 3 (200 XP par palier) ; sans les 50 XP de cette
    // tentative, 360 → niveau 2. C'est donc bien ELLE qui a fait monter.
    expect(levelCrossedBy(quest(), true)).toBe(3);
  });

  it("rend null quand le palier était déjà acquis avant la tentative", () => {
    expect(
      levelCrossedBy(quest({ xpEarned: 10, profile: { level: 3, xp: 450 } }), true),
    ).toBeNull();
  });

  it("⭐ rend null sur un REJEU — le profil relu ne dit plus rien du niveau d'avant", () => {
    expect(levelCrossedBy(quest({ replayed: true }), true)).toBeNull();
  });

  it("rend null pour le registre anonyme, qui ne gagne pas d'XP", () => {
    expect(levelCrossedBy(quest({ profile: null }), false)).toBeNull();
  });

  it("rend null quand la tentative n'a rapporté aucun XP", () => {
    expect(levelCrossedBy(quest({ xpEarned: 0 }), true)).toBeNull();
  });
});

describe("emitQuestResultTelemetry", () => {
  beforeEach(() => vi.mocked(trackProductEvent).mockClear());

  it("⭐ émet la quête terminée même sans compte, en le disant", () => {
    emitQuestResultTelemetry({
      result: quest({ profile: null, xpEarned: 0 }),
      subjectId: "math-9eme",
      variant: "classic",
      isQuiz: false,
      rewarded: false,
      passed: true,
      leveledUpTo: null,
    });
    expect(trackProductEvent).toHaveBeenCalledTimes(1);
    expect(trackProductEvent).toHaveBeenCalledWith(
      "quest_completed",
      expect.objectContaining({ anonymous: true, subject_id: "math-9eme", passed: true }),
    );
  });

  it("émet un badge par badge débloqué, et le palier une seule fois", () => {
    emitQuestResultTelemetry({
      result: quest({ unlockedBadges: [{ code: "first_quest" }, { code: "perfect_score" }] }),
      subjectId: "math-9eme",
      variant: "classic",
      isQuiz: false,
      rewarded: true,
      passed: true,
      leveledUpTo: 3,
    });
    expect(trackProductEvent).toHaveBeenCalledWith("badge_earned", {
      badge_code: "first_quest",
      source: "quest",
    });
    expect(trackProductEvent).toHaveBeenCalledWith("badge_earned", {
      badge_code: "perfect_score",
      source: "quest",
    });
    expect(trackProductEvent).toHaveBeenCalledWith("level_up", { level: 3 });
    expect(trackProductEvent).toHaveBeenCalledTimes(4);
  });

  it("n'émet ni badge ni palier pour le registre anonyme (il n'en a pas)", () => {
    emitQuestResultTelemetry({
      result: quest({ unlockedBadges: [{ code: "first_quest" }] }),
      subjectId: null,
      variant: "recall",
      isQuiz: false,
      rewarded: false,
      passed: false,
      leveledUpTo: 3,
    });
    expect(trackProductEvent).toHaveBeenCalledTimes(1);
  });
});
