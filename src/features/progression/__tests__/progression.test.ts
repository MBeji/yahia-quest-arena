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
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

// ---- Query chain helper ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.lte = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue(chain);
  chain.update = vi.fn().mockReturnValue(chain);
  Object.assign(chain, result);
  return chain;
}

const EXERCISE_ID = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
const SUBJECT_ID = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";
const ATTEMPT_ID = "cccccccc-cccc-cccc-cccc-cccccccccccc";

describe("gamification.progression — scheduleSpacedRepetition", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("skips scheduling when score is above pass threshold", async () => {
    const { scheduleSpacedRepetition } = await import("@/lib/gamification.progression");
    const result = await (scheduleSpacedRepetition as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: EXERCISE_ID,
      subjectId: SUBJECT_ID,
      attemptId: ATTEMPT_ID,
      scorePct: 80,
    });

    const res = result as { scheduled: boolean };
    expect(res.scheduled).toBe(false);
  });

  it("skips if already scheduled", async () => {
    mockFrom.mockImplementation(() => mockQuery([{ id: "existing" }]));

    const { scheduleSpacedRepetition } = await import("@/lib/gamification.progression");
    const result = await (scheduleSpacedRepetition as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: EXERCISE_ID,
      subjectId: SUBJECT_ID,
      attemptId: ATTEMPT_ID,
      scorePct: 30,
    });

    const res = result as { scheduled: boolean; reason: string };
    expect(res.scheduled).toBe(false);
    expect(res.reason).toContain("already scheduled");
  });

  it("schedules 3 repetition intervals on failure", async () => {
    mockFrom.mockImplementation(() => mockQuery([]));

    const { scheduleSpacedRepetition } = await import("@/lib/gamification.progression");
    const result = await (scheduleSpacedRepetition as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: EXERCISE_ID,
      subjectId: SUBJECT_ID,
      attemptId: ATTEMPT_ID,
      scorePct: 40,
    });

    const res = result as { scheduled: boolean; levels: number };
    expect(res.scheduled).toBe(true);
    expect(res.levels).toBe(3);
  });
});

describe("gamification.progression — getPendingSpacedRepetition", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns pending items", async () => {
    const pendingData = [
      { id: "s1", exercise_id: EXERCISE_ID, retry_level: 1, scheduled_for: "2026-06-01" },
    ];
    mockFrom.mockImplementation(() => mockQuery(pendingData));

    const { getPendingSpacedRepetition } = await import("@/lib/gamification.progression");
    const result = await (
      getPendingSpacedRepetition as unknown as (d?: unknown) => Promise<unknown>
    )();

    expect(result).toEqual(pendingData);
  });

  it("throws on DB error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "DB error" }));

    const { getPendingSpacedRepetition } = await import("@/lib/gamification.progression");

    await expect(
      (getPendingSpacedRepetition as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow("DB error");
  });
});

describe("gamification.progression — getDailyObjectives", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns existing objectives", async () => {
    const objectivesData = [
      { id: "o1", objective_type: "10_min", target_value: 10, current_value: 5, status: "active" },
    ];
    mockFrom.mockImplementation(() => mockQuery(objectivesData));

    const { getDailyObjectives } = await import("@/lib/gamification.progression");
    const result = await (getDailyObjectives as unknown as (d?: unknown) => Promise<unknown>)();

    expect(result).toEqual(objectivesData);
  });

  it("auto-creates objectives when none exist and returns them", async () => {
    let callCount = 0;
    const newObjectives = [
      { id: "o1", objective_type: "10_min", target_value: 10, current_value: 0, status: "active" },
    ];

    mockFrom.mockImplementation(() => {
      callCount++;
      // First call returns empty, subsequent calls return new objectives
      if (callCount === 1) return mockQuery([]);
      return mockQuery(newObjectives);
    });

    const { getDailyObjectives } = await import("@/lib/gamification.progression");
    const result = await (getDailyObjectives as unknown as (d?: unknown) => Promise<unknown>)();

    expect(result).toEqual(newObjectives);
  });

  it("throws on fetch error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "Fetch error" }));

    const { getDailyObjectives } = await import("@/lib/gamification.progression");

    await expect(
      (getDailyObjectives as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow("Fetch error");
  });
});

describe("gamification.progression — updateDailyObjectiveProgress", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("increments and completes an objective", async () => {
    const objective = {
      id: "o1",
      objective_type: "3_exercises",
      target_value: 3,
      current_value: 2,
      status: "active",
    };
    mockFrom.mockImplementation(() => mockQuery(objective));

    const { updateDailyObjectiveProgress } = await import("@/lib/gamification.progression");
    const result = await (
      updateDailyObjectiveProgress as unknown as (d: unknown) => Promise<unknown>
    )({
      objectiveType: "3_exercises",
      incrementValue: 1,
    });

    const res = result as { completed: boolean; progress: number; target: number };
    expect(res.completed).toBe(true);
    expect(res.progress).toBe(3);
    expect(res.target).toBe(3);
  });

  it("returns not completed when below target", async () => {
    const objective = {
      id: "o1",
      objective_type: "10_min",
      target_value: 10,
      current_value: 3,
      status: "active",
    };
    mockFrom.mockImplementation(() => mockQuery(objective));

    const { updateDailyObjectiveProgress } = await import("@/lib/gamification.progression");
    const result = await (
      updateDailyObjectiveProgress as unknown as (d: unknown) => Promise<unknown>
    )({
      objectiveType: "10_min",
      incrementValue: 2,
    });

    const res = result as { completed: boolean; progress: number };
    expect(res.completed).toBe(false);
    expect(res.progress).toBe(5);
  });

  it("returns no progress when objective not found", async () => {
    mockFrom.mockImplementation(() => mockQuery(null));

    const { updateDailyObjectiveProgress } = await import("@/lib/gamification.progression");
    const result = await (
      updateDailyObjectiveProgress as unknown as (d: unknown) => Promise<unknown>
    )({
      objectiveType: "15_min",
      incrementValue: 1,
    });

    const res = result as { completed: boolean; progress: number };
    expect(res.completed).toBe(false);
    expect(res.progress).toBe(0);
  });

  it("throws invalid increment for 3_exercises objective", async () => {
    const { updateDailyObjectiveProgress } = await import("@/lib/gamification.progression");

    await expect(
      (updateDailyObjectiveProgress as unknown as (d: unknown) => Promise<unknown>)({
        objectiveType: "3_exercises",
        incrementValue: 3,
      }),
    ).rejects.toThrow("Invalid increment");
  });

  it("throws when rate limited", async () => {
    const { isRateLimited } = await import("@/shared/lib/rate-limit");
    vi.mocked(isRateLimited).mockResolvedValueOnce(true);

    const { updateDailyObjectiveProgress } = await import("@/lib/gamification.progression");

    await expect(
      (updateDailyObjectiveProgress as unknown as (d: unknown) => Promise<unknown>)({
        objectiveType: "10_min",
        incrementValue: 1,
      }),
    ).rejects.toThrow("Too many objective updates");
  });
});

describe("gamification.progression — adaptDifficulty", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("creates new adaptation record on first attempt", async () => {
    const newAdaptation = {
      id: "a1",
      avg_score: 70,
      recent_avg_score: 70,
      total_attempts: 1,
      current_difficulty_level: 1,
    };

    let callCount = 0;
    mockFrom.mockImplementation(() => {
      callCount++;
      if (callCount === 1) return mockQuery(null); // maybeSingle - no existing
      return mockQuery(newAdaptation); // insert returns new record
    });

    const { adaptDifficulty } = await import("@/lib/gamification.progression");
    const result = await (adaptDifficulty as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: SUBJECT_ID,
      newScore: 70,
    });

    const res = result as { current_difficulty_level: number };
    expect(res.current_difficulty_level).toBe(1);
  });

  it("increases difficulty when recent average is high", async () => {
    const existing = {
      id: "a1",
      avg_score: 80,
      recent_avg_score: 80,
      total_attempts: 10,
      current_difficulty_level: 2,
    };
    const recentAttempts = Array(9).fill({ score_pct: 85 });

    let callCount = 0;
    mockFrom.mockImplementation(() => {
      callCount++;
      if (callCount === 1) return mockQuery(existing); // maybeSingle
      if (callCount === 2) return mockQuery(recentAttempts); // recent attempts
      return mockQuery(null); // update
    });

    const { adaptDifficulty } = await import("@/lib/gamification.progression");
    const result = await (adaptDifficulty as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: SUBJECT_ID,
      newScore: 90,
    });

    const res = result as { current_difficulty_level: number };
    expect(res.current_difficulty_level).toBe(3);
  });

  it("decreases difficulty when recent average is low", async () => {
    const existing = {
      id: "a1",
      avg_score: 30,
      recent_avg_score: 30,
      total_attempts: 10,
      current_difficulty_level: 3,
    };
    const recentAttempts = Array(9).fill({ score_pct: 25 });

    let callCount = 0;
    mockFrom.mockImplementation(() => {
      callCount++;
      if (callCount === 1) return mockQuery(existing);
      if (callCount === 2) return mockQuery(recentAttempts);
      return mockQuery(null);
    });

    const { adaptDifficulty } = await import("@/lib/gamification.progression");
    const result = await (adaptDifficulty as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: SUBJECT_ID,
      newScore: 20,
    });

    const res = result as { current_difficulty_level: number };
    expect(res.current_difficulty_level).toBe(2);
  });

  it("does not exceed max difficulty", async () => {
    const existing = {
      id: "a1",
      avg_score: 90,
      recent_avg_score: 90,
      total_attempts: 20,
      current_difficulty_level: 4,
    };
    const recentAttempts = Array(9).fill({ score_pct: 95 });

    let callCount = 0;
    mockFrom.mockImplementation(() => {
      callCount++;
      if (callCount === 1) return mockQuery(existing);
      if (callCount === 2) return mockQuery(recentAttempts);
      return mockQuery(null);
    });

    const { adaptDifficulty } = await import("@/lib/gamification.progression");
    const result = await (adaptDifficulty as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: SUBJECT_ID,
      newScore: 95,
    });

    const res = result as { current_difficulty_level: number };
    expect(res.current_difficulty_level).toBe(4);
  });

  it("does not go below min difficulty", async () => {
    const existing = {
      id: "a1",
      avg_score: 20,
      recent_avg_score: 20,
      total_attempts: 5,
      current_difficulty_level: 1,
    };
    const recentAttempts = Array(4).fill({ score_pct: 15 });

    let callCount = 0;
    mockFrom.mockImplementation(() => {
      callCount++;
      if (callCount === 1) return mockQuery(existing);
      if (callCount === 2) return mockQuery(recentAttempts);
      return mockQuery(null);
    });

    const { adaptDifficulty } = await import("@/lib/gamification.progression");
    const result = await (adaptDifficulty as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: SUBJECT_ID,
      newScore: 10,
    });

    const res = result as { current_difficulty_level: number };
    expect(res.current_difficulty_level).toBe(1);
  });
});

describe("gamification.progression — input validation", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
  });

  it("rejects invalid objectiveType", async () => {
    const { updateDailyObjectiveProgress } = await import("@/lib/gamification.progression");

    await expect(
      (updateDailyObjectiveProgress as unknown as (d: unknown) => Promise<unknown>)({
        objectiveType: "invalid_type",
        incrementValue: 1,
      }),
    ).rejects.toThrow();
  });

  it("rejects incrementValue > 5", async () => {
    const { updateDailyObjectiveProgress } = await import("@/lib/gamification.progression");

    await expect(
      (updateDailyObjectiveProgress as unknown as (d: unknown) => Promise<unknown>)({
        objectiveType: "10_min",
        incrementValue: 10,
      }),
    ).rejects.toThrow();
  });

  it("rejects non-uuid subjectId for adaptDifficulty", async () => {
    const { adaptDifficulty } = await import("@/lib/gamification.progression");

    await expect(
      (adaptDifficulty as unknown as (d: unknown) => Promise<unknown>)({
        subjectId: "not-uuid",
        newScore: 50,
      }),
    ).rejects.toThrow();
  });

  it("rejects score > 100 for adaptDifficulty", async () => {
    const { adaptDifficulty } = await import("@/lib/gamification.progression");

    await expect(
      (adaptDifficulty as unknown as (d: unknown) => Promise<unknown>)({
        subjectId: SUBJECT_ID,
        newScore: 150,
      }),
    ).rejects.toThrow();
  });
});

// =============================================================================
// getWeeklyQuests
// =============================================================================
describe("gamification.progression — getWeeklyQuests", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns existing weekly quests", async () => {
    const quests = [
      { id: "wq1", quest_type: "maintain_streak_5", target_value: 5, current_value: 2, status: "active" },
    ];
    mockFrom.mockImplementation(() => mockQuery(quests));

    const { getWeeklyQuests } = await import("@/lib/gamification.progression");
    const result = await (getWeeklyQuests as unknown as () => Promise<unknown>)();
    expect(result).toEqual(quests);
  });

  it("auto-creates quests when none exist for this week", async () => {
    let callIndex = 0;
    mockFrom.mockImplementation(() => {
      callIndex++;
      if (callIndex === 1) return mockQuery([]); // First fetch: empty
      // Insert calls return OK
      if (callIndex >= 2 && callIndex <= 5) return mockQuery(null);
      // Re-fetch returns created quests
      return mockQuery([{ id: "wq1", quest_type: "maintain_streak_5", status: "active" }]);
    });

    const { getWeeklyQuests } = await import("@/lib/gamification.progression");
    const result = await (getWeeklyQuests as unknown as () => Promise<unknown>)();
    expect(Array.isArray(result)).toBe(true);
  });

  it("throws on fetch error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "DB error" }));

    const { getWeeklyQuests } = await import("@/lib/gamification.progression");
    await expect(
      (getWeeklyQuests as unknown as () => Promise<unknown>)(),
    ).rejects.toThrow("DB error");
  });
});

// =============================================================================
// updateWeeklyQuestProgress
// =============================================================================
describe("gamification.progression — updateWeeklyQuestProgress", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("increments and completes a weekly quest", async () => {
    mockFrom.mockImplementation(() => {
      const chain = mockQuery({ id: "wq1", quest_type: "maintain_streak_5", target_value: 5, current_value: 4, status: "active" });
      chain.update = vi.fn().mockReturnValue(mockQuery(null));
      return chain;
    });

    const { updateWeeklyQuestProgress } = await import("@/lib/gamification.progression");
    const result = await (updateWeeklyQuestProgress as unknown as (d: unknown) => Promise<unknown>)({
      questType: "maintain_streak_5",
      incrementValue: 1,
    });

    const r = result as Record<string, unknown>;
    expect(r.completed).toBe(true);
    expect(r.progress).toBe(5);
    expect(r.target).toBe(5);
  });

  it("returns not completed when below target", async () => {
    mockFrom.mockImplementation(() => {
      const chain = mockQuery({ id: "wq1", quest_type: "beat_2_bosses", target_value: 2, current_value: 0, status: "active" });
      chain.update = vi.fn().mockReturnValue(mockQuery(null));
      return chain;
    });

    const { updateWeeklyQuestProgress } = await import("@/lib/gamification.progression");
    const result = await (updateWeeklyQuestProgress as unknown as (d: unknown) => Promise<unknown>)({
      questType: "beat_2_bosses",
      incrementValue: 1,
    });

    const r = result as Record<string, unknown>;
    expect(r.completed).toBe(false);
    expect(r.progress).toBe(1);
  });

  it("returns no progress when quest not found", async () => {
    mockFrom.mockImplementation(() => {
      const chain = mockQuery(null);
      chain.maybeSingle = vi.fn().mockReturnValue({ data: null, error: null });
      Object.assign(chain, { data: null, error: null });
      return chain;
    });

    const { updateWeeklyQuestProgress } = await import("@/lib/gamification.progression");
    const result = await (updateWeeklyQuestProgress as unknown as (d: unknown) => Promise<unknown>)({
      questType: "maintain_streak_5",
      incrementValue: 1,
    });

    const r = result as Record<string, unknown>;
    expect(r.completed).toBe(false);
    expect(r.progress).toBe(0);
  });

  it("rejects invalid questType", async () => {
    const { updateWeeklyQuestProgress } = await import("@/lib/gamification.progression");
    await expect(
      (updateWeeklyQuestProgress as unknown as (d: unknown) => Promise<unknown>)({
        questType: "invalid_type",
        incrementValue: 1,
      }),
    ).rejects.toThrow();
  });
});

// =============================================================================
// recoverStreak
// =============================================================================
describe("gamification.progression — recoverStreak", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("recovers streak for 15 coins", async () => {
    mockFrom.mockImplementation(() => {
      const chain = mockQuery({ id: "user-123", yahia_coins: 50, current_streak: 0, longest_streak: 7, last_active_date: "2026-05-30" });
      chain.update = vi.fn().mockReturnValue(mockQuery(null));
      return chain;
    });
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { recoverStreak } = await import("@/lib/gamification.progression");
    const result = await (recoverStreak as unknown as () => Promise<unknown>)();

    const r = result as Record<string, unknown>;
    expect(r.success).toBe(true);
    expect(r.newStreak).toBe(1);
    expect(r.coinsSpent).toBe(15);
    expect(r.remainingCoins).toBe(35);
  });

  it("rejects when streak is already active", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({ id: "user-123", yahia_coins: 50, current_streak: 3, longest_streak: 7, last_active_date: "2026-06-01" }),
    );

    const { recoverStreak } = await import("@/lib/gamification.progression");
    await expect(
      (recoverStreak as unknown as () => Promise<unknown>)(),
    ).rejects.toThrow("streak est actif");
  });

  it("rejects when no previous streak exists", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({ id: "user-123", yahia_coins: 50, current_streak: 0, longest_streak: 0, last_active_date: null }),
    );

    const { recoverStreak } = await import("@/lib/gamification.progression");
    await expect(
      (recoverStreak as unknown as () => Promise<unknown>)(),
    ).rejects.toThrow("pas encore eu de streak");
  });

  it("rejects when insufficient coins", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({ id: "user-123", yahia_coins: 5, current_streak: 0, longest_streak: 7, last_active_date: "2026-05-30" }),
    );

    const { recoverStreak } = await import("@/lib/gamification.progression");
    await expect(
      (recoverStreak as unknown as () => Promise<unknown>)(),
    ).rejects.toThrow("15 XP Coins");
  });

  it("throws on spend_coins RPC error", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({ id: "user-123", yahia_coins: 50, current_streak: 0, longest_streak: 7, last_active_date: "2026-05-30" }),
    );
    mockRpc.mockResolvedValue({ data: null, error: { message: "Insufficient funds" } });

    const { recoverStreak } = await import("@/lib/gamification.progression");
    await expect(
      (recoverStreak as unknown as () => Promise<unknown>)(),
    ).rejects.toThrow("Insufficient funds");
  });
});
