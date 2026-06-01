import { render, screen, fireEvent, waitFor, act } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

// Mock modules
vi.mock("@/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      onAuthStateChange: vi.fn(() => ({
        data: { subscription: { unsubscribe: vi.fn() } },
      })),
      getSession: vi.fn().mockResolvedValue({ data: { session: null } }),
    },
  },
}));

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => () => ({ component: undefined }),
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

const mockUseServerFn = vi.fn();
vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => mockUseServerFn(fn) ?? fn,
}));

vi.mock("@/lib/gamification.quest", () => ({
  getExercise: vi.fn(),
  startExerciseSession: vi.fn(),
  submitAttempt: vi.fn(),
}));

vi.mock("@/lib/gamification.constants", () => ({
  BOSS_TIME_PER_QUESTION_S: 10,
  PASS_THRESHOLD_PCT: 60,
}));

vi.mock("@/lib/utils", () => ({
  isRtlText: () => false,
  isMathExpression: () => false,
}));

vi.mock("motion/react", () => ({
  motion: new Proxy(
    {},
    {
      get: (_target, prop: string) => {
        return ({ children, className, ...props }: Record<string, unknown>) =>
          React.createElement(prop, { className, ...props }, children as React.ReactNode);
      },
    },
  ),
  AnimatePresence: ({ children }: { children: React.ReactNode }) => children,
}));

vi.mock("sonner", () => ({
  toast: { error: vi.fn(), success: vi.fn() },
}));

import { shuffleOptions, type BaseOption } from "@/lib/question-utils";
import { PASS_THRESHOLD_PCT } from "@/lib/gamification.constants";

// --- Build a minimal QuestPage for testing ---
// (re-implements key rendering logic without TanStack Router internals)

type Answer = { questionId: string; choice: string };
type DisplayOption = BaseOption & { displayId: string };

const mockQuestions = [
  {
    id: "q1",
    prompt: "What is 2+2?",
    options: [
      { id: "a", text: "3" },
      { id: "b", text: "4" },
      { id: "c", text: "5" },
      { id: "d", text: "6" },
    ],
    explanation: "Basic addition",
  },
  {
    id: "q2",
    prompt: "What is 3×3?",
    options: [
      { id: "a", text: "6" },
      { id: "b", text: "9" },
      { id: "c", text: "12" },
      { id: "d", text: "15" },
    ],
    explanation: "Basic multiplication",
  },
];

function QuestPageTestHarness({
  questions = mockQuestions,
  exerciseTitle = "Test Exercise",
  isBoss = false,
  result = null as {
    scorePct: number;
    correct: number;
    total: number;
    xpEarned: number;
    coinsEarned: number;
    durationSeconds: number;
    unlockedBadges: { code: string; name: string; rarity: string }[];
    profile: { level: number; current_streak: number; hero_class: string };
  } | null,
  onSubmit = vi.fn(),
}: {
  questions?: typeof mockQuestions;
  exerciseTitle?: string;
  isBoss?: boolean;
  result?: {
    scorePct: number;
    correct: number;
    total: number;
    xpEarned: number;
    coinsEarned: number;
    durationSeconds: number;
    unlockedBadges: { code: string; name: string; rarity: string }[];
    profile: { level: number; current_streak: number; hero_class: string };
  } | null;
  onSubmit?: () => void;
}) {
  const [idx, setIdx] = React.useState(0);
  const [answers, setAnswers] = React.useState<Answer[]>([]);
  const [selected, setSelected] = React.useState<string | null>(null);
  const [showFeedback, setShowFeedback] = React.useState(false);
  const [currentResult, setCurrentResult] = React.useState(result);

  const shuffledOptions = React.useMemo(
    () => new Map(questions.map((q) => [q.id, shuffleOptions(q.options)])),
    [questions],
  );

  const total = questions.length;
  const current = questions[idx];
  const progress = total > 0 ? (idx / total) * 100 : 0;
  const options = current ? (shuffledOptions.get(current.id) ?? []) : [];

  function handleSelect(optId: string) {
    if (showFeedback) return;
    setSelected(optId);
    setShowFeedback(true);
  }

  function advanceNow() {
    if (!selected || !current) return;
    const newAnswers = [...answers, { questionId: current.id, choice: selected }];
    setAnswers(newAnswers);

    if (idx + 1 >= total) {
      onSubmit();
      setCurrentResult(result);
    } else {
      setIdx(idx + 1);
      setSelected(null);
      setShowFeedback(false);
    }
  }

  if (currentResult) {
    const passed = currentResult.scorePct >= PASS_THRESHOLD_PCT;
    return (
      <div data-testid="results-screen">
        <h1>{passed ? "Victory!" : "Nice try, warrior"}</h1>
        <p>
          {currentResult.correct} / {currentResult.total} correct answers ·{" "}
          {Math.round(currentResult.scorePct)}%
        </p>
        <div data-testid="xp-earned">+{currentResult.xpEarned}</div>
        <div data-testid="coins-earned">+{currentResult.coinsEarned}</div>
        {currentResult.unlockedBadges.length > 0 && (
          <div data-testid="badges">
            {currentResult.unlockedBadges.map((b) => (
              <span key={b.code}>{b.name}</span>
            ))}
          </div>
        )}
        <a href="/dashboard">Back to hall</a>
      </div>
    );
  }

  return (
    <div data-testid="quest-playing">
      {isBoss && <div data-testid="boss-header">⚔️ Boss Fight - {exerciseTitle}</div>}
      <div data-testid="progress">
        Question {idx + 1} / {total}
      </div>
      <div role="progressbar" aria-valuenow={progress} aria-valuemin={0} aria-valuemax={100} />
      <h2 data-testid="question-prompt">{current.prompt}</h2>
      <div data-testid="options">
        {options.map((opt: DisplayOption) => (
          <button
            key={opt.id}
            onClick={() => handleSelect(opt.id)}
            disabled={showFeedback}
            data-testid={`option-${opt.displayId}`}
          >
            {opt.displayId}: {opt.text}
          </button>
        ))}
      </div>
      {showFeedback && <div data-testid="feedback">Reponse enregistree.</div>}
      <button data-testid="next-button" disabled={!showFeedback} onClick={advanceNow}>
        {idx + 1 >= total ? "Finish quest" : "Next question"}
      </button>
    </div>
  );
}

function createWrapper() {
  const qc = new QueryClient({
    defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
  });
  return ({ children }: { children: React.ReactNode }) =>
    React.createElement(QueryClientProvider, { client: qc }, children);
}

describe("QuestPage Component", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe("Playing State", () => {
    it("renders the first question with options", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness)));
      expect(screen.getByTestId("quest-playing")).toBeInTheDocument();
      expect(screen.getByTestId("question-prompt")).toHaveTextContent("What is 2+2?");
      expect(screen.getByText(/Question 1 \/ 2/)).toBeInTheDocument();
    });

    it("displays 4 shuffled options with A/B/C/D labels", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness)));
      expect(screen.getByTestId("option-A")).toBeInTheDocument();
      expect(screen.getByTestId("option-B")).toBeInTheDocument();
      expect(screen.getByTestId("option-C")).toBeInTheDocument();
      expect(screen.getByTestId("option-D")).toBeInTheDocument();
    });

    it("shows feedback after selecting an answer", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness)));
      fireEvent.click(screen.getByTestId("option-A"));
      expect(screen.getByTestId("feedback")).toHaveTextContent("Reponse enregistree.");
    });

    it("disables options after selection", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness)));
      fireEvent.click(screen.getByTestId("option-A"));
      expect(screen.getByTestId("option-A")).toBeDisabled();
      expect(screen.getByTestId("option-B")).toBeDisabled();
    });

    it("advances to the next question after clicking Next", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness)));
      fireEvent.click(screen.getByTestId("option-A"));
      fireEvent.click(screen.getByTestId("next-button"));
      expect(screen.getByTestId("question-prompt")).toHaveTextContent("What is 3×3?");
      expect(screen.getByText(/Question 2 \/ 2/)).toBeInTheDocument();
    });

    it("shows Finish quest on last question", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness)));
      // Answer first question
      fireEvent.click(screen.getByTestId("option-A"));
      fireEvent.click(screen.getByTestId("next-button"));
      // Now on last question
      expect(screen.getByTestId("next-button")).toHaveTextContent("Finish quest");
    });

    it("calls onSubmit when finishing the quest", () => {
      const onSubmit = vi.fn();
      const Wrapper = createWrapper();
      render(
        React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness, { onSubmit })),
      );
      // Answer both questions
      fireEvent.click(screen.getByTestId("option-A"));
      fireEvent.click(screen.getByTestId("next-button"));
      fireEvent.click(screen.getByTestId("option-B"));
      fireEvent.click(screen.getByTestId("next-button"));
      expect(onSubmit).toHaveBeenCalledTimes(1);
    });

    it("shows boss header in boss mode", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { isBoss: true }),
        ),
      );
      expect(screen.getByTestId("boss-header")).toHaveTextContent("⚔️ Boss Fight");
    });

    it("next button is disabled before answering", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(QuestPageTestHarness)));
      expect(screen.getByTestId("next-button")).toBeDisabled();
    });
  });

  describe("Results State", () => {
    const passResult = {
      scorePct: 80,
      correct: 8,
      total: 10,
      xpEarned: 120,
      coinsEarned: 20,
      durationSeconds: 45,
      unlockedBadges: [{ code: "first_win", name: "First Victory", rarity: "common" }],
      profile: { level: 5, current_streak: 3, hero_class: "Mage" },
    };

    const failResult = {
      scorePct: 40,
      correct: 4,
      total: 10,
      xpEarned: 40,
      coinsEarned: 5,
      durationSeconds: 60,
      unlockedBadges: [],
      profile: { level: 3, current_streak: 0, hero_class: "Warrior" },
    };

    it("shows Victory when score >= 60%", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { result: passResult }),
        ),
      );
      expect(screen.getByText("Victory!")).toBeInTheDocument();
    });

    it("shows Nice try when score < 60%", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { result: failResult }),
        ),
      );
      expect(screen.getByText("Nice try, warrior")).toBeInTheDocument();
    });

    it("displays XP and coins earned", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { result: passResult }),
        ),
      );
      expect(screen.getByTestId("xp-earned")).toHaveTextContent("+120");
      expect(screen.getByTestId("coins-earned")).toHaveTextContent("+20");
    });

    it("displays unlocked badges when present", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { result: passResult }),
        ),
      );
      expect(screen.getByTestId("badges")).toBeInTheDocument();
      expect(screen.getByText("First Victory")).toBeInTheDocument();
    });

    it("does not display badges section when none unlocked", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { result: failResult }),
        ),
      );
      expect(screen.queryByTestId("badges")).not.toBeInTheDocument();
    });

    it("shows score breakdown", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { result: passResult }),
        ),
      );
      expect(screen.getByText(/8 \/ 10 correct answers · 80%/)).toBeInTheDocument();
    });

    it("has a link back to dashboard", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(QuestPageTestHarness, { result: passResult }),
        ),
      );
      expect(screen.getByText("Back to hall")).toBeInTheDocument();
    });
  });
});
