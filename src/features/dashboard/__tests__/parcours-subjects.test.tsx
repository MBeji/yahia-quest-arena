import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { ParcoursSubjects } from "../components/parcours-subjects";

const subjects = [
  {
    id: "s1",
    name_fr: "Mathématiques",
    attribute: "Sciences",
    description: null,
    content_language: "fr",
  },
  { id: "s2", name_fr: "SVT", attribute: null, description: null, content_language: "fr" },
];

describe("ParcoursSubjects", () => {
  it("lists each subject linking to its public hub, with a back link to the programme", () => {
    const { container } = render(
      <ParcoursSubjects
        parcours={{ name_fr: "Préparation Concours 9ème", status: "available", kind: "concours" }}
        subjects={subjects}
      />,
    );
    expect(
      screen.getByRole("heading", { level: 1, name: "Préparation Concours 9ème" }),
    ).toBeInTheDocument();
    expect(container.querySelectorAll('a[href="/matiere/$subjectId"]')).toHaveLength(2);
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
  });

  it("links back to extras for a libre track", () => {
    const { container } = render(
      <ParcoursSubjects
        parcours={{ name_fr: "Anglais", status: "available", kind: "libre" }}
        subjects={subjects}
      />,
    );
    expect(container.querySelector('a[href="/extras"]')).not.toBeNull();
  });

  it("shows a 'bientôt' state when the level has no subjects yet", () => {
    render(
      <ParcoursSubjects
        parcours={{ name_fr: "7ème année de base", status: "coming_soon", kind: "scolaire" }}
        subjects={[]}
      />,
    );
    expect(screen.getByText(/Contenu bientôt disponible/)).toBeInTheDocument();
  });

  it("annonce le reste du programme en cartes « bientôt », jamais cliquables", () => {
    const { container } = render(
      <ParcoursSubjects
        parcours={{ name_fr: "9ème année de base", status: "available", kind: "scolaire" }}
        subjects={subjects}
        soon={[
          { id: "histoire-geo-9eme", name: "المواد الاجتماعية", contentLanguage: "ar" },
          { id: "informatique-9eme", name: "الإعلامية", contentLanguage: "ar" },
        ]}
      />,
    );
    expect(screen.getByText("المواد الاجتماعية")).toBeInTheDocument();
    expect(screen.getByText("الإعلامية")).toBeInTheDocument();
    // Les deux matières ouvertes restent les seuls liens de la page.
    expect(container.querySelectorAll('a[href="/matiere/$subjectId"]')).toHaveLength(2);
    expect(container.querySelectorAll('[aria-disabled="true"]')).toHaveLength(2);
  });

  it("annonce le programme même quand la classe n'a encore aucune matière ouverte", () => {
    render(
      <ParcoursSubjects
        parcours={{ name_fr: "2ème Lettres", status: "coming_soon", kind: "scolaire" }}
        subjects={[]}
        soon={[{ id: "math-2eme-sec-lettres", name: "Mathématiques", contentLanguage: "fr" }]}
      />,
    );
    expect(screen.getByText(/Contenu bientôt disponible/)).toBeInTheDocument();
    expect(screen.getByText("Mathématiques")).toBeInTheDocument();
  });

  // Le geste que l'élève de 8ᵉ vient chercher pour rejoindre sa 9ᵉ (#776) : hors fenêtre de
  // rentrée, cette page est la SEULE à porter le changement de classe. Elle n'était pas testée.
  it("offre de basculer sur ce parcours quand on est connecté", async () => {
    const onChoose = vi.fn();
    render(
      <ParcoursSubjects
        parcours={{ name_fr: "Préparation Concours 9ème", status: "available", kind: "concours" }}
        subjects={subjects}
        isAuthenticated
        onChoose={onChoose}
      />,
    );
    const cta = screen.getByRole("button", { name: /Choisir ce parcours/ });
    await userEvent.click(cta);
    expect(onChoose).toHaveBeenCalledTimes(1);
  });

  it("ne propose pas la bascule à un visiteur anonyme", () => {
    render(
      <ParcoursSubjects
        parcours={{ name_fr: "Préparation Concours 9ème", status: "available", kind: "concours" }}
        subjects={subjects}
        onChoose={vi.fn()}
      />,
    );
    expect(screen.queryByRole("button", { name: /Choisir ce parcours/ })).toBeNull();
  });
});
