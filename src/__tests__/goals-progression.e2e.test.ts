/**
 * END-TO-END SCENARIO SUITE — DAILY/WEEKLY GOALS, PROGRESSION & LEADERBOARDS
 * =========================================================================
 * Realistic NON-REGRESSION scenarios that chain server functions together to
 * exercise the goals/progression/leaderboard journeys against the mocked
 * Supabase layer:
 *   - daily/weekly goals are ensured on dashboard bootstrap & on submit,
 *   - goal progress is reflected across reads,
 *   - the submit path ensures goals BEFORE the atomic scoring RPC,
 *   - global & per-subject leaderboards rank players and resolve myRank,
 *   - spaced-repetition reviews surface, and empty goal sets resolve cleanly.
 * Complements the per-function suite and e2e-scenarios.test.ts.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };
let capturedHandlers: Record<string, (...args: unknown[]) => unknown> = {};

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: ({ method }: { method: string }) => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      inputValidator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        const wrapped = async (input: unknown) => {
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({
            data,
            context: {
              supabase: mockSupabase,
              userId: "user-regression-test",
              claims: { sub: "user-regression-test", user_metadata: { display_name: "Yahia" } },
            },
          });
        };
        capturedHandlers[method + "_" + Object.keys(capturedHandlers).length] = wrapped;
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: vi.fn().mockResolvedValue(false) }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of [
    "select",
    "eq",
    "gt",
    "gte",
    "lte",
    "neq",
    "in",
    "order",
    "limit",
    "insert",
    "update",
    "upsert",
    "delete",
  ]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.then = (resolve: (v: unknown) => unknown) => resolve(result);
  Object.assign(chain, result);
  return chain;
}

// =============================================================================
// END-TO-END SCENARIOS — chain multiple server fns to mimic real journeys.
// Each step re-arms the supabase mock so every call gets a realistic response.
// =============================================================================
const EX = "22222222-2222-2222-2222-222222222222";
const SESS = "11111111-1111-1111-1111-111111111111";
const Q = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
const CH = "33333333-3333-3333-3333-333333333333";
const REQ = "44444444-4444-4444-4444-444444444444";
const U = "55555555-5555-5555-5555-555555555555";

/** Dispatch RPC responses by function name (default ok/empty). */
function rpcByName(map: Record<string, { data?: unknown; error?: unknown }>) {
  return (fn: string) => Promise.resolve(map[fn] ?? { data: null, error: null });
}

type Fn = (d?: unknown) => Promise<unknown>;

// Touch otherwise-unused harness constants so the verbatim copy doesn't trip
// the project's zero-warning lint policy (no-unused-vars).
void [CH, REQ, U, rpcByName];

const ME = "user-regression-test";

/** A daily-objectives row, defaulting to the canonical "3 exercises" goal. */
function dailyRow(overrides: Record<string, unknown> = {}) {
  return {
    id: "obj-daily-1",
    objective_type: "3_exercises",
    target_value: 3,
    current_value: 0,
    xp_reward: 50,
    coin_reward: 10,
    status: "active",
    completed_at: null,
    ...overrides,
  };
}

/** A weekly-quests row, defaulting to the "beat 2 bosses" quest. */
function weeklyRow(overrides: Record<string, unknown> = {}) {
  return {
    id: "quest-weekly-1",
    quest_type: "beat_2_bosses",
    target_value: 2,
    current_value: 0,
    xp_reward: 200,
    coin_reward: 50,
    status: "active",
    completed_at: null,
    ...overrides,
  };
}

describe("END-TO-END: daily/weekly goals are ensured on dashboard bootstrap", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getSprint2Dashboard ensures goals then returns the daily objective + weekly quest", async () => {
    const { getSprint2Dashboard } = await import("@/features/dashboard");

    mockFrom.mockImplementation((table: string) => {
      if (table === "daily_objectives") return mockQuery([dailyRow()]);
      if (table === "weekly_quests") return mockQuery([weeklyRow()]);
      if (table === "spaced_repetition_schedule") return mockQuery([]);
      return mockQuery([]);
    });
    mockRpc.mockResolvedValue({ data: null, error: null });

    const dash = (await (getSprint2Dashboard as unknown as Fn)()) as {
      dailyObjectives: Array<Record<string, unknown>>;
      weeklyQuests: Array<Record<string, unknown>>;
      pendingSpacedReps: unknown[];
    };

    // The on-demand goal creation RPC must run with the authenticated user id.
    expect(mockRpc).toHaveBeenCalledWith("ensure_daily_weekly_goals", { p_user: ME });

    expect(dash.dailyObjectives).toHaveLength(1);
    expect(dash.dailyObjectives[0].objective_type).toBe("3_exercises");
    expect(dash.dailyObjectives[0].target_value).toBe(3);

    expect(dash.weeklyQuests).toHaveLength(1);
    expect(dash.weeklyQuests[0].quest_type).toBe("beat_2_bosses");
    expect(dash.weeklyQuests[0].target_value).toBe(2);
  });
});

describe("END-TO-END: daily goal progress is reflected across reads", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("current_value climbs 0/3 → 1/3 → 3/3 (completed) across successive dashboards", async () => {
    const { getSprint2Dashboard } = await import("@/features/dashboard");
    mockRpc.mockResolvedValue({ data: null, error: null });

    const readDaily = async (row: Record<string, unknown>) => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "daily_objectives") return mockQuery([row]);
        if (table === "weekly_quests") return mockQuery([weeklyRow()]);
        return mockQuery([]);
      });
      const dash = (await (getSprint2Dashboard as unknown as Fn)()) as {
        dailyObjectives: Array<Record<string, unknown>>;
      };
      return dash.dailyObjectives[0];
    };

    const start = await readDaily(dailyRow({ current_value: 0, status: "active" }));
    expect(start.current_value).toBe(0);
    expect(start.status).toBe("active");

    const mid = await readDaily(dailyRow({ current_value: 1, status: "active" }));
    expect(mid.current_value).toBe(1);
    expect(mid.status).toBe("active");

    const done = await readDaily(
      dailyRow({
        current_value: 3,
        status: "completed",
        completed_at: "2026-06-04T12:00:00Z",
      }),
    );
    expect(done.current_value).toBe(done.target_value);
    expect(done.status).toBe("completed");
    expect(done.completed_at).not.toBeNull();
  });
});

describe("END-TO-END: submitAttempt ensures goals before the atomic scoring RPC", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("calls ensure_daily_weekly_goals before submit_exercise_attempt", async () => {
    const { submitAttempt } = await import("@/features/quest");

    mockFrom.mockImplementation((table: string) => {
      if (table === "questions")
        return mockQuery([{ id: Q, prompt: "2+2?", correct_option: "4", explanation: "x" }]);
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery([]);
    });

    const callOrder: string[] = [];
    mockRpc.mockImplementation((fn: string) => {
      callOrder.push(fn);
      if (fn === "submit_exercise_attempt") {
        return Promise.resolve({
          data: {
            correct: 1,
            total: 1,
            scorePct: 100,
            xpEarned: 10,
            coinsEarned: 2,
            durationSeconds: 30,
            profile: null,
            unlockedBadges: [],
          },
          error: null,
        });
      }
      return Promise.resolve({ data: null, error: null });
    });

    const result = (await (submitAttempt as unknown as Fn)({
      sessionId: SESS,
      exerciseId: EX,
      answers: [{ questionId: Q, choice: "4" }],
    })) as Record<string, unknown>;

    expect(mockRpc).toHaveBeenCalledWith("ensure_daily_weekly_goals", { p_user: ME });
    const ensureIdx = callOrder.indexOf("ensure_daily_weekly_goals");
    const submitIdx = callOrder.indexOf("submit_exercise_attempt");
    expect(ensureIdx).toBeGreaterThanOrEqual(0);
    expect(submitIdx).toBeGreaterThan(ensureIdx);
    expect(result.scorePct).toBe(100);
  });
});

describe("END-TO-END: global leaderboard ranking + myRank", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns ranked top players and flags the current user as isMe", async () => {
    const { getLeaderboard } = await import("@/features/dashboard");

    // Global board reads through the RLS-safe `get_global_leaderboard` RPC, which
    // already returns rank + is_me and exposes no peer/self UUID.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Yahia",
          hero_class: "mage",
          level: 12,
          xp: 2400,
          current_streak: 7,
          avatar_tier: 3,
          is_me: true,
        },
        {
          rank: 2,
          display_name: "Sami",
          hero_class: "warrior",
          level: 9,
          xp: 1800,
          current_streak: 4,
          avatar_tier: 2,
          is_me: false,
        },
        {
          rank: 3,
          display_name: "Lina",
          hero_class: "rogue",
          level: 7,
          xp: 1200,
          current_streak: 2,
          avatar_tier: 1,
          is_me: false,
        },
      ],
      error: null,
    });

    const res = (await (getLeaderboard as unknown as Fn)()) as {
      leaderboard: Array<Record<string, unknown>>;
      myRank: Record<string, unknown> | null;
    };

    expect(res.leaderboard).toHaveLength(3);
    expect(res.leaderboard.map((r) => r.rank)).toEqual([1, 2, 3]);
    // SECURITY (P0 S2b): rows expose no peer/self UUID; self is flagged by isMe.
    expect(res.leaderboard[0].isMe).toBe(true);
    expect(res.leaderboard[0]).not.toHaveProperty("id");
    expect(res.leaderboard[1].isMe).toBe(false);
    expect(res.myRank?.rank).toBe(1);
    expect(res.myRank?.isMe).toBe(true);
  });

  it("surfaces myRank from the caller's own row when outside the top window", async () => {
    const { getLeaderboard } = await import("@/features/dashboard");

    // The RPC always includes the caller's own row (here rank 99) even when it
    // falls past the visible window (LEADERBOARD_LIMIT = 50); the client list
    // trims to the top window so the self row drops out of `leaderboard`.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Sami",
          hero_class: "warrior",
          level: 20,
          xp: 5000,
          current_streak: 9,
          avatar_tier: 4,
          is_me: false,
        },
        {
          rank: 2,
          display_name: "Lina",
          hero_class: "rogue",
          level: 18,
          xp: 4200,
          current_streak: 6,
          avatar_tier: 3,
          is_me: false,
        },
        {
          rank: 99,
          display_name: "Yahia",
          hero_class: "mage",
          level: 3,
          xp: 300,
          current_streak: 1,
          avatar_tier: 1,
          is_me: true,
        },
      ],
      error: null,
    });

    const res = (await (getLeaderboard as unknown as Fn)()) as {
      leaderboard: Array<Record<string, unknown>>;
      myRank: Record<string, unknown> | null;
    };

    // Top window keeps the two visible peers (rank 99 is past LEADERBOARD_LIMIT).
    expect(res.leaderboard.some((r) => r.isMe)).toBe(false);
    expect(res.myRank?.rank).toBe(99);
    expect(res.myRank?.isMe).toBe(true);
    expect(res.myRank).not.toHaveProperty("id");
    expect(res.myRank?.xp).toBe(300);
  });
});

describe("END-TO-END: per-subject leaderboard maps the RPC rows", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("maps get_subject_leaderboard rows (rank, subject_xp, is_me)", async () => {
    const { getSubjectLeaderboard } = await import("@/features/dashboard");

    // SECURITY (P0 S2b): the RPC no longer returns peer `user_id`s; the self
    // row is flagged by `is_me`.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Sami",
          hero_class: "warrior",
          level: 10,
          subject_xp: 900,
          current_streak: 5,
          avatar_tier: 3,
          is_me: false,
        },
        {
          rank: 2,
          display_name: "Yahia",
          hero_class: "mage",
          level: 8,
          subject_xp: 640,
          current_streak: 3,
          avatar_tier: 2,
          is_me: true,
        },
      ],
      error: null,
    });

    const res = (await (getSubjectLeaderboard as unknown as Fn)({ subjectId: "s1" })) as {
      leaderboard: Array<Record<string, unknown>>;
      myRank: Record<string, unknown> | null;
    };

    expect(mockRpc).toHaveBeenCalledWith(
      "get_subject_leaderboard",
      expect.objectContaining({ p_subject: "s1" }),
    );
    expect(res.leaderboard).toHaveLength(2);
    expect(res.leaderboard[0].rank).toBe(1);
    expect(res.leaderboard[0].xp).toBe(900);
    expect(res.leaderboard[1].isMe).toBe(true);
    expect(res.leaderboard[1]).not.toHaveProperty("id");
    expect(res.myRank?.rank).toBe(2);
    expect(res.myRank?.xp).toBe(640);
  });
});

describe("END-TO-END: spaced repetition surfaces on the dashboard", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getSprint2Dashboard returns pendingSpacedReps", async () => {
    const { getSprint2Dashboard } = await import("@/features/dashboard");
    mockRpc.mockResolvedValue({ data: null, error: null });

    mockFrom.mockImplementation((table: string) => {
      if (table === "daily_objectives") return mockQuery([dailyRow()]);
      if (table === "weekly_quests") return mockQuery([weeklyRow()]);
      if (table === "spaced_repetition_schedule")
        return mockQuery([
          {
            id: "srs-1",
            retry_level: 2,
            scheduled_for: "2026-06-03T00:00:00Z",
            exercises: { id: EX, title: "Révision: équations" },
          },
        ]);
      return mockQuery([]);
    });

    const dash = (await (getSprint2Dashboard as unknown as Fn)()) as {
      pendingSpacedReps: Array<Record<string, unknown>>;
    };

    expect(dash.pendingSpacedReps).toHaveLength(1);
    expect(dash.pendingSpacedReps[0].id).toBe("srs-1");
    expect(dash.pendingSpacedReps[0].retry_level).toBe(2);
  });
});

describe("END-TO-END: empty goal sets still resolve (no throw)", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getSprint2Dashboard with empty objectives/quests/reps returns empty arrays", async () => {
    const { getSprint2Dashboard } = await import("@/features/dashboard");
    mockRpc.mockResolvedValue({ data: null, error: null });

    mockFrom.mockImplementation(() => mockQuery([]));

    const dash = (await (getSprint2Dashboard as unknown as Fn)()) as {
      dailyObjectives: unknown[];
      weeklyQuests: unknown[];
      pendingSpacedReps: unknown[];
    };

    expect(dash.dailyObjectives).toEqual([]);
    expect(dash.weeklyQuests).toEqual([]);
    expect(dash.pendingSpacedReps).toEqual([]);
    // Goals are still ensured even when the read comes back empty.
    expect(mockRpc).toHaveBeenCalledWith("ensure_daily_weekly_goals", { p_user: ME });
  });
});
