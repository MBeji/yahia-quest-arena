import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * UN ÉCHEC QUI SE NOMME.
 *
 * La Forge ne reconnaissait que quatre codes et renvoyait tout le reste sur
 * `errGeneric` — « L'enregistrement a échoué ». Deux fautes en une phrase : la
 * Forge n'enregistre rien à ce moment (elle génère), et une clé refusée, un
 * modèle inexistant ou un fournisseur en panne arrivaient tous à l'écran sous
 * ce même mot. Signalé en usage le 2026-08-26 : « j'ai attendu plusieurs
 * secondes puis il m'a dit failed to save » — le porteur n'avait aucun moyen
 * d'apprendre ce qui n'allait pas.
 */

let outcome: { ok: boolean; code?: string; quizId?: string } = { ok: false, code: "AI_UNKNOWN" };

vi.mock("@tanstack/react-query", () => ({
  useQuery: ({ queryKey }: { queryKey: unknown[] }) =>
    queryKey[0] === "forgeable-chapters"
      ? { data: [], isLoading: false }
      : { data: { quizzes: [], quotaLeft: 3 }, isLoading: false },
  useQueryClient: () => ({ invalidateQueries: vi.fn() }),
}));

const errors: string[] = [];
vi.mock("sonner", () => ({ toast: { error: (m: string) => errors.push(m), success: vi.fn() } }));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: () => () => Promise.resolve(outcome),
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

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children }: { children: React.ReactNode }) => <a href="/parcours">{children}</a>,
}));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    ai: new Proxy({} as Record<string, string>, { get: (_t, key: string) => `ai.${key}` }),
  }),
}));

import { ForgePanel } from "../components/forge-panel";

async function forgeAndReadError(code: string) {
  errors.length = 0;
  outcome = { ok: false, code };
  const view = render(<ForgePanel chapterId="ch-1" />);
  await userEvent.click(screen.getByTestId("forge-run"));
  view.unmount();
  return errors.at(-1);
}

beforeEach(() => {
  errors.length = 0;
});

describe("ForgePanel — le message d'échec", () => {
  it("nomme les causes propres à la Forge", async () => {
    expect(await forgeAndReadError("AI_FORGE_QUOTA")).toBe("ai.errForgeQuota");
    expect(await forgeAndReadError("AI_FORGE_NO_QUORUM")).toBe("ai.errForgeNoQuorum");
    expect(await forgeAndReadError("AI_FORGE_NO_CONTEXT")).toBe("ai.errForgeNoContext");
    expect(await forgeAndReadError("AI_OUTPUT_REJECTED")).toBe("ai.errForgeOutputRejected");
  });

  it("nomme les causes de l'annexe C, au lieu de les avaler", async () => {
    // Les quatre que le porteur peut RÉPARER, et qui arrivaient toutes sous
    // « L'enregistrement a échoué ».
    expect(await forgeAndReadError("AI_KEY_INVALID")).toBe("ai.errKeyInvalid");
    expect(await forgeAndReadError("AI_MODEL_UNKNOWN")).toBe("ai.errModelUnknown");
    expect(await forgeAndReadError("AI_CREDIT_EXHAUSTED")).toBe("ai.errCreditExhausted");
    expect(await forgeAndReadError("AI_BUDGET_REACHED")).toBe("ai.errBudgetReached");
    // Et les trois qui se lisent « attends / ce n'est pas toi ».
    expect(await forgeAndReadError("AI_RATE_LIMITED")).toBe("ai.errRateLimited");
    expect(await forgeAndReadError("AI_PROVIDER_DOWN")).toBe("ai.errProviderDown");
    expect(await forgeAndReadError("AI_MODE_OFF")).toBe("ai.errModeOff");
  });

  it("retombe sur un générique QUI PARLE DE LA FORGE, jamais d'enregistrement", async () => {
    // `AI_UNKNOWN` et l'absence de code sont les deux seuls cas sans nom. Ils ne
    // doivent surtout pas reprendre `errGeneric`, écrit pour un formulaire.
    expect(await forgeAndReadError("AI_UNKNOWN")).toBe("ai.errForgeFailed");
    expect(await forgeAndReadError("boom")).toBe("ai.errForgeFailed");
  });
});
