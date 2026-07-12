/**
 * Anonymous (no userId) path of the parcours catalogue reads — switched to
 * optionalSupabaseAuth in chantier C8 (L1.3). getParcours + getParcoursSubjects must
 * work without a session: every parcours is returned unlocked (`hasEntitlement: true`)
 * and the entitlement RPC is never called. Mirrors the quest-anon harness (a mutable
 * `ctxUserId` lets a test drive the anonymous branch).
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const { mockFrom, mockRpc } = vi.hoisted(() => ({ mockFrom: vi.fn(), mockRpc: vi.fn() }));
let ctxUserId: string | null = null;
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
          return handlerFn({ data, context: { supabase: mockSupabase, userId: ctxUserId } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({ requireSupabaseAuth: "mw" }));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mw-optional",
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of ["select", "eq", "is", "order", "limit"]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  Object.assign(chain, result);
  return chain;
}

type Fn = (d?: unknown) => Promise<unknown>;

describe("dashboard.parcours — anonymous (optionalSupabaseAuth)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
    ctxUserId = null;
  });

  it("getParcours: anon sees a premium parcours unlocked and never calls the entitlement RPC", async () => {
    const concours = {
      id: "concours-9eme",
      name_fr: "Préparation Concours 9ème",
      kind: "concours",
      is_premium: true,
      status: "available",
      display_order: 1,
      icon: "GraduationCap",
      color: "subject-math",
      theme_id: "ecole-tn",
      grade_id: "g9",
    };
    mockFrom.mockImplementation((table: string) =>
      table === "grades"
        ? mockQuery([
            {
              id: "g9",
              slug: "9eme-base",
              cycle: "college",
              display_order: 9,
              is_selectable: true,
            },
          ])
        : mockQuery([concours]),
    );

    const { getParcours } = await import("@/features/dashboard");
    const result = (await (getParcours as unknown as Fn)()) as {
      parcours: Array<Record<string, unknown>>;
    };

    expect(result.parcours[0]).toMatchObject({
      id: "concours-9eme",
      grade_cycle: "college",
      grade_order: 9,
      grade_slug: "9eme-base",
      grade_selectable: true,
      hasEntitlement: true,
    });
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("getParcours: surfaces the grade's is_selectable and defaults it to true without a grade", async () => {
    const rows = [
      {
        id: "ecole-bac", // legacy flat node → non-selectable grade
        name_fr: "Bac",
        kind: "concours",
        is_premium: false,
        status: "coming_soon",
        display_order: 2,
        icon: "GraduationCap",
        color: "subject-math",
        theme_id: "ecole-tn",
        grade_id: "g-bac",
      },
      {
        id: "culture-generale", // libre, grade-less → stays selectable
        name_fr: "Culture G",
        kind: "libre",
        is_premium: false,
        status: "available",
        display_order: 3,
        icon: "Globe",
        color: "subject-math",
        theme_id: "culture-generale",
        grade_id: null,
      },
    ];
    mockFrom.mockImplementation((table: string) =>
      table === "grades"
        ? mockQuery([
            {
              id: "g-bac",
              slug: "bac",
              cycle: "secondaire",
              display_order: 13,
              is_selectable: false,
            },
          ])
        : mockQuery(rows),
    );

    const { getParcours } = await import("@/features/dashboard");
    const result = (await (getParcours as unknown as Fn)()) as {
      parcours: Array<Record<string, unknown>>;
    };

    expect(result.parcours[0]).toMatchObject({ grade_slug: "bac", grade_selectable: false });
    expect(result.parcours[1]).toMatchObject({ grade_slug: null, grade_selectable: true });
  });

  it("getParcoursSubjects: anon resolves a school level's subjects (theme + grade)", async () => {
    const parcours = {
      id: "concours-9eme",
      name_fr: "Préparation Concours 9ème",
      kind: "concours",
      is_premium: true,
      status: "available",
      theme_id: "ecole-tn",
      grade_id: "g9",
    };
    const math = {
      id: "s1",
      name_fr: "Mathématiques",
      attribute: null,
      description: null,
      content_language: "fr",
    };
    const subjectsChain = mockQuery([math]);
    mockFrom.mockImplementation((table: string) =>
      table === "parcours" ? mockQuery(parcours) : subjectsChain,
    );

    const { getParcoursSubjects } = await import("@/features/dashboard");
    const result = (await (getParcoursSubjects as unknown as Fn)({
      parcoursId: "concours-9eme",
    })) as { parcours: Record<string, unknown> | null; subjects: unknown[] };

    expect(result.parcours).toMatchObject({ id: "concours-9eme" });
    expect(result.subjects).toEqual([math]);
    // grade-bound parcours filters subjects by grade_id (eq), not the null branch (is).
    expect(subjectsChain.eq).toHaveBeenCalledWith("grade_id", "g9");
    expect(subjectsChain.is).not.toHaveBeenCalled();
  });

  it("getParcoursSubjects: a libre (grade-null) track filters subjects by grade IS NULL", async () => {
    const parcours = {
      id: "anglais",
      name_fr: "Anglais",
      kind: "libre",
      is_premium: false,
      status: "available",
      theme_id: "anglais",
      grade_id: null,
    };
    const a1 = {
      id: "anglais-a1",
      name_fr: "Anglais A1",
      attribute: "Débutant",
      description: null,
      content_language: "en",
    };
    const subjectsChain = mockQuery([a1]);
    mockFrom.mockImplementation((table: string) =>
      table === "parcours" ? mockQuery(parcours) : subjectsChain,
    );

    const { getParcoursSubjects } = await import("@/features/dashboard");
    const result = (await (getParcoursSubjects as unknown as Fn)({
      parcoursId: "anglais",
    })) as { subjects: unknown[] };

    expect(result.subjects).toEqual([a1]);
    expect(subjectsChain.is).toHaveBeenCalledWith("grade_id", null);
  });

  it("getParcoursSubjects: an unknown parcours returns an empty result", async () => {
    mockFrom.mockImplementation(() => mockQuery(null));
    const { getParcoursSubjects } = await import("@/features/dashboard");
    const result = (await (getParcoursSubjects as unknown as Fn)({
      parcoursId: "nope",
    })) as { parcours: unknown; subjects: unknown[] };

    expect(result.parcours).toBeNull();
    expect(result.subjects).toEqual([]);
  });

  it("getParcoursSubjects: surfaces a generic error message on failure", async () => {
    mockFrom.mockImplementation((table: string) =>
      table === "parcours" ? mockQuery(null, { message: "boom" }) : mockQuery([]),
    );
    const { getParcoursSubjects } = await import("@/features/dashboard");
    await expect((getParcoursSubjects as unknown as Fn)({ parcoursId: "x" })).rejects.toThrow(
      /tableau de bord/i,
    );
  });
});
