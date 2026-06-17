import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    discover: {
      enter: "Enter",
      start: "Start",
      backToPrograms: "Back to programs",
      comingSoonTitle: "Coming soon",
      comingSoonDesc: "Under construction.",
      families: {
        tunisien: "Tunisian school program",
        langues: "Languages",
        culture: "General knowledge",
        cerveau: "Brain training",
        ib: "IB",
      },
      familyDesc: {
        tunisien: "desc-tunisien",
        langues: "desc-langues",
        culture: "desc-culture",
        cerveau: "desc-cerveau",
        ib: "desc-ib",
      },
      langShort: { anglais: "English", francais: "French", arabe: "Arabic" },
    },
    flagship: {
      badge: "National exam",
      sectionTitle: "Our flagship exams",
      bannerTitle: "Prepare for your national exam",
      bannerSubtitle: "Aim for the exam.",
      bannerCta: "Explore the exams",
    },
    cycles: { primaire: "Primary", college: "Middle", secondaire: "High" },
    parcoursInterest: {
      cta: "I'm interested",
      interested: "Interested ✓",
      count: "{count} interested",
      underConstruction: "Under construction",
    },
    explorer: { switching: "Switching…", empty: "empty" },
  }),
}));

import { ProgramCategory } from "../components/program-category";
import { buildPrograms, type ProgramParcours, type Program } from "../program-families";

const P = (over: Partial<ProgramParcours> & { id: string; theme_id: string }): ProgramParcours => ({
  name_fr: over.id,
  status: "available",
  is_premium: false,
  hasEntitlement: true,
  grade_cycle: null,
  grade_order: null,
  ...over,
});

function family(id: string, parcours: ProgramParcours[]): Program {
  const program = buildPrograms(parcours).find((p) => p.id === id);
  if (!program) throw new Error(`unknown family ${id}`);
  return program;
}

function setup(program: Program) {
  const onSelect = vi.fn();
  const onToggle = vi.fn();
  const onBack = vi.fn();
  render(
    <ProgramCategory
      program={program}
      onSelect={onSelect}
      onBack={onBack}
      interest={{ counts: {}, mine: new Set(), togglingId: null, onToggle }}
      isSwitching={false}
    />,
  );
  return { onSelect, onToggle, onBack };
}

describe("ProgramCategory", () => {
  it("languages: enters an available language, votes for a coming-soon one", () => {
    const { onSelect, onToggle } = setup(
      family("langues", [
        P({ id: "anglais", theme_id: "anglais" }),
        P({ id: "francais", theme_id: "francais" }),
        P({ id: "arabe", theme_id: "arabe", status: "coming_soon" }),
      ]),
    );
    expect(screen.getByText("Languages")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "French" }));
    expect(onSelect).toHaveBeenCalledWith("francais");
    // Coming-soon language → no enter button, a vote instead.
    expect(screen.queryByRole("button", { name: "Arabic" })).not.toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /I'm interested/ }));
    expect(onToggle).toHaveBeenCalledWith("arabe");
  });

  it("school: pins flagship concours on top, groups the rest by cycle, votes for coming-soon", () => {
    const { onSelect, onToggle } = setup(
      family("tunisien", [
        P({
          id: "concours-6eme",
          name_fr: "6ème",
          theme_id: "ecole-tn",
          grade_cycle: "primaire",
          grade_order: 6,
          is_premium: true,
          hasEntitlement: false,
        }),
        P({
          id: "concours-9eme",
          name_fr: "9ème",
          theme_id: "ecole-tn",
          grade_cycle: "college",
          grade_order: 9,
          is_premium: true,
        }),
        P({
          id: "ecole-7eme",
          name_fr: "7ème",
          theme_id: "ecole-tn",
          grade_cycle: "college",
          grade_order: 7,
          status: "coming_soon",
        }),
        P({
          id: "ecole-3eme",
          name_fr: "3ème",
          theme_id: "ecole-tn",
          grade_cycle: "primaire",
          grade_order: 3,
        }),
      ]),
    );
    // The 2 premium concours are pinned in a flagship section, each shown ONCE
    // (removed from their cycle so there's no duplicate).
    expect(screen.getByText("Our flagship exams")).toBeInTheDocument();
    expect(screen.getAllByText("National exam")).toHaveLength(2);
    // The class title is shown in full (not truncated away) for each flagship.
    expect(screen.getByRole("heading", { name: "6ème" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "9ème" })).toBeInTheDocument();
    expect(screen.getAllByRole("button", { name: "9ème" })).toHaveLength(1);
    fireEvent.click(screen.getByRole("button", { name: "9ème" }));
    expect(onSelect).toHaveBeenCalledWith("concours-9eme");
    fireEvent.click(screen.getByRole("button", { name: "6ème" }));
    expect(onSelect).toHaveBeenCalledWith("concours-6eme");
    // Non-flagship classes still appear under their cycle.
    expect(screen.getByText("Primary")).toBeInTheDocument();
    expect(screen.getByText("Middle")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "3ème" }));
    expect(onSelect).toHaveBeenCalledWith("ecole-3eme");
    // Coming-soon non-flagship class → vote, not entry.
    expect(screen.queryByRole("button", { name: "7ème" })).not.toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /I'm interested/ }));
    expect(onToggle).toHaveBeenCalledWith("ecole-7eme");
  });

  it("single-entry program: a 'start' CTA enters the parcours directly", () => {
    const { onSelect } = setup(
      family("culture", [P({ id: "culture-generale", theme_id: "culture-generale" })]),
    );
    expect(screen.getByText("General knowledge")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Start" }));
    expect(onSelect).toHaveBeenCalledWith("culture-generale");
  });

  it("coming-soon program (IB): an elegant teaser + interest vote, no entry", () => {
    const { onSelect, onToggle } = setup(
      family("ib", [P({ id: "ib", theme_id: "ib", status: "coming_soon" })]),
    );
    expect(screen.getByText("Coming soon")).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Start" })).not.toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /I'm interested/ }));
    expect(onToggle).toHaveBeenCalledWith("ib");
    expect(onSelect).not.toHaveBeenCalled();
  });

  it("back link returns to the hub", () => {
    const { onBack } = setup(
      family("cerveau", [P({ id: "muscle-cerveau", theme_id: "muscle-cerveau" })]),
    );
    fireEvent.click(screen.getByRole("button", { name: /Back to programs/ }));
    expect(onBack).toHaveBeenCalled();
  });
});
