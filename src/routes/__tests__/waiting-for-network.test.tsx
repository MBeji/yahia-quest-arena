// @vitest-environment jsdom
import { act, render, screen, waitFor } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import React from "react";

/**
 * Étude 38, lot 4 (R-9) — UNE ROUTE QUI ATTEND LE RÉSEAU LE DIT.
 *
 * Hors connexion, TanStack Query met une lecture neuve en PAUSE : `isLoading` est
 * faux, `data` absente, et l'écran rendait son squelette sans fin. Ces tests montent
 * les VRAIES routes sur un VRAI `QueryClient`, coupent le réseau par `onlineManager`
 * (la seule source, D-4), et vérifient les trois temps : l'attente dite, jamais le
 * squelette ; le contenu qui arrive au retour, sans remontage ; le chemin en ligne
 * intact.
 *
 * Le hall (`/dashboard`) ne se rend dans aucun navigateur de session (pas de compte
 * de test) : c'est ici qu'il est couvert, avec la carte du parcours qui lit la même
 * requête.
 */
const routes = new Map<string, React.ComponentType>();

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: (path: string) => (opts: { component: React.ComponentType }) => {
    routes.set(path, opts.component);
    return {
      useParams: () => ({ subjectId: "s1" }),
      useLoaderData: () => null,
    };
  },
  Link: ({ children }: { children: React.ReactNode }) => React.createElement("a", null, children),
  // `BackLink` (écrans d'échec) se construit avec `createLink` à l'import.
  createLink: () => () => null,
  useNavigate: () => () => undefined,
  notFound: () => ({ isNotFound: true }),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));
vi.mock("motion/react", () => ({
  motion: new Proxy({}, { get: () => () => null }),
  useReducedMotion: () => true,
}));

const getDashboard = vi.fn();
const getSubject = vi.fn();

vi.mock("@/features/dashboard", () => ({
  getDashboard: (...a: unknown[]) => getDashboard(...a),
  getSprint2Dashboard: vi.fn(async () => null),
  getDailyRing: vi.fn(async () => null),
  getWeeklyRecap: vi.fn(async () => null),
  getActiveEvent: vi.fn(async () => null),
  getParcours: vi.fn(),
}));
vi.mock("@/features/dashboard/components/dashboard-skeleton", () => ({
  DashboardSkeleton: () => <div data-testid="skeleton" />,
}));
vi.mock("@/features/parcours", () => ({
  JourneyMap: () => <div data-testid="content" />,
  JourneySkeleton: () => <div data-testid="skeleton" />,
  buildSubjectNodes: () => [],
}));
vi.mock("@/features/quest", () => ({
  getSubject: (...a: unknown[]) => getSubject(...a),
  getSubjectParcours: vi.fn(async () => null),
}));
vi.mock("@/features/quest/components/subject-hub", () => ({
  SubjectHub: () => <div data-testid="content" />,
}));
vi.mock("@/features/quest/components/subject-hub-skeleton", () => ({
  SubjectHubSkeleton: () => <div data-testid="skeleton" />,
}));
vi.mock("@/features/auth", () => ({
  useAuth: () => ({ user: null, loading: false }),
  hubRouteForRole: () => "/dashboard",
  shouldLeaveDashboard: () => false,
  useExitOnRefusedSession: () => undefined,
}));

// Le hall : tout ce qu'il compose au-delà de l'état d'attente est hors sujet ici.
const nothing = () => null;
vi.mock("@/features/ai/components/forge-entry", () => ({ ForgeEntry: nothing }));
vi.mock("@/features/tutor/components/tutor-coach", () => ({
  TutorCoachLine: nothing,
  TutorGreeting: nothing,
}));
vi.mock("@/features/tutor/components/tutor-practice-entry", () => ({
  TutorPracticeEntry: nothing,
}));
vi.mock("@/features/tutor/components/tutor-digest", () => ({ TutorDigestCard: nothing }));
vi.mock("@/features/tutor/coaching", () => ({ daysAwayFrom: () => 0 }));
vi.mock("@/features/progression/components/daily-review-panel", () => ({
  DailyReviewPanel: nothing,
}));
vi.mock("@/features/progression/progression.server", () => ({ recoverStreak: vi.fn() }));
vi.mock("@/features/notifications", () => ({ EnablePushCard: nothing }));
vi.mock("@/features/dashboard/components/subject-path-card", () => ({
  SubjectPathCard: nothing,
}));
vi.mock("@/features/dashboard/components/motivational-quote", () => ({
  MotivationalQuote: nothing,
}));
vi.mock("@/features/dashboard/components/dashboard-goals-skeleton", () => ({
  DashboardGoalsSkeleton: nothing,
}));
vi.mock("@/features/dashboard/components/dashboard-focus", () => ({ DashboardFocus: nothing }));
vi.mock("@/features/dashboard/components/back-to-school-banner", () => ({
  BackToSchoolBanner: nothing,
}));
vi.mock("@/features/dashboard/components/hero-avatar", () => ({ HeroAvatar: nothing }));
vi.mock("@/features/dashboard/components/hero-stat-chips", () => ({ HeroStatChips: nothing }));
vi.mock("@/components/guide/guide-intro-card", () => ({ GuideIntroCard: nothing }));
vi.mock("@/hooks/use-mobile", () => ({ useIsMobile: () => true }));

import { QueryClient, QueryClientProvider, onlineManager } from "@tanstack/react-query";
import { I18nProvider } from "@/lib/i18n";

async function renderRoute(path: string, load: () => Promise<unknown>) {
  await load();
  const Component = routes.get(path);
  if (!Component) throw new Error(`route ${path} non capturée`);
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  render(
    <QueryClientProvider client={client}>
      <I18nProvider>
        <Component />
      </I18nProvider>
    </QueryClientProvider>,
  );
}

const CASES = [
  {
    name: "le hall",
    path: "/_authenticated/dashboard",
    load: () => import("@/routes/_authenticated/dashboard"),
    read: getDashboard,
  },
  {
    name: "la carte du parcours",
    path: "/_authenticated/parcours",
    load: () => import("@/routes/_authenticated/parcours"),
    read: getDashboard,
  },
  {
    name: "la page matière",
    path: "/_public/matiere/$subjectId",
    load: () => import("@/routes/_public/matiere.$subjectId"),
    read: getSubject,
  },
] as const;

beforeEach(() => {
  getDashboard.mockReset();
  getSubject.mockReset();
});
afterEach(() => onlineManager.setOnline(true));

describe.each(CASES)("$name — sans réseau", ({ path, load, read }) => {
  it("dit « en attente du réseau », jamais le squelette, et n'appelle pas le serveur", async () => {
    onlineManager.setOnline(false);
    await renderRoute(path, load);

    expect(screen.getByTestId("waiting-for-network")).toBeInTheDocument();
    expect(screen.queryByTestId("skeleton")).toBeNull();
    expect(read).not.toHaveBeenCalled();
  });

  it("en ligne, le chargement garde son squelette : l'attente n'est pas un chargement", async () => {
    read.mockReturnValue(new Promise(() => {}));
    await renderRoute(path, load);

    expect(screen.getByTestId("skeleton")).toBeInTheDocument();
    expect(screen.queryByTestId("waiting-for-network")).toBeNull();
  });
});

// Le retour : prouvé sur les deux écrans dont le contenu se rend sans rien d'autre.
describe.each(CASES.filter((c) => c.name !== "le hall"))(
  "$name — au retour du réseau",
  ({ path, load, read }) => {
    it("le contenu arrive seul, sans rechargement", async () => {
      read.mockResolvedValue({
        subject: { id: "s1" },
        viewer: { unrestricted: false },
        parcours: { id: "p1" },
        chapters: [],
        subjects: [],
        stats: [],
        progress: {},
        profile: null,
      });
      onlineManager.setOnline(false);
      await renderRoute(path, load);
      expect(screen.getByTestId("waiting-for-network")).toBeInTheDocument();

      act(() => onlineManager.setOnline(true));

      await waitFor(() => expect(screen.getByTestId("content")).toBeInTheDocument());
      expect(screen.queryByTestId("waiting-for-network")).toBeNull();
      expect(read).toHaveBeenCalledTimes(1);
    });
  },
);
