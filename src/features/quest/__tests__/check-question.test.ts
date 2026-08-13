import { describe, it, expect, vi, beforeEach } from "vitest";

const { mockRpc, mockFrom, mockIsRateLimited } = vi.hoisted(() => ({
  mockRpc: vi.fn(),
  mockFrom: vi.fn(),
  mockIsRateLimited: vi.fn(),
}));

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
          return handlerFn({ data, context: { supabase: mockSupabase, userId: "user-1" } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@tanstack/react-start/server", () => ({ getRequest: vi.fn() }));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: mockIsRateLimited,
  isRateLimitedLocal: vi.fn().mockReturnValue(false),
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

import { checkQuestion } from "@/features/quest/quest.check.server";

type Verdict = {
  questionId: string;
  isCorrect: boolean;
  correctChoice: string | null;
  explanation: string | null;
} | null;
const call = checkQuestion as unknown as (input: unknown) => Promise<Verdict>;

const Q1 = "11111111-1111-1111-1111-111111111111";
const EX = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee";

describe("quest.checkQuestion (retour immédiat, levier 01)", () => {
  beforeEach(() => {
    mockRpc.mockReset();
    mockFrom.mockReset().mockReturnValue(questionTypesQuery([{ id: Q1, question_type: "mcq" }]));
    mockIsRateLimited.mockReset().mockResolvedValue(false);
  });

  it("rend le verdict d'une bonne réponse", async () => {
    mockRpc.mockResolvedValue({
      data: [
        { question_id: Q1, is_correct: true, correct_option: "a", explanation: "Parce que a." },
      ],
      error: null,
    });

    await expect(call({ exerciseId: EX, questionId: Q1, choice: "a" })).resolves.toEqual({
      questionId: Q1,
      isCorrect: true,
      correctChoice: "a",
      explanation: "Parce que a.",
    });
  });

  it("rend la bonne option et l'explication sur une réponse fausse", async () => {
    mockRpc.mockResolvedValue({
      data: [{ question_id: Q1, is_correct: false, correct_option: "b", explanation: "C'est b." }],
      error: null,
    });

    const verdict = await call({ exerciseId: EX, questionId: Q1, choice: "a" });
    expect(verdict).toEqual({
      questionId: Q1,
      isCorrect: false,
      correctChoice: "b",
      explanation: "C'est b.",
    });
  });

  it("n'envoie QUE la question demandée à la RPC de correction", async () => {
    mockRpc.mockResolvedValue({ data: [], error: null });
    await call({ exerciseId: EX, questionId: Q1, choice: "a" });
    expect(mockRpc).toHaveBeenCalledWith("check_answers", {
      p_exercise_id: EX,
      p_answers: [{ questionId: Q1, choice: "a" }],
    });
  });

  it("rend null quand la RPC ne corrige pas (quiz, catalogue non-admin) — le lecteur enchaîne", async () => {
    // `check_answers` sort sans ligne pour un `mode = 'quiz'` ou une source ≠ admin.
    mockRpc.mockResolvedValue({ data: [], error: null });
    await expect(call({ exerciseId: EX, questionId: Q1, choice: "a" })).resolves.toBeNull();
  });

  it("rend null si la RPC répond pour une AUTRE question que celle demandée", async () => {
    mockRpc.mockResolvedValue({
      data: [{ question_id: "other", is_correct: true, correct_option: "a", explanation: null }],
      error: null,
    });
    await expect(call({ exerciseId: EX, questionId: Q1, choice: "a" })).resolves.toBeNull();
  });

  it("refuse au-delà du plafond de requêtes", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    await expect(call({ exerciseId: EX, questionId: Q1, choice: "a" })).rejects.toThrow(/Trop de/);
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("refuse une réponse au mauvais format pour le type de la question", async () => {
    // La question est numérique : un id d'option QCM n'est pas un format valide.
    mockFrom.mockReturnValue(questionTypesQuery([{ id: Q1, question_type: "numeric" }]));
    await expect(call({ exerciseId: EX, questionId: Q1, choice: "a" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
