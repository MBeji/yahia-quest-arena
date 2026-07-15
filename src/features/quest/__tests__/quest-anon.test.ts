import { describe, it, expect, vi, beforeEach } from "vitest";

// Anonymous (no userId) path of the content reads switched to optionalSupabaseAuth
// in lot L0.4b: getSubject + getExercise must work without a session and skip every
// account-bound branch (best scores, quiz-pass lookup, premium viewer, hint inventory).

const { mockFrom, mockRpc } = vi.hoisted(() => ({ mockFrom: vi.fn(), mockRpc: vi.fn() }));

let ctxUserId: string | null = null;
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
        return async (input: unknown) => {
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: ctxUserId } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@tanstack/react-start/server", () => ({
  getRequest: vi.fn(() => ({ headers: new Headers() })),
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({ requireSupabaseAuth: "mw" }));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mw-optional",
}));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
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

import { getSubject, getExercise } from "@/features/quest/quest.server";

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.in = vi.fn().mockReturnValue(chain);
  chain.gte = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.then = (fn: (v: unknown) => unknown) => fn(result);
  Object.assign(chain, result);
  return chain;
}

const callSubject = getSubject as unknown as (input: unknown) => Promise<{
  viewer: { level: number; isPremium: boolean; hasEntitlement: boolean };
  bestByExercise: Record<string, number>;
  quizPassedByChapter: Record<string, boolean>;
  exercises: unknown[];
}>;
const callExercise = getExercise as unknown as (input: unknown) => Promise<{
  exercise: unknown;
  questions: unknown[];
  hintCharges: number;
}>;

describe("quest anonymous content reads (L0.4b)", () => {
  beforeEach(() => {
    ctxUserId = null;
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getSubject (anon): open viewer, no best scores, only content-derived RPCs, quiz gate left unpassed", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects")
        return mockQuery({
          id: "subj-1",
          name_fr: "Maths",
          grade_id: "9eme",
          theme_id: "ecole-tn",
        });
      if (table === "chapters") return mockQuery([{ id: "ch1", title: "Ch1" }]);
      if (table === "exercises")
        return mockQuery([
          { id: "q1", mode: "quiz", chapter_id: "ch1" },
          { id: "e1", mode: "practice", chapter_id: "ch1" },
        ]);
      // attempts must never be queried for an anonymous visitor.
      throw new Error(`unexpected table for anon getSubject: ${table}`);
    });

    const res = await callSubject({ subjectId: "subj-1" });

    expect(res.viewer).toEqual({ level: 0, isPremium: false, hasEntitlement: true });
    expect(res.bestByExercise).toEqual({});
    expect(res.quizPassedByChapter).toEqual({ ch1: false });
    expect(res.exercises).toHaveLength(2);
    // No ACCOUNT-BOUND RPC (best scores / entitlements) runs for an anon caller.
    // Only CONTENT-DERIVED RPCs are allowed: the parcours-anchor resolution (étude
    // 15 lot 7 — the hub's back link works for anonymous visitors too) and recall
    // availability (étude 17, R-9 amendée 2026-07-15 — the locked recall mission
    // rows are discoverable while signed out; the RPC returns eligibility only,
    // unlocked=false for anon).
    const allowedRpcs = new Set(["resolve_subject_parcours", "get_recall_availability"]);
    for (const call of mockRpc.mock.calls) {
      expect(allowedRpcs).toContain(call[0]);
    }
    expect(mockRpc).not.toHaveBeenCalledWith("get_best_scores_by_exercise", expect.anything());
    expect(mockRpc).not.toHaveBeenCalledWith("has_parcours_entitlement", expect.anything());
  });

  it("getExercise (anon): returns content with zero hint charges and no inventory read", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ id: "e1", mode: "practice" });
      if (table === "questions") return mockQuery([{ id: "qq1", prompt: "?", options: [] }]);
      // inventory_items must never be queried for an anonymous visitor.
      throw new Error(`unexpected table for anon getExercise: ${table}`);
    });

    const res = await callExercise({ exerciseId: "11111111-1111-1111-1111-111111111111" });

    expect(res.hintCharges).toBe(0);
    expect(res.questions).toHaveLength(1);
    expect(mockFrom).not.toHaveBeenCalledWith("inventory_items");
  });
});
