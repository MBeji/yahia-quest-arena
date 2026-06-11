import { describe, it, expect, vi, beforeEach } from "vitest";

// These tests exercise the REAL dungeon server fns and their internal payload
// parsers. The server fns are thin wrappers over Supabase RPCs, so we mock the
// rpc + rate-limit + auth-middleware layers (same pattern as shop.test.ts) and
// assert on the parsed return value, rate-limit guards, RPC-error propagation
// (via failWithClientError), and the parser branches.

const mockRpc = vi.fn();
const mockSupabase = { rpc: mockRpc };

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
        const wrapped = async (input: unknown) => {
          // Real TanStack server fns are invoked as fn({ data: payload }); unwrap the
          // envelope so the zod validator sees the raw payload, exactly like prod.
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

// Rate limiter is mocked so each test controls whether the guard trips.
const mockIsRateLimited = vi.fn().mockResolvedValue(false);
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: (...args: unknown[]) => mockIsRateLimited(...args),
}));

// Silence the server-side logger that failWithClientError calls.
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function rpcResponder(map: Record<string, { data: unknown; error: unknown }>) {
  return (fn: string) => map[fn] ?? { data: null, error: null };
}

const RUN_ID = "11111111-1111-1111-1111-111111111111";
const QUESTION_ID = "22222222-2222-2222-2222-222222222222";

type AnyFn = (d?: unknown) => Promise<unknown>;

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  mockIsRateLimited.mockReset();
  mockIsRateLimited.mockResolvedValue(false);
});

describe("dungeon — exported constants", () => {
  it("exposes positive reward constants", async () => {
    const { DUNGEON_XP_PER_FLOOR, DUNGEON_COINS_PER_5_FLOORS } =
      await import("@/features/dungeon/dungeon.server");
    expect(DUNGEON_XP_PER_FLOOR).toBeGreaterThan(0);
    expect(DUNGEON_COINS_PER_5_FLOORS).toBeGreaterThan(0);
  });
});

describe("dungeon — startDungeonRun", () => {
  it("returns the runId from the RPC", async () => {
    mockRpc.mockImplementation(rpcResponder({ start_dungeon_run: { data: RUN_ID, error: null } }));

    const { startDungeonRun } = await import("@/features/dungeon");
    const res = (await (startDungeonRun as unknown as AnyFn)()) as Record<string, unknown>;

    expect(res.runId).toBe(RUN_ID);
    expect(res.currentFloor).toBe(1);
    expect(mockRpc).toHaveBeenCalledWith("start_dungeon_run");
  });

  it("blocks when rate limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);

    const { startDungeonRun } = await import("@/features/dungeon");
    await expect((startDungeonRun as unknown as AnyFn)()).rejects.toThrow(
      /Trop de départs de donjon/i,
    );
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("hides the raw RPC error behind a safe client message", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        start_dungeon_run: { data: null, error: { message: "internal: column foo missing" } },
      }),
    );

    const { startDungeonRun } = await import("@/features/dungeon");
    const err = await (startDungeonRun as unknown as AnyFn)().catch((e: unknown) => e);

    expect(err).toBeInstanceOf(Error);
    expect((err as Error).message).toBe("Impossible de démarrer la course.");
    // The raw RPC message must not leak to the client.
    expect((err as Error).message).not.toMatch(/column foo missing/);
  });

  it("throws when the RPC returns a non-string runId", async () => {
    mockRpc.mockImplementation(rpcResponder({ start_dungeon_run: { data: null, error: null } }));

    const { startDungeonRun } = await import("@/features/dungeon");
    await expect((startDungeonRun as unknown as AnyFn)()).rejects.toThrow(
      /Impossible de démarrer/i,
    );
  });
});

describe("dungeon — getDungeonQuestions (parser branches)", () => {
  it("filters out malformed questions (missing id/prompt or non-object)", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        get_dungeon_questions: {
          data: {
            currentFloor: 3,
            questions: [
              {
                id: "q1",
                prompt: "Valid question",
                options: [{ id: "a", text: "A" }],
                explanation: "because",
                exercises: { difficulty: 2, subject_id: "s1", subjects: { name_fr: "Maths" } },
              },
              { id: "", prompt: "no id" }, // dropped: empty id
              { id: "q3", prompt: "" }, // dropped: empty prompt
              null, // dropped: non-object
              "garbage", // dropped: non-object
            ],
          },
          error: null,
        },
      }),
    );

    const { getDungeonQuestions } = await import("@/features/dungeon");
    const res = (await (getDungeonQuestions as unknown as AnyFn)({
      data: { runId: RUN_ID, batchSize: 5 },
    })) as { currentFloor: number; questions: Array<Record<string, unknown>> };

    expect(res.currentFloor).toBe(3);
    expect(res.questions).toHaveLength(1);
    expect(res.questions[0].id).toBe("q1");
    expect(res.questions[0].options).toEqual([{ id: "a", text: "A" }]);
  });

  it("normalizes missing fields to safe defaults", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        get_dungeon_questions: {
          data: { questions: [{ id: "q1", prompt: "P" }] },
          error: null,
        },
      }),
    );

    const { getDungeonQuestions } = await import("@/features/dungeon");
    const res = (await (getDungeonQuestions as unknown as AnyFn)({
      data: { runId: RUN_ID, batchSize: 5 },
    })) as { currentFloor: number; questions: Array<Record<string, unknown>> };

    expect(res.currentFloor).toBe(1); // defaulted
    expect(res.questions[0].options).toEqual([]);
    expect(res.questions[0].explanation).toBeNull();
    expect(res.questions[0].exercises).toBeUndefined();
  });

  it("throws when the RPC payload is null", async () => {
    mockRpc.mockImplementation(
      rpcResponder({ get_dungeon_questions: { data: null, error: null } }),
    );

    const { getDungeonQuestions } = await import("@/features/dungeon");
    await expect(
      (getDungeonQuestions as unknown as AnyFn)({ data: { runId: RUN_ID, batchSize: 5 } }),
    ).rejects.toThrow(/unexpected dungeon questions response/i);
  });

  it("propagates a safe client message on RPC error", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        get_dungeon_questions: { data: null, error: { message: "db exploded internally" } },
      }),
    );

    const { getDungeonQuestions } = await import("@/features/dungeon");
    const err = await (getDungeonQuestions as unknown as AnyFn)({
      data: { runId: RUN_ID, batchSize: 5 },
    }).catch((e: unknown) => e);

    expect((err as Error).message).toBe("Impossible de charger les questions du donjon.");
    expect((err as Error).message).not.toMatch(/db exploded/);
  });

  it("rejects an invalid runId via the zod validator", async () => {
    const { getDungeonQuestions } = await import("@/features/dungeon");
    await expect(
      (getDungeonQuestions as unknown as AnyFn)({ data: { runId: "not-a-uuid", batchSize: 5 } }),
    ).rejects.toThrow();
  });

  it("blocks when rate limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);

    const { getDungeonQuestions } = await import("@/features/dungeon");
    await expect(
      (getDungeonQuestions as unknown as AnyFn)({ data: { runId: RUN_ID, batchSize: 5 } }),
    ).rejects.toThrow(/Trop de requêtes/i);
  });
});

describe("dungeon — submitDungeonAnswer (parser branches)", () => {
  it("maps a correct-answer payload", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        submit_dungeon_answer: {
          data: {
            isCorrect: true,
            nextFloor: 4,
            floorsCleared: 3,
            totalCorrect: 3,
            totalAnswered: 3,
            correctChoice: "b",
            prompt: "What is 2+2?",
            explanation: "Basic arithmetic",
            runStatus: "active",
          },
          error: null,
        },
      }),
    );

    const { submitDungeonAnswer } = await import("@/features/dungeon");
    const res = (await (submitDungeonAnswer as unknown as AnyFn)({
      data: { runId: RUN_ID, questionId: QUESTION_ID, choice: "b" },
    })) as Record<string, unknown>;

    expect(res.isCorrect).toBe(true);
    expect(res.nextFloor).toBe(4);
    expect(res.correctChoice).toBe("b");
    expect(res.runOver).toBe(false);
  });

  it("sets runOver=true when the run status is failed", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        submit_dungeon_answer: {
          data: { isCorrect: false, runStatus: "failed" },
          error: null,
        },
      }),
    );

    const { submitDungeonAnswer } = await import("@/features/dungeon");
    const res = (await (submitDungeonAnswer as unknown as AnyFn)({
      data: { runId: RUN_ID, questionId: QUESTION_ID, choice: "a" },
    })) as Record<string, unknown>;

    expect(res.isCorrect).toBe(false);
    expect(res.runOver).toBe(true);
    // Defaulted fields:
    expect(res.correctChoice).toBeNull();
    expect(res.prompt).toBe("Question");
    expect(res.explanation).toBeNull();
  });

  it("sets runOver=true when the run status is completed", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        submit_dungeon_answer: {
          data: { isCorrect: true, runStatus: "completed" },
          error: null,
        },
      }),
    );

    const { submitDungeonAnswer } = await import("@/features/dungeon");
    const res = (await (submitDungeonAnswer as unknown as AnyFn)({
      data: { runId: RUN_ID, questionId: QUESTION_ID, choice: "a" },
    })) as Record<string, unknown>;

    expect(res.runOver).toBe(true);
  });

  it("throws when the RPC payload is null", async () => {
    mockRpc.mockImplementation(
      rpcResponder({ submit_dungeon_answer: { data: null, error: null } }),
    );

    const { submitDungeonAnswer } = await import("@/features/dungeon");
    await expect(
      (submitDungeonAnswer as unknown as AnyFn)({
        data: { runId: RUN_ID, questionId: QUESTION_ID, choice: "a" },
      }),
    ).rejects.toThrow(/unexpected dungeon answer response/i);
  });

  it("propagates a safe client message on RPC error", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        submit_dungeon_answer: { data: null, error: { message: "constraint violation xyz" } },
      }),
    );

    const { submitDungeonAnswer } = await import("@/features/dungeon");
    const err = await (submitDungeonAnswer as unknown as AnyFn)({
      data: { runId: RUN_ID, questionId: QUESTION_ID, choice: "a" },
    }).catch((e: unknown) => e);

    expect((err as Error).message).toBe("Impossible de valider la réponse.");
    expect((err as Error).message).not.toMatch(/constraint violation/);
  });

  it("rejects an empty choice via the zod validator", async () => {
    const { submitDungeonAnswer } = await import("@/features/dungeon");
    await expect(
      (submitDungeonAnswer as unknown as AnyFn)({
        data: { runId: RUN_ID, questionId: QUESTION_ID, choice: "" },
      }),
    ).rejects.toThrow();
  });

  it("blocks when rate limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);

    const { submitDungeonAnswer } = await import("@/features/dungeon");
    await expect(
      (submitDungeonAnswer as unknown as AnyFn)({
        data: { runId: RUN_ID, questionId: QUESTION_ID, choice: "a" },
      }),
    ).rejects.toThrow(/Trop de réponses/i);
  });
});

describe("dungeon — submitDungeonRun (finalize parser)", () => {
  it("maps the finalize payload", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        finalize_dungeon_run: {
          data: {
            xpEarned: 90,
            coinsEarned: 5,
            floorsCleared: 6,
            totalCorrect: 6,
            totalAnswered: 7,
            durationSeconds: 42,
          },
          error: null,
        },
      }),
    );

    const { submitDungeonRun } = await import("@/features/dungeon");
    const res = (await (submitDungeonRun as unknown as AnyFn)({
      data: { runId: RUN_ID, durationSeconds: 42 },
    })) as Record<string, unknown>;

    expect(res.xpEarned).toBe(90);
    expect(res.coinsEarned).toBe(5);
    expect(res.floorsCleared).toBe(6);
    expect(res.durationSeconds).toBe(42);
  });

  it("defaults missing finalize fields to zero", async () => {
    mockRpc.mockImplementation(rpcResponder({ finalize_dungeon_run: { data: {}, error: null } }));

    const { submitDungeonRun } = await import("@/features/dungeon");
    const res = (await (submitDungeonRun as unknown as AnyFn)({
      data: { runId: RUN_ID, durationSeconds: 0 },
    })) as Record<string, unknown>;

    expect(res.xpEarned).toBe(0);
    expect(res.coinsEarned).toBe(0);
    expect(res.floorsCleared).toBe(0);
  });

  it("throws when the RPC payload is null", async () => {
    mockRpc.mockImplementation(rpcResponder({ finalize_dungeon_run: { data: null, error: null } }));

    const { submitDungeonRun } = await import("@/features/dungeon");
    await expect(
      (submitDungeonRun as unknown as AnyFn)({ data: { runId: RUN_ID, durationSeconds: 0 } }),
    ).rejects.toThrow(/unexpected dungeon finalization response/i);
  });

  it("propagates a safe client message on RPC error", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        finalize_dungeon_run: { data: null, error: { message: "rollback details" } },
      }),
    );

    const { submitDungeonRun } = await import("@/features/dungeon");
    const err = await (submitDungeonRun as unknown as AnyFn)({
      data: { runId: RUN_ID, durationSeconds: 0 },
    }).catch((e: unknown) => e);

    expect((err as Error).message).toBe("Impossible de finaliser la course.");
    expect((err as Error).message).not.toMatch(/rollback details/);
  });

  it("blocks when rate limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);

    const { submitDungeonRun } = await import("@/features/dungeon");
    await expect(
      (submitDungeonRun as unknown as AnyFn)({ data: { runId: RUN_ID, durationSeconds: 0 } }),
    ).rejects.toThrow(/Trop d'envois/i);
  });
});

describe("dungeon — getDungeonAccess", () => {
  it("maps the access RPC row (remaining = max - today)", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        get_dungeon_access: {
          data: [
            {
              level: 3,
              max_runs_per_day: 3,
              runs_today: 1,
              subjects_done: 2,
              chapters_done: 4,
              required_subjects: 2,
              required_chapters: 3,
              can_access: true,
              reason: "",
            },
          ],
          error: null,
        },
      }),
    );

    const { getDungeonAccess } = await import("@/features/dungeon");
    const res = (await (getDungeonAccess as unknown as AnyFn)()) as Record<string, unknown>;

    expect(mockRpc).toHaveBeenCalledWith("get_dungeon_access");
    expect(res.canAccess).toBe(true);
    expect(res.maxRunsPerDay).toBe(3);
    expect(res.remaining).toBe(2);
  });

  it("reports a locked state with its reason code", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        get_dungeon_access: {
          data: [
            {
              level: 1,
              max_runs_per_day: 1,
              runs_today: 0,
              subjects_done: 1,
              chapters_done: 1,
              required_subjects: 2,
              required_chapters: 3,
              can_access: false,
              reason: "PREREQ",
            },
          ],
          error: null,
        },
      }),
    );

    const { getDungeonAccess } = await import("@/features/dungeon");
    const res = (await (getDungeonAccess as unknown as AnyFn)()) as Record<string, unknown>;

    expect(res.canAccess).toBe(false);
    expect(res.reason).toBe("PREREQ");
  });
});

describe("dungeon — startDungeonRun gate", () => {
  it("surfaces a friendly message when the RPC reports DUNGEON_LOCKED", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        start_dungeon_run: { data: null, error: { message: "DUNGEON_LOCKED:DAILY_LIMIT" } },
      }),
    );

    const { startDungeonRun } = await import("@/features/dungeon");
    await expect((startDungeonRun as unknown as AnyFn)()).rejects.toThrow(
      /Accès au Dungeon refusé/i,
    );
  });
});
