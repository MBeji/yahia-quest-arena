import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import type { AiConsole } from "../ai-console.server";

/**
 * LA CONSOLE DIT POURQUOI UN APPEL A ÉCHOUÉ.
 *
 * `get_ai_console` rend `recent` avec son `errorCode` depuis le lot 5 ; l'écran
 * le récupérait, le typait, et le jetait. C'était pourtant la SEULE surface où
 * un porteur pouvait apprendre la cause : `concludeFailure` ne marque la clé
 * `invalid` que sur un 401, donc le bandeau d'erreur des Réglages reste muet
 * pour un modèle inexistant, un fournisseur en panne ou un crédit épuisé.
 */

let console_: AiConsole | null = null;

vi.mock("@tanstack/react-query", () => ({
  useQuery: () => ({ data: console_ }),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: () => vi.fn(),
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

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    ai: new Proxy({} as Record<string, string>, {
      get: (_t, key: string) => (key === "pricesAsOf" ? "ai.pricesAsOf {date}" : `ai.${key}`),
    }),
  }),
}));

import { AiSpendPanel } from "../components/ai-spend-panel";

function consoleWith(recent: AiConsole["recent"]): AiConsole {
  return {
    dayMicros: 0,
    monthMicros: 0,
    dailyBudgetUsd: 2,
    monthlyBudgetUsd: 20,
    callsMonth: recent.length,
    byFeature: {},
    byStudent: {},
    byModel: {},
    recent,
    forgeDiscardRate: 0,
    modelAdvice: null,
    pricesAsOf: "2026-08-01",
    limitsEnforced: false,
  };
}

describe("AiSpendPanel — les derniers appels", () => {
  it("affiche la CAUSE d'un appel en erreur, pas un montant", () => {
    console_ = consoleWith([
      {
        feature: "forge",
        model: "gpt-5-mini",
        status: "error",
        errorCode: "AI_MODEL_UNKNOWN",
        micros: 0,
        at: "2026-08-26T20:00:00Z",
      },
    ]);
    render(<AiSpendPanel />);

    const list = screen.getByTestId("ai-spend-recent");
    expect(list).toHaveTextContent("ai.featForge");
    expect(list).toHaveTextContent("gpt-5-mini");
    // La ligne qui manquait : le code traduit, à l'endroit où le porteur le lit.
    expect(list).toHaveTextContent("ai.errModelUnknown");
  });

  it("traduit un code inconnu au lieu de perdre la ligne", () => {
    // Une base plus récente que le code (ou l'inverse) ne doit pas faire
    // disparaître l'échec de la console — il dégrade en générique.
    console_ = consoleWith([
      {
        feature: "chat",
        model: "m",
        status: "error",
        errorCode: "AI_CODE_DU_FUTUR",
        micros: 0,
        at: "2026-08-26T20:01:00Z",
      },
    ]);
    render(<AiSpendPanel />);
    expect(screen.getByTestId("ai-spend-recent")).toHaveTextContent("ai.errGeneric");
  });

  it("un appel réussi montre son montant", () => {
    console_ = consoleWith([
      {
        feature: "explain",
        model: "m",
        status: "ok",
        errorCode: null,
        micros: 12_340,
        at: "2026-08-26T20:02:00Z",
      },
    ]);
    render(<AiSpendPanel />);
    const list = screen.getByTestId("ai-spend-recent");
    expect(list).toHaveTextContent("0.01 $");
    expect(list).not.toHaveTextContent("ai.err");
  });

  it("aucun appel : aucune liste, et surtout aucun bloc vide", () => {
    console_ = consoleWith([]);
    render(<AiSpendPanel />);
    expect(screen.queryByTestId("ai-spend-recent")).not.toBeInTheDocument();
  });
});
