/**
 * `getSubject` — split out of `quest.test.ts` on 2026-08-10.
 *
 * Not an arbitrary tidy-up: `quest.test.ts` had reached the 750-line `max-lines`
 * ceiling, and adding the L1 regression test below pushed it over. The gate is
 * not the thing to weaken (AGENTS.md, DoD §2), so the file was split along the
 * seam it already had — one server function per file. The mock harness is
 * duplicated because `vi.mock` is hoisted per file and cannot be shared; that is
 * the pattern the sibling `quest-anon.test.ts` already follows.
 */
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
    mockRpc.mockImplementation((fn: string) => {
      if (fn === "get_best_scores_by_exercise") return { data: bestScoresData, error: null };
      return { data: [], error: null };
    });

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
      // Recall availability (étude 17) — empty here: the mocked RPC resolves nothing.
      recall: { eligibleByExercise: {}, unlockedByExercise: {}, bestByExercise: {} },
      // Level anchor (étude 15 lot 7) — null here: the mocked RPC resolves no parcours.
      parcours: null,
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

  // The best-scores RPC rides in the same Promise.all as the content queries
  // (perf audit L1). A rejection there must still degrade to "no best scores"
  // and never take the whole page down with it.
  it("returns empty bestByExercise — and still loads the subject — when bestScores THROWS", async () => {
    const subjectData = { id: "s1", name_fr: "Math" };
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects") return mockQuery(subjectData);
      if (table === "chapters") return mockQuery([]);
      if (table === "exercises") return mockQuery([]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation((fn: string) => {
      if (fn === "get_best_scores_by_exercise") return Promise.reject(new Error("network down"));
      return { data: [], error: null };
    });

    const { getSubject } = await import("@/features/quest");

    const result = (await (getSubject as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "s1",
    })) as Record<string, unknown>;

    expect(result.bestByExercise).toEqual({});
    expect(result.subject).toEqual(subjectData);
  });
});
