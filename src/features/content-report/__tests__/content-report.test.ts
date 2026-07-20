import { describe, it, expect, vi, beforeEach } from "vitest";

const mockInsert = vi.fn();
const builder = {
  insert: (row: unknown) => mockInsert(row),
  select: () => builder,
  eq: () => builder,
};
const mockFrom = vi.fn(() => builder);
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };
const mockIsRateLimited = vi.fn().mockResolvedValue(false);

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
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: "user-1" } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: () => mockIsRateLimited() }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

type AnyFn = (d?: unknown) => Promise<unknown>;

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  mockInsert.mockReset();
  mockFrom.mockClear();
  mockIsRateLimited.mockResolvedValue(false);
});

describe("contentReport — reportContentError", () => {
  it("inserts an open report", async () => {
    mockInsert.mockResolvedValue({ error: null });
    const { reportContentError } = await import("@/features/content-report");
    const res = (await (reportContentError as unknown as AnyFn)({
      data: { exerciseId: "11111111-1111-1111-1111-111111111111", message: "wrong answer key" },
    })) as { ok: boolean };
    expect(res.ok).toBe(true);
    expect(mockInsert).toHaveBeenCalledTimes(1);
  });

  // Étude 20 Q-3 — le lot 1 se contente de rendre le « refus contesté »
  // DISTINGUABLE (US-5) ; la file admin dédiée est le lot 6.
  it("defaults kind to content_error, so existing callers are unchanged", async () => {
    mockInsert.mockResolvedValue({ error: null });
    const { reportContentError } = await import("@/features/content-report");
    await (reportContentError as unknown as AnyFn)({ data: { message: "wrong answer key" } });
    expect(mockInsert).toHaveBeenCalledWith(expect.objectContaining({ kind: "content_error" }));
  });

  it("accepts a recall_false_negative report", async () => {
    mockInsert.mockResolvedValue({ error: null });
    const { reportContentError } = await import("@/features/content-report");
    const res = (await (reportContentError as unknown as AnyFn)({
      data: {
        questionId: "22222222-2222-2222-2222-222222222222",
        message: "j'ai écrit « فوق الشجرة » et c'était juste",
        kind: "recall_false_negative",
      },
    })) as { ok: boolean };
    expect(res.ok).toBe(true);
    expect(mockInsert).toHaveBeenCalledWith(
      expect.objectContaining({ kind: "recall_false_negative", status: "open" }),
    );
  });

  it("rejects an unknown kind (the enum is closed, mirroring the CHECK)", async () => {
    const { reportContentError } = await import("@/features/content-report");
    await expect(
      (reportContentError as unknown as AnyFn)({
        data: { message: "message assez long", kind: "invented_kind" },
      }),
    ).rejects.toBeTruthy();
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("rejects when rate-limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    const { reportContentError } = await import("@/features/content-report");
    await expect(
      (reportContentError as unknown as AnyFn)({ data: { message: "something is off here" } }),
    ).rejects.toThrow(/signalements/i);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("rejects a too-short message", async () => {
    const { reportContentError } = await import("@/features/content-report");
    await expect(
      (reportContentError as unknown as AnyFn)({ data: { message: "no" } }),
    ).rejects.toBeTruthy();
  });

  it("throws a safe message when the insert fails", async () => {
    mockInsert.mockResolvedValue({ error: { message: "db" } });
    const { reportContentError } = await import("@/features/content-report");
    await expect(
      (reportContentError as unknown as AnyFn)({ data: { message: "the answer to Q3 is wrong" } }),
    ).rejects.toThrow(/signalement/i);
  });
});

describe("contentReport — admin fns", () => {
  it("listContentReports maps RPC rows", async () => {
    mockRpc.mockResolvedValue({
      data: [
        {
          id: "r1",
          message: "wrong",
          status: "open",
          created_at: "2026-06-03T00:00:00Z",
          exercise_id: "e1",
          exercise_title: "Exo 1",
          subject_id: "math",
          question_id: null,
        },
      ],
      error: null,
    });
    const { listContentReports } = await import("@/features/content-report");
    const res = (await (listContentReports as unknown as AnyFn)()) as {
      reports: Array<{ status: string; exerciseTitle: string | null }>;
    };
    expect(res.reports).toHaveLength(1);
    expect(res.reports[0].exerciseTitle).toBe("Exo 1");
  });

  it("getOpenReportsCount returns the count and degrades to 0 on error", async () => {
    mockRpc.mockResolvedValue({ data: 3, error: null });
    const mod = await import("@/features/content-report");
    expect(
      ((await (mod.getOpenReportsCount as unknown as AnyFn)()) as { count: number }).count,
    ).toBe(3);
    vi.resetModules();
    mockRpc.mockResolvedValue({ data: null, error: { message: "Unauthorized" } });
    const mod2 = await import("@/features/content-report");
    expect(
      ((await (mod2.getOpenReportsCount as unknown as AnyFn)()) as { count: number }).count,
    ).toBe(0);
  });

  it("resolveContentReport calls the RPC with the chosen status", async () => {
    mockRpc.mockResolvedValue({ error: null });
    const { resolveContentReport } = await import("@/features/content-report");
    await (resolveContentReport as unknown as AnyFn)({
      data: { reportId: "11111111-1111-1111-1111-111111111111", status: "resolved" },
    });
    expect(mockRpc).toHaveBeenCalledWith("admin_resolve_content_report", {
      p_report: "11111111-1111-1111-1111-111111111111",
      p_status: "resolved",
    });
  });
});
