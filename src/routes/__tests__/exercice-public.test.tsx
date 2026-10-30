import { fireEvent, render } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";
import type { ExercisePlayerStrategy } from "@/features/quest/components/exercise-player";

/**
 * Étude 38 lot 0 — l'entraînement PUBLIC mesure sa fin et son invitation.
 *
 * La page ne rend rien elle-même : elle fabrique une stratégie et la donne au lecteur
 * partagé. On remplace donc le lecteur par un capteur de stratégie, et on appelle
 * `submit` et `renderResultFooter` comme le lecteur le ferait.
 */
const holder = vi.hoisted(() => ({ strategy: null as ExercisePlayerStrategy | null }));

const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useParams: () => ({ exerciseId: "ex-1" }),
  }),
  Link: ({
    children,
    to,
    onClick,
  }: {
    children: React.ReactNode;
    to: string;
    onClick?: () => void;
  }) =>
    React.createElement(
      "a",
      {
        href: to,
        onClick: (e: React.MouseEvent) => {
          e.preventDefault();
          onClick?.();
        },
      },
      children,
    ),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));

const checkAnswersPublic = vi.fn();
const scoreQuizPublic = vi.fn();
const getChapterLesson = vi.fn();
vi.mock("@/features/quest", () => ({
  checkAnswersPublic: (...a: unknown[]) => checkAnswersPublic(...a),
  scoreQuizPublic: (...a: unknown[]) => scoreQuizPublic(...a),
  getChapterLesson: (...a: unknown[]) => getChapterLesson(...a),
}));
vi.mock("@/features/quest/components/exercise-player", () => ({
  ExercisePlayer: ({ strategy }: { strategy: ExercisePlayerStrategy }) => {
    holder.strategy = strategy;
    return null;
  },
}));
vi.mock("@/features/auth", () => ({ useAuth: () => ({ user: null, loading: false }) }));

import { Route } from "../_public/exercice.$exerciseId";

const Page = (Route as unknown as { component: React.ComponentType }).component;

/** Monte la page et rend la stratégie que le lecteur aurait reçue. */
function mountStrategy(): ExercisePlayerStrategy {
  render(<Page />);
  if (!holder.strategy) throw new Error("le lecteur n'a pas reçu sa stratégie");
  return holder.strategy;
}

const run = { sessionId: "anon", exerciseId: "ex-1", chapterId: "c1", answers: [] };

describe("entraînement public — public_practice_completed (é38 lot 0)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    holder.strategy = null;
    window.sessionStorage.clear();
    getChapterLesson.mockResolvedValue({ practiceExerciseId: null });
  });

  it("quiz réussi, sans précipitation : passed vaut true", async () => {
    scoreQuizPublic.mockResolvedValue({ correct: 5, total: 5, scorePct: 100 });
    await mountStrategy().submit({ ...run, durationSeconds: 60, isQuiz: true, totalQuestions: 5 });

    expect(trackProductEvent).toHaveBeenCalledWith("public_practice_completed", {
      exercise_id: "ex-1",
      is_quiz: true,
      passed: true,
    });
  });

  it("quiz bâclé : le score y est mais pas le rythme, donc passed vaut false", async () => {
    scoreQuizPublic.mockResolvedValue({ correct: 5, total: 5, scorePct: 100 });
    await mountStrategy().submit({ ...run, durationSeconds: 5, isQuiz: true, totalQuestions: 5 });

    expect(trackProductEvent).toHaveBeenCalledWith("public_practice_completed", {
      exercise_id: "ex-1",
      is_quiz: true,
      passed: false,
    });
  });

  it("mission corrigée au-dessus du seuil : is_quiz false, passed true", async () => {
    checkAnswersPublic.mockResolvedValue({
      correct: 4,
      total: 5,
      scorePct: 80,
      reviewable: true,
      review: [],
    });
    await mountStrategy().submit({ ...run, durationSeconds: 60, isQuiz: false, totalQuestions: 5 });

    expect(trackProductEvent).toHaveBeenCalledWith("public_practice_completed", {
      exercise_id: "ex-1",
      is_quiz: false,
      passed: true,
    });
  });

  it("mission corrigée sous le seuil : passed vaut false", async () => {
    checkAnswersPublic.mockResolvedValue({
      correct: 2,
      total: 5,
      scorePct: 40,
      reviewable: true,
      review: [],
    });
    await mountStrategy().submit({ ...run, durationSeconds: 60, isQuiz: false, totalQuestions: 5 });

    expect(trackProductEvent).toHaveBeenCalledWith("public_practice_completed", {
      exercise_id: "ex-1",
      is_quiz: false,
      passed: false,
    });
  });

  it("une correction qui échoue n'émet rien : il n'y a pas d'entraînement terminé", async () => {
    checkAnswersPublic.mockRejectedValue(new Error("réseau"));
    await expect(
      mountStrategy().submit({ ...run, durationSeconds: 60, isQuiz: false, totalQuestions: 5 }),
    ).rejects.toThrow("réseau");

    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("l'invitation du résultat émet account_invite_clicked depuis l'entraînement", () => {
    const strategy = mountStrategy();
    const { container } = render(
      <div>
        {strategy.renderResultFooter({
          exerciseId: "ex-1",
          subjectId: "s1",
          nextExerciseId: null,
          onReplay: () => {},
          result: {} as never,
        })}
      </div>,
    );
    fireEvent.click(container.querySelector('a[href="/signup"]') as HTMLElement);

    expect(trackProductEvent).toHaveBeenCalledWith("account_invite_clicked", {
      surface: "practice",
    });
  });
});
