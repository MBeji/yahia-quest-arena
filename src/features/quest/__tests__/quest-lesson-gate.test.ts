import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * getChapterLesson quiz-gate affordance (étude 15, lot 1 — audit §D-4): the
 * reader CTA needs the chapter's quiz id, whether the gate applies (school
 * subjects only) and, signed-in, whether THIS user already passed (score AND
 * not rushed — the same rule as getSubject). Split from quest.test.ts, which
 * sits at its max-lines budget; same self-contained mock harness.
 */

// ---- Mocks (same shape as quest.test.ts) ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
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
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
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

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.in = vi.fn().mockReturnValue(chain);
  chain.gte = vi.fn().mockReturnValue(chain);
  chain.not = vi.fn().mockReturnValue(chain);
  chain.neq = vi.fn().mockReturnValue(chain);
  chain.then = (fn: (v: unknown) => unknown) => fn(result);
  Object.assign(chain, result);
  return chain;
}

/** chapters reads: (1) the chapter row, then sibling metadata / has-lesson sets. */
function mockChapterWorld({
  gradeId,
  exercises,
  attempts = [],
}: {
  gradeId: string | null;
  exercises: Array<{ id: string; mode: string; display_order: number }>;
  attempts?: Array<{ duration_seconds: number; total_count: number }>;
}) {
  let calls = 0;
  mockFrom.mockImplementation((table: string) => {
    if (table === "chapters") {
      calls += 1;
      return calls === 1
        ? mockQuery({
            id: "ch-1",
            title: "C1",
            subject_id: "s1",
            lesson_content: "x",
            subjects: { id: "s1", name_fr: "Maths", grade_id: gradeId },
          })
        : mockQuery([{ id: "ch-1", title: "C1", display_order: 1, lesson_content: "x" }]);
    }
    if (table === "exercises") return mockQuery(exercises);
    if (table === "attempts") return mockQuery(attempts);
    return mockQuery([]);
  });
}

type LessonGateResult = {
  quizExerciseId: string | null;
  quizGated: boolean;
  quizPassed: boolean | null;
};

const CH = "11111111-1111-1111-1111-111111111111";

async function callGetChapterLesson(): Promise<LessonGateResult> {
  const { getChapterLesson } = await import("@/features/quest");
  return (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
    chapterId: CH,
  })) as LessonGateResult;
}

describe("gamification.quest — getChapterLesson quiz gate (étude 15, lot 1)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("surfaces the quiz id + gate and the signed-in pass state (score AND not rushed)", async () => {
    mockChapterWorld({
      gradeId: "g-9eme",
      exercises: [
        { id: "qz", mode: "quiz", display_order: 1 },
        { id: "ex", mode: "practice", display_order: 2 },
      ],
      // Passing attempt, not rushed (40s ≥ 5 questions × 4s) → gate already open.
      attempts: [{ duration_seconds: 40, total_count: 5 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizExerciseId).toBe("qz");
    expect(res.quizGated).toBe(true);
    expect(res.quizPassed).toBe(true);
  });

  it("treats a rushed passing attempt as NOT passed (mirrors the connected gate)", async () => {
    mockChapterWorld({
      gradeId: "g-9eme",
      exercises: [{ id: "qz", mode: "quiz", display_order: 1 }],
      // Score reached but rushed: 8s for 5 questions < the 20s floor.
      attempts: [{ duration_seconds: 8, total_count: 5 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizGated).toBe(true);
    expect(res.quizPassed).toBe(false);
  });

  it("never gates non-school chapters (no grade): quiz surfaced but open, pass state null", async () => {
    mockChapterWorld({
      gradeId: null,
      exercises: [{ id: "qz", mode: "quiz", display_order: 1 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizExerciseId).toBe("qz");
    expect(res.quizGated).toBe(false);
    expect(res.quizPassed).toBeNull();
  });

  it("reports no quiz target at all for a chapter without a quiz exercise", async () => {
    mockChapterWorld({
      gradeId: "g-9eme",
      exercises: [{ id: "ex", mode: "practice", display_order: 1 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizExerciseId).toBeNull();
    expect(res.quizGated).toBe(false);
    expect(res.quizPassed).toBeNull();
  });
});
