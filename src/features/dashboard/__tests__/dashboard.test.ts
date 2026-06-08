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

  it("aggregates per-subject stats from the full attempt set, not the recent window (#18)", async () => {
    const profile = { id: "user-123", display_name: "Yahia" };
    // Recent (limited) query returns 1 row; the full stats query returns 3 rows.
    // Correct aggregates must reflect the full set.
    const recent = [
      {
        subject_id: "s1",
        score_pct: 90,
        xp_earned: 50,
        completed_at: "2026-06-03",
        exercise_id: "e3",
      },
    ];
    const full = [
      { subject_id: "s1", score_pct: 90, xp_earned: 50 },
      { subject_id: "s1", score_pct: 60, xp_earned: 30 },
      { subject_id: "s1", score_pct: 30, xp_earned: 10 },
    ];

    let attemptsCall = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([]);
      if (table === "attempts") {
        attemptsCall += 1;
        // Call order in getDashboard's Promise.all: recent first, then full stats.
        return attemptsCall === 1 ? mockQuery(recent) : mockQuery(full);
      }
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const result = await (getDashboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as { stats: Record<string, { count: number; avg: number; xp: number }> };
    expect(res.stats.s1.count).toBe(3);
    expect(res.stats.s1.avg).toBe(60); // (90+60+30)/3
    expect(res.stats.s1.xp).toBe(90);
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

    const res = result as {
      leaderboard: Record<string, unknown>[];
      myRank: Record<string, unknown> | undefined;
    };
    expect(res.leaderboard).toHaveLength(2);
    expect(res.myRank).toBeDefined();

    // SECURITY (P0 S2b): the global leaderboard must not surface any peer UUIDs.
    // `isMe` is computed server-side; rows are keyed by `rank` on the client.
    expect(res.leaderboard[0]).toMatchObject({ rank: 1, isMe: true });
    expect(res.leaderboard[1]).toMatchObject({ rank: 2, isMe: false });
    for (const row of res.leaderboard) {
      expect(row).not.toHaveProperty("id");
    }
  });

  it("throws a generic French message on fetch error (#14)", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "Leaderboard error" }));

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

describe("gamification.dashboard — getSubjects", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns the ordered subjects list", async () => {
    const subjects = [
      { id: "math", name_fr: "Mathématiques", color_token: "subject-math" },
      { id: "french", name_fr: "Français", color_token: "subject-french" },
    ];
    mockFrom.mockImplementation(() => mockQuery(subjects));

    const { getSubjects } = await import("@/features/dashboard");
    const result = (await (getSubjects as unknown as (d?: unknown) => Promise<unknown>)()) as {
      subjects: unknown[];
    };

    expect(result.subjects).toEqual(subjects);
  });

  it("getSubjects scopes by theme and grade when both are provided", async () => {
    const subjects = [{ id: "math-bac", name_fr: "Mathématiques", theme_id: "ecole-tn" }];
    const chain = mockQuery(subjects);
    mockFrom.mockImplementation(() => chain);

    const { getSubjects } = await import("@/features/dashboard");
    const result = (await (getSubjects as unknown as (d: unknown) => Promise<unknown>)({
      themeId: "ecole-tn",
      gradeId: "11111111-1111-1111-1111-111111111111",
    })) as { subjects: unknown[] };

    expect(result.subjects).toEqual(subjects);
    expect(chain.eq).toHaveBeenCalledWith("theme_id", "ecole-tn");
    expect(chain.eq).toHaveBeenCalledWith("grade_id", "11111111-1111-1111-1111-111111111111");
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

  it("getLeaderboard computes my rank via count when I'm not in the top list", async () => {
    let n = 0;
    mockFrom.mockImplementation(() => {
      n += 1;
      if (n === 1)
        return mockQuery([
          {
            id: "other",
            display_name: "Other",
            hero_class: "mage",
            level: 9,
            xp: 9999,
            current_streak: 0,
            avatar_tier: 1,
          },
        ]);
      if (n === 2)
        return mockQuery({
          id: "user-123",
          xp: 500,
          display_name: "Me",
          hero_class: "novice",
          level: 2,
          current_streak: 1,
          avatar_tier: 1,
        });
      return mockQuery(null); // count query → count undefined → `count ?? 0`
    });

    const { getLeaderboard } = await import("@/features/dashboard");
    const res = (await (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)()) as {
      myRank: { isMe: boolean; rank: number } | undefined;
    };
    expect(res.myRank?.isMe).toBe(true);
    expect(res.myRank?.rank).toBe(1);
  });

  it("getLeaderboard throws when the 'me' query errors", async () => {
    let n = 0;
    mockFrom.mockImplementation(() => {
      n += 1;
      if (n === 1) return mockQuery([]);
      return mockQuery(null, { message: "me error" });
    });
    const { getLeaderboard } = await import("@/features/dashboard");
    await expect(
      (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
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

  it("getSubjects throws a generic message on error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "subjects error" }));
    const { getSubjects } = await import("@/features/dashboard");
    await expect((getSubjects as unknown as (d?: unknown) => Promise<unknown>)()).rejects.toThrow(
      /tableau de bord/i,
    );
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
