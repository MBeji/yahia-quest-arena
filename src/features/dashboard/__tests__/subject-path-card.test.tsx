import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import type { SubjectStarSummary } from "@/shared/lib/progress-stars";
import { SubjectPathCard } from "../components/subject-path-card";

const base = {
  id: "math",
  name_fr: "Mathématiques",
  icon: "Sword",
  attribute: "Force",
  color_token: "math",
};

describe("SubjectPathCard", () => {
  /** Un agrégat de matière à la forme de `get_user_subject_stars` — bornes CUMULÉES. */
  const stars = (
    total: number,
    cumulative: [number, number, number, number],
    sealStar = 0,
  ): SubjectStarSummary => ({
    subjectId: "math",
    chaptersTotal: total,
    chaptersStarted: cumulative[0],
    cumulative,
    sealStar,
    sealAt: null,
    newChapters: 0,
    newMissions: 0,
  });

  it("renders the name, attribute and quest count", () => {
    render(<SubjectPathCard subject={base} stat={{ count: 3, avg: 82 }} premiumLocked={false} />);
    expect(screen.getByText("Mathématiques")).toBeInTheDocument();
    expect(screen.getByText(/Force/)).toBeInTheDocument();
    expect(screen.getByText(/3 quest/)).toBeInTheDocument();
  });

  it("⭐ le SCEAU remplace la moyenne des scores — deux « 82 % » différents, c'était un", () => {
    // Avant l'étude 34, ce chiffre était la moyenne des SCORES, affichée exactement
    // comme le « 40 % » de la carte /parcours, qui disait la couverture des chapitres.
    // Deux pourcentages identiques à l'œil pour deux choses différentes.
    render(
      <SubjectPathCard
        subject={base}
        stat={{ count: 3, avg: 82 }}
        stars={stars(20, [14, 9, 3, 1], 1)}
        premiumLocked={false}
      />,
    );
    expect(screen.queryByText("82%")).not.toBeInTheDocument();
    expect(screen.getByTestId("card-seal").textContent).toBe("⭐");
    // …et la barre du prochain sceau dit ce qui manque, sans pourcentage.
    expect(screen.getByTestId("card-next-seal").textContent).toContain("⭐⭐ 9/20");
  });

  it("se tait au sceau ⭐⭐⭐⭐ : plus rien à viser", () => {
    render(
      <SubjectPathCard
        subject={base}
        stat={{ count: 9, avg: 95 }}
        stars={stars(3, [3, 3, 3, 3], 4)}
        premiumLocked={false}
      />,
    );
    expect(screen.getByTestId("card-seal").textContent).toBe("⭐⭐⭐⭐");
    expect(screen.queryByTestId("card-next-seal")).not.toBeInTheDocument();
  });

  it("n'invente aucun sceau sans donnée — la carte se tait (tiret)", () => {
    render(<SubjectPathCard subject={base} stat={undefined} premiumLocked={false} />);
    expect(screen.getByTestId("card-seal").textContent).toBe("—");
    expect(screen.queryByTestId("card-next-seal")).not.toBeInTheDocument();
  });

  it("shows a Premium (lock) badge on a premium-locked subject", () => {
    render(<SubjectPathCard subject={base} stat={undefined} premiumLocked />);
    expect(screen.getByText("Premium")).toBeInTheDocument();
  });

  it("does not show a Premium badge when the subject is not locked (entitled or free)", () => {
    render(<SubjectPathCard subject={base} stat={undefined} premiumLocked={false} />);
    expect(screen.queryByText("Premium")).not.toBeInTheDocument();
  });

  it("resolves the subject colour var without double-prefixing a prefixed token", () => {
    const { container } = render(
      <SubjectPathCard
        subject={{ ...base, color_token: "subject-arabic" }}
        stat={{ count: 1, avg: 50 }}
        premiumLocked={false}
      />,
    );
    expect(container.innerHTML).toContain("var(--subject-arabic)");
    expect(container.innerHTML).not.toContain("subject-subject-arabic");
  });

  it("resolves the subject colour var from a bare token too", () => {
    const { container } = render(
      <SubjectPathCard
        subject={{ ...base, color_token: "math" }}
        stat={undefined}
        premiumLocked={false}
      />,
    );
    expect(container.innerHTML).toContain("var(--subject-math)");
    expect(container.innerHTML).not.toContain("subject-subject-math");
  });

  it("renders the mapped lucide icon instead of the Sword fallback", () => {
    const mapped = render(
      <SubjectPathCard
        subject={{ ...base, icon: "Calculator" }}
        stat={undefined}
        premiumLocked={false}
      />,
    )
      .container.querySelector("svg")
      ?.getAttribute("class");
    const fallback = render(
      <SubjectPathCard
        subject={{ ...base, icon: "DefinitelyNotAnIcon" }}
        stat={undefined}
        premiumLocked={false}
      />,
    )
      .container.querySelector("svg")
      ?.getAttribute("class");
    expect(mapped).toBeTruthy();
    expect(mapped).not.toEqual(fallback); // Calculator was resolved, not collapsed to Sword
  });
});
