// @vitest-environment node
import { describe, expect, it } from "vitest";

/**
 * LA BIBLIOTHÈQUE DE COACHING — étude 11 lot 2, R-10.
 *
 * Ce que ce fichier garde, ce n'est pas la beauté des phrases : c'est le fait
 * qu'aucune d'elles ne coûte un token, et qu'elles ne changent pas sous les
 * doigts de l'élève. Deux propriétés, et elles se testent :
 *
 *   1. le choix est DÉTERMINISTE — le même plan rendu deux fois dit la même
 *      chose. Une phrase de coach qui tourne à chaque re-rendu donne l'impression
 *      d'un écran qui bavarde, et rend le test suivant impossible à écrire ;
 *   2. la PRIORITÉ est celle de l'étude — une erreur active passe avant le
 *      retard, parce que c'est la seule des deux raisons qu'un enfant reconnaît.
 */

import {
  dayIndexOf,
  daysAwayFrom,
  momentKey,
  momentKind,
  planCoachKey,
  planCoachKind,
} from "../coaching";
import type { DailyPlanItem } from "@/shared/types/daily-plan";

function item(over: Partial<DailyPlanItem> = {}): DailyPlanItem {
  return {
    exercise_id: "e1",
    chapter_id: "c1",
    subject_id: "math",
    exercise_title: "Fractions",
    chapter_title: "Fractions",
    days_overdue: 0,
    weak_tags: 0,
    is_fallback: false,
    ...over,
  };
}

describe("le registre d'un item du plan", () => {
  it("nomme l'ERREUR avant le retard — c'est la raison que l'élève reconnaît", () => {
    // Douze jours de retard ET une erreur active : c'est l'erreur qui gagne.
    expect(planCoachKind(item({ days_overdue: 12, weak_tags: 2 }))).toBe("weak");
  });

  it("distingue « ça part » de « à revoir » à sept jours", () => {
    expect(planCoachKind(item({ days_overdue: 7 }))).toBe("late");
    expect(planCoachKind(item({ days_overdue: 6 }))).toBe("due");
  });

  it("une échéance du jour n'est pas un retard", () => {
    expect(planCoachKind(item({ days_overdue: 0 }))).toBe("today");
    // Une échéance à venir passe par le même registre : rien à reprocher.
    expect(planCoachKind(item({ days_overdue: -2 }))).toBe("today");
  });

  it("trois items d'affilée ne disent pas tous la même phrase", () => {
    const keys = [0, 1, 2].map((i) => planCoachKey(item({ days_overdue: 3 }), i));
    expect(new Set(keys).size).toBeGreaterThan(1);
  });

  it("le même item, à la même place, dit toujours la même chose", () => {
    // La garantie qui interdit à l'écran de bavarder au re-rendu.
    expect(planCoachKey(item({ days_overdue: 3 }), 1)).toBe(
      planCoachKey(item({ days_overdue: 3 }), 1),
    );
  });
});

describe("le moment à saluer (US-15)", () => {
  it("un retour après plusieurs jours passe avant tout le reste", () => {
    expect(momentKind({ daysAway: 5, streakDays: 9, planEmpty: true })).toBe("comeback");
  });

  it("une série ne se nomme qu'à partir de trois jours", () => {
    expect(momentKind({ daysAway: 0, streakDays: 3, planEmpty: false })).toBe("streak");
    expect(momentKind({ daysAway: 0, streakDays: 2, planEmpty: false })).toBe("steady");
  });

  it("un plan vide est une bonne nouvelle, pas un écran vide", () => {
    expect(momentKind({ daysAway: 0, streakDays: 0, planEmpty: true })).toBe("clear");
  });

  it("l'état neutre existe — un écran sans exploit accueille quand même", () => {
    expect(momentKind({ daysAway: 0, streakDays: 0, planEmpty: false })).toBe("steady");
  });

  it("deux visites le même jour disent la même phrase", () => {
    const state = { daysAway: 0, streakDays: 5, planEmpty: false };
    const morning = dayIndexOf(new Date("2026-08-23T07:00:00Z"));
    const evening = dayIndexOf(new Date("2026-08-23T20:00:00Z"));
    expect(morning).toBe(evening);
    expect(momentKey(state, morning)).toBe(momentKey(state, evening));
  });
});

describe("les jours d'absence", () => {
  it("se comptent sur les dates civiles, pas sur les heures", () => {
    expect(daysAwayFrom("2026-08-20", "2026-08-23")).toBe(3);
    expect(daysAwayFrom("2026-08-23", "2026-08-23")).toBe(0);
  });

  it("un compte qui n'a jamais joué n'est pas un absent", () => {
    // Sinon un nouveau venu serait accueilli par « ça faisait longtemps ».
    expect(daysAwayFrom(null, "2026-08-23")).toBe(0);
  });

  it("une date illisible ne fabrique pas une absence", () => {
    expect(daysAwayFrom("pas-une-date", "2026-08-23")).toBe(0);
  });
});
