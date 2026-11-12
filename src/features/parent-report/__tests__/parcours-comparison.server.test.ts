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
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

const STUDENT = "11111111-1111-4111-8111-111111111111";
type Fn = (d: unknown) => Promise<unknown>;
const PARCOURS = { nameFr: "Concours 9ᵉ", nameEn: null, nameAr: null };

async function load(): Promise<Fn> {
  return (await import("../parent-report.server")).getStudentParcoursComparison as unknown as Fn;
}

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
});

describe("getStudentParcoursComparison — étude 08 lot 3", () => {
  it("lit par la RPC dédiée ; le seuil et le lien sont jugés en base", async () => {
    mockRpc.mockResolvedValue({
      data: {
        parcours: PARCOURS,
        student: { avgScore: 70, weeklyMinutes: 10 },
        platform: { masked: false, students: 30, avgScore: 51, weeklyMinutes: 12 },
      },
      error: null,
    });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toMatchObject({
      student: { avgScore: 70, weeklyMinutes: 10 },
      platform: { masked: false, students: 30, avgScore: 51 },
    });
    expect(mockRpc).toHaveBeenCalledWith("get_student_parcours_comparison", {
      p_student: STUDENT,
    });
  });

  it("masqué : les NULL restent des NULL — aucun 0 inventé qui passerait pour une moyenne", async () => {
    mockRpc.mockResolvedValue({
      data: {
        parcours: PARCOURS,
        student: { avgScore: 70, weeklyMinutes: 10 },
        platform: { masked: true, students: null, avgScore: null, weeklyMinutes: null },
      },
      error: null,
    });
    const fn = await load();
    const out = (await fn({ studentId: STUDENT })) as { platform: Record<string, unknown> };
    expect(out.platform).toEqual({
      masked: true,
      students: null,
      avgScore: null,
      weeklyMinutes: null,
    });
  });

  it("un drapeau `masked` illisible vaut MASQUÉ — on échoue fermé", async () => {
    mockRpc.mockResolvedValue({
      data: {
        parcours: PARCOURS,
        student: null,
        platform: { masked: "nope", students: 3, avgScore: 99, weeklyMinutes: 1 },
      },
      error: null,
    });
    const fn = await load();
    const out = (await fn({ studentId: STUDENT })) as { platform: { masked: boolean } };
    expect(out.platform.masked).toBe(true);
  });

  it("élève sans parcours : la base rend NULL, la fonction aussi", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toBeNull();
  });

  it("refus ou panne : null — la section disparaît, le bilan reste", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Access denied." } });
    const fn = await load();
    expect(await fn({ studentId: STUDENT })).toBeNull();
  });

  it("refuse un identifiant d'élève qui n'est pas un uuid", async () => {
    const fn = await load();
    await expect(fn({ studentId: "x" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
