import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

vi.mock("@tanstack/react-start", () => ({
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
          const data = validatorFn ? validatorFn(input) : input;
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

vi.mock("@/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

vi.mock("@/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

const RUN_ID = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
const Q_ID = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";

describe("gamification.dungeon — startDungeonRun", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns run id and initial floor", async () => {
    mockRpc.mockReturnValue({ data: RUN_ID, error: null });

    const { startDungeonRun } = await import("@/lib/gamification.dungeon");
    const result = await (startDungeonRun as unknown as (d?: unknown) => Promise<unknown>)();

    expect(result).toEqual({ runId: RUN_ID, currentFloor: 1 });
  });

  it("throws on RPC error", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "RPC fail" } });

    const { startDungeonRun } = await import("@/lib/gamification.dungeon");

    await expect(
      (startDungeonRun as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow("RPC fail");
  });

  it("throws when run id is empty", async () => {
    mockRpc.mockReturnValue({ data: "", error: null });

    const { startDungeonRun } = await import("@/lib/gamification.dungeon");

    await expect(
      (startDungeonRun as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow("initialization failed");
  });

  it("throws when rate limited", async () => {
    const { isRateLimited } = await import("@/lib/rate-limit");
    vi.mocked(isRateLimited).mockResolvedValueOnce(true);

    const { startDungeonRun } = await import("@/lib/gamification.dungeon");

    await expect(
      (startDungeonRun as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow("Too many dungeon starts");
  });
});

describe("gamification.dungeon — getDungeonQuestions", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns parsed questions with current floor", async () => {
    const rpcPayload = {
      currentFloor: 3,
      questions: [
        { id: Q_ID, prompt: "What is 2+2?", options: ["3", "4", "5"], explanation: "Basic" },
      ],
    };
    mockRpc.mockReturnValue({ data: rpcPayload, error: null });

    const { getDungeonQuestions } = await import("@/lib/gamification.dungeon");
    const result = await (getDungeonQuestions as unknown as (d: unknown) => Promise<unknown>)({
      runId: RUN_ID,
      batchSize: 5,
    });

    const res = result as { currentFloor: number; questions: unknown[] };
    expect(res.currentFloor).toBe(3);
    expect(res.questions).toHaveLength(1);
  });

  it("throws on RPC error", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "DB down" } });

    const { getDungeonQuestions } = await import("@/lib/gamification.dungeon");

    await expect(
      (getDungeonQuestions as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        batchSize: 5,
      }),
    ).rejects.toThrow("DB down");
  });

  it("throws when rate limited", async () => {
    const { isRateLimited } = await import("@/lib/rate-limit");
    vi.mocked(isRateLimited).mockResolvedValueOnce(true);

    const { getDungeonQuestions } = await import("@/lib/gamification.dungeon");

    await expect(
      (getDungeonQuestions as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        batchSize: 5,
      }),
    ).rejects.toThrow("Too many requests");
  });

  it("filters out invalid questions from payload", async () => {
    const rpcPayload = {
      currentFloor: 1,
      questions: [
        { id: Q_ID, prompt: "Valid?", options: ["a"], explanation: null },
        { id: "", prompt: "No ID", options: [], explanation: null },
        { id: "x", prompt: "", options: [], explanation: null },
      ],
    };
    mockRpc.mockReturnValue({ data: rpcPayload, error: null });

    const { getDungeonQuestions } = await import("@/lib/gamification.dungeon");
    const result = await (getDungeonQuestions as unknown as (d: unknown) => Promise<unknown>)({
      runId: RUN_ID,
      batchSize: 5,
    });

    const res = result as { questions: unknown[] };
    expect(res.questions).toHaveLength(1);
  });
});

describe("gamification.dungeon — submitDungeonAnswer", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns parsed answer response", async () => {
    const rpcPayload = {
      isCorrect: true,
      nextFloor: 4,
      floorsCleared: 3,
      totalCorrect: 5,
      totalAnswered: 6,
      correctChoice: "4",
      prompt: "2+2?",
      explanation: "Basic math",
      runStatus: "active",
    };
    mockRpc.mockReturnValue({ data: rpcPayload, error: null });

    const { submitDungeonAnswer } = await import("@/lib/gamification.dungeon");
    const result = await (submitDungeonAnswer as unknown as (d: unknown) => Promise<unknown>)({
      runId: RUN_ID,
      questionId: Q_ID,
      choice: "4",
    });

    const res = result as Record<string, unknown>;
    expect(res.isCorrect).toBe(true);
    expect(res.nextFloor).toBe(4);
    expect(res.floorsCleared).toBe(3);
    expect(res.runOver).toBe(false);
  });

  it("marks run as over when status is failed", async () => {
    const rpcPayload = {
      isCorrect: false,
      nextFloor: 3,
      floorsCleared: 2,
      totalCorrect: 2,
      totalAnswered: 3,
      correctChoice: "b",
      prompt: "Q",
      explanation: null,
      runStatus: "failed",
    };
    mockRpc.mockReturnValue({ data: rpcPayload, error: null });

    const { submitDungeonAnswer } = await import("@/lib/gamification.dungeon");
    const result = await (submitDungeonAnswer as unknown as (d: unknown) => Promise<unknown>)({
      runId: RUN_ID,
      questionId: Q_ID,
      choice: "a",
    });

    const res = result as Record<string, unknown>;
    expect(res.runOver).toBe(true);
    expect(res.isCorrect).toBe(false);
  });

  it("throws on RPC error", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "Answer RPC fail" } });

    const { submitDungeonAnswer } = await import("@/lib/gamification.dungeon");

    await expect(
      (submitDungeonAnswer as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        questionId: Q_ID,
        choice: "a",
      }),
    ).rejects.toThrow("Answer RPC fail");
  });
});

describe("gamification.dungeon — submitDungeonRun", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns finalized dungeon stats", async () => {
    const rpcPayload = {
      xpEarned: 150,
      coinsEarned: 10,
      floorsCleared: 10,
      totalCorrect: 8,
      totalAnswered: 10,
      durationSeconds: 120,
    };
    mockRpc.mockReturnValue({ data: rpcPayload, error: null });

    const { submitDungeonRun } = await import("@/lib/gamification.dungeon");
    const result = await (submitDungeonRun as unknown as (d: unknown) => Promise<unknown>)({
      runId: RUN_ID,
      durationSeconds: 120,
    });

    const res = result as Record<string, unknown>;
    expect(res.xpEarned).toBe(150);
    expect(res.coinsEarned).toBe(10);
    expect(res.floorsCleared).toBe(10);
  });

  it("throws on RPC error", async () => {
    mockRpc.mockReturnValue({ data: null, error: { message: "Finalize fail" } });

    const { submitDungeonRun } = await import("@/lib/gamification.dungeon");

    await expect(
      (submitDungeonRun as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        durationSeconds: 60,
      }),
    ).rejects.toThrow("Finalize fail");
  });

  it("throws when rate limited", async () => {
    const { isRateLimited } = await import("@/lib/rate-limit");
    vi.mocked(isRateLimited).mockResolvedValueOnce(true);

    const { submitDungeonRun } = await import("@/lib/gamification.dungeon");

    await expect(
      (submitDungeonRun as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        durationSeconds: 60,
      }),
    ).rejects.toThrow("Too many submissions");
  });
});

describe("gamification.dungeon — input validation", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("rejects invalid runId for getDungeonQuestions", async () => {
    const { getDungeonQuestions } = await import("@/lib/gamification.dungeon");

    await expect(
      (getDungeonQuestions as unknown as (d: unknown) => Promise<unknown>)({
        runId: "not-uuid",
        batchSize: 5,
      }),
    ).rejects.toThrow();
  });

  it("rejects batchSize above max for getDungeonQuestions", async () => {
    const { getDungeonQuestions } = await import("@/lib/gamification.dungeon");

    await expect(
      (getDungeonQuestions as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        batchSize: 100,
      }),
    ).rejects.toThrow();
  });

  it("rejects empty choice for submitDungeonAnswer", async () => {
    const { submitDungeonAnswer } = await import("@/lib/gamification.dungeon");

    await expect(
      (submitDungeonAnswer as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        questionId: Q_ID,
        choice: "",
      }),
    ).rejects.toThrow();
  });

  it("rejects negative durationSeconds for submitDungeonRun", async () => {
    const { submitDungeonRun } = await import("@/lib/gamification.dungeon");

    await expect(
      (submitDungeonRun as unknown as (d: unknown) => Promise<unknown>)({
        runId: RUN_ID,
        durationSeconds: -1,
      }),
    ).rejects.toThrow();
  });
});
