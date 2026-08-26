/**
 * Les trois classements du tableau de bord — global, matières, et le classement
 * d'une matière. Sortis de `dashboard.test.ts` le 2026-08-26 : ce fichier-là
 * mesurait **749 lignes de code pour un plafond de 750** (`max-lines`,
 * `eslint.config.js`), donc le prochain test ajouté au dashboard aurait fait
 * rougir `npm run lint` au pre-push pour une raison sans rapport avec son diff.
 *
 * Le préambule est recopié plutôt que partagé : c'est le motif déjà en place dans
 * ce dossier (24 fichiers, chacun avec ses mocks), et un harnais de mock mis en
 * commun devient vite plus permissif que chacune de ses copies.
 */
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
            context: {
              supabase: mockSupabase,
              userId: "user-123",
              claims: { sub: "user-123", user_metadata: { display_name: "Yahia" } },
            },
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

// ---- Query chain helper ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.gt = vi.fn().mockReturnValue(chain);
  chain.gte = vi.fn().mockReturnValue(chain);
  chain.lte = vi.fn().mockReturnValue(chain);
  chain.is = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue(chain);
  Object.assign(chain, result);
  return chain;
}

describe("gamification.dashboard — getLeaderboard", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns ranked leaderboard with current user via the RLS-safe RPC", async () => {
    // The global board reads through the SECURITY DEFINER `get_global_leaderboard`
    // RPC (not `profiles` directly), so it can see peers despite the "own or linked
    // profiles" RLS policy. The RPC already returns rank + is_me and no peer UUID.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Yahia",
          hero_class: "warrior",
          level: 5,
          xp: 1000,
          current_streak: 7,
          avatar_tier: 3,
          is_me: true,
        },
        {
          rank: 2,
          display_name: "Ali",
          hero_class: "mage",
          level: 3,
          xp: 500,
          current_streak: 3,
          avatar_tier: 1,
          is_me: false,
        },
      ],
      error: null,
    });

    const { getLeaderboard } = await import("@/features/dashboard");
    const result = await (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as {
      leaderboard: Record<string, unknown>[];
      myRank: Record<string, unknown> | null;
    };

    expect(mockRpc).toHaveBeenCalledWith("get_global_leaderboard", {
      p_limit: expect.any(Number),
    });
    expect(res.leaderboard).toHaveLength(2);
    expect(res.myRank).toMatchObject({ rank: 1, isMe: true });

    // SECURITY (P0 S2b): the global leaderboard must not surface any peer UUIDs.
    // `isMe` comes from the RPC; rows are keyed by `rank` on the client.
    expect(res.leaderboard[0]).toMatchObject({ rank: 1, isMe: true });
    expect(res.leaderboard[1]).toMatchObject({ rank: 2, isMe: false });
    for (const row of res.leaderboard) {
      expect(row).not.toHaveProperty("id");
      expect(row).not.toHaveProperty("user_id");
    }
  });

  it("returns my rank even when I fall outside the visible top window", async () => {
    // The RPC always includes the caller's own row (rank > limit) so "my rank" is
    // known; the client list still trims it to the top LEADERBOARD_LIMIT rows.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Top",
          hero_class: "S-Rank",
          level: 10,
          xp: 9999,
          current_streak: 4,
          avatar_tier: 3,
          is_me: false,
        },
        {
          rank: 99,
          display_name: "Me",
          hero_class: "Novice",
          level: 2,
          xp: 50,
          current_streak: 1,
          avatar_tier: 1,
          is_me: true,
        },
      ],
      error: null,
    });

    const { getLeaderboard } = await import("@/features/dashboard");
    const result = (await (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)()) as {
      leaderboard: Record<string, unknown>[];
      myRank: { rank: number; isMe: boolean } | null;
    };

    expect(result.myRank).toMatchObject({ rank: 99, isMe: true });
  });

  it("throws a generic French message on RPC error (#14)", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Leaderboard error" } });

    const { getLeaderboard } = await import("@/features/dashboard");

    await expect(
      (getLeaderboard as unknown as (d?: unknown) => Promise<unknown>)(),
    ).rejects.toThrow(/tableau de bord/i);
  });
});

describe("gamification.dashboard — getLeaderboardSubjects", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns only the active parcours' subjects (school parcours: theme + grade)", async () => {
    const subjects = [{ id: "math-9", name_fr: "Mathématiques", color_token: "subject-math" }];
    const subjectsChain = mockQuery(subjects);
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ current_parcours_id: "concours-9eme" });
      if (table === "parcours") return mockQuery({ theme_id: "ecole-tn", grade_id: "g-9" });
      return subjectsChain;
    });

    const { getLeaderboardSubjects } = await import("@/features/dashboard");
    const result = (await (
      getLeaderboardSubjects as unknown as (d?: unknown) => Promise<unknown>
    )()) as { subjects: unknown[] };

    expect(result.subjects).toEqual(subjects);
    expect(subjectsChain.eq).toHaveBeenCalledWith("theme_id", "ecole-tn");
    expect(subjectsChain.eq).toHaveBeenCalledWith("grade_id", "g-9");
  });

  it("scopes to null-grade subjects for a non-school (exploration) parcours", async () => {
    const subjectsChain = mockQuery([{ id: "cg-fr", name_fr: "Histoire" }]);
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ current_parcours_id: "culture-generale" });
      if (table === "parcours") return mockQuery({ theme_id: "culture-generale", grade_id: null });
      return subjectsChain;
    });

    const { getLeaderboardSubjects } = await import("@/features/dashboard");
    await (getLeaderboardSubjects as unknown as (d?: unknown) => Promise<unknown>)();

    expect(subjectsChain.is).toHaveBeenCalledWith("grade_id", null);
  });

  it("returns an empty list when the student has no active parcours (pre-onboarding)", async () => {
    mockFrom.mockImplementation(() => mockQuery({ current_parcours_id: null }));

    const { getLeaderboardSubjects } = await import("@/features/dashboard");
    const result = (await (
      getLeaderboardSubjects as unknown as (d?: unknown) => Promise<unknown>
    )()) as { subjects: unknown[] };

    expect(result.subjects).toEqual([]);
  });
});

describe("gamification.dashboard — getSubjectLeaderboard", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("maps RPC rows and extracts my rank (subject XP) WITHOUT exposing peer UUIDs", async () => {
    // SECURITY (P0 S2b): the RPC no longer returns peer `user_id`s; the self row
    // is flagged by `is_me`. The mapped output must carry NO `id` field at all.
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Top",
          hero_class: "S-Rank",
          level: 10,
          current_streak: 3,
          avatar_tier: 2,
          subject_xp: 500,
          is_me: false,
        },
        {
          rank: 4,
          display_name: "Yahia",
          hero_class: "Novice",
          level: 3,
          current_streak: 1,
          avatar_tier: 1,
          subject_xp: 120,
          is_me: true,
        },
      ],
      error: null,
    });

    const { getSubjectLeaderboard } = await import("@/features/dashboard");
    const result = (await (getSubjectLeaderboard as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "math",
    })) as {
      leaderboard: Record<string, unknown>[];
      myRank: Record<string, unknown> | null;
    };

    expect(mockRpc).toHaveBeenCalledWith("get_subject_leaderboard", {
      p_subject: "math",
      p_limit: expect.any(Number),
    });
    expect(result.leaderboard).toHaveLength(2);
    expect(result.leaderboard[0]).toMatchObject({ xp: 500, rank: 1, isMe: false });
    expect(result.myRank).toMatchObject({ xp: 120, rank: 4, isMe: true });

    // No row — peer OR self — may carry a raw user id field.
    for (const row of [...result.leaderboard, result.myRank]) {
      expect(row).not.toHaveProperty("id");
      expect(row).not.toHaveProperty("user_id");
    }
  });

  it("throws a friendly error when the RPC fails", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });

    const { getSubjectLeaderboard } = await import("@/features/dashboard");

    await expect(
      (getSubjectLeaderboard as unknown as (d: unknown) => Promise<unknown>)({ subjectId: "math" }),
    ).rejects.toThrow(/tableau de bord/i);
  });
});
