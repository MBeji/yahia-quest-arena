import { renderHook } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";
import { describe, expect, it, vi, beforeEach } from "vitest";

const { mockSignOut, mockGetSession, toastSuccess, toastError, loggerWarn, loggerError } =
  vi.hoisted(() => ({
    mockSignOut: vi.fn(),
    mockGetSession: vi.fn(),
    toastSuccess: vi.fn(),
    toastError: vi.fn(),
    loggerWarn: vi.fn(),
    loggerError: vi.fn(),
  }));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: { auth: { signOut: mockSignOut, getSession: mockGetSession } },
}));
vi.mock("sonner", () => ({ toast: { success: toastSuccess, error: toastError } }));
vi.mock("@/shared/lib/logger", () => ({ logger: { warn: loggerWarn, error: loggerError } }));

import { useSignOutInPlace } from "../use-sign-out-in-place";
import { fr } from "@/lib/i18n/fr";

/**
 * Étude 38 lot 1 (R-11, US-7) — se déconnecter depuis une page publique LAISSE sur la page.
 *
 * Le hook ne navigue pas : il termine la session, puis fait oublier au cache ce que le compte
 * avait servi. Tout le reste (le HUD qui disparaît, les invitations qui reviennent) découle de
 * `useAuth`, qui reçoit `SIGNED_OUT`.
 *
 * `signOut()` renvoie ses erreurs sans les lever, et `auth-js` retire la session de l'appareil
 * même quand la révocation côté serveur échoue : l'erreur ne dit donc pas si l'on est resté
 * connecté. Seule la session le dit — c'est ce que ces cas fixent.
 */
function setup() {
  const queryClient = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  const wrapper = ({ children }: { children: React.ReactNode }) =>
    React.createElement(QueryClientProvider, { client: queryClient }, children);
  const { result } = renderHook(() => useSignOutInPlace(), { wrapper });
  queryClient.setQueryData(["me-role", "u1"], { role: "student" });
  return { queryClient, signOut: result.current };
}

const ACCOUNT_DATA = { role: "student" };

describe("useSignOutInPlace", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockSignOut.mockResolvedValue({ error: null });
    mockGetSession.mockResolvedValue({ data: { session: null } });
  });

  it("termine la session PUIS fait oublier au cache ce que le compte avait servi, puis le dit", async () => {
    const { queryClient, signOut } = setup();
    // Au moment où la session se termine, la donnée du compte est encore là : l'ordre est
    // « session d'abord ». Le cache ne se vide qu'après.
    mockSignOut.mockImplementation(async () => {
      expect(queryClient.getQueryData(["me-role", "u1"])).toEqual(ACCOUNT_DATA);
      return { error: null };
    });

    await signOut();

    expect(mockSignOut).toHaveBeenCalledTimes(1);
    expect(queryClient.getQueryData(["me-role", "u1"])).toBeUndefined();
    expect(toastSuccess).toHaveBeenCalledWith(fr.layout.logoutToast);
    expect(toastError).not.toHaveBeenCalled();
    // Rien à vérifier quand l'appel a réussi : on ne relit pas la session pour rien.
    expect(mockGetSession).not.toHaveBeenCalled();
  });

  it("est une déconnexion complète (scope par défaut), pas la sortie locale d'un refus de session", async () => {
    const { signOut } = setup();
    await signOut();
    expect(mockSignOut).toHaveBeenCalledWith();
  });

  it("révocation serveur en échec mais session retirée de l'appareil : l'élève EST déconnecté, le cache se vide, une trace est gardée", async () => {
    mockSignOut.mockResolvedValue({ error: new Error("Failed to fetch") });
    const { queryClient, signOut } = setup();

    await signOut();

    expect(queryClient.getQueryData(["me-role", "u1"])).toBeUndefined();
    expect(toastSuccess).toHaveBeenCalledWith(fr.layout.logoutToast);
    expect(toastError).not.toHaveBeenCalled();
    expect(loggerWarn).toHaveBeenCalledWith("auth.signOutInPlace", {
      error: "Failed to fetch",
      sessionRemains: false,
    });
    expect(loggerError).not.toHaveBeenCalled();
  });

  it("session restée sur l'appareil : on le dit, rien n'est effacé, aucun « à bientôt »", async () => {
    mockSignOut.mockResolvedValue({ error: new Error("storage indisponible") });
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "t" } } });
    const { queryClient, signOut } = setup();

    await signOut();

    expect(toastError).toHaveBeenCalledWith(fr.errors.errorFallback);
    expect(toastSuccess).not.toHaveBeenCalled();
    expect(queryClient.getQueryData(["me-role", "u1"])).toEqual(ACCOUNT_DATA);
    expect(loggerError).toHaveBeenCalledWith("auth.signOutInPlace", {
      error: "storage indisponible",
      sessionRemains: true,
    });
  });

  it("une exception levée par signOut se lit de la même façon, sans promesse rejetée", async () => {
    mockSignOut.mockRejectedValue(new Error("verrou expiré"));
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "t" } } });
    const { queryClient, signOut } = setup();

    await expect(signOut()).resolves.toBeUndefined();

    expect(toastError).toHaveBeenCalledTimes(1);
    expect(toastSuccess).not.toHaveBeenCalled();
    expect(queryClient.getQueryData(["me-role", "u1"])).toEqual(ACCOUNT_DATA);
  });

  it("dans le doute — signOut en échec ET session illisible — la session est tenue pour ouverte", async () => {
    mockSignOut.mockResolvedValue({ error: new Error("réseau") });
    mockGetSession.mockRejectedValue(new Error("lecture impossible"));
    const { queryClient, signOut } = setup();

    await signOut();

    expect(toastError).toHaveBeenCalledTimes(1);
    expect(toastSuccess).not.toHaveBeenCalled();
    expect(queryClient.getQueryData(["me-role", "u1"])).toEqual(ACCOUNT_DATA);
  });

  it("ne touche à aucune mémoire de l'appareil : un identifiant de chapitre n'est pas une donnée de compte", async () => {
    window.localStorage.setItem("na9ra.anonQuizPassed", '{"c1":1}');
    const { signOut } = setup();

    await signOut();

    expect(window.localStorage.getItem("na9ra.anonQuizPassed")).toBe('{"c1":1}');
    window.localStorage.clear();
  });
});
