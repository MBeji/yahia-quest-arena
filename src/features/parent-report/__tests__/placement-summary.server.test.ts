// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockRpc = vi.fn();
const mockSupabase = { rpc: mockRpc };

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
        return async (input: unknown) => {
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: "parent-1" } });
        };
      },
    };
    return chain;
  },
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional",
}));
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: vi.fn().mockResolvedValue(false) }));
const warn = vi.fn();
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn, info: vi.fn(), debug: vi.fn() },
}));

const STUDENT = "11111111-1111-4111-8111-111111111111";
type Fn = (d: unknown) => Promise<unknown>;

async function load(): Promise<Fn> {
  return (await import("../parent-report.server")).getStudentPlacementSummary as unknown as Fn;
}

const test0 = {
  sessionId: "s1",
  subjectId: "math-9",
  subjectNameFr: "Mathématiques",
  gradeNameFr: "9ème année",
  finishedAt: "2026-11-18T10:00:00Z",
  correct: 7,
  total: 10,
  scoreOn20: "14.0",
  band: "en-route",
  chaptersHeld: ["Nombres"],
  chaptersToReview: ["Angles"],
  scope: { throughTitle: "Angles", chaptersInScope: "4", chaptersTotal: 12 },
};

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  warn.mockReset();
});

describe("getStudentPlacementSummary — étude 39 lot 5 (é08)", () => {
  it("lit par la RPC dédiée, avec l'élève demandé — le lien est jugé en base", async () => {
    mockRpc.mockResolvedValue({ data: { tests: [] }, error: null });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toEqual({ tests: [] });
    expect(mockRpc).toHaveBeenCalledWith("get_student_placement_summary", { p_student: STUDENT });
  });

  it("relit la charge : les nombres en texte de Postgres redeviennent des nombres", async () => {
    mockRpc.mockResolvedValue({ data: { tests: [test0] }, error: null });
    const fn = await load();
    const out = (await fn({ studentId: STUDENT })) as { tests: Record<string, unknown>[] };
    expect(out.tests[0]).toMatchObject({
      scoreOn20: 14,
      band: "en-route",
      scope: { throughTitle: "Angles", chaptersInScope: 4, chaptersTotal: 12 },
    });
  });

  it("une portée absente vaut « toute l'année »", async () => {
    mockRpc.mockResolvedValue({ data: { tests: [{ ...test0, scope: null }] }, error: null });
    const fn = await load();
    const out = (await fn({ studentId: STUDENT })) as { tests: { scope: unknown }[] };
    expect(out.tests[0].scope).toBeNull();
  });

  it("une bande inconnue est une panne de lecture : null, journalisé — jamais une bande inventée", async () => {
    mockRpc.mockResolvedValue({ data: { tests: [{ ...test0, band: "excellent" }] }, error: null });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toBeNull();
    expect(warn).toHaveBeenCalledTimes(1);
  });

  it("refus ou panne : null, journalisé — la section disparaît, le bilan reste", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: "Access denied: you are not linked to this student." },
    });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toBeNull();
    expect(warn).toHaveBeenCalledTimes(1);
  });

  it("refuse un identifiant d'élève qui n'est pas un uuid", async () => {
    const fn = await load();
    await expect(fn({ studentId: "x" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});

describe("getStudentPlacementSummaryByCode — /suivi (2026-11-24)", () => {
  const CODE = "11111111-1111-4111-8111-111111111111";
  async function loadByCode(): Promise<Fn> {
    return (await import("../parent-report.server"))
      .getStudentPlacementSummaryByCode as unknown as Fn;
  }

  it("lit par la RPC au code — le décodage et la borne de débit sont en base", async () => {
    mockRpc.mockResolvedValue({ data: { tests: [test0] }, error: null });
    const fn = await loadByCode();
    const out = (await fn({ studentCode: CODE })) as { tests: unknown[] };
    expect(out.tests).toHaveLength(1);
    expect(mockRpc).toHaveBeenCalledWith("get_student_placement_summary_by_code", {
      p_code: CODE,
    });
  });

  it("code refusé ou cadence dépassée : null — le bilan principal dit déjà l'erreur", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Invalid student alliance code." } });
    const fn = await loadByCode();
    expect(await fn({ studentCode: CODE })).toBeNull();
    expect(warn).toHaveBeenCalledTimes(1);
  });

  it("refuse un code trop court avant tout appel", async () => {
    const fn = await loadByCode();
    await expect(fn({ studentCode: "abc" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
