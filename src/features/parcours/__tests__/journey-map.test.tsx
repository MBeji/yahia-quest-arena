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
      lockedHint: "locked",
      premiumHint: "subscribe",
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
    state: "locked",
  },
  {
    id: "frm",
    nameFr: "Maîtrise",
    colorToken: "subject-french",
    icon: "BookOpen",
    isPremium: true,
    attempts: 0,
    avg: 0,
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

  it("links every non-locked subject to the unified subject screen, leaving locked unlinked", () => {
    const { container } = render(
      <JourneyMap nodes={nodes} profile={{ level: 1, xp: 0, heroClass: "Novice" }} />,
    );
    const hrefs = Array.from(container.querySelectorAll("a")).map((a) => a.getAttribute("href"));
    // After the F1 merge there is a single chapter screen: all non-locked nodes
    // (done/current/open AND premium-locked) point to /matiere/$subjectId; the
    // locked node ("Arabe") renders no link.
    expect(hrefs).toEqual(["/matiere/$subjectId", "/matiere/$subjectId", "/matiere/$subjectId"]);
    expect(hrefs).not.toContain("/parcours/$subjectId");
  });
});
