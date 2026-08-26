// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetSession, mockRefreshSession } = vi.hoisted(() => ({
  mockGetSession: vi.fn(),
  mockRefreshSession: vi.fn(),
}));

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({
    client: (handler: unknown) => handler,
  }),
}));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      getSession: mockGetSession,
      refreshSession: mockRefreshSession,
    },
  },
}));

import { attachSupabaseAuth } from "@/shared/integrations/supabase/auth-attacher";

// The mock above makes `.client(handler)` return the handler, so at runtime the
// middleware is directly callable. Cast to a callable for type-checking the tests.
const callMiddleware = attachSupabaseAuth as unknown as (ctx: never) => Promise<unknown>;

describe("attachSupabaseAuth", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
  });

  it("attaches Authorization header when session token exists", async () => {
    mockGetSession.mockResolvedValue({
      data: {
        session: {
          access_token: "token-123",
        },
      },
    });

    const next = vi.fn().mockResolvedValue("ok");

    const result = await callMiddleware({ next } as never);

    expect(result).toBe("ok");
    expect(next).toHaveBeenCalledWith({
      headers: {
        Authorization: "Bearer token-123",
      },
    });
  });

  it("passes empty headers when no session token exists", async () => {
    mockGetSession.mockResolvedValue({
      data: {
        session: null,
      },
    });

    const next = vi.fn().mockResolvedValue("ok");

    await callMiddleware({ next } as never);

    expect(next).toHaveBeenCalledWith({ headers: {} });
  });
});

// =============================================================================
// Le rafraîchissement raté (signalé en prod le 2026-08-18).
//
// `getSession()` rafraîchit déjà une session expirée : quand il rend malgré
// tout `session: null` AVEC une erreur, c'est que ce rafraîchissement a échoué.
// Le client se croit alors connecté — rien n'a effacé la session, donc aucune
// redirection vers la connexion — mais plus aucune server fn n'aboutit :
// « Failed to load dashboard », dont seule une déconnexion/reconnexion sortait.
// =============================================================================
describe("attachSupabaseAuth — rafraîchissement raté", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
  });

  it("retente une fois, et l'appel repart avec le jeton neuf", async () => {
    mockGetSession.mockResolvedValue({
      data: { session: null },
      error: { message: "refresh failed" },
    });
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
    expect(next).toHaveBeenCalledWith({ headers: { Authorization: "Bearer token-neuf" } });
  });

  it("si la reprise échoue aussi, on n'invente pas d'en-tête", async () => {
    mockGetSession.mockResolvedValue({
      data: { session: null },
      error: { message: "refresh failed" },
    });
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: { message: "still failing" },
    });

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(next).toHaveBeenCalledWith({ headers: {} });
  });

  it("visiteur anonyme : aucune session, donc AUCUN appel de reprise", async () => {
    // La distinction tient à `error` : nul = personne n'est connecté, il n'y a
    // rien à retenter. Sans ce garde, chaque appel du registre public paierait
    // un `refreshSession()` de plus.
    mockGetSession.mockResolvedValue({ data: { session: null }, error: null });

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(mockRefreshSession).not.toHaveBeenCalled();
    expect(next).toHaveBeenCalledWith({ headers: {} });
  });
});
