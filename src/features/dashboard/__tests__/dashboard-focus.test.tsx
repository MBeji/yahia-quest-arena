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
        nextAction={{ kind: "retry", exerciseId: "ex-1" }}
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

  it("renders 'Continuer <matière>' when the engine delegates the path to a subject", () => {
    render(
      <DashboardFocus
        nextAction={{ kind: "continue-subject", subjectId: "math" }}
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

  it("stays silent rather than inventing a target when the engine has nothing (R-31)", () => {
    // L'ancienne bande retombait sur « la première matière du parcours » — un CTA que rien ne
    // justifiait. Un écran qui n'a rien à proposer doit le dire, pas meubler.
    render(
      <DashboardFocus
        nextAction={null}
        continueSubject={subject}
        xpToday={0}
        dailyGoal={100}
        streak={0}
      />,
    );
    expect(screen.queryByText("Continuer")).not.toBeInTheDocument();
    expect(screen.queryByText("Mathématiques")).not.toBeInTheDocument();
  });

  it("renders the Donjon and Duel secondary tiles", () => {
    render(
      <DashboardFocus
        nextAction={null}
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
        nextAction={{ kind: "retry", exerciseId: "ex-1" }}
        continueSubject={subject}
        xpToday={65}
        dailyGoal={100}
        streak={12}
      />,
    );
    expect(screen.getByText("65%")).toBeInTheDocument();
  });
});
