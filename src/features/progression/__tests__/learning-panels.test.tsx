/**
 * Le repli R-6 — le test le plus important du lot 3 (étude 30).
 *
 * « Sur une matière non taggée, l'écran est IDENTIQUE à celui d'aujourd'hui » est un critère
 * d'acceptation, pas une intention. Ici il devient exécutable : quand `get_learning_state`
 * rend zéro ligne, l'élève doit retrouver la carte de é07 lot 4, servie par sa RPC intacte —
 * et surtout PAS un état vide flambant neuf qui remplacerait un écran qui marchait.
 *
 * L'autre moitié : quand il y a de quoi la nourrir, la carte à 4 états prend la place, et
 * l'ancienne disparaît. Un produit qui montrerait les deux dirait deux choses de la même
 * compétence — exactement le défaut que é22 a corrigé sur « qu'est-ce que je fais maintenant ».
 */
import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

import type { LearningFrontierRow, LearningStateRow } from "@/shared/types/competency";

let stateRows: LearningStateRow[] = [];
let frontierRows: LearningFrontierRow[] = [];

vi.mock("@tanstack/react-query", () => ({
  useQuery: ({ queryKey }: { queryKey: unknown[] }) => ({
    data: queryKey[0] === "learning-state" ? stateRows : frontierRows,
  }),
}));
vi.mock("@tanstack/react-start", () => ({
  useServerFn: () => () => Promise.resolve([]),
}));
vi.mock("@tanstack/react-router", () => ({ useNavigate: () => vi.fn() }));
vi.mock("../progression.server", () => ({
  getLearningState: vi.fn(),
  getLearningFrontier: vi.fn(),
  getCompetencyExercises: vi.fn(() => Promise.resolve([])),
  disputeInference: vi.fn(() => Promise.resolve({ disputed: true })),
}));
vi.mock("@/lib/i18n", async () => {
  const { fr } = await import("@/lib/i18n/fr");
  return {
    useI18n: () => ({ t: fr, locale: "fr", dir: "ltr", setLocale: () => {} }),
  };
});

import { LearningPanels } from "../components/learning-panels";

const legacyRow = {
  competency_id: "c-legacy",
  slug: "math.frac.legacy",
  family: "math",
  domain: "frac",
  label_fr: "Ancienne carte",
  label_en: "Legacy",
  label_ar: "قديم",
  mastery: 72,
  attempts: 10,
  recent_result: null,
};

beforeEach(() => {
  stateRows = [];
  frontierRows = [];
});

describe("LearningPanels — le repli R-6", () => {
  it("sans croyance, rend l'ANCIENNE carte de é07 — l'écran d'aujourd'hui, intact", () => {
    render(<LearningPanels map={[legacyRow]} blockers={[]} blockedSlug={null} />);
    expect(screen.getByText("Ancienne carte")).toBeInTheDocument();
    // Et surtout pas l'état vide de la nouvelle : remplacer un écran qui marche par une
    // invitation à jouer serait une régression déguisée en nouveauté.
    expect(screen.queryByText("Où tu en es")).not.toBeInTheDocument();
  });

  it("avec des croyances, la carte à 4 états prend la place de l'ancienne", () => {
    stateRows = [
      {
        competency_id: "c-1",
        slug: "math.frac.add",
        family: "math",
        domain: "frac",
        label_fr: "Additionner",
        label_en: "Add",
        label_ar: "جمع",
        state: "fragile",
        zone: "frontiere",
        p_known: 0.42,
        evidence_count: 2,
        sessions_seen: 1,
        forms_count: 1,
        belief_source: "evidence",
        suspect: false,
      },
    ];
    render(<LearningPanels map={[legacyRow]} blockers={[]} blockedSlug={null} />);
    expect(screen.getByText("Où tu en es")).toBeInTheDocument();
    expect(screen.getByText("Additionner")).toBeInTheDocument();
    // Les deux cartes ensemble diraient deux choses de la même compétence.
    expect(screen.queryByText("Ancienne carte")).not.toBeInTheDocument();
  });

  it("sans frontière, aucun panneau « prêt à apprendre » ne s'affiche", () => {
    render(<LearningPanels map={[legacyRow]} blockers={[]} blockedSlug={null} />);
    expect(screen.queryByText("Prêt à apprendre")).not.toBeInTheDocument();
  });

  it("avec une frontière, elle s'affiche AU-DESSUS de la carte", () => {
    frontierRows = [
      {
        competency_id: "f-1",
        slug: "math.prop.quatrieme",
        label_fr: "Quatrième proportionnelle",
        label_en: "Fourth",
        label_ar: "رابع",
        state: "en-cours",
        p_known: 0.6,
        unlocks: 2,
        entry_exercise_id: "ex-1",
        entry_subject_id: "math-9",
        entry_odds: 0.7,
      },
    ];
    const { container } = render(
      <LearningPanels map={[legacyRow]} blockers={[]} blockedSlug={null} />,
    );
    const text = container.textContent ?? "";
    expect(text.indexOf("Prêt à apprendre")).toBeGreaterThanOrEqual(0);
    expect(text.indexOf("Prêt à apprendre")).toBeLessThan(text.indexOf("Ancienne carte"));
  });
});
