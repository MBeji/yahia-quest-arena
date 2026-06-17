import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("motion/react", () => ({
  motion: new Proxy(
    {},
    {
      get:
        (_t, tag: string) =>
        ({
          children,
          whileHover: _wh,
          whileTap: _wt,
          animate: _a,
          initial: _i,
          transition: _tr,
          ...rest
        }: Record<string, unknown> & { children?: React.ReactNode }) =>
          React.createElement(tag, rest, children),
    },
  ),
  useReducedMotion: () => true,
}));

vi.mock("@/hooks/use-mobile", () => ({ useIsMobile: () => false }));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    discover: {
      heading: "Discover our programs",
      subtitle: "Pick your path.",
      center: "Our programs",
      enter: "Enter",
      back: "Back",
      families: {
        tunisien: "Tunisian school program",
        langues: "Languages",
        culture: "General knowledge",
        cerveau: "Brain training",
        ib: "IB",
      },
      hintClasses: "{count} classes",
      hintLanguages: "{count} languages",
      hintSoon: "Soon",
      hintExplore: "Explore",
    },
    cycles: { primaire: "Primary", college: "Middle", secondaire: "High" },
    parcoursInterest: {
      cta: "I'm interested",
      interested: "Interested ✓",
      count: "{count} interested",
      underConstruction: "Under construction",
    },
    explorer: {
      premium: "Premium",
      unlocked: "Unlocked",
      switching: "Switching…",
      failedLoad: "failed",
      empty: "empty",
    },
  }),
}));

import { ProgramHub } from "../components/program-hub";
import type { ProgramParcours } from "../program-families";

const P = (over: Partial<ProgramParcours> & { id: string; theme_id: string }): ProgramParcours => ({
  name_fr: over.id,
  status: "available",
  is_premium: false,
  hasEntitlement: true,
  grade_cycle: null,
  grade_order: null,
  ...over,
});

const CATALOGUE: ProgramParcours[] = [
  P({
    id: "concours-9eme",
    name_fr: "9ème",
    theme_id: "ecole-tn",
    grade_cycle: "college",
    grade_order: 9,
    is_premium: true,
  }),
  P({
    id: "ecole-7eme-base",
    name_fr: "7ème",
    theme_id: "ecole-tn",
    grade_cycle: "college",
    grade_order: 7,
    status: "coming_soon",
  }),
  P({ id: "anglais", name_fr: "Anglais", theme_id: "anglais" }),
  P({ id: "francais", name_fr: "Français", theme_id: "francais" }),
  P({ id: "arabe", name_fr: "Arabe", theme_id: "arabe" }),
  P({ id: "culture-generale", name_fr: "Culture G", theme_id: "culture-generale" }),
  P({ id: "muscle-cerveau", name_fr: "Cerveau", theme_id: "muscle-cerveau" }),
  P({ id: "ib", name_fr: "IB program", theme_id: "ib", status: "coming_soon" }),
];

function setup(over: Partial<React.ComponentProps<typeof ProgramHub>> = {}) {
  const onSelect = vi.fn();
  const onToggle = vi.fn();
  render(
    <ProgramHub
      parcours={CATALOGUE}
      isPending={false}
      isError={false}
      isSwitching={false}
      onSelect={onSelect}
      interest={{ counts: {}, mine: new Set(), togglingId: null, onToggle }}
      {...over}
    />,
  );
  return { onSelect, onToggle };
}

describe("ProgramHub (Découvrir)", () => {
  it("renders the 5 root program nodes", () => {
    setup();
    expect(screen.getByRole("button", { name: "Tunisian school program" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Languages" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "General knowledge" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Brain training" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "IB" })).toBeInTheDocument();
  });

  it("enters a single-parcours program directly on click (no panel)", () => {
    const { onSelect } = setup();
    fireEvent.click(screen.getByRole("button", { name: "General knowledge" }));
    expect(onSelect).toHaveBeenCalledWith("culture-generale");
    // No disclosure panel (no cycle labels) for an enter-kind program.
    expect(screen.queryByText("Primary")).not.toBeInTheDocument();
  });

  it("reveals the 3 languages and enters one on click", () => {
    const { onSelect } = setup();
    fireEvent.click(screen.getByRole("button", { name: "Languages" }));
    expect(screen.getByRole("button", { name: /Anglais/ })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Français/ })).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Arabe/ }));
    expect(onSelect).toHaveBeenCalledWith("arabe");
  });

  it("reveals cycles → classes for the school program", () => {
    const { onSelect } = setup();
    fireEvent.click(screen.getByRole("button", { name: "Tunisian school program" }));
    // Cycle chooser (only cycles with classes → Middle).
    fireEvent.click(screen.getByRole("button", { name: /Middle/ }));
    // Available class enters; coming-soon class shows a vote.
    fireEvent.click(screen.getByRole("button", { name: /9ème/ }));
    expect(onSelect).toHaveBeenCalledWith("concours-9eme");
    expect(screen.getByRole("button", { name: /I'm interested/ })).toBeInTheDocument();
  });

  it("offers a vote (not entry) for the coming-soon IB program", () => {
    const { onSelect } = setup();
    fireEvent.click(screen.getByRole("button", { name: "IB" }));
    expect(screen.getByText("Under construction")).toBeInTheDocument();
    const vote = screen.getByRole("button", { name: /I'm interested/ });
    fireEvent.click(vote);
    expect(onSelect).not.toHaveBeenCalled();
  });

  it("shows the switching hint", () => {
    setup({ isSwitching: true });
    expect(screen.getByText("Switching…")).toBeInTheDocument();
  });
});
