/**
 * « Carte de compétences » — étude 07, lot 4 (US-1, US-2, R-5).
 *
 * Ce que ces tests protègent : la SINCÉRITÉ de la carte. Sous cinq tentatives, on ne montre
 * jamais un chiffre (Q-2 / RISK-2) ; l'état vide invite au lieu de reprocher ; « ce qui te
 * bloque » n'apparaît que lorsqu'il y a un blocage diagnostiqué (R-5) ; et « S'entraîner »
 * mène à un vrai exercice de la compétence (US-2). Les libellés se choisissent dans la langue
 * de l'interface — le serveur en envoie trois.
 */
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";
import React from "react";

import type { CompetencyBlocker, CompetencyMasteryRow } from "@/shared/types/competency";

const navigate = vi.fn();
vi.mock("@tanstack/react-router", () => ({
  useNavigate: () => navigate,
}));

const getCompetencyExercises = vi.fn();
vi.mock("../progression.server", () => ({
  getCompetencyExercises: (args: unknown) => getCompetencyExercises(args),
}));

// Locale par défaut fr ; un test le repasse en ar pour vérifier la mise en langue.
let mockLocale: "fr" | "en" | "ar" = "fr";
vi.mock("@/lib/i18n", async () => {
  const { fr } = await import("@/lib/i18n/fr");
  const { ar } = await import("@/lib/i18n/ar");
  return {
    useI18n: () => ({
      t: mockLocale === "ar" ? ar : fr,
      locale: mockLocale,
      dir: "ltr",
      setLocale: () => {},
    }),
  };
});

import { CompetencyMapPanel } from "../components/competency-map-panel";

function row(overrides: Partial<CompetencyMasteryRow> = {}): CompetencyMasteryRow {
  return {
    competency_id: "c-1",
    slug: "math.frac.add-sous",
    family: "math",
    domain: "frac",
    label_fr: "Additionner des fractions",
    label_en: "Add fractions",
    label_ar: "جمع الكسور",
    mastery: 72,
    attempts: 10,
    recent_result: null,
    ...overrides,
  };
}

function blocker(overrides: Partial<CompetencyBlocker> = {}): CompetencyBlocker {
  return {
    competency_id: "b-1",
    slug: "math.frac.equivalence",
    label_fr: "Fractions égales",
    label_en: "Equivalent fractions",
    label_ar: "الكسور المتساوية",
    mastery: 41,
    depth: 1,
    ...overrides,
  };
}

describe("CompetencyMapPanel", () => {
  it("montre la maîtrise en pourcentage et une barre de progression accessible", () => {
    render(<CompetencyMapPanel map={[row({ mastery: 72 })]} blockers={[]} blockedSlug={null} />);

    expect(screen.getByText("Additionner des fractions")).toBeInTheDocument();
    expect(screen.getByText("72%")).toBeInTheDocument();
    expect(screen.getByRole("progressbar")).toHaveAttribute("aria-valuenow", "72");
  });

  it("cache le score sous cinq tentatives et affiche « en cours d'évaluation » (Q-2/RISK-2)", () => {
    render(
      <CompetencyMapPanel
        map={[row({ mastery: 50, attempts: 3 })]}
        blockers={[]}
        blockedSlug={null}
      />,
    );

    expect(screen.getByText("en cours d'évaluation")).toBeInTheDocument();
    expect(screen.queryByText("50%")).not.toBeInTheDocument();
  });

  it("compose la tendance ▲ quand la réussite récente dépasse la maîtrise", () => {
    render(
      <CompetencyMapPanel
        map={[row({ mastery: 60, recent_result: 90 })]}
        blockers={[]}
        blockedSlug={null}
      />,
    );
    expect(screen.getByLabelText("up")).toBeInTheDocument();
  });

  it("n'affiche aucune tendance quand le mouvement est dans la marge morte ou inconnu", () => {
    render(
      <CompetencyMapPanel
        map={[
          row({ competency_id: "c-flat", slug: "a.b.c", mastery: 60, recent_result: 62 }),
          row({ competency_id: "c-null", slug: "a.b.d", mastery: 60, recent_result: null }),
        ]}
        blockers={[]}
        blockedSlug={null}
      />,
    );
    expect(screen.queryByLabelText("up")).not.toBeInTheDocument();
    expect(screen.queryByLabelText("down")).not.toBeInTheDocument();
  });

  it("invite au lieu de reprocher quand la carte est vide", () => {
    render(<CompetencyMapPanel map={[]} blockers={[]} blockedSlug={null} />);
    expect(
      screen.getByText("Joue quelques exercices et ta carte de compétences s'allumera ici."),
    ).toBeInTheDocument();
    expect(screen.queryByRole("progressbar")).not.toBeInTheDocument();
  });

  it("ne montre « ce qui te bloque » QUE s'il y a un blocage, avec la compétence en échec nommée (R-5)", () => {
    const { rerender } = render(
      <CompetencyMapPanel map={[row()]} blockers={[]} blockedSlug={null} />,
    );
    expect(screen.queryByText(/te bloque/)).not.toBeInTheDocument();

    rerender(
      <CompetencyMapPanel
        map={[
          row({ slug: "math.geo.thales-direct", label_fr: "Thalès", mastery: 40, attempts: 8 }),
        ]}
        blockers={[blocker()]}
        blockedSlug="math.geo.thales-direct"
      />,
    );
    expect(screen.getByText("Ce qui te bloque en Thalès")).toBeInTheDocument();
    expect(screen.getByText("Fractions égales")).toBeInTheDocument();
  });

  it("« S'entraîner » ouvre un exercice réel de la compétence bloquante (US-2)", async () => {
    getCompetencyExercises.mockResolvedValue([
      {
        exercise_id: "ex-42",
        chapter_id: "ch",
        subject_id: "math",
        exercise_title: "T",
        difficulty: 2,
      },
    ]);
    render(
      <CompetencyMapPanel
        map={[row({ slug: "math.geo.thales-direct", mastery: 40, attempts: 8 })]}
        blockers={[blocker({ slug: "math.frac.equivalence" })]}
        blockedSlug="math.geo.thales-direct"
      />,
    );

    await userEvent.click(screen.getByRole("button", { name: /S'entraîner/ }));

    await waitFor(() =>
      expect(getCompetencyExercises).toHaveBeenCalledWith({
        data: { competency: "math.frac.equivalence" },
      }),
    );
    await waitFor(() =>
      expect(navigate).toHaveBeenCalledWith({
        to: "/quest/$exerciseId",
        params: { exerciseId: "ex-42" },
      }),
    );
  });

  it("met les libellés dans la langue de l'interface (arabe)", () => {
    mockLocale = "ar";
    try {
      render(<CompetencyMapPanel map={[row()]} blockers={[]} blockedSlug={null} />);
      expect(screen.getByText("جمع الكسور")).toBeInTheDocument();
      expect(screen.queryByText("Additionner des fractions")).not.toBeInTheDocument();
    } finally {
      mockLocale = "fr";
    }
  });
});
