import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

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
              userId: "parent-user-1",
              claims: { sub: "parent-user-1" },
            },
          });
        };
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
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
  chain.in = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.range = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue(chain);
  chain.upsert = vi.fn().mockReturnValue(chain);
  chain.then = (resolve: (v: unknown) => unknown) => resolve(result);
  Object.assign(chain, result);
  return chain;
}

// =============================================================================
// getLinkedStudents
// =============================================================================
describe("parent-report — getLinkedStudents", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns students for admin with pagination", async () => {
    const students = [
      {
        id: "s1",
        display_name: "Student 1",
        hero_class: "mage",
        level: 3,
        xp: 200,
        current_streak: 5,
        longest_streak: 10,
        last_active_date: "2026-06-01",
        created_at: "2026-01-01",
        role: "student",
      },
    ];
    let callIndex = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        callIndex++;
        // First call: get role
        if (callIndex === 1) return mockQuery({ role: "admin" });
        // Second call: get students
        if (callIndex === 2) return mockQuery(students);
        // Third call: count
        if (callIndex === 3) {
          const chain = mockQuery(null);
          Object.assign(chain, { count: 1, data: null, error: null });
          return chain;
        }
      }
      return mockQuery([]);
    });

    const { getLinkedStudents } = await import("@/features/parent-report/parent-report.server");
    const result = await (getLinkedStudents as unknown as (d: unknown) => Promise<unknown>)({
      page: 1,
      pageSize: 100,
    });

    const r = result as Record<string, unknown>;
    expect(r.role).toBe("admin");
    expect(r).toHaveProperty("students");
    expect(r).toHaveProperty("pagination");
  });

  it("returns linked students for parent role", async () => {
    const links = [{ student_user_id: "s1", relation_label: "parent", is_active: true }];
    const students = [
      {
        id: "s1",
        display_name: "Yahia",
        hero_class: "warrior",
        level: 2,
        xp: 100,
        current_streak: 2,
        longest_streak: 5,
        last_active_date: "2026-06-01",
        created_at: "2026-01-01",
      },
    ];
    let callIndex = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        callIndex++;
        if (callIndex === 1) return mockQuery({ role: "parent" });
        if (callIndex === 2) return mockQuery(students);
      }
      if (table === "parent_student_links") return mockQuery(links);
      return mockQuery([]);
    });

    const { getLinkedStudents } = await import("@/features/parent-report/parent-report.server");
    const result = await (getLinkedStudents as unknown as (d: unknown) => Promise<unknown>)({
      page: 1,
      pageSize: 100,
    });

    const r = result as Record<string, unknown>;
    expect(r.role).toBe("parent");
    expect((r.students as unknown[]).length).toBe(1);
  });

  it("returns empty list when parent has no linked students", async () => {
    let callIndex = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        callIndex++;
        if (callIndex === 1) return mockQuery({ role: "parent" });
      }
      if (table === "parent_student_links") return mockQuery([]);
      return mockQuery([]);
    });

    const { getLinkedStudents } = await import("@/features/parent-report/parent-report.server");
    const result = await (getLinkedStudents as unknown as (d: unknown) => Promise<unknown>)({
      page: 1,
      pageSize: 100,
    });

    const r = result as Record<string, unknown>;
    expect(r.role).toBe("parent");
    expect((r.students as unknown[]).length).toBe(0);
    expect((r.pagination as Record<string, unknown>).total).toBe(0);
  });

  it("denies access to non-parent/admin users", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ role: "student" });
      return mockQuery([]);
    });

    const { getLinkedStudents } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (getLinkedStudents as unknown as (d: unknown) => Promise<unknown>)({
        page: 1,
        pageSize: 100,
      }),
    ).rejects.toThrow("Access denied");
  });

  it("throws on profile fetch error", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "DB down" }));

    const { getLinkedStudents } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (getLinkedStudents as unknown as (d: unknown) => Promise<unknown>)({
        page: 1,
        pageSize: 100,
      }),
    ).rejects.toThrow("DB down");
  });
});

// =============================================================================
// getStudentReport
// =============================================================================
describe("parent-report — getStudentReport", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns parsed report from RPC", async () => {
    const reportPayload = {
      student: {
        displayName: "Yahia",
        heroClass: "warrior",
        level: 5,
        xp: 500,
        currentStreak: 7,
        longestStreak: 14,
        lastActiveDate: "2026-06-01",
        createdAt: "2026-01-01",
      },
      summary: {
        totalTimeMinutes: 120,
        totalExercises: 30,
        avgScore: 85,
        daysActiveThisWeek: 5,
        seriousnessScore: 90,
        verdict: "excellent",
        scoreTrend: 5,
      },
      subjectStats: [
        {
          subjectId: "s1",
          name: "Math",
          colorToken: "math",
          attempts: 20,
          avgScore: 88,
          totalTimeMinutes: 60,
        },
      ],
      dailyActivity: [{ date: "2026-06-01", exercises: 5, minutes: 30, avgScore: 90 }],
    };
    mockRpc.mockResolvedValue({ data: reportPayload, error: null });

    const { getStudentReport } = await import("@/features/parent-report/parent-report.server");
    const result = await (getStudentReport as unknown as (d: unknown) => Promise<unknown>)({
      studentId: "11111111-1111-1111-1111-111111111111",
    });

    const r = result as Record<string, unknown>;
    expect(r).toHaveProperty("student");
    expect(r).toHaveProperty("summary");
    expect(r).toHaveProperty("subjectStats");
    expect(r).toHaveProperty("dailyActivity");
  });

  it("throws on RPC error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Student not found" } });

    const { getStudentReport } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (getStudentReport as unknown as (d: unknown) => Promise<unknown>)({
        studentId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow("Student not found");
  });

  it("throws on invalid payload (null)", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { getStudentReport } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (getStudentReport as unknown as (d: unknown) => Promise<unknown>)({
        studentId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow("Invalid student report payload");
  });

  it("rejects invalid studentId format", async () => {
    const { getStudentReport } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (getStudentReport as unknown as (d: unknown) => Promise<unknown>)({
        studentId: "not-a-uuid",
      }),
    ).rejects.toThrow();
  });
});

// =============================================================================
// linkStudentByCode
// =============================================================================
describe("parent-report — linkStudentByCode", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("links parent to student successfully", async () => {
    const studentUuid = "aabbccdd-1122-3344-5566-778899001122";
    const allianceCode = "AABB-CCDD-1122-3344-5566-7788-9900-1122";
    let callIndex = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        callIndex++;
        if (callIndex === 1) return mockQuery({ role: "parent" });
        if (callIndex === 2)
          return mockQuery({ id: studentUuid, display_name: "Yahia", role: "student" });
      }
      if (table === "parent_student_links") {
        const chain = mockQuery(null);
        chain.upsert = vi.fn().mockReturnValue({ data: null, error: null });
        return chain;
      }
      return mockQuery([]);
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    const result = await (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
      studentCode: allianceCode,
      relationLabel: "parent",
    });

    const r = result as Record<string, unknown>;
    expect(r.linked).toBe(true);
    expect((r.student as Record<string, unknown>).id).toBe(studentUuid);
  });

  it("denies linking for student role", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ role: "student" });
      return mockQuery([]);
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
        studentCode: "AABB-CCDD-1122-3344-5566-7788-9900-1122",
        relationLabel: "parent",
      }),
    ).rejects.toThrow("Parent account required");
  });

  it("rejects invalid alliance code", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery({ role: "parent" });
      return mockQuery([]);
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
        studentCode: "invalid-code",
        relationLabel: "parent",
      }),
    ).rejects.toThrow("Invalid student alliance code");
  });

  it("rejects self-linking", async () => {
    // parent-user-1 is the context userId
    const parentHex = "706172656e742d757365722d31000000"; // doesn't match parent-user-1 uuid format
    // We need a proper UUID that matches the mocked userId
    const selfUuid = "parent-user-1";
    let callIndex = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        callIndex++;
        if (callIndex === 1) return mockQuery({ role: "parent" });
        // studentProfile.id === userId should trigger self-link error
        if (callIndex === 2)
          return mockQuery({ id: "parent-user-1", display_name: "Me", role: "student" });
      }
      return mockQuery([]);
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    // Use a valid 32-hex code that decodes to parent-user-1 format won't work easily
    // Instead, test the code path where student is not found
    await expect(
      (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
        studentCode: "AABB-CCDD-1122-3344-5566-7788-9900-1122",
        relationLabel: "parent",
      }),
    ).rejects.toThrow("cannot link your own account");
  });

  it("rejects short student codes", async () => {
    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
        studentCode: "short",
        relationLabel: "parent",
      }),
    ).rejects.toThrow(); // Zod validation
  });
});

// =============================================================================
// family-link utilities
// =============================================================================
describe("parent-report — family-link utilities", () => {
  it("formats a UUID as alliance code", async () => {
    const { formatStudentAllianceCode } = await import("@/features/parent-report/family-link");
    const code = formatStudentAllianceCode("aabbccdd-1122-3344-5566-778899001122");
    expect(code).toBe("AABB-CCDD-1122-3344-5566-7788-9900-1122");
  });

  it("returns empty for invalid UUID", async () => {
    const { formatStudentAllianceCode } = await import("@/features/parent-report/family-link");
    expect(formatStudentAllianceCode("not-a-uuid")).toBe("");
  });

  it("parses alliance code back to UUID", async () => {
    const { parseStudentAllianceCode } = await import("@/features/parent-report/family-link");
    const uuid = parseStudentAllianceCode("AABB-CCDD-1122-3344-5566-7788-9900-1122");
    expect(uuid).toBe("aabbccdd-1122-3344-5566-778899001122");
  });

  it("returns null for invalid alliance code", async () => {
    const { parseStudentAllianceCode } = await import("@/features/parent-report/family-link");
    expect(parseStudentAllianceCode("too-short")).toBeNull();
    expect(parseStudentAllianceCode("GGGG-HHHH-1122-3344-5566-7788-9900-1122")).toBeNull();
  });
});
