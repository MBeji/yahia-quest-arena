// @vitest-environment node
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
      // No chapter_id on this exercise → no comprehension-quiz lookup.
      chapterQuizId: null,
      // No chapter quiz + no grade → the exercise is not quiz-gated.
      quizGated: false,
      unrestricted: false,
      // No correction_video and no chapter → no review video (étude 23 R-6).
      correctionVideo: null,
      // Default variant (étude 17): classic behaviour is unchanged.
      variant: "classic",
    });
  });

  it("resolves the chapter's comprehension quiz id for a gated (non-quiz) exercise", async () => {
    const exerciseData = { id: "ex-1", title: "Ex 1", chapter_id: "ch-1", mode: "practice" };
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") {
        // First call → the exercise itself; the follow-up quiz lookup is also on
        // "exercises" but selects by chapter_id+mode and reads .maybeSingle().
        const chain = mockQuery(exerciseData) as Record<string, unknown>;
        chain.maybeSingle = vi.fn().mockReturnValue({ data: { id: "quiz-1" }, error: null });
        return chain;
      }
      if (table === "questions") return mockQuery([]);
      return mockQuery([]);
    });

    const { getExercise } = await import("@/features/quest");
    const result = (await (getExercise as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: "11111111-1111-1111-1111-111111111111",
    })) as { chapterQuizId: string | null };

    expect(result.chapterQuizId).toBe("quiz-1");
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
    mockFrom.mockReset().mockImplementation(withReveals(() => mockQuery([])));
    mockRpc.mockReset();
  });

  // The gate now lives in the start_exercise_session SECURITY DEFINER RPC; this
  // server fn is a thin wrapper. These tests pin the wrapper contract: it returns
  // the RPC's session row and maps each raised gate signal to its client message.
  // The gate LOGIC itself (premium / quiz / anti-rush) is enforced and covered
  // server-side by the SQL RPC + the live C3 security probes, not by these mocks.
  const EXID = "11111111-1111-1111-1111-111111111111";
  const start = async () => {
    const { startExerciseSession } = await import("@/features/quest");
    return (startExerciseSession as unknown as (d: unknown) => Promise<unknown>)({
      exerciseId: EXID,
    });
  };

  it("returns the session id and started_at from the RPC", async () => {
    mockRpc.mockReturnValue({
      data: [{ session_id: "sess-1", started_at: "2026-06-01T12:00:00Z" }],
      error: null,
    });
    expect(await start()).toEqual({
      sessionId: "sess-1",
      startedAt: "2026-06-01T12:00:00Z",
      revealed: [],
    });
  });

  it("surfaces the premium paywall message on a PARCOURS_LOCKED gate", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "PARCOURS_LOCKED" } });
    await expect(start()).rejects.toThrow(/Parcours premium/);
  });

  it("surfaces the coming-soon message on a PARCOURS_COMING_SOON gate", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "PARCOURS_COMING_SOON" } });
    await expect(start()).rejects.toThrow(/bientôt disponible/);
  });

  it("surfaces the quiz-gate message on a QUIZ_LOCKED gate", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "QUIZ_LOCKED" } });
    await expect(start()).rejects.toThrow(/quiz de compréhension/);
  });

  it("fails closed with a generic message on any other RPC error (no session)", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "deadlock detected" } });
    await expect(start()).rejects.toThrow("Impossible de démarrer la session.");
  });

  it("throws a generic message when the RPC returns no row", async () => {
    mockRpc.mockReturnValue({ data: [], error: null });
    await expect(start()).rejects.toThrow("Impossible de démarrer la session.");
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
    // Three chapters reads: (1) the chapter itself, (2) sibling metadata WITHOUT
    // the lesson body, (3) the id-only set of siblings that have a lesson.
    let calls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "chapters") {
        calls += 1;
        if (calls === 1)
          return mockQuery({ id: "ch-1", title: "C1", subject_id: "s1", lesson_content: "x" });
        if (calls === 2)
          return mockQuery([
            { id: "ch-1", title: "C1", display_order: 1 },
            { id: "ch-2", title: "C2", display_order: 2 },
          ]);
        // Only ch-1 carries a lesson.
        return mockQuery([{ id: "ch-1" }]);
      }
      return mockQuery([]);
    });

    const { getChapterLesson } = await import("@/features/quest");
    const res = (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
      chapterId: CH,
    })) as {
      chapter: { id: string };
      allChapters: Array<{ id: string; hasLesson: boolean }>;
      practiceExerciseId: string | null;
    };

    expect(res.chapter.id).toBe("ch-1");
    expect(res.allChapters).toEqual([
      { id: "ch-1", title: "C1", display_order: 1, hasLesson: true },
      { id: "ch-2", title: "C2", display_order: 2, hasLesson: false },
    ]);
    // No exercises returned for this chapter → no practise CTA target.
    expect(res.practiceExerciseId).toBeNull();
  });

  it("does NOT fetch sibling lesson bodies — only metadata + an id-only has-lesson set", async () => {
    // Regression guard for the over-fetch fix: shipping every sibling's full
    // lesson_content just to compute a boolean was the perf bug. The nav query
    // must select metadata only, and the has-lesson set must filter on (not null
    // AND not empty) without selecting the body.
    const selects: string[] = [];
    let calls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "chapters") {
        calls += 1;
        const q =
          calls === 1
            ? mockQuery({ id: "ch-1", title: "C1", subject_id: "s1", lesson_content: "x" })
            : calls === 2
              ? mockQuery([
                  { id: "ch-1", title: "C1", display_order: 1 },
                  { id: "ch-2", title: "C2", display_order: 2 },
                ])
              : mockQuery([{ id: "ch-1" }]);
        const origSelect = q.select as ReturnType<typeof vi.fn>;
        origSelect.mockImplementation((cols: string) => {
          selects.push(cols);
          return q;
        });
        return q;
      }
      return mockQuery([]);
    });

    const { getChapterLesson } = await import("@/features/quest");
    const res = (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
      chapterId: CH,
    })) as { allChapters: Array<{ id: string; hasLesson: boolean }> };

    // The sibling-nav select (2nd chapters read) must not pull the body.
    expect(selects[1]).not.toContain("lesson_content");
    // The has-lesson probe (3rd read) selects ids only, never the body.
    expect(selects[2]).toBe("id");
    expect(res.allChapters).toEqual([
      { id: "ch-1", title: "C1", display_order: 1, hasLesson: true },
      { id: "ch-2", title: "C2", display_order: 2, hasLesson: false },
    ]);
  });

  it("returns the chapter's first non-quiz exercise as the practise CTA target", async () => {
    let calls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "chapters") {
        calls += 1;
        return calls === 1
          ? mockQuery({ id: "ch-1", title: "C1", subject_id: "s1", lesson_content: "x" })
          : mockQuery([{ id: "ch-1", title: "C1", display_order: 1, lesson_content: "x" }]);
      }
      if (table === "exercises")
        return mockQuery([
          { id: "qz", mode: "quiz", display_order: 1 },
          { id: "ex", mode: "practice", display_order: 2 },
        ]);
      return mockQuery([]);
    });

    const { getChapterLesson } = await import("@/features/quest");
    const res = (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
      chapterId: CH,
    })) as { practiceExerciseId: string | null };

    // The comprehension quiz is the connected gate, not practice → it's skipped.
    expect(res.practiceExerciseId).toBe("ex");
  });

  // The quiz-gate fields added by étude 15 lot 1 (quizExerciseId / quizGated /
  // quizPassed) are covered in the co-located quest-lesson-gate.test.ts —
  // this file is at its max-lines budget.

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
