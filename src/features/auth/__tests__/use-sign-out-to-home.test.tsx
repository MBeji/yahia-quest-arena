// @vitest-environment jsdom
import { act, renderHook } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Se déconnecter depuis l'espace connecté mène à l'accueil (arbitrage Q-4, audit de navigation du
 * 2026-11-21, N-7). La garde de la coquille poussait `/auth` en même temps et gagnait la course.
 */
const order: string[] = [];
const navigate = vi.fn(async (opts: unknown) => {
  order.push(`navigate ${JSON.stringify(opts)}`);
});
const resetQueries = vi.fn(async () => {
  order.push("resetQueries");
});
const toastSuccess = vi.fn((m: string) => order.push(`toast ${m}`));
let deliberateDuringSignOut: boolean | null = null;

vi.mock("@tanstack/react-router", () => ({ useNavigate: () => navigate }));
vi.mock("@tanstack/react-query", () => ({ useQueryClient: () => ({ resetQueries }) }));
vi.mock("sonner", () => ({ toast: { success: (m: string) => toastSuccess(m) } }));
vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      signOut: vi.fn(async () => {
        const { isDeliberateSignOut } = await import("../use-sign-out-to-home");
        deliberateDuringSignOut = isDeliberateSignOut();
        order.push("signOut");
        return { error: null };
      }),
    },
  },
}));

import { isDeliberateSignOut, useSignOutToHome } from "../use-sign-out-to-home";

beforeEach(() => {
  order.length = 0;
  deliberateDuringSignOut = null;
});

describe("useSignOutToHome", () => {
  it("se déclare VOULUE pendant la déconnexion, et plus après", async () => {
    const { result } = renderHook(() => useSignOutToHome());
    await act(() => result.current("À bientôt"));
    expect(deliberateDuringSignOut).toBe(true);
    expect(isDeliberateSignOut()).toBe(false);
  });

  it("ferme la session, part à l'accueil SANS trace dans l'historique, puis oublie le compte", async () => {
    const { result } = renderHook(() => useSignOutToHome());
    await act(() => result.current("À bientôt"));
    expect(order).toEqual([
      "signOut",
      `navigate ${JSON.stringify({ to: "/", replace: true })}`,
      "resetQueries",
      "toast À bientôt",
    ]);
  });
});
