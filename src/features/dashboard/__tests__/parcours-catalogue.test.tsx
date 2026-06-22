import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import {
  ProgrammeCatalogue,
  ExtrasCatalogue,
  type CatalogueParcours,
} from "../components/parcours-catalogue";

/** A catalogue parcours with school-default fields; override what a case needs. */
function p(over: Partial<CatalogueParcours>): CatalogueParcours {
  return {
    id: "x",
    name_fr: "X",
    kind: "scolaire",
    status: "available",
    is_premium: false,
    hasEntitlement: true,
    theme_id: "ecole-tn",
    grade_cycle: "primaire",
    grade_order: 1,
    ...over,
  } as CatalogueParcours;
}

describe("ProgrammeCatalogue", () => {
  const parcours: CatalogueParcours[] = [
    p({
      id: "ecole-1ere-base",
      name_fr: "1ère année de base",
      grade_cycle: "primaire",
      grade_order: 1,
    }),
    p({
      id: "concours-9eme",
      name_fr: "Préparation Concours 9ème",
      kind: "concours",
      is_premium: true,
      grade_cycle: "college",
      grade_order: 9,
    }),
    p({
      id: "ecole-7eme-base",
      name_fr: "7ème année de base",
      grade_cycle: "college",
      grade_order: 7,
      status: "coming_soon",
    }),
  ];

  it("groups school levels by cycle with the concours class highlighted", () => {
    render(<ProgrammeCatalogue parcours={parcours} />);
    expect(screen.getByRole("heading", { level: 2, name: "Primaire" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { level: 2, name: "Collège" })).toBeInTheDocument();
    // the concours label is compacted ("Préparation Concours 9ème" → "9ème") + badged
    expect(screen.getByText("9ème")).toBeInTheDocument();
    expect(screen.getByText("Concours")).toBeInTheDocument();
  });

  it("links available levels to their /niveau page but not coming-soon ones", () => {
    const { container } = render(<ProgrammeCatalogue parcours={parcours} />);
    // 1ère + concours-9eme are available → 2 links; 7ème is coming_soon → none.
    expect(container.querySelectorAll('a[href="/niveau/$parcoursId"]')).toHaveLength(2);
    expect(screen.getByText(/Bientôt disponible/)).toBeInTheDocument();
    // a tail CTA points to the extras catalogue
    expect(container.querySelector('a[href="/extras"]')).not.toBeNull();
  });
});

describe("ExtrasCatalogue", () => {
  const parcours: CatalogueParcours[] = [
    p({
      id: "concours-9eme",
      name_fr: "Préparation Concours 9ème",
      kind: "concours",
      is_premium: true,
      grade_cycle: "college",
    }),
    p({
      id: "anglais",
      name_fr: "Anglais",
      kind: "libre",
      theme_id: "anglais",
      grade_cycle: null,
      grade_order: null,
    }),
    p({
      id: "culture-generale",
      name_fr: "Culture Générale",
      kind: "libre",
      theme_id: "culture-generale",
      grade_cycle: null,
      grade_order: null,
    }),
  ];

  it("shows only the libre tracks, each linking to its level page", () => {
    const { container } = render(<ExtrasCatalogue parcours={parcours} />);
    expect(screen.getByText("Anglais")).toBeInTheDocument();
    expect(screen.getByText("Culture Générale")).toBeInTheDocument();
    // 3 parcours in, 2 libre → 2 cards/links (the school concours is excluded).
    expect(container.querySelectorAll('a[href="/niveau/$parcoursId"]')).toHaveLength(2);
  });
});
