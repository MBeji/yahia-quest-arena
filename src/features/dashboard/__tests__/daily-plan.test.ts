/**
 * « Révision du jour » côté serveur — étude 04, lot A1.1 (R-18/D-8 de l'étude 22).
 *
 * Le point sensible de ce lot n'est pas la RPC (le pgTAP la couvre) : c'est la COUTURE. Le
 * plan devait remplacer la source de la priorité 1 du moteur de « prochaine action » sans
 * toucher au moteur, et sans ouvrir un second chemin de décision. Ces tests vérifient donc
 * trois choses et rien d'autre :
 *
 *   1. la tête du plan devient la révision due que le moteur promeut (`kind: "review"`) ;
 *   2. le plan complet part au client pour le panneau — une seule lecture pour deux surfaces ;
 *   3. la requête directe sur `spaced_repetition_schedule` a bien disparu (sans quoi deux
 *      sources coexisteraient et pourraient diverger).
 *
 * Harnais de mocks identique à `dashboard-parcours.test.ts`.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockFrom = vi.fn();
const mockRpc = vi.fn();
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
        return async () =>
          handlerFn({
            context: {
              supabase: mockSupabase,
              userId: "user-123",
              claims: { sub: "user-123", user_metadata: { display_name: "Yahia" } },
            },
          });
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));
const warn = vi.fn();
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn, info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of ["select", "eq", "gt", "gte", "lte", "order", "limit", "insert"]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  Object.assign(chain, result);
  return chain;
}

const PLAN_ROW = {
  exercise_id: "ex-fractions",
  chapter_id: "chap-fractions",
  subject_id: "math",
  exercise_title: "Additionner des fractions",
  chapter_title: "Fractions",
  days_overdue: 12,
  weak_tags: 2,
  is_fallback: false,
};

type Fn = (d?: unknown) => Promise<unknown>;

/** Réponses RPC par nom ; tout le reste rend vide (le tableau de bord dégrade en douceur). */
function rpcWith(plan: unknown, planError: unknown = null) {
  return (fn: string) =>
    fn === "get_daily_plan"
      ? Promise.resolve({ data: plan, error: planError })
      : Promise.resolve({ data: [], error: null });
}

describe("getDashboard — « Révision du jour » (étude 04, A1.1)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
    warn.mockReset();
    mockFrom.mockImplementation(() => mockQuery([]));
  });

  it("fait de la tête du plan la priorité 1 du moteur de prochaine action (R-18)", async () => {
    mockRpc.mockImplementation(rpcWith([PLAN_ROW, { ...PLAN_ROW, exercise_id: "ex-second" }]));

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    // Le moteur n'a pas changé : il reçoit juste une meilleure source. Le plan étant déjà
    // trié par urgence, sa tête EST la révision à promouvoir.
    expect(res.nextAction).toEqual({ kind: "review", exerciseId: "ex-fractions" });
  });

  it("demande au serveur le plafond R-4, et rend le plan entier au client", async () => {
    mockRpc.mockImplementation(rpcWith([PLAN_ROW]));

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    expect(mockRpc).toHaveBeenCalledWith("get_daily_plan", { p_limit: 3 });
    // Une seule lecture sert la bande focus ET le panneau (D-8) : le plan voyage en entier.
    expect(res.dailyPlan).toEqual([PLAN_ROW]);
  });

  it("ne lit plus `spaced_repetition_schedule` en direct — la RPC est la source unique", async () => {
    mockRpc.mockImplementation(rpcWith([PLAN_ROW]));

    const { getDashboard } = await import("@/features/dashboard");
    await (getDashboard as unknown as Fn)();

    // Deux sources de « ce qui est dû » finiraient par diverger : c'est précisément ce que
    // D-8 interdit. La requête directe du lot 6 de l'étude 22 doit avoir disparu.
    const tables = mockFrom.mock.calls.map((c) => c[0]);
    expect(tables).not.toContain("spaced_repetition_schedule");
  });

  it("sans rien à réviser, le moteur passe à la priorité suivante", async () => {
    mockRpc.mockImplementation(rpcWith([]));
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ id: "user-123", display_name: "Yahia" });
      // Dernière tentative sous la barre : c'est la priorité 2, elle doit reprendre la main.
      if (table === "attempts")
        return mockQuery([
          {
            subject_id: "math",
            score_pct: 20,
            xp_earned: 0,
            completed_at: "x",
            exercise_id: "ex-raté",
          },
        ]);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    expect(res.dailyPlan).toEqual([]);
    expect(res.nextAction).toEqual({ kind: "retry", exerciseId: "ex-raté" });
  });

  it("si la RPC manque, le tableau de bord s'affiche sans révision au lieu de casser", async () => {
    // Cas réel : le code est déployé avant que la migration ne soit appliquée.
    mockRpc.mockImplementation(rpcWith(null, { message: "function does not exist" }));

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    expect(res.dailyPlan).toEqual([]);
    expect(res.nextAction).toBeNull();
    expect(warn).toHaveBeenCalled();
  });
});
