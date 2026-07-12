/**
 * NON-REGRESSION TEST SUITE
 * ==========================
 * Detects breaking changes on core server functions:
 * - Functions must resolve (not hang/timeout)
 * - Functions must return expected data shapes
 * - Functions must handle DB errors gracefully (not crash)
 * - Functions must handle RPC unavailability gracefully
 *
 * These tests specifically guard against the "infinite loading" class of regressions
 * where a server function throws unexpectedly or never resolves.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Shared mocks ----
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

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

// ---- Chainable query mock helper ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.gt = vi.fn().mockReturnValue(chain);
  chain.gte = vi.fn().mockReturnValue(chain);
  chain.lte = vi.fn().mockReturnValue(chain);
  chain.neq = vi.fn().mockReturnValue(chain);
  chain.in = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue(chain);
  chain.update = vi.fn().mockReturnValue(chain);
  chain.upsert = vi.fn().mockReturnValue(chain);
  chain.delete = vi.fn().mockReturnValue(chain);
  // Make it thenable for Promise.all
  chain.then = (resolve: (v: unknown) => unknown) => resolve(result);
  Object.assign(chain, result);
  return chain;
}

/** Timeout helper: rejects if a fn doesn't resolve within ms */
function withTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
  return Promise.race([
    promise,
    new Promise<never>((_, reject) =>
      setTimeout(
        () => reject(new Error(`REGRESSION: Server function did not resolve within ${ms}ms`)),
        ms,
      ),
    ),
  ]);
}

// =============================================================================
// QUEST MODULE — Non-Regression
// =============================================================================
describe("NON-REGRESSION: Quest Server Functions", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
    mockRpc.mockReturnValue({ data: [], error: null });
  });

  describe("getSubject — must never hang", () => {
    it("resolves within 1s with valid data", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "subjects")
          return mockQuery({ id: "s1", name_fr: "Math", color_token: "math", icon: "🧮" });
        if (table === "chapters") return mockQuery([{ id: "ch1", title: "Ch1", display_order: 1 }]);
        if (table === "exercises")
          return mockQuery([{ id: "ex1", title: "Ex1", display_order: 1 }]);
        return mockQuery([]);
      });
      mockRpc.mockResolvedValue({ data: [{ exercise_id: "ex1", best_score: 90 }], error: null });

      const { getSubject } = await import("@/features/quest");
      const result = await withTimeout(
        (getSubject as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "s1" }),
        1000,
      );

      expect(result).toHaveProperty("subject");
      expect(result).toHaveProperty("chapters");
      expect(result).toHaveProperty("exercises");
      expect(result).toHaveProperty("bestByExercise");
    });

    it("resolves gracefully when RPC function does not exist", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "subjects") return mockQuery({ id: "s1", name_fr: "Test" });
        if (table === "chapters") return mockQuery([]);
        if (table === "exercises") return mockQuery([]);
        return mockQuery([]);
      });
      // Simulate RPC not existing (rejected promise)
      mockRpc.mockRejectedValue(new Error("function get_best_scores_by_exercise does not exist"));

      const { getSubject } = await import("@/features/quest");
      const result = await withTimeout(
        (getSubject as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "s1" }),
        1000,
      );

      // Must NOT throw — must return with empty scores
      const r = result as Record<string, unknown>;
      expect(r.subject).toEqual({ id: "s1", name_fr: "Test" });
      expect(r.bestByExercise).toEqual({});
    });

    it("resolves gracefully when RPC returns error", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "subjects") return mockQuery({ id: "s1", name_fr: "Test" });
        if (table === "chapters") return mockQuery([]);
        if (table === "exercises") return mockQuery([]);
        return mockQuery([]);
      });
      mockRpc.mockResolvedValue({ data: null, error: { message: "permission denied" } });

      const { getSubject } = await import("@/features/quest");
      const result = await withTimeout(
        (getSubject as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "s1" }),
        1000,
      );

      const r = result as Record<string, unknown>;
      expect(r.bestByExercise).toEqual({});
    });

    it("throws clearly on subject table error (not hang)", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "subjects") return mockQuery(null, { message: "relation does not exist" });
        return mockQuery([]);
      });
      mockRpc.mockResolvedValue({ data: [], error: null });

      const { getSubject } = await import("@/features/quest");

      await expect(
        withTimeout(
          (getSubject as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "s1" }),
          1000,
        ),
      ).rejects.toThrow("Impossible de charger la matière.");
    });
  });

  describe("getExercise — must never hang", () => {
    it("resolves within 1s with valid data", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "exercises") return mockQuery({ id: "ex1", title: "Ex" });
        if (table === "questions")
          return mockQuery([{ id: "q1", prompt: "2+2?", options: ["3", "4"], display_order: 1 }]);
        return mockQuery([]);
      });

      const { getExercise } = await import("@/features/quest");
      const result = await withTimeout(
        (getExercise as unknown as (d: unknown) => Promise<unknown>)({
          exerciseId: "11111111-1111-1111-1111-111111111111",
        }),
        1000,
      );

      const r = result as Record<string, unknown>;
      expect(r).toHaveProperty("exercise");
      expect(r).toHaveProperty("questions");
    });

    it("throws on exercise not found (not hang)", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "exercises") return mockQuery(null, { message: "Row not found" });
        return mockQuery([]);
      });

      const { getExercise } = await import("@/features/quest");

      await expect(
        withTimeout(
          (getExercise as unknown as (d: unknown) => Promise<unknown>)({
            exerciseId: "11111111-1111-1111-1111-111111111111",
          }),
          1000,
        ),
      ).rejects.toThrow("Impossible de charger l'exercice.");
    });
  });

  describe("submitAttempt — must never hang", () => {
    const QUESTION_UUID = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";

    it("resolves within 1s with valid submission", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "questions")
          return mockQuery([
            { id: QUESTION_UUID, prompt: "2+2?", correct_option: "4", explanation: "Basic math" },
          ]);
        return mockQuery([]);
      });
      mockRpc.mockResolvedValue({
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

      const { submitAttempt } = await import("@/features/quest");
      const result = await withTimeout(
        (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
          sessionId: "11111111-1111-1111-1111-111111111111",
          exerciseId: "22222222-2222-2222-2222-222222222222",
          answers: [{ questionId: QUESTION_UUID, choice: "4" }],
        }),
        1000,
      );

      const r = result as Record<string, unknown>;
      expect(r).toHaveProperty("correct");
      expect(r).toHaveProperty("xpEarned");
      expect(r).toHaveProperty("review");
    });

    it("throws on RPC error (not hang)", async () => {
      mockFrom.mockImplementation((table: string) => {
        if (table === "questions") return mockQuery([{ id: QUESTION_UUID, correct_option: "4" }]);
        return mockQuery([]);
      });
      mockRpc.mockResolvedValue({
        data: null,
        error: { message: "submit_exercise_attempt failed" },
      });

      const { submitAttempt } = await import("@/features/quest");

      await expect(
        withTimeout(
          (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
            sessionId: "11111111-1111-1111-1111-111111111111",
            exerciseId: "22222222-2222-2222-2222-222222222222",
            answers: [{ questionId: QUESTION_UUID, choice: "4" }],
          }),
          1000,
        ),
      ).rejects.toThrow("Impossible d'enregistrer votre tentative.");
    });
  });
});

// =============================================================================
// DASHBOARD MODULE — Non-Regression
// =============================================================================
describe("NON-REGRESSION: Dashboard Server Functions", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
    mockRpc.mockReturnValue({ data: [], error: null });
  });

  describe("getDashboard — must never hang", () => {
    it("resolves within 1s with existing profile", async () => {
      const profile = {
        id: "user-regression-test",
        display_name: "Yahia",
        xp: 100,
        level: 1,
        current_streak: 3,
        yahia_coins: 50,
      };
      mockFrom.mockImplementation((table: string) => {
        if (table === "profiles") return mockQuery(profile);
        if (table === "subjects") return mockQuery([{ id: "s1", name_fr: "Math" }]);
        if (table === "attempts") return mockQuery([]);
        if (table === "student_badges") return mockQuery([]);
        if (table === "inventory_items") return mockQuery([]);
        if (table === "shop_items") return mockQuery([]);
        return mockQuery([]);
      });

      const { getDashboard } = await import("@/features/dashboard");
      const result = await withTimeout((getDashboard as unknown as () => Promise<unknown>)(), 1000);

      const r = result as Record<string, unknown>;
      expect(r).toHaveProperty("profile");
      expect(r).toHaveProperty("subjects");
    });

    it("resolves when profile does not exist (creates one)", async () => {
      const profileCreated = false;
      mockFrom.mockImplementation((table: string) => {
        if (table === "profiles") {
          if (!profileCreated) {
            // First call: maybeSingle returns null (no profile)
            const chain = mockQuery(null);
            chain.maybeSingle = vi.fn().mockReturnValue({ data: null, error: null });
            Object.assign(chain, { data: null, error: null });
            return chain;
          }
          return mockQuery({ id: "user-regression-test", display_name: "Yahia", xp: 0, level: 1 });
        }
        if (table === "subjects") return mockQuery([]);
        if (table === "attempts") return mockQuery([]);
        if (table === "student_badges") return mockQuery([]);
        if (table === "inventory_items") return mockQuery([]);
        if (table === "shop_items") return mockQuery([]);
        return mockQuery([]);
      });

      const { getDashboard } = await import("@/features/dashboard");
      const result = await withTimeout((getDashboard as unknown as () => Promise<unknown>)(), 1000);

      // Must resolve, not hang or throw
      expect(result).toBeDefined();
    });

    it("throws on DB connection error (not hang)", async () => {
      mockFrom.mockImplementation(() => {
        return mockQuery(null, { message: "connection refused" });
      });

      const { getDashboard } = await import("@/features/dashboard");

      await expect(
        withTimeout((getDashboard as unknown as () => Promise<unknown>)(), 1000),
      ).rejects.toThrow();
    });
  });

  describe("getLeaderboard — must never hang", () => {
    it("resolves within 1s with valid data", async () => {
      // Global board now reads through the RLS-safe `get_global_leaderboard` RPC.
      mockRpc.mockResolvedValue({
        data: [
          {
            rank: 1,
            display_name: "Player1",
            hero_class: "mage",
            level: 3,
            xp: 500,
            current_streak: 2,
            avatar_tier: 0,
            is_me: false,
          },
        ],
        error: null,
      });

      const { getLeaderboard } = await import("@/features/dashboard");
      const result = await withTimeout(
        (getLeaderboard as unknown as () => Promise<unknown>)(),
        1000,
      );

      expect(result).toHaveProperty("leaderboard");
    });
  });
});

// =============================================================================
// DUNGEON MODULE — Non-Regression
// =============================================================================
describe("NON-REGRESSION: Dungeon Server Functions", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
    mockRpc.mockReturnValue({ data: [], error: null });
  });

  describe("startDungeonRun — must never hang", () => {
    it("resolves within 1s with valid RPC response", async () => {
      mockRpc.mockResolvedValue({
        data: "11111111-1111-1111-1111-111111111111",
        error: null,
      });

      const { startDungeonRun } = await import("@/features/dungeon");
      const result = await withTimeout(
        (startDungeonRun as unknown as () => Promise<unknown>)(),
        1000,
      );

      expect(result).toHaveProperty("runId");
    });

    it("throws on RPC error (not hang)", async () => {
      mockRpc.mockResolvedValue({ data: null, error: { message: "dungeon unavailable" } });

      const { startDungeonRun } = await import("@/features/dungeon");

      await expect(
        withTimeout((startDungeonRun as unknown as () => Promise<unknown>)(), 1000),
      ).rejects.toThrow();
    });
  });

  describe("getDungeonQuestions — must never hang", () => {
    it("resolves within 1s with valid RPC response", async () => {
      mockRpc.mockResolvedValue({
        data: {
          currentFloor: 1,
          questions: [{ id: "q1", prompt: "2+2?", options: ["3", "4"], explanation: null }],
        },
        error: null,
      });

      const { getDungeonQuestions } = await import("@/features/dungeon");
      const result = await withTimeout(
        (getDungeonQuestions as unknown as (d: unknown) => Promise<unknown>)({
          runId: "11111111-1111-1111-1111-111111111111",
        }),
        1000,
      );

      expect(result).toHaveProperty("questions");
    });
  });
});

// =============================================================================
// CROSS-CUTTING: Promise.all / RPC resolution patterns
// =============================================================================
describe("NON-REGRESSION: Promise resolution patterns", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
    mockRpc.mockReturnValue({ data: [], error: null });
  });

  it("server functions using Promise.all never hang when one query rejects", async () => {
    // Simulate a query that rejects (broken promise chain)
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") {
        const chain = mockQuery(null, { message: "timeout" });
        // Override then to simulate rejection
        chain.then = (_: unknown, reject?: (e: unknown) => unknown) =>
          reject ? reject(new Error("timeout")) : Promise.reject(new Error("timeout"));
        return chain;
      }
      return mockQuery([]);
    });
    mockRpc.mockResolvedValue({ data: [], error: null });

    const { getSubject } = await import("@/features/quest");

    // Must reject (not hang forever)
    await expect(
      withTimeout(
        (getSubject as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "s1" }),
        1000,
      ),
    ).rejects.toThrow();
  });

  it("mockRpc must be thenable (catches the .then is not a function regression)", async () => {
    // This test specifically catches the bug where mockReturnValue returns
    // a non-thenable value, but the code does `await supabase.rpc(...)`
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") return mockQuery({ id: "s1", name_fr: "T" });
      return mockQuery([]);
    });

    // Simulate the CORRECT mock pattern (mockResolvedValue, not mockReturnValue)
    mockRpc.mockResolvedValue({ data: [], error: null });

    const { getSubject } = await import("@/features/quest");
    const result = await withTimeout(
      (getSubject as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "s1" }),
      1000,
    );

    expect(result).toBeDefined();
  });
});

// =============================================================================
// DATA SHAPE CONTRACTS — ensure returned objects have required fields
// =============================================================================
describe("NON-REGRESSION: Data shape contracts", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
    mockRpc.mockReturnValue({ data: [], error: null });
  });

  it("getSubject returns { subject, chapters, exercises, bestByExercise, quizPassedByChapter }", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects")
        return mockQuery({ id: "s1", name_fr: "Math", color_token: "math", icon: "📐" });
      if (table === "chapters") return mockQuery([]);
      if (table === "exercises") return mockQuery([]);
      return mockQuery([]);
    });
    mockRpc.mockResolvedValue({ data: [], error: null });

    const { getSubject } = await import("@/features/quest");
    const result = (await (getSubject as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "s1",
    })) as Record<string, unknown>;

    // These keys are consumed by the SubjectPage component (`parcours` is the
    // hub's level anchor — étude 15 lot 7).
    expect(Object.keys(result).sort()).toEqual([
      "bestByExercise",
      "chapters",
      "exercises",
      "parcours",
      "quizPassedByChapter",
      "subject",
      "viewer",
    ]);
    expect(result.chapters).toBeInstanceOf(Array);
    expect(result.exercises).toBeInstanceOf(Array);
    expect(typeof result.bestByExercise).toBe("object");
  });

  it("getExercise returns { exercise, questions, hintCharges, chapterQuizId, quizGated }", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ id: "ex1", title: "E" });
      if (table === "questions") return mockQuery([]);
      return mockQuery([]);
    });

    const { getExercise } = await import("@/features/quest");
    const result = (await (getExercise as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    })) as Record<string, unknown>;

    expect(Object.keys(result).sort()).toEqual([
      "chapterQuizId",
      "exercise",
      "hintCharges",
      "questions",
      "quizGated",
    ]);
    expect(result.questions).toBeInstanceOf(Array);
    expect(result.hintCharges).toBe(0);
  });

  it("submitAttempt returns { correct, total, scorePct, xpEarned, coinsEarned, review, ... }", async () => {
    const QUESTION_UUID = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
    mockFrom.mockImplementation((table: string) => {
      if (table === "questions")
        return mockQuery([
          { id: QUESTION_UUID, prompt: "?", correct_option: "A", explanation: null },
        ]);
      return mockQuery([]);
    });
    mockRpc.mockResolvedValue({
      data: {
        correct: 1,
        total: 1,
        scorePct: 100,
        xpEarned: 10,
        coinsEarned: 2,
        durationSeconds: 15,
        profile: null,
        unlockedBadges: [],
      },
      error: null,
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: "11111111-1111-1111-1111-111111111111",
      exerciseId: "22222222-2222-2222-2222-222222222222",
      answers: [{ questionId: QUESTION_UUID, choice: "A" }],
    })) as Record<string, unknown>;

    const requiredKeys = ["correct", "total", "scorePct", "xpEarned", "coinsEarned", "review"];
    for (const key of requiredKeys) {
      expect(result).toHaveProperty(key);
    }
    expect(result.review).toBeInstanceOf(Array);
  });
});
