import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

// Mock modules
vi.mock("@/shared/integrations/supabase/client", () => ({
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

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
}));

vi.mock("@/features/dungeon", () => ({
  getDungeonQuestions: vi.fn(),
  startDungeonRun: vi.fn(),
  submitDungeonAnswer: vi.fn(),
  submitDungeonRun: vi.fn(),
  DUNGEON_XP_PER_FLOOR: 15,
  DUNGEON_COINS_PER_5_FLOORS: 10,
}));

vi.mock("@/shared/lib/utils", () => ({
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

import { shuffleOptions, type DisplayOption } from "@/shared/lib/question-utils";

// --- Dungeon Test Harness ---
// Tests the 3 game states: lobby, playing, gameover

type GameState = "lobby" | "playing" | "gameover";

interface DungeonQuestion {
  id: string;
  prompt: string;
  options: DisplayOption[];
  explanation: string | null;
  exercises: {
    difficulty: number;
    subject_id: string;
    subjects: { name_fr: string; color_token: string; icon: string };
  };
}

const mockDungeonQuestions: DungeonQuestion[] = [
  {
    id: "dq1",
    prompt: "Solve: 5 + 7",
    options: shuffleOptions([
      { id: "a", text: "10" },
      { id: "b", text: "12" },
      { id: "c", text: "14" },
      { id: "d", text: "11" },
    ]),
    explanation: "5 + 7 = 12",
    exercises: {
      difficulty: 1,
      subject_id: "math",
      subjects: { name_fr: "Mathématiques", color_token: "math", icon: "Sword" },
    },
  },
  {
    id: "dq2",
    prompt: "Capital of France?",
    options: shuffleOptions([
      { id: "a", text: "London" },
      { id: "b", text: "Paris" },
      { id: "c", text: "Berlin" },
      { id: "d", text: "Madrid" },
    ]),
    explanation: "Paris is the capital of France",
    exercises: {
      difficulty: 1,
      subject_id: "geo",
      subjects: { name_fr: "Géographie", color_token: "geo", icon: "Globe" },
    },
  },
];

function DungeonTestHarness({
  initialState = "lobby" as GameState,
  questions = mockDungeonQuestions,
  floor = 1,
  onStart = vi.fn(),
  onAnswer = vi.fn().mockResolvedValue({
    isCorrect: true,
    totalCorrect: 1,
    totalAnswered: 1,
    nextFloor: 2,
    correctChoice: "b",
    prompt: "",
    explanation: null,
  }),
  runResult = null as {
    xpEarned: number;
    coinsEarned: number;
    floorsCleared: number;
    totalCorrect: number;
    totalAnswered: number;
  } | null,
  lastWrongAnswer = null as {
    prompt: string;
    selected: string;
    correct: string;
    explanation: string | null;
  } | null,
}: {
  initialState?: GameState;
  questions?: DungeonQuestion[];
  floor?: number;
  onStart?: () => void;
  onAnswer?: (optId: string) => Promise<{
    isCorrect: boolean;
    totalCorrect: number;
    totalAnswered: number;
    nextFloor: number;
    correctChoice: string;
    prompt: string;
    explanation: string | null;
  }>;
  runResult?: {
    xpEarned: number;
    coinsEarned: number;
    floorsCleared: number;
    totalCorrect: number;
    totalAnswered: number;
  } | null;
  lastWrongAnswer?: {
    prompt: string;
    selected: string;
    correct: string;
    explanation: string | null;
  } | null;
}) {
  const [state, setState] = React.useState<GameState>(initialState);
  const [currentIdx, setCurrentIdx] = React.useState(0);
  const [selected, setSelected] = React.useState<string | null>(null);
  const [showFeedback, setShowFeedback] = React.useState(false);
  const [answerWasCorrect, setAnswerWasCorrect] = React.useState<boolean | null>(null);
  const [currentFloor, setCurrentFloor] = React.useState(floor);

  const currentQuestion = questions[currentIdx] as DungeonQuestion | undefined;

  async function handleSelect(optId: string) {
    if (showFeedback) return;
    setSelected(optId);
    setShowFeedback(true);
    const result = await onAnswer(optId);
    setAnswerWasCorrect(result.isCorrect);
    if (result.isCorrect) {
      setCurrentFloor(result.nextFloor);
    }
  }

  // ========== LOBBY ==========
  if (state === "lobby") {
    return (
      <div data-testid="dungeon-lobby">
        <h1>The Infinite Dungeon</h1>
        <p>
          Descends floor by floor. Questions from all subjects, increasingly difficult. One wrong
          answer and it's over.
        </p>
        <div data-testid="reward-xp">15</div>
        <div data-testid="reward-coins">10</div>
        <div data-testid="reward-life">1</div>
        <button
          aria-label="Enter the infinite dungeon mode"
          onClick={() => {
            onStart();
            setState("playing");
          }}
        >
          Enter the Dungeon
        </button>
      </div>
    );
  }

  // ========== GAME OVER ==========
  if (state === "gameover" || runResult) {
    const floorsCleared = runResult?.floorsCleared ?? Math.max(0, currentFloor - 1);
    return (
      <div data-testid="dungeon-gameover">
        <h1>Dungeon Collapsed</h1>
        <p>You fell at floor {currentFloor}.</p>
        {lastWrongAnswer && (
          <div data-testid="last-wrong-answer">
            <p data-testid="fatal-question">{lastWrongAnswer.prompt}</p>
            <div data-testid="your-answer">{lastWrongAnswer.selected}</div>
            <div data-testid="correct-answer">{lastWrongAnswer.correct}</div>
            {lastWrongAnswer.explanation && (
              <p data-testid="explanation">{lastWrongAnswer.explanation}</p>
            )}
          </div>
        )}
        <div data-testid="floors-cleared">{floorsCleared}</div>
        <div data-testid="xp-earned">{runResult?.xpEarned ?? 0}</div>
        <div data-testid="coins-earned">{runResult?.coinsEarned ?? 0}</div>
        <a href="/dashboard">Back to hall</a>
        <button onClick={() => setState("lobby")}>Retry dungeon</button>
      </div>
    );
  }

  // ========== PLAYING ==========
  if (!currentQuestion) {
    return <div data-testid="loading">Descending to floor {currentFloor}…</div>;
  }

  const options = currentQuestion.options;
  const subjectInfo = currentQuestion.exercises?.subjects;
  const difficulty = currentQuestion.exercises?.difficulty ?? 1;

  return (
    <div data-testid="dungeon-playing">
      <a href="/dashboard">Leave dungeon</a>
      <div data-testid="floor-indicator">Floor {currentFloor}</div>
      <div data-testid="hp-indicator">1 HP</div>
      {subjectInfo && <div data-testid="subject-badge">{subjectInfo.name_fr}</div>}
      <div data-testid="difficulty">
        {[1, 2, 3].map((d) => (
          <span key={d} data-active={d <= difficulty}>
            ★
          </span>
        ))}
      </div>
      <h2 data-testid="question-prompt">{currentQuestion.prompt}</h2>
      <p>One wrong answer ends the run. Choose wisely.</p>
      <div data-testid="options">
        {options.map((opt) => {
          const isSel = selected === opt.id;
          const isCorrect = showFeedback && isSel && answerWasCorrect === true;
          const isWrong = showFeedback && isSel && answerWasCorrect === false;
          return (
            <button
              key={opt.id}
              onClick={() => handleSelect(opt.id)}
              disabled={showFeedback}
              data-testid={`option-${opt.displayId}`}
              data-correct={isCorrect || undefined}
              data-wrong={isWrong || undefined}
            >
              {opt.displayId}: {opt.text}
            </button>
          );
        })}
      </div>
      {showFeedback && answerWasCorrect !== null && (
        <div data-testid="feedback">
          {answerWasCorrect ? "Correct! Descending deeper…" : "Wrong! The dungeon collapses…"}
        </div>
      )}
      <div
        role="progressbar"
        aria-label="Dungeon depth"
        aria-valuenow={currentFloor}
        aria-valuemin={0}
        aria-valuemax={50}
      />
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

describe("DungeonPage Component", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe("Lobby State", () => {
    it("renders the dungeon intro", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(DungeonTestHarness)));
      expect(screen.getByTestId("dungeon-lobby")).toBeInTheDocument();
      expect(screen.getByText("The Infinite Dungeon")).toBeInTheDocument();
    });

    it("shows rewards information", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(DungeonTestHarness)));
      expect(screen.getByTestId("reward-xp")).toHaveTextContent("15");
      expect(screen.getByTestId("reward-coins")).toHaveTextContent("10");
      expect(screen.getByTestId("reward-life")).toHaveTextContent("1");
    });

    it("shows the enter button", () => {
      const Wrapper = createWrapper();
      render(React.createElement(Wrapper, null, React.createElement(DungeonTestHarness)));
      expect(
        screen.getByRole("button", { name: /enter the infinite dungeon mode/i }),
      ).toBeInTheDocument();
    });

    it("transitions to playing state on enter", () => {
      const onStart = vi.fn();
      const Wrapper = createWrapper();
      render(
        React.createElement(Wrapper, null, React.createElement(DungeonTestHarness, { onStart })),
      );
      fireEvent.click(screen.getByRole("button", { name: /enter the infinite dungeon/i }));
      expect(onStart).toHaveBeenCalledTimes(1);
      expect(screen.getByTestId("dungeon-playing")).toBeInTheDocument();
    });
  });

  describe("Playing State", () => {
    it("renders current question with options", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing" }),
        ),
      );
      expect(screen.getByTestId("question-prompt")).toHaveTextContent("Solve: 5 + 7");
      expect(screen.getByTestId("option-A")).toBeInTheDocument();
      expect(screen.getByTestId("option-B")).toBeInTheDocument();
      expect(screen.getByTestId("option-C")).toBeInTheDocument();
      expect(screen.getByTestId("option-D")).toBeInTheDocument();
    });

    it("shows floor indicator and HP", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing" }),
        ),
      );
      expect(screen.getByTestId("floor-indicator")).toHaveTextContent("Floor 1");
      expect(screen.getByTestId("hp-indicator")).toHaveTextContent("1 HP");
    });

    it("shows subject badge", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing" }),
        ),
      );
      expect(screen.getByTestId("subject-badge")).toHaveTextContent("Mathématiques");
    });

    it("shows feedback on correct answer", async () => {
      const onAnswer = vi.fn().mockResolvedValue({
        isCorrect: true,
        totalCorrect: 1,
        totalAnswered: 1,
        nextFloor: 2,
        correctChoice: "b",
        prompt: "",
        explanation: null,
      });
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing", onAnswer }),
        ),
      );
      fireEvent.click(screen.getByTestId("option-A"));
      await waitFor(() => {
        expect(screen.getByTestId("feedback")).toHaveTextContent("Correct! Descending deeper…");
      });
    });

    it("shows feedback on wrong answer", async () => {
      const onAnswer = vi.fn().mockResolvedValue({
        isCorrect: false,
        totalCorrect: 0,
        totalAnswered: 1,
        nextFloor: 1,
        correctChoice: "b",
        prompt: "Solve: 5 + 7",
        explanation: "5 + 7 = 12",
      });
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing", onAnswer }),
        ),
      );
      fireEvent.click(screen.getByTestId("option-A"));
      await waitFor(() => {
        expect(screen.getByTestId("feedback")).toHaveTextContent("Wrong! The dungeon collapses…");
      });
    });

    it("disables options after answering", async () => {
      const onAnswer = vi.fn().mockResolvedValue({
        isCorrect: true,
        totalCorrect: 1,
        totalAnswered: 1,
        nextFloor: 2,
        correctChoice: "b",
        prompt: "",
        explanation: null,
      });
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing", onAnswer }),
        ),
      );
      fireEvent.click(screen.getByTestId("option-A"));
      await waitFor(() => {
        expect(screen.getByTestId("option-A")).toBeDisabled();
        expect(screen.getByTestId("option-B")).toBeDisabled();
      });
    });

    it("has leave dungeon link", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing" }),
        ),
      );
      expect(screen.getByText("Leave dungeon")).toBeInTheDocument();
    });

    it("has a depth progress bar", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, { initialState: "playing", floor: 5 }),
        ),
      );
      const bar = screen.getByRole("progressbar", { name: "Dungeon depth" });
      expect(bar).toHaveAttribute("aria-valuenow", "5");
    });
  });

  describe("Game Over State", () => {
    const runResult = {
      xpEarned: 45,
      coinsEarned: 10,
      floorsCleared: 3,
      totalCorrect: 3,
      totalAnswered: 4,
    };

    it("shows game over screen with stats", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, {
            initialState: "gameover",
            runResult,
            floor: 4,
          }),
        ),
      );
      expect(screen.getByTestId("dungeon-gameover")).toBeInTheDocument();
      expect(screen.getByText("Dungeon Collapsed")).toBeInTheDocument();
      expect(screen.getByText("You fell at floor 4.")).toBeInTheDocument();
    });

    it("displays earned rewards", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, {
            initialState: "gameover",
            runResult,
            floor: 4,
          }),
        ),
      );
      expect(screen.getByTestId("xp-earned")).toHaveTextContent("45");
      expect(screen.getByTestId("coins-earned")).toHaveTextContent("10");
      expect(screen.getByTestId("floors-cleared")).toHaveTextContent("3");
    });

    it("shows last wrong answer details", () => {
      const lastWrong = {
        prompt: "What is 8×7?",
        selected: "A",
        correct: "C",
        explanation: "8 × 7 = 56",
      };
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, {
            initialState: "gameover",
            runResult,
            floor: 4,
            lastWrongAnswer: lastWrong,
          }),
        ),
      );
      expect(screen.getByTestId("fatal-question")).toHaveTextContent("What is 8×7?");
      expect(screen.getByTestId("your-answer")).toHaveTextContent("A");
      expect(screen.getByTestId("correct-answer")).toHaveTextContent("C");
      expect(screen.getByTestId("explanation")).toHaveTextContent("8 × 7 = 56");
    });

    it("has retry and back buttons", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, {
            initialState: "gameover",
            runResult,
            floor: 4,
          }),
        ),
      );
      expect(screen.getByText("Back to hall")).toBeInTheDocument();
      expect(screen.getByText("Retry dungeon")).toBeInTheDocument();
    });

    it("retry returns to lobby", () => {
      const Wrapper = createWrapper();
      render(
        React.createElement(
          Wrapper,
          null,
          React.createElement(DungeonTestHarness, {
            initialState: "gameover",
            runResult,
            floor: 4,
          }),
        ),
      );
      fireEvent.click(screen.getByText("Retry dungeon"));
      expect(screen.getByTestId("dungeon-lobby")).toBeInTheDocument();
    });
  });
});
