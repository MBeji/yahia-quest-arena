import { renderHook } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";

const { mockNavigate, mockUseMyRole } = vi.hoisted(() => ({
  mockNavigate: vi.fn(),
  mockUseMyRole: vi.fn(),
}));

vi.mock("@tanstack/react-router", () => ({ useNavigate: () => mockNavigate }));
vi.mock("../use-my-role", () => ({ useMyRole: () => mockUseMyRole() }));

import { useRedirectConnectedParent } from "../use-redirect-connected-parent";

/**
 * Étude 38 lot 1 (R-14) — un parent CONNECTÉ qui ouvre `/suivi` est renvoyé sur son espace.
 *
 * Le hook ne décide pas qui est « parent » : c'est `hubRouteForRole`, déjà testé, la seule
 * définition de l'espace d'un rôle. Ici on prouve la conduite — qui part, qui reste, et quand.
 */
describe("useRedirectConnectedParent", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("un parent connecté est envoyé sur son rapport, par remplacement (le retour ne le ramène pas ici)", () => {
    mockUseMyRole.mockReturnValue({ role: "parent" });
    renderHook(() => useRedirectConnectedParent({ enabled: true }));

    expect(mockNavigate).toHaveBeenCalledTimes(1);
    expect(mockNavigate).toHaveBeenCalledWith({ to: "/parent-report", replace: true });
  });

  it("un lien partagé avec un code garde la page : l'espace du parent ne sait pas ouvrir CE bilan", () => {
    mockUseMyRole.mockReturnValue({ role: "parent" });
    renderHook(() => useRedirectConnectedParent({ enabled: false }));

    expect(mockNavigate).not.toHaveBeenCalled();
  });

  it.each([
    ["un élève", "student"],
    ["un admin", "admin"],
    ["un rôle pas encore lu (ou un visiteur)", null],
  ])("%s garde la page", (_label, role) => {
    mockUseMyRole.mockReturnValue({ role });
    renderHook(() => useRedirectConnectedParent({ enabled: true }));

    expect(mockNavigate).not.toHaveBeenCalled();
  });

  it("ne redirige pas avant que le rôle soit lu, puis redirige une seule fois quand il arrive", () => {
    mockUseMyRole.mockReturnValue({ role: null });
    const { rerender } = renderHook(() => useRedirectConnectedParent({ enabled: true }));
    expect(mockNavigate).not.toHaveBeenCalled();

    mockUseMyRole.mockReturnValue({ role: "parent" });
    rerender();
    rerender();

    expect(mockNavigate).toHaveBeenCalledTimes(1);
  });
});
