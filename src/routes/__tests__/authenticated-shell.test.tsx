// @vitest-environment jsdom
import { render } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { peekReturnTo } from "@/shared/lib/return-to";
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
// La page demandée — réglable : le garde la retient (é38 lot 1, R-4).
let currentLocation = { pathname: "/dashboard", searchStr: "" };

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: { component: React.ComponentType }) => {
    captured = opts.component;
    return {};
  },
  Outlet: () => null,
  Link: ({ children }: { children: React.ReactNode }) => React.createElement("a", null, children),
  useNavigate: () => navigate,
  useLocation: () => currentLocation,
}));

vi.mock("@tanstack/react-query", () => ({ useQuery: () => ({ data: undefined }) }));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));

vi.mock("@/features/auth", () => ({
  useAuth: () => authState,
  useMyRole: () => ({ role: "student", currentParcoursId: "p1", hasProfile: true, isLoaded: true }),
  shouldRedirectToOnboarding: () => false,
  hubRouteForRole: () => "/dashboard",
  // é31 lot 4 : la coquille pousse la langue d'interface dans le profil (R-17).
  // Neutralisé ici — ce fichier teste le mur de connexion.
  useProfileLocaleSync: () => {},
}));

vi.mock("@/features/subscription", () => ({ getPendingBetaCount: vi.fn() }));
vi.mock("@/features/content-report", () => ({ getOpenReportsCount: vi.fn() }));
vi.mock("@/features/bug-report", () => ({
  BetaBadge: () => null,
  BugReportLauncher: () => null,
  getOpenBugsCount: vi.fn(),
}));

// Le cœur du test : on OBSERVE ce que la coquille déclare à la bulle IA.
//
// Le mock vise le CHEMIN PROFOND, celui qu'importe la route — et pas la barrel
// `@/features/ai`, qu'une coquille ne doit justement plus importer : elle mêle
// composants client et modules serveur (`egress.server` → `node:dns`), ce qui a
// éteint le routage en dev et rougi le nightly cinq nuits.
vi.mock("@/features/ai/components/ai-launcher", () => ({
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
  currentLocation = { pathname: "/dashboard", searchStr: "" };
  window.localStorage.clear();
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

describe("coquille connectée — le retour au point de départ (é38 lot 1, R-4)", () => {
  it("retient la page qu'un visiteur sans session voulait voir, requête comprise", async () => {
    currentLocation = { pathname: "/quest/ex-1", searchStr: "?variant=recall" };
    authState = { user: null, loading: false };
    await renderShell();

    expect(peekReturnTo()).toBe("/quest/ex-1?variant=recall");
    expect(navigate).toHaveBeenCalledWith({ to: "/auth", search: { mode: "login" } });
  });

  it("n'écrit rien tant que la session se lit : on ne sait pas encore s'il y en a une", async () => {
    currentLocation = { pathname: "/quest/ex-1", searchStr: "" };
    authState = { user: null, loading: true };
    await renderShell();

    expect(peekReturnTo()).toBeNull();
    expect(navigate).not.toHaveBeenCalled();
  });

  it("ne retient RIEN pour celui qui vient de se déconnecter : sur un poste partagé, la page du précédent n'est pas pour le suivant", async () => {
    currentLocation = { pathname: "/quest/ex-1", searchStr: "" };
    authState = { user: { id: "u1" }, loading: false };
    const view = await renderShell();

    // La déconnexion : la session disparaît alors que la coquille est déjà montée.
    authState = { user: null, loading: false };
    view.rerender(React.createElement(captured as React.ComponentType));

    expect(navigate).toHaveBeenCalledWith({ to: "/auth", search: { mode: "login" } });
    expect(peekReturnTo()).toBeNull();
  });
});
