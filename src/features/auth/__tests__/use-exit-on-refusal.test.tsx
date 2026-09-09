import { renderHook, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";

const { mockSignOut } = vi.hoisted(() => ({ mockSignOut: vi.fn() }));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: { auth: { signOut: mockSignOut } },
}));

const { mockReport } = vi.hoisted(() => ({ mockReport: vi.fn() }));
vi.mock("@/shared/lib/client-log", () => ({ reportClientError: mockReport }));

import { useExitOnRefusedSession } from "../use-exit-on-refusal";

/**
 * LE CUL-DE-SAC, TEL QUE LA SPEC E2E L'A MESURÉ (#938 → #969).
 *
 * Trois correctifs ont visé l'amont — le jeton, le classifieur, la frontière d'erreur racine —
 * et la spec est restée rouge chaque fois. Instrumentée pour dire ce qu'elle VOYAIT, elle a
 * rendu : frontière racine INVISIBLE, écran « Impossible de charger le dashboard », et
 * **1 clé de session encore en place**. Donc l'écran d'erreur de la PAGE, le garde monté mais
 * `user` toujours vrai, et personne pour terminer la session.
 *
 * D'où ce hook : un refus qui atteint un écran d'erreur terminal a déjà épuisé les reprises de
 * react-query ET le forçage de jeton d'`auth-attacher`. Il n'est plus passager — la session se
 * termine, `SIGNED_OUT` est émis, et le garde de `_authenticated` fait la redirection.
 */
describe("useExitOnRefusedSession", () => {
  beforeEach(() => {
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
    mockReport.mockReset();
  });

  it("un refus d'authentification qui atteint l'écran termine la session", async () => {
    renderHook(() => useExitOnRefusedSession(new Error("Unauthorized: Invalid token")));
    // `scope: "local"` : les jetons sont refusés, une révocation réseau échouerait de toute
    // façon — et faire dépendre la sortie d'un appel qui peut pendre rejouerait le gel.
    await waitFor(() => expect(mockSignOut).toHaveBeenCalledWith({ scope: "local" }));
  });

  it("le refus SANS en-tête compte aussi — c'est la panne du 2026-08-18", async () => {
    renderHook(() =>
      useExitOnRefusedSession(new Error("Unauthorized: No authorization header provided")),
    );
    await waitFor(() => expect(mockSignOut).toHaveBeenCalledTimes(1));
  });

  it("une panne ORDINAIRE ne déconnecte personne", async () => {
    // Renvoyer un élève vers la connexion pour un bug de rendu ou un 500 serait une
    // régression : son problème n'a rien à voir avec sa session.
    for (const message of ["Boom", "Failed to fetch", "Internal Server Error"]) {
      renderHook(() => useExitOnRefusedSession(new Error(message)));
    }
    await new Promise((r) => setTimeout(r, 0));
    expect(mockSignOut).not.toHaveBeenCalled();
  });

  it("aucune erreur, aucune sortie — l'écran nominal n'appelle rien", async () => {
    renderHook(() => useExitOnRefusedSession(null));
    await new Promise((r) => setTimeout(r, 0));
    expect(mockSignOut).not.toHaveBeenCalled();
  });

  it("une déconnexion locale qui échoue est journalisée, pas avalée", async () => {
    mockSignOut.mockRejectedValue(new Error("storage indisponible"));
    renderHook(() => useExitOnRefusedSession(new Error("Unauthorized: Invalid token")));
    await waitFor(() => expect(mockReport).toHaveBeenCalledTimes(1));
    expect(mockReport.mock.calls[0]?.[0]).toMatchObject({ stage: "token-attach" });
  });

  it("une seule sortie par erreur, même si le composant rend plusieurs fois", async () => {
    const erreur = new Error("Unauthorized: Invalid token");
    const { rerender } = renderHook(() => useExitOnRefusedSession(erreur));
    rerender();
    rerender();
    await waitFor(() => expect(mockSignOut).toHaveBeenCalledTimes(1));
  });
});
