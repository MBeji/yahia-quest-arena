import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

// ---- Mocks for the data/presentation layers (mirrors the other quest tests) ----
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
  // BackLink (primitive du lot 1) est construit avec createLink.
  createLink:
    (Comp: React.ComponentType<Record<string, unknown>>) =>
    ({ to, params: _params, ...rest }: { to: string; params?: unknown }) =>
      React.createElement(Comp, { ...rest, href: to }),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
}));

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
  // useEntrance (module motion du lot 1) lit la préférence via ce hook.
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
    ],
    hintCharges: 0,
    chapterQuizId: "quiz-1",
    quizGated: true,
  };
}

const neutralResult: PlayerResult = {
  correct: 1,
  total: 1,
  scorePct: 100,
  durationSeconds: 12,
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
};

function anonStrategy(overrides: Partial<ExercisePlayerStrategy> = {}): ExercisePlayerStrategy {
  return {
    capabilities: { rewards: false, hints: false, boss: false, next: false },
    quizExerciseTo: "/exercice/$exerciseId",
    homeTo: "/",
    startSession: vi.fn().mockResolvedValue({ ok: true, sessionId: "anon" }),
    submit: vi.fn().mockResolvedValue(neutralResult),
    renderResultFooter: () => <div data-testid="footer">footer</div>,
    ...overrides,
  };
}

function renderPlayer(strategy: ExercisePlayerStrategy, variant: "classic" | "recall" = "classic") {
  const qc = new QueryClient({
    defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
  });
  return render(
    <QueryClientProvider client={qc}>
      <ExercisePlayer exerciseId={EXERCISE_ID} strategy={strategy} variant={variant} />
    </QueryClientProvider>,
  );
}

describe("ExercisePlayer", () => {
  beforeEach(() => {
    mockGetExercise.mockReset().mockResolvedValue(exerciseData());
    mockGetSubject.mockReset().mockResolvedValue({ chapters: [], exercises: [] });
  });

  it("renders the first question once the exercise loads and the session starts", async () => {
    renderPlayer(anonStrategy());
    expect(await screen.findByText("1 + 1 ?")).toBeInTheDocument();
    expect(screen.getByTestId("quest-submit")).toBeInTheDocument();
    // Options are rendered as radios.
    expect(screen.getAllByRole("radio")).toHaveLength(2);
  });

  it("shows the quiz-lock screen (anon) when the gate blocks a non-quiz exercise", async () => {
    const strategy = anonStrategy({
      startSession: vi.fn().mockResolvedValue({ ok: false, kind: "quiz" }),
    });
    const { container } = renderPlayer(strategy);
    // The take-quiz CTA routes to the PUBLIC quiz flow, not the connected one.
    await waitFor(() =>
      expect(container.querySelector('a[href="/exercice/$exerciseId"]')).not.toBeNull(),
    );
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).toBeNull();
  });

  it("plays to the result screen and shows the score without rewards (anon)", async () => {
    const submit = vi.fn().mockResolvedValue(neutralResult);
    renderPlayer(anonStrategy({ submit }));

    fireEvent.click(await screen.findByText("2")); // select option "a"
    fireEvent.click(screen.getByTestId("quest-submit")); // single question → finishes

    expect(await screen.findByTestId("quest-score")).toBeInTheDocument();
    expect(screen.getByTestId("footer")).toBeInTheDocument();
    // Anonymous: no XP/badges reward UI.
    expect(screen.queryByText(/badgesUnlocked|XP/)).not.toBeInTheDocument();
    expect(submit).toHaveBeenCalledWith(
      expect.objectContaining({ exerciseId: EXERCISE_ID, isQuiz: false, totalQuestions: 1 }),
    );
  });

  it("renders the reward grid on the result screen when rewards are enabled", async () => {
    const rewardResult: PlayerResult = {
      ...neutralResult,
      xpEarned: 120,
      coinsEarned: 20,
      profile: { level: 5, xp: 1000, current_streak: 3, hero_class: "Mage" },
    };
    const strategy = anonStrategy({
      capabilities: { rewards: true, hints: false, boss: false, next: false },
      submit: vi.fn().mockResolvedValue(rewardResult),
    });
    renderPlayer(strategy);

    fireEvent.click(await screen.findByText("2"));
    fireEvent.click(screen.getByTestId("quest-submit"));

    expect(await screen.findByTestId("quest-score")).toBeInTheDocument();
    // The reward grid surfaces the earned XP amount.
    expect(screen.getByText(/120/)).toBeInTheDocument();
  });
});

describe("ExercisePlayer — recall variant (étude 17)", () => {
  beforeEach(() => {
    mockGetExercise.mockReset().mockResolvedValue(exerciseData());
    mockGetSubject.mockReset().mockResolvedValue({ chapters: [], exercises: [] });
  });

  it("replays a mastered mission as free text: banner shown, options gone, no hint button", async () => {
    const strategy = anonStrategy({
      capabilities: { rewards: true, hints: true, boss: false, next: false },
    });
    renderPlayer(strategy, "recall");

    expect(await screen.findByTestId("recall-banner")).toBeInTheDocument();
    // The free-text input replaces the radiogroup options (R-8).
    expect(screen.getByTestId("recall-answer-input")).toBeInTheDocument();
    expect(screen.queryAllByRole("radio")).toHaveLength(0);
    // The variant is threaded to the data + session layers.
    expect(mockGetExercise).toHaveBeenCalledWith(
      expect.objectContaining({ data: expect.objectContaining({ variant: "recall" }) }),
    );
  });

  it("surfaces the recall lock screen when the mission is not yet mastered", async () => {
    const strategy = anonStrategy({
      startSession: vi.fn().mockResolvedValue({ ok: false, kind: "recall", reason: "locked" }),
    });
    const { container } = renderPlayer(strategy, "recall");
    // The lock reuses the quiz-lock CTA (replay in QCM), never the recall run.
    await waitFor(() =>
      expect(container.querySelector('a[href="/exercice/$exerciseId"]')).not.toBeNull(),
    );
    expect(screen.queryByTestId("recall-answer-input")).not.toBeInTheDocument();
  });
});
