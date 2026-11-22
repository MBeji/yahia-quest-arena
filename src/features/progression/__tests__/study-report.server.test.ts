// @vitest-environment node
/**
 * Bilan et programme du jour — les deux server fns de l'élève.
 *
 * Elles ne décident de rien (tout est tranché par `get_study_report` / `set_class_chapters`) :
 * ce qu'on protège ici, c'est la frontière — la bonne RPC, les bons arguments, une forme
 * inattendue qui rend `null` au lieu d'un demi-bilan, et une entrée mal formée qui n'atteint
 * jamais la base.
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
        return async (input?: { data?: unknown }) => {
          const data = validatorFn ? validatorFn(input?.data) : input?.data;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: "student-1" } });
        };
      },
    };
    return chain;
  },
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
const isRateLimited = vi.fn();
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited }));
const warn = vi.fn();
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn, info: vi.fn(), debug: vi.fn() },
}));

const CHAPTER = "22222222-2222-4222-8222-222222222222";
type Fn = (input?: { data?: unknown }) => Promise<unknown>;

async function load() {
  const mod = await import("../progression.server");
  return {
    getStudyReport: mod.getStudyReport as unknown as Fn,
    setClassChapters: mod.setClassChapters as unknown as Fn,
    setStudyPreferences: mod.setStudyPreferences as unknown as Fn,
  };
}

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  warn.mockReset();
  isRateLimited.mockReset().mockResolvedValue(false);
});

describe("getStudyReport", () => {
  it("lit le bilan de l'élève connecté, détail des chapitres compris", async () => {
    mockRpc.mockResolvedValue({ data: report(), error: null });
    const { getStudyReport } = await load();
    await expect(getStudyReport()).resolves.toEqual(report());
    expect(mockRpc).toHaveBeenCalledWith("get_study_report");
  });

  it("rend null quand la RPC échoue", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { getStudyReport } = await load();
    await expect(getStudyReport()).resolves.toBeNull();
    expect(warn).toHaveBeenCalled();
  });

  it("rend null sur une forme inattendue — jamais un demi-bilan", async () => {
    mockRpc.mockResolvedValue({ data: { ...report(), subjects: "rien" }, error: null });
    const { getStudyReport } = await load();
    await expect(getStudyReport()).resolves.toBeNull();
    expect(warn).toHaveBeenCalledWith("progression.studyReport: unexpected shape");
  });
});

describe("setClassChapters", () => {
  it("envoie la déclaration entière de la matière", async () => {
    mockRpc.mockResolvedValue({ data: 1, error: null });
    const { setClassChapters } = await load();
    await expect(
      setClassChapters({ data: { subjectId: "math", chapterIds: [CHAPTER] } }),
    ).resolves.toEqual({ count: 1 });
    expect(mockRpc).toHaveBeenCalledWith("set_class_chapters", {
      p_subject_id: "math",
      p_chapter_ids: [CHAPTER],
    });
  });

  it("accepte une liste vide (retour à l'estimation du calendrier)", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const { setClassChapters } = await load();
    await expect(
      setClassChapters({ data: { subjectId: "math", chapterIds: [] } }),
    ).resolves.toEqual({ count: 0 });
  });

  it("refuse une entrée mal formée avant la base", async () => {
    const { setClassChapters } = await load();
    await expect(
      setClassChapters({ data: { subjectId: "math", chapterIds: ["pas-un-uuid"] } }),
    ).rejects.toThrow();
    await expect(setClassChapters({ data: { subjectId: "", chapterIds: [] } })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("freine les rafales", async () => {
    isRateLimited.mockResolvedValue(true);
    const { setClassChapters } = await load();
    await expect(
      setClassChapters({ data: { subjectId: "math", chapterIds: [CHAPTER] } }),
    ).rejects.toThrow("Trop de modifications");
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("remonte un refus de la base sans en livrer le détail", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: "Unknown chapter for this subject" },
    });
    const { setClassChapters } = await load();
    await expect(
      setClassChapters({ data: { subjectId: "math", chapterIds: [CHAPTER] } }),
    ).rejects.toThrow("Enregistrement impossible");
  });
});

describe("setStudyPreferences", () => {
  it("règle l'objectif seul : les matières ne sont pas envoyées", async () => {
    mockRpc.mockResolvedValue({ data: {}, error: null });
    const { setStudyPreferences } = await load();
    await expect(setStudyPreferences({ data: { dailyMinutes: 45 } })).resolves.toEqual({
      ok: true,
    });
    expect(mockRpc).toHaveBeenCalledWith("set_study_preferences", {
      p_daily_minutes: 45,
      p_focus_subject_ids: undefined,
    });
  });

  it("règle les matières prioritaires, liste vide comprise", async () => {
    mockRpc.mockResolvedValue({ data: {}, error: null });
    const { setStudyPreferences } = await load();
    await setStudyPreferences({ data: { focusSubjectIds: ["arabic", "french"] } });
    expect(mockRpc).toHaveBeenLastCalledWith("set_study_preferences", {
      p_daily_minutes: undefined,
      p_focus_subject_ids: ["arabic", "french"],
    });
    await setStudyPreferences({ data: { focusSubjectIds: [] } });
    expect(mockRpc).toHaveBeenLastCalledWith("set_study_preferences", {
      p_daily_minutes: undefined,
      p_focus_subject_ids: [],
    });
  });

  it("refuse avant la base un objectif sous le plancher ou une troisième matière", async () => {
    const { setStudyPreferences } = await load();
    await expect(setStudyPreferences({ data: { dailyMinutes: 20 } })).rejects.toThrow();
    await expect(
      setStudyPreferences({ data: { focusSubjectIds: ["a", "b", "c"] } }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("freine les rafales et remonte un refus sans en livrer le détail", async () => {
    isRateLimited.mockResolvedValueOnce(true);
    const { setStudyPreferences } = await load();
    await expect(setStudyPreferences({ data: { dailyMinutes: 60 } })).rejects.toThrow(
      "Trop de modifications",
    );
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: "Unknown subject for this parcours" },
    });
    await expect(setStudyPreferences({ data: { focusSubjectIds: ["x"] } })).rejects.toThrow(
      "Enregistrement impossible",
    );
  });
});
