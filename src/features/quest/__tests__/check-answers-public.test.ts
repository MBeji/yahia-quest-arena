import { describe, it, expect, vi, beforeEach } from "vitest";

const { mockRpc, mockFrom, mockIsRateLimited, mockIsRateLimitedLocal, mockGetRequest } = vi.hoisted(
  () => ({
    mockRpc: vi.fn(),
    mockFrom: vi.fn(),
    mockIsRateLimited: vi.fn(),
    mockIsRateLimitedLocal: vi.fn(),
    mockGetRequest: vi.fn(),
  }),
);

// Controls the userId the mocked middleware injects (null = anonymous visitor).
let ctxUserId: string | null = null;
const mockSupabase = { rpc: mockRpc, from: mockFrom };

/** Thenable select().eq() chain for the per-type format-validation lookup. */
function questionTypesQuery(rows: unknown, error: unknown = null) {
  return { select: () => ({ eq: () => Promise.resolve({ data: rows, error }) }) };
}

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
        return async (input: unknown) => {
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: ctxUserId } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@tanstack/react-start/server", () => ({ getRequest: mockGetRequest }));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: mockIsRateLimited,
  isRateLimitedLocal: mockIsRateLimitedLocal,
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn() },
}));
vi.mock("@/shared/lib/safe-error", () => ({
  failWithClientError: (_ctx: string, _err: unknown, msg: string) => {
    throw new Error(msg);
  },
  errorMessage: (e: unknown) => String(e),
}));

import { checkAnswersPublic } from "@/features/quest/quest.server";

type Result = {
  reviewable: boolean;
  correct: number;
  total: number;
  scorePct: number;
  review: Array<{
    questionId: string;
    selectedChoice: string;
    isCorrect: boolean;
    correctChoice: string | null;
    explanation: string | null;
  }>;
};
const call = checkAnswersPublic as unknown as (input: unknown) => Promise<Result>;

const Q1 = "11111111-1111-1111-1111-111111111111";
const Q2 = "22222222-2222-2222-2222-222222222222";
const EX = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee";

describe("quest.checkAnswersPublic", () => {
  beforeEach(() => {
    ctxUserId = null;
    mockRpc.mockReset();
    // Default: both questions are plain mcq (format validation passes).
    mockFrom.mockReset().mockReturnValue(
      questionTypesQuery([
        { id: Q1, question_type: "mcq" },
        { id: Q2, question_type: "mcq" },
      ]),
    );
    mockIsRateLimited.mockReset().mockResolvedValue(false);
    mockIsRateLimitedLocal.mockReset().mockReturnValue(false);
    mockGetRequest
      .mockReset()
      .mockReturnValue({ headers: new Headers({ "x-forwarded-for": "1.2.3.4" }) });
  });

  it("maps the RPC correction into a scored review (practice)", async () => {
    mockRpc.mockResolvedValue({
      data: [
        { question_id: Q1, is_correct: true, correct_option: "a", explanation: "Because a." },
        { question_id: Q2, is_correct: false, correct_option: "b", explanation: "Because b." },
      ],
      error: null,
    });

    const res = await call({
      exerciseId: EX,
      answers: [
        { questionId: Q1, choice: "a" },
        { questionId: Q2, choice: "x" },
      ],
    });

    expect(res.reviewable).toBe(true);
    expect(res.total).toBe(2);
    expect(res.correct).toBe(1);
    expect(res.scorePct).toBe(50);
    expect(res.review[1]).toEqual({
      questionId: Q2,
      selectedChoice: "x",
      isCorrect: false,
      correctChoice: "b",
      explanation: "Because b.",
    });
  });

  it("passes the exercise id and answers to the check_answers RPC", async () => {
    mockRpc.mockResolvedValue({ data: [], error: null });
    await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(mockRpc).toHaveBeenCalledWith("check_answers", {
      p_exercise_id: EX,
      p_answers: [{ questionId: Q1, choice: "a" }],
    });
  });

  it("returns a non-reviewable result when the RPC yields no rows (quiz/parent)", async () => {
    mockRpc.mockResolvedValue({ data: [], error: null });
    const res = await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(res.reviewable).toBe(false);
    expect(res.total).toBe(0);
    expect(res.scorePct).toBe(0);
    expect(res.review).toEqual([]);
  });

  it("tolerates a non-array RPC payload", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const res = await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(res.reviewable).toBe(false);
  });

  it("uses the in-memory limiter for anonymous callers, not the persistent one", async () => {
    mockRpc.mockResolvedValue({ data: [], error: null });
    await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(mockIsRateLimitedLocal).toHaveBeenCalledTimes(1);
    expect(mockIsRateLimited).not.toHaveBeenCalled();
  });

  it("uses the persistent limiter for signed-in callers", async () => {
    ctxUserId = "user-9";
    mockRpc.mockResolvedValue({ data: [], error: null });
    await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(mockIsRateLimited).toHaveBeenCalledWith(
      mockSupabase,
      "check_answers_user-9",
      30,
      60_000,
    );
    expect(mockIsRateLimitedLocal).not.toHaveBeenCalled();
  });

  it("throws when rate-limited", async () => {
    mockIsRateLimitedLocal.mockReturnValue(true);
    await expect(
      call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] }),
    ).rejects.toThrow("Trop de requêtes");
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("rejects a malformed numeric answer before calling the RPC", async () => {
    mockFrom.mockReturnValue(questionTypesQuery([{ id: Q1, question_type: "numeric" }]));
    await expect(
      call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "abc" }] }),
    ).rejects.toThrow("Réponse invalide pour ce type de question.");
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("accepts a well-formed numeric answer (comma decimal)", async () => {
    mockFrom.mockReturnValue(questionTypesQuery([{ id: Q1, question_type: "numeric" }]));
    mockRpc.mockResolvedValue({
      data: [{ question_id: Q1, is_correct: true, correct_option: "3.14", explanation: null }],
      error: null,
    });
    const res = await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "3,14" }] });
    expect(res.correct).toBe(1);
    expect(res.review[0].correctChoice).toBe("3.14");
  });

  it("degrades open when the question_type lookup fails", async () => {
    mockFrom.mockReturnValue(questionTypesQuery(null, { message: "boom" }));
    mockRpc.mockResolvedValue({ data: [], error: null });
    const res = await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "abc" }] });
    expect(res.reviewable).toBe(false);
    expect(mockRpc).toHaveBeenCalled();
  });

  it("throws a sanitized error when the RPC fails", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    await expect(
      call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] }),
    ).rejects.toThrow("Impossible de corriger l'entraînement.");
  });
});
