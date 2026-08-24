import React from "react";
import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import type { WeaknessRow } from "@/shared/types/weakness";

/**
 * Étude 04 lot A2.1 — ce que l'ÉCRAN doit garantir.
 *
 * Trois choses, et la première est celle qu'on casse sans s'en apercevoir :
 *
 *   1. **L'absence n'est pas un vide.** Sans erreur active — l'état de tout
 *      compte neuf — le panneau ne rend RIEN. Un encadré « aucune erreur » sur
 *      un tableau de bord neuf se lirait comme un bulletin.
 *   2. **Le tag n'est jamais affiché** (R-A1.2-1). C'est un identifiant ; la
 *      phrase vient du registre.
 *   3. **Les gestes ne s'inventent pas** : pas de compétence déclarée ⇒ pas de
 *      bouton « S'entraîner » (A12) ; pas de chapitre ⇒ pas de lien vers le cours.
 */

vi.mock("@tanstack/react-router", () => ({
  useNavigate: () => vi.fn(),
  Link: ({ children, ...rest }: { children: React.ReactNode }) => <a {...rest}>{children}</a>,
}));

vi.mock("../progression.server", () => ({
  getCompetencyExercises: vi.fn(async () => []),
}));

const { WeaknessesPanel } = await import("../components/weaknesses-panel");

function row(over: Partial<WeaknessRow> = {}): WeaknessRow {
  return {
    tag: "math.frac.add-denominators",
    label_fr: "Tu additionnes les dénominateurs",
    label_en: "You add the denominators",
    label_ar: "تجمع المقامات",
    competency: "math.frac.add-sous",
    occurrences: 5,
    last_seen_at: "2026-08-22T10:00:00Z",
    chapter_id: "11111111-1111-4111-8111-111111111111",
    chapter_title: "Les fractions",
    subject_id: "math",
    recent_7d: 1,
    previous_7d: 3,
    trend: "improving",
    ...over,
  };
}

describe("WeaknessesPanel — étude 04 A2.1", () => {
  it("ne rend RIEN sans erreur active — l'état normal d'un compte neuf", () => {
    const { container } = render(<WeaknessesPanel weaknesses={[]} />);
    expect(container.textContent).toBe("");
  });

  it("affiche la PHRASE de l'erreur, jamais son tag (R-A1.2-1)", () => {
    const { container } = render(<WeaknessesPanel weaknesses={[row()]} />);
    expect(screen.getByText("Tu additionnes les dénominateurs")).toBeTruthy();
    expect(container.textContent).not.toContain("math.frac.add-denominators");
  });

  it("compte les occurrences et rend la tendance mesurée", () => {
    render(<WeaknessesPanel weaknesses={[row()]} />);
    expect(screen.getByText(/5 fois/)).toBeTruthy();
    expect(screen.getByText(/ça s'améliore/)).toBeTruthy();
  });

  it("n'affiche AUCUNE flèche quand la tendance est stable — une flèche sur deux points ment", () => {
    render(<WeaknessesPanel weaknesses={[row({ trend: "stable" })]} />);
    expect(screen.getByText(/stable/)).toBeTruthy();
    expect(screen.queryByText(/ça s'améliore/)).toBeNull();
    expect(screen.queryByText(/ça revient/)).toBeNull();
  });

  it("propose « S'entraîner » seulement si l'erreur DÉCLARE une compétence (A12)", () => {
    const { rerender } = render(<WeaknessesPanel weaknesses={[row()]} />);
    expect(screen.getByTestId("weakness-train")).toBeTruthy();

    // Une confusion de vocabulaire n'a pas de compétence propre : proposer un
    // exercice au hasard serait pire que ne rien proposer.
    rerender(<WeaknessesPanel weaknesses={[row({ competency: null })]} />);
    expect(screen.queryByTestId("weakness-train")).toBeNull();
  });

  it("propose « revoir le cours » seulement si un chapitre est connu", () => {
    const { rerender } = render(<WeaknessesPanel weaknesses={[row()]} />);
    expect(screen.getByTestId("weakness-course")).toBeTruthy();

    rerender(<WeaknessesPanel weaknesses={[row({ chapter_id: null })]} />);
    expect(screen.queryByTestId("weakness-course")).toBeNull();
  });

  it("liste plusieurs erreurs, dans l'ordre que le serveur a décidé", () => {
    render(
      <WeaknessesPanel
        weaknesses={[
          row({ tag: "a", label_fr: "Première erreur", occurrences: 9 }),
          row({ tag: "b", label_fr: "Deuxième erreur", occurrences: 4 }),
        ]}
      />,
    );
    const items = screen.getAllByTestId("weakness-item");
    expect(items).toHaveLength(2);
    expect(items[0]?.textContent).toContain("Première erreur");
  });
});

/**
 * Étude 11 lot 5 — le SLOT d'entraînement, posé par la route.
 *
 * Ce que ces trois cas gardent, c'est l'indépendance des deux features. Le
 * panneau appartient à `progression` ; le geste d'El Ostedh appartient à
 * `tutor`. Le jour où quelqu'un « simplifiera » en important le second dans le
 * premier, le premier cas ci-dessous continuera de passer — mais le troisième
 * dira que le panneau ne sait plus vivre sans le tuteur, ce qui est la vraie
 * régression (AGENTS.md : une feature n'en importe jamais une autre).
 */
describe("WeaknessesPanel — le slot d'entraînement (étude 11 lot 5)", () => {
  it("rend le slot que la route fournit, une fois par erreur", () => {
    render(
      <WeaknessesPanel
        weaknesses={[row({ tag: "a" }), row({ tag: "b" })]}
        renderPractice={(w) => <button data-testid="slot">slot:{w.tag}</button>}
      />,
    );
    expect(screen.getAllByTestId("slot")).toHaveLength(2);
  });

  it("REMPLACE le bouton « S'entraîner » au lieu de s'y ajouter — un seul chemin (A12)", () => {
    // Deux boutons côte à côte promettant la même chose obligeraient l'élève à
    // choisir entre deux mots qu'il ne peut pas distinguer.
    render(
      <WeaknessesPanel weaknesses={[row()]} renderPractice={() => <button>Entraîne-moi</button>} />,
    );
    expect(screen.queryByTestId("weakness-train")).toBeNull();
  });

  it("s'affiche même SANS compétence déclarée — c'est tout l'apport du slot", () => {
    // L'ancien bouton se taisait faute de compétence ; le tuteur, lui, cible
    // aussi par le TAG. Sans ce cas, la régression serait silencieuse.
    render(
      <WeaknessesPanel
        weaknesses={[row({ competency: null })]}
        renderPractice={() => <button data-testid="slot">Entraîne-moi</button>}
      />,
    );
    expect(screen.getByTestId("slot")).toBeTruthy();
  });

  it("reste utilisable SANS slot — le panneau ne dépend pas du tuteur", () => {
    render(<WeaknessesPanel weaknesses={[row()]} />);
    expect(screen.getByTestId("weakness-train")).toBeTruthy();
    expect(screen.queryByTestId("slot")).toBeNull();
  });
});
