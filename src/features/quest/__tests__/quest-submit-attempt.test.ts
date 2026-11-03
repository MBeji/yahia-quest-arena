// @vitest-environment node
// Le bloc `submitAttempt` de `quest.test.ts`, sorti à part : ce fichier-là était à 712 lignes
// de code pour un plafond de 750, et ce bloc en faisait plus de la moitié. Le décor est
// recopié, comme dans `quest-get-subject.test.ts` : un `vi.mock` s'applique au fichier où
// il est écrit, il ne se partage pas par import.

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
      validator: (fn: (d: unknown) => unknown) => {
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

vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));

vi.mock("@tanstack/react-start/server", () => ({
  getRequest: vi.fn(() => ({ headers: new Headers() })),
}));

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
  isRateLimitedLocal: vi.fn().mockReturnValue(false),
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
  chain.not = vi.fn().mockReturnValue(chain);
  chain.neq = vi.fn().mockReturnValue(chain);
  // Make the chain itself resolve like a promise with data/error
  chain.then = (fn: (v: unknown) => unknown) => fn(result);
  Object.assign(chain, result);
  return chain;
}

/**
 * La table des réponses figées (migration 20260929120000), lue par le démarrage et
 * par la soumission : vide sauf mention contraire, quel que soit le décor du test.
 */
function withReveals(impl: (table: string) => unknown, reveals: unknown[] = []) {
  return (table: string) =>
    table === "exercise_session_reveals" ? mockQuery(reveals) : impl(table);
}

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
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery([{ id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "x" }]);
      }),
    );
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

    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery([]);
      }),
    );
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

  it("rejects a malformed numeric answer before any scoring RPC", async () => {
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery([{ id: Q1_ID, question_type: "numeric" }]);
      }),
    );

    const { submitAttempt } = await import("@/features/quest");
    await expect(
      (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
        sessionId: SESSION_ID,
        exerciseId: EXERCISE_ID,
        answers: [{ questionId: Q1_ID, choice: "abc" }],
      }),
    ).rejects.toThrow("Réponse invalide pour ce type de question.");
    expect(mockRpc).not.toHaveBeenCalledWith("submit_exercise_attempt", expect.anything());
  });

  it("scores the review through the RPC — an in-tolerance numeric answer shows correct", async () => {
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery([{ id: Q1_ID, question_type: "numeric" }]);
      }),
    );
    mockRpc.mockImplementation((name: string) => {
      if (name === "get_attempt_review") {
        return {
          data: [
            {
              question_id: Q1_ID,
              prompt: "pi ≈ ?",
              correct_option: "3.14",
              explanation: null,
              is_correct: true,
            },
          ],
          error: null,
        };
      }
      return {
        data: { correct: 1, total: 1, scorePct: 100, xpEarned: 10, coinsEarned: 1 },
        error: null,
      };
    });

    const { submitAttempt } = await import("@/features/quest");
    const res = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "3,15" }],
    })) as Record<string, unknown>;

    const review = res.review as Array<{ isCorrect: boolean; correctChoice: string }>;
    // Server-scored via score_answer (is_correct), NOT the old "3,15" === "3.14"
    // string equality — the review can no longer contradict the counted score.
    expect(review[0].isCorrect).toBe(true);
    expect(review[0].correctChoice).toBe("3.14");
    expect(mockRpc).toHaveBeenCalledWith("get_attempt_review", {
      p_session_id: SESSION_ID,
      p_answers: [{ questionId: Q1_ID, choice: "3,15" }],
    });
  });

  it("surfaces an applied multiplier potion from the RPC payload", async () => {
    const questionsData = [
      { id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "Basic math" },
    ];
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery(questionsData);
      }),
    );
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
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery(questionsData);
      }),
    );
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
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery(questionsData);
      }),
    );
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
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "practice" });
        return mockQuery(questionsData);
      }),
    );
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
    mockFrom.mockImplementation(
      withReveals((table: string) => {
        if (table === "exercises") return mockQuery({ mode: "quiz" });
        // questions table
        return mockQuery([{ id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: "x" }]);
      }),
    );
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
    // Les lectures préparatoires partent en même temps que le rate limit
    // (2026-10-31) : un décor vide suffit, le refus de débit l'emporte.
    mockFrom.mockImplementation(withReveals(() => mockQuery([])));

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
