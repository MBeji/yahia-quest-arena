/**
 * END-TO-END SCENARIO SUITE — SUBSCRIPTIONS · BETA ACCESS · CONTENT REPORTS
 * ========================================================================
 * Chains server functions together to exercise realistic admin/user journeys
 * for the subscription, beta-access and content-report features against the
 * mocked Supabase layer. Complements the per-function non-regression suites.
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

// Imported reference to the globally-mocked rate-limit gate, so individual
// tests can force it true (mirrors the per-feature suites).
import { isRateLimited } from "@/shared/lib/rate-limit";
const mockIsRateLimited = isRateLimited as unknown as ReturnType<typeof vi.fn>;

beforeEach(() => {
  vi.resetModules();
  capturedHandlers = {};
  mockFrom.mockReset();
  mockRpc.mockReset();
  mockIsRateLimited.mockReset();
  mockIsRateLimited.mockResolvedValue(false);
});

// =============================================================================
// SCENARIO 1 — Beta access end-to-end (user request → admin approval).
// =============================================================================
describe("END-TO-END: beta access lifecycle", () => {
  it("getMyBetaRequest(null) → requestBetaAccess(pending) → listBetaRequests → reviewBetaRequest(approved)", async () => {
    const beta = await import("@/features/subscription/beta-access.server");

    // 1) The user has no existing request yet.
    mockFrom.mockImplementation(() => mockQuery(null));
    const before = await (beta.getMyBetaRequest as unknown as Fn)();
    expect(before).toBeNull();

    // 2) Submit a fresh request — no live request exists, insert succeeds.
    mockFrom.mockImplementation(() => mockQuery(null)); // existing check → none; insert → ok
    const submitted = (await (beta.requestBetaAccess as unknown as Fn)({
      name: "Yahia",
      email: "yahia@example.com",
      motivation: "I want to crush the national exam.",
    })) as { status: string };
    expect(submitted.status).toBe("pending");

    // 3) Admin lists every request and sees the pending one (via RPC).
    mockRpc.mockResolvedValue({
      data: [
        {
          id: REQ,
          name: "Yahia",
          email: "yahia@example.com",
          motivation: "I want to crush the national exam.",
          status: "pending",
          created_at: "2026-06-04T00:00:00Z",
          reviewed_at: null,
        },
      ],
      error: null,
    });
    const listed = (await (beta.listBetaRequests as unknown as Fn)()) as {
      requests: Array<{ id: string; status: string; name: string }>;
    };
    expect(listed.requests).toHaveLength(1);
    expect(listed.requests[0]).toMatchObject({ id: REQ, status: "pending", name: "Yahia" });
    expect(mockRpc).toHaveBeenCalledWith("admin_list_beta_requests");

    // 4) Admin approves the request — RPC invoked with p_approve true.
    mockRpc.mockClear();
    mockRpc.mockResolvedValue({ data: null, error: null });
    const reviewed = (await (beta.reviewBetaRequest as unknown as Fn)({
      requestId: REQ,
      approve: true,
    })) as { ok: boolean };
    expect(reviewed).toEqual({ ok: true });
    expect(mockRpc).toHaveBeenCalledWith("admin_review_beta_request", {
      p_request: REQ,
      p_approve: true,
    });
  });

  it("requestBetaAccess rejects when a live request already exists", async () => {
    const beta = await import("@/features/subscription/beta-access.server");
    // Existing-check returns a pending row → the new submission is refused.
    mockFrom.mockImplementation(() => mockQuery({ status: "pending" }));
    await expect(
      (beta.requestBetaAccess as unknown as Fn)({
        name: "Yahia",
        email: "yahia@example.com",
      }),
    ).rejects.toThrow();
  });
});

// =============================================================================
// SCENARIO 2 — requestBetaAccess input validation / guard branches.
// =============================================================================
describe("END-TO-END: beta access validation", () => {
  it("rejects an empty name (invalid input)", async () => {
    const beta = await import("@/features/subscription/beta-access.server");
    mockFrom.mockImplementation(() => mockQuery(null));
    await expect(
      (beta.requestBetaAccess as unknown as Fn)({ name: "", email: "yahia@example.com" }),
    ).rejects.toThrow();
  });

  it("rejects a malformed email (invalid input)", async () => {
    const beta = await import("@/features/subscription/beta-access.server");
    mockFrom.mockImplementation(() => mockQuery(null));
    await expect(
      (beta.requestBetaAccess as unknown as Fn)({ name: "Yahia", email: "not-an-email" }),
    ).rejects.toThrow();
  });
});

// =============================================================================
// SCENARIO 3 — getPendingBetaCount returns count, degrades to 0 on error.
// =============================================================================
describe("END-TO-END: pending beta count", () => {
  it("returns the count when the admin RPC succeeds", async () => {
    const beta = await import("@/features/subscription/beta-access.server");
    mockRpc.mockImplementation(rpcByName({ admin_pending_beta_count: { data: 7, error: null } }));
    const res = (await (beta.getPendingBetaCount as unknown as Fn)()) as { count: number };
    expect(res.count).toBe(7);
    expect(mockRpc).toHaveBeenCalledWith("admin_pending_beta_count");
  });

  it("degrades to 0 when the RPC errors (non-admin / missing RPC)", async () => {
    const beta = await import("@/features/subscription/beta-access.server");
    mockRpc.mockImplementation(
      rpcByName({ admin_pending_beta_count: { data: null, error: { message: "Unauthorized" } } }),
    );
    const res = (await (beta.getPendingBetaCount as unknown as Fn)()) as { count: number };
    expect(res.count).toBe(0);
  });
});

// =============================================================================
// SCENARIO 4 — Admin subscriptions: list → grant a plan → revoke.
// =============================================================================
describe("END-TO-END: admin subscription management", () => {
  it("listSubscriptions maps rows → setSubscription → clearSubscription (RPCs invoked)", async () => {
    const sub = await import("@/features/subscription/subscription.server");

    // 1) List every user with their subscription state.
    mockRpc.mockImplementation(
      rpcByName({
        admin_list_subscriptions: {
          data: [
            {
              user_id: U,
              display_name: "Student One",
              email: "one@example.com",
              role: "student",
              subscription_type: null,
              subscription_activated_at: null,
              subscription_expires_at: null,
              is_active: false,
            },
          ],
          error: null,
        },
      }),
    );
    const listed = (await (sub.listSubscriptions as unknown as Fn)()) as {
      users: Array<{ userId: string; isActive: boolean; type: string | null }>;
    };
    expect(listed.users).toHaveLength(1);
    expect(listed.users[0]).toMatchObject({ userId: U, isActive: false, type: null });
    expect(mockRpc).toHaveBeenCalledWith("admin_list_subscriptions");

    // 2) Grant an annual plan to that user.
    mockRpc.mockClear();
    mockRpc.mockResolvedValue({ data: null, error: null });
    const granted = (await (sub.setSubscription as unknown as Fn)({
      userId: U,
      type: "annual",
    })) as { ok: boolean };
    expect(granted).toEqual({ ok: true });
    expect(mockRpc).toHaveBeenCalledWith("admin_set_subscription", {
      p_user: U,
      p_type: "annual",
    });

    // 3) Revoke (block) the subscription again.
    mockRpc.mockClear();
    mockRpc.mockResolvedValue({ data: null, error: null });
    const cleared = (await (sub.clearSubscription as unknown as Fn)({ userId: U })) as {
      ok: boolean;
    };
    expect(cleared).toEqual({ ok: true });
    expect(mockRpc).toHaveBeenCalledWith("admin_clear_subscription", { p_user: U });
  });
});

// =============================================================================
// SCENARIO 5 — Content reports: report → list → resolve; count degrades to 0.
// =============================================================================
describe("END-TO-END: content report lifecycle", () => {
  it("reportContentError(open) → listContentReports → resolveContentReport(resolved)", async () => {
    const report = await import("@/features/content-report/content-report.server");

    // 1) Student reports a suspected mistake — inserts an open report.
    mockFrom.mockImplementation(() => mockQuery(null));
    const reported = (await (report.reportContentError as unknown as Fn)({
      exerciseId: EX,
      questionId: Q,
      message: "The expected answer looks wrong here.",
    })) as { ok: boolean };
    expect(reported).toEqual({ ok: true });

    // 2) Admin lists reports (open first) with exercise context.
    mockRpc.mockImplementation(
      rpcByName({
        admin_list_content_reports: {
          data: [
            {
              id: REQ,
              message: "The expected answer looks wrong here.",
              status: "open",
              created_at: "2026-06-04T00:00:00Z",
              exercise_id: EX,
              exercise_title: "Algebra basics",
              subject_id: CH,
              question_id: Q,
            },
          ],
          error: null,
        },
      }),
    );
    const listed = (await (report.listContentReports as unknown as Fn)()) as {
      reports: Array<{ id: string; status: string; exerciseTitle: string | null }>;
    };
    expect(listed.reports).toHaveLength(1);
    expect(listed.reports[0]).toMatchObject({
      id: REQ,
      status: "open",
      exerciseTitle: "Algebra basics",
    });
    expect(mockRpc).toHaveBeenCalledWith("admin_list_content_reports");

    // 3) Admin resolves the report — RPC invoked with the chosen status.
    mockRpc.mockClear();
    mockRpc.mockResolvedValue({ data: null, error: null });
    const resolved = (await (report.resolveContentReport as unknown as Fn)({
      reportId: REQ,
      status: "resolved",
    })) as { ok: boolean };
    expect(resolved).toEqual({ ok: true });
    expect(mockRpc).toHaveBeenCalledWith("admin_resolve_content_report", {
      p_report: REQ,
      p_status: "resolved",
    });
  });

  it("reportContentError rejects when rate-limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    const report = await import("@/features/content-report/content-report.server");
    mockFrom.mockImplementation(() => mockQuery(null));
    await expect(
      (report.reportContentError as unknown as Fn)({
        exerciseId: EX,
        message: "Another quick report.",
      }),
    ).rejects.toThrow(/Trop de signalements/);
  });

  it("reportContentError rejects a too-short message (invalid input)", async () => {
    const report = await import("@/features/content-report/content-report.server");
    mockFrom.mockImplementation(() => mockQuery(null));
    await expect(
      (report.reportContentError as unknown as Fn)({ exerciseId: EX, message: "no" }),
    ).rejects.toThrow();
  });

  it("getOpenReportsCount returns the count, degrades to 0 on error", async () => {
    const report = await import("@/features/content-report/content-report.server");

    mockRpc.mockImplementation(rpcByName({ admin_open_reports_count: { data: 3, error: null } }));
    const ok = (await (report.getOpenReportsCount as unknown as Fn)()) as { count: number };
    expect(ok.count).toBe(3);
    expect(mockRpc).toHaveBeenCalledWith("admin_open_reports_count");

    mockRpc.mockImplementation(
      rpcByName({ admin_open_reports_count: { data: null, error: { message: "boom" } } }),
    );
    const degraded = (await (report.getOpenReportsCount as unknown as Fn)()) as { count: number };
    expect(degraded.count).toBe(0);
  });
});

// =============================================================================
// SCENARIO 6 — Unauthorized admin path is surfaced as an error (no hang).
// =============================================================================
describe("END-TO-END: unauthorized admin RPC is surfaced", () => {
  it("listSubscriptions throws when the RPC reports Unauthorized", async () => {
    const sub = await import("@/features/subscription/subscription.server");
    mockRpc.mockImplementation(
      rpcByName({
        admin_list_subscriptions: { data: null, error: { message: "Unauthorized" } },
      }),
    );
    await expect((sub.listSubscriptions as unknown as Fn)()).rejects.toThrow();
  });

  it("reviewBetaRequest throws when the RPC reports Unauthorized", async () => {
    const beta = await import("@/features/subscription/beta-access.server");
    mockRpc.mockImplementation(
      rpcByName({
        admin_review_beta_request: { data: null, error: { message: "Unauthorized" } },
      }),
    );
    await expect(
      (beta.reviewBetaRequest as unknown as Fn)({ requestId: REQ, approve: true }),
    ).rejects.toThrow();
  });

  it("resolveContentReport throws when the RPC reports Unauthorized", async () => {
    const report = await import("@/features/content-report/content-report.server");
    mockRpc.mockImplementation(
      rpcByName({
        admin_resolve_content_report: { data: null, error: { message: "Unauthorized" } },
      }),
    );
    await expect(
      (report.resolveContentReport as unknown as Fn)({ reportId: REQ, status: "dismissed" }),
    ).rejects.toThrow();
  });
});
