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

import { scoreQuizPublic } from "@/features/quest/quest.server";

type Result = { correct: number; total: number; scorePct: number };
const call = scoreQuizPublic as unknown as (input: unknown) => Promise<Result>;

const Q1 = "11111111-1111-1111-1111-111111111111";
const EX = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee";

describe("quest.scoreQuizPublic", () => {
  beforeEach(() => {
    ctxUserId = null;
    mockRpc.mockReset();
    // Default: the quiz question is a plain mcq (format validation passes).
    mockFrom.mockReset().mockReturnValue(questionTypesQuery([{ id: Q1, question_type: "mcq" }]));
    mockIsRateLimited.mockReset().mockResolvedValue(false);
    mockIsRateLimitedLocal.mockReset().mockReturnValue(false);
    mockGetRequest
      .mockReset()
      .mockReturnValue({ headers: new Headers({ "x-forwarded-for": "1.2.3.4" }) });
  });

  it("rejects a malformed numeric answer before calling the RPC", async () => {
    mockFrom.mockReturnValue(questionTypesQuery([{ id: Q1, question_type: "numeric" }]));
    await expect(
      call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "not-a-number" }] }),
    ).rejects.toThrow("Réponse invalide pour ce type de question.");
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("maps the aggregate RPC row into a percentage score", async () => {
    mockRpc.mockResolvedValue({ data: [{ correct: 4, total: 5 }], error: null });
    const res = await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(res).toEqual({ correct: 4, total: 5, scorePct: 80 });
  });

  it("passes the exercise id and answers to the score_quiz RPC", async () => {
    mockRpc.mockResolvedValue({ data: [{ correct: 0, total: 0 }], error: null });
    await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(mockRpc).toHaveBeenCalledWith("score_quiz", {
      p_exercise_id: EX,
      p_answers: [{ questionId: Q1, choice: "a" }],
    });
  });

  it("returns 0% when the RPC reports a zero total (refused: practice/parent)", async () => {
    mockRpc.mockResolvedValue({ data: [{ correct: 0, total: 0 }], error: null });
    const res = await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(res).toEqual({ correct: 0, total: 0, scorePct: 0 });
  });

  it("tolerates a non-array RPC payload", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const res = await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(res).toEqual({ correct: 0, total: 0, scorePct: 0 });
  });

  it("uses the in-memory limiter for anonymous callers, not the persistent one", async () => {
    mockRpc.mockResolvedValue({ data: [{ correct: 1, total: 1 }], error: null });
    await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(mockIsRateLimitedLocal).toHaveBeenCalledTimes(1);
    expect(mockIsRateLimited).not.toHaveBeenCalled();
  });

  it("uses the persistent limiter for signed-in callers", async () => {
    ctxUserId = "user-7";
    mockRpc.mockResolvedValue({ data: [{ correct: 1, total: 1 }], error: null });
    await call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] });
    expect(mockIsRateLimited).toHaveBeenCalledWith(mockSupabase, "score_quiz_user-7", 30, 60_000);
    expect(mockIsRateLimitedLocal).not.toHaveBeenCalled();
  });

  it("throws when rate-limited", async () => {
    mockIsRateLimitedLocal.mockReturnValue(true);
    await expect(
      call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] }),
    ).rejects.toThrow("Trop de requêtes");
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("throws a sanitized error when the RPC fails", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    await expect(
      call({ exerciseId: EX, answers: [{ questionId: Q1, choice: "a" }] }),
    ).rejects.toThrow("Impossible de corriger le quiz.");
  });
});
