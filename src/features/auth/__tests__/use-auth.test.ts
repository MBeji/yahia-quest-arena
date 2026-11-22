import { act, renderHook, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockOnAuthStateChange, mockGetSession, mockUnsubscribe } = vi.hoisted(() => ({
  mockOnAuthStateChange: vi.fn(),
  mockGetSession: vi.fn(),
  mockUnsubscribe: vi.fn(),
}));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      onAuthStateChange: mockOnAuthStateChange,
      getSession: mockGetSession,
    },
  },
}));

import { useAuth } from "@/features/auth";
import { resetAuthStoreForTests } from "@/features/auth/use-auth";

describe("useAuth", () => {
  beforeEach(() => {
    resetAuthStoreForTests();
    mockOnAuthStateChange.mockReset();
    mockGetSession.mockReset();
    mockUnsubscribe.mockReset();
  });

  it("loads current session and user", async () => {
    const session = { user: { id: "user-1", email: "u@example.com" } };

    mockOnAuthStateChange.mockReturnValue({
      data: { subscription: { unsubscribe: mockUnsubscribe } },
    });
    mockGetSession.mockResolvedValue({ data: { session } });

    const { result } = renderHook(() => useAuth());

    expect(result.current.loading).toBe(true);

    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });

    expect(result.current.session).toEqual(session);
    expect(result.current.user).toEqual(session.user);
  });

  it("reacts to auth state changes", async () => {
    let authCallback: ((event: string, session: unknown) => void) | undefined;

    mockOnAuthStateChange.mockImplementation((cb: (event: string, session: unknown) => void) => {
      authCallback = cb;
      return { data: { subscription: { unsubscribe: mockUnsubscribe } } };
    });
    mockGetSession.mockResolvedValue({ data: { session: null } });

    const { result } = renderHook(() => useAuth());

    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });

    const nextSession = { user: { id: "user-2" } };
    act(() => {
      authCallback?.("SIGNED_IN", nextSession);
    });

    await waitFor(() => {
      expect(result.current.session).toEqual(nextSession);
      expect(result.current.user).toEqual(nextSession.user);
    });
  });

  it("unsubscribes once the last reader is gone", async () => {
    mockOnAuthStateChange.mockReturnValue({
      data: { subscription: { unsubscribe: mockUnsubscribe } },
    });
    mockGetSession.mockResolvedValue({ data: { session: null } });

    const { unmount } = renderHook(() => useAuth());
    unmount();
    // Coupé au tour suivant, pas dans le même commit : une bascule de coquille démonte et monte
    // ensemble, et rouvrir l'abonnement entre les deux serait relire la session.
    expect(mockUnsubscribe).not.toHaveBeenCalled();
    await new Promise((resolve) => setTimeout(resolve, 0));
    expect(mockUnsubscribe).toHaveBeenCalledTimes(1);
  });

  // Le mur de connexion de toute l'application dépend de ce booléen : tant que
  // `loading`, `routes/_authenticated.tsx` rend son écran d'attente et son effet
  // de redirection ne part pas. Une lecture de session qui rejette laissait donc
  // une route de compte affichée à un visiteur SANS session, indéfiniment.
  it("ferme le mur quand la session est ILLISIBLE, au lieu de le laisser ouvert", async () => {
    mockOnAuthStateChange.mockReturnValue({
      data: { subscription: { unsubscribe: mockUnsubscribe } },
    });
    mockGetSession.mockRejectedValue(new Error("network down"));

    const { result } = renderHook(() => useAuth());

    // Sans le `catch`, ce `waitFor` expire : `loading` ne retombe jamais.
    await waitFor(() => expect(result.current.loading).toBe(false));
    // Et une session illisible n'est PAS une session : la garde doit se fermer.
    expect(result.current.user).toBeNull();
    expect(result.current.session).toBeNull();
  });

  // Audit de navigation du 2026-11-21 (§ 6 A-2, N-6) : chaque appelant relisait la session à son
  // montage. Une coquille montée APRÈS la première lecture affichait « Chargement… » plein écran.
  it("une seule lecture et un seul abonnement, partagés par tous les lecteurs", async () => {
    mockOnAuthStateChange.mockReturnValue({
      data: { subscription: { unsubscribe: mockUnsubscribe } },
    });
    mockGetSession.mockResolvedValue({ data: { session: { user: { id: "u1" } } } });

    const first = renderHook(() => useAuth());
    const second = renderHook(() => useAuth());
    await waitFor(() => expect(first.result.current.loading).toBe(false));

    expect(second.result.current.user).toEqual({ id: "u1" });
    expect(mockOnAuthStateChange).toHaveBeenCalledTimes(1);
    expect(mockGetSession).toHaveBeenCalledTimes(1);
  });

  it("un lecteur monté après la première lecture a la session DÈS son premier rendu", async () => {
    mockOnAuthStateChange.mockReturnValue({
      data: { subscription: { unsubscribe: mockUnsubscribe } },
    });
    mockGetSession.mockResolvedValue({ data: { session: { user: { id: "u1" } } } });

    const shellA = renderHook(() => useAuth());
    await waitFor(() => expect(shellA.result.current.loading).toBe(false));

    // La bascule : l'ancienne coquille se démonte, la nouvelle se monte.
    shellA.unmount();
    const renders: boolean[] = [];
    renderHook(() => {
      const auth = useAuth();
      renders.push(auth.loading);
      return auth;
    });
    expect(renders[0]).toBe(false);
  });
});
