import { describe, it, expect, vi, beforeEach } from "vitest";

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
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn() },
}));

type AnyFn = (d?: unknown) => Promise<unknown>;
const valid = { endpoint: "https://push.example/abc", p256dh: "key", auth: "auth" };

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
});

describe("notifications.server — savePushSubscription", () => {
  it("calls save_push_subscription with the mapped args", async () => {
    mockRpc.mockResolvedValue({ error: null });
    const { savePushSubscription } = await import("../notifications.server");
    const res = (await (savePushSubscription as unknown as AnyFn)({
      data: { ...valid, userAgent: "UA" },
    })) as { ok: boolean };
    expect(res.ok).toBe(true);
    expect(mockRpc).toHaveBeenCalledWith("save_push_subscription", {
      p_endpoint: valid.endpoint,
      p_p256dh: "key",
      p_auth: "auth",
      p_user_agent: "UA",
    });
  });

  it("rejects a non-URL endpoint (zod)", async () => {
    const { savePushSubscription } = await import("../notifications.server");
    await expect(
      (savePushSubscription as unknown as AnyFn)({ data: { ...valid, endpoint: "not-a-url" } }),
    ).rejects.toBeTruthy();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("throws a safe message when the RPC fails", async () => {
    mockRpc.mockResolvedValue({ error: { message: "db" } });
    const { savePushSubscription } = await import("../notifications.server");
    await expect((savePushSubscription as unknown as AnyFn)({ data: valid })).rejects.toThrow(
      /notification/i,
    );
  });
});

describe("notifications.server — deletePushSubscription", () => {
  it("calls delete_push_subscription with the endpoint", async () => {
    mockRpc.mockResolvedValue({ error: null });
    const { deletePushSubscription } = await import("../notifications.server");
    await (deletePushSubscription as unknown as AnyFn)({ data: { endpoint: valid.endpoint } });
    expect(mockRpc).toHaveBeenCalledWith("delete_push_subscription", {
      p_endpoint: valid.endpoint,
    });
  });

  it("throws a safe message on RPC error", async () => {
    mockRpc.mockResolvedValue({ error: { message: "db" } });
    const { deletePushSubscription } = await import("../notifications.server");
    await expect(
      (deletePushSubscription as unknown as AnyFn)({ data: { endpoint: valid.endpoint } }),
    ).rejects.toThrow(/notification/i);
  });
});
