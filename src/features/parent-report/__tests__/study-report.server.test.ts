// @vitest-environment node
/**
 * Bilan et programme du jour de l'enfant — les deux server fns du parent.
 *
 * Même RPC et même schéma que l'élève : ce qu'on protège ici, c'est que le parent demande bien
 * le bilan de L'ENFANT (le lien actif est jugé en base), que la section disparaît sur refus,
 * et que cocher à sa place passe par la même écriture.
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

import { report } from "@/shared/lib/__tests__/study-report.fixture";

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
const CHAPTER = "22222222-2222-4222-8222-222222222222";
type Fn = (d: unknown) => Promise<unknown>;

async function load() {
  const mod = await import("../parent-report.server");
  return {
    getStudentStudyReport: mod.getStudentStudyReport as unknown as Fn,
    setStudentClassChapters: mod.setStudentClassChapters as unknown as Fn,
  };
}

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  warn.mockReset();
});

describe("getStudentStudyReport", () => {
  it("lit le bilan de l'enfant demandé — le lien est jugé en base", async () => {
    mockRpc.mockResolvedValue({ data: report(), error: null });
    const { getStudentStudyReport } = await load();
    await expect(getStudentStudyReport({ studentId: STUDENT })).resolves.toEqual(report());
    expect(mockRpc).toHaveBeenCalledWith("get_study_report", { p_student: STUDENT });
  });

  it("rend null sur refus : la section disparaît, le suivi reste", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Access denied" } });
    const { getStudentStudyReport } = await load();
    await expect(getStudentStudyReport({ studentId: STUDENT })).resolves.toBeNull();
    expect(warn).toHaveBeenCalled();
  });

  it("rend null sur une forme inattendue", async () => {
    mockRpc.mockResolvedValue({ data: { day: "2026-11-22" }, error: null });
    const { getStudentStudyReport } = await load();
    await expect(getStudentStudyReport({ studentId: STUDENT })).resolves.toBeNull();
    expect(warn).toHaveBeenCalledWith("parentReport.studyReport: unexpected shape");
  });

  it("refuse un identifiant mal formé avant la base", async () => {
    const { getStudentStudyReport } = await load();
    await expect(getStudentStudyReport({ studentId: "x" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});

describe("setStudentClassChapters", () => {
  it("coche pour l'enfant, par la même écriture que lui", async () => {
    mockRpc.mockResolvedValue({ data: 1, error: null });
    const { setStudentClassChapters } = await load();
    await expect(
      setStudentClassChapters({ studentId: STUDENT, subjectId: "math", chapterIds: [CHAPTER] }),
    ).resolves.toEqual({ count: 1 });
    expect(mockRpc).toHaveBeenCalledWith("set_class_chapters", {
      p_subject_id: "math",
      p_chapter_ids: [CHAPTER],
      p_student: STUDENT,
    });
  });

  it("remonte un refus de la base (lien inactif) sans en livrer le détail", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Access denied" } });
    const { setStudentClassChapters } = await load();
    await expect(
      setStudentClassChapters({ studentId: STUDENT, subjectId: "math", chapterIds: [] }),
    ).rejects.toThrow("Enregistrement impossible");
  });

  it("refuse une entrée mal formée avant la base", async () => {
    const { setStudentClassChapters } = await load();
    await expect(
      setStudentClassChapters({ studentId: STUDENT, subjectId: "math", chapterIds: ["non"] }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
