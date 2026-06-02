import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
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
              userId: "user-123",
              claims: { sub: "user-123", user_metadata: { display_name: "Yahia" } },
            },
          });
        };
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

// ---- Query chain helper ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.gt = vi.fn().mockReturnValue(chain);
  chain.gte = vi.fn().mockReturnValue(chain);
  chain.lte = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue(chain);
  Object.assign(chain, result);
  return chain;
}

describe("gamification.dashboard — getDashboard", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns full dashboard data with existing profile", async () => {
    const profile = { id: "user-123", display_name: "Yahia", xp: 300, level: 2 };
    const subjects = [{ id: "s1", name_fr: "Math" }];
    const attempts = [
      {
        subject_id: "s1",
        score_pct: 80,
        xp_earned: 50,
        completed_at: "2026-06-01",
        exercise_id: "e1",
      },
    ];
    const badges = [
      {
        awarded_at: "2026-06-01",
        awarded_reason: "First win",
        badge: { code: "first", name: "First", rarity: "common", icon_name: null },
      },
    ];
    const inventory = [
      {
        quantity: 1,
        is_equipped: true,
        acquired_at: "2026-06-01",
        item: {
          id: "i1",
          code: "skin_a",
          name: "Skin A",
          item_type: "skin",
          description: null,
          price_coins: 100,
        },
      },
    ];
    const shopItems = [
      {
        id: "i1",
        code: "skin_a",
        name: "Skin A",
        item_type: "skin",
        description: null,
        price_coins: 100,
        is_active: true,
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery(subjects);
      if (table === "attempts") return mockQuery(attempts);
      if (table === "student_badges") return mockQuery(badges);
      if (table === "inventory_items") return mockQuery(inventory);
      if (table === "shop_items") return mockQuery(shopItems);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    expect(res.profile).toEqual(profile);
    expect(res.subjects).toEqual(subjects);
    expect(res.recent).toEqual(attempts);
    expect((res.badges as unknown[]).length).toBe(1);
    expect((res.shopItems as unknown[]).length).toBe(1);
  });

  it("creates profile if not found", async () => {
    const subjects = [{ id: "s1", name_fr: "Math" }];
    const newProfile = { id: "user-123", display_name: "Yahia", xp: 0, level: 1 };

    let profileCallCount = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        profileCallCount++;
        if (profileCallCount === 1) return mockQuery(null); // maybeSingle returns null
        if (profileCallCount === 2) return mockQuery(null); // insert
        return mockQuery(newProfile); // reload
      }
      if (table === "subjects") return mockQuery(subjects);
      if (table === "attempts") return mockQuery([]);
      if (table === "student_badges") return mockQuery([]);
      if (table === "inventory_items") return mockQuery([]);
      if (table === "shop_items") return mockQuery([]);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    expect(res.profile).toEqual(newProfile);
  });

  it("throws on profile fetch error", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(null, { message: "DB error" });
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");

    await expect((getDashboard as unknown as (d?: unknown) => Promise<unknown>)()).rejects.toThrow(
      "DB error",
    );
  });

  it("throws on subjects fetch error", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ id: "user-123" });
      if (table === "subjects") return mockQuery(null, { message: "Subjects error" });
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");

    await expect((getDashboard as unknown as (d?: unknown) => Promise<unknown>)()).rejects.toThrow(
      "Subjects error",
    );
  });

  it("computes per-subject stats correctly", async () => {
    const profile = { id: "user-123", display_name: "Yahia" };
    const attempts = [
      {
        subject_id: "s1",
        score_pct: 80,
        xp_earned: 50,
        completed_at: "2026-06-01",
        exercise_id: "e1",
      },
      {
        subject_id: "s1",
        score_pct: 60,
        xp_earned: 30,
        completed_at: "2026-06-01",
        exercise_id: "e2",
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([]);
      if (table === "attempts") return mockQuery(attempts);
      if (table === "student_badges") return mockQuery([]);
      if (table === "inventory_items") return mockQuery([]);
      if (table === "shop_items") return mockQuery([]);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as { stats: Record<string, { count: number; avg: number; xp: number }> };
    expect(res.stats.s1.count).toBe(2);
    expect(res.stats.s1.avg).toBe(70); // (80+60)/2
    expect(res.stats.s1.xp).toBe(80);
  });

  it("identifies next exercise when last attempt failed", async () => {
    const profile = { id: "user-123", display_name: "Yahia" };
    const attempts = [
      {
        subject_id: "s1",
        score_pct: 40,
        xp_earned: 10,
        completed_at: "2026-06-01",
        exercise_id: "e1",
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([]);
      if (table === "attempts") return mockQuery(attempts);
      if (table === "student_badges") return mockQuery([]);
      if (table === "inventory_items") return mockQuery([]);
      if (table === "shop_items") return mockQuery([]);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as { nextExerciseId: string | null };
    expect(res.nextExerciseId).toBe("e1");
  });
});

describe("gamification.dashboard — getLeaderboard", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns ranked leaderboard with current user", async () => {
    const topPlayers = [
      {
        id: "user-123",
        display_name: "Yahia",
        hero_class: "warrior",
        level: 5,
        xp: 1000,
        current_streak: 7,
        avatar_tier: "gold",
      },
      {
        id: "user-456",
        display_name: "Ali",
        hero_class: "mage",
        level: 3,
        xp: 500,
        current_streak: 3,
        avatar_tier: "bronze",
      },
    ];

    mockFrom.mockImplementation(() => mockQuery(topPlayers));

    const { getLeaderboard } = await import("@/features/dashboard");
    const result = await (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as { leaderboard: unknown[]; myRank: unknown };
    expect(res.leaderboard).toHaveLength(2);
    expect(res.myRank).toBeDefined();
  });

  it("throws on fetch error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "Leaderboard error" }));

    const { getLeaderboard } = await import("@/features/dashboard");

    await expect(
      (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow("Leaderboard error");
  });
});

describe("gamification.dashboard — getSprint2Dashboard", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns daily objectives, weekly quests, and spaced rep", async () => {
    const dailyObjs = [{ id: "d1", objective_type: "10_min", status: "active" }];
    const weeklyQs = [{ id: "w1", quest_type: "maintain_streak_5", status: "active" }];
    const spacedRep = [{ id: "sr1", retry_level: 1, scheduled_for: "2026-06-01" }];

    let callCount = 0;
    mockFrom.mockImplementation(() => {
      callCount++;
      if (callCount === 1) return mockQuery(dailyObjs);
      if (callCount === 2) return mockQuery(weeklyQs);
      if (callCount === 3) return mockQuery(spacedRep);
      return mockQuery([]);
    });

    const { getSprint2Dashboard } = await import("@/features/dashboard");
    const result = await (getSprint2Dashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    expect(res.dailyObjectives).toEqual(dailyObjs);
    expect(res.weeklyQuests).toEqual(weeklyQs);
  });

  it("throws on daily objectives error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "Daily error" }));

    const { getSprint2Dashboard } = await import("@/features/dashboard");

    await expect(
      (getSprint2Dashboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow("Daily error");
  });
});
