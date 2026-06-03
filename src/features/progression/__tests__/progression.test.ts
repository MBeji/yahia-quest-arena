import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
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
        const wrapped = async (input: unknown) => {
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
        return wrapped;
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

// ---- Query chain helper ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.lte = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue(chain);
  chain.update = vi.fn().mockReturnValue(chain);
  Object.assign(chain, result);
  return chain;
}

// =============================================================================
// recoverStreak
// =============================================================================
describe("gamification.progression — recoverStreak", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("recovers streak for 15 coins", async () => {
    mockFrom.mockImplementation(() => {
      const chain = mockQuery({
        id: "user-123",
        yahia_coins: 50,
        current_streak: 0,
        longest_streak: 7,
        last_active_date: "2026-05-30",
      });
      chain.update = vi.fn().mockReturnValue(mockQuery(null));
      return chain;
    });
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { recoverStreak } = await import("@/features/progression");
    const result = await (recoverStreak as unknown as () => Promise<unknown>)();

    const r = result as Record<string, unknown>;
    expect(r.success).toBe(true);
    expect(r.newStreak).toBe(1);
    expect(r.coinsSpent).toBe(15);
    expect(r.remainingCoins).toBe(35);
  });

  it("rejects when streak is already active", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({
        id: "user-123",
        yahia_coins: 50,
        current_streak: 3,
        longest_streak: 7,
        last_active_date: "2026-06-01",
      }),
    );

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "streak est actif",
    );
  });

  it("rejects when no previous streak exists", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({
        id: "user-123",
        yahia_coins: 50,
        current_streak: 0,
        longest_streak: 0,
        last_active_date: null,
      }),
    );

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "pas encore eu de streak",
    );
  });

  it("rejects when insufficient coins", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({
        id: "user-123",
        yahia_coins: 5,
        current_streak: 0,
        longest_streak: 7,
        last_active_date: "2026-05-30",
      }),
    );

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "15 XP Coins",
    );
  });

  it("throws on spend_coins RPC error", async () => {
    mockFrom.mockImplementation(() =>
      mockQuery({
        id: "user-123",
        yahia_coins: 50,
        current_streak: 0,
        longest_streak: 7,
        last_active_date: "2026-05-30",
      }),
    );
    mockRpc.mockResolvedValue({ data: null, error: { message: "Insufficient funds" } });

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "Insufficient funds",
    );
  });
});
