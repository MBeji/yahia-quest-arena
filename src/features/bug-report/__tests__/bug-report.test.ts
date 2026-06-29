import { describe, it, expect, vi, beforeEach } from "vitest";

const mockInsert = vi.fn();
const builder = {
  insert: () => mockInsert(),
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

describe("bugReport — reportBug", () => {
  it("inserts an open bug report with the page", async () => {
    mockInsert.mockResolvedValue({ error: null });
    const { reportBug } = await import("@/features/bug-report");
    const res = (await (reportBug as unknown as AnyFn)({
      data: { message: "the dashboard stays blank on load", page: "/dashboard" },
    })) as { ok: boolean };
    expect(res.ok).toBe(true);
    expect(mockInsert).toHaveBeenCalledTimes(1);
  });

  it("rejects when rate-limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    const { reportBug } = await import("@/features/bug-report");
    await expect(
      (reportBug as unknown as AnyFn)({ data: { message: "something is broken here" } }),
    ).rejects.toThrow(/signalements/i);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("rejects a too-short message", async () => {
    const { reportBug } = await import("@/features/bug-report");
    await expect((reportBug as unknown as AnyFn)({ data: { message: "no" } })).rejects.toBeTruthy();
  });

  it("throws a safe message when the insert fails", async () => {
    mockInsert.mockResolvedValue({ error: { message: "db" } });
    const { reportBug } = await import("@/features/bug-report");
    await expect(
      (reportBug as unknown as AnyFn)({ data: { message: "submit button does nothing" } }),
    ).rejects.toThrow(/signalement/i);
  });
});

describe("bugReport — admin fns", () => {
  it("listBugReports maps RPC rows", async () => {
    mockRpc.mockResolvedValue({
      data: [
        {
          id: "b1",
          message: "stuck on quiz",
          page: "/quest/abc",
          status: "open",
          created_at: "2026-06-29T00:00:00Z",
        },
      ],
      error: null,
    });
    const { listBugReports } = await import("@/features/bug-report");
    const res = (await (listBugReports as unknown as AnyFn)()) as {
      reports: Array<{ status: string; page: string | null }>;
    };
    expect(res.reports).toHaveLength(1);
    expect(res.reports[0].page).toBe("/quest/abc");
    expect(res.reports[0].status).toBe("open");
  });

  it("getOpenBugsCount returns the count and degrades to 0 on error", async () => {
    mockRpc.mockResolvedValue({ data: 4, error: null });
    const mod = await import("@/features/bug-report");
    expect(((await (mod.getOpenBugsCount as unknown as AnyFn)()) as { count: number }).count).toBe(
      4,
    );
    vi.resetModules();
    mockRpc.mockResolvedValue({ data: null, error: { message: "Unauthorized" } });
    const mod2 = await import("@/features/bug-report");
    expect(((await (mod2.getOpenBugsCount as unknown as AnyFn)()) as { count: number }).count).toBe(
      0,
    );
  });

  it("resolveBugReport calls the RPC with the chosen status", async () => {
    mockRpc.mockResolvedValue({ error: null });
    const { resolveBugReport } = await import("@/features/bug-report");
    await (resolveBugReport as unknown as AnyFn)({
      data: { reportId: "11111111-1111-1111-1111-111111111111", status: "dismissed" },
    });
    expect(mockRpc).toHaveBeenCalledWith("admin_resolve_bug_report", {
      p_report: "11111111-1111-1111-1111-111111111111",
      p_status: "dismissed",
    });
  });
});
