import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  // `BackLink` se construit avec `createLink` : il rend l'ancre qu'on lui passe.
  createLink:
    (Comp: React.ElementType) =>
    ({ to, params: _params, ...rest }: { to: string; params?: unknown }) =>
      React.createElement(Comp, { ...rest, href: to }),
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";
import { fr } from "@/lib/i18n/fr";
import { chapters, exercises, expandAll, subject } from "./subject-hub-fixtures";

beforeEach(() => sessionStorage.clear());

describe("SubjectHub — recall mission row (étude 17, US-6 + override R-9)", () => {
  const openC1 = { c1: true, c2: true };

  it("unlocked: an eligible + mastered mission links into the recall run with its best score", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e2: 5 },
          unlockedByExercise: { e2: true },
          bestByExercise: { e2: 88 },
        }}
      />,
    );
    expandAll(container);
    const chip = screen.getByTestId("recall-chip-unlocked");
    expect(chip).toBeInTheDocument();
    expect(chip.getAttribute("href")).toBe("/quest/$exerciseId");
    expect(screen.getByText(/88%/)).toBeInTheDocument();
  });

  it("locked: eligible but not mastered shows the inert lock, never a link", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e2: 5 },
          unlockedByExercise: {},
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    expect(screen.getByTestId("recall-chip-locked")).toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
    // Signed-in reason omits the "sign in" step.
    expect(screen.getByText(fr.quest.recallLockedHint)).toBeInTheDocument();
  });

  it("absent below RECALL_MIN_QUESTIONS eligible questions (no dead end)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e2: 2 },
          unlockedByExercise: { e2: true },
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    expect(screen.queryByTestId("recall-chip-locked")).not.toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
  });

  it("anonymous visitor: the recall mission is DISCOVERABLE but locked (override R-9)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={false}
        // Anon never unlocks (no durable attempts) → server returns unlocked=false.
        recall={{
          eligibleByExercise: { e2: 5 },
          unlockedByExercise: {},
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    // Locked row shown with the sign-in reason; never a playable link.
    expect(screen.getByTestId("recall-chip-locked")).toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
    expect(screen.getByText(fr.quest.recallLockedHintAnon)).toBeInTheDocument();
  });

  it("absent on the quiz row even when signed-in and eligible", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e1: 5 },
          unlockedByExercise: { e1: true },
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    // e1 is the quiz mission → no recall chip, only e-row chips would appear.
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-locked")).not.toBeInTheDocument();
  });
});
