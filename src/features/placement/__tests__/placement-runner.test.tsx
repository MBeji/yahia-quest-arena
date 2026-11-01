import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { PlacementRunner } from "../components/placement-runner";
import { readPlacementDraft, writePlacementDraft } from "../placement-memory";

/**
 * Étude 39 — la passation : une question à la fois, SANS correction en cours de route (R-4), un
 * retour en arrière possible, un seul envoi à la fin, et un brouillon qui survit au rechargement
 * (US-8). Le catalogue i18n vient du vrai `usePlacementT` (locale par défaut : fr).
 */
vi.mock("@/lib/i18n/placement", async () => {
  const mod = await vi.importActual<typeof import("@/lib/i18n/placement")>("@/lib/i18n/placement");
  const fr = await import("@/lib/i18n/fr");
  return {
    ...mod,
    usePlacementT: () => ({ ...fr.fr, ...mod.placementTranslations("fr") }),
  };
});

const SESSION = "11111111-1111-4111-8111-111111111111";
const questions = [
  {
    id: "q1",
    chapterId: "c1",
    chapterTitle: "Fractions",
    chapterOrder: 1,
    prompt: "Combien font 1/2 + 1/2 ?",
    options: [
      { id: "a", text: "1" },
      { id: "b", text: "2" },
    ],
    questionType: "mcq",
  },
  {
    id: "q2",
    chapterId: "c2",
    chapterTitle: "Décimaux",
    chapterOrder: 2,
    prompt: "Écris 0,5 + 0,5",
    options: [],
    questionType: "numeric",
  },
];

function mount(over: Partial<Parameters<typeof PlacementRunner>[0]> = {}) {
  const onFinish = vi.fn();
  render(
    <PlacementRunner
      sessionId={SESSION}
      questions={questions}
      contentLanguage="fr"
      finishing={false}
      finishError={null}
      onFinish={onFinish}
      onLeave={vi.fn()}
      {...over}
    />,
  );
  return { onFinish };
}

describe("PlacementRunner", () => {
  beforeEach(() => window.sessionStorage.clear());

  it("montre une question à la fois, et ne corrige rien en cours de route", () => {
    mount();
    expect(screen.getByTestId("placement-progress")).toHaveTextContent("Question 1 sur 2");
    // L'énoncé passe par `RichField`, qui découpe les expressions mathématiques en segments :
    // on lit le titre entier, pas un nœud texte.
    expect(screen.getByRole("heading", { level: 2 })).toHaveTextContent("Combien font");
    expect(screen.getByTestId("placement-runner")).not.toHaveTextContent("Écris 0,5");
    // Aucun verdict, aucune bonne réponse : seulement la promesse que la correction vient à la fin.
    expect(screen.getByText("La correction arrive à la fin, avec ton bilan.")).toBeInTheDocument();
    expect(screen.getByTestId("placement-next")).toBeDisabled();
  });

  it("avance après une réponse, revient en arrière, et rend tout à la fin en un seul envoi", () => {
    const { onFinish } = mount();
    fireEvent.click(screen.getByRole("radio", { name: /1/ }));
    fireEvent.click(screen.getByTestId("placement-next"));
    expect(screen.getByTestId("placement-progress")).toHaveTextContent("Question 2 sur 2");

    fireEvent.click(screen.getByTestId("placement-previous"));
    expect(screen.getByTestId("placement-progress")).toHaveTextContent("Question 1 sur 2");
    // La réponse donnée est gardée.
    expect(screen.getByRole("radio", { name: /1/ })).toHaveAttribute("aria-checked", "true");

    fireEvent.click(screen.getByTestId("placement-next"));
    const input = screen.getByTestId("numeric-answer-input");
    fireEvent.change(input, { target: { value: "abc" } });
    expect(screen.getByTestId("placement-next")).toBeDisabled();
    fireEvent.change(input, { target: { value: "1" } });
    fireEvent.click(screen.getByTestId("placement-next"));

    expect(onFinish).toHaveBeenCalledTimes(1);
    const [answers, duration] = onFinish.mock.calls[0] as [
      Array<{ questionId: string; choice: string }>,
      number,
    ];
    expect(answers).toEqual([
      { questionId: "q1", choice: "a" },
      { questionId: "q2", choice: "1" },
    ]);
    expect(duration).toBeGreaterThanOrEqual(0);
  });

  it("garde un brouillon et le reprend au rechargement (US-8)", () => {
    mount();
    fireEvent.click(screen.getByRole("radio", { name: /2/ }));
    fireEvent.click(screen.getByTestId("placement-next"));
    expect(readPlacementDraft(SESSION)).toEqual({ answers: { q1: "b" }, index: 1 });
  });

  it("au montage, un brouillon existant repose la position et le dit", () => {
    writePlacementDraft(SESSION, { answers: { q1: "a" }, index: 1 });
    mount();
    expect(screen.getByTestId("placement-progress")).toHaveTextContent("Question 2 sur 2");
    expect(screen.getByTestId("placement-resumed")).toBeInTheDocument();
  });

  it("prévient quand on termine avec des questions sans réponse", () => {
    writePlacementDraft(SESSION, { answers: {}, index: 1 });
    mount();
    expect(screen.getByTestId("placement-unanswered")).toBeInTheDocument();
  });

  it("une erreur de correction se lit, et le bouton reste utilisable", () => {
    mount({ finishError: "Impossible de corriger le test. Réessaie." });
    expect(screen.getByRole("alert")).toHaveTextContent("Impossible de corriger");
  });
});
