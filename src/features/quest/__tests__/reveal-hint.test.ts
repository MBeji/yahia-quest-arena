import { describe, it, expect, vi, beforeEach } from "vitest";

// revealHint is a thin wrapper over the consume_hint SECURITY DEFINER RPC, so we
// mock supabase.rpc and assert the server fn surfaces the hint / errors.

const mockFrom = vi.fn();
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
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
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

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

const QUESTION_ID = "22222222-2222-2222-2222-222222222222";

function rpcResponder(map: Record<string, { data: unknown; error: unknown }>) {
  return (fn: string) => map[fn] ?? { data: null, error: null };
}

describe("quest — revealHint", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("surfaces the hint text returned by consume_hint", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        consume_hint: {
          data: {
            questionId: QUESTION_ID,
            hint: "Pense au théorème de Pythagore.",
            consumed: true,
            itemCode: "booster_hint",
            itemName: "Indice Mystique",
          },
          error: null,
        },
      }),
    );

    const { revealHint } = await import("@/features/quest");
    const res = (await (revealHint as unknown as (d: unknown) => Promise<unknown>)({
      questionId: QUESTION_ID,
    })) as Record<string, unknown>;

    expect(res.questionId).toBe(QUESTION_ID);
    expect(res.hint).toBe("Pense au théorème de Pythagore.");
    expect(res.consumed).toBe(true);
    expect(res.itemCode).toBe("booster_hint");
    expect(mockRpc).toHaveBeenCalledWith("consume_hint", { p_question_id: QUESTION_ID });
  });

  it("reports consumed=false (no charge spent) when the question has no explanation", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        consume_hint: {
          data: {
            questionId: QUESTION_ID,
            hint: null,
            consumed: false,
            itemCode: null,
            itemName: null,
          },
          error: null,
        },
      }),
    );

    const { revealHint } = await import("@/features/quest");
    const res = (await (revealHint as unknown as (d: unknown) => Promise<unknown>)({
      questionId: QUESTION_ID,
    })) as Record<string, unknown>;

    expect(res.hint).toBeNull();
    expect(res.consumed).toBe(false);
  });

  it("surfaces the RPC error when the user has 0 hint charges", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        consume_hint: { data: null, error: { message: "No hint charge available." } },
      }),
    );

    const { revealHint } = await import("@/features/quest");
    await expect(
      (revealHint as unknown as (d: unknown) => Promise<unknown>)({ questionId: QUESTION_ID }),
    ).rejects.toThrow("Impossible de révéler un indice.");
  });

  it("falls back to safe defaults when the RPC returns no payload", async () => {
    mockRpc.mockImplementation(rpcResponder({ consume_hint: { data: null, error: null } }));

    const { revealHint } = await import("@/features/quest");
    const res = (await (revealHint as unknown as (d: unknown) => Promise<unknown>)({
      questionId: QUESTION_ID,
    })) as Record<string, unknown>;

    expect(res.questionId).toBe(QUESTION_ID); // falls back to the requested id
    expect(res.hint).toBeNull();
    expect(res.consumed).toBe(false);
    expect(res.itemCode).toBe("");
  });

  it("rejects a non-uuid questionId (input validation)", async () => {
    const { revealHint } = await import("@/features/quest");
    await expect(
      (revealHint as unknown as (d: unknown) => Promise<unknown>)({ questionId: "nope" }),
    ).rejects.toThrow();
  });
});
