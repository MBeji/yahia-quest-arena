import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import React from "react";
import { vi } from "vitest";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { DashboardFocus } from "../components/dashboard-focus";

const subject = { id: "math", name_fr: "Mathématiques" };

describe("DashboardFocus", () => {
  it("promotes the unfinished exercise as the primary 'Reprendre' action", () => {
    render(
      <DashboardFocus
        nextExerciseId="ex-1"
        continueSubject={subject}
        xpToday={65}
        dailyGoal={100}
        streak={12}
      />,
    );
    // Overline verb + retry title, linking to the quest player.
    expect(screen.getByText("Reprendre")).toBeInTheDocument();
    expect(screen.getByText("Ton dernier exercice")).toBeInTheDocument();
    const cta = screen.getByText("Ton dernier exercice").closest("a");
    expect(cta).toHaveAttribute("href", "/quest/$exerciseId");
  });

  it("falls back to 'Continuer <subject>' when there is no unfinished exercise", () => {
    render(
      <DashboardFocus
        nextExerciseId={null}
        continueSubject={subject}
        xpToday={0}
        dailyGoal={100}
        streak={0}
      />,
    );
    expect(screen.getByText("Continuer")).toBeInTheDocument();
    const cta = screen.getByText("Mathématiques").closest("a");
    expect(cta).toHaveAttribute("href", "/matiere/$subjectId");
  });

  it("renders the Donjon and Duel secondary tiles", () => {
    render(
      <DashboardFocus
        nextExerciseId={null}
        continueSubject={subject}
        xpToday={0}
        dailyGoal={100}
        streak={0}
      />,
    );
    expect(screen.getByText("Le Donjon Infini")).toBeInTheDocument();
    expect(screen.getByText("Duels")).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /Donjon/i })).toHaveAttribute("href", "/dungeon");
    expect(screen.getByRole("link", { name: /Duel/i })).toHaveAttribute("href", "/duel");
  });

  it("shows the daily-objective ring percentage", () => {
    render(
      <DashboardFocus
        nextExerciseId="ex-1"
        continueSubject={subject}
        xpToday={65}
        dailyGoal={100}
        streak={12}
      />,
    );
    expect(screen.getByText("65%")).toBeInTheDocument();
  });
});
