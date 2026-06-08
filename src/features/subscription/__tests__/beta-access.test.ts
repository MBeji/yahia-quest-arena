import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mock the supabase + auth + logger layers (subscription test pattern) ----
const mockMaybeSingle = vi.fn();
const mockInsert = vi.fn();
const builder = {
  select: () => builder,
  eq: () => builder,
  in: () => builder,
  order: () => builder,
  limit: () => builder,
  maybeSingle: () => mockMaybeSingle(),
  insert: () => mockInsert(),
};
const mockFrom = vi.fn(() => builder);
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
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: {} },
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
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

type AnyFn = (d?: unknown) => Promise<unknown>;

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  mockMaybeSingle.mockReset();
  mockInsert.mockReset();
  mockFrom.mockClear();
});

describe("betaAccess — getMyBetaRequest", () => {
  it("returns null when the user has no request", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: null });
    const { getMyBetaRequest } = await import("@/features/subscription");
    const res = await (getMyBetaRequest as unknown as AnyFn)();
    expect(res).toBeNull();
  });

  it("maps an existing request", async () => {
    mockMaybeSingle.mockResolvedValue({
      data: {
        id: "r1",
        name: "Yahia",
        email: "y@example.com",
        motivation: "I love testing",
        status: "pending",
        created_at: "2026-06-03T00:00:00Z",
        reviewed_at: null,
      },
      error: null,
    });
    const { getMyBetaRequest } = await import("@/features/subscription");
    const res = (await (getMyBetaRequest as unknown as AnyFn)()) as Record<string, unknown>;
    expect(res.status).toBe("pending");
    expect(res.email).toBe("y@example.com");
  });
});

describe("betaAccess — requestBetaAccess", () => {
  it("inserts a pending request when none exists", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: null }); // no existing
    mockInsert.mockResolvedValue({ error: null });
    const { requestBetaAccess } = await import("@/features/subscription");
    const res = (await (requestBetaAccess as unknown as AnyFn)({
      data: { name: "Yahia", email: "y@example.com", motivation: "test" },
    })) as Record<string, unknown>;
    expect(res.status).toBe("pending");
    expect(mockInsert).toHaveBeenCalledTimes(1);
  });

  it("blocks a new request when one is already live", async () => {
    mockMaybeSingle.mockResolvedValue({ data: { status: "pending" }, error: null });
    const { requestBetaAccess } = await import("@/features/subscription");
    await expect(
      (requestBetaAccess as unknown as AnyFn)({
        data: { name: "Yahia", email: "y@example.com" },
      }),
    ).rejects.toThrow(/déjà une demande/i);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("rejects an invalid email", async () => {
    const { requestBetaAccess } = await import("@/features/subscription");
    await expect(
      (requestBetaAccess as unknown as AnyFn)({ data: { name: "Y", email: "not-an-email" } }),
    ).rejects.toBeTruthy();
  });
});

describe("betaAccess — admin fns", () => {
  it("listBetaRequests maps RPC rows", async () => {
    mockRpc.mockResolvedValue({
      data: [
        {
          id: "r1",
          user_id: "u1",
          name: "Yahia",
          email: "y@example.com",
          motivation: null,
          status: "pending",
          created_at: "2026-06-03T00:00:00Z",
          reviewed_at: null,
        },
      ],
      error: null,
    });
    const { listBetaRequests } = await import("@/features/subscription");
    const res = (await (listBetaRequests as unknown as AnyFn)()) as {
      requests: Array<Record<string, unknown>>;
    };
    expect(res.requests).toHaveLength(1);
    expect(res.requests[0].status).toBe("pending");
  });

  it("getPendingBetaCount returns the count", async () => {
    mockRpc.mockResolvedValue({ data: 4, error: null });
    const { getPendingBetaCount } = await import("@/features/subscription");
    const res = (await (getPendingBetaCount as unknown as AnyFn)()) as { count: number };
    expect(res.count).toBe(4);
  });

  it("getPendingBetaCount degrades to 0 on error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Unauthorized" } });
    const { getPendingBetaCount } = await import("@/features/subscription");
    const res = (await (getPendingBetaCount as unknown as AnyFn)()) as { count: number };
    expect(res.count).toBe(0);
  });

  it("reviewBetaRequest reviews then grants a beta entitlement on the current premium parcours", async () => {
    mockRpc.mockResolvedValue({ error: null, data: null });
    // 1) beta_access_requests → user_id, 2) profiles → current_parcours_id.
    mockMaybeSingle
      .mockResolvedValueOnce({ data: { user_id: "beta-user-1" }, error: null })
      .mockResolvedValueOnce({ data: { current_parcours_id: "concours-6eme" }, error: null });

    const { reviewBetaRequest } = await import("@/features/subscription");
    await (reviewBetaRequest as unknown as AnyFn)({
      data: { requestId: "11111111-1111-1111-1111-111111111111", approve: true },
    });

    expect(mockRpc).toHaveBeenNthCalledWith(1, "admin_review_beta_request", {
      p_request: "11111111-1111-1111-1111-111111111111",
      p_approve: true,
    });
    const grantCall = mockRpc.mock.calls.find((c) => c[0] === "admin_grant_parcours");
    expect(grantCall).toBeTruthy();
    const grantArgs = grantCall![1] as Record<string, unknown>;
    expect(grantArgs.p_user).toBe("beta-user-1");
    expect(grantArgs.p_parcours).toBe("concours-6eme");
    expect(grantArgs.p_source).toBe("beta");
    expect(typeof grantArgs.p_expires_at).toBe("string");
  });

  it("reviewBetaRequest defaults the grant to the flagship parcours when current is not premium", async () => {
    mockRpc.mockResolvedValue({ error: null, data: null });
    mockMaybeSingle
      .mockResolvedValueOnce({ data: { user_id: "beta-user-2" }, error: null })
      .mockResolvedValueOnce({ data: { current_parcours_id: "francais" }, error: null });

    const { reviewBetaRequest } = await import("@/features/subscription");
    await (reviewBetaRequest as unknown as AnyFn)({
      data: { requestId: "11111111-1111-1111-1111-111111111111", approve: true },
    });

    const grantCall = mockRpc.mock.calls.find((c) => c[0] === "admin_grant_parcours");
    expect((grantCall![1] as Record<string, unknown>).p_parcours).toBe("concours-9eme");
  });

  it("reviewBetaRequest on rejection only reviews and never grants", async () => {
    mockRpc.mockResolvedValue({ error: null, data: null });

    const { reviewBetaRequest } = await import("@/features/subscription");
    await (reviewBetaRequest as unknown as AnyFn)({
      data: { requestId: "11111111-1111-1111-1111-111111111111", approve: false },
    });

    expect(mockRpc).toHaveBeenCalledTimes(1);
    expect(mockRpc).toHaveBeenCalledWith("admin_review_beta_request", {
      p_request: "11111111-1111-1111-1111-111111111111",
      p_approve: false,
    });
  });
});

describe("betaAccess — error paths", () => {
  const EMAIL = { name: "Y", email: "y@example.com" };

  it("getMyBetaRequest throws a safe message on error", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { getMyBetaRequest } = await import("@/features/subscription");
    await expect((getMyBetaRequest as unknown as AnyFn)()).rejects.toThrow(/demandes/i);
  });

  it("requestBetaAccess throws when the existing-request lookup errors", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { requestBetaAccess } = await import("@/features/subscription");
    await expect((requestBetaAccess as unknown as AnyFn)({ data: EMAIL })).rejects.toThrow(
      /demandes/i,
    );
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("requestBetaAccess throws when the insert fails", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: null });
    mockInsert.mockResolvedValue({ error: { message: "boom" } });
    const { requestBetaAccess } = await import("@/features/subscription");
    await expect((requestBetaAccess as unknown as AnyFn)({ data: EMAIL })).rejects.toThrow(
      /envoyer/i,
    );
  });

  it("listBetaRequests returns [] when the RPC yields null data", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const { listBetaRequests } = await import("@/features/subscription");
    const res = (await (listBetaRequests as unknown as AnyFn)()) as { requests: unknown[] };
    expect(res.requests).toEqual([]);
  });

  it("listBetaRequests throws on RPC error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Unauthorized" } });
    const { listBetaRequests } = await import("@/features/subscription");
    await expect((listBetaRequests as unknown as AnyFn)()).rejects.toBeTruthy();
  });

  it("reviewBetaRequest throws on RPC error", async () => {
    mockRpc.mockResolvedValue({ error: { message: "boom" } });
    const { reviewBetaRequest } = await import("@/features/subscription");
    await expect(
      (reviewBetaRequest as unknown as AnyFn)({
        data: { requestId: "11111111-1111-1111-1111-111111111111", approve: false },
      }),
    ).rejects.toBeTruthy();
  });
});
