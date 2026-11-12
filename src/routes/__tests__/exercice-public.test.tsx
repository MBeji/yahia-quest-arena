import { fireEvent, render } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
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
  notFound: () => ({ isNotFound: true }),
  isNotFound: (e: unknown) => (e as { isNotFound?: boolean } | null)?.isNotFound === true,
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
// La route importe `getExerciseMeta` directement du fichier serveur (pas du barrel :
// le loader vit dans le chunk d'entrée). On le remplace ici, sinon le vrai fichier
// serveur se charge avec ses middlewares.
const getExerciseMeta = vi.fn();
vi.mock("@/features/quest/quest.practice.server", () => ({
  getExerciseMeta: (...a: unknown[]) => getExerciseMeta(...a),
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() },
}));
const authState = vi.hoisted(() => ({ user: null as { id: string } | null, loading: false }));
vi.mock("@/features/auth", () => ({ useAuth: () => authState }));

import { Route } from "../_public/exercice.$exerciseId";
import { peekReturnTo } from "@/shared/lib/return-to";

const Page = (Route as unknown as { component: React.ComponentType }).component;

const EX_ID = "6e7219be-5c5a-586e-bedd-318a6262ec8f";

type HeadTags = { meta: Array<Record<string, string>> };
const routeOptions = Route as unknown as {
  loader: (ctx: { params: { exerciseId: string } }) => Promise<{ head: HeadTags } | null> | null;
  head: (ctx: { loaderData: { head: HeadTags } | null | undefined }) => HeadTags;
};

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
          xpReward: null,
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

describe("entraînement public — la suite après une réussite (relevé première visite, C-3)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    holder.strategy = null;
    window.sessionStorage.clear();
    getChapterLesson.mockResolvedValue({ practiceExerciseId: null });
  });

  const footer = (strategy: ExercisePlayerStrategy, scorePct: number) =>
    render(
      <div>
        {strategy.renderResultFooter({
          exerciseId: "ex-1",
          subjectId: "s1",
          nextExerciseId: "ex-2",
          xpReward: null,
          onReplay: () => {},
          result: { scorePct } as never,
        })}
      </div>,
    ).container.querySelector('a[href="/exercice/$exerciseId"]');

  it("le registre sans compte demande la mission suivante au lecteur", () => {
    expect(mountStrategy().capabilities.next).toBe(true);
  });

  it("mission réussie : la suivante est offerte, dans le registre sans compte", async () => {
    checkAnswersPublic.mockResolvedValue({
      correct: 5,
      total: 6,
      scorePct: 83,
      reviewable: true,
      review: [],
    });
    const strategy = mountStrategy();
    await strategy.submit({ ...run, durationSeconds: 60, isQuiz: false, totalQuestions: 6 });
    expect(footer(strategy, 83)?.getAttribute("href")).toBe("/exercice/$exerciseId");
  });

  it("mission ratée : pas de mission suivante, rejouer vient d'abord", async () => {
    checkAnswersPublic.mockResolvedValue({
      correct: 1,
      total: 6,
      scorePct: 17,
      reviewable: true,
      review: [],
    });
    const strategy = mountStrategy();
    await strategy.submit({ ...run, durationSeconds: 60, isQuiz: false, totalQuestions: 6 });
    expect(footer(strategy, 17)).toBeNull();
  });

  it("quiz raté à 70 % : la mission suivante est derrière la porte, elle n'est pas offerte", async () => {
    scoreQuizPublic.mockResolvedValue({ correct: 7, total: 10, scorePct: 70 });
    const strategy = mountStrategy();
    await strategy.submit({ ...run, durationSeconds: 60, isQuiz: true, totalQuestions: 10 });
    expect(footer(strategy, 70)).toBeNull();
  });
});

describe("entraînement public — le retour au point de départ (é38 lot 1)", () => {
  it("l'invitation du résultat retient la page de l'entraînement", () => {
    window.localStorage.clear();
    window.history.replaceState({}, "", "/exercice/ex-1");
    const strategy = mountStrategy();
    const { container } = render(
      <div>
        {strategy.renderResultFooter({
          exerciseId: "ex-1",
          subjectId: "s1",
          nextExerciseId: null,
          xpReward: null,
          onReplay: () => {},
          result: {} as never,
        })}
      </div>,
    );
    fireEvent.click(container.querySelector('a[href="/signup"]') as HTMLElement);

    expect(peekReturnTo()).toBe("/exercice/ex-1");
    window.history.replaceState({}, "", "/");
    window.localStorage.clear();
  });
});

describe("entraînement public — la valeur de la mission dans l'invitation (é38 lot 1, R-8)", () => {
  /** Rend le pied de résultat comme le lecteur le ferait, avec la récompense qu'il lui passe. */
  function renderFooter(xpReward: number | null) {
    const strategy = mountStrategy();
    return render(
      <div>
        {strategy.renderResultFooter({
          exerciseId: "ex-1",
          subjectId: "s1",
          nextExerciseId: null,
          xpReward,
          onReplay: () => {},
          result: {} as never,
        })}
      </div>,
    );
  }

  beforeEach(() => {
    authState.user = null;
    authState.loading = false;
  });

  it("une mission à 40 XP promet « jusqu'à 40 XP » — un gain futur, jamais une perte", () => {
    const { container } = renderFooter(40);

    expect(container.textContent).toContain("jusqu’à 40 XP");
    expect(container.textContent).not.toMatch(/perdu|perdre|ne sont pas conservés/i);
  });

  it("la phrase de valeur REMPLACE la phrase sans chiffre : une seule explication à l'écran", () => {
    const { container } = renderFooter(40);

    expect(container.textContent).not.toContain("Sans compte, tes XP");
  });

  it("sans récompense connue, la phrase actuelle reste — aucun chiffre inventé", () => {
    const { container } = renderFooter(null);

    expect(container.textContent).toContain("Sans compte, tes XP");
    expect(container.textContent).not.toMatch(/jusqu’à \d/);
  });

  it("le chiffre est celui de la mission, rien d'autre", () => {
    const { container } = renderFooter(125);

    expect(container.textContent).toContain("jusqu’à 125 XP");
  });

  it("un connecté ne lit aucune invitation — il garde le lien vers la quête", () => {
    authState.user = { id: "u1" };
    const { container } = renderFooter(40);

    expect(container.querySelector('a[href="/signup"]')).toBeNull();
    expect(container.textContent).not.toContain("jusqu’à 40 XP");
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).not.toBeNull();
  });

  it("pendant la lecture de la session, ni l'une ni l'autre des deux cartes", () => {
    authState.loading = true;
    const { container } = renderFooter(40);

    expect(container.querySelector('a[href="/signup"]')).toBeNull();
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).toBeNull();
  });
});

describe("entraînement public — le <head> rendu par le serveur", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("au rendu serveur, la page annonce son exercice, son chapitre et sa matière", async () => {
    vi.stubEnv("SSR", true);
    getExerciseMeta.mockResolvedValue({
      title: "Mission 3",
      mode: "practice",
      chapterTitle: "Les fractions",
      subjectName: "Mathématiques",
    });

    const seeded = await routeOptions.loader({ params: { exerciseId: EX_ID } });
    const head = routeOptions.head({ loaderData: seeded });

    expect(getExerciseMeta).toHaveBeenCalledWith({ data: { exerciseId: EX_ID } });
    expect(head.meta).toContainEqual({ title: "Mission 3 — Les fractions · Na9ra Nal3ab" });
    expect(head.meta).toContainEqual({
      name: "description",
      content:
        "Exercice corrigé, gratuit et sans inscription : Mission 3 (Les fractions · Mathématiques).",
    });
    expect(head.meta).toContainEqual({
      property: "og:url",
      content: `https://www.na9ranal3ab.tn/exercice/${EX_ID}`,
    });
  });

  it("un quiz de compréhension se présente comme tel", async () => {
    vi.stubEnv("SSR", true);
    getExerciseMeta.mockResolvedValue({
      title: "Quiz",
      mode: "quiz",
      chapterTitle: null,
      subjectName: null,
    });
    const seeded = await routeOptions.loader({ params: { exerciseId: EX_ID } });
    const head = routeOptions.head({ loaderData: seeded });
    expect(head.meta).toContainEqual({ title: "Quiz · Na9ra Nal3ab" });
    expect(head.meta).toContainEqual({
      name: "description",
      content: "Quiz de compréhension, gratuit et sans inscription : Quiz.",
    });
  });

  // « Lecture en échec » n'est pas « n'existe pas » : une panne garde la page en
  // 200, avec son titre générique, et le lecteur charge côté client.
  it("lecture en panne : pas de 404, le titre générique reste", async () => {
    vi.stubEnv("SSR", true);
    getExerciseMeta.mockRejectedValue(new Error("db down"));
    expect(await routeOptions.loader({ params: { exerciseId: EX_ID } })).toBeNull();

    expect(routeOptions.head({ loaderData: null })).toEqual({
      meta: [{ title: "Entraînement · Na9ra Nal3ab" }],
    });
  });

  // Le faux 404 du 2026-11-12 : `/exercice/<id inconnu>` répondait HTTP 200.
  it("exercice inconnu : la lecture a réussi sans rien rendre, la page répond 404", async () => {
    vi.stubEnv("SSR", true);
    getExerciseMeta.mockResolvedValue(null);
    await expect(routeOptions.loader({ params: { exerciseId: EX_ID } })).rejects.toEqual({
      isNotFound: true,
    });
  });

  it("adresse qui n'a pas la forme d'un uuid : 404 sans interroger la base", async () => {
    vi.stubEnv("SSR", true);
    await expect(routeOptions.loader({ params: { exerciseId: "pas-un-uuid" } })).rejects.toEqual({
      isNotFound: true,
    });
    expect(getExerciseMeta).not.toHaveBeenCalled();
  });

  it("dans le navigateur, le loader ne lit rien", () => {
    vi.stubEnv("SSR", false);
    expect(routeOptions.loader({ params: { exerciseId: EX_ID } })).toBeNull();
    expect(getExerciseMeta).not.toHaveBeenCalled();
  });
});
