import { render, screen, fireEvent } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { fr } from "@/lib/i18n/fr";
import { buildQuestLabels } from "@/features/quest/quest-labels";
import { computeOutcome } from "../duel-outcome";
import { DuelRecap } from "../components/duel-recap";
import { OpponentProgress } from "../components/opponent-progress";
import { DuelArena } from "../components/duel-arena";
import type { DuelState } from "../duel.server";

const L = fr.duel;

const mkState = (over: Partial<DuelState>): DuelState => ({
  duelId: "d1",
  status: "finished",
  total: 3,
  myAnswered: 3,
  myScore: 2,
  opponentAnswered: 3,
  opponentFinished: true,
  opponentScore: 1,
  review: null,
  ...over,
});

describe("computeOutcome (recap verdict)", () => {
  it("declares a win when my score beats the opponent's", () => {
    expect(computeOutcome(mkState({ myScore: 3, opponentScore: 1 }))).toBe("resultWin");
  });
  it("declares a loss when the opponent scored higher", () => {
    expect(computeOutcome(mkState({ myScore: 1, opponentScore: 2 }))).toBe("resultLoss");
  });
  it("declares a draw on equal finished scores", () => {
    expect(computeOutcome(mkState({ myScore: 2, opponentScore: 2 }))).toBe("resultDraw");
  });
  it("is a forfait win when expired and I finished but the opponent didn't", () => {
    expect(computeOutcome(mkState({ status: "expired", myAnswered: 3, opponentScore: null }))).toBe(
      "resultWin",
    );
  });
  it("is pending when expired and nobody has a result", () => {
    expect(
      computeOutcome(
        mkState({ status: "expired", myAnswered: 1, myScore: 1, opponentScore: null }),
      ),
    ).toBe("resultPending");
  });
  it("is pending while the duel is still active", () => {
    expect(computeOutcome(mkState({ status: "active", opponentScore: null }))).toBe(
      "resultPending",
    );
  });
});

describe("OpponentProgress (R-3: count only)", () => {
  it("shows the answered count while the opponent plays", () => {
    render(<OpponentProgress answered={2} total={5} finished={false} labels={L} />);
    expect(screen.getByText(/Adversaire : 2\/5/)).toBeInTheDocument();
  });
  it("shows the done label once the opponent finished", () => {
    render(<OpponentProgress answered={5} total={5} finished labels={L} />);
    expect(screen.getByText(L.opponentDone)).toBeInTheDocument();
  });
});

describe("DuelRecap", () => {
  it("renders the verdict, both scores, and the review", () => {
    const state = mkState({
      myScore: 3,
      opponentScore: 1,
      review: [
        { questionId: "q1", prompt: "2+2 ?", correctChoice: "4", explanation: "deux et deux" },
      ],
    });
    render(<DuelRecap state={state} labels={L} />);
    expect(screen.getByText(L.resultWin)).toBeInTheDocument();
    expect(screen.getByText(/Ton score : 3\/3/)).toBeInTheDocument();
    expect(screen.getByText(L.reviewTitle)).toBeInTheDocument();
    expect(screen.getByText(/Bonne réponse : 4/)).toBeInTheDocument();
  });
});

describe("DuelArena (US-2 play screen)", () => {
  const question = {
    id: "q1",
    prompt: "2 + 2 = ?",
    questionType: "mcq",
    options: [
      { id: "a", text: "4" },
      { id: "b", text: "5" },
    ],
  };

  it("keeps the submit disabled until an option is chosen, then fires onSubmit", () => {
    const onSubmit = vi.fn();
    render(
      <DuelArena
        question={question}
        questionIndex={0}
        total={3}
        rtl={false}
        questLabels={buildQuestLabels("fr")}
        labels={L}
        submitting={false}
        tooFast={false}
        onSubmit={onSubmit}
        opponent={null}
      />,
    );
    const submitBtn = screen.getByRole("button", { name: L.validate });
    expect(submitBtn).toBeDisabled();

    fireEvent.click(screen.getByText("4"));
    expect(submitBtn).toBeEnabled();

    fireEvent.click(submitBtn);
    expect(onSubmit).toHaveBeenCalledWith("a");
  });

  it("shows the too-fast warning when flagged", () => {
    render(
      <DuelArena
        question={question}
        questionIndex={1}
        total={3}
        rtl={false}
        questLabels={buildQuestLabels("fr")}
        labels={L}
        submitting={false}
        tooFast
        onSubmit={vi.fn()}
        opponent={null}
      />,
    );
    expect(screen.getByText(L.tooFast)).toBeInTheDocument();
    expect(screen.getByText(/Question 2\/3/)).toBeInTheDocument();
  });
});
