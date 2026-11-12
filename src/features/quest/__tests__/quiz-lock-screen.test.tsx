import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { QuizLockScreen } from "../components/quiz-lock-screen";

describe("QuizLockScreen", () => {
  it("renders the title/body and the take-quiz, review and back links when ids are set", () => {
    const { container } = render(
      <QuizLockScreen
        title="Locked"
        body="Pass the quiz first"
        takeQuizLabel="Take the quiz"
        reviewLabel="Review the lesson"
        backLabel="Back to subject"
        quizId="qz1"
        chapterId="c1"
        subjectId="s1"
        rtl={false}
      />,
    );
    expect(screen.getByText("Locked")).toBeInTheDocument();
    expect(screen.getByText("Pass the quiz first")).toBeInTheDocument();
    // The direct unlock path: a link straight to the comprehension quiz.
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).not.toBeNull();
    expect(screen.getByText("Take the quiz")).toBeInTheDocument();
    expect(container.querySelector('a[href="/chapitre/$chapterId"]')).not.toBeNull();
    expect(container.querySelector('a[href="/matiere/$subjectId"]')).not.toBeNull();
    // No RTL direction unless requested.
    expect(container.querySelector('[dir="rtl"]')).toBeNull();
    // Sans titre de mission, pas de surtitre.
    expect(container.querySelector('[data-testid="lock-mission-title"]')).toBeNull();
  });

  it("names the mission the visitor asked for, above the reason (relevé première visite, C-1)", () => {
    const { container } = render(
      <QuizLockScreen
        missionTitle="⭐ تمرين: الأعداد الأوّليّة"
        title="D'abord le quiz"
        body="Cette mission s'ouvre dès que…"
        takeQuizLabel="Passer le quiz"
        reviewLabel="Lire le cours"
        backLabel="Retour"
        quizId="qz1"
        chapterId="c1"
        subjectId="s1"
        rtl={false}
        quizExerciseTo="/exercice/$exerciseId"
      />,
    );
    const overline = container.querySelector('[data-testid="lock-mission-title"]');
    expect(overline?.textContent).toBe("⭐ تمرين: الأعداد الأوّليّة");
    // Le titre arabe d'une matière arabe se lit dans son sens, quelle que soit l'interface.
    expect(overline?.getAttribute("dir")).toBe("auto");
    // Le quiz reste à un toucher, dans le registre sans compte.
    expect(container.querySelector('a[href="/exercice/$exerciseId"]')).not.toBeNull();
  });

  it("omits the take-quiz link when no quiz id, the review link without a chapter, back without a subject, and honors rtl", () => {
    const { container } = render(
      <QuizLockScreen
        title="Locked"
        body="Pass the quiz first"
        takeQuizLabel="Take the quiz"
        reviewLabel="Review the lesson"
        backLabel="Back to subject"
        quizId={null}
        chapterId={null}
        subjectId={null}
        rtl
      />,
    );
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).toBeNull();
    expect(container.querySelector('a[href="/chapitre/$chapterId"]')).toBeNull();
    expect(container.querySelector('a[href="/matiere/$subjectId"]')).toBeNull();
    expect(container.querySelector('[dir="rtl"]')).not.toBeNull();
  });
});
