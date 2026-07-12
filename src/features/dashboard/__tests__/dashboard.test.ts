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
  chain.is = vi.fn().mockReturnValue(chain);
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
    // Default: the per-subject stats RPC returns no rows. Tests that assert on
    // stats override this with their own aggregate rows.
    mockRpc.mockReturnValue({ data: [], error: null });
  });

  // Parcours-based subject scoping (active parcours, premium lock, null parcours)
  // is covered in the co-located dashboard-parcours.test.ts.

  it("returns primary dashboard data with existing profile", async () => {
    const profile = {
      id: "user-123",
      display_name: "Yahia",
      xp: 300,
      level: 2,
      current_parcours_id: null,
    };
    const attempts = [
      {
        subject_id: "s1",
        score_pct: 80,
        xp_earned: 50,
        completed_at: "2026-06-01",
        exercise_id: "e1",
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([]);
      if (table === "attempts") return mockQuery(attempts);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    expect(res.profile).toEqual(profile);
    expect(res.recent).toEqual(attempts);
    // #15: badges/inventory/shop moved out of the primary fn.
    expect(res.badges).toBeUndefined();
    expect(res.inventory).toBeUndefined();
    expect(res.shopItems).toBeUndefined();
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

  it("throws a generic French message on profile fetch error (#14)", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(null, { message: "DB error" });
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");

    // #14: raw Supabase error.message must NOT leak to the client.
    await expect((getDashboard as unknown as (d?: unknown) => Promise<unknown>)()).rejects.toThrow(
      /tableau de bord/i,
    );
  });

  it("throws a generic French message on subjects fetch error (#14)", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ id: "user-123" });
      if (table === "subjects") return mockQuery(null, { message: "Subjects error" });
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");

    await expect((getDashboard as unknown as (d?: unknown) => Promise<unknown>)()).rejects.toThrow(
      /tableau de bord/i,
    );
  });

  it("computes per-subject stats from the stats RPC aggregate", async () => {
    const profile = { id: "user-123", display_name: "Yahia" };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([]);
      if (table === "attempts") return mockQuery([]);
      return mockQuery([]);
    });
    // get_user_subject_stats returns one bounded row per subject (GROUP BY).
    mockRpc.mockReturnValue({
      data: [{ subject_id: "s1", attempts_count: 2, avg_score: 70, total_xp: 80 }],
      error: null,
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as { stats: Record<string, { count: number; avg: number; xp: number }> };
    expect(res.stats.s1.count).toBe(2);
    expect(res.stats.s1.avg).toBe(70);
    expect(res.stats.s1.xp).toBe(80);
  });

  it("stats come from the RPC (full history), independent of the recent window (#18)", async () => {
    const profile = { id: "user-123", display_name: "Yahia" };
    // The recent (limited) attempts query returns 1 row; the stats RPC aggregates
    // the FULL set (3 attempts) — the dashboard stats must reflect the RPC, not
    // the recent window.
    const recent = [
      {
        subject_id: "s1",
        score_pct: 90,
        xp_earned: 50,
        completed_at: "2026-06-03",
        exercise_id: "e3",
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([]);
      if (table === "attempts") return mockQuery(recent);
      return mockQuery([]);
    });
    mockRpc.mockReturnValue({
      data: [{ subject_id: "s1", attempts_count: 3, avg_score: 60, total_xp: 90 }],
      error: null,
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as { stats: Record<string, { count: number; avg: number; xp: number }> };
    expect(res.stats.s1.count).toBe(3);
    expect(res.stats.s1.avg).toBe(60);
    expect(res.stats.s1.xp).toBe(90);
  });

  it("degrades to empty stats when the stats RPC errors (deploy-race safe)", async () => {
    const profile = { id: "user-123", display_name: "Yahia" };
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([]);
      if (table === "attempts") return mockQuery([]);
      return mockQuery([]);
    });
    mockRpc.mockReturnValue({ data: null, error: { message: "function does not exist" } });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    // The dashboard still renders; stats are simply empty rather than throwing.
    const res = result as { stats: Record<string, unknown> };
    expect(res.stats).toEqual({});
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

  it("returns ranked leaderboard with current user via the RLS-safe RPC", async () => {
    // The global board reads through the SECURITY DEFINER `get_global_leaderboard`
    // RPC (not `profiles` directly), so it can see peers despite the "own or linked
    // profiles" RLS policy. The RPC already returns rank + is_me and no peer UUID.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Yahia",
          hero_class: "warrior",
          level: 5,
          xp: 1000,
          current_streak: 7,
          avatar_tier: 3,
          is_me: true,
        },
        {
          rank: 2,
          display_name: "Ali",
          hero_class: "mage",
          level: 3,
          xp: 500,
          current_streak: 3,
          avatar_tier: 1,
          is_me: false,
        },
      ],
      error: null,
    });

    const { getLeaderboard } = await import("@/features/dashboard");
    const result = await (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as {
      leaderboard: Record<string, unknown>[];
      myRank: Record<string, unknown> | null;
    };

    expect(mockRpc).toHaveBeenCalledWith("get_global_leaderboard", {
      p_limit: expect.any(Number),
    });
    expect(res.leaderboard).toHaveLength(2);
    expect(res.myRank).toMatchObject({ rank: 1, isMe: true });

    // SECURITY (P0 S2b): the global leaderboard must not surface any peer UUIDs.
    // `isMe` comes from the RPC; rows are keyed by `rank` on the client.
    expect(res.leaderboard[0]).toMatchObject({ rank: 1, isMe: true });
    expect(res.leaderboard[1]).toMatchObject({ rank: 2, isMe: false });
    for (const row of res.leaderboard) {
      expect(row).not.toHaveProperty("id");
      expect(row).not.toHaveProperty("user_id");
    }
  });

  it("returns my rank even when I fall outside the visible top window", async () => {
    // The RPC always includes the caller's own row (rank > limit) so "my rank" is
    // known; the client list still trims it to the top LEADERBOARD_LIMIT rows.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Top",
          hero_class: "S-Rank",
          level: 10,
          xp: 9999,
          current_streak: 4,
          avatar_tier: 3,
          is_me: false,
        },
        {
          rank: 99,
          display_name: "Me",
          hero_class: "Novice",
          level: 2,
          xp: 50,
          current_streak: 1,
          avatar_tier: 1,
          is_me: true,
        },
      ],
      error: null,
    });

    const { getLeaderboard } = await import("@/features/dashboard");
    const result = (await (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)()) as {
      leaderboard: Record<string, unknown>[];
      myRank: { rank: number; isMe: boolean } | null;
    };

    expect(result.myRank).toMatchObject({ rank: 99, isMe: true });
  });

  it("throws a generic French message on RPC error (#14)", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Leaderboard error" } });

    const { getLeaderboard } = await import("@/features/dashboard");

    await expect(
      (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
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
    // The goals are created on demand so the widgets are never empty/stuck at 0.
    expect(mockRpc).toHaveBeenCalledWith("ensure_daily_weekly_goals", {
      p_user: expect.any(String),
    });
  });

  it("throws a generic French message on daily objectives error (#14)", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "Daily error" }));

    const { getSprint2Dashboard } = await import("@/features/dashboard");

    await expect(
      (getSprint2Dashboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
  });

  it("filters daily objectives to today only via eq, not a 24h window (#2)", async () => {
    const dailyChain = mockQuery([]);
    mockFrom.mockImplementation((table: string) => {
      if (table === "daily_objectives") return dailyChain;
      return mockQuery([]);
    });

    const { getSprint2Dashboard } = await import("@/features/dashboard");
    await (getSprint2Dashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const today = new Date().toISOString().slice(0, 10);
    // #2: must be an exact-match on today's date, never a gte lower bound.
    expect(dailyChain.eq).toHaveBeenCalledWith("objective_date", today);
    expect(dailyChain.gte).not.toHaveBeenCalledWith("objective_date", expect.anything());
  });
});

describe("gamification.dashboard — getDashboardSecondary", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns badges, inventory and shop items (#15)", async () => {
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
        effect_payload: { avatarSlug: "samurai" },
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "student_badges") return mockQuery(badges);
      if (table === "inventory_items") return mockQuery(inventory);
      if (table === "shop_items") return mockQuery(shopItems);
      return mockQuery([]);
    });

    const { getDashboardSecondary } = await import("@/features/dashboard");
    const result = await (getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    expect((res.badges as unknown[]).length).toBe(1);
    expect((res.inventory as unknown[]).length).toBe(1);
    const shop = res.shopItems as Array<{
      isOwned: boolean;
      isEquipped: boolean;
      avatarSlug: string | null;
    }>;
    expect(shop.length).toBe(1);
    expect(shop[0].isOwned).toBe(true);
    expect(shop[0].isEquipped).toBe(true);
    expect(shop[0].avatarSlug).toBe("samurai");
  });

  it("marks owned multiplier potions as armable and surfaces the armed one (#consumables)", async () => {
    const inventory = [
      {
        quantity: 2,
        is_equipped: false,
        is_active: true,
        acquired_at: "2026-06-02",
        item: {
          id: "p1",
          code: "potion_xp_boost",
          name: "XP Boost",
          item_type: "potion",
          description: "XP x2",
          price_coins: 50,
          effect_payload: { xpMultiplier: 2, uses: 1 },
        },
      },
      {
        quantity: 1,
        is_equipped: false,
        is_active: false,
        acquired_at: "2026-06-01",
        item: {
          id: "p2",
          code: "potion_rappel",
          name: "Rappel",
          item_type: "potion",
          description: "hint",
          price_coins: 30,
          effect_payload: { hintBoost: 1 },
        },
      },
    ];
    const shopItems = [
      {
        id: "p1",
        code: "potion_xp_boost",
        name: "XP Boost",
        item_type: "potion",
        description: "XP x2",
        price_coins: 50,
        is_active: true,
        effect_payload: { xpMultiplier: 2, uses: 1 },
      },
      {
        id: "p2",
        code: "potion_rappel",
        name: "Rappel",
        item_type: "potion",
        description: "hint",
        price_coins: 30,
        is_active: true,
        effect_payload: { hintBoost: 1 },
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "student_badges") return mockQuery([]);
      if (table === "inventory_items") return mockQuery(inventory);
      if (table === "shop_items") return mockQuery(shopItems);
      return mockQuery([]);
    });

    const { getDashboardSecondary } = await import("@/features/dashboard");
    const result = await (getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    const inv = res.inventory as Array<{ code: string; isArmable: boolean; isActive: boolean }>;
    const xpInv = inv.find((i) => i.code === "potion_xp_boost");
    const hintInv = inv.find((i) => i.code === "potion_rappel");
    // Multiplier potion is armable and currently armed; hint potion is neither.
    expect(xpInv?.isArmable).toBe(true);
    expect(xpInv?.isActive).toBe(true);
    expect(hintInv?.isArmable).toBe(false);

    const shop = res.shopItems as Array<{ code: string; isArmable: boolean; isActive: boolean }>;
    const xpShop = shop.find((i) => i.code === "potion_xp_boost");
    const hintShop = shop.find((i) => i.code === "potion_rappel");
    expect(xpShop?.isArmable).toBe(true);
    expect(xpShop?.isActive).toBe(true);
    // Hint potion is owned but NOT armable (out of scope this iteration).
    expect(hintShop?.isArmable).toBe(false);
  });

  it("throws a generic French message on badges error (#14)", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "student_badges") return mockQuery(null, { message: "Badges error" });
      return mockQuery([]);
    });

    const { getDashboardSecondary } = await import("@/features/dashboard");

    await expect(
      (getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
  });
});

describe("gamification.dashboard — getLeaderboardSubjects", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns only the active parcours' subjects (school parcours: theme + grade)", async () => {
    const subjects = [{ id: "math-9", name_fr: "Mathématiques", color_token: "subject-math" }];
    const subjectsChain = mockQuery(subjects);
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ current_parcours_id: "concours-9eme" });
      if (table === "parcours") return mockQuery({ theme_id: "ecole-tn", grade_id: "g-9" });
      return subjectsChain;
    });

    const { getLeaderboardSubjects } = await import("@/features/dashboard");
    const result = (await (
      getLeaderboardSubjects as unknown as (d?: unknown) => Promise<unknown>
    )()) as { subjects: unknown[] };

    expect(result.subjects).toEqual(subjects);
    expect(subjectsChain.eq).toHaveBeenCalledWith("theme_id", "ecole-tn");
    expect(subjectsChain.eq).toHaveBeenCalledWith("grade_id", "g-9");
  });

  it("scopes to null-grade subjects for a non-school (exploration) parcours", async () => {
    const subjectsChain = mockQuery([{ id: "cg-fr", name_fr: "Histoire" }]);
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ current_parcours_id: "culture-generale" });
      if (table === "parcours") return mockQuery({ theme_id: "culture-generale", grade_id: null });
      return subjectsChain;
    });

    const { getLeaderboardSubjects } = await import("@/features/dashboard");
    await (getLeaderboardSubjects as unknown as (d?: unknown) => Promise<unknown>)();

    expect(subjectsChain.is).toHaveBeenCalledWith("grade_id", null);
  });

  it("returns an empty list when the student has no active parcours (pre-onboarding)", async () => {
    mockFrom.mockImplementation(() => mockQuery({ current_parcours_id: null }));

    const { getLeaderboardSubjects } = await import("@/features/dashboard");
    const result = (await (
      getLeaderboardSubjects as unknown as (d?: unknown) => Promise<unknown>
    )()) as { subjects: unknown[] };

    expect(result.subjects).toEqual([]);
  });
});

describe("gamification.dashboard — getSubjectLeaderboard", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("maps RPC rows and extracts my rank (subject XP) WITHOUT exposing peer UUIDs", async () => {
    // SECURITY (P0 S2b): the RPC no longer returns peer `user_id`s; the self row
    // is flagged by `is_me`. The mapped output must carry NO `id` field at all.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Top",
          hero_class: "S-Rank",
          level: 10,
          current_streak: 3,
          avatar_tier: 2,
          subject_xp: 500,
          is_me: false,
        },
        {
          rank: 4,
          display_name: "Yahia",
          hero_class: "Novice",
          level: 3,
          current_streak: 1,
          avatar_tier: 1,
          subject_xp: 120,
          is_me: true,
        },
      ],
      error: null,
    });

    const { getSubjectLeaderboard } = await import("@/features/dashboard");
    const result = (await (getSubjectLeaderboard as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "math",
    })) as {
      leaderboard: Record<string, unknown>[];
      myRank: Record<string, unknown> | null;
    };

    expect(mockRpc).toHaveBeenCalledWith("get_subject_leaderboard", {
      p_subject: "math",
      p_limit: expect.any(Number),
    });
    expect(result.leaderboard).toHaveLength(2);
    expect(result.leaderboard[0]).toMatchObject({ xp: 500, rank: 1, isMe: false });
    expect(result.myRank).toMatchObject({ xp: 120, rank: 4, isMe: true });

    // No row — peer OR self — may carry a raw user id field.
    for (const row of [...result.leaderboard, result.myRank]) {
      expect(row).not.toHaveProperty("id");
      expect(row).not.toHaveProperty("user_id");
    }
  });

  it("throws a friendly error when the RPC fails", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });

    const { getSubjectLeaderboard } = await import("@/features/dashboard");

    await expect(
      (getSubjectLeaderboard as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "math" }),
    ).rejects.toThrow(/tableau de bord/i);
  });
});

describe("gamification.dashboard — branch coverage (error/empty paths)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getLeaderboard returns a null myRank when the RPC omits the caller's row", async () => {
    // Defensive: if the caller has no student profile the RPC returns no self row,
    // so myRank is null and the board still renders the visible peers.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Other",
          hero_class: "mage",
          level: 9,
          xp: 9999,
          current_streak: 0,
          avatar_tier: 1,
          is_me: false,
        },
      ],
      error: null,
    });

    const { getLeaderboard } = await import("@/features/dashboard");
    const res = (await (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)()) as {
      leaderboard: unknown[];
      myRank: unknown;
    };
    expect(res.leaderboard).toHaveLength(1);
    expect(res.myRank).toBeNull();
  });

  it("getDashboardSecondary skips null badge/item rows and marks unowned shop items", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "student_badges")
        return mockQuery([{ awarded_at: "d", awarded_reason: "r", badge: null }]);
      if (table === "inventory_items")
        return mockQuery([{ quantity: 1, is_equipped: false, acquired_at: "d", item: null }]);
      if (table === "shop_items")
        return mockQuery([
          {
            id: "i9",
            code: "skin_z",
            name: "Z",
            item_type: "skin",
            description: null,
            price_coins: 50,
            is_active: true,
          },
        ]);
      return mockQuery([]);
    });
    const { getDashboardSecondary } = await import("@/features/dashboard");
    const res = (await (
      getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>
    )()) as {
      badges: unknown[];
      inventory: unknown[];
      shopItems: Array<{ isOwned: boolean; isEquipped: boolean; quantity: number }>;
    };
    expect(res.badges).toEqual([]);
    expect(res.inventory).toEqual([]);
    expect(res.shopItems[0]).toMatchObject({ isOwned: false, isEquipped: false, quantity: 0 });
  });

  it("getDashboardSecondary throws on inventory error and on shop error", async () => {
    const { getDashboardSecondary } = await import("@/features/dashboard");

    mockFrom.mockImplementation((table: string) => {
      if (table === "inventory_items") return mockQuery(null, { message: "inv error" });
      return mockQuery([]);
    });
    await expect(
      (getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);

    mockFrom.mockImplementation((table: string) => {
      if (table === "shop_items") return mockQuery(null, { message: "shop error" });
      return mockQuery([]);
    });
    await expect(
      (getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
  });

  it("getLeaderboardSubjects throws a generic message on a subjects fetch error", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ current_parcours_id: "concours-9eme" });
      if (table === "parcours") return mockQuery({ theme_id: "ecole-tn", grade_id: "g-9" });
      return mockQuery(null, { message: "subjects error" });
    });
    const { getLeaderboardSubjects } = await import("@/features/dashboard");
    await expect(
      (getLeaderboardSubjects as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
  });

  it("getSprint2Dashboard throws on weekly-quests error and on spaced-rep error", async () => {
    const { getSprint2Dashboard } = await import("@/features/dashboard");

    let n = 0;
    mockFrom.mockImplementation(() => {
      n += 1;
      return n === 2 ? mockQuery(null, { message: "weekly error" }) : mockQuery([]);
    });
    await expect(
      (getSprint2Dashboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);

    n = 0;
    mockFrom.mockImplementation(() => {
      n += 1;
      return n === 3 ? mockQuery(null, { message: "spaced error" }) : mockQuery([]);
    });
    await expect(
      (getSprint2Dashboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
  });
});

describe("gamification.dashboard — getMyFamilyGoal", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns the parsed goal for the signed-in student", async () => {
    mockRpc.mockResolvedValue({
      data: { weekStart: "2026-06-29", target: 5, done: 3 },
      error: null,
    });

    const { getMyFamilyGoal } = await import("@/features/dashboard");
    const result = await (getMyFamilyGoal as unknown as (d?: unknown) => Promise<unknown>)();

    expect(result).toEqual({ weekStart: "2026-06-29", target: 5, done: 3 });
  });

  it("returns null when no goal is set this week", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { getMyFamilyGoal } = await import("@/features/dashboard");
    expect(await (getMyFamilyGoal as unknown as (d?: unknown) => Promise<unknown>)()).toBeNull();
  });

  it("degrades to null when the RPC is unavailable (not yet deployed)", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "function does not exist" } });

    const { getMyFamilyGoal } = await import("@/features/dashboard");
    expect(await (getMyFamilyGoal as unknown as (d?: unknown) => Promise<unknown>)()).toBeNull();
  });
});
