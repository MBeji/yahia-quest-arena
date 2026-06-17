import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

// Render motion.* elements as plain elements (drop animation-only props), while
// preserving the props the component relies on (onClick, disabled, aria-*).
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
          ...rest
        }: Record<string, unknown> & { children?: React.ReactNode }) =>
          React.createElement(tag, rest, children),
    },
  ),
}));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    explorer: {
      heading: "Choose your path",
      subtitle: "Follow or explore.",
      concoursTitle: "School program",
      libreTitle: "Free Exploration",
      unlocked: "Unlocked",
      premium: "Premium",
      comingSoon: "Coming soon",
      switching: "Switching path…",
      switchError: "error",
      failedLoad: "failed",
      empty: "empty",
    },
    cycles: { primaire: "Primary", college: "Middle school", secondaire: "High school" },
    parcoursInterest: {
      cta: "I'm interested",
      interested: "Interested ✓",
      count: "{count} interested",
      underConstruction: "Under construction",
    },
  }),
}));

import {
  ParcoursHub,
  type ParcoursHubItem,
  type ParcoursInterestState,
} from "../components/parcours-hub";

const concoursAvailable: ParcoursHubItem = {
  id: "concours-9eme",
  name_fr: "Concours 9ème",
  kind: "concours",
  is_premium: true,
  status: "available",
  icon: "GraduationCap",
  color: "subject-math",
  hasEntitlement: false,
  grade_cycle: "college",
  grade_order: 9,
};

const concoursSoon: ParcoursHubItem = {
  id: "concours-6eme",
  name_fr: "Concours 6ème",
  kind: "concours",
  is_premium: true,
  status: "coming_soon",
  icon: "GraduationCap",
  color: "subject-math",
  hasEntitlement: false,
  grade_cycle: "primaire",
  grade_order: 6,
};

const scolaireSoon: ParcoursHubItem = {
  id: "ecole-1ere-base",
  name_fr: "1ère année de base",
  kind: "scolaire",
  is_premium: false,
  status: "coming_soon",
  icon: "GraduationCap",
  color: "subject-math",
  hasEntitlement: true,
  grade_cycle: "primaire",
  grade_order: 1,
};

const secSoon: ParcoursHubItem = {
  id: "ecole-1ere-sec",
  name_fr: "1ère année secondaire",
  kind: "scolaire",
  is_premium: false,
  status: "coming_soon",
  icon: "GraduationCap",
  color: "subject-math",
  hasEntitlement: true,
  grade_cycle: "secondaire",
  grade_order: 10,
};

const libre: ParcoursHubItem = {
  id: "culture-generale",
  name_fr: "Culture Générale",
  kind: "libre",
  is_premium: false,
  status: "available",
  icon: "Globe",
  color: "subject-french",
  hasEntitlement: true,
};

const baseProps = {
  isPending: false,
  isError: false,
  isSwitching: false,
  onSelect: () => {},
};

const noInterest: ParcoursInterestState = {
  counts: {},
  mine: new Set<string>(),
  togglingId: null,
  onToggle: () => {},
};

describe("ParcoursHub (Explorer)", () => {
  it("renders the school group (by cycle) and the libre group", () => {
    render(<ParcoursHub {...baseProps} parcours={[concoursAvailable, scolaireSoon, libre]} />);
    expect(screen.getByText(/School program/)).toBeInTheDocument();
    expect(screen.getByText(/Free Exploration/)).toBeInTheDocument();
    expect(screen.getByText("Concours 9ème")).toBeInTheDocument();
    expect(screen.getByText("1ère année de base")).toBeInTheDocument();
    expect(screen.getByText("Culture Générale")).toBeInTheDocument();
    // Cycle subheadings group the ladder.
    expect(screen.getByText("Primary")).toBeInTheDocument();
    expect(screen.getByText("Middle school")).toBeInTheDocument();
  });

  it("groups school parcours into all three cycles", () => {
    render(<ParcoursHub {...baseProps} parcours={[scolaireSoon, concoursAvailable, secSoon]} />);
    expect(screen.getByText("Primary")).toBeInTheDocument();
    expect(screen.getByText("Middle school")).toBeInTheDocument();
    expect(screen.getByText("High school")).toBeInTheDocument();
  });

  it("shows a Premium (lock) badge on a premium parcours without entitlement", () => {
    render(<ParcoursHub {...baseProps} parcours={[concoursAvailable]} />);
    expect(screen.getByText("Premium")).toBeInTheDocument();
  });

  it("shows an Unlocked badge on a premium parcours with entitlement", () => {
    render(
      <ParcoursHub {...baseProps} parcours={[{ ...concoursAvailable, hasEntitlement: true }]} />,
    );
    expect(screen.getByText("Unlocked")).toBeInTheDocument();
  });

  it("renders a coming_soon parcours as a non-selectable 'under construction' card", () => {
    const onSelect = vi.fn();
    render(<ParcoursHub {...baseProps} parcours={[concoursSoon]} onSelect={onSelect} />);
    // It is NOT a button anymore (so the interest button can nest inside).
    expect(screen.queryByRole("button", { name: "Concours 6ème" })).not.toBeInTheDocument();
    expect(screen.getByText("Under construction")).toBeInTheDocument();
    expect(onSelect).not.toHaveBeenCalled();
  });

  it("shows the interest button + count on a coming_soon card and toggles it", () => {
    const onToggle = vi.fn();
    render(
      <ParcoursHub
        {...baseProps}
        parcours={[scolaireSoon]}
        interest={{ counts: { "ecole-1ere-base": 3 }, mine: new Set(), togglingId: null, onToggle }}
      />,
    );
    expect(screen.getByText("3 interested")).toBeInTheDocument();
    const cta = screen.getByRole("button", { name: /I'm interested/ });
    fireEvent.click(cta);
    expect(onToggle).toHaveBeenCalledWith("ecole-1ere-base");
  });

  it("reflects an already-registered interest as 'Interested ✓'", () => {
    render(
      <ParcoursHub
        {...baseProps}
        parcours={[scolaireSoon]}
        interest={{
          counts: { "ecole-1ere-base": 1 },
          mine: new Set(["ecole-1ere-base"]),
          togglingId: null,
          onToggle: () => {},
        }}
      />,
    );
    expect(screen.getByRole("button", { name: /Interested ✓/ })).toBeInTheDocument();
  });

  it("calls onSelect with the parcours id when an available card is clicked", () => {
    const onSelect = vi.fn();
    render(<ParcoursHub {...baseProps} parcours={[libre]} onSelect={onSelect} />);
    fireEvent.click(screen.getByRole("button", { name: "Culture Générale" }));
    expect(onSelect).toHaveBeenCalledWith("culture-generale");
  });

  it("excludes a coming_soon libre parcours (only available libre shown)", () => {
    const soonLibre: ParcoursHubItem = { ...libre, id: "x", status: "coming_soon" };
    render(<ParcoursHub {...baseProps} parcours={[soonLibre]} />);
    expect(screen.queryByText("Culture Générale")).not.toBeInTheDocument();
    expect(screen.getByText("empty")).toBeInTheDocument();
  });

  it("disables cards and shows the switching hint during a mutation", () => {
    const onSelect = vi.fn();
    render(
      <ParcoursHub
        {...baseProps}
        parcours={[libre]}
        isSwitching
        onSelect={onSelect}
        interest={noInterest}
      />,
    );
    expect(screen.getByText("Switching path…")).toBeInTheDocument();
    const btn = screen.getByRole("button", { name: "Culture Générale" });
    expect(btn).toBeDisabled();
  });
});
