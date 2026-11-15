// @vitest-environment jsdom
import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

/**
 * La coquille publique (`routes/_public.tsx`) et la barre d'onglets d'un élève connecté.
 *
 * Arbitrage du propriétaire, 2026-11-15 : les pages de catalogue (programme, classe, matière,
 * cours) sont servies par cette coquille, y compris à un élève connecté — qui y perdait ses
 * onglets en ouvrant une matière depuis son Hall. La barre le suit désormais ; ce fichier
 * épingle À QUI et OÙ elle se monte, pas son dessin (`student-tab-bar.test.tsx`).
 */
let authState: { user: { id: string } | null; loading: boolean };
let roleState: { role: string | null; isLoaded: boolean };
let pathname: string;

let captured: React.ComponentType | undefined;

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: { component: React.ComponentType }) => {
    captured = opts.component;
    return {};
  },
  Outlet: () => null,
  // La coquille ne lit que le chemin, par `select`.
  useLocation: ({ select }: { select: (location: { pathname: string }) => string }) =>
    select({ pathname }),
}));

vi.mock("@/features/auth", () => ({
  useAuth: () => authState,
  useMyRole: () => roleState,
}));

vi.mock("@/components/public/public-header", () => ({ PublicHeader: () => null }));
vi.mock("@/components/public/public-footer", () => ({ PublicFooter: () => null }));
vi.mock("@/components/public/print-mark", () => ({ PrintMark: () => null }));
vi.mock("@/components/public/canonical-link", () => ({ CanonicalLink: () => null }));
vi.mock("@/components/ui/network-banner", () => ({ NetworkBanner: () => null }));
vi.mock("@/shared/lib/content-protection", () => ({ usePublicContentProtection: () => {} }));
vi.mock("@/shared/lib/install-signals", () => ({}));
vi.mock("@/features/ai/components/ai-launcher", () => ({ AiLauncher: () => null }));
vi.mock("@/components/student-tab-bar", () => ({
  StudentTabBar: () => React.createElement("nav", { "data-testid": "student-tab-bar" }),
}));

async function renderShell() {
  await import("@/routes/_public");
  if (!captured) throw new Error("PublicLayout non capturé");
  return render(React.createElement(captured));
}

beforeEach(() => {
  authState = { user: { id: "u1" }, loading: false };
  roleState = { role: "student", isLoaded: true };
  pathname = "/matiere/math-7eme";
});

describe("coquille publique — la barre d'onglets suit l'élève connecté", () => {
  it.each(["/matiere/math-7eme", "/chapitre/c1", "/programme", "/niveau/ecole-7eme-base"])(
    "se monte sur %s",
    async (path) => {
      pathname = path;
      await renderShell();
      expect(screen.getByTestId("student-tab-bar")).toBeInTheDocument();
    },
  );

  it("réserve sa place en bas de page : le pied de page ne passe pas dessous", async () => {
    const { container } = await renderShell();
    expect(container.querySelector(".public-shell")).toHaveClass(
      "pb-[calc(4.5rem+env(safe-area-inset-bottom))]",
    );
  });

  it("sert aussi l'admin, comme la coquille connectée", async () => {
    roleState = { role: "admin", isLoaded: true };
    await renderShell();
    expect(screen.getByTestId("student-tab-bar")).toBeInTheDocument();
  });
});

describe("coquille publique — la barre d'onglets ne se monte pas", () => {
  it("pour un visiteur sans compte, et sa page ne réserve aucune place", async () => {
    authState = { user: null, loading: false };
    roleState = { role: null, isLoaded: false };
    const { container } = await renderShell();
    expect(screen.queryByTestId("student-tab-bar")).toBeNull();
    expect(container.querySelector(".public-shell")?.className).not.toContain("pb-[calc(");
  });

  // R-6 de l'étude 38 : tant que la session se lit — c'est aussi le rendu serveur — rien ne
  // devine l'état du compte.
  it("tant que la session se lit", async () => {
    authState = { user: null, loading: true };
    roleState = { role: null, isLoaded: false };
    await renderShell();
    expect(screen.queryByTestId("student-tab-bar")).toBeNull();
  });

  it("tant que le rôle n'est pas lu : elle disparaîtrait sous le doigt d'un parent", async () => {
    roleState = { role: null, isLoaded: false };
    await renderShell();
    expect(screen.queryByTestId("student-tab-bar")).toBeNull();
  });

  it("pour un parent : son espace est le suivi, pas la navigation de jeu", async () => {
    roleState = { role: "parent", isLoaded: true };
    await renderShell();
    expect(screen.queryByTestId("student-tab-bar")).toBeNull();
  });

  it.each(["/exercice/e1", "/test-de-niveau/s1"])(
    "sur %s, écran immersif : le bouton du bas appartient à l'épreuve",
    async (path) => {
      pathname = path;
      await renderShell();
      expect(screen.queryByTestId("student-tab-bar")).toBeNull();
    },
  );
});
