/**
 * « Révision du jour » — étude 04, lot A1.1 (US-1).
 *
 * Ce que ces tests protègent, ce n'est pas le balisage : c'est la RAISON. Un panneau qui
 * liste trois exercices sans dire pourquoi se lit comme une punition (RISK-4) ; la phrase
 * « Tu n'as pas revu X depuis N jours » est la moitié de la fonctionnalité. Elle se compose
 * ICI, dans la langue de l'interface — le serveur ne renvoie que des faits.
 */
import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

import type { DailyPlanItem } from "@/shared/types/daily-plan";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
  }) => React.createElement("a", { href: to, "data-exercise": params?.exerciseId }, children),
}));

import { DailyReviewPanel } from "../components/daily-review-panel";

function item(overrides: Partial<DailyPlanItem> = {}): DailyPlanItem {
  return {
    exercise_id: "ex-1",
    chapter_id: "chap-1",
    subject_id: "math",
    exercise_title: "Additionner des fractions",
    chapter_title: "Fractions",
    days_overdue: 12,
    weak_tags: 0,
    is_fallback: false,
    ...overrides,
  };
}

describe("DailyReviewPanel", () => {
  it("dit POURQUOI il propose l'exercice, chapitre et retard à l'appui", () => {
    render(<DailyReviewPanel items={[item()]} />);

    expect(screen.getByText("Additionner des fractions")).toBeInTheDocument();
    expect(screen.getByText("Tu n'as pas revu Fractions depuis 12 jours")).toBeInTheDocument();
  });

  it("accorde la raison au retard : aujourd'hui, un jour, plusieurs jours", () => {
    render(
      <DailyReviewPanel
        items={[
          item({ exercise_id: "ex-0", days_overdue: 0, chapter_title: "Géométrie" }),
          item({ exercise_id: "ex-1", days_overdue: 1, chapter_title: "Fractions" }),
          item({ exercise_id: "ex-2", days_overdue: 7, chapter_title: "Équations" }),
        ]}
      />,
    );

    // « depuis 0 jour » ne se dit pas, et « depuis 1 jours » se remarque tout de suite.
    expect(screen.getByText("Géométrie est à revoir aujourd'hui")).toBeInTheDocument();
    expect(screen.getByText("Tu n'as pas revu Fractions depuis 1 jour")).toBeInTheDocument();
    expect(screen.getByText("Tu n'as pas revu Équations depuis 7 jours")).toBeInTheDocument();
  });

  it("envoie chaque révision vers SON exercice, pas vers une page de liste", () => {
    render(
      <DailyReviewPanel items={[item({ exercise_id: "ex-a" }), item({ exercise_id: "ex-b" })]} />,
    );

    const links = screen.getAllByRole("link");
    expect(links).toHaveLength(2);
    expect(links[0]).toHaveAttribute("href", "/quest/$exerciseId");
    expect(links.map((l) => l.getAttribute("data-exercise"))).toEqual(["ex-a", "ex-b"]);
  });

  it("signale le point faible seulement là où il y en a un (D-3, terme 2)", () => {
    render(
      <DailyReviewPanel
        items={[
          item({ exercise_id: "ex-weak", weak_tags: 2 }),
          item({ exercise_id: "ex-clean", weak_tags: 0 }),
        ]}
      />,
    );

    expect(screen.getAllByText("Un point faible repéré ici")).toHaveLength(1);
  });

  it("célèbre l'élève à jour au lieu de lui montrer un trou", () => {
    render(<DailyReviewPanel items={[]} />);

    expect(
      screen.getByText("Rien à réviser aujourd'hui — ta mémoire tient bon. Continue !"),
    ).toBeInTheDocument();
    expect(screen.queryByRole("link")).not.toBeInTheDocument();
  });

  it("rend le plan tel qu'il arrive — c'est le serveur qui trie et qui plafonne (R-4)", () => {
    render(
      <DailyReviewPanel
        items={[
          item({ exercise_id: "ex-1", exercise_title: "Un" }),
          item({ exercise_id: "ex-2", exercise_title: "Deux" }),
          item({ exercise_id: "ex-3", exercise_title: "Trois" }),
        ]}
      />,
    );

    const titles = screen.getAllByRole("link").map((l) => l.textContent);
    expect(titles[0]).toContain("Un");
    expect(titles[2]).toContain("Trois");
  });
});
