import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
    [k: string]: unknown;
  }) =>
    React.createElement(
      "a",
      { href: to.replace("$chapterId", params?.chapterId ?? ""), ...rest },
      children,
    ),
}));

import { QuestReviewList } from "../components/quest-review-list";
import type { PlayerReviewItem } from "../components/exercise-player";

/**
 * Étude 04 lot A1.2b — le bloc de correction riche.
 *
 * Ce qui est mis à l'épreuve ici n'est pas le cas nominal (facile), c'est la
 * DÉGRADATION (R-A1.2-3) : le corpus n'est tagué que sur `math` et `math-6eme`,
 * donc « pas de tag » est le cas ORDINAIRE, pas le cas limite. Chaque morceau
 * doit disparaître seul, sans trou visuel — et le rendu d'avant A1.2 reste le
 * plancher.
 */

const LABELS = {
  questReview: "Révision",
  questionN: "Question {n}",
  passed: "Réussi",
  needsWork: "À revoir",
  yourAnswer: "Ta réponse",
  correctAnswer: "Bonne réponse",
  reviewMistakeTitle: "Ce qui t'a fait trébucher",
  reviewCourseCta: "Revoir le cours",
};

function item(over: Partial<PlayerReviewItem> = {}): PlayerReviewItem {
  return {
    questionId: "q1",
    prompt: "Combien font 1/2 + 1/3 ?",
    selectedChoice: "b",
    correctChoice: "a",
    isCorrect: false,
    explanation: "On met au même dénominateur.",
    misconceptionTag: "math.frac.add-denominators",
    chapterId: "chap-1",
    ...over,
  };
}

function renderList(items: PlayerReviewItem[], resolve?: (tag: string) => string | null) {
  return render(
    <QuestReviewList
      review={items}
      labels={LABELS}
      resolvePrompt={() => "fallback"}
      getDisplayChoice={(_q, c) => c.toUpperCase()}
      resolveMisconceptionLabel={resolve}
    />,
  );
}

describe("QuestReviewList — bloc de correction riche (A1.2b)", () => {
  it("nomme l'erreur et ouvre le cours sur une réponse fausse (US-4)", () => {
    renderList([item()], () => "Tu additionnes les dénominateurs");

    expect(screen.getByTestId("review-mistake")).toBeTruthy();
    expect(screen.getByTestId("review-mistake-label").textContent).toBe(
      "Tu additionnes les dénominateurs",
    );
    expect(screen.getByTestId("review-course-link").getAttribute("href")).toBe("/lesson/chap-1");
  });

  it("n'affiche JAMAIS le tag lui-même — c'est un id (R-A1.2-1)", () => {
    const { container } = renderList([item()], () => "Tu additionnes les dénominateurs");
    expect(container.textContent).not.toContain("math.frac.add-denominators");
  });

  it("ne dit rien sur une BONNE réponse — une réussite n'est pas une leçon (R-A1.2-2)", () => {
    // Tag et chapitre présents : seul le verdict doit faire taire le bloc.
    renderList([item({ isCorrect: true })], () => "Tu additionnes les dénominateurs");
    expect(screen.queryByTestId("review-mistake")).toBeNull();
  });

  it("question NON taguée : le lien cours reste, l'erreur n'est pas nommée (R-A1.2-3)", () => {
    renderList([item({ misconceptionTag: null })], () => "jamais appelé");
    expect(screen.queryByTestId("review-mistake-label")).toBeNull();
    expect(screen.getByTestId("review-course-link")).toBeTruthy();
  });

  it("registre MUET sur le tag : même dégradation, aucun message d'erreur (R-A1.2-3)", () => {
    renderList([item()], () => null);
    expect(screen.queryByTestId("review-mistake-label")).toBeNull();
    expect(screen.getByTestId("review-course-link")).toBeTruthy();
  });

  it("aucun résolveur fourni : l'écran reste valide, sans erreur nommée", () => {
    renderList([item()]);
    expect(screen.queryByTestId("review-mistake-label")).toBeNull();
    expect(screen.getByTestId("review-course-link")).toBeTruthy();
  });

  it("erreur nommée mais chapitre absent : pas de lien mort", () => {
    renderList([item({ chapterId: null })], () => "Tu additionnes les dénominateurs");
    expect(screen.getByTestId("review-mistake-label")).toBeTruthy();
    expect(screen.queryByTestId("review-course-link")).toBeNull();
  });

  it("ni tag ni chapitre : AUCUN bloc — pas de cadre vide (R-A1.2-3)", () => {
    renderList([item({ misconceptionTag: null, chapterId: null })], () => "jamais appelé");
    expect(screen.queryByTestId("review-mistake")).toBeNull();
  });

  it("correction ANONYME (champs absents) : le rendu d'avant A1.2 est le plancher", () => {
    // La correction publique ne porte ni tag ni chapitre — les champs sont
    // optionnels, et rien ne doit lever.
    const anon = {
      questionId: "q1",
      prompt: "p",
      selectedChoice: "b",
      correctChoice: "a",
      isCorrect: false,
      explanation: null,
    } satisfies PlayerReviewItem;
    renderList([anon]);
    expect(screen.queryByTestId("review-mistake")).toBeNull();
    // La carte elle-même est toujours là : on n'a rien retiré.
    expect(screen.getByTestId("review-item")).toBeTruthy();
  });

  it("le bloc vit DANS la carte de sa question, pas à côté", () => {
    renderList([item()], () => "Tu additionnes les dénominateurs");
    const card = screen.getByTestId("review-item");
    expect(card.querySelector('[data-testid="review-mistake"]')).not.toBeNull();
  });

  it("plusieurs questions : seules les ratées portent un bloc", () => {
    renderList(
      [
        item({ questionId: "q1", isCorrect: false }),
        item({ questionId: "q2", isCorrect: true }),
        item({ questionId: "q3", isCorrect: false, misconceptionTag: null, chapterId: null }),
      ],
      () => "Tu additionnes les dénominateurs",
    );
    // q1 seule : q2 est juste, q3 n'a rien à dire.
    expect(screen.getAllByTestId("review-mistake")).toHaveLength(1);
  });
});
