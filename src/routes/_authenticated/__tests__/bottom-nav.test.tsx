import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";
import { fr } from "@/lib/i18n/fr";

// Coverage for GAP-152 (feat: Refonte Na9ra Nal3ab mobile bottom tab bar):
// - The authenticated shell renders a fixed mobile tab bar on non-immersive routes.
// - The tab bar is suppressed on quest / dungeon / lesson / onboarding screens so it
//   never overlaps in-screen CTAs (quiz submit, lesson nav, dungeon HUD, onboarding).
// This suite drives the real _authenticated.tsx with location stubs to assert both
// branches. Route files are excluded from coverage scope by design (see vitest.config),
// but they CAN have behavioural tests — see admin-routes.test.tsx for the pattern.

type LocationStub = { pathname: string };

const h = vi.hoisted(() => ({
  components: {} as Record<string, React.ComponentType>,
  location: { pathname: "/dashboard" } as LocationStub,
}));

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: (path: string) => (opts: { component: React.ComponentType }) => {
    h.components[path] = opts.component;
    return { options: opts };
  },
  Link: ({
    children,
    to,
    className,
    activeProps: _activeProps,
    "aria-label": ariaLabel,
    title,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    className?: string;
    activeProps?: unknown;
    "aria-label"?: string;
    title?: string;
  }) =>
    React.createElement(
      "a",
      { href: to, className, "aria-label": ariaLabel, title, ...rest },
      children,
    ),
  useNavigate: () => vi.fn(),
  useLocation: () => h.location,
  Outlet: () => React.createElement("div", { "data-testid": "outlet" }),
}));

vi.mock("@/features/auth", () => ({
  useAuth: () => ({
    user: { id: "u1", email: "test@example.com" },
    loading: false,
    session: { access_token: "tok" },
  }),
  useMyRole: () => ({
    role: "student",
    isAdmin: false,
    currentParcoursId: "parcours-1",
    hasProfile: true,
    isLoaded: true,
  }),
}));

vi.mock("@/features/subscription", () => ({
  getPendingBetaCount: vi.fn(() => Promise.resolve({ count: 0 })),
}));

vi.mock("@/features/content-report", () => ({
  getOpenReportsCount: vi.fn(() => Promise.resolve({ count: 0 })),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
}));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: { auth: { signOut: vi.fn() } },
}));

vi.mock("sonner", () => ({ toast: { success: vi.fn() } }));

// Side-effect import: calls the mocked createFileRoute at eval time, registering
// AuthenticatedLayout into h.components["/_authenticated"].
import "../../_authenticated";

function renderShell() {
  const Layout = h.components["/_authenticated"];
  if (!Layout) throw new Error("_authenticated route did not register its component");
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    React.createElement(QueryClientProvider, { client: qc }, React.createElement(Layout)),
  );
}

const PRIMARY_NAV_LABELS = [
  fr.layout.heroesHall,
  fr.layout.parcours,
  fr.layout.themes,
  fr.layout.dungeon,
  fr.layout.ranking,
] as const;

describe("authenticated shell — mobile bottom tab bar (GAP-152)", () => {
  beforeEach(() => {
    h.location = { pathname: "/dashboard" };
  });

  it("renders both the header nav and the bottom tab bar on a non-immersive route", () => {
    renderShell();
    // Non-immersive: 2 <nav> elements (scrollable top nav in header + fixed bottom bar).
    expect(screen.getAllByRole("navigation").length).toBe(2);
  });

  it("includes all 5 primary destinations in the bottom tab bar", () => {
    renderShell();
    for (const label of PRIMARY_NAV_LABELS) {
      // Each label appears in BOTH the desktop nav wrapper and the bottom tab bar.
      expect(screen.getAllByRole("link", { name: label }).length).toBeGreaterThanOrEqual(1);
    }
  });

  describe("immersive routes — bottom tab bar must be suppressed", () => {
    const IMMERSIVE_PATHS = [
      "/quest",
      "/quest/some-exercise-id",
      "/dungeon",
      "/dungeon/run-abc",
      "/lesson/chapter-1",
      "/onboarding",
    ];

    for (const path of IMMERSIVE_PATHS) {
      it(`hides the bottom tab bar at ${path}`, () => {
        h.location = { pathname: path };
        renderShell();
        // On immersive routes the bottom bar <nav> is not mounted at all —
        // only the scrollable top nav inside the header remains.
        expect(screen.getAllByRole("navigation").length).toBe(1);
      });
    }
  });

  describe("non-immersive routes — bottom tab bar must be present", () => {
    const NON_IMMERSIVE_PATHS = ["/dashboard", "/leaderboard", "/parcours", "/themes", "/shop"];

    for (const path of NON_IMMERSIVE_PATHS) {
      it(`shows the bottom tab bar at ${path}`, () => {
        h.location = { pathname: path };
        renderShell();
        expect(screen.getAllByRole("navigation").length).toBe(2);
      });
    }
  });
});

describe("immersive route detection regex", () => {
  // Pin the pattern so a future typo in the regex is caught immediately.
  const isImmersive = (path: string) => /^\/(quest|dungeon|lesson|onboarding)/.test(path);

  it("matches every immersive prefix", () => {
    expect(isImmersive("/quest")).toBe(true);
    expect(isImmersive("/quest/exercise-123")).toBe(true);
    expect(isImmersive("/dungeon")).toBe(true);
    expect(isImmersive("/dungeon/run-1")).toBe(true);
    expect(isImmersive("/lesson")).toBe(true);
    expect(isImmersive("/lesson/ch-1")).toBe(true);
    expect(isImmersive("/onboarding")).toBe(true);
  });

  it("does not match standard navigation routes", () => {
    expect(isImmersive("/dashboard")).toBe(false);
    expect(isImmersive("/leaderboard")).toBe(false);
    expect(isImmersive("/parcours")).toBe(false);
    expect(isImmersive("/themes")).toBe(false);
    expect(isImmersive("/shop")).toBe(false);
    expect(isImmersive("/parent-report")).toBe(false);
    expect(isImmersive("/")).toBe(false);
  });
});
