// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

// Server fns: mock the supabase + auth + logger layers (the shop/dungeon/subscription
// pattern). `updateDisplayName` writes through PostgREST, not an RPC, so the mock
// builder has to record the full `.update().eq().select().single()` chain — the `.eq`
// in particular is what keeps the statement self-scoped at the call site.
const single = vi.fn();
const select = vi.fn(() => ({ single }));
const eq = vi.fn(() => ({ select }));
const update = vi.fn(() => ({ eq }));
const upsert = vi.fn();
const mockFrom = vi.fn(() => ({ update, upsert }));
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
            context: { supabase: mockSupabase, userId: USER_ID, claims: {} },
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
  // No `vi.resetModules()`: the mocked layers are module-level spies reset right
  // here, so nothing needs a fresh graph — and re-importing the auth barrel per
  // test costs seconds of cold transform, enough to trip the 15 s timeout on a
  // cold CI runner.
  for (const spy of [single, select, eq, update, upsert, mockFrom, mockRpc]) spy.mockClear();
  single.mockResolvedValue({ data: { display_name: "Yahia" }, error: null });
  upsert.mockResolvedValue({ error: null });
  mockRpc.mockResolvedValue({ error: null });
});

describe("updateDisplayName", () => {
  it("writes the pseudo on the caller's own row only", async () => {
    const { updateDisplayName } = await import("@/features/auth");
    const res = await (updateDisplayName as unknown as AnyFn)({
      data: { displayName: "Yahia" },
    });

    expect(mockFrom).toHaveBeenCalledWith("profiles");
    expect(update).toHaveBeenCalledWith({ display_name: "Yahia" });
    // Not what makes the write safe (RLS does) — but a regression that dropped it
    // would turn a self-scoped statement into a table-wide one.
    expect(eq).toHaveBeenCalledWith("id", USER_ID);
    expect(res).toEqual({ displayName: "Yahia" });
  });

  it("persists the trimmed pseudo, and returns what the database holds", async () => {
    single.mockResolvedValue({ data: { display_name: "Yahia" }, error: null });

    const { updateDisplayName } = await import("@/features/auth");
    const res = await (updateDisplayName as unknown as AnyFn)({
      data: { displayName: "   Yahia   " },
    });

    expect(update).toHaveBeenCalledWith({ display_name: "Yahia" });
    expect(res).toEqual({ displayName: "Yahia" });
  });

  it("refuses an invalid pseudo BEFORE touching the database", async () => {
    const { updateDisplayName } = await import("@/features/auth");

    await expect(
      (updateDisplayName as unknown as AnyFn)({ data: { displayName: "  " } }),
    ).rejects.toThrow();
    await expect(
      (updateDisplayName as unknown as AnyFn)({ data: { displayName: "x".repeat(81) } }),
    ).rejects.toThrow();
    await expect(
      (updateDisplayName as unknown as AnyFn)({
        data: { displayName: `Ya${String.fromCharCode(0x202e)}hia` },
      }),
    ).rejects.toThrow();

    expect(mockFrom).not.toHaveBeenCalled();
  });

  it("surfaces a safe message when the write is refused, never the raw error", async () => {
    single.mockResolvedValue({
      data: null,
      error: { message: 'permission denied for column "display_name"', code: "42501" },
    });

    const { updateDisplayName } = await import("@/features/auth");

    await expect(
      (updateDisplayName as unknown as AnyFn)({ data: { displayName: "Yahia" } }),
    ).rejects.toThrow("display_name_update_failed");
  });
});

describe("bootstrapProfile — same rule as the settings screen", () => {
  it("validates the signup pseudo through the shared schema", async () => {
    const { bootstrapProfile } = await import("@/features/auth");

    await (bootstrapProfile as unknown as AnyFn)({
      data: { displayName: "  Yahia  ", role: "student" },
    });
    expect(upsert).toHaveBeenCalledWith(
      { id: USER_ID, display_name: "Yahia" },
      { onConflict: "id" },
    );

    // The drift this guards against: a pseudo signup accepts but settings refuses
    // (or the reverse) would leave a user unable to rename themselves.
    await expect(
      (bootstrapProfile as unknown as AnyFn)({
        data: { displayName: `Ya${String.fromCharCode(0x200b)}hia`, role: "student" },
      }),
    ).rejects.toThrow();
  });
});
