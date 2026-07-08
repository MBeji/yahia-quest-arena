import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: ({ method: _method }: { method: string }) => {
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

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
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
    ).rejects.toThrow("Impossible de charger votre profil.");
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
      weekComparison: {
        thisWeek: { exercises: 12, minutes: 45, avgScore: 82 },
        lastWeek: { exercises: 8, minutes: 30, avgScore: 75 },
      },
      chapterInsights: {
        strengths: [
          {
            chapterId: "c1",
            chapterTitle: "Les fractions",
            subjectId: "s1",
            subjectName: "Math",
            attempts: 4,
            avgScore: 92,
          },
        ],
        weaknesses: [
          {
            chapterId: "c2",
            chapterTitle: "Thalès",
            subjectId: "s1",
            subjectName: "Math",
            attempts: 3,
            avgScore: 45,
          },
        ],
      },
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
    const week = r.weekComparison as Record<string, Record<string, number>>;
    expect(week.thisWeek.exercises).toBe(12);
    expect(week.lastWeek.avgScore).toBe(75);
    const insights = r.chapterInsights as Record<string, Array<Record<string, unknown>>>;
    expect(insights.strengths[0].chapterTitle).toBe("Les fractions");
    expect(insights.weaknesses[0].avgScore).toBe(45);
  });

  it("throws on RPC error", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Student not found" } });

    const { getStudentReport } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (getStudentReport as unknown as (d: unknown) => Promise<unknown>)({
        studentId: "11111111-1111-1111-1111-111111111111",
      }),
    ).rejects.toThrow("Impossible de charger le rapport de l'élève.");
  });

  it("coerces numbers, defaults arrays, and falls back the verdict", async () => {
    // Loosely-typed RPC payload: numeric strings, an unknown verdict, and
    // missing array fields. The parser must normalise rather than crash.
    const looselyTypedPayload = {
      student: {
        displayName: "Yahia",
        heroClass: null,
        level: "5",
        xp: "500",
        currentStreak: "7",
        longestStreak: "14",
        lastActiveDate: null,
        createdAt: "2026-01-01",
      },
      summary: {
        totalTimeMinutes: "120",
        totalExercises: "30",
        avgScore: "85",
        daysActiveThisWeek: "5",
        seriousnessScore: "90",
        verdict: "totally_unknown",
        scoreTrend: "5",
      },
      // subjectStats, dailyActivity, weekComparison and chapterInsights
      // intentionally omitted (older RPC shape) — the parser must default them.
    };
    mockRpc.mockResolvedValue({ data: looselyTypedPayload, error: null });

    const { getStudentReport } = await import("@/features/parent-report/parent-report.server");
    const result = (await (getStudentReport as unknown as (d: unknown) => Promise<unknown>)({
      studentId: "11111111-1111-1111-1111-111111111111",
    })) as {
      student: { level: number; xp: number };
      summary: { totalTimeMinutes: number; verdict: string };
      subjectStats: unknown[];
      dailyActivity: unknown[];
      weekComparison: {
        thisWeek: { exercises: number; minutes: number; avgScore: number };
        lastWeek: { exercises: number; minutes: number; avgScore: number };
      };
      chapterInsights: { strengths: unknown[]; weaknesses: unknown[] };
    };

    expect(result.student.level).toBe(5);
    expect(result.student.xp).toBe(500);
    expect(result.summary.totalTimeMinutes).toBe(120);
    expect(result.summary.verdict).toBe("average");
    expect(result.subjectStats).toEqual([]);
    expect(result.dailyActivity).toEqual([]);
    expect(result.weekComparison.thisWeek).toEqual({ exercises: 0, minutes: 0, avgScore: 0 });
    expect(result.weekComparison.lastWeek).toEqual({ exercises: 0, minutes: 0, avgScore: 0 });
    expect(result.chapterInsights).toEqual({ strengths: [], weaknesses: [] });
  });

  it("coerces numeric strings inside weekComparison and drops malformed insights arrays", async () => {
    const payload = {
      student: { displayName: "Yahia", createdAt: "2026-01-01" },
      summary: { verdict: "good" },
      weekComparison: {
        thisWeek: { exercises: "3", minutes: "20", avgScore: "70" },
        lastWeek: "corrupted",
      },
      chapterInsights: { strengths: "not-an-array", weaknesses: [] },
    };
    mockRpc.mockResolvedValue({ data: payload, error: null });

    const { getStudentReport } = await import("@/features/parent-report/parent-report.server");
    const result = (await (getStudentReport as unknown as (d: unknown) => Promise<unknown>)({
      studentId: "11111111-1111-1111-1111-111111111111",
    })) as {
      weekComparison: {
        thisWeek: { exercises: number };
        lastWeek: { exercises: number; minutes: number; avgScore: number };
      };
      chapterInsights: { strengths: unknown[]; weaknesses: unknown[] };
    };

    expect(result.weekComparison.thisWeek.exercises).toBe(3);
    expect(result.weekComparison.lastWeek).toEqual({ exercises: 0, minutes: 0, avgScore: 0 });
    expect(result.chapterInsights.strengths).toEqual([]);
    expect(result.chapterInsights.weaknesses).toEqual([]);
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
// Weekly family goal (parent side)
// =============================================================================
describe("parent-report — weekly goal", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  const STUDENT = "11111111-1111-1111-1111-111111111111";

  it("getStudentWeeklyGoal parses the goal payload", async () => {
    mockRpc.mockResolvedValue({
      data: { weekStart: "2026-06-29", target: 5, done: 2 },
      error: null,
    });

    const { getStudentWeeklyGoal } = await import("@/features/parent-report/parent-report.server");
    const result = await (getStudentWeeklyGoal as unknown as (d: unknown) => Promise<unknown>)({
      studentId: STUDENT,
    });

    expect(result).toEqual({ weekStart: "2026-06-29", target: 5, done: 2 });
    expect(mockRpc).toHaveBeenCalledWith("get_family_weekly_goal", { p_student: STUDENT });
  });

  it("getStudentWeeklyGoal returns null when no goal is set", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    const { getStudentWeeklyGoal } = await import("@/features/parent-report/parent-report.server");
    const result = await (getStudentWeeklyGoal as unknown as (d: unknown) => Promise<unknown>)({
      studentId: STUDENT,
    });

    expect(result).toBeNull();
  });

  it("setStudentWeeklyGoal upserts via the RPC and echoes the target", async () => {
    mockRpc.mockImplementation((name: string) => {
      if (name === "check_rate_limit") return Promise.resolve({ data: false, error: null });
      return Promise.resolve({ data: { weekStart: "2026-06-29", target: 7 }, error: null });
    });

    const { setStudentWeeklyGoal } = await import("@/features/parent-report/parent-report.server");
    const result = await (setStudentWeeklyGoal as unknown as (d: unknown) => Promise<unknown>)({
      studentId: STUDENT,
      target: 7,
    });

    expect(result).toEqual({ target: 7 });
    expect(mockRpc).toHaveBeenCalledWith("set_parent_weekly_goal", {
      p_student: STUDENT,
      p_target: 7,
    });
  });

  it("setStudentWeeklyGoal surfaces an RPC failure as a friendly error", async () => {
    mockRpc.mockImplementation((name: string) => {
      if (name === "check_rate_limit") return Promise.resolve({ data: false, error: null });
      return Promise.resolve({ data: null, error: { message: "Access denied" } });
    });

    const { setStudentWeeklyGoal } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (setStudentWeeklyGoal as unknown as (d: unknown) => Promise<unknown>)({
        studentId: STUDENT,
        target: 3,
      }),
    ).rejects.toThrow("Impossible d'enregistrer l'objectif de la semaine.");
  });

  it("setStudentWeeklyGoal rejects an out-of-bounds target (zod)", async () => {
    const { setStudentWeeklyGoal } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (setStudentWeeklyGoal as unknown as (d: unknown) => Promise<unknown>)({
        studentId: STUDENT,
        target: 0,
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

  it("links parent to student successfully via the RPC", async () => {
    const studentUuid = "aabbccdd-1122-3344-5566-778899001122";
    mockRpc.mockReturnValue({
      data: { linked: true, student_id: studentUuid, student_display_name: "Yahia" },
      error: null,
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    const result = await (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
      studentCode: "AABB-CCDD-1122-3344-5566-7788-9900-1122",
      relationLabel: "parent",
    });

    const r = result as Record<string, unknown>;
    expect(r.linked).toBe(true);
    expect((r.student as Record<string, unknown>).id).toBe(studentUuid);
    expect(mockRpc).toHaveBeenCalledWith("link_student_by_code", {
      p_code: "AABB-CCDD-1122-3344-5566-7788-9900-1122",
      p_relation: "parent",
    });
  });

  it("surfaces a SPECIFIC message when the caller is not a parent", async () => {
    mockRpc.mockReturnValue({
      data: null,
      error: { message: "Parent account required to link a student." },
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
        studentCode: "AABB-CCDD-1122-3344-5566-7788-9900-1122",
        relationLabel: "parent",
      }),
    ).rejects.toThrow(/compte parent/i);
  });

  it("surfaces a SPECIFIC message for an invalid alliance code", async () => {
    mockRpc.mockReturnValue({
      data: null,
      error: { message: "Invalid student alliance code." },
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
        studentCode: "AABB-CCDD-1122-3344-5566-7788-9900-1122",
        relationLabel: "parent",
      }),
    ).rejects.toThrow(/Code d'alliance invalide/i);
  });

  it("falls back to the generic message for an unrecognised RPC error", async () => {
    mockRpc.mockReturnValue({
      data: null,
      error: { message: "some unexpected database error" },
    });

    const { linkStudentByCode } = await import("@/features/parent-report/parent-report.server");
    await expect(
      (linkStudentByCode as unknown as (d: unknown) => Promise<unknown>)({
        studentCode: "AABB-CCDD-1122-3344-5566-7788-9900-1122",
        relationLabel: "parent",
      }),
    ).rejects.toThrow("Impossible d'associer cet élève. Vérifiez le code et réessayez.");
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
// linkErrorMessage — RPC reason → actionable French message
// =============================================================================
describe("parent-report — linkErrorMessage", () => {
  it("maps each known RPC reason to a distinct, specific message", async () => {
    const { linkErrorMessage } = await import("@/features/parent-report/parent-report.server");
    const generic = "Impossible d'associer cet élève. Vérifiez le code et réessayez.";

    expect(linkErrorMessage("Parent account required to link a student.")).toMatch(
      /compte parent/i,
    );
    expect(linkErrorMessage("Invalid student alliance code.")).toMatch(/Code d'alliance invalide/i);
    expect(linkErrorMessage("You cannot link your own account.")).toMatch(/ton propre compte/i);
    expect(linkErrorMessage("This code does not belong to a student account.")).toMatch(
      /compte élève/i,
    );
    expect(linkErrorMessage("Student not found.")).toMatch(/Aucun élève/i);

    // Each known reason resolves to something OTHER than the generic fallback.
    for (const reason of [
      "Parent account required to link a student.",
      "Invalid student alliance code.",
      "You cannot link your own account.",
      "This code does not belong to a student account.",
      "Student not found.",
    ]) {
      expect(linkErrorMessage(reason)).not.toBe(generic);
    }

    // Unknown reasons keep the safe generic fallback.
    expect(linkErrorMessage("connection reset by peer")).toBe(generic);
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
