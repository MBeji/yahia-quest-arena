/**
 * FREE vs PREMIUM — END-TO-END SCENARIO SUITE
 * ===========================================
 * Server-fn-level non-regression scenarios for the per-parcours entitlement
 * access model and the "opening missions" flow. Each test chains real server fns
 * (getSubject, getExercise, startExerciseSession, submitAttempt) against the
 * mocked Supabase layer to mimic a realistic student journey through the gating
 * rules:
 *   - the start_exercise_session RPC is server-authoritative for starting a mission
 *     (it wraps the premium resolver resolve_exercise_access + the quiz gate):
 *       PARCOURS_LOCKED → "Parcours premium" (paywall)
 *       PARCOURS_COMING_SOON → "bientôt disponible"; QUIZ_LOCKED → "quiz de compréhension"
 *       success → the created session is returned (free preview or entitled)
 *   - practice/boss locked until the chapter comprehension quiz is passed
 *   - getSubject surfaces the parcours viewer ctx {level, isPremium, hasEntitlement}
 *   - quizzes never leak correct answers (anti-cheat)
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

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
            context: {
              supabase: mockSupabase,
              userId: "user-regression-test",
              claims: { sub: "user-regression-test", user_metadata: { display_name: "Yahia" } },
            },
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
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: vi.fn().mockResolvedValue(false) }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of [
    "select",
    "eq",
    "gt",
    "gte",
    "lte",
    "neq",
    "in",
    "order",
    "limit",
    "insert",
    "update",
    "upsert",
    "delete",
  ]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.then = (resolve: (v: unknown) => unknown) => resolve(result);
  Object.assign(chain, result);
  return chain;
}

// =============================================================================
// END-TO-END SCENARIOS — chain multiple server fns to mimic real journeys.
// Each step re-arms the supabase mock so every call gets a realistic response.
// =============================================================================
const EX = "22222222-2222-2222-2222-222222222222";
const SESS = "11111111-1111-1111-1111-111111111111";
const Q = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
const CH = "33333333-3333-3333-3333-333333333333";
const REQ = "44444444-4444-4444-4444-444444444444";
const U = "55555555-5555-5555-5555-555555555555";

/** Dispatch RPC responses by function name (default ok/empty). */
function rpcByName(map: Record<string, { data?: unknown; error?: unknown }>) {
  return (fn: string) => Promise.resolve(map[fn] ?? { data: null, error: null });
}

type Fn = (d?: unknown) => Promise<unknown>;

// ---------------------------------------------------------------------------
// Shared helpers for arming the mocks per scenario.
// ---------------------------------------------------------------------------

/**
 * Arm getSubject's table calls. getSubject reads, in order:
 *   subjects(single) · chapters(order) · exercises(order) [Promise.all]
 *   then get_best_scores_by_exercise RPC
 *   then attempts(in/gte) for the quiz-passed map (only if quiz exercises exist)
 *   then profiles(maybeSingle) for the level + resolve_subject_parcours RPC; when a
 *   parcours resolves, parcours(maybeSingle, is_premium) + has_parcours_entitlement RPC.
 * Pass parcoursIsPremium to drive the parcours row read for the viewer ctx.
 */
function armGetSubject(opts: {
  subject: Record<string, unknown>;
  chapters?: unknown[];
  exercises?: unknown[];
  passedQuizRows?: unknown[];
  viewerLevel?: number;
  parcoursIsPremium?: boolean;
}) {
  mockFrom.mockImplementation((table: string) => {
    if (table === "subjects") return mockQuery(opts.subject);
    if (table === "chapters") return mockQuery(opts.chapters ?? []);
    if (table === "exercises") return mockQuery(opts.exercises ?? []);
    if (table === "attempts") return mockQuery(opts.passedQuizRows ?? []);
    if (table === "profiles") return mockQuery({ level: opts.viewerLevel ?? 1 });
    if (table === "parcours") return mockQuery({ is_premium: opts.parcoursIsPremium ?? false });
    return mockQuery([]);
  });
}

describe("FREE vs PREMIUM E2E: free user opens a beginner mission", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getSubject → getExercise → startExerciseSession → submitAttempt succeeds for a free/preview mission", async () => {
    const quest = await import("@/features/quest");

    // 1) Browse the (free) subject. No theme → no parcours → not premium.
    armGetSubject({
      subject: { id: "s1", name_fr: "Math", content_language: "fr" },
      chapters: [{ id: CH, title: "Ch1", display_order: 1 }],
      exercises: [{ id: "ex1", title: "Ex1", display_order: 1, mode: "practice", difficulty: 2 }],
    });
    mockRpc.mockImplementation(rpcByName({}));
    const subject = (await (quest.getSubject as unknown as Fn)({ subjectId: "s1" })) as Record<
      string,
      unknown
    >;
    expect(subject).toHaveProperty("exercises");
    expect((subject.viewer as { isPremium: boolean }).isPremium).toBe(false);
    expect((subject.viewer as { hasEntitlement: boolean }).hasEntitlement).toBe(true);

    // 2) Open the exercise.
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises")
        return mockQuery({ id: "ex1", title: "Ex1", mode: "practice", difficulty: 2 });
      if (table === "questions")
        return mockQuery([{ id: Q, prompt: "2+2?", options: [], display_order: 1 }]);
      return mockQuery([]);
    });
    const exercise = (await (quest.getExercise as unknown as Fn)({ exerciseId: EX })) as Record<
      string,
      unknown
    >;
    expect(exercise).toHaveProperty("questions");

    // 3) Start a secure session — the start_exercise_session RPC enforces access +
    //    the quiz gate server-side and returns the created session.
    mockRpc.mockImplementation(
      rpcByName({
        start_exercise_session: {
          data: [{ session_id: "sess1", started_at: "2026-06-03T00:00:00Z" }],
        },
      }),
    );
    const session = (await (quest.startExerciseSession as unknown as Fn)({ exerciseId: EX })) as {
      sessionId: string;
    };
    expect(session.sessionId).toBe("sess1");

    // 4) Submit the attempt → scoring RPC; practice exercise returns full review.
    mockFrom.mockImplementation((table: string) =>
      table === "questions"
        ? mockQuery([{ id: Q, prompt: "2+2?", correct_option: "4", explanation: "x" }])
        : mockQuery({ mode: "practice" }),
    );
    mockRpc.mockImplementation(
      rpcByName({
        ensure_daily_weekly_goals: { data: null },
        // The correction now comes from the get_attempt_review RPC (GAP-020), not a
        // direct client read of questions.correct_option.
        get_attempt_review: {
          data: [{ question_id: Q, prompt: "2+2?", correct_option: "4", explanation: "x" }],
        },
        submit_exercise_attempt: {
          data: {
            correct: 1,
            total: 1,
            scorePct: 100,
            xpEarned: 10,
            coinsEarned: 2,
            durationSeconds: 30,
            profile: null,
            unlockedBadges: [],
          },
        },
      }),
    );
    const result = (await (quest.submitAttempt as unknown as Fn)({
      sessionId: SESS,
      exerciseId: EX,
      answers: [{ questionId: Q, choice: "4" }],
    })) as Record<string, unknown>;
    expect(result.scorePct).toBe(100);
    expect(result.xpEarned).toBe(10);
    expect(result.reviewHidden).toBe(false);
    expect(Array.isArray(result.review)).toBe(true);
    expect((result.review as unknown[]).length).toBe(1);
  });
});

describe("FREE vs PREMIUM E2E: premium-parcours mission gate", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("blocks a FREE user when the start RPC denies the mission (/Parcours premium/)", async () => {
    const { startExerciseSession } = await import("@/features/quest");

    mockRpc.mockImplementation(
      rpcByName({ start_exercise_session: { error: { message: "PARCOURS_LOCKED" } } }),
    );

    await expect((startExerciseSession as unknown as Fn)({ exerciseId: EX })).rejects.toThrow(
      /Parcours premium/,
    );
  });

  it("surfaces /bientôt disponible/ when the parcours is coming soon", async () => {
    const { startExerciseSession } = await import("@/features/quest");

    mockRpc.mockImplementation(
      rpcByName({ start_exercise_session: { error: { message: "PARCOURS_COMING_SOON" } } }),
    );

    await expect((startExerciseSession as unknown as Fn)({ exerciseId: EX })).rejects.toThrow(
      /bientôt disponible/,
    );
  });

  it("allows an entitled user when the start RPC grants access", async () => {
    const { startExerciseSession } = await import("@/features/quest");

    mockRpc.mockImplementation(
      rpcByName({
        start_exercise_session: {
          data: [{ session_id: "sess1", started_at: "2026-06-03T00:00:00Z" }],
        },
      }),
    );

    const session = (await (startExerciseSession as unknown as Fn)({ exerciseId: EX })) as {
      sessionId: string;
    };
    expect(session.sessionId).toBe("sess1");
  });

  it("fails closed (no session) on an unexpected start RPC error", async () => {
    const { startExerciseSession } = await import("@/features/quest");

    mockRpc.mockImplementation(
      rpcByName({ start_exercise_session: { error: { message: "deadlock detected" } } }),
    );

    await expect((startExerciseSession as unknown as Fn)({ exerciseId: EX })).rejects.toThrow(
      "Impossible de démarrer la session.",
    );
  });
});

describe("FREE vs PREMIUM E2E: comprehension-quiz gate", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("blocks practice until the chapter quiz is passed (/quiz de compréhension/), then allows it", async () => {
    const { startExerciseSession } = await import("@/features/quest");

    // 1) Quiz NOT passed → the start RPC raises QUIZ_LOCKED → practice locked.
    mockRpc.mockImplementation(
      rpcByName({ start_exercise_session: { error: { message: "QUIZ_LOCKED" } } }),
    );
    await expect((startExerciseSession as unknown as Fn)({ exerciseId: EX })).rejects.toThrow(
      /quiz de compréhension/,
    );

    // 2) Quiz passed → the RPC returns the created session.
    mockRpc.mockImplementation(
      rpcByName({
        start_exercise_session: {
          data: [{ session_id: "sess1", started_at: "2026-06-03T00:00:00Z" }],
        },
      }),
    );
    const session = (await (startExerciseSession as unknown as Fn)({ exerciseId: EX })) as {
      sessionId: string;
    };
    expect(session.sessionId).toBe("sess1");
  });
});

describe("FREE vs PREMIUM E2E: quiz anti-cheat (no answer leak)", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("submitAttempt on a mode='quiz' exercise hides the review", async () => {
    const { submitAttempt } = await import("@/features/quest");

    mockFrom.mockImplementation((table: string) => {
      if (table === "questions")
        return mockQuery([
          { id: Q, prompt: "Capitale?", correct_option: "Tunis", explanation: "e" },
        ]);
      if (table === "exercises") return mockQuery({ mode: "quiz" });
      return mockQuery([]);
    });
    mockRpc.mockImplementation(
      rpcByName({
        ensure_daily_weekly_goals: { data: null },
        submit_exercise_attempt: {
          data: {
            correct: 1,
            total: 1,
            scorePct: 100,
            xpEarned: 5,
            coinsEarned: 1,
            durationSeconds: 20,
            profile: null,
            unlockedBadges: [],
          },
        },
      }),
    );

    const result = (await (submitAttempt as unknown as Fn)({
      sessionId: SESS,
      exerciseId: EX,
      answers: [{ questionId: Q, choice: "Tunis" }],
    })) as Record<string, unknown>;

    // Score still returned, but the review is empty and flagged hidden — no
    // correct_option / explanation leaks to the client for a quiz.
    expect(result.scorePct).toBe(100);
    expect(result.reviewHidden).toBe(true);
    expect(result.review).toEqual([]);
    expect(JSON.stringify(result)).not.toContain("Tunis");
  });
});

describe("FREE vs PREMIUM E2E: getSubject viewer parcours context", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("reports isPremium=true / hasEntitlement=false for a premium parcours without an entitlement", async () => {
    const { getSubject } = await import("@/features/quest");

    armGetSubject({
      subject: {
        id: "s1",
        name_fr: "Math",
        theme_id: "ecole-tn",
        grade_id: "g9",
        content_language: "fr",
      },
      exercises: [{ id: "ex1", display_order: 1, mode: "practice", difficulty: 1 }],
      viewerLevel: 3,
      parcoursIsPremium: true,
    });
    mockRpc.mockImplementation(
      rpcByName({
        resolve_subject_parcours: { data: "parcours-1" },
        has_parcours_entitlement: { data: false },
      }),
    );

    const subject = (await (getSubject as unknown as Fn)({ subjectId: "s1" })) as {
      viewer: { level: number; isPremium: boolean; hasEntitlement: boolean };
    };
    expect(subject.viewer.isPremium).toBe(true);
    expect(subject.viewer.hasEntitlement).toBe(false);
    expect(subject.viewer.level).toBe(3);
  });

  it("reports hasEntitlement=true for a premium parcours the viewer has unlocked", async () => {
    const { getSubject } = await import("@/features/quest");

    armGetSubject({
      subject: {
        id: "s1",
        name_fr: "Math",
        theme_id: "ecole-tn",
        grade_id: "g9",
        content_language: "fr",
      },
      exercises: [{ id: "ex1", display_order: 1, mode: "practice", difficulty: 1 }],
      viewerLevel: 7,
      parcoursIsPremium: true,
    });
    mockRpc.mockImplementation(
      rpcByName({
        resolve_subject_parcours: { data: "parcours-1" },
        has_parcours_entitlement: { data: true },
      }),
    );

    const subject = (await (getSubject as unknown as Fn)({ subjectId: "s1" })) as {
      viewer: { level: number; isPremium: boolean; hasEntitlement: boolean };
    };
    expect(subject.viewer.isPremium).toBe(true);
    expect(subject.viewer.hasEntitlement).toBe(true);
    expect(subject.viewer.level).toBe(7);
  });

  it("reports isPremium=false / hasEntitlement=true for a free parcours", async () => {
    const { getSubject } = await import("@/features/quest");

    armGetSubject({
      subject: { id: "s1", name_fr: "Math", theme_id: "culture-generale", content_language: "fr" },
      exercises: [{ id: "ex1", display_order: 1, mode: "practice", difficulty: 1 }],
      viewerLevel: 2,
      parcoursIsPremium: false,
    });
    mockRpc.mockImplementation(rpcByName({ resolve_subject_parcours: { data: "parcours-free" } }));

    const subject = (await (getSubject as unknown as Fn)({ subjectId: "s1" })) as {
      viewer: { level: number; isPremium: boolean; hasEntitlement: boolean };
    };
    expect(subject.viewer.isPremium).toBe(false);
    expect(subject.viewer.hasEntitlement).toBe(true);
    expect(subject.viewer.level).toBe(2);
  });
});

// Unused fixtures kept to mirror the canonical harness verbatim.
void REQ;
void U;
