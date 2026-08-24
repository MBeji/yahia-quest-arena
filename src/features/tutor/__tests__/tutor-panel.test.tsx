import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type {
  TutorEscalation,
  TutorExplanation,
  TutorMiniCheck,
  TutorMiniCheckResult,
} from "../tutor.server";

/**
 * Étude 11 lot 1 — ce que l'ÉCRAN doit garantir.
 *
 * Deux choses, et la seconde est la plus facile à casser sans s'en apercevoir :
 *
 *   1. R-1 : porte fermée ⇒ aucun bouton. Pas un bouton grisé, pas un « bientôt » —
 *      une phrase qui dit pourquoi, et rien de cliquable.
 *   2. R-15 : un refus du socle IA ne montre JAMAIS son code. Un enfant lit
 *      « El Ostedh revient demain », pas `AI_BUDGET_REACHED`.
 */

let answer: TutorExplanation = {
  ok: true,
  threadId: "11111111-1111-4111-8111-111111111111",
  messageIx: 0,
  body: "Tu as additionné les dénominateurs, or il faut les garder communs.",
  variant: "concret",
  canReformulate: true,
  cached: false,
  lang: "fr",
};

const explain = vi.fn(async (_args: unknown) => answer);
const rate = vi.fn(async (_args: unknown) => ({ ok: true }));

// Lot 4 — le mini-check. Les quatre RPC sont pilotées par des variables de
// module plutôt que par des `mockResolvedValueOnce` : un test qui décrit « la
// réponse est fausse ET aucun signal n'est levé » doit pouvoir le dire en deux
// affectations lisibles, pas en une file d'attente de valeurs.
let miniCheck: TutorMiniCheck = {
  ok: true,
  questionId: "33333333-3333-4333-8333-333333333333",
  prompt: "Combien fait 1/2 + 1/3 ?",
  options: [
    { id: "a", text: "2/5" },
    { id: "b", text: "5/6" },
  ],
  tag: "math.frac.add-denominators",
  lang: "fr",
};
let miniCheckResult: TutorMiniCheckResult = {
  ok: true,
  correct: true,
  correctOption: "b",
  explanation: "On met au même dénominateur avant d'ajouter.",
  tag: null,
};
let signalLevel = 0;
let escalation: TutorEscalation | null = null;

const fetchCheck = vi.fn(async (_args: unknown) => miniCheck);
const submitCheck = vi.fn(async (_args: unknown) => miniCheckResult);
const readSignal = vi.fn(async (_args: unknown) => ({
  level: signalLevel,
  step: "reteach" as const,
}));
const doEscalate = vi.fn(async (_args: unknown) => escalation);

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: () => vi.fn(),
    };
    return chain;
  },
}));

vi.mock("../tutor.server", () => ({
  explainMistake: (args: unknown) => explain(args),
  rateTutorMessage: (args: unknown) => rate(args),
  getTutorMiniCheck: (args: unknown) => fetchCheck(args),
  submitTutorMiniCheck: (args: unknown) => submitCheck(args),
  getTutorUnderstandingSignal: (args: unknown) => readSignal(args),
  escalateTutorThread: (args: unknown) => doEscalate(args),
}));

const { TutorPanel } = await import("../components/tutor-panel");

beforeEach(() => {
  explain.mockClear();
  rate.mockClear();
  fetchCheck.mockClear();
  submitCheck.mockClear();
  readSignal.mockClear();
  doEscalate.mockClear();
  signalLevel = 0;
  escalation = null;
});

const QUESTION = "22222222-2222-4222-8222-222222222222";

describe("TutorPanel — R-1, la porte", () => {
  it("n'affiche AUCUN bouton pendant une session d'exercice active", () => {
    render(
      <TutorPanel
        questionId={QUESTION}
        availability={{ allowed: false, reason: "ACTIVE_SESSION" }}
      />,
    );
    expect(screen.queryByRole("button")).toBeNull();
    // …mais l'élève sait POURQUOI : une porte fermée sans explication ressemble
    // à une panne.
    expect(screen.getByText(/Termine d'abord ta mission/)).toBeTruthy();
  });

  it("disparaît entièrement sur un refus qu'on ne sait pas expliquer", () => {
    // `UNKNOWN` ne dit rien à un enfant. Le tuteur s'efface, comme le reste du
    // bloc A1.2b sait le faire (R-A1.2-3) — jamais un message technique.
    const { container } = render(
      <TutorPanel questionId={QUESTION} availability={{ allowed: false, reason: "UNKNOWN" }} />,
    );
    expect(container.textContent).toBe("");
  });

  it("propose le bouton quand la porte est ouverte", () => {
    render(<TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />);
    expect(screen.getByRole("button", { name: /Demander au Prof/ })).toBeTruthy();
  });
});

describe("TutorPanel — l'explication", () => {
  it("affiche la réponse du tuteur et le geste de reformulation (R-7)", async () => {
    const user = userEvent.setup();
    render(<TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />);

    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));

    await waitFor(() => expect(screen.getByText(/additionné les dénominateurs/)).toBeTruthy());
    expect(screen.getByRole("button", { name: /Explique autrement/ })).toBeTruthy();
    expect(explain).toHaveBeenCalledWith({ data: { questionId: QUESTION, again: false } });
  });

  it("demande le registre SUIVANT sur « Explique autrement » (R-7)", async () => {
    const user = userEvent.setup();
    render(<TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />);

    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));
    await waitFor(() => screen.getByRole("button", { name: /Explique autrement/ }));
    await user.click(screen.getByRole("button", { name: /Explique autrement/ }));

    await waitFor(() =>
      expect(explain).toHaveBeenLastCalledWith({ data: { questionId: QUESTION, again: true } }),
    );
  });

  it("remplace le geste par une phrase quand les trois registres sont épuisés", async () => {
    answer = { ...(answer as Extract<TutorExplanation, { ok: true }>), canReformulate: false };
    const user = userEvent.setup();
    render(<TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />);

    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));

    await waitFor(() => expect(screen.getByText(/On a fait le tour/)).toBeTruthy());
    expect(screen.queryByRole("button", { name: /Explique autrement/ })).toBeNull();
    answer = { ...(answer as Extract<TutorExplanation, { ok: true }>), canReformulate: true };
  });

  it("signale une réponse servie depuis le pot commun (R-15.2)", async () => {
    answer = { ...(answer as Extract<TutorExplanation, { ok: true }>), cached: true };
    const user = userEvent.setup();
    render(<TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />);

    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));

    await waitFor(() => expect(screen.getByText(/Réponse déjà préparée/)).toBeTruthy());
    answer = { ...(answer as Extract<TutorExplanation, { ok: true }>), cached: false };
  });
});

describe("TutorPanel — R-15, le dégradé", () => {
  it("ne montre JAMAIS le code d'un refus — l'énergie épuisée devient une phrase", async () => {
    answer = { ok: false, code: "AI_BUDGET_REACHED" };
    const user = userEvent.setup();
    const { container } = render(
      <TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />,
    );

    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));

    await waitFor(() => expect(screen.getByText(/El Ostedh revient demain/)).toBeTruthy());
    expect(container.textContent).not.toContain("AI_BUDGET_REACHED");
  });

  it("dit « le mode n'est pas activé » plutôt que « panne » quand c'est le cas", async () => {
    answer = { ok: false, code: "AI_MODE_OFF" };
    const user = userEvent.setup();
    render(<TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />);

    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));

    await waitFor(() => expect(screen.getByText(/n'est pas activé/)).toBeTruthy());
  });

  it("retombe sur « en pause » pour tout code inconnu — jamais une erreur brute", async () => {
    answer = { ok: false, code: "UN_CODE_QUE_PERSONNE_N_A_PREVU" };
    const user = userEvent.setup();
    const { container } = render(
      <TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />,
    );

    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));

    await waitFor(() => expect(screen.getByText(/El Ostedh est en pause/)).toBeTruthy());
    expect(container.textContent).not.toContain("UN_CODE_QUE_PERSONNE");
  });
});
describe("TutorPanel — US-4, le mini-check", () => {
  // Les blocs précédents laissent `answer` sur un état DÉGRADÉ (c'est leur
  // sujet). Le mini-check ne part que d'une explication réussie : on remet donc
  // l'état nominal ici, plutôt que de dépendre de l'ordre des `describe`.
  beforeEach(() => {
    answer = {
      ok: true,
      threadId: "11111111-1111-4111-8111-111111111111",
      messageIx: 0,
      body: "Tu as additionné les dénominateurs, or il faut les garder communs.",
      variant: "concret",
      canReformulate: true,
      cached: false,
      lang: "fr",
    };
  });

  /** Amène le panneau jusqu'à l'explication, d'où part « Vérifions ensemble ». */
  async function openExplanation(user: ReturnType<typeof userEvent.setup>) {
    render(<TutorPanel questionId={QUESTION} availability={{ allowed: true, reason: "OK" }} />);
    await user.click(screen.getByRole("button", { name: /Demander au Prof/ }));
    await waitFor(() => screen.getByText(/additionné les dénominateurs/));
  }

  it("propose la vérification SOUS l'explication, jamais à sa place", async () => {
    const user = userEvent.setup();
    await openExplanation(user);

    await user.click(screen.getByTestId("tutor-minicheck-start"));

    await waitFor(() => expect(screen.getByTestId("tutor-minicheck")).toBeTruthy());
    // L'explication reste le PLANCHER (R-15) : elle est toujours à l'écran
    // pendant que l'élève répond à la question de vérification.
    expect(screen.getByText(/additionné les dénominateurs/)).toBeTruthy();
    expect(screen.getByText(/Combien fait 1\/2 \+ 1\/3/)).toBeTruthy();
  });

  it("se tait poliment quand aucune question du stock ne convient", async () => {
    miniCheck = { ok: false, code: "NO_CANDIDATE" };
    const user = userEvent.setup();
    await openExplanation(user);

    await user.click(screen.getByTestId("tutor-minicheck-start"));

    await waitFor(() =>
      expect(screen.getByTestId("tutor-minicheck-unavailable").textContent).toMatch(
        /une autre fois/,
      ),
    );
    miniCheck = {
      ok: true,
      questionId: "33333333-3333-4333-8333-333333333333",
      prompt: "Combien fait 1/2 + 1/3 ?",
      options: [
        { id: "a", text: "2/5" },
        { id: "b", text: "5/6" },
      ],
      tag: "math.frac.add-denominators",
      lang: "fr",
    };
  });

  it("célèbre SOBREMENT une bonne réponse — et ne promet aucune récompense (R-11)", async () => {
    const user = userEvent.setup();
    await openExplanation(user);
    await user.click(screen.getByTestId("tutor-minicheck-start"));
    await waitFor(() => screen.getByTestId("tutor-minicheck"));

    await user.click(screen.getByRole("button", { name: "5/6" }));

    const result = await screen.findByTestId("tutor-minicheck-result");
    expect(result.textContent).toMatch(/C'est ça/);
    // Aucun XP, aucune pièce, aucun badge : le mini-check ne rapporte RIEN, et
    // l'écran ne doit pas laisser croire le contraire — un enfant qui croit
    // gagner quelque chose apprendra à se tromper exprès pour en refaire un.
    expect(result.textContent).not.toMatch(/XP|pièce|badge/i);
    // Réussir n'escalade pas.
    expect(doEscalate).not.toHaveBeenCalled();
    expect(screen.queryByTestId("tutor-escalation")).toBeNull();
  });

  it("n'escalade PAS sur un simple échec — R-8 exige un signal objectif", async () => {
    miniCheckResult = {
      ok: true,
      correct: false,
      correctOption: "b",
      explanation: "On met au même dénominateur.",
      tag: "math.frac.add-denominators",
    };
    signalLevel = 0;
    const user = userEvent.setup();
    await openExplanation(user);
    await user.click(screen.getByTestId("tutor-minicheck-start"));
    await waitFor(() => screen.getByTestId("tutor-minicheck"));

    await user.click(screen.getByRole("button", { name: "2/5" }));

    await waitFor(() => expect(screen.getByTestId("tutor-escalation")).toBeTruthy());
    // Rater une fois n'est pas un signal : on reste sur la marche la plus douce
    // et on ne touche PAS à `escalation_level` en base.
    expect(screen.getByTestId("tutor-escalation").textContent).toMatch(/d'une autre façon/);
    expect(doEscalate).not.toHaveBeenCalled();
  });

  it("escalade d'UNE marche quand un signal R-8 est levé, et dit laquelle", async () => {
    miniCheckResult = {
      ok: true,
      correct: false,
      correctOption: "b",
      explanation: "On met au même dénominateur.",
      tag: "math.frac.add-denominators",
    };
    signalLevel = 2;
    escalation = { level: 2, step: "prerequisite", target: null };
    const user = userEvent.setup();
    await openExplanation(user);
    await user.click(screen.getByTestId("tutor-minicheck-start"));
    await waitFor(() => screen.getByTestId("tutor-minicheck"));

    await user.click(screen.getByRole("button", { name: "2/5" }));

    await waitFor(() =>
      expect(screen.getByTestId("tutor-escalation").textContent).toMatch(/une base juste avant/),
    );
    expect(doEscalate).toHaveBeenCalledWith({
      data: { threadId: "11111111-1111-4111-8111-111111111111" },
    });
    // Remise à l'état neutre pour les tests suivants du fichier.
    miniCheckResult = {
      ok: true,
      correct: true,
      correctOption: "b",
      explanation: "On met au même dénominateur avant d'ajouter.",
      tag: null,
    };
  });
});
