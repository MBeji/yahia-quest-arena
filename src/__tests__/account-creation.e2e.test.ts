/**
 * END-TO-END SCENARIO SUITE — ACCOUNT CREATION & PROFILE
 * ======================================================
 * Realistic non-regression journeys around signing up and profile setup:
 *   - a new STUDENT signs up, bootstraps their profile, then loads the dashboard
 *     (which auto-creates a profile row on first load if the trigger hasn't);
 *   - a new PARENT signs up, bootstraps as parent, then links a student via an
 *     alliance code;
 *   - graceful failure when an unknown alliance code is used;
 *   - the onboarding route's data fetch (getDashboard → subjects) returns shape;
 *   - edge cases (bootstrap when a profile already exists, dashboard for a
 *     brand-new user with zero attempts).
 *
 * Mock harness copied verbatim from `e2e-scenarios.test.ts`: server fns become
 * directly callable, INPUT IS PASSED RAW (not wrapped in {data}).
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };
let capturedHandlers: Record<string, (...args: unknown[]) => unknown> = {};

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: ({ method }: { method: string }) => {
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
              userId: "user-regression-test",
              claims: { sub: "user-regression-test", user_metadata: { display_name: "Yahia" } },
            },
          });
        };
        capturedHandlers[method + "_" + Object.keys(capturedHandlers).length] = wrapped;
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: vi.fn().mockResolvedValue(false) }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of [
    "select",
    "eq",
    "gt",
    "gte",
    "lte",
    "neq",
    "in",
    "order",
    "limit",
    "insert",
    "update",
    "upsert",
    "delete",
  ]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.then = (resolve: (v: unknown) => unknown) => resolve(result);
  Object.assign(chain, result);
  return chain;
}

// =============================================================================
// END-TO-END SCENARIOS — chain multiple server fns to mimic real journeys.
// Each step re-arms the supabase mock so every call gets a realistic response.
// =============================================================================
const U = "55555555-5555-5555-5555-555555555555";

/** Dispatch RPC responses by function name (default ok/empty). */
function rpcByName(map: Record<string, { data?: unknown; error?: unknown }>) {
  return (fn: string) => Promise.resolve(map[fn] ?? { data: null, error: null });
}

type Fn = (d?: unknown) => Promise<unknown>;

describe("END-TO-END: new student signs up", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("bootstrapProfile(student) → first getDashboard returns the profile", async () => {
    const { bootstrapProfile } = await import("@/features/auth");
    const { getDashboard } = await import("@/features/dashboard");

    // 1) Bootstrap the freshly created profile as a student.
    //    Role is now set via the `set_profile_role` SECURITY DEFINER RPC, never a
    //    direct client write (P0 S2a containment), so arm the RPC mock.
    mockFrom.mockImplementation((table: string) =>
      table === "profiles" ? mockQuery(null) : mockQuery([]),
    );
    mockRpc.mockImplementation(rpcByName({ set_profile_role: { data: null, error: null } }));
    const bootstrap = (await (bootstrapProfile as unknown as Fn)({
      displayName: "Yahia",
      role: "student",
    })) as { ok: boolean };
    expect(bootstrap.ok).toBe(true);
    // The role must NOT be written through a direct profiles upsert anymore.
    expect(mockRpc).toHaveBeenCalledWith("set_profile_role", { p_role: "student" });

    // 2) First dashboard load — profile row already exists (trigger + bootstrap),
    //    with an active concours parcours pinning theme + grade.
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return mockQuery({
          id: "user-regression-test",
          display_name: "Yahia",
          role: "student",
          xp: 0,
          level: 1,
          coins: 0,
          current_streak: 0,
          current_grade_id: "g9",
          current_parcours_id: "concours-9eme",
        });
      if (table === "parcours")
        return mockQuery({ theme_id: "ecole-tn", grade_id: "g9", is_premium: false });
      if (table === "subjects")
        return mockQuery([
          {
            id: "s1",
            name_fr: "Math",
            color_token: "math",
            display_order: 1,
            theme_id: "ecole-tn",
            grade_id: "g9",
          },
          {
            id: "s2",
            name_fr: "Physique",
            color_token: "phys",
            display_order: 2,
            theme_id: "ecole-tn",
            grade_id: "g9",
          },
        ]);
      // attempts (recent + stats)
      return mockQuery([]);
    });

    const dashboard = (await (getDashboard as unknown as Fn)()) as {
      profile: { display_name: string; role: string } | null;
      subjects: unknown[];
      stats: Record<string, unknown>;
      recent: unknown[];
      nextExerciseId: string | null;
    };

    expect(dashboard.profile).not.toBeNull();
    expect(dashboard.profile?.display_name).toBe("Yahia");
    expect(dashboard.profile?.role).toBe("student");
    expect(dashboard.subjects).toHaveLength(2);
    expect(dashboard.recent).toEqual([]);
    expect(dashboard.stats).toEqual({});
    expect(dashboard.nextExerciseId).toBeNull();
  });

  it("getDashboard AUTO-CREATES the profile when none exists yet", async () => {
    const { getDashboard } = await import("@/features/dashboard");

    // 1st `from("profiles")` = initial select → null; 2nd = insert (no error);
    // 3rd = reload select → the freshly created row.
    let profileCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        profileCalls += 1;
        return profileCalls === 3
          ? mockQuery({
              id: "user-regression-test",
              display_name: "Yahia",
              role: "student",
              xp: 0,
              level: 1,
            })
          : mockQuery(null);
      }
      if (table === "subjects") return mockQuery([{ id: "s1", name_fr: "Math", display_order: 1 }]);
      return mockQuery([]);
    });

    const dashboard = (await (getDashboard as unknown as Fn)()) as {
      profile: { display_name: string } | null;
    };

    expect(dashboard.profile).not.toBeNull();
    expect(dashboard.profile?.display_name).toBe("Yahia");
    // initial select + insert + reload select => profiles touched 3x.
    expect(profileCalls).toBe(3);
  });
});

describe("END-TO-END: new parent signs up and links a student", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("bootstrapProfile(parent) → linkStudentByCode(valid) links the student", async () => {
    const { bootstrapProfile } = await import("@/features/auth");
    const { linkStudentByCode } = await import("@/features/parent-report");

    // 1) Bootstrap as a parent. Role goes through the `set_profile_role` RPC.
    mockFrom.mockImplementation(() => mockQuery(null));
    mockRpc.mockImplementation(rpcByName({ set_profile_role: { data: null, error: null } }));
    const bootstrap = (await (bootstrapProfile as unknown as Fn)({
      displayName: "Parent Yahia",
      role: "parent",
    })) as { ok: boolean };
    expect(bootstrap.ok).toBe(true);
    expect(mockRpc).toHaveBeenCalledWith("set_profile_role", { p_role: "parent" });

    // 2) Link a real student via alliance code → RPC reports linked.
    mockRpc.mockImplementation(
      rpcByName({
        link_student_by_code: {
          data: { linked: true, student_id: U, student_display_name: "Sami" },
          error: null,
        },
      }),
    );

    const linked = (await (linkStudentByCode as unknown as Fn)({
      studentCode: "ALLIANCE-CODE-1234",
      relationLabel: "father",
    })) as { linked: boolean; student: { id: string; displayName: string | null } };

    expect(linked.linked).toBe(true);
    expect(linked.student.id).toBe(U);
    expect(linked.student.displayName).toBe("Sami");
  });

  it("linkStudentByCode defaults the relation label to 'parent'", async () => {
    const { linkStudentByCode } = await import("@/features/parent-report");

    let relationArg: unknown;
    mockRpc.mockImplementation((fn: string, args: Record<string, unknown>) => {
      relationArg = args?.p_relation;
      return Promise.resolve({
        data: { linked: true, student_id: U, student_display_name: "Sami" },
        error: null,
      });
    });

    const linked = (await (linkStudentByCode as unknown as Fn)({
      studentCode: "ALLIANCE-CODE-1234",
    })) as { linked: boolean };

    expect(linked.linked).toBe(true);
    expect(relationArg).toBe("parent");
  });
});

describe("END-TO-END: linking with a bad alliance code fails gracefully", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("unknown code → RPC returns linked:false, no hang", async () => {
    const { linkStudentByCode } = await import("@/features/parent-report");

    // The SECURITY DEFINER RPC succeeds but reports the code matched nobody.
    mockRpc.mockImplementation(
      rpcByName({
        link_student_by_code: { data: { linked: false }, error: null },
      }),
    );

    const result = (await (linkStudentByCode as unknown as Fn)({
      studentCode: "UNKNOWN-CODE-9999",
    })) as { linked: boolean; student: { id: string; displayName: string | null } };

    expect(result.linked).toBe(false);
    expect(result.student.id).toBe("");
    expect(result.student.displayName).toBeNull();
  });

  it("RPC error → rejects with a sanitized client error (no hang)", async () => {
    const { linkStudentByCode } = await import("@/features/parent-report");

    mockRpc.mockImplementation(
      rpcByName({
        link_student_by_code: { data: null, error: { message: "boom", code: "P0001" } },
      }),
    );

    await expect(
      (linkStudentByCode as unknown as Fn)({ studentCode: "ANY-CODE-12345" }),
    ).rejects.toThrow(/associer cet élève/i);
  });

  it("rejects a too-short code at the validator (never hits the RPC)", async () => {
    const { linkStudentByCode } = await import("@/features/parent-report");

    mockRpc.mockResolvedValue({ data: { linked: true }, error: null });

    await expect((linkStudentByCode as unknown as Fn)({ studentCode: "short" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});

describe("END-TO-END: onboarding route data fetch", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getParcours supplies the parcours the profile-first onboarding wizard renders", async () => {
    const { getParcours } = await import("@/features/dashboard");

    const rows = [
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
      {
        id: "culture-generale",
        name_fr: "Culture générale",
        kind: "libre",
        is_premium: false,
        status: "available",
        display_order: 11,
        icon: "Globe",
        color: "subject-culture",
        theme_id: "culture-generale",
        grade_id: null,
      },
    ];
    mockFrom.mockImplementation((table: string) =>
      table === "parcours" ? mockQuery(rows) : mockQuery([]),
    );
    // getParcours now enriches premium rows via has_parcours_entitlement.
    mockRpc.mockResolvedValue({ data: false, error: null });

    const res = (await (getParcours as unknown as Fn)()) as {
      parcours: Array<(typeof rows)[number] & { hasEntitlement: boolean }>;
    };

    // Onboarding filters by kind/status and renders a ParcoursCard per item.
    expect(res.parcours).toHaveLength(2);
    expect(res.parcours[0]).toMatchObject({
      id: "concours-9eme",
      kind: "concours",
      hasEntitlement: false,
    });
    // Free parcours are always entitled, without an RPC round-trip.
    expect(res.parcours[1]).toMatchObject({
      id: "culture-generale",
      kind: "libre",
      hasEntitlement: true,
    });
  });
});

describe("END-TO-END: account-creation edge cases", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("bootstrapProfile is idempotent when a profile already exists (upsert)", async () => {
    const { bootstrapProfile } = await import("@/features/auth");

    // upsert onConflict:id over an existing row → no error.
    mockFrom.mockImplementation((table: string) =>
      table === "profiles" ? mockQuery(null, null) : mockQuery([]),
    );
    mockRpc.mockImplementation(rpcByName({ set_profile_role: { data: null, error: null } }));

    const first = (await (bootstrapProfile as unknown as Fn)({
      displayName: "Yahia",
      role: "student",
    })) as { ok: boolean };
    const second = (await (bootstrapProfile as unknown as Fn)({
      displayName: "Yahia Renamed",
      role: "student",
    })) as { ok: boolean };

    expect(first.ok).toBe(true);
    expect(second.ok).toBe(true);
  });

  it("bootstrapProfile rejects an invalid role at the validator", async () => {
    const { bootstrapProfile } = await import("@/features/auth");

    mockFrom.mockImplementation(() => mockQuery(null));

    await expect(
      (bootstrapProfile as unknown as Fn)({ displayName: "Yahia", role: "wizard" }),
    ).rejects.toThrow();
    // Validator fails before any supabase write.
    expect(mockFrom).not.toHaveBeenCalled();
  });

  it("bootstrapProfile surfaces a sanitized error when the upsert fails", async () => {
    const { bootstrapProfile } = await import("@/features/auth");

    mockFrom.mockImplementation((table: string) =>
      table === "profiles"
        ? mockQuery(null, { message: "rls denied", code: "42501" })
        : mockQuery([]),
    );

    await expect(
      (bootstrapProfile as unknown as Fn)({ displayName: "Yahia", role: "student" }),
    ).rejects.toThrow();
  });

  it("bootstrapProfile surfaces a sanitized error when the role RPC fails", async () => {
    const { bootstrapProfile } = await import("@/features/auth");

    // Name upsert succeeds; the sanctioned `set_profile_role` RPC then errors
    // (e.g. trigger rejection) → the raw DB message must not leak.
    mockFrom.mockImplementation((table: string) =>
      table === "profiles" ? mockQuery(null, null) : mockQuery([]),
    );
    mockRpc.mockImplementation(
      rpcByName({
        set_profile_role: { data: null, error: { message: "trigger denied", code: "P0001" } },
      }),
    );

    await expect(
      (bootstrapProfile as unknown as Fn)({ displayName: "Yahia", role: "student" }),
    ).rejects.toThrow();
  });

  it("setCurrentParcours persists the chosen parcours via the RPC and returns the profile", async () => {
    const { setCurrentParcours } = await import("@/features/auth");

    const updatedProfile = {
      id: "user-regression-test",
      current_parcours_id: "concours-9eme",
      current_grade_id: "g9",
    };
    mockRpc.mockImplementation(
      rpcByName({ set_current_parcours: { data: updatedProfile, error: null } }),
    );

    const res = (await (setCurrentParcours as unknown as Fn)({
      parcoursId: "concours-9eme",
    })) as { profile: typeof updatedProfile };

    // The self-scoped SECURITY DEFINER RPC is the only sanctioned write path.
    expect(mockRpc).toHaveBeenCalledWith("set_current_parcours", { p_parcours: "concours-9eme" });
    expect(res.profile).toEqual(updatedProfile);
  });

  it("setCurrentParcours surfaces a sanitized error when the RPC fails", async () => {
    const { setCurrentParcours } = await import("@/features/auth");

    mockRpc.mockImplementation(
      rpcByName({
        set_current_parcours: { data: null, error: { message: "rls denied", code: "42501" } },
      }),
    );

    await expect(
      (setCurrentParcours as unknown as Fn)({ parcoursId: "concours-9eme" }),
    ).rejects.toThrow(/parcours/i);
  });

  it("setCurrentParcours rejects an empty parcours id at the validator", async () => {
    const { setCurrentParcours } = await import("@/features/auth");
    mockRpc.mockResolvedValue({ data: null, error: null });

    await expect((setCurrentParcours as unknown as Fn)({ parcoursId: "" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("getDashboard for a brand-new user with zero attempts returns empty aggregates", async () => {
    const { getDashboard } = await import("@/features/dashboard");

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return mockQuery({
          id: "user-regression-test",
          display_name: "Yahia",
          role: "student",
          xp: 0,
          level: 1,
          coins: 0,
        });
      if (table === "subjects") return mockQuery([{ id: "s1", name_fr: "Math", display_order: 1 }]);
      // attempts: recent + stats both empty for a fresh account.
      return mockQuery([]);
    });

    const dashboard = (await (getDashboard as unknown as Fn)()) as {
      stats: Record<string, unknown>;
      recent: unknown[];
      nextExerciseId: string | null;
    };

    expect(dashboard.stats).toEqual({});
    expect(dashboard.recent).toEqual([]);
    expect(dashboard.nextExerciseId).toBeNull();
  });
});
