import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Server fns: mock the supabase + auth + logger layers (shop/dungeon pattern).
// Premium access is per-parcours now; these admin fns talk to entitlement RPCs only. ----
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
const USER_ID = "33333333-3333-3333-3333-333333333333";

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
});

describe("subscription — admin parcours entitlement fns", () => {
  it("listParcoursEntitlements maps RPC rows snake→camel", async () => {
    mockRpc.mockResolvedValue({
      data: [
        {
          user_id: USER_ID,
          display_name: "Yahia",
          email: "y@example.com",
          parcours_id: "concours-9eme",
          parcours_name: "Préparation Concours 9ème",
          source: "purchase",
          granted_at: "2026-06-01T00:00:00Z",
          expires_at: "2026-09-01T00:00:00Z",
          is_active: true,
        },
      ],
      error: null,
    });

    const { listParcoursEntitlements } = await import("@/features/subscription");
    const res = (await (listParcoursEntitlements as unknown as AnyFn)()) as {
      entitlements: Array<Record<string, unknown>>;
    };

    expect(mockRpc).toHaveBeenCalledWith("admin_list_parcours_entitlements");
    expect(res.entitlements[0]).toMatchObject({
      userId: USER_ID,
      parcoursId: "concours-9eme",
      parcoursName: "Préparation Concours 9ème",
      source: "purchase",
      grantedAt: "2026-06-01T00:00:00Z",
      isActive: true,
    });
  });

  it("listParcoursEntitlements returns [] when the RPC yields null data", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const { listParcoursEntitlements } = await import("@/features/subscription");
    const res = (await (listParcoursEntitlements as unknown as AnyFn)()) as {
      entitlements: unknown[];
    };
    expect(res.entitlements).toEqual([]);
  });

  it("listParcoursEntitlements throws a safe message on RPC error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Unauthorized" } });
    const { listParcoursEntitlements } = await import("@/features/subscription");
    await expect((listParcoursEntitlements as unknown as AnyFn)()).rejects.toThrow(/parcours/i);
  });

  it("grantParcoursEntitlement defaults the source to 'purchase' and grants perpetually", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { grantParcoursEntitlement } = await import("@/features/subscription");
    await (grantParcoursEntitlement as unknown as AnyFn)({
      data: { userId: USER_ID, parcoursId: "concours-9eme" },
    });

    // No expiry passed (perpetual) → p_expires_at omitted.
    expect(mockRpc).toHaveBeenCalledWith("admin_grant_parcours", {
      p_user: USER_ID,
      p_parcours: "concours-9eme",
      p_source: "purchase",
    });
  });

  it("grantParcoursEntitlement converts a months convenience into an expiry", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { grantParcoursEntitlement } = await import("@/features/subscription");
    await (grantParcoursEntitlement as unknown as AnyFn)({
      data: { userId: USER_ID, parcoursId: "concours-6eme", source: "gift", months: 3 },
    });

    expect(mockRpc).toHaveBeenCalledTimes(1);
    const [rpcName, args] = mockRpc.mock.calls[0] as [string, Record<string, unknown>];
    expect(rpcName).toBe("admin_grant_parcours");
    expect(args.p_user).toBe(USER_ID);
    expect(args.p_parcours).toBe("concours-6eme");
    expect(args.p_source).toBe("gift");
    expect(typeof args.p_expires_at).toBe("string");
  });

  it("grantParcoursEntitlement forwards an explicit expiry", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { grantParcoursEntitlement } = await import("@/features/subscription");
    await (grantParcoursEntitlement as unknown as AnyFn)({
      data: {
        userId: USER_ID,
        parcoursId: "concours-9eme",
        source: "beta",
        expiresAt: "2026-12-01T00:00:00.000Z",
      },
    });

    expect(mockRpc).toHaveBeenCalledWith("admin_grant_parcours", {
      p_user: USER_ID,
      p_parcours: "concours-9eme",
      p_source: "beta",
      p_expires_at: "2026-12-01T00:00:00.000Z",
    });
  });

  it("grantParcoursEntitlement rejects an invalid source before hitting the RPC", async () => {
    const { grantParcoursEntitlement } = await import("@/features/subscription");
    await expect(
      (grantParcoursEntitlement as unknown as AnyFn)({
        data: { userId: USER_ID, parcoursId: "concours-9eme", source: "lifetime" },
      }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("grantParcoursEntitlement rejects an empty parcours id", async () => {
    const { grantParcoursEntitlement } = await import("@/features/subscription");
    await expect(
      (grantParcoursEntitlement as unknown as AnyFn)({
        data: { userId: USER_ID, parcoursId: "" },
      }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("grantParcoursEntitlement surfaces a safe message on RPC error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "nope" } });
    const { grantParcoursEntitlement } = await import("@/features/subscription");
    await expect(
      (grantParcoursEntitlement as unknown as AnyFn)({
        data: { userId: USER_ID, parcoursId: "concours-9eme" },
      }),
    ).rejects.toThrow(/parcours/i);
  });

  it("revokeParcoursEntitlement forwards user + parcours to the RPC", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { revokeParcoursEntitlement } = await import("@/features/subscription");
    await (revokeParcoursEntitlement as unknown as AnyFn)({
      data: { userId: USER_ID, parcoursId: "concours-9eme" },
    });

    expect(mockRpc).toHaveBeenCalledWith("admin_revoke_parcours", {
      p_user: USER_ID,
      p_parcours: "concours-9eme",
    });
  });

  it("revokeParcoursEntitlement surfaces a safe message on RPC error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "nope" } });

    const { revokeParcoursEntitlement } = await import("@/features/subscription");
    await expect(
      (revokeParcoursEntitlement as unknown as AnyFn)({
        data: { userId: USER_ID, parcoursId: "concours-9eme" },
      }),
    ).rejects.toThrow(/parcours/i);
  });
});
