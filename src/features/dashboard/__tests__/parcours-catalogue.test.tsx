import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import {
  LyceeYearSections,
  ProgrammeCatalogue,
  ExtrasCatalogue,
  type CatalogueParcours,
} from "../components/parcours-catalogue";
import type { ParcoursInterestState } from "../use-parcours-interest";

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

  it("shows the real « N matières » volumetry on an available class (étude 15 lot 8)", () => {
    render(
      <ProgrammeCatalogue
        parcours={[
          p({
            id: "ecole-1ere-base",
            name_fr: "1ère année de base",
            grade_cycle: "primaire",
            grade_order: 1,
            subjects_count: 5,
          }),
        ]}
      />,
    );
    expect(screen.getByText(/5 matières/)).toBeInTheDocument();
  });
});

describe("ProgrammeCatalogue — lycée drill-down (étude 16 R-1/R-2)", () => {
  const lycee: CatalogueParcours[] = [
    p({
      id: "ecole-1ere-sec",
      name_fr: "1ère année secondaire",
      grade_cycle: "secondaire",
      grade_order: 10,
      grade_slug: "1ere-sec",
      grade_selectable: true,
    }),
    p({
      id: "concours-bac", // flat legacy node → hidden (R-1)
      name_fr: "Préparation Concours Bac",
      kind: "concours",
      grade_cycle: "secondaire",
      grade_order: 13,
      grade_slug: "bac",
      grade_selectable: false,
    }),
    p({
      id: "concours-bac-math",
      name_fr: "Bac Mathématiques",
      kind: "concours",
      grade_cycle: "secondaire",
      grade_order: 24,
      grade_slug: "bac-math",
      grade_selectable: true,
    }),
    p({
      id: "concours-bac-lettres",
      name_fr: "Bac Lettres",
      kind: "concours",
      grade_cycle: "secondaire",
      grade_order: 26,
      grade_slug: "bac-lettres",
      grade_selectable: true,
      status: "coming_soon",
    }),
  ];

  it("renders the 1ère as a direct card and each section year as ONE drill-down row", () => {
    const { container } = render(<ProgrammeCatalogue parcours={lycee} />);
    // 1ère sec links straight to its level page.
    expect(screen.getByText("1ère année secondaire")).toBeInTheDocument();
    // The bac sections never unfold here — one « Baccalauréat » row links to the year page.
    expect(screen.getByText("Baccalauréat")).toBeInTheDocument();
    expect(screen.getByText("2 sections · 1 disponibles")).toBeInTheDocument();
    expect(container.querySelectorAll('a[href="/programme/lycee/$annee"]')).toHaveLength(1);
    expect(screen.queryByText("Bac Mathématiques")).not.toBeInTheDocument();
  });

  it("hides the flat legacy secondary nodes everywhere (R-1)", () => {
    render(<ProgrammeCatalogue parcours={lycee} />);
    expect(screen.queryByText(/Préparation Concours Bac/)).not.toBeInTheDocument();
  });
});

describe("LyceeYearSections — public year page (étude 16 D-5/D-7)", () => {
  const interest: ParcoursInterestState = {
    counts: { "concours-bac-lettres": 17 },
    mine: new Set<string>(),
    togglingId: null,
    onToggle: vi.fn(),
  };
  const sections: CatalogueParcours[] = [
    p({
      id: "concours-bac-math",
      name_fr: "Bac Mathématiques",
      kind: "concours",
      grade_cycle: "secondaire",
      grade_slug: "bac-math",
      grade_selectable: true,
    }),
    p({
      id: "concours-bac-lettres",
      name_fr: "Bac Lettres",
      kind: "concours",
      grade_cycle: "secondaire",
      grade_slug: "bac-lettres",
      grade_selectable: true,
      status: "coming_soon",
    }),
  ];

  it("links available sections, shows the interest count on coming-soon ones", () => {
    const { container } = render(
      <LyceeYearSections year="bac" sections={sections} interest={interest} />,
    );
    expect(screen.getByRole("heading", { name: /Baccalauréat/ })).toBeInTheDocument();
    // available → /niveau link (compacted concours label)
    expect(container.querySelectorAll('a[href="/niveau/$parcoursId"]')).toHaveLength(1);
    expect(screen.getByText("Bac Mathématiques")).toBeInTheDocument();
    // coming_soon → badge + live public count (D-7) + vote button
    expect(screen.getByText(/Bientôt disponible/)).toBeInTheDocument();
    expect(screen.getByText(/17 intéressé/)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Ça m'intéresse/ })).toBeInTheDocument();
    // breadcrumb back to the catalogue
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
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
    p({
      id: "arabe",
      name_fr: "Arabe",
      kind: "libre",
      theme_id: "arabe",
      grade_cycle: null,
      grade_order: null,
    }),
  ];

  it("shows only the libre tracks, each linking to its level page", () => {
    const { container } = render(<ExtrasCatalogue parcours={parcours} />);
    expect(screen.getByText("Anglais")).toBeInTheDocument();
    expect(screen.getByText("Culture Générale")).toBeInTheDocument();
    // 4 parcours in, 3 libre, but the Arabic track is excluded → 2 cards/links.
    expect(container.querySelectorAll('a[href="/niveau/$parcoursId"]')).toHaveLength(2);
  });

  it("excludes the Arabic language track from the extras menu", () => {
    render(<ExtrasCatalogue parcours={parcours} />);
    expect(screen.queryByText("Arabe")).not.toBeInTheDocument();
  });

  it("gives each extra a theme-specific descriptor (CECRL for languages) (étude 15 lot 8)", () => {
    render(<ExtrasCatalogue parcours={parcours} />);
    // anglais → CECRL promise; culture générale → its own descriptor.
    expect(screen.getByText(/aligné CECRL/)).toBeInTheDocument();
    expect(screen.getByText(/en trois langues/)).toBeInTheDocument();
    // the generic « Cours · résumés · exercices » subtext is gone for these cards.
    expect(screen.queryByText("Cours · résumés · exercices")).not.toBeInTheDocument();
  });
});
