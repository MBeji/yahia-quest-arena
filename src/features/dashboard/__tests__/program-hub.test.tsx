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
      families: {
        tunisien: "Tunisian school program",
        langues: "Languages",
        culture: "General knowledge",
        cerveau: "Brain training",
        ib: "IB",
      },
      langShort: { anglais: "Anglais", francais: "Français", arabe: "Arabe" },
      hintClasses: "{count} classes",
      hintLanguages: "{count} languages",
      hintSoon: "Soon",
      hintExplore: "Explore",
    },
    cycles: { primaire: "Primary", college: "Middle", secondaire: "High" },
    explorer: { failedLoad: "failed", empty: "empty" },
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
  const onOpen = vi.fn();
  render(
    <ProgramHub parcours={CATALOGUE} isPending={false} isError={false} onOpen={onOpen} {...over} />,
  );
  return { onOpen };
}

describe("ProgramHub (Découvrir)", () => {
  it("renders the 5 root program nodes — and nothing else is interactive", () => {
    setup();
    expect(screen.getByRole("button", { name: "Tunisian school program" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Languages" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "General knowledge" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Brain training" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "IB" })).toBeInTheDocument();
    // Only the 5 nodes are clickable — no sub-menu / enter / vote buttons on the hub.
    expect(screen.getAllByRole("button")).toHaveLength(5);
  });

  it("opens the dedicated category page for the clicked program (no in-place entry)", () => {
    const { onOpen } = setup();
    fireEvent.click(screen.getByRole("button", { name: "Languages" }));
    expect(onOpen).toHaveBeenCalledWith("langues");
    fireEvent.click(screen.getByRole("button", { name: "General knowledge" }));
    expect(onOpen).toHaveBeenCalledWith("culture");
    fireEvent.click(screen.getByRole("button", { name: "IB" }));
    expect(onOpen).toHaveBeenCalledWith("ib");
  });

  it("reveals NON-clickable sub-menu previews on hover (desktop)", () => {
    setup();
    // Before hover: previews are hidden.
    expect(screen.queryByText("Anglais")).not.toBeInTheDocument();
    fireEvent.mouseEnter(screen.getByRole("button", { name: "Languages" }));
    // Preview chips appear…
    expect(screen.getByText("Anglais")).toBeInTheDocument();
    expect(screen.getByText("Français")).toBeInTheDocument();
    // …but are illustration only — not buttons, and the node count stays at 5.
    expect(screen.queryByRole("button", { name: "Anglais" })).not.toBeInTheDocument();
    expect(screen.getAllByRole("button")).toHaveLength(5);
  });

  it("shows loading / error / empty states", () => {
    const { rerender } = render(
      <ProgramHub parcours={[]} isPending isError={false} onOpen={vi.fn()} />,
    );
    expect(screen.queryByRole("button")).not.toBeInTheDocument();

    rerender(<ProgramHub parcours={[]} isPending={false} isError onOpen={vi.fn()} />);
    expect(screen.getByText("failed")).toBeInTheDocument();

    rerender(<ProgramHub parcours={[]} isPending={false} isError={false} onOpen={vi.fn()} />);
    expect(screen.getByText("empty")).toBeInTheDocument();
  });
});
