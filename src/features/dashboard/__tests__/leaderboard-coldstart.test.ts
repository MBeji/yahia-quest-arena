/**
 * Leaderboard cold-start (étude 15 lot 11, D-7): the global board must never surface
 * a rank without XP — a brand-new 0-XP player is neither a « fictitious #1 » nor told
 * they rank Nth. They appear only once they've earned their first XP.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const { mockRpc } = vi.hoisted(() => ({ mockRpc: vi.fn() }));
const mockSupabase = { from: vi.fn(), rpc: mockRpc };

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async (input: unknown) =>
          handlerFn({ data: input, context: { supabase: mockSupabase, userId: "u1" } });
      },
    };
    return chain;
  },
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({ requireSupabaseAuth: "mw" }));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mw-opt",
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

type Fn = (d?: unknown) => Promise<unknown>;
type Board = { leaderboard: unknown[]; myRank: { xp?: number; isMe?: boolean } | null };
const row = (over: Record<string, unknown>) => ({
  rank: 1,
  display_name: "X",
  hero_class: "N",
  level: 1,
  xp: 100,
  current_streak: 0,
  avatar_tier: 0,
  is_me: false,
  ...over,
});

describe("getLeaderboard — cold-start (D-7)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockRpc.mockReset();
  });

  it("never surfaces a rank without XP (no fictitious #1, no hollow self-rank)", async () => {
    mockRpc.mockResolvedValue({
      data: [row({ rank: 1, xp: 0, is_me: true }), row({ rank: 2, xp: 0 })],
      error: null,
    });
    const { getLeaderboard } = await import("@/features/dashboard");
    const res = (await (getLeaderboard as unknown as Fn)()) as Board;
    expect(res.leaderboard).toHaveLength(0);
    expect(res.myRank).toBeNull();
  });

  it("keeps players once they have XP, including my own row", async () => {
    mockRpc.mockResolvedValue({
      data: [row({ rank: 1, xp: 500 }), row({ rank: 2, xp: 50, is_me: true })],
      error: null,
    });
    const { getLeaderboard } = await import("@/features/dashboard");
    const res = (await (getLeaderboard as unknown as Fn)()) as Board;
    expect(res.leaderboard).toHaveLength(2);
    expect(res.myRank).toMatchObject({ xp: 50, isMe: true });
  });
});
