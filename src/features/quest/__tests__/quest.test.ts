import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
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
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
        // Store by method to allow differentiation
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

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

// ---- Helpers ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue(chain);
  chain.in = vi.fn().mockReturnValue(chain);
  chain.gte = vi.fn().mockReturnValue(chain);
  // Make the chain itself resolve like a promise with data/error
  chain.then = (fn: (v: unknown) => unknown) => fn(result);
  Object.assign(chain, result);
  return chain;
}

describe("gamification.quest — getSubject", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns subject, chapters, exercises, and best scores", async () => {
    const subjectData = { id: "subj-1", name_fr: "Math" };
    const chaptersData = [{ id: "ch-1", title: "Chapter 1" }];
    const exercisesData = [{ id: "ex-1", title: "Exercise 1" }];
    const bestScoresData = [{ exercise_id: "ex-1", best_score: 85 }];

    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") return mockQuery(subjectData);
      if (table === "chapters") return mockQuery(chaptersData);
      if (table === "exercises") return mockQuery(exercisesData);
      return mockQuery([]);
    });
    mockRpc.mockReturnValue({ data: bestScoresData, error: null });

    const { getSubject } = await import("@/features/quest");
    const result = await (getSubject as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "subj-1",
    });

    expect(result).toEqual({
      subject: subjectData,
      chapters: chaptersData,
      exercises: exercisesData,
      bestByExercise: { "ex-1": 85 },
      quizPassedByChapter: {},
      viewer: { level: 0, isPremium: false, hasEntitlement: true },
    });
  });

  it("throws on subject fetch error", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") return mockQuery(null, { message: "Not found" });
      return mockQuery([]);
    });
    mockRpc.mockReturnValue({ data: [], error: null });

    const { getSubject } = await import("@/features/quest");

    await expect(
      (getSubject as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "bad-id" }),
    ).rejects.toThrow("Impossible de charger la matière.");
  });

  it("returns empty bestByExercise on bestScores RPC error", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") return mockQuery({ id: "s1" });
      if (table === "chapters") return mockQuery([]);
      if (table === "exercises") return mockQuery([]);
      return mockQuery([]);
    });
    mockRpc.mockReturnValue({ data: null, error: { message: "RPC fail" } });

    const { getSubject } = await import("@/features/quest");

    const result = await (getSubject as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "s1",
    });
    expect((result as Record<string, unknown>).bestByExercise).toEqual({});
  });
});

describe("gamification.quest — getExercise", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns exercise and questions", async () => {
    const exerciseData = { id: "ex-1", title: "Ex 1" };
    const questionsData = [{ id: "q-1", prompt: "2+2?", options: ["3", "4"], display_order: 1 }];

    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery(exerciseData);
      if (table === "questions") return mockQuery(questionsData);
      return mockQuery([]);
    });

    const { getExercise } = await import("@/features/quest");
    const result = await (getExercise as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    });

    expect(result).toEqual({
      exercise: exerciseData,
      questions: questionsData,
      hintCharges: 0,
    });
  });

  it("sums reveal charges from owned hint consumables", async () => {
    const exerciseData = { id: "ex-1", title: "Ex 1" };
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery(exerciseData);
      if (table === "questions") return mockQuery([]);
      if (table === "inventory_items")
        return mockQuery([
          { quantity: 3, item: { item_type: "booster", effect_payload: { hints: 3 } } },
          { quantity: 1, item: { item_type: "potion", effect_payload: { hintBoost: 1 } } },
          // A non-hint potion must NOT count toward reveal charges.
          { quantity: 5, item: { item_type: "potion", effect_payload: { xpMultiplier: 2 } } },
        ]);
      return mockQuery([]);
    });

    const { getExercise } = await import("@/features/quest");
    const result = (await (getExercise as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    })) as { hintCharges: number };

    // 3 (booster_hint) + 1 (potion_rappel) = 4; the xp potion is excluded.
    expect(result.hintCharges).toBe(4);
  });

  it("throws on exercise fetch error", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery(null, { message: "DB error" });
      return mockQuery([]);
    });

    const { getExercise } = await import("@/features/quest");

    await expect(
      (getExercise as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow("Impossible de charger l'exercice.");
  });
});

describe("gamification.quest — startExerciseSession", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns session id and started_at", async () => {
    const sessionData = { id: "sess-1", started_at: "2026-06-01T12:00:00Z" };
    mockFrom.mockImplementation(() => mockQuery(sessionData));
    mockRpc.mockReturnValue({ data: [{ allowed: true }], error: null });

    const { startExerciseSession } = await import("@/features/quest");
    const result = await (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    });

    expect(result).toEqual({ sessionId: "sess-1", startedAt: "2026-06-01T12:00:00Z" });
  });

  it("throws on insert error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "Insert failed" }));
    mockRpc.mockReturnValue({ data: [{ allowed: true }], error: null });

    const { startExerciseSession } = await import("@/features/quest");

    await expect(
      (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow("Impossible de démarrer la session.");
  });

  it("blocks a practice exercise until the chapter comprehension quiz is passed", async () => {
    let exerciseCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") {
        exerciseCalls += 1;
        // 1st call = the requested exercise; 2nd call = the chapter's quiz.
        return exerciseCalls === 1
          ? mockQuery({
              id: "ex-1",
              mode: "practice",
              chapter_id: "ch-1",
              subjects: { grade_id: "g-1" },
            })
          : mockQuery({ id: "quiz-1" });
      }
      if (table === "attempts") return mockQuery([]); // no passing attempt
      return mockQuery({ id: "sess-1", started_at: "t" });
    });
    mockRpc.mockReturnValue({ data: [{ allowed: true }], error: null });

    const { startExerciseSession } = await import("@/features/quest");

    await expect(
      (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow("quiz de compréhension");
  });

  it("allows a practice exercise once the chapter quiz is passed", async () => {
    let exerciseCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") {
        exerciseCalls += 1;
        return exerciseCalls === 1
          ? mockQuery({
              id: "ex-1",
              mode: "practice",
              chapter_id: "ch-1",
              subjects: { grade_id: "g-1" },
            })
          : mockQuery({ id: "quiz-1" });
      }
      // Passing attempt done with effort (>= 4s/question): genuinely unlocks.
      if (table === "attempts")
        return mockQuery([{ id: "att-1", duration_seconds: 40, total_count: 6 }]);
      return mockQuery({ id: "sess-1", started_at: "2026-06-01T12:00:00Z" });
    });
    mockRpc.mockReturnValue({ data: [{ allowed: true }], error: null });

    const { startExerciseSession } = await import("@/features/quest");
    const result = await (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    });

    expect(result).toEqual({ sessionId: "sess-1", startedAt: "2026-06-01T12:00:00Z" });
  });

  it("does NOT quiz-gate a non-school subject's exercise (grade_id null)", async () => {
    // Non-school themes (culture-générale, muscle-cerveau/IQ, language tracks) have
    // no theory to validate: a practice exercise starts even with no quiz attempt.
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises")
        return mockQuery({
          id: "ex-1",
          mode: "practice",
          chapter_id: "ch-1",
          subjects: { grade_id: null },
        });
      if (table === "attempts") return mockQuery([]); // no passing quiz attempt
      return mockQuery({ id: "sess-1", started_at: "t" });
    });
    mockRpc.mockReturnValue({ data: [{ allowed: true }], error: null });

    const { startExerciseSession } = await import("@/features/quest");
    const result = await (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    });

    expect(result).toEqual({ sessionId: "sess-1", startedAt: "t" });
  });

  it("does NOT unlock when the only passing quiz attempt was rushed (< 4s/question)", async () => {
    let exerciseCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") {
        exerciseCalls += 1;
        return exerciseCalls === 1
          ? mockQuery({
              id: "ex-1",
              mode: "practice",
              chapter_id: "ch-1",
              subjects: { grade_id: "g-1" },
            })
          : mockQuery({ id: "quiz-1" });
      }
      // High score but rushed (3s for 6 questions) → must not satisfy the gate.
      if (table === "attempts")
        return mockQuery([{ id: "att-1", duration_seconds: 3, total_count: 6 }]);
      return mockQuery({ id: "sess-1", started_at: "t" });
    });
    mockRpc.mockReturnValue({ data: [{ allowed: true }], error: null });

    const { startExerciseSession } = await import("@/features/quest");
    await expect(
      (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow("quiz de compréhension");
  });

  it("blocks a premium-parcours mission when resolve_exercise_access denies it", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises")
        return mockQuery({ id: "ex-1", mode: "boss", difficulty: 3, chapter_id: "ch-1" });
      return mockQuery({ id: "sess-1", started_at: "t" });
    });
    // Server gate denies access (no entitlement, outside the free preview).
    mockRpc.mockReturnValue({
      data: [{ allowed: false, reason: "PARCOURS_LOCKED" }],
      error: null,
    });

    const { startExerciseSession } = await import("@/features/quest");
    await expect(
      (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow(/Parcours premium/);
  });

  it("surfaces the coming-soon message when the parcours is not yet available", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises")
        return mockQuery({ id: "ex-1", mode: "boss", difficulty: 3, chapter_id: "ch-1" });
      return mockQuery({ id: "sess-1", started_at: "t" });
    });
    mockRpc.mockReturnValue({
      data: [{ allowed: false, reason: "PARCOURS_COMING_SOON" }],
      error: null,
    });

    const { startExerciseSession } = await import("@/features/quest");
    await expect(
      (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow(/bientôt disponible/);
  });

  it("fails closed when resolve_exercise_access errors (unknown access)", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises")
        return mockQuery({ id: "ex-1", mode: "boss", difficulty: 3, chapter_id: "ch-1" });
      return mockQuery({ id: "sess-1", started_at: "t" });
    });
    mockRpc.mockReturnValue({ data: null, error: { message: "RPC down" } });

    const { startExerciseSession } = await import("@/features/quest");
    await expect(
      (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow(/Parcours premium/);
  });

  it("allows a mission inside the free preview / with an entitlement (access allowed)", async () => {
    let exerciseCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") {
        exerciseCalls += 1;
        return exerciseCalls === 1
          ? mockQuery({
              id: "ex-1",
              mode: "practice",
              difficulty: 2,
              chapter_id: "ch-1",
              subjects: { grade_id: "g-1" },
            })
          : mockQuery({ id: "quiz-1" });
      }
      if (table === "attempts")
        return mockQuery([{ id: "att-1", duration_seconds: 40, total_count: 6 }]); // quiz passed
      return mockQuery({ id: "sess-1", started_at: "2026-06-01T12:00:00Z" });
    });
    mockRpc.mockReturnValue({ data: [{ allowed: true }], error: null });

    const { startExerciseSession } = await import("@/features/quest");
    const result = await (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    });

    expect(result).toEqual({ sessionId: "sess-1", startedAt: "2026-06-01T12:00:00Z" });
  });
});

describe("gamification.quest — submitAttempt", () => {
  const Q1_ID = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
  const Q2_ID = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";
  const SESSION_ID = "11111111-1111-1111-1111-111111111111";
  const EXERCISE_ID = "22222222-2222-2222-2222-222222222222";

  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("surfaces the anti-rush flags (tooFast / improved) and a 0-XP result", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery([{ id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "x" }]);
    });
    // The hardened RPC returns 0 XP with tooFast=true when answered too quickly.
    mockRpc.mockReturnValue({
      data: {
        correct: 1,
        total: 2,
        scorePct: 50,
        xpEarned: 0,
        coinsEarned: 0,
        durationSeconds: 2,
        tooFast: true,
        improved: false,
      },
      error: null,
    });

    const { submitAttempt } = await import("@/features/quest");
    const res = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [
        { questionId: Q1_ID, choice: "4" },
        { questionId: Q2_ID, choice: "1" },
      ],
    })) as Record<string, unknown>;

    expect(res.tooFast).toBe(true);
    expect(res.improved).toBe(false);
    expect(res.xpEarned).toBe(0);
  });

  it("returns scored result with review", async () => {
    // The end-of-quest correction now comes from the get_attempt_review SECURITY
    // DEFINER RPC (snake_case rows), not a direct client read of questions.
    const reviewRows = [
      { question_id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "Basic math" },
      { question_id: Q2_ID, prompt: "3+3?", correct_option: "6", explanation: null },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery([]);
    });
    mockRpc.mockImplementation((name: string) => {
      if (name === "get_attempt_review") return { data: reviewRows, error: null };
      return {
        data: {
          correct: 2,
          total: 2,
          scorePct: 100,
          xpEarned: 50,
          coinsEarned: 10,
          durationSeconds: 45,
          profile: { xp: 250 },
          unlockedBadges: [
            { code: "first_win", name: "First Win", rarity: "common", iconName: null },
          ],
        },
        error: null,
      };
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [
        { questionId: Q1_ID, choice: "4" },
        { questionId: Q2_ID, choice: "6" },
      ],
    });

    const res = result as Record<string, unknown>;
    expect(res.correct).toBe(2);
    expect(res.total).toBe(2);
    expect(res.scorePct).toBe(100);
    expect(res.xpEarned).toBe(50);
    expect(res.coinsEarned).toBe(10);
    expect((res.review as Array<{ isCorrect: boolean }>)[0].isCorrect).toBe(true);
    expect(res.reviewHidden).toBe(false);
    expect((res.unlockedBadges as Array<{ code: string }>)[0].code).toBe("first_win");
    // Daily/weekly goal rows are ensured before the atomic submit so progress
    // actually increments (they used to never be created → stuck at 0).
    expect(mockRpc).toHaveBeenCalledWith("ensure_daily_weekly_goals", {
      p_user: expect.any(String),
    });
  });

  it("surfaces an applied multiplier potion from the RPC payload", async () => {
    const questionsData = [
      { id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "Basic math" },
    ];
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery(questionsData);
    });
    mockRpc.mockReturnValue({
      data: {
        correct: 1,
        total: 1,
        scorePct: 100,
        xpEarned: 100,
        coinsEarned: 20,
        durationSeconds: 30,
        tooFast: false,
        improved: true,
        profile: { xp: 100 },
        unlockedBadges: [],
        potionApplied: {
          itemCode: "potion_xp_boost",
          itemName: "XP Boost",
          xpMultiplier: 2,
          coinMultiplier: 1,
        },
      },
      error: null,
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "4" }],
    })) as Record<string, unknown>;

    const potion = result.potionApplied as Record<string, unknown> | null;
    expect(potion).not.toBeNull();
    expect(potion?.itemCode).toBe("potion_xp_boost");
    expect(potion?.xpMultiplier).toBe(2);
    expect(potion?.coinMultiplier).toBe(1);
  });

  it("returns potionApplied = null when no potion was applied", async () => {
    const questionsData = [{ id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "x" }];
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery(questionsData);
    });
    mockRpc.mockReturnValue({
      data: {
        correct: 1,
        total: 1,
        scorePct: 100,
        xpEarned: 50,
        coinsEarned: 10,
        durationSeconds: 30,
        profile: { xp: 50 },
        unlockedBadges: [],
        potionApplied: null,
      },
      error: null,
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "4" }],
    })) as Record<string, unknown>;

    expect(result.potionApplied).toBeNull();
  });

  it("surfaces retryShieldUsed=true when an armed retry shield suppressed a failure penalty", async () => {
    const questionsData = [{ id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "x" }];
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery(questionsData);
    });
    mockRpc.mockReturnValue({
      data: {
        correct: 0,
        total: 1,
        scorePct: 0,
        xpEarned: 0,
        coinsEarned: 0,
        durationSeconds: 30,
        tooFast: false,
        improved: false,
        profile: { xp: 0 },
        unlockedBadges: [],
        potionApplied: null,
        retryShieldUsed: true,
      },
      error: null,
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "5" }],
    })) as Record<string, unknown>;

    expect(result.retryShieldUsed).toBe(true);
  });

  it("defaults retryShieldUsed to false when the RPC omits it", async () => {
    const questionsData = [{ id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "x" }];
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery(questionsData);
    });
    mockRpc.mockReturnValue({
      data: {
        correct: 1,
        total: 1,
        scorePct: 100,
        xpEarned: 50,
        coinsEarned: 10,
        durationSeconds: 30,
        profile: { xp: 50 },
        unlockedBadges: [],
        potionApplied: null,
      },
      error: null,
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "4" }],
    })) as Record<string, unknown>;

    expect(result.retryShieldUsed).toBe(false);
  });

  it("hides the correction (no correct answers leak) for a comprehension quiz", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "quiz" });
      // questions table
      return mockQuery([{ id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "x" }]);
    });
    mockRpc.mockReturnValue({
      data: {
        correct: 1,
        total: 1,
        scorePct: 100,
        xpEarned: 20,
        coinsEarned: 5,
        durationSeconds: 10,
        profile: { xp: 20 },
        unlockedBadges: [],
      },
      error: null,
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "4" }],
    });

    const res = result as Record<string, unknown>;
    // Score is still returned, but the per-question correction (correct answers /
    // explanations) is withheld so the student can't memorise and re-pass blindly.
    expect(res.scorePct).toBe(100);
    expect(res.reviewHidden).toBe(true);
    expect((res.review as unknown[]).length).toBe(0);
  });

  it("throws when rate limited", async () => {
    const { isRateLimited } = await import("@/shared/lib/rate-limit");
    vi.mocked(isRateLimited).mockResolvedValueOnce(true);

    const { submitAttempt } = await import("@/features/quest");

    await expect(
      (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
        sessionId: SESSION_ID,
        exerciseId: EXERCISE_ID,
        answers: [{ questionId: Q1_ID, choice: "4" }],
      }),
    ).rejects.toThrow("Too many submissions");
  });

  it("degrades to an empty review (no throw) when get_attempt_review fails", async () => {
    mockFrom.mockImplementation(() => mockQuery([]));
    mockRpc.mockImplementation((name: string) =>
      name === "get_attempt_review"
        ? { data: null, error: { message: "review RPC down" } }
        : { data: { correct: 1, total: 1, scorePct: 100, unlockedBadges: [] }, error: null },
    );
    const { submitAttempt } = await import("@/features/quest");
    const res = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "4" }],
    })) as Record<string, unknown>;
    expect(res.scorePct).toBe(100);
    expect((res.review as unknown[]).length).toBe(0);
  });

  it("throws on submit RPC error", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery([{ id: Q1_ID, prompt: "?", correct_option: "a", explanation: null }]),
    );
    mockRpc.mockReturnValue({ data: null, error: { message: "RPC submit fail" } });

    const { submitAttempt } = await import("@/features/quest");

    await expect(
      (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
        sessionId: SESSION_ID,
        exerciseId: EXERCISE_ID,
        answers: [{ questionId: Q1_ID, choice: "a" }],
      }),
    ).rejects.toThrow("Impossible d'enregistrer votre tentative.");
  });
});

describe("gamification.quest — input validation", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("rejects invalid exerciseId format for getExercise", async () => {
    const { getExercise } = await import("@/features/quest");

    await expect(
      (getExercise as unknown as (d: unknown) => Promise<unknown>)({ exerciseId: "not-a-uuid" }),
    ).rejects.toThrow();
  });

  it("rejects empty answers array for submitAttempt", async () => {
    const { submitAttempt } = await import("@/features/quest");

    await expect(
      (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
        sessionId: "11111111-1111-1111-1111-111111111111",
        exerciseId: "22222222-2222-2222-2222-222222222222",
        answers: [],
      }),
    ).rejects.toThrow();
  });

  it("rejects missing sessionId for submitAttempt", async () => {
    const { submitAttempt } = await import("@/features/quest");

    await expect(
      (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: "22222222-2222-2222-2222-222222222222",
        answers: [{ questionId: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", choice: "a" }],
      }),
    ).rejects.toThrow();
  });
});

describe("gamification.quest — getChapterLesson", () => {
  const CH = "11111111-1111-1111-1111-111111111111";
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns the chapter and sibling nav (hasLesson reflects lesson_content)", async () => {
    let calls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "chapters") {
        calls += 1;
        return calls === 1
          ? mockQuery({ id: "ch-1", title: "C1", subject_id: "s1", lesson_content: "x" })
          : mockQuery([
              { id: "ch-1", title: "C1", display_order: 1, lesson_content: "x" },
              { id: "ch-2", title: "C2", display_order: 2, lesson_content: null },
            ]);
      }
      return mockQuery([]);
    });

    const { getChapterLesson } = await import("@/features/quest");
    const res = (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
      chapterId: CH,
    })) as { chapter: { id: string }; allChapters: Array<{ id: string; hasLesson: boolean }> };

    expect(res.chapter.id).toBe("ch-1");
    expect(res.allChapters).toEqual([
      { id: "ch-1", title: "C1", display_order: 1, hasLesson: true },
      { id: "ch-2", title: "C2", display_order: 2, hasLesson: false },
    ]);
  });

  it("falls back to an empty sibling list when none are returned", async () => {
    let calls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "chapters") {
        calls += 1;
        return calls === 1 ? mockQuery({ id: "ch-1", subject_id: "s1" }) : mockQuery(null);
      }
      return mockQuery([]);
    });

    const { getChapterLesson } = await import("@/features/quest");
    const res = (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
      chapterId: CH,
    })) as { allChapters: unknown[] };
    expect(res.allChapters).toEqual([]);
  });

  it("throws a safe message on chapter fetch error", async () => {
    mockFrom.mockImplementation((table: string) =>
      table === "chapters" ? mockQuery(null, { message: "boom" }) : mockQuery([]),
    );
    const { getChapterLesson } = await import("@/features/quest");
    await expect(
      (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({ chapterId: CH }),
    ).rejects.toThrow(/leçon/i);
  });
});
