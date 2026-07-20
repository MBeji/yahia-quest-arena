import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

// Render motion.* elements as plain divs (drop animation-only props).
vi.mock("motion/react", () => ({
  motion: new Proxy(
    {},
    {
      get:
        () =>
        ({ children }: { children?: React.ReactNode }) => <div>{children}</div>,
    },
  ),
  useReducedMotion: () => false,
}));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    parcours: {
      worldTitle: "Adventure Map",
      worldSubtitle: "Choose your path",
      level: "Level",
      xpToNext: "to next",
      maxLevel: "max",
      premium: "Premium",
      nodeNext: "Suggested",
      xpToEarn: "XP",
      backToMap: "back",
      empty: "empty",
    },
  }),
}));

import { JourneyMap } from "../components/journey-map";
import type { SubjectNode } from "../journey";

const nodes: SubjectNode[] = [
  {
    id: "math",
    nameFr: "Maths",
    colorToken: "subject-math",
    icon: "Calculator",
    isPremium: false,
    attempts: 5,
    avg: 90,
    progressionPct: 100,
    state: "done",
  },
  {
    id: "french",
    nameFr: "Français",
    colorToken: "subject-french",
    icon: "BookOpen",
    isPremium: false,
    attempts: 2,
    avg: 50,
    progressionPct: 40,
    state: "current",
  },
  {
    id: "arabic",
    nameFr: "Arabe",
    colorToken: "subject-arabic",
    icon: "Languages",
    isPremium: false,
    attempts: 0,
    avg: 0,
    progressionPct: 0,
    state: "next",
  },
  {
    id: "frm",
    nameFr: "Maîtrise",
    colorToken: "subject-french",
    icon: "BookOpen",
    isPremium: true,
    attempts: 0,
    avg: 0,
    progressionPct: null,
    state: "premium-locked",
  },
];

describe("JourneyMap", () => {
  it("renders the world title, level and all subject nodes", () => {
    render(<JourneyMap nodes={nodes} profile={{ level: 4, xp: 250, heroClass: "Aspirant" }} />);
    expect(screen.getByText("Adventure Map")).toBeInTheDocument();
    expect(screen.getByText(/Level\s*4/)).toBeInTheDocument();
    expect(screen.getByText("Aspirant")).toBeInTheDocument();
    for (const name of ["Maths", "Français", "Arabe", "Maîtrise"]) {
      expect(screen.getByText(name)).toBeInTheDocument();
    }
  });

  it("links EVERY subject to the unified subject screen (R-11: no node is unclickable)", () => {
    const { container } = render(
      <JourneyMap nodes={nodes} profile={{ level: 1, xp: 0, heroClass: "Novice" }} />,
    );
    const hrefs = Array.from(container.querySelectorAll("a")).map((a) => a.getAttribute("href"));
    // La carte ne verrouille plus : les quatre nœuds — y compris `premium-locked`, dont la
    // page explique le cas — pointent vers /matiere/$subjectId. Aucun nœud muet.
    expect(hrefs).toEqual(Array(nodes.length).fill("/matiere/$subjectId"));
    expect(hrefs).not.toContain("/parcours/$subjectId");
  });

  it("shows the R-16 progression as sublabel and badges the recommended node", () => {
    render(<JourneyMap nodes={nodes} profile={{ level: 1, xp: 0, heroClass: "Novice" }} />);
    // Sous-libellé = progression en chapitres, pas la moyenne des scores (avg 90 ≠ 100 %).
    expect(screen.getByText("40%")).toBeInTheDocument();
    // Le badge « recommandé » ne s'affiche que sur le nœud `next`.
    expect(screen.getAllByText("Suggested")).toHaveLength(1);
  });

  it("omits the sublabel when progression is unknown rather than showing 100%", () => {
    render(<JourneyMap nodes={nodes} profile={{ level: 1, xp: 0, heroClass: "Novice" }} />);
    // « Maîtrise » a progressionPct null : aucun pourcentage ne lui est accolé.
    expect(screen.queryByText("null%")).not.toBeInTheDocument();
    expect(screen.getAllByText(/^\d+%$/).length).toBe(3);
  });
});
