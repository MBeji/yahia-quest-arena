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

  it("rend les rangs 2 et 4 — dormants jusqu'au producteur de #870", () => {
    // Avant #870, aucun appelant ne renseignait `remediation`/`strengthen` : ces deux
    // rangs rendaient `null` et la bande ne les voyait jamais. Ils arrivent ici.
    render(
      <DashboardFocus
        nextAction={{ kind: "remediate", exerciseId: "ex-racine", competencySlug: "pgcd" }}
        continueSubject={subject}
        xpToday={0}
        dailyGoal={100}
        streak={0}
      />,
    );
    expect(screen.getByText("On reprend la base")).toBeInTheDocument();
    const cta = screen.getByText("Un pas en arrière pour deux en avant").closest("a");
    expect(cta).toHaveAttribute("href", "/quest/$exerciseId");
  });

  it("ne dit JAMAIS à l'élève ce qu'on pense de lui (R-14 / D-1)", () => {
    // Les libellés nomment l'ACTION, jamais l'état de croyance : ni « lacune », ni
    // « fragile », ni un pourcentage. Ces grandeurs sont réservées à la console d'admin.
    const { container } = render(
      <DashboardFocus
        nextAction={{ kind: "strengthen", exerciseId: "ex-2", competencySlug: "frac-add" }}
        continueSubject={subject}
        xpToday={0}
        dailyGoal={100}
        streak={0}
      />,
    );
    expect(screen.getByText("Encore un peu")).toBeInTheDocument();
    expect(container.textContent).not.toMatch(/lacune|fragile|pgcd|frac-add|%\s*de/i);
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
