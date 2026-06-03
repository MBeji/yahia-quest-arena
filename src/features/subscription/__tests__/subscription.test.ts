import { describe, it, expect, vi, beforeEach } from "vitest";
import { isSubscriptionActive } from "../subscription";

// Pure helper — no mocks needed.
describe("isSubscriptionActive", () => {
  const now = new Date("2026-06-03T00:00:00Z");

  it("is false when there is no expiry", () => {
    expect(isSubscriptionActive(null, now)).toBe(false);
  });

  it("is true when the expiry is in the future", () => {
    expect(isSubscriptionActive("2026-07-03T00:00:00Z", now)).toBe(true);
  });

  it("is false when the expiry has passed (auto-revoke)", () => {
    expect(isSubscriptionActive("2026-05-03T00:00:00Z", now)).toBe(false);
  });

  it("is false for an unparseable date", () => {
    expect(isSubscriptionActive("not-a-date", now)).toBe(false);
  });
});

// ---- Server fns: mock the supabase + auth + logger layers (shop/dungeon pattern) ----
const mockMaybeSingle = vi.fn();
const fromBuilder = {
  select: () => fromBuilder,
  eq: () => fromBuilder,
  maybeSingle: () => mockMaybeSingle(),
};
const mockFrom = vi.fn(() => fromBuilder);
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
const USER_ID = "33333333-3333-3333-3333-333333333333";

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  mockMaybeSingle.mockReset();
  mockFrom.mockClear();
});

describe("subscription — getMySubscription", () => {
  it("maps the profile row and derives isActive from a future expiry", async () => {
    mockMaybeSingle.mockResolvedValue({
      data: {
        subscription_type: "annual",
        subscription_activated_at: "2026-06-01T00:00:00Z",
        subscription_expires_at: "2999-01-01T00:00:00Z",
      },
      error: null,
    });

    const { getMySubscription } = await import("@/features/subscription");
    const res = (await (getMySubscription as unknown as AnyFn)()) as Record<string, unknown>;

    expect(res.type).toBe("annual");
    expect(res.isActive).toBe(true);
  });

  it("returns an inactive null state when there is no profile", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: null });

    const { getMySubscription } = await import("@/features/subscription");
    const res = (await (getMySubscription as unknown as AnyFn)()) as Record<string, unknown>;

    expect(res.type).toBeNull();
    expect(res.isActive).toBe(false);
  });

  it("throws a safe message when the query errors", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: { message: "boom" } });

    const { getMySubscription } = await import("@/features/subscription");
    await expect((getMySubscription as unknown as AnyFn)()).rejects.toThrow(/abonnements/i);
  });
});

describe("subscription — admin server fns", () => {
  it("listSubscriptions maps RPC rows", async () => {
    mockRpc.mockResolvedValue({
      data: [
        {
          user_id: USER_ID,
          display_name: "Yahia",
          email: "y@example.com",
          role: "student",
          subscription_type: "monthly",
          subscription_activated_at: "2026-06-01T00:00:00Z",
          subscription_expires_at: "2026-07-01T00:00:00Z",
          is_active: true,
        },
      ],
      error: null,
    });

    const { listSubscriptions } = await import("@/features/subscription");
    const res = (await (listSubscriptions as unknown as AnyFn)()) as {
      users: Array<Record<string, unknown>>;
    };

    expect(mockRpc).toHaveBeenCalledWith("admin_list_subscriptions");
    expect(res.users[0]).toMatchObject({ userId: USER_ID, type: "monthly", isActive: true });
  });

  it("setSubscription forwards user + plan to the RPC", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { setSubscription } = await import("@/features/subscription");
    await (setSubscription as unknown as AnyFn)({ data: { userId: USER_ID, type: "quarterly" } });

    expect(mockRpc).toHaveBeenCalledWith("admin_set_subscription", {
      p_user: USER_ID,
      p_type: "quarterly",
    });
  });

  it("setSubscription rejects an invalid plan type before hitting the RPC", async () => {
    const { setSubscription } = await import("@/features/subscription");
    await expect(
      (setSubscription as unknown as AnyFn)({ data: { userId: USER_ID, type: "lifetime" } }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("clearSubscription forwards the user to the RPC", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { clearSubscription } = await import("@/features/subscription");
    await (clearSubscription as unknown as AnyFn)({ data: { userId: USER_ID } });

    expect(mockRpc).toHaveBeenCalledWith("admin_clear_subscription", { p_user: USER_ID });
  });

  it("clearSubscription surfaces a safe message on RPC error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "nope" } });

    const { clearSubscription } = await import("@/features/subscription");
    await expect(
      (clearSubscription as unknown as AnyFn)({ data: { userId: USER_ID } }),
    ).rejects.toThrow(/bloquer/i);
  });
});
