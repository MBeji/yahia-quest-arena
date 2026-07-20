/**
 * Cohorte de classe (étude 22, R-23) — `getGradeLeaderboard`.
 *
 * Deux comportements portent tout l'écran : `hasCohort`, qui décide si l'onglet « Ma classe »
 * existe (un parcours libre n'a pas de grade, donc pas de cohorte), et `rankedCount`, qui
 * décide s'il devient l'onglet PAR DÉFAUT (Q-1 : seuil GRADE_TAB_DEFAULT_MIN_RANKED).
 *
 * `rankedCount` mérite ses tests : la RPC ne remonte que le top plus la ligne de l'appelant,
 * donc l'effectif réel doit être minoré à partir de deux indices contradictoires — le nombre
 * de lignes et le rang le plus élevé — dont aucun ne suffit seul.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const { mockRpc, mockFrom } = vi.hoisted(() => ({ mockRpc: vi.fn(), mockFrom: vi.fn() }));
const mockSupabase = { from: mockFrom, rpc: mockRpc };

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
type Board = {
  leaderboard: unknown[];
  myRank: { xp?: number; isMe?: boolean } | null;
  hasCohort: boolean;
  rankedCount: number;
};

/** `profiles.select(...).eq(...).maybeSingle()` — la lecture du grade de l'appelant. */
function mockProfileGrade(gradeId: string | null) {
  mockFrom.mockReturnValue({
    select: () => ({
      eq: () => ({ maybeSingle: async () => ({ data: { current_grade_id: gradeId } }) }),
    }),
  });
}

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

describe("getGradeLeaderboard — cohorte de classe (R-23)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockRpc.mockReset();
    mockFrom.mockReset();
  });

  it("sans grade : aucune cohorte, et la RPC n'est même pas appelée", async () => {
    mockProfileGrade(null);
    const { getGradeLeaderboard } = await import("@/features/dashboard");
    const res = (await (getGradeLeaderboard as unknown as Fn)()) as Board;
    expect(res.hasCohort).toBe(false);
    expect(res.leaderboard).toHaveLength(0);
    expect(res.myRank).toBeNull();
    expect(res.rankedCount).toBe(0);
    // Un parcours libre n'a pas de classe : inutile d'interroger la base pour l'apprendre.
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("avec un grade : la cohorte existe et la ligne de l'appelant est identifiée", async () => {
    mockProfileGrade("g1");
    mockRpc.mockResolvedValue({
      data: [row({ rank: 1, xp: 900 }), row({ rank: 2, xp: 500, is_me: true })],
      error: null,
    });
    const { getGradeLeaderboard } = await import("@/features/dashboard");
    const res = (await (getGradeLeaderboard as unknown as Fn)()) as Board;
    expect(res.hasCohort).toBe(true);
    expect(res.leaderboard).toHaveLength(2);
    expect(res.myRank).toMatchObject({ xp: 500, isMe: true });
  });

  it("cold-start : un élève à 0 XP n'est jamais classé", async () => {
    mockProfileGrade("g1");
    mockRpc.mockResolvedValue({
      data: [row({ rank: 1, xp: 0, is_me: true }), row({ rank: 2, xp: 0 })],
      error: null,
    });
    const { getGradeLeaderboard } = await import("@/features/dashboard");
    const res = (await (getGradeLeaderboard as unknown as Fn)()) as Board;
    expect(res.leaderboard).toHaveLength(0);
    expect(res.myRank).toBeNull();
    expect(res.rankedCount).toBe(0);
  });

  it("compte les classés malgré les ex aequo, que le rang seul masquerait", async () => {
    mockProfileGrade("g1");
    // Douze élèves à égalité : `rank()` leur donne tous le rang 1. Se fier au rang maximal
    // conclurait « 1 classé » et garderait « Global » par défaut à tort.
    mockRpc.mockResolvedValue({
      data: Array.from({ length: 12 }, () => row({ rank: 1, xp: 300 })),
      error: null,
    });
    const { getGradeLeaderboard } = await import("@/features/dashboard");
    const res = (await (getGradeLeaderboard as unknown as Fn)()) as Board;
    expect(res.rankedCount).toBe(12);
  });

  it("compte les classés au-delà du top remonté, que le nombre de lignes masquerait", async () => {
    mockProfileGrade("g1");
    // Trois lignes seulement, mais l'appelant est 42ᵉ : la cohorte compte donc au moins 42
    // classés. Se fier au nombre de lignes conclurait « 3 » et masquerait la profondeur.
    mockRpc.mockResolvedValue({
      data: [
        row({ rank: 1, xp: 900 }),
        row({ rank: 2, xp: 800 }),
        row({ rank: 42, xp: 10, is_me: true }),
      ],
      error: null,
    });
    const { getGradeLeaderboard } = await import("@/features/dashboard");
    const res = (await (getGradeLeaderboard as unknown as Fn)()) as Board;
    expect(res.rankedCount).toBe(42);
  });
});
