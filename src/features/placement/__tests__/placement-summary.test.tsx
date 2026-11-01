import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import React from "react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { PlacementSummary } from "../components/placement-summary";
import type { PlacementBilan } from "../placement.server";

/**
 * Étude 39 — le bilan : la note et la bande (R-5, R-6), ce qui tient d'abord (R-7), par où
 * commencer (R-8), ce que le compte ouvre — annoncé, jamais tu (D-5, R-11) — et aucune
 * invitation tant que la session n'est pas lue (é38 R-6).
 */
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
    search,
    onClick,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
    search?: Record<string, string>;
    onClick?: () => void;
  }) => {
    let href = to;
    for (const [k, v] of Object.entries(params ?? {})) href = href.replace(`$${k}`, v);
    if (search) href += `?${new URLSearchParams(search).toString()}`;
    return React.createElement("a", { href, onClick, ...rest }, children);
  },
}));
vi.mock("@/lib/i18n/placement", async () => {
  const mod = await vi.importActual<typeof import("@/lib/i18n/placement")>("@/lib/i18n/placement");
  const fr = await import("@/lib/i18n/fr");
  return { ...mod, usePlacementT: () => ({ ...fr.fr, ...mod.placementTranslations("fr") }) };
});
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: "fr" }), useT: () => ({}) }));

const bilan: PlacementBilan = {
  id: "11111111-1111-4111-8111-111111111111",
  status: "completed",
  audience: "student",
  startedAt: "2026-11-01T10:00:00Z",
  finishedAt: "2026-11-01T10:05:00Z",
  subject: {
    id: "math",
    nameFr: "Mathématiques",
    contentLanguage: "fr",
    gradeNameFr: "9ᵉ année",
    gradeSlug: "9eme-base",
    parcoursId: "concours-9eme",
  },
  correct: 7,
  total: 10,
  scoreOn20: 14,
  band: "en-route",
  durationSeconds: 300,
  tooFast: false,
  chapters: [
    {
      chapterId: "c2",
      title: "Angles",
      displayOrder: 2,
      correct: 0,
      total: 1,
      held: false,
      hasLesson: true,
    },
    {
      chapterId: "c1",
      title: "Fractions",
      displayOrder: 1,
      correct: 2,
      total: 2,
      held: true,
      hasLesson: true,
    },
    {
      chapterId: "c3",
      title: "Thalès",
      displayOrder: 3,
      correct: 1,
      total: 2,
      held: false,
      hasLesson: false,
    },
  ],
  firstToReview: { chapterId: "c2", title: "Angles" },
  percentile: { candidates: 3, minCandidates: 20, percentile: null },
  review: [
    {
      questionId: "q1",
      chapterId: "c2",
      prompt: "Un angle droit mesure ?",
      options: [
        { id: "a", text: "90°" },
        { id: "b", text: "180°" },
      ],
      questionType: "mcq",
      selectedChoice: "b",
      isCorrect: false,
      correctChoice: "a",
      explanation: null,
      misconception: null,
    },
  ],
  insightsLocked: true,
};

function mount(over: Partial<React.ComponentProps<typeof PlacementSummary>> = {}) {
  const onShared = vi.fn();
  const onInviteClick = vi.fn();
  render(
    <PlacementSummary
      bilan={bilan}
      isAuthenticated={false}
      authLoading={false}
      onShared={onShared}
      onInviteClick={onInviteClick}
      {...over}
    />,
  );
  return { onShared, onInviteClick };
}

describe("PlacementSummary", () => {
  beforeEach(() => vi.clearAllMocks());

  it("la note sur 20, la bande nommée, le rang en attente sous vingt participants", () => {
    mount();
    expect(screen.getByTestId("placement-score")).toHaveTextContent("14/20");
    expect(screen.getByTestId("placement-band")).toHaveTextContent("En bonne voie");
    expect(screen.getByTestId("placement-percentile")).toHaveTextContent(
      "à partir de 20 participants",
    );
    expect(screen.queryByTestId("placement-too-fast")).not.toBeInTheDocument();
  });

  it("ce qui tient d'abord, puis à revoir dans l'ordre du programme, et par où commencer", () => {
    mount();
    const links = screen.getAllByRole("link", { name: /Angles|Thalès|Fractions/ });
    // « Angles » a un cours : c'est un lien ; « Thalès » n'en a pas : un simple texte.
    expect(links.some((l) => l.getAttribute("href") === "/chapitre/c2")).toBe(true);
    expect(screen.getByText("Thalès").closest("a")).toBeNull();
    expect(screen.getByTestId("placement-start-with")).toHaveAttribute("href", "/chapitre/c2");
    expect(screen.getByTestId("placement-start-with")).toHaveTextContent("Angles");
  });

  it("sans compte : la bonne réponse se voit, et ce que le compte ouvre est annoncé", () => {
    const { onInviteClick } = mount();
    expect(screen.getByText("90°")).toBeInTheDocument();
    expect(screen.queryByTestId("placement-explanation")).not.toBeInTheDocument();
    const invite = screen.getByTestId("placement-invite");
    expect(invite).toHaveTextContent("ce bilan t'appartient");
    fireEvent.click(screen.getByRole("link", { name: "Créer mon compte gratuit" }));
    expect(onInviteClick).toHaveBeenCalledTimes(1);
  });

  it("le propriétaire lit l'explication et l'erreur nommée, et va voir son Hall", () => {
    mount({
      isAuthenticated: true,
      bilan: {
        ...bilan,
        insightsLocked: false,
        review: [
          {
            ...bilan.review[0],
            explanation: "Un angle droit, c'est un quart de tour.",
            misconception: {
              tag: "t",
              labelFr: "Tu confonds droit et plat",
              labelEn: "x",
              labelAr: "y",
            },
          },
        ],
      },
    });
    expect(screen.getByTestId("placement-explanation")).toHaveTextContent("quart de tour");
    expect(screen.getByTestId("placement-misconception")).toHaveTextContent(
      "Tu confonds droit et plat",
    );
    expect(screen.getByTestId("placement-see-hall")).toHaveAttribute("href", "/dashboard");
    expect(screen.queryByTestId("placement-invite")).not.toBeInTheDocument();
  });

  it("tant que la session n'est pas lue, aucune invitation (é38 R-6)", () => {
    mount({ authLoading: true });
    expect(screen.queryByTestId("placement-invite")).not.toBeInTheDocument();
    expect(screen.queryByTestId("placement-see-hall")).not.toBeInTheDocument();
  });

  it("le parent a sa suite : le suivi, et le compte de son enfant", () => {
    mount({ bilan: { ...bilan, audience: "parent" } });
    expect(screen.getByTestId("placement-invite-parent")).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Découvrir le suivi parent" })).toHaveAttribute(
      "href",
      "/suivi",
    );
  });

  it("bâclé : la note s'affiche quand même, avec la phrase qui invite à refaire", () => {
    mount({ bilan: { ...bilan, tooFast: true } });
    expect(screen.getByTestId("placement-too-fast")).toHaveTextContent("très vite");
  });

  it("partager : la copie quand la feuille manque, et la mesure dit la méthode", async () => {
    const writeText = vi.fn().mockResolvedValue(undefined);
    Object.assign(navigator, { clipboard: { writeText } });
    const { onShared } = mount();
    fireEvent.click(screen.getByTestId("placement-copy"));
    await waitFor(() => expect(onShared).toHaveBeenCalledWith("copy"));
    expect(writeText.mock.calls[0]?.[0]).toContain("14/20");
    expect(writeText.mock.calls[0]?.[0]).toContain("/test-de-niveau?matiere=math");
    expect(screen.getByTestId("placement-copy")).toHaveTextContent("Copié !");
  });
});
