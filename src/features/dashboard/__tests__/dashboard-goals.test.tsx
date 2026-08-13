import { describe, it, expect, vi } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import React from "react";

vi.mock("motion/react", () => ({
  motion: new Proxy(
    {},
    {
      get:
        (_t, prop: string) =>
        ({ children, ...props }: Record<string, unknown>) =>
          React.createElement(prop, props, children as React.ReactNode),
    },
  ),
  useReducedMotion: () => false,
}));
// La quête famille fait son propre aller-retour serveur : hors sujet ici.
vi.mock("@/features/dashboard/components/family-goal-card", () => ({
  FamilyGoalCard: () => null,
}));

import {
  DashboardGoals,
  type DashboardObjective,
  type DashboardQuest,
} from "@/features/dashboard/components/dashboard-goals";
import { DashboardGoalsSkeleton } from "@/features/dashboard/components/dashboard-goals-skeleton";

const objective = (over: Partial<DashboardObjective> = {}): DashboardObjective => ({
  id: "o1",
  objective_type: "perfect_score",
  current_value: 1,
  target_value: 2,
  status: "in_progress",
  xp_reward: 50,
  ...over,
});

const quest = (over: Partial<DashboardQuest> = {}): DashboardQuest => ({
  id: "q1",
  quest_type: "beat_2_bosses",
  current_value: 0,
  target_value: 2,
  status: "in_progress",
  xp_reward: 200,
  ...over,
});

describe("DashboardGoals", () => {
  it("résout l'action depuis le TYPE de l'objectif — un score parfait renvoie au rejeu", () => {
    const onAction = vi.fn();
    render(
      <DashboardGoals dailyObjectives={[objective()]} weeklyQuests={[]} onAction={onAction} />,
    );
    fireEvent.click(screen.getAllByRole("button")[0]);
    expect(onAction).toHaveBeenCalledWith("retry");
  });

  it("résout l'action d'une quête hebdo — deux boss renvoient au donjon", () => {
    const onAction = vi.fn();
    render(<DashboardGoals dailyObjectives={[]} weeklyQuests={[quest()]} onAction={onAction} />);
    fireEvent.click(screen.getAllByRole("button")[0]);
    expect(onAction).toHaveBeenCalledWith("dungeon");
  });

  it("n'agit plus sur un objectif terminé", () => {
    const onAction = vi.fn();
    render(
      <DashboardGoals
        dailyObjectives={[objective({ status: "completed" })]}
        weeklyQuests={[]}
        onAction={onAction}
      />,
    );
    const button = screen.getAllByRole("button")[0];
    expect(button).toBeDisabled();
    fireEvent.click(button);
    expect(onAction).not.toHaveBeenCalled();
  });

  it("borne la progression au lieu de diviser par zéro sur une cible nulle", () => {
    render(
      <DashboardGoals
        dailyObjectives={[objective({ current_value: 3, target_value: 0 })]}
        weeklyQuests={[]}
        onAction={vi.fn()}
      />,
    );
    expect(screen.getByRole("progressbar")).toHaveAttribute("aria-valuenow", "0");
  });

  it("plafonne à 100 quand l'élève dépasse la cible", () => {
    render(
      <DashboardGoals
        dailyObjectives={[]}
        weeklyQuests={[quest({ current_value: 9, target_value: 2 })]}
        onAction={vi.fn()}
      />,
    );
    expect(screen.getByRole("progressbar")).toHaveAttribute("aria-valuenow", "100");
  });
});

describe("DashboardGoalsSkeleton", () => {
  it("annonce le chargement de la section pendant son arrivée paresseuse", () => {
    render(<DashboardGoalsSkeleton />);
    expect(screen.getByRole("status")).toHaveAccessibleName();
  });
});
