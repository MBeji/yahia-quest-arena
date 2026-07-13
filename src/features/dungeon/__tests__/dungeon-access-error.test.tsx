import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

// --- Real-component regression test ---
// Guards against the "infinite loading" dungeon bug: when the access query
// (get_dungeon_access) fails, the lobby used to stay stuck on the loading
// spinner forever (`accessQuery.isLoading || !access`). It must instead show an
// error with a working retry. We mount the REAL DungeonPage (captured from the
// route's createFileRoute call) — not a mirror harness.

let capturedComponent: React.ComponentType | undefined;

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: { component: React.ComponentType }) => {
    capturedComponent = opts.component;
    return {};
  },
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
  // BackLink (primitive du lot 1) est construit avec createLink.
  createLink:
    (Comp: React.ComponentType<Record<string, unknown>>) =>
    ({ to, params: _params, ...rest }: { to: string; params?: unknown }) =>
      React.createElement(Comp, { ...rest, href: to }),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
}));

// The access server fn is the unit under test — it rejects to simulate a failed
// get_dungeon_access RPC. The others are unused on the lobby error path.
const getDungeonAccess = vi.fn();
vi.mock("@/features/dungeon", () => ({
  getDungeonAccess: (...args: unknown[]) => getDungeonAccess(...args),
  getDungeonQuestions: vi.fn(),
  startDungeonRun: vi.fn(),
  submitDungeonAnswer: vi.fn(),
  submitDungeonRun: vi.fn(),
  DUNGEON_XP_PER_FLOOR: 15,
  DUNGEON_COINS_PER_5_FLOORS: 5,
}));

vi.mock("@/shared/lib/utils", async (importOriginal) => ({
  ...(await importOriginal<typeof import("@/shared/lib/utils")>()),
  isRtlText: () => false,
  isMathExpression: () => false,
}));

vi.mock("@/components/ui/svg-figure", () => ({
  RichField: ({ raw }: { raw: string }) => React.createElement("span", null, raw),
  OptionContent: ({ raw }: { raw: string }) => React.createElement("span", null, raw),
}));

vi.mock("motion/react", () => ({
  motion: new Proxy(
    {},
    {
      get: (_target, prop: string) => {
        return ({ children, className, ...props }: Record<string, unknown>) =>
          React.createElement(
            prop,
            { className, ...filterDomProps(props) },
            children as React.ReactNode,
          );
      },
    },
  ),
  AnimatePresence: ({ children }: { children: React.ReactNode }) => children,
  useReducedMotion: () => false,
}));

// Drop motion-only props that React would warn about on a plain DOM element.
function filterDomProps(props: Record<string, unknown>) {
  const { initial, animate, exit, transition, ...rest } = props;
  void initial;
  void animate;
  void exit;
  void transition;
  return rest;
}

vi.mock("sonner", () => ({
  toast: { error: vi.fn(), success: vi.fn() },
}));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    common: { loading: "LOADING", retry: "RETRY", backToHall: "BACK" },
    dungeon: {
      loadAccessError: "ACCESS_ERROR",
      title: "Dungeon",
      desc: "desc",
      heroesHall: "hall",
      xpPerFloor: "xp",
      coinsPerFloors: "coins",
      life: "life",
      locked: "LOCKED",
      prereqLocked: "prereq",
      subjectsStarted: "subjects {done}/{required}",
      chaptersStarted: "chapters {done}/{required}",
      keepTraining: "keep training",
    },
  }),
}));

function createWrapper() {
  const qc = new QueryClient({
    defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
  });
  return ({ children }: { children: React.ReactNode }) =>
    React.createElement(QueryClientProvider, { client: qc }, children);
}

async function renderDungeon() {
  // Importing the route module runs createFileRoute, capturing DungeonPage.
  await import("@/routes/_authenticated/dungeon");
  const DungeonPage = capturedComponent;
  if (!DungeonPage) throw new Error("DungeonPage was not captured from the route module");
  const Wrapper = createWrapper();
  return render(React.createElement(Wrapper, null, React.createElement(DungeonPage)));
}

describe("Dungeon lobby — access query failure", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("shows an error with a retry instead of an endless spinner when access fails", async () => {
    getDungeonAccess.mockRejectedValue(new Error("RPC failed"));

    await renderDungeon();

    await waitFor(() => {
      expect(screen.getByText("ACCESS_ERROR")).toBeInTheDocument();
    });
    // The endless loading text must NOT be shown once the query has errored.
    expect(screen.queryByText("LOADING")).not.toBeInTheDocument();
    expect(screen.getByRole("button", { name: /retry/i })).toBeInTheDocument();
  });

  it("retry refetches the access query and clears the error on success", async () => {
    // Phase gratuite (étude 15, lot 2) : plus de raison SUBSCRIPTION — le premier
    // verrou possible est le prérequis de progression.
    getDungeonAccess.mockRejectedValueOnce(new Error("RPC failed")).mockResolvedValue({
      level: 3,
      maxRunsPerDay: 3,
      runsToday: 0,
      remaining: 3,
      subjectsDone: 0,
      chaptersDone: 0,
      requiredSubjects: 2,
      requiredChapters: 3,
      hasSubscription: true,
      canAccess: false,
      reason: "PREREQ",
    });

    await renderDungeon();

    await waitFor(() => {
      expect(screen.getByText("ACCESS_ERROR")).toBeInTheDocument();
    });

    fireEvent.click(screen.getByRole("button", { name: /retry/i }));

    // After a successful refetch the error is gone and the progress lock renders
    // (reason === "PREREQ").
    await waitFor(() => {
      expect(screen.queryByText("ACCESS_ERROR")).not.toBeInTheDocument();
      expect(screen.getByText("LOCKED")).toBeInTheDocument();
    });
    expect(getDungeonAccess).toHaveBeenCalledTimes(2);
  });
});
