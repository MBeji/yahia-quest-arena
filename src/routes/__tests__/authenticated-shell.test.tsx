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

// Le rôle lu par la coquille, et le verdict de la garde d'accueil — réglables par test.
let currentRole: string | null = "student";
let needsOnboarding = false;
let renderedPathname: string | null = null;
let deliberateSignOut = false;

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
  // L'écran rendu — par défaut le même que l'adresse ; `renderedPathname` les sépare pour jouer
  // l'instant où une navigation est partie et où la coquille est encore montée.
  useMatches: ({ select }: { select: (m: Array<{ pathname: string }>) => unknown }) =>
    select([{ pathname: "/" }, { pathname: renderedPathname ?? currentLocation.pathname }]),
}));

vi.mock("@tanstack/react-query", () => ({ useQuery: () => ({ data: undefined }) }));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));

vi.mock("@/features/auth", () => ({
  useAuth: () => authState,
  useMyRole: () => ({
    role: currentRole,
    currentParcoursId: "p1",
    hasProfile: true,
    isLoaded: true,
  }),
  shouldRedirectToOnboarding: () => needsOnboarding,
  hubRouteForRole: (role: string | null) => (role === "parent" ? "/parent-report" : "/dashboard"),
  isDeliberateSignOut: () => deliberateSignOut,
  useSignOutToHome: () => vi.fn(),
  // é31 lot 4 : la coquille pousse la langue d'interface dans le profil (R-17).
  // Neutralisé ici — ce fichier teste le mur de connexion.
  useProfileLocaleSync: () => {},
}));

// é39 : la coquille rattache les tests de niveau de l'appareil à la connexion. Le hook importe la
// couche serveur de sa feature (`createMiddleware`) : on remplace la feature, pas le framework.
vi.mock("@/features/placement", () => ({ useClaimPlacementSessions: () => undefined }));
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
// Le bandeau réseau lit `onlineManager`, que le mock de react-query ci-dessus ne porte pas :
// il a ses propres tests (`network-banner.test.tsx`), ce fichier teste le mur de connexion.
vi.mock("@/components/ui/network-banner", () => ({ NetworkBanner: () => null }));
vi.mock("@/components/visual/gold-ambient", () => ({ GoldAmbient: () => null }));
vi.mock("@/components/account-hud", () => ({ AccountHud: () => null }));
// La barre d'onglets a ses propres tests ; ici on observe seulement QUAND la coquille la monte.
vi.mock("@/components/student-tab-bar", () => ({
  StudentTabBar: () => React.createElement("nav", { "data-testid": "student-tab-bar" }),
}));
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
  currentRole = "student";
  needsOnboarding = false;
  renderedPathname = null;
  deliberateSignOut = false;
  window.localStorage.clear();
});

describe("coquille connectée — le mur de connexion", () => {
  it("renvoie vers /auth un visiteur sans session", async () => {
    authState = { user: null, loading: false };
    await renderShell();
    expect(navigate).toHaveBeenCalledWith({
      to: "/auth",
      search: { mode: "login" },
      replace: true,
    });
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
    expect(navigate).not.toHaveBeenCalledWith({
      to: "/auth",
      search: { mode: "login" },
      replace: true,
    });
  });
});

describe("coquille connectée — le retour au point de départ (é38 lot 1, R-4)", () => {
  it("retient la page qu'un visiteur sans session voulait voir, requête comprise", async () => {
    currentLocation = { pathname: "/quest/ex-1", searchStr: "?variant=recall" };
    authState = { user: null, loading: false };
    await renderShell();

    expect(peekReturnTo()).toBe("/quest/ex-1?variant=recall");
    expect(navigate).toHaveBeenCalledWith({
      to: "/auth",
      search: { mode: "login" },
      replace: true,
    });
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

    expect(navigate).toHaveBeenCalledWith({
      to: "/auth",
      search: { mode: "login" },
      replace: true,
    });
    expect(peekReturnTo()).toBeNull();
  });
});

describe("coquille connectée — le bouton Retour n'est pas piégé (audit du 2026-11-21, N-3)", () => {
  // Une redirection POUSSÉE laisse derrière elle l'écran qui redirige : Retour y ramène, la
  // garde repart, et l'on ne sort plus. Chaque garde REMPLACE donc l'entrée d'historique.
  it("l'élève sans classe est conduit à l'accueil en remplaçant l'écran demandé", async () => {
    needsOnboarding = true;
    authState = { user: { id: "u1" }, loading: false };
    await renderShell();
    expect(navigate).toHaveBeenCalledWith({ to: "/onboarding", replace: true });
  });

  it("le parent qui arrive sur le Hall est conduit à son Suivi, sans attendre le tableau de bord", async () => {
    currentRole = "parent";
    authState = { user: { id: "u1" }, loading: false };
    await renderShell();
    expect(navigate).toHaveBeenCalledWith({ to: "/parent-report", replace: true });
  });

  it.each(["/arene", "/boutique", "/quest/e1", "/parcours"])(
    "un parent qui ouvre l'écran d'élève %s est conduit à son Suivi",
    async (pathname) => {
      currentRole = "parent";
      currentLocation = { pathname, searchStr: "" };
      authState = { user: { id: "u1" }, loading: false };
      await renderShell();
      expect(navigate).toHaveBeenCalledWith({ to: "/parent-report", replace: true });
    },
  );

  it("le parent n'est renvoyé QUE des écrans d'élève : ses paramètres restent les siens", async () => {
    currentRole = "parent";
    currentLocation = { pathname: "/parametrage", searchStr: "" };
    authState = { user: { id: "u1" }, loading: false };
    await renderShell();
    expect(navigate).not.toHaveBeenCalled();
  });

  it("ne juge que l'écran RENDU : un parent qui quitte le Hall pour ailleurs n'y est pas rattrapé", async () => {
    // La navigation vers le Hall est partie (l'adresse le dit) mais l'écran affiché est encore
    // un autre : la garde attend que le Hall soit réellement rendu.
    currentRole = "parent";
    currentLocation = { pathname: "/dashboard", searchStr: "" };
    renderedPathname = "/parent-report";
    authState = { user: { id: "u1" }, loading: false };
    await renderShell();
    expect(navigate).not.toHaveBeenCalled();
  });

  it("une déconnexion VOULUE n'est pas disputée : la garde ne pousse pas /auth (Q-4, N-7)", async () => {
    authState = { user: { id: "u1" }, loading: false };
    const view = await renderShell();
    deliberateSignOut = true;
    authState = { user: null, loading: false };
    view.rerender(React.createElement(captured as React.ComponentType));
    expect(navigate).not.toHaveBeenCalled();
  });

  it("l'élève sans classe garde l'écran demandé : l'assistant l'y ramènera (N-11)", async () => {
    needsOnboarding = true;
    currentLocation = { pathname: "/boutique", searchStr: "?onglet=badges" };
    authState = { user: { id: "u1" }, loading: false };
    await renderShell();
    expect(navigate).toHaveBeenCalledWith({
      to: "/onboarding",
      search: { redirect: "/boutique?onglet=badges" },
      replace: true,
    });
  });

  it("l'élève et l'admin gardent le Hall", async () => {
    for (const role of ["student", "admin"]) {
      navigate.mockReset();
      currentRole = role;
      authState = { user: { id: "u1" }, loading: false };
      const view = await renderShell();
      expect(navigate).not.toHaveBeenCalled();
      view.unmount();
    }
  });
});

describe("coquille connectée — la barre d'onglets", () => {
  it("se monte pour un élève, hors écran immersif", async () => {
    authState = { user: { id: "u1" }, loading: false };
    const { queryByTestId } = await renderShell();
    expect(queryByTestId("student-tab-bar")).not.toBeNull();
  });

  it("se retire pendant une quête : le bouton du bas appartient à la question", async () => {
    authState = { user: { id: "u1" }, loading: false };
    currentLocation = { pathname: "/quest/e1", searchStr: "" };
    const { queryByTestId } = await renderShell();
    expect(queryByTestId("student-tab-bar")).toBeNull();
  });
});
