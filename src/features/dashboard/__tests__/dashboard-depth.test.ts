// @vitest-environment node
/**
 * Profondeur du chemin critique de `getDashboard` (lot data-03 / db-02, 2026-10-31).
 *
 * Un builder PostgREST est un thenable PARESSEUX : la requête part au premier `.then`, et
 * chaque `await` isolé coûtait un aller-retour Vercel → Supabase payé en série. Mesuré AVANT le
 * lot : 14 lectures en 10 vagues ; APRÈS : les mêmes 14 en 2 (celles qui ne dépendent que de
 * la session, puis celles qui lisent leur résultat). Ce test épingle les 2 vagues, l'état de
 * croyance lu UNE fois et rendu au client, et la dégradation gracieuse quand sa RPC manque.
 *
 * Même harnais que dashboard.test.ts (qui a atteint son plafond de lignes) : les server fns
 * deviennent directement appelables, supabase est un double `from`/`rpc`.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

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
      validator: (fn: (d: unknown) => unknown) => {
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
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of ["select", "eq", "order", "limit", "insert"]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  Object.assign(chain, result);
  return chain;
}

describe("getDashboard — profondeur du chemin critique", () => {
  // Chaque lecture ne se résout qu'au tour de boucle suivant, et note à quelle « vague » elle
  // est partie : une lecture émise seulement après la résolution d'une autre tombe dans la
  // vague d'après.
  let tick = 0;
  let starts: Array<{ name: string; at: number }> = [];

  function lazy(name: string, data: unknown) {
    let pending: Promise<{ data: unknown; error: null }> | null = null;
    return {
      then(onFulfilled?: (v: { data: unknown; error: null }) => unknown, onRejected?: unknown) {
        pending ??= new Promise((resolve) => {
          const at = tick;
          starts.push({ name, at });
          setTimeout(() => {
            tick = Math.max(tick, at + 1);
            resolve({ data, error: null });
          }, 0);
        });
        return pending.then(onFulfilled, onRejected as undefined);
      },
    };
  }

  function lazyQuery(table: string, data: unknown) {
    const chain: Record<string, unknown> = lazy(`from:${table}`, data);
    for (const m of ["select", "eq", "order", "limit", "insert", "maybeSingle", "single"]) {
      chain[m] = () => chain;
    }
    return chain;
  }

  const croyance = (over: Record<string, unknown>) => ({
    competency_id: "c1",
    slug: "math.frac.add",
    family: "math",
    domain: "frac",
    label_fr: "",
    label_en: "",
    label_ar: "",
    state: "lacune",
    zone: "frontiere",
    p_known: null,
    evidence_count: 3,
    sessions_seen: 2,
    forms_count: 1,
    belief_source: "evidence",
    suspect: false,
    ...over,
  });

  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
    tick = 0;
    starts = [];
  });

  it("émet ses 14 lectures en 2 vagues, et rend l'état de croyance lu une seule fois", async () => {
    // Le scénario le plus long : une classe et un parcours (grades, parcours, étoiles), une
    // compétence sous le seuil (blocages), une lacune ET une compétence en cours (remontée et
    // consolidation) — les 14 lectures partent toutes.
    const tables: Record<string, unknown> = {
      profiles: {
        id: "user-123",
        display_name: "Yahia",
        current_parcours_id: "p0",
        current_grade_id: "g6",
      },
      subjects: [{ id: "s1", theme_id: "t-school", grade_id: "g6", display_order: 1 }],
      attempts: [
        {
          subject_id: "s1",
          score_pct: 40,
          xp_earned: 10,
          completed_at: "2026-06-01",
          exercise_id: "e1",
        },
      ],
      parcours: [
        {
          id: "p0",
          name_fr: "6e",
          theme_id: "t-school",
          grade_id: "g6",
          is_premium: false,
          status: "available",
        },
        {
          id: "p5",
          name_fr: "5e",
          theme_id: "t-school",
          grade_id: "g5",
          is_premium: false,
          status: "available",
        },
      ],
      grades: [
        {
          id: "g5",
          slug: "5e",
          name_fr: "5e",
          theme_id: "t-school",
          display_order: 5,
          is_selectable: true,
        },
        {
          id: "g6",
          slug: "6e",
          name_fr: "6e",
          theme_id: "t-school",
          display_order: 6,
          is_selectable: true,
        },
      ],
    };
    const learningState = [
      croyance({ competency_id: "c1", slug: "math.frac.add", state: "lacune" }),
      croyance({ competency_id: "c2", slug: "math.frac.cmp", state: "en-cours" }),
    ];
    const rpcs: Record<string, unknown> = {
      get_user_subject_stats: [],
      get_daily_plan: [],
      // Une ligne COMPLÈTE : la carte est validée à la frontière, et une ligne
      // partielle serait écartée — donc plus de compétence en échec, donc plus
      // de lecture des blocages.
      get_my_competency_map: [
        {
          competency_id: "c1",
          slug: "math.frac.add",
          family: "math",
          domain: "frac",
          label_fr: "",
          label_en: "",
          label_ar: "",
          mastery: 30,
          attempts: 6,
          recent_result: null,
        },
      ],
      get_my_weaknesses: [],
      get_competency_blockers: [],
      get_user_subject_stars: [],
      get_learning_state: learningState,
      get_remediation_path: [
        { slug: "pgcd", entry_exercise_id: "e9", is_root_cause: true, depth: 1 },
      ],
      get_exercises_for_competency: [
        {
          exercise_id: "e5",
          chapter_id: "ch",
          subject_id: "s1",
          exercise_title: "",
          difficulty: 1,
        },
      ],
    };
    mockFrom.mockImplementation((table: string) => lazyQuery(table, tables[table] ?? []));
    mockRpc.mockImplementation((fn: string) => lazy(`rpc:${fn}`, rpcs[fn] ?? []));

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as () => Promise<unknown>)()) as Record<
      string,
      unknown
    >;

    const names = starts.map((s) => s.name);
    expect(names).toHaveLength(14);
    expect(names.filter((n) => n === "rpc:get_learning_state")).toHaveLength(1);
    const waves = Math.max(...starts.map((s) => s.at)) + 1;
    expect(waves, `vagues : ${JSON.stringify(starts)}`).toBe(2);
    // Les lectures qui dépendent d'une autre sont bien en seconde vague, pas devinées.
    const at = (name: string) => starts.find((s) => s.name === name)?.at;
    expect(at("rpc:get_competency_blockers")).toBe(1);
    expect(at("rpc:get_user_subject_stars")).toBe(1);
    expect(at("rpc:get_remediation_path")).toBe(1);
    expect(at("from:grades")).toBe(1);

    // Mêmes sorties qu'avant le lot, plus l'état lui-même pour la carte à 4 états.
    expect(res.nextAction).toEqual({
      kind: "remediate",
      exerciseId: "e9",
      competencySlug: "pgcd",
    });
    expect(res.competencyBlockedSlug).toBe("math.frac.add");
    expect(res.reviseGateway).toEqual({ parcoursId: "p5", name: "5e" });
    expect(res.learningState).toEqual(learningState);
  });

  it("quand `get_learning_state` échoue, l'état rendu est vide et « Prochaine action » ne bouge pas", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ id: "user-123", display_name: "Yahia" });
      if (table === "attempts")
        return mockQuery([
          {
            subject_id: "s1",
            score_pct: 40,
            xp_earned: 10,
            completed_at: "2026-06-01",
            exercise_id: "e1",
          },
        ]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation((fn: string) =>
      fn === "get_learning_state"
        ? { data: null, error: { message: "function does not exist" } }
        : { data: [], error: null },
    );

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as () => Promise<unknown>)()) as Record<
      string,
      unknown
    >;
    expect(res.learningState).toEqual([]);
    expect(res.nextAction).toEqual({ kind: "retry", exerciseId: "e1" });
    expect(mockRpc).not.toHaveBeenCalledWith("get_remediation_path", expect.anything());
  });

  // rt-10 : `parcours`, `grades` et `subjects` ne dépendent pas l'une de l'autre.
  // En série, `/programme` payait trois allers-retours ; le test échoue dès
  // qu'une des trois attend une autre.
  it("getParcours émet ses trois lectures dans la MÊME vague", async () => {
    const tables: Record<string, unknown> = {
      parcours: [
        {
          id: "p6",
          name_fr: "6e",
          theme_id: "t-school",
          grade_id: "g6",
          is_premium: false,
          status: "available",
        },
      ],
      grades: [{ id: "g6", slug: "6e", cycle: "primaire", display_order: 6, is_selectable: true }],
      subjects: [
        { theme_id: "t-school", grade_id: "g6" },
        { theme_id: "t-school", grade_id: "g6" },
      ],
    };
    mockFrom.mockImplementation((table: string) => lazyQuery(table, tables[table] ?? []));

    const { getParcours } = await import("@/features/dashboard");
    const out = await getParcours();

    expect(starts.map((s) => s.name).sort()).toEqual([
      "from:grades",
      "from:parcours",
      "from:subjects",
    ]);
    expect(new Set(starts.map((s) => s.at))).toEqual(new Set([0]));
    // …et l'assemblage est celui d'avant.
    expect(out.parcours).toEqual([
      expect.objectContaining({
        id: "p6",
        grade_cycle: "primaire",
        grade_slug: "6e",
        subjects_count: 2,
        hasEntitlement: true,
      }),
    ]);
  });
});
