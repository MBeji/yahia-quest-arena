import { render, screen, fireEvent, within } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { PracticeExercise, type CheckAnswersResult } from "../components/practice-exercise";

const exercise = {
  id: "ex1",
  title: "Addition",
  subject_id: "s1",
  subjects: { content_language: "fr" },
};
const questions = [
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
];
const result: CheckAnswersResult = {
  reviewable: true,
  correct: 1,
  total: 2,
  scorePct: 50,
  review: [
    {
      questionId: "q1",
      selectedChoice: "a",
      isCorrect: true,
      correctChoice: "a",
      explanation: "Un plus un font deux.",
    },
    {
      questionId: "q2",
      selectedChoice: "b",
      isCorrect: false,
      correctChoice: "a",
      explanation: null,
    },
  ],
};

function answerAll() {
  for (const q of questions) {
    const group = screen.getByRole("radiogroup", { name: `Question ${questions.indexOf(q) + 1}` });
    fireEvent.click(within(group).getAllByRole("radio")[0]);
  }
}

describe("PracticeExercise", () => {
  beforeEach(() => {
    window.scrollTo = vi.fn();
  });

  it("disables « Corriger » until every question is answered", () => {
    render(
      <PracticeExercise
        exercise={exercise}
        questions={questions}
        isAuthenticated={false}
        checkAnswers={vi.fn().mockResolvedValue(result)}
      />,
    );
    expect(screen.getByRole("button", { name: /Corriger/ })).toBeDisabled();
    answerAll();
    expect(screen.getByRole("button", { name: /Corriger/ })).toBeEnabled();
  });

  it("corrects the answers and shows score, markers, explanation + account invite (anon)", async () => {
    const checkAnswers = vi.fn().mockResolvedValue(result);
    render(
      <PracticeExercise
        exercise={exercise}
        questions={questions}
        isAuthenticated={false}
        checkAnswers={checkAnswers}
      />,
    );
    answerAll();
    fireEvent.click(screen.getByRole("button", { name: /Corriger/ }));

    // Score + per-question markers + explanation appear after correction.
    expect(await screen.findByText("50%")).toBeInTheDocument();
    expect(checkAnswers).toHaveBeenCalledWith({
      exerciseId: "ex1",
      answers: expect.arrayContaining([expect.objectContaining({ questionId: "q1" })]),
    });
    // correct option marked on both questions; the wrong pick marked once.
    expect(screen.getAllByLabelText("Bonne réponse")).toHaveLength(2);
    expect(screen.getByLabelText("Ta réponse")).toBeInTheDocument();
    expect(screen.getByText(/Un plus un font deux/)).toBeInTheDocument();
    // anon → account upsell
    expect(screen.getByText(/Crée un compte/)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Recommencer/ })).toBeInTheDocument();
  });

  it("offers the scored quest instead of the account invite when authenticated", async () => {
    const { container } = render(
      <PracticeExercise
        exercise={exercise}
        questions={questions}
        isAuthenticated={true}
        checkAnswers={vi.fn().mockResolvedValue(result)}
      />,
    );
    answerAll();
    fireEvent.click(screen.getByRole("button", { name: /Corriger/ }));

    expect(await screen.findByText(/mode quête/)).toBeInTheDocument();
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).not.toBeNull();
    expect(screen.queryByText(/Crée un compte/)).not.toBeInTheDocument();
  });
});
