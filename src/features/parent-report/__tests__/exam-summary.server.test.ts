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
  return (await import("../parent-report.server")).getStudentExamSummary as unknown as Fn;
}

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  warn.mockReset();
});

describe("getStudentExamSummary — étude 08 lot 1", () => {
  it("lit par la RPC dédiée, avec l'élève demandé — le lien est jugé en base", async () => {
    mockRpc.mockResolvedValue({
      data: { minCandidates: 20, openExams: 1, exams: [] },
      error: null,
    });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toEqual({
      minCandidates: 20,
      openExams: 1,
      exams: [],
    });
    expect(mockRpc).toHaveBeenCalledWith("get_student_exam_summary", { p_student: STUDENT });
  });

  it("relit la charge : les nombres en texte de Postgres redeviennent des nombres", async () => {
    mockRpc.mockResolvedValue({
      data: {
        minCandidates: 20,
        openExams: 0,
        exams: [
          {
            examId: "e1",
            titleFr: "Blanc A",
            titleEn: null,
            titleAr: null,
            finishedAt: "2026-11-08T10:00:00Z",
            scorePoints: "120",
            maxPoints: 150,
            scoreOn20: "16.00",
            candidates: 42,
            percentile: "65.0",
          },
        ],
      },
      error: null,
    });
    const fn = await load();
    const out = (await fn({ studentId: STUDENT })) as { exams: Record<string, unknown>[] };
    expect(out.exams[0]).toMatchObject({ scorePoints: 120, scoreOn20: 16, percentile: 65 });
  });

  it("garde le percentile à null sous le seuil — jamais un 0 inventé", async () => {
    mockRpc.mockResolvedValue({
      data: {
        minCandidates: 20,
        openExams: 0,
        exams: [
          {
            examId: "e1",
            titleFr: "Blanc A",
            finishedAt: "2026-11-08T10:00:00Z",
            scorePoints: 120,
            maxPoints: 150,
            scoreOn20: 16,
            candidates: 19,
            percentile: null,
          },
        ],
      },
      error: null,
    });
    const fn = await load();
    const out = (await fn({ studentId: STUDENT })) as { exams: { percentile: unknown }[] };
    expect(out.exams[0].percentile).toBeNull();
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

  it("une charge sans forme rend null plutôt qu'une section fausse", async () => {
    mockRpc.mockResolvedValue({ data: "nope", error: null });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toBeNull();
  });

  it("refuse un identifiant d'élève qui n'est pas un uuid", async () => {
    const fn = await load();
    await expect(fn({ studentId: "x" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
