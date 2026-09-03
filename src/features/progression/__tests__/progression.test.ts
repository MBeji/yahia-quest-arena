// @vitest-environment node
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
  // Dates relative to the real clock the server fn reads (getTodayUtc/getYesterdayUtc).
  const TODAY = new Date().toISOString().slice(0, 10);
  const YESTERDAY = new Date(Date.now() - 86_400_000).toISOString().slice(0, 10);
  // Depuis le 2026-09-03 la fenêtre de rachat est BORNÉE (STREAK_RECOVERY_WINDOW_DAYS = 2) :
  // « assez loin pour que la série soit cassée » ne suffit plus, il faut être cassé ET dans la
  // fenêtre. L'ancienne valeur (`2020-01-01`) est désormais le cas EXPIRÉ, testé plus bas.
  const RACHETABLE = new Date(Date.now() - 2 * 86_400_000).toISOString().slice(0, 10);
  const TROP_TARD = "2020-01-01";

  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  function armProfile(profile: Record<string, unknown>) {
    mockFrom.mockImplementation(() => {
      const chain = mockQuery(profile);
      chain.update = vi.fn().mockReturnValue(mockQuery(null));
      return chain;
    });
  }

  it("recovers a broken streak and PRESERVES its pre-break value (not reset to 1)", async () => {
    armProfile({
      id: "user-123",
      yahia_coins: 50,
      current_streak: 10,
      longest_streak: 10,
      last_active_date: RACHETABLE,
    });
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { recoverStreak } = await import("@/features/progression");
    const r = (await (recoverStreak as unknown as () => Promise<unknown>)()) as Record<
      string,
      unknown
    >;
    expect(r.success).toBe(true);
    expect(r.newStreak).toBe(10);
    expect(r.coinsSpent).toBe(15);
    expect(r.remainingCoins).toBe(35);
  });

  it("rejects when the streak was counted today (still active)", async () => {
    armProfile({
      id: "user-123",
      yahia_coins: 50,
      current_streak: 3,
      longest_streak: 7,
      last_active_date: TODAY,
    });

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "streak est actif",
    );
  });

  it("rejects when the streak was counted yesterday (still alive)", async () => {
    armProfile({
      id: "user-123",
      yahia_coins: 50,
      current_streak: 4,
      longest_streak: 7,
      last_active_date: YESTERDAY,
    });

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "streak est actif",
    );
  });

  it("rejects when no previous streak exists", async () => {
    armProfile({
      id: "user-123",
      yahia_coins: 50,
      current_streak: 0,
      longest_streak: 0,
      last_active_date: null,
    });

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "pas encore eu de streak",
    );
  });

  it("rejects when insufficient coins", async () => {
    armProfile({
      id: "user-123",
      yahia_coins: 5,
      current_streak: 7,
      longest_streak: 7,
      last_active_date: RACHETABLE,
    });

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "15 Coins",
    );
  });

  it("rejects when the recovery window has closed (absent too long)", async () => {
    // ⭐ Le trou remonté par le lot 3 de é31 : ce profil PASSAIT — un élève absent
    // depuis des années rachetait pour 15 pièces une série perdue en 2020.
    armProfile({
      id: "user-123",
      yahia_coins: 500,
      current_streak: 30,
      longest_streak: 30,
      last_active_date: TROP_TARD,
    });

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "fenêtre de rachat est passée",
    );
    // Et la dépense n'a PAS eu lieu : un refus qui débite serait pire que le trou.
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("throws on spend_coins RPC error", async () => {
    armProfile({
      id: "user-123",
      yahia_coins: 50,
      current_streak: 7,
      longest_streak: 7,
      last_active_date: RACHETABLE,
    });
    mockRpc.mockResolvedValue({ data: null, error: { message: "Insufficient funds" } });

    const { recoverStreak } = await import("@/features/progression");
    await expect((recoverStreak as unknown as () => Promise<unknown>)()).rejects.toThrow(
      "Insufficient funds",
    );
  });
});
