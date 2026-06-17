import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";
import { fr } from "@/lib/i18n/fr";

// Route-level guard for GAP-017: an admin must reach each /admin console, a
// non-admin must be refused, and there must be no access-denied flash while the
// role is still loading. The role itself comes from useMyRole (unit-tested in
// features/auth); here we mock it to drive the three real route components and
// assert their guard wiring. createFileRoute is stubbed so we can capture each
// page component (keyed by its route path) and render it in isolation.
type RoleState = {
  role: string | null;
  isAdmin: boolean;
  currentParcoursId: string | null;
  hasProfile: boolean;
  isLoaded: boolean;
};

const h = vi.hoisted(() => ({
  components: {} as Record<string, React.ComponentType>,
  role: {
    role: null,
    isAdmin: false,
    currentParcoursId: null,
    hasProfile: false,
    isLoaded: true,
  } as RoleState,
}));

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: (path: string) => (opts: { component: React.ComponentType }) => {
    h.components[path] = opts.component;
    return { options: opts };
  },
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

vi.mock("@/features/auth", () => ({
  useMyRole: () => h.role,
}));

vi.mock("@/features/subscription", () => ({
  BetaRequestsAdmin: () => React.createElement("div", { "data-testid": "beta-requests-admin" }),
  ParcoursEntitlementsAdmin: () =>
    React.createElement("div", { "data-testid": "parcours-entitlements-admin" }),
  listParcoursEntitlements: vi.fn(() => Promise.resolve({ entitlements: [] })),
  grantParcoursEntitlement: vi.fn(),
  revokeParcoursEntitlement: vi.fn(),
}));

vi.mock("@/features/content-report", () => ({
  ContentReportsAdmin: () => React.createElement("div", { "data-testid": "content-reports-admin" }),
}));

vi.mock("@/features/dashboard", () => ({
  getParcours: vi.fn(() => Promise.resolve({ parcours: [] })),
  getParcoursInterestCounts: vi.fn(() => Promise.resolve({ counts: [] })),
  ParcoursInterestAdmin: () =>
    React.createElement("div", { "data-testid": "parcours-interest-admin" }),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
}));

vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));

// Side-effect imports: each route module calls the mocked createFileRoute at eval
// time, registering its page component into h.components under its route path.
import "../admin.subscriptions";
import "../admin.beta-requests";
import "../admin.content-reports";
import "../admin.parcours-interest";

const SUBSCRIPTIONS = "/_authenticated/admin/subscriptions";
const BETA = "/_authenticated/admin/beta-requests";
const REPORTS = "/_authenticated/admin/content-reports";
const INTEREST = "/_authenticated/admin/parcours-interest";

function pageFor(path: string): React.ComponentType {
  const Component = h.components[path];
  if (!Component) throw new Error(`route ${path} did not register a component`);
  return Component;
}

function renderPage(Page: React.ComponentType) {
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    React.createElement(QueryClientProvider, { client: qc }, React.createElement(Page)),
  );
}

const ADMIN: RoleState = {
  role: "admin",
  isAdmin: true,
  currentParcoursId: null,
  hasProfile: true,
  isLoaded: true,
};

describe("admin console route guards (GAP-017)", () => {
  beforeEach(() => {
    h.role = {
      role: null,
      isAdmin: false,
      currentParcoursId: null,
      hasProfile: false,
      isLoaded: true,
    };
  });

  describe("/admin/subscriptions", () => {
    it("lets an admin into the entitlements console", async () => {
      h.role = ADMIN;
      renderPage(pageFor(SUBSCRIPTIONS));

      expect(screen.queryByText(fr.subscription.accessDenied)).not.toBeInTheDocument();
      // The entitlements panel mounts once the (mocked) list query resolves.
      expect(await screen.findByTestId("parcours-entitlements-admin")).toBeInTheDocument();
    });

    it("refuses a non-admin", () => {
      h.role = {
        role: "student",
        isAdmin: false,
        currentParcoursId: "x",
        hasProfile: true,
        isLoaded: true,
      };
      renderPage(pageFor(SUBSCRIPTIONS));

      expect(screen.getByText(fr.subscription.accessDenied)).toBeInTheDocument();
      expect(screen.queryByTestId("parcours-entitlements-admin")).not.toBeInTheDocument();
    });
  });

  describe("/admin/beta-requests", () => {
    it("lets an admin into the beta-requests console", () => {
      h.role = ADMIN;
      renderPage(pageFor(BETA));

      expect(screen.getByTestId("beta-requests-admin")).toBeInTheDocument();
      expect(screen.queryByText(fr.subscription.accessDenied)).not.toBeInTheDocument();
    });

    it("refuses a non-admin (parent)", () => {
      h.role = {
        role: "parent",
        isAdmin: false,
        currentParcoursId: null,
        hasProfile: true,
        isLoaded: true,
      };
      renderPage(pageFor(BETA));

      expect(screen.getByText(fr.subscription.accessDenied)).toBeInTheDocument();
      expect(screen.queryByTestId("beta-requests-admin")).not.toBeInTheDocument();
    });
  });

  describe("/admin/content-reports", () => {
    it("lets an admin into the content-reports console", () => {
      h.role = ADMIN;
      renderPage(pageFor(REPORTS));

      expect(screen.getByTestId("content-reports-admin")).toBeInTheDocument();
      expect(screen.queryByText(fr.subscription.accessDenied)).not.toBeInTheDocument();
    });

    it("refuses a non-admin", () => {
      h.role = {
        role: "student",
        isAdmin: false,
        currentParcoursId: null,
        hasProfile: true,
        isLoaded: true,
      };
      renderPage(pageFor(REPORTS));

      expect(screen.getByText(fr.subscription.accessDenied)).toBeInTheDocument();
      expect(screen.queryByTestId("content-reports-admin")).not.toBeInTheDocument();
    });
  });

  describe("/admin/parcours-interest", () => {
    it("lets an admin into the program-interest ranking", async () => {
      h.role = ADMIN;
      renderPage(pageFor(INTEREST));

      expect(screen.queryByText(fr.subscription.accessDenied)).not.toBeInTheDocument();
      expect(await screen.findByTestId("parcours-interest-admin")).toBeInTheDocument();
    });

    it("refuses a non-admin", () => {
      h.role = {
        role: "student",
        isAdmin: false,
        currentParcoursId: "x",
        hasProfile: true,
        isLoaded: true,
      };
      renderPage(pageFor(INTEREST));

      expect(screen.getByText(fr.subscription.accessDenied)).toBeInTheDocument();
      expect(screen.queryByTestId("parcours-interest-admin")).not.toBeInTheDocument();
    });
  });

  // While the role is still loading (role === null), the guard must not flash the
  // access-denied screen — it only refuses once a non-admin role is known.
  it("does not flash access-denied while the role is still loading", () => {
    h.role = {
      role: null,
      isAdmin: false,
      currentParcoursId: null,
      hasProfile: false,
      isLoaded: false,
    };
    renderPage(pageFor(BETA));

    expect(screen.queryByText(fr.subscription.accessDenied)).not.toBeInTheDocument();
    expect(screen.queryByTestId("beta-requests-admin")).not.toBeInTheDocument();
  });
});
