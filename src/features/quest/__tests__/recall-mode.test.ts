import { describe, it, expect, vi, beforeEach } from "vitest";

// Recall mode (étude 17, lot 3) — server-fn wiring: the free-text active-recall
// variant is relayed to the SECURITY DEFINER RPCs, questions never carry options
// (R-1), hints are off (R-11), per-question verdicts come from the submit RPC
// (D-4, never re-scored on the TS side), and availability degrades gracefully.

// ---- Mocks (mirrors quest.test.ts) ----
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
  chain.then = (fn: (v: unknown) => unknown) => fn(result);
  Object.assign(chain, result);
  return chain;
}

const EXID = "11111111-1111-1111-1111-111111111111";

describe("quest recall — getExercise", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("serves the recall play set from the RPC with no options and hints off", async () => {
    const exerciseData = { id: "ex-1", title: "Ex 1" };
    const recallRows = [
      { id: "q-1", prompt: "2+2?", display_order: 1 },
      { id: "q-2", prompt: "3+3?", display_order: 2 },
    ];
    let fetchedQuestionsTable = false;
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery(exerciseData);
      if (table === "questions") {
        fetchedQuestionsTable = true;
        return mockQuery([{ id: "q-1", prompt: "2+2?", options: ["3", "4"], display_order: 1 }]);
      }
      // An owned hint consumable — must be ignored in recall (R-11).
      if (table === "inventory_items")
        return mockQuery([
          { quantity: 3, item: { item_type: "booster", effect_payload: { hints: 3 } } },
        ]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation((fn: string) => {
      if (fn === "get_recall_questions") return { data: recallRows, error: null };
      return { data: [], error: null };
    });

    const { getExercise } = await import("@/features/quest");
    const result = (await (getExercise as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: EXID,
      variant: "recall",
    })) as {
      variant: string;
      hintCharges: number;
      questions: Array<{ id: string; prompt: string; options: unknown[]; question_type: string }>;
    };

    expect(result.variant).toBe("recall");
    // R-1: the answer key never reaches the client — options are empty by construction.
    expect(result.questions).toHaveLength(2);
    expect(result.questions.every((q) => Array.isArray(q.options) && q.options.length === 0)).toBe(
      true,
    );
    expect(result.questions[0]).toMatchObject({ id: "q-1", prompt: "2+2?", question_type: "mcq" });
    // R-11: no hints in recall, even when the account owns hint consumables.
    expect(result.hintCharges).toBe(0);
    // The classic `questions` table is never read in recall (no options leak).
    expect(fetchedQuestionsTable).toBe(false);
    expect(mockRpc).toHaveBeenCalledWith("get_recall_questions", { p_exercise_id: EXID });
  });

  it("surfaces the not-eligible message when the recall RPC errors", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ id: "ex-1" });
      return mockQuery([]);
    });
    mockRpc.mockImplementation((fn: string) => {
      if (fn === "get_recall_questions")
        return { data: null, error: { message: "RECALL_NOT_ELIGIBLE" } };
      return { data: [], error: null };
    });

    const { getExercise } = await import("@/features/quest");
    await expect(
      (getExercise as unknown as (d: unknown) => Promise<unknown>)({
        exerciseId: EXID,
        variant: "recall",
      }),
    ).rejects.toThrow(/mode Rappel/);
  });
});

describe("quest recall — startExerciseSession", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  const start = async (variant?: string) => {
    const { startExerciseSession } = await import("@/features/quest");
    return (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: EXID,
      ...(variant ? { variant } : {}),
    });
  };

  it("relays the recall variant to the RPC", async () => {
    mockRpc.mockReturnValue({
      data: [{ session_id: "sess-1", started_at: "2026-07-14T12:00:00Z" }],
      error: null,
    });
    const res = await start("recall");
    expect(res).toEqual({ sessionId: "sess-1", startedAt: "2026-07-14T12:00:00Z" });
    expect(mockRpc).toHaveBeenCalledWith("start_exercise_session", {
      p_exercise_id: EXID,
      p_variant: "recall",
    });
  });

  it("defaults the variant to classic when omitted", async () => {
    mockRpc.mockReturnValue({
      data: [{ session_id: "sess-1", started_at: "2026-07-14T12:00:00Z" }],
      error: null,
    });
    await start();
    expect(mockRpc).toHaveBeenCalledWith("start_exercise_session", {
      p_exercise_id: EXID,
      p_variant: "classic",
    });
  });

  it("surfaces the locked message on a RECALL_LOCKED gate", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "RECALL_LOCKED" } });
    await expect(start("recall")).rejects.toThrow(/débloquer le mode Rappel/);
  });

  it("surfaces the not-eligible message on a RECALL_NOT_ELIGIBLE gate", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "RECALL_NOT_ELIGIBLE" } });
    await expect(start("recall")).rejects.toThrow(/mode Rappel/);
  });

  it("maps an INVALID_VARIANT programming error to the not-eligible surface", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "INVALID_VARIANT" } });
    await expect(start("recall")).rejects.toThrow(/mode Rappel/);
  });
});

describe("quest recall — submitAttempt review", () => {
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

  it("sources per-question correctness from the submit RPC, not re-scoring the text", async () => {
    // The typed text differs from the option text; the classic string-equality
    // fallback would call BOTH wrong. The recall verdict must come from perQuestion.
    const reviewRows = [
      { question_id: Q1_ID, prompt: "2+2?", correct_option: "quatre", explanation: null },
      { question_id: Q2_ID, prompt: "3+3?", correct_option: "six", explanation: null },
    ];
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery([]);
    });
    mockRpc.mockImplementation((name: string) => {
      if (name === "get_attempt_review") return { data: reviewRows, error: null };
      if (name === "submit_exercise_attempt") {
        return {
          data: {
            correct: 1,
            total: 2,
            scorePct: 50,
            xpEarned: 15,
            coinsEarned: 3,
            durationSeconds: 40,
            variant: "recall",
            // The RPC scored the normalized free text: Q1 right, Q2 wrong.
            perQuestion: [
              { questionId: Q1_ID, isCorrect: true },
              { questionId: Q2_ID, isCorrect: false },
            ],
          },
          error: null,
        };
      }
      return { data: [], error: null };
    });

    const { submitAttempt } = await import("@/features/quest");
    const res = (await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [
        { questionId: Q1_ID, choice: "Quatre" },
        { questionId: Q2_ID, choice: "sept" },
      ],
    })) as {
      variant: string;
      review: Array<{ questionId: string; isCorrect: boolean; correctChoice: string }>;
    };

    expect(res.variant).toBe("recall");
    const byId = new Map(res.review.map((r) => [r.questionId, r]));
    expect(byId.get(Q1_ID)?.isCorrect).toBe(true);
    expect(byId.get(Q2_ID)?.isCorrect).toBe(false);
    // correctChoice is the option TEXT the review RPC returns in recall.
    expect(byId.get(Q1_ID)?.correctChoice).toBe("quatre");
  });
});

describe("quest recall — getSubject availability", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("builds the recall availability maps from the RPC", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") return mockQuery({ id: "subj-1" });
      if (table === "chapters") return mockQuery([]);
      if (table === "exercises") return mockQuery([]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation((fn: string) => {
      if (fn === "get_recall_availability")
        return {
          data: [
            { exercise_id: "ex-1", eligible_count: 5, unlocked: true, best_recall_pct: 80 },
            { exercise_id: "ex-2", eligible_count: 2, unlocked: false, best_recall_pct: null },
          ],
          error: null,
        };
      return { data: [], error: null };
    });

    const { getSubject } = await import("@/features/quest");
    const result = (await (getSubject as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "subj-1",
    })) as {
      recall: {
        eligibleByExercise: Record<string, number>;
        unlockedByExercise: Record<string, boolean>;
        bestByExercise: Record<string, number>;
      };
    };

    expect(result.recall).toEqual({
      eligibleByExercise: { "ex-1": 5, "ex-2": 2 },
      unlockedByExercise: { "ex-1": true, "ex-2": false },
      // Only ex-1 has a best score; a null best is omitted.
      bestByExercise: { "ex-1": 80 },
    });
  });

  it("degrades to empty recall maps when the availability RPC fails", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") return mockQuery({ id: "subj-1" });
      if (table === "chapters") return mockQuery([]);
      if (table === "exercises") return mockQuery([]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation((fn: string) => {
      if (fn === "get_recall_availability")
        return { data: null, error: { message: "RPC missing" } };
      return { data: [], error: null };
    });

    const { getSubject } = await import("@/features/quest");
    const result = (await (getSubject as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "subj-1",
    })) as { recall: Record<string, Record<string, unknown>> };

    expect(result.recall).toEqual({
      eligibleByExercise: {},
      unlockedByExercise: {},
      bestByExercise: {},
    });
  });
});
