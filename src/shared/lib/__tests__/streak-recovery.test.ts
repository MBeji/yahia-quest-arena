// @vitest-environment node
import { describe, expect, it } from "vitest";

import { STREAK_RECOVERY_WINDOW_DAYS } from "@/shared/constants/gamification";
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
/** Actif avant-hier : un seul jour manqué (hier). Le cas nominal du rachat. */
const AVANT_HIER = "2026-08-31";
/** Actif il y a 3 jours : deux jours manqués — le DERNIER jour encore rachetable. */
const BORD_OUVERT = "2026-08-30";
/** Actif il y a 4 jours : trois jours manqués — un de trop. */
const BORD_FERME = "2026-08-29";

describe("streakRecoveryBlock — la porte du rachat de série", () => {
  it("ouvre quand la dernière activité est plus vieille qu'hier, DANS la fenêtre", () => {
    expect(
      streakRecoveryBlock({ last_active_date: AVANT_HIER, longest_streak: 12 }, LE_2_SEPTEMBRE),
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

  it("refuse une date ABSENTE, même avec une série au palmarès", () => {
    // Ce cas OUVRAIT le rachat avant le 2026-09-03, et c'était le trou : sans date,
    // rien ne dit depuis quand la série est perdue — donc rien ne prouve qu'on est
    // dans la fenêtre. `award_xp` ne produit d'ailleurs pas ce profil (il écrit
    // `last_active_date` en même temps que la série) ; on ne devine pas une date
    // pour autoriser une dépense de pièces.
    expect(streakRecoveryBlock({ last_active_date: null, longest_streak: 5 }, LE_2_SEPTEMBRE)).toBe(
      "fenetre-expiree",
    );
  });

  it(`⭐ ferme au-delà de ${STREAK_RECOVERY_WINDOW_DAYS} jours manqués — les DEUX bords`, () => {
    // C'est l'écart remonté par le lot 3 de é31 : la porte ne regardait que
    // « périmé ou non ». Un élève parti dix jours rachetait la série qu'il avait
    // perdue neuf jours plus tôt, ce que R-16 ne suppose nulle part.
    expect(
      streakRecoveryBlock({ last_active_date: BORD_OUVERT, longest_streak: 12 }, LE_2_SEPTEMBRE),
    ).toBeNull();
    expect(
      streakRecoveryBlock({ last_active_date: BORD_FERME, longest_streak: 12 }, LE_2_SEPTEMBRE),
    ).toBe("fenetre-expiree");
    // Et loin derrière, sans ambiguïté.
    expect(
      streakRecoveryBlock({ last_active_date: "2026-08-20", longest_streak: 9 }, LE_2_SEPTEMBRE),
    ).toBe("fenetre-expiree");
  });

  it("la fenêtre est calculée, pas écrite en dur — elle suit la constante", () => {
    // Un bord codé en dur passerait ce fichier et mentirait le jour où la valeur
    // change. On rejoue la borne depuis la constante elle-même.
    const dernierJourOuvert = new Date(LE_2_SEPTEMBRE);
    dernierJourOuvert.setUTCDate(
      dernierJourOuvert.getUTCDate() - (STREAK_RECOVERY_WINDOW_DAYS + 1),
    );
    const premierJourFerme = new Date(LE_2_SEPTEMBRE);
    premierJourFerme.setUTCDate(premierJourFerme.getUTCDate() - (STREAK_RECOVERY_WINDOW_DAYS + 2));
    expect(
      streakRecoveryBlock(
        { last_active_date: dernierJourOuvert.toISOString().slice(0, 10), longest_streak: 4 },
        LE_2_SEPTEMBRE,
      ),
    ).toBeNull();
    expect(
      streakRecoveryBlock(
        { last_active_date: premierJourFerme.toISOString().slice(0, 10), longest_streak: 4 },
        LE_2_SEPTEMBRE,
      ),
    ).toBe("fenetre-expiree");
  });

  it("le franchissement de mois ne casse pas la borne (arithmétique UTC)", () => {
    // AVANT_HIER/BORD_* sont en août pour un « aujourd'hui » de septembre : la
    // fenêtre traverse le changement de mois, et un calcul par soustraction de
    // chaînes s'y casserait.
    expect(
      streakRecoveryBlock(
        { last_active_date: "2026-02-27", longest_streak: 6 },
        new Date("2026-03-01T10:00:00Z"),
      ),
    ).toBeNull();
  });

  it("NE DÉPEND PAS de current_streak — c'était la porte morte", () => {
    // `award_xp` ne persiste jamais 0 : ses branches donnent 1, `current` ou
    // `current + 1`. Un profil réel de série cassée porte donc `current_streak`
    // ≥ 1 ET un `last_active_date` périmé. L'ancien garde client exigeait 0 :
    // il ne s'ouvrait pour personne.
    const profilReelDeSerieCassee = {
      last_active_date: AVANT_HIER,
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
