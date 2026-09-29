// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

// =============================================================================
// UNE RÉPONSE CORRIGÉE EST DÉFINITIVE (migration 20260929120000) — le côté
// server fns de la triche au F5, signalée par un parent : cocher au hasard, lire
// la bonne réponse, recharger, la redonner — comptée juste.
//
// Le verrou lui-même est SQL (pgTAP 100). Ce fichier garde ce que les server fns
// en font : le démarrage rend les réponses figées d'une partie reprise, et la
// soumission note ET corrige sur elles, quoi que le payload porte.
// =============================================================================

const { mockFrom, mockRpc } = vi.hoisted(() => ({ mockFrom: vi.fn(), mockRpc: vi.fn() }));
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
        return async (input: unknown) =>
          handlerFn({
            data: validatorFn ? validatorFn(input) : input,
            context: { supabase: mockSupabase, userId: "user-123" },
          });
      },
    };
    return chain;
  },
}));
vi.mock("@tanstack/react-start/server", () => ({
  getRequest: vi.fn(() => ({ headers: new Headers() })),
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
  isRateLimitedLocal: vi.fn().mockReturnValue(false),
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { startExerciseSession, submitAttempt } from "@/features/quest";

/** Une requête PostgREST thenable : `select().eq()` → `{ data, error }`. */
function query(data: unknown, error: unknown = null) {
  const result = { data, error };
  const chain: Record<string, unknown> = {
    then: (fn: (v: unknown) => unknown) => fn(result),
  };
  for (const method of ["select", "eq", "in", "order", "limit"]) {
    chain[method] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  return chain;
}

/** Le décor : la table des réponses figées, les exercices, et tout le reste vide. */
function tables(reveals: unknown, revealsError: unknown = null) {
  return (table: string) => {
    if (table === "exercise_session_reveals") return query(reveals, revealsError);
    if (table === "exercises") return query({ mode: "practice" });
    return query([]);
  };
}

const start = startExerciseSession as unknown as (d: unknown) => Promise<Record<string, unknown>>;
const submit = submitAttempt as unknown as (d: unknown) => Promise<Record<string, unknown>>;

const EXERCISE_ID = "22222222-2222-2222-2222-222222222222";
const SESSION_ID = "11111111-1111-1111-1111-111111111111";
const Q1 = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
const Q2 = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";

beforeEach(() => {
  mockFrom.mockReset();
  mockRpc.mockReset();
});

describe("startExerciseSession — la partie reprise arrive avec ses réponses figées", () => {
  beforeEach(() => {
    mockRpc.mockReturnValue({
      data: [{ session_id: SESSION_ID, started_at: "2026-09-29T12:00:00Z" }],
      error: null,
    });
  });

  it("rend les réponses déjà corrigées : le rechargement ne les rend pas rejouables", async () => {
    mockFrom.mockImplementation(tables([{ question_id: Q1, choice: "b" }]));

    await expect(start({ exerciseId: EXERCISE_ID })).resolves.toMatchObject({
      sessionId: SESSION_ID,
      revealed: [{ questionId: Q1, choice: "b" }],
    });
    expect(mockFrom).toHaveBeenCalledWith("exercise_session_reveals");
  });

  it("démarre quand même si la lecture échoue — le barème SQL tient le verrou", async () => {
    mockFrom.mockImplementation(tables(null, { message: "boom" }));

    await expect(start({ exerciseId: EXERCISE_ID })).resolves.toMatchObject({
      sessionId: SESSION_ID,
      revealed: [],
    });
  });
});

describe("submitAttempt — la note et la correction portent sur la réponse figée", () => {
  it("le F5 : « b » corrigé puis « a » renvoyé — c'est « b » qui part au barème et à la correction", async () => {
    mockFrom.mockImplementation(tables([{ question_id: Q1, choice: "b" }]));
    mockRpc.mockImplementation((name: string) =>
      name === "get_attempt_review"
        ? { data: [], error: null }
        : { data: { correct: 1, total: 2, scorePct: 50, xpEarned: 0 }, error: null },
    );

    await submit({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [
        { questionId: Q1, choice: "a" },
        { questionId: Q2, choice: "a" },
      ],
    });

    const locked = [
      { questionId: Q1, choice: "b" },
      { questionId: Q2, choice: "a" },
    ];
    expect(mockRpc).toHaveBeenCalledWith("submit_exercise_attempt", {
      p_session_id: SESSION_ID,
      p_exercise_id: EXERCISE_ID,
      p_answers: locked,
    });
    expect(mockRpc).toHaveBeenCalledWith("get_attempt_review", {
      p_session_id: SESSION_ID,
      p_answers: locked,
    });
  });
});
