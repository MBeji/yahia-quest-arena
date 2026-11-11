import { render, screen } from "@testing-library/react";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@/shared/lib/product-events", () => ({ trackProductEvent: vi.fn() }));
import { trackProductEvent } from "@/shared/lib/product-events";

vi.mock("@/features/dashboard/components/family-goal-card", () => ({
  FamilyGoalCard: () => null,
}));

import { DashboardGoals } from "../components/dashboard-goals";
import { resolveDailyAction } from "../dashboard-helpers";
import {
  DAILY_COMPLETE_TYPE,
  DAILY_MISSION_TYPES,
  DAILY_MISSION_XP,
  DAILY_MISSION_COINS,
  DAILY_COMPLETE_XP,
  DAILY_COMPLETE_COINS,
  DAILY_MISSIONS_PER_DAY,
} from "@/shared/constants/daily-missions";
import { fr } from "@/lib/i18n/fr";
import { en } from "@/lib/i18n/en";
import { ar } from "@/lib/i18n/ar";

/**
 * Étude 31 lot 3 — la journée, côté écran.
 *
 * Ce qui est tenu ici, c'est ce que le SQL ne peut pas garder :
 *
 *   1. ⭐ le bonus de complétion n'est PAS une quatrième mission — il est la
 *      CÉLÉBRATION DE FIN (R-6). Le rendre comme une carte ferait mentir « trois
 *      missions du jour » et noierait la seule chose qui doit se voir ;
 *   2. ⭐ cette célébration ne propose AUCUN enchaînement (« encore un ») — c'est
 *      la moitié de R-6 qu'on oublie, et celle qui coûte : une fin qui relance
 *      n'est pas une fin ;
 *   3. chaque type du pool a un libellé dans les trois langues (R-22) et mène à
 *      un écran cohérent.
 */

type Objective = {
  id: string;
  objective_type: string;
  current_value: number;
  target_value: number;
  status: string;
  xp_reward: number | null;
};

function mission(over: Partial<Objective> = {}): Objective {
  return {
    id: "m1",
    objective_type: "exercises_n",
    current_value: 0,
    target_value: 3,
    status: "active",
    xp_reward: DAILY_MISSION_XP,
    ...over,
  };
}

const THREE: Objective[] = [
  mission({ id: "m1", objective_type: "exercises_n" }),
  mission({ id: "m2", objective_type: "score_90", target_value: 1 }),
  mission({ id: "m3", objective_type: "dungeon_floors", target_value: 5 }),
];

function renderGoals(objectives: Objective[]) {
  return render(
    <DashboardGoals dailyObjectives={objectives} weeklyQuests={[]} onAction={() => {}} />,
  );
}

describe("DashboardGoals — les missions du jour", () => {
  beforeEach(() => vi.mocked(trackProductEvent).mockClear());

  it("rend les trois missions du jour", () => {
    renderGoals(THREE);
    expect(screen.getByText(fr.dashboard.objectiveTypes.exercises_n)).toBeInTheDocument();
    expect(screen.getByText(fr.dashboard.objectiveTypes.score_90)).toBeInTheDocument();
    expect(screen.getByText(fr.dashboard.objectiveTypes.dungeon_floors)).toBeInTheDocument();
  });

  it("⭐ le bonus de complétion n'apparaît PAS comme une quatrième mission", () => {
    renderGoals([
      ...THREE,
      mission({ id: "bonus", objective_type: DAILY_COMPLETE_TYPE, target_value: 3 }),
    ]);
    expect(screen.queryByText(fr.dashboard.objectiveTypes.daily_complete)).not.toBeInTheDocument();
    expect(screen.queryByTestId("daily-missions-done")).not.toBeInTheDocument();
  });

  it("⭐ fête la FIN de la journée quand le bonus est acquis, sans aucun « encore un » (R-6)", () => {
    renderGoals([
      ...THREE.map((m) => ({ ...m, status: "completed", current_value: m.target_value })),
      mission({
        id: "bonus",
        objective_type: DAILY_COMPLETE_TYPE,
        target_value: 3,
        current_value: 3,
        status: "completed",
      }),
    ]);
    const done = screen.getByTestId("daily-missions-done");
    expect(done.textContent).toContain(fr.dashboard.dailyMissionsDone);
    // La célébration ne porte aucun bouton : c'est une fin, pas un rebond.
    expect(done.querySelector("button")).toBeNull();
  });

  it("émet `daily_missions_completed` une fois la journée close", () => {
    renderGoals([
      ...THREE,
      mission({
        id: "bonus",
        objective_type: DAILY_COMPLETE_TYPE,
        target_value: 3,
        current_value: 3,
        status: "completed",
      }),
    ]);
    expect(trackProductEvent).toHaveBeenCalledWith("daily_missions_completed", { missions: 3 });
  });

  it("n'émet rien tant que la journée n'est pas finie", () => {
    renderGoals(THREE);
    expect(trackProductEvent).not.toHaveBeenCalled();
  });
});

describe("resolveDailyAction — chaque mission mène au bon écran", () => {
  it.each([
    ["dungeon_floors", "dungeon"],
    ["duel_play", "duel"],
    ["review_due", "retry"],
    ["recall_one", "retry"],
    ["chapter_step", "retry"],
    ["exercises_n", "subject"],
    ["score_90", "subject"],
    ["subject_focus", "subject"],
  ])("%s → %s", (type, expected) => {
    expect(resolveDailyAction(type)).toBe(expected);
  });
});

describe("le pool de missions, côté libellés (R-22)", () => {
  it("⭐ chaque type du pool est nommé dans les trois langues", () => {
    for (const type of [...DAILY_MISSION_TYPES, DAILY_COMPLETE_TYPE]) {
      for (const [lang, dict] of [
        ["fr", fr],
        ["en", en],
        ["ar", ar],
      ] as const) {
        const label = dict.dashboard.objectiveTypes[type];
        expect(label?.length ?? 0, `${type} / ${lang} : libellé manquant`).toBeGreaterThan(0);
      }
    }
  });

  it("⭐ l'enveloppe du jour reste celle d'avant le lot : 50 XP / 10 pièces (R-11)", () => {
    expect(DAILY_MISSION_XP * DAILY_MISSIONS_PER_DAY + DAILY_COMPLETE_XP).toBe(50);
    expect(DAILY_MISSION_COINS * DAILY_MISSIONS_PER_DAY + DAILY_COMPLETE_COINS).toBe(10);
  });

  it("⭐ la liste du code est celle que la migration tire", () => {
    const migration = readFileSync(
      join(process.cwd(), "supabase/migrations/20260902150000_daily_missions.sql"),
      "utf8",
    );
    for (const type of DAILY_MISSION_TYPES) {
      expect(migration.includes(`'${type}'`), `${type} absent du pool SQL`).toBe(true);
    }
  });
});
