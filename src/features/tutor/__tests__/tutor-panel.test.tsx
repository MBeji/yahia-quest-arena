import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type { TutorExplanation } from "../tutor.server";

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
}));

const { TutorPanel } = await import("../components/tutor-panel");

beforeEach(() => {
  explain.mockClear();
  rate.mockClear();
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
