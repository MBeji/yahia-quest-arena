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
      subtitle: "Prep or explore.",
      concoursTitle: "Exam Prep",
      libreTitle: "Free Exploration",
      unlocked: "Unlocked",
      premium: "Premium",
      comingSoon: "Coming soon",
      switching: "Switching path…",
      switchError: "error",
      failedLoad: "failed",
      empty: "empty",
    },
  }),
}));

import { ParcoursHub, type ParcoursHubItem } from "../components/parcours-hub";

const concoursAvailable: ParcoursHubItem = {
  id: "concours-9eme",
  name_fr: "Concours 9ème",
  kind: "concours",
  is_premium: true,
  status: "available",
  icon: "GraduationCap",
  color: "subject-math",
  hasEntitlement: false,
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

describe("ParcoursHub (Explorer)", () => {
  it("renders both groups with their parcours", () => {
    render(<ParcoursHub {...baseProps} parcours={[concoursAvailable, concoursSoon, libre]} />);
    expect(screen.getByText(/Exam Prep/)).toBeInTheDocument();
    expect(screen.getByText(/Free Exploration/)).toBeInTheDocument();
    expect(screen.getByText("Concours 9ème")).toBeInTheDocument();
    expect(screen.getByText("Culture Générale")).toBeInTheDocument();
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

  it("renders the coming_soon parcours disabled (aria-disabled, not clickable)", () => {
    const onSelect = vi.fn();
    render(<ParcoursHub {...baseProps} parcours={[concoursSoon]} onSelect={onSelect} />);
    const btn = screen.getByRole("button", { name: "Concours 6ème" });
    expect(btn).toHaveAttribute("aria-disabled", "true");
    expect(btn).toBeDisabled();
    expect(screen.getByText("Coming soon")).toBeInTheDocument();
    fireEvent.click(btn);
    expect(onSelect).not.toHaveBeenCalled();
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
    render(<ParcoursHub {...baseProps} parcours={[libre]} isSwitching onSelect={onSelect} />);
    expect(screen.getByText("Switching path…")).toBeInTheDocument();
    const btn = screen.getByRole("button", { name: "Culture Générale" });
    expect(btn).toBeDisabled();
  });
});
