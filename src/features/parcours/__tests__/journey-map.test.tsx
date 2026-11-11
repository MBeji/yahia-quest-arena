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
      sealLegend: "⭐ = subject seal",
      nodeSealAria: "{subject} — seal {stars}, {ready} of {total} ready",
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
    sealStar: 4,
    nextSeal: null,
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
    sealStar: 1,
    nextSeal: { star: 2, chaptersReady: 8, chaptersTotal: 20, newChapters: 0 },
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
    sealStar: 0,
    nextSeal: { star: 1, chaptersReady: 0, chaptersTotal: 12, newChapters: 0 },
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
    sealStar: 0,
    nextSeal: null,
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

  it("⭐ affiche le SCEAU et ce qui manque pour le suivant, et badge le nœud recommandé", () => {
    render(<JourneyMap nodes={nodes} profile={{ level: 1, xp: 0, heroClass: "Novice" }} />);
    // Français : sceau ⭐ acquis, 8 chapitres sur 20 prêts pour le ⭐⭐.
    expect(screen.getByText("⭐ · 8/20")).toBeInTheDocument();
    // Maths est scellée au ⭐⭐⭐⭐ : le glyphe seul, sans fraction — il n'y a plus rien à viser.
    expect(screen.getByText("⭐⭐⭐⭐")).toBeInTheDocument();
    // Le badge « recommandé » ne s'affiche que sur le nœud `next`.
    expect(screen.getAllByText("Suggested")).toHaveLength(1);
  });

  it("⭐ n'affiche AUCUN pourcentage — c'est tout l'objet du changement (é34)", () => {
    const { container } = render(
      <JourneyMap nodes={nodes} profile={{ level: 1, xp: 0, heroClass: "Novice" }} />,
    );
    // Un pourcentage divise un travail par un catalogue qui bouge : il faisait reculer
    // l'élève quand c'était le produit qui grandissait. Il ne doit plus exister ici.
    expect(container.textContent).not.toMatch(/\d+\s*%/);
    // « Maîtrise » n'a ni sceau ni prochain : elle se tait plutôt que d'afficher « 0 ».
    expect(screen.queryByText("null")).not.toBeInTheDocument();
  });

  it("porte une LÉGENDE : « ⭐⭐ · 8/20 » ne se devine pas", () => {
    render(<JourneyMap nodes={nodes} profile={{ level: 1, xp: 0, heroClass: "Novice" }} />);
    expect(screen.getByTestId("seal-legend").textContent).toMatch(/⭐/);
  });
});
