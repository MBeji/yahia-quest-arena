// @vitest-environment jsdom
import { render } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

/**
 * La coquille connectée (`routes/_authenticated.tsx`) — le mur de connexion.
 *
 * Ce qui vaut un filet ici n'est pas le rendu : c'est que la coquille, rendue
 * pour un visiteur SANS session, (1) le renvoie vers `/auth` et (2) ne déclare
 * à personne qu'il est authentifié. Le second point n'avait aucun test, et le
 * nightly a rougi cinq nuits sur le premier.
 */
const navigate = vi.fn();
let authState: { user: { id: string } | null; loading: boolean } = { user: null, loading: false };
const launcherProps: Array<{ authenticated: boolean }> = [];

let captured: React.ComponentType | undefined;

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: { component: React.ComponentType }) => {
    captured = opts.component;
    return {};
  },
  Outlet: () => null,
  Link: ({ children }: { children: React.ReactNode }) => React.createElement("a", null, children),
  useNavigate: () => navigate,
  useLocation: () => ({ pathname: "/dashboard" }),
}));

vi.mock("@tanstack/react-query", () => ({ useQuery: () => ({ data: undefined }) }));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));

vi.mock("@/features/auth", () => ({
  useAuth: () => authState,
  useMyRole: () => ({ role: "student", currentParcoursId: "p1", hasProfile: true, isLoaded: true }),
  shouldRedirectToOnboarding: () => false,
  hubRouteForRole: () => "/dashboard",
}));

vi.mock("@/features/subscription", () => ({ getPendingBetaCount: vi.fn() }));
vi.mock("@/features/content-report", () => ({ getOpenReportsCount: vi.fn() }));
vi.mock("@/features/bug-report", () => ({
  BetaBadge: () => null,
  BugReportLauncher: () => null,
  getOpenBugsCount: vi.fn(),
}));

// Le cœur du test : on OBSERVE ce que la coquille déclare à la bulle IA.
vi.mock("@/features/ai", () => ({
  AiLauncher: (props: { authenticated: boolean }) => {
    launcherProps.push(props);
    return null;
  },
}));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: { auth: { signOut: vi.fn() } },
}));
vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));
vi.mock("@/components/ui/settings-menu", () => ({ SettingsMenu: () => null }));
vi.mock("@/components/visual/gold-ambient", () => ({ GoldAmbient: () => null }));
vi.mock("@/components/account-hud", () => ({ AccountHud: () => null }));
vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    common: { loading: "…", backToHall: "" },
    layout: { signOut: "", logoutToast: "" },
    nav: {},
  }),
}));

async function renderShell() {
  await import("@/routes/_authenticated");
  if (!captured) throw new Error("AuthenticatedLayout non capturé");
  return render(React.createElement(captured));
}

beforeEach(() => {
  navigate.mockReset();
  launcherProps.length = 0;
});

describe("coquille connectée — le mur de connexion", () => {
  it("renvoie vers /auth un visiteur sans session", async () => {
    authState = { user: null, loading: false };
    await renderShell();
    expect(navigate).toHaveBeenCalledWith({ to: "/auth", search: { mode: "login" } });
  });

  it("ne monte AUCUNE surface IA pour un visiteur sans session", async () => {
    // C'est ce qui rend sûr le `<AiLauncher authenticated />` écrit EN DUR dans
    // cette coquille : le `if (!user) return null` passe avant, donc la bulle
    // n'est jamais montée sans session et sa server fn — gardée par
    // `requireSupabaseAuth` — ne part jamais pour personne.
    //
    // ⚠️ Le `true` littéral reste un piège latent : il ne dit pas la vérité, il
    // est seulement inatteignable. Remonter la bulle au-dessus du garde-fou, ou
    // retirer celui-ci, la ferait mentir sans qu'aucun autre test ne bronche.
    // C'est CE test qui le rattraperait. (La coquille publique, elle, dérive
    // honnêtement : `authenticated={!!user}`.)
    authState = { user: null, loading: false };
    await renderShell();
    expect(launcherProps).toHaveLength(0);
  });

  it("déclare authentifié un visiteur qui a une session", async () => {
    authState = { user: { id: "u1" }, loading: false };
    await renderShell();
    expect(launcherProps.at(-1)?.authenticated).toBe(true);
    expect(navigate).not.toHaveBeenCalledWith({ to: "/auth", search: { mode: "login" } });
  });
});
