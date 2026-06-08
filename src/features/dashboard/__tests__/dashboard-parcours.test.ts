/**
 * Parcours-scoped dashboard (Phase 4 — premium-parcours pivot).
 *
 * Covers getDashboard's parcours-based subject scoping (active parcours pins
 * theme + grade; premium parcours without an entitlement surface locked subjects;
 * null parcours → no scoped subjects) and the getParcours catalogue reader.
 *
 * Mock harness mirrors dashboard.test.ts: server fns become directly callable and
 * supabase is a `from`/`rpc` double with a chainable query builder.
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
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
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

/** has_parcours_entitlement → `entitled`; everything else → null/ok. */
function rpcEntitlement(entitled: boolean) {
  return (fn: string) =>
    fn === "has_parcours_entitlement"
      ? Promise.resolve({ data: entitled, error: null })
      : Promise.resolve({ data: null, error: null });
}

type Fn = (d?: unknown) => Promise<unknown>;

describe("dashboard.parcours — getDashboard scoping", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("scopes subjects to the active concours parcours (theme + grade)", async () => {
    const profile = {
      id: "user-123",
      display_name: "Yahia",
      current_grade_id: "g9",
      current_parcours_id: "concours-9eme",
    };
    const inParcours = { id: "s1", name_fr: "Math", theme_id: "ecole-tn", grade_id: "g9" };
    const wrongGrade = { id: "s2", name_fr: "Philo", theme_id: "ecole-tn", grade_id: "gbac" };
    const free = { id: "fr", name_fr: "Français", theme_id: "francais", grade_id: null };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "parcours")
        return mockQuery({ theme_id: "ecole-tn", grade_id: "g9", is_premium: false });
      if (table === "subjects") return mockQuery([inParcours, wrongGrade, free]);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    // Only the active parcours' subjects; the free subject is split into otherSubjects.
    expect(res.subjects).toEqual([inParcours]);
    expect(res.otherSubjects).toEqual([free]);
    expect(res.currentParcoursId).toBe("concours-9eme");
    expect(res.premiumLockedSubjectIds).toEqual([]);
  });

  it("returns empty subjects when the profile has no active parcours", async () => {
    const profile = { id: "user-123", display_name: "Yahia", current_parcours_id: null };
    const g9 = { id: "s1", name_fr: "Math", theme_id: "ecole-tn", grade_id: "g9" };
    const free = { id: "fr", name_fr: "Français", theme_id: "francais", grade_id: null };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "subjects") return mockQuery([g9, free]);
      return mockQuery([]);
    });

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    // No parcours → no scoped subjects; free (grade-null) subjects surface as "other".
    expect(res.subjects).toEqual([]);
    expect(res.otherSubjects).toEqual([free]);
    expect(res.currentParcoursId).toBeNull();
    expect(res.premiumLockedSubjectIds).toEqual([]);
  });

  it("locks the active parcours' subjects when it is premium and lacks an entitlement", async () => {
    const profile = { id: "user-123", current_parcours_id: "concours-9eme" };
    const s1 = { id: "s1", name_fr: "Math", theme_id: "ecole-tn", grade_id: "g9" };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "parcours")
        return mockQuery({ theme_id: "ecole-tn", grade_id: "g9", is_premium: true });
      if (table === "subjects") return mockQuery([s1]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation(rpcEntitlement(false));

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    expect(res.subjects).toEqual([s1]);
    expect(res.premiumLockedSubjectIds).toEqual(["s1"]);
  });

  it("does NOT lock a premium parcours' subjects when the user has the entitlement", async () => {
    const profile = { id: "user-123", current_parcours_id: "concours-9eme" };
    const s1 = { id: "s1", name_fr: "Math", theme_id: "ecole-tn", grade_id: "g9" };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "parcours")
        return mockQuery({ theme_id: "ecole-tn", grade_id: "g9", is_premium: true });
      if (table === "subjects") return mockQuery([s1]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation(rpcEntitlement(true));

    const { getDashboard } = await import("@/features/dashboard");
    const res = (await (getDashboard as unknown as Fn)()) as Record<string, unknown>;

    expect(res.subjects).toEqual([s1]);
    expect(res.premiumLockedSubjectIds).toEqual([]);
  });
});

describe("dashboard.parcours — getParcours catalogue", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns the ordered parcours catalogue", async () => {
    const parcours = [
      {
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
      },
    ];
    const chain = mockQuery(parcours);
    mockFrom.mockImplementation(() => chain);

    const { getParcours } = await import("@/features/dashboard");
    const result = (await (getParcours as unknown as Fn)()) as { parcours: unknown[] };

    expect(result.parcours).toEqual(parcours);
    expect(chain.order).toHaveBeenCalledWith("display_order");
  });

  it("throws a generic message on error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "parcours error" }));
    const { getParcours } = await import("@/features/dashboard");
    await expect((getParcours as unknown as Fn)()).rejects.toThrow(/tableau de bord/i);
  });
});
