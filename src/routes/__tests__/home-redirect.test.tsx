// @vitest-environment jsdom
import { render } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import React from "react";

/**
 * La vitrine est pour le visiteur (arbitrage Q-3, audit de navigation du 2026-11-21, N-9) :
 * l'application installée s'ouvre sur `/`, comme la page 404 y renvoie — un connecté passe
 * dans SON espace, une fois sa session et son rôle lus.
 */
const navigate = vi.fn();
let authState: { user: { id: string } | null } = { user: null };
let roleState: { role: string | null; isLoaded: boolean } = { role: null, isLoaded: false };

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => opts,
  useNavigate: () => navigate,
}));
vi.mock("@tanstack/react-query", () => ({
  useQuery: () => ({ data: undefined, isPending: true }),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("@/features/dashboard", () => ({ getCatalogueStats: vi.fn() }));
vi.mock("@/features/auth", () => ({
  useAuth: () => authState,
  useMyRole: () => roleState,
  hubRouteForRole: (role: string | null) => (role === "parent" ? "/parent-report" : "/dashboard"),
}));
vi.mock("@/components/public/public-landing", () => ({
  PublicLanding: () => React.createElement("main", { "data-testid": "landing" }),
}));

import { Route } from "../_public/index";

const Home = (Route as unknown as { component: React.ComponentType }).component;

beforeEach(() => {
  navigate.mockReset();
  authState = { user: null };
  roleState = { role: null, isLoaded: false };
});

describe("accueil — un connecté passe dans son espace", () => {
  it("un visiteur sans compte voit la vitrine", () => {
    const { getByTestId } = render(<Home />);
    expect(getByTestId("landing")).toBeInTheDocument();
    expect(navigate).not.toHaveBeenCalled();
  });

  it("un élève connecté va au Hall, sans laisser la vitrine dans l'historique", () => {
    authState = { user: { id: "u1" } };
    roleState = { role: "student", isLoaded: true };
    render(<Home />);
    expect(navigate).toHaveBeenCalledWith({ to: "/dashboard", replace: true });
  });

  it("un parent connecté va à son Suivi", () => {
    authState = { user: { id: "u1" } };
    roleState = { role: "parent", isLoaded: true };
    render(<Home />);
    expect(navigate).toHaveBeenCalledWith({ to: "/parent-report", replace: true });
  });

  it("attend le rôle : un parent ne doit pas transiter par le Hall", () => {
    authState = { user: { id: "u1" } };
    render(<Home />);
    expect(navigate).not.toHaveBeenCalled();
  });
});
