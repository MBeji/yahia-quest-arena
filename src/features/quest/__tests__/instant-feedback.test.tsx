import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

// ---- Mêmes doublures que exercise-player.test.tsx (harnais de rendu du lecteur) ----
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
  useNavigate: () => vi.fn(),
  createLink:
    (Comp: React.ComponentType<Record<string, unknown>>) =>
    ({ to, params: _params, ...rest }: { to: string; params?: unknown }) =>
      React.createElement(Comp, { ...rest, href: to }),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("../quest.training", () => ({ getTrainingForMisconception: vi.fn() }));

const { mockGetExercise, mockGetSubject } = vi.hoisted(() => ({
  mockGetExercise: vi.fn(),
  mockGetSubject: vi.fn(),
}));
vi.mock("@/features/quest", () => ({
  getExercise: (args: unknown) => mockGetExercise(args),
  getSubject: (args: unknown) => mockGetSubject(args),
  computeNextExerciseId: () => null,
}));

vi.mock("motion/react", () => ({
  motion: new Proxy(
    {},
    {
      get:
        (_t, prop: string) =>
        ({ children, ...props }: Record<string, unknown>) =>
          React.createElement(prop, props, children as React.ReactNode),
    },
  ),
  AnimatePresence: ({ children }: { children: React.ReactNode }) => children,
  useReducedMotion: () => false,
}));
vi.mock("@/components/ui/svg-figure", () => ({
  RichField: ({ raw, as = "div" }: { raw: string; as?: string }) =>
    React.createElement(as, null, raw),
  OptionContent: ({ raw }: { raw: string }) => React.createElement("span", null, raw),
}));
vi.mock("@/components/ui/level-up-celebration", () => ({ LevelUpCelebration: () => null }));
vi.mock("@/components/ui/explain-hint", () => ({
  ExplainHint: ({ children }: { children: React.ReactNode }) => children,
}));
vi.mock("@/features/quest/components/confetti", () => ({ Confetti: () => null }));
vi.mock("@/shared/lib/utils", async (importOriginal) => ({
  ...(await importOriginal<typeof import("@/shared/lib/utils")>()),
  isRtlText: () => false,
  isMathExpression: () => false,
}));
vi.mock("sonner", () => ({ toast: { error: vi.fn(), success: vi.fn() } }));

import {
  ExercisePlayer,
  type ExercisePlayerStrategy,
  type PlayerResult,
} from "@/features/quest/components/exercise-player";

const EXERCISE_ID = "ex-1";

function exerciseData(mode = "practice") {
  return {
    exercise: {
      id: EXERCISE_ID,
      mode,
      title: "Test Exercise",
      subject_id: "subj-1",
      chapter_id: "ch-1",
      subjects: { content_language: "fr" },
    },
    questions: [
      {
        id: "q1",
        prompt: "1 + 1 ?",
        options: [
          { id: "a", text: "2" },
          { id: "b", text: "3" },
        ],
      },
      {
        id: "q2",
        prompt: "2 + 2 ?",
        options: [
          { id: "a", text: "4" },
          { id: "b", text: "5" },
        ],
      },
    ],
    hintCharges: 0,
    chapterQuizId: "quiz-1",
    quizGated: false,
  };
}

const neutralResult: PlayerResult = {
  correct: 2,
  total: 2,
  scorePct: 100,
  durationSeconds: 30,
  reviewHidden: true,
  review: [],
  xpEarned: 0,
  coinsEarned: 0,
  profile: null,
  unlockedBadges: [],
  potionApplied: null,
  retryShieldUsed: false,
  tooFast: false,
  improved: false,
  speedBonus: 1,
};

function strategyWith(overrides: Partial<ExercisePlayerStrategy> = {}): ExercisePlayerStrategy {
  return {
    capabilities: { rewards: false, hints: false, boss: false, next: false, instantFeedback: true },
    quizExerciseTo: "/exercice/$exerciseId",
    homeTo: "/",
    startSession: vi.fn().mockResolvedValue({ ok: true, sessionId: "s-1" }),
    submit: vi.fn().mockResolvedValue(neutralResult),
    checkAnswer: vi.fn().mockResolvedValue({
      questionId: "q1",
      isCorrect: true,
      correctChoice: "a",
      explanation: null,
    }),
    renderResultFooter: () => <div data-testid="footer">footer</div>,
    ...overrides,
  };
}

function renderPlayer(strategy: ExercisePlayerStrategy) {
  const qc = new QueryClient({
    defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
  });
  return render(
    <QueryClientProvider client={qc}>
      <ExercisePlayer exerciseId={EXERCISE_ID} strategy={strategy} variant="classic" />
    </QueryClientProvider>,
  );
}

describe("ExercisePlayer — retour immédiat par question (levier 01)", () => {
  beforeEach(() => {
    mockGetExercise.mockReset().mockResolvedValue(exerciseData());
    mockGetSubject.mockReset().mockResolvedValue({ chapters: [], exercises: [] });
  });

  it("valide sans avancer : le verdict s'affiche, la question ne change pas", async () => {
    const checkAnswer = vi.fn().mockResolvedValue({
      questionId: "q1",
      isCorrect: true,
      correctChoice: "a",
      explanation: "Deux, évidemment.",
    });
    renderPlayer(strategyWith({ checkAnswer }));

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));

    const verdict = await screen.findByTestId("quest-feedback");
    expect(verdict).toHaveAttribute("data-correct", "true");
    expect(screen.getByText("Deux, évidemment.")).toBeInTheDocument();
    // Toujours la première question — rien n'a avancé.
    expect(screen.getByText("1 + 1 ?")).toBeInTheDocument();
    expect(checkAnswer).toHaveBeenCalledWith({
      exerciseId: EXERCISE_ID,
      questionId: "q1",
      choice: "a",
    });
  });

  it("« Continuer » enchaîne sur la question suivante", async () => {
    renderPlayer(strategyWith());

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));
    await screen.findByTestId("quest-feedback");
    fireEvent.click(screen.getByTestId("quest-submit"));

    expect(await screen.findByText("2 + 2 ?")).toBeInTheDocument();
    expect(screen.queryByTestId("quest-feedback")).not.toBeInTheDocument();
  });

  it("fige la réponse : les options sont verrouillées et c'est le choix validé qui est soumis", async () => {
    const submit = vi.fn().mockResolvedValue(neutralResult);
    const checkAnswer = vi.fn().mockResolvedValue({
      questionId: "q",
      isCorrect: false,
      correctChoice: "a",
      explanation: null,
    });
    renderPlayer(strategyWith({ submit, checkAnswer }));

    // Q1 : on valide « a » (le texte « 2 »), puis on tente de basculer sur « b ».
    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));
    await screen.findByTestId("quest-feedback");

    const otherOption = screen.getByText("3").closest("button");
    expect(otherOption).toBeDisabled();
    fireEvent.click(otherOption!);

    fireEvent.click(screen.getByTestId("quest-submit")); // continuer
    // Q2 : on valide, puis on termine.
    fireEvent.click(await screen.findByText("4"));
    fireEvent.click(screen.getByTestId("quest-submit"));
    await screen.findByTestId("quest-feedback");
    fireEvent.click(screen.getByTestId("quest-submit"));

    await waitFor(() => expect(submit).toHaveBeenCalled());
    expect(submit.mock.calls[0][0].answers).toEqual([
      { questionId: "q1", choice: "a" },
      { questionId: "q2", choice: "a" },
    ]);
  });

  it("sur une erreur, nomme la bonne réponse dans la liste et garde l'explication", async () => {
    const checkAnswer = vi.fn().mockResolvedValue({
      questionId: "q1",
      isCorrect: false,
      correctChoice: "a",
      explanation: "Un plus un font deux.",
    });
    renderPlayer(strategyWith({ checkAnswer }));

    fireEvent.click(await screen.findByText("3")); // mauvaise option
    fireEvent.click(screen.getByTestId("quest-submit"));

    const verdict = await screen.findByTestId("quest-feedback");
    expect(verdict).toHaveAttribute("data-correct", "false");
    expect(screen.getByText("Un plus un font deux.")).toBeInTheDocument();
  });

  it("compte la série de bonnes réponses et affiche la pastille de combo", async () => {
    renderPlayer(strategyWith());

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));
    await screen.findByTestId("quest-feedback");
    // Une seule bonne réponse : la pastille reste muette.
    expect(screen.queryByTestId("quest-combo")).not.toBeInTheDocument();
    fireEvent.click(screen.getByTestId("quest-submit"));

    fireEvent.click(await screen.findByText("4"));
    fireEvent.click(screen.getByTestId("quest-submit"));
    await screen.findByTestId("quest-feedback");
    expect(await screen.findByTestId("quest-combo")).toHaveTextContent("x2");
  });

  it("verdict indisponible (null) : on enchaîne comme avant ce lot, sans écran d'erreur", async () => {
    const checkAnswer = vi.fn().mockResolvedValue(null);
    renderPlayer(strategyWith({ checkAnswer }));

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));

    expect(await screen.findByText("2 + 2 ?")).toBeInTheDocument();
    expect(screen.queryByTestId("quest-feedback")).not.toBeInTheDocument();
  });

  it("correction en panne : l'élève n'est pas enfermé dans sa question", async () => {
    const checkAnswer = vi.fn().mockRejectedValue(new Error("réseau"));
    renderPlayer(strategyWith({ checkAnswer }));

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));

    expect(await screen.findByText("2 + 2 ?")).toBeInTheDocument();
  });

  it("ne corrige JAMAIS le quiz de compréhension : l'élève s'y valide seul", async () => {
    mockGetExercise.mockResolvedValue(exerciseData("quiz"));
    const checkAnswer = vi.fn();
    renderPlayer(strategyWith({ checkAnswer }));

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));

    expect(await screen.findByText("2 + 2 ?")).toBeInTheDocument();
    expect(checkAnswer).not.toHaveBeenCalled();
  });

  it("sans capacité `instantFeedback`, la boucle reste celle d'avant", async () => {
    const checkAnswer = vi.fn();
    renderPlayer(
      strategyWith({
        capabilities: {
          rewards: false,
          hints: false,
          boss: false,
          next: false,
          instantFeedback: false,
        },
        checkAnswer,
      }),
    );

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));

    expect(await screen.findByText("2 + 2 ?")).toBeInTheDocument();
    expect(checkAnswer).not.toHaveBeenCalled();
  });
});
