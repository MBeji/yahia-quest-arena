// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockRpc = vi.fn();
const mockMaybeSingle = vi.fn();
const mockEq = vi.fn(() => ({ maybeSingle: mockMaybeSingle }));
const mockSelect = vi.fn(() => ({ eq: mockEq }));
const mockFrom = vi.fn(() => ({ select: mockSelect }));
const mockSupabase = { rpc: mockRpc, from: mockFrom };
const mockRateLimited = vi.fn(async () => false);
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: mockRateLimited }));

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      validator: (fn: (d: unknown) => unknown) => {
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
  mockMaybeSingle.mockReset();
  mockFrom.mockClear();
  mockEq.mockClear();
  mockRateLimited.mockReset().mockResolvedValue(false);
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

describe("notifications.server — le digest enrichi (étude 08 lot 2)", () => {
  async function load() {
    const mod = await import("../notifications.server");
    return {
      get: mod.getParentDigestPref as unknown as AnyFn,
      set: mod.setParentDigestPref as unknown as AnyFn,
    };
  }

  it("pas de ligne = pas demandé : désactivé par défaut (Q-1)", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: null });
    const { get } = await load();
    expect(await get()).toEqual({ enriched: false });
    expect(mockFrom).toHaveBeenCalledWith("parent_digest_prefs");
    // La lecture est bornée à l'utilisateur de la session, jamais à un id reçu.
    expect(mockEq).toHaveBeenCalledWith("parent_user_id", "user-1");
  });

  it("relit la préférence enregistrée", async () => {
    mockMaybeSingle.mockResolvedValue({ data: { enriched_digest: true }, error: null });
    const { get } = await load();
    expect(await get()).toEqual({ enriched: true });
  });

  it("une lecture en panne échoue proprement", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { get } = await load();
    await expect(get()).rejects.toThrow();
  });

  it("enregistre par la RPC self-scopée — aucun identifiant ne voyage", async () => {
    mockRpc.mockResolvedValue({ error: null });
    const { set } = await load();
    expect(await set({ data: { enabled: true } })).toEqual({ enriched: true });
    expect(mockRpc).toHaveBeenCalledWith("set_parent_digest_pref", { p_enabled: true });
  });

  it("refuse une entrée qui n'est pas un booléen", async () => {
    const { set } = await load();
    await expect(set({ data: { enabled: "yes" } })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("est limité en fréquence, comme l'objectif famille", async () => {
    mockRateLimited.mockResolvedValue(true);
    const { set } = await load();
    await expect(set({ data: { enabled: true } })).rejects.toThrow(/Too many/);
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("une RPC en panne échoue proprement", async () => {
    mockRpc.mockResolvedValue({ error: { message: "boom" } });
    const { set } = await load();
    await expect(set({ data: { enabled: false } })).rejects.toThrow();
  });
});
