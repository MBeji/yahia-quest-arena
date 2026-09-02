// @vitest-environment node
import { describe, expect, it } from "vitest";

import { streakRecoveryBlock } from "@/shared/lib/streak-recovery";

/**
 * LE RACHAT DE SÉRIE A UNE PORTE ATTEIGNABLE.
 *
 * Ce fichier garde une fonctionnalité qui a été MURÉE sans que rien ne rougisse :
 * le serveur lisait un `last_active_date` périmé, le client testait
 * `current_streak === 0` — une valeur qu'`award_xp` n'écrit jamais. Chaque
 * moitié était juste de son côté, la fonctionnalité n'existait pas.
 *
 * Aucun test ne pouvait l'attraper tant que la condition vivait à deux endroits :
 * c'est le fait qu'elle soit désormais UNE qui rend ces assertions possibles.
 */
const LE_2_SEPTEMBRE = new Date("2026-09-02T10:00:00Z");

describe("streakRecoveryBlock — la porte du rachat de série", () => {
  it("ouvre quand la dernière activité est plus vieille qu'hier", () => {
    expect(
      streakRecoveryBlock({ last_active_date: "2026-08-28", longest_streak: 12 }, LE_2_SEPTEMBRE),
    ).toBeNull();
  });

  it("refuse une série encore vivante — hier compte comme vivante", () => {
    expect(
      streakRecoveryBlock({ last_active_date: "2026-09-01", longest_streak: 12 }, LE_2_SEPTEMBRE),
    ).toBe("streak-actif");
    expect(
      streakRecoveryBlock({ last_active_date: "2026-09-02", longest_streak: 12 }, LE_2_SEPTEMBRE),
    ).toBe("streak-actif");
  });

  it("refuse un élève qui n'a jamais eu de série", () => {
    expect(streakRecoveryBlock({ last_active_date: null, longest_streak: 0 }, LE_2_SEPTEMBRE)).toBe(
      "aucun-streak",
    );
    expect(
      streakRecoveryBlock({ last_active_date: null, longest_streak: null }, LE_2_SEPTEMBRE),
    ).toBe("aucun-streak");
  });

  it("ouvre pour un élève qui n'a jamais rien fait depuis mais a eu une série", () => {
    expect(
      streakRecoveryBlock({ last_active_date: null, longest_streak: 5 }, LE_2_SEPTEMBRE),
    ).toBeNull();
  });

  it("NE DÉPEND PAS de current_streak — c'était la porte morte", () => {
    // `award_xp` ne persiste jamais 0 : ses branches donnent 1, `current` ou
    // `current + 1`. Un profil réel de série cassée porte donc `current_streak`
    // ≥ 1 ET un `last_active_date` périmé. L'ancien garde client exigeait 0 :
    // il ne s'ouvrait pour personne.
    const profilReelDeSerieCassee = {
      last_active_date: "2026-08-20",
      longest_streak: 9,
      // présent dans le vrai profil, et volontairement ignoré par la porte
      current_streak: 3,
    };
    expect(streakRecoveryBlock(profilReelDeSerieCassee, LE_2_SEPTEMBRE)).toBeNull();
  });

  it("l'ordre des refus est stable : une série vivante l'emporte sur l'absence de série", () => {
    // Un profil incohérent (actif aujourd'hui, aucune série jamais atteinte) ne
    // doit pas rendre « aucun-streak » : le serveur en tirerait le mauvais
    // message. Le test épingle l'ordre, pas seulement l'ensemble des cas.
    expect(
      streakRecoveryBlock({ last_active_date: "2026-09-02", longest_streak: 0 }, LE_2_SEPTEMBRE),
    ).toBe("streak-actif");
  });
});
