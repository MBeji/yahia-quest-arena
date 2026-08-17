import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * Les deux server fns du tableau de bord quotidien. Le contrôle d'accès vit dans
 * les RPC SECURITY DEFINER (il ne peut pas être testé ici) ; ce qui se teste ici,
 * c'est ce dont dépend l'écran : la validation d'entrée, le passage exact des
 * paramètres, et le fait qu'une charge utile abîmée n'explose pas côté client.
 */

const mockRpc = vi.fn();
const mockSupabase = { rpc: mockRpc, from: vi.fn() };

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
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "parent-1" },
          });
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
  optionalSupabaseAuth: "mock-optional-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: vi.fn().mockResolvedValue(false) }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import {
  getStudentAttemptDetail,
  getStudentAttemptDetailByCode,
  getStudentDailyReport,
  getStudentDailyReportByCode,
} from "../parent-report.server";

const STUDENT = "22222222-2222-4222-8222-222222222222";
const ATTEMPT = "33333333-3333-4333-8333-333333333333";

// Le harnais ci-dessus court-circuite `createServerFn` : la fonction exportée
// reçoit directement la charge utile, sans l'enveloppe `{ data }` du client.
type Call = (data: Record<string, unknown>) => Promise<Record<string, unknown>>;
const dailyReport = getStudentDailyReport as unknown as Call;
const attemptDetail = getStudentAttemptDetail as unknown as Call;

describe("getStudentDailyReport", () => {
  beforeEach(() => mockRpc.mockReset());

  it("passe la période telle quelle à la RPC", async () => {
    mockRpc.mockResolvedValue({ data: {}, error: null });

    await dailyReport({ studentId: STUDENT, from: "2026-08-01", to: "2026-08-07" });

    expect(mockRpc).toHaveBeenCalledWith("get_student_daily_report", {
      p_student: STUDENT,
      p_from: "2026-08-01",
      p_to: "2026-08-07",
      // Le périmètre par défaut, explicite : le typage de .rpc() ne contrôle PAS
      // les noms d arguments, ces assertions sont le seul filet.
      p_scope: "all",
    });
  });

  // Le filtre demandé en production : « si mon fils est en 9ème, je veux voir son
  // activité par rapport à sa classe uniquement ». Le périmètre voyage jusqu'à la
  // RPC, qui seule sait quelles matières composent sa classe.
  it("transmet le périmètre « sa classe » quand il est demandé", async () => {
    mockRpc.mockResolvedValue({ data: {}, error: null });

    await dailyReport({
      studentId: STUDENT,
      from: "2026-08-01",
      to: "2026-08-07",
      scope: "class",
    });

    expect(mockRpc.mock.calls[0][1]).toMatchObject({ p_scope: "class" });
  });

  // Le périmètre n'est plus un jeu fermé — les niveaux et les thèmes sont des
  // données. C'est sa FORME qui est contrôlée ici ; la RPC, elle, dégrade vers
  // « tout » sur une clé qui ne désigne plus rien.
  it.each([
    ["all", true],
    ["class", true],
    ["grade:99999999-9999-4999-8999-999999999991", true],
    ["theme:education-islamique", true],
    ["9eme", false],
    ["grade:pas-un-uuid", false],
    ["theme:MAJUSCULES", false],
    ["grade:99999999-9999-4999-8999-999999999991; DROP TABLE attempts", false],
  ])("périmètre « %s » accepté ? %s", async (scope, accepted) => {
    mockRpc.mockResolvedValue({ data: {}, error: null });

    const run = dailyReport({
      studentId: STUDENT,
      from: "2026-08-01",
      to: "2026-08-07",
      scope,
    });

    if (accepted) {
      await run;
      expect(mockRpc.mock.calls[0][1]).toMatchObject({ p_scope: scope });
    } else {
      await expect(run).rejects.toThrow();
      expect(mockRpc).not.toHaveBeenCalled();
    }
  });

  it("refuse une date qui n'est pas une date de calendrier", async () => {
    await expect(
      dailyReport({ studentId: STUDENT, from: "hier", to: "2026-08-07" }),
    ).rejects.toThrow();
    await expect(
      dailyReport({ studentId: "pas-un-uuid", from: "2026-08-01", to: "2026-08-07" }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("normalise une charge utile incomplète au lieu de casser l'écran", async () => {
    mockRpc.mockResolvedValue({
      data: { totals: { appMinutes: "90" }, days: null, subjects: "oops" },
      error: null,
    });

    const report = await dailyReport({
      studentId: STUDENT,
      from: "2026-08-01",
      to: "2026-08-07",
    });

    expect(report.totals).toMatchObject({ appMinutes: 90, exercises: 0 });
    expect(report.days).toEqual([]);
    expect(report.subjects).toEqual([]);
  });

  it("remonte une erreur RPC en message client", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "Access denied." } });

    await expect(
      dailyReport({ studentId: STUDENT, from: "2026-08-01", to: "2026-08-07" }),
    ).rejects.toThrow(/Impossible de charger l'activité/);
  });
});

describe("getStudentAttemptDetail", () => {
  beforeEach(() => mockRpc.mockReset());

  it("rend les réponses de l'enfant, correction comprise", async () => {
    mockRpc.mockResolvedValue({
      data: {
        attemptId: ATTEMPT,
        exerciseTitle: "Fractions",
        mode: "practice",
        reviewHidden: false,
        questions: [
          {
            questionId: "q1",
            order: 1,
            prompt: "1/2 + 1/2 = ?",
            questionType: "mcq",
            options: [
              { id: "a", text: "1" },
              { id: "b", text: "2/4" },
            ],
            answer: "b",
            isCorrect: false,
            correctOption: "a",
            explanation: "On additionne les numérateurs.",
          },
        ],
      },
      error: null,
    });

    const detail = await attemptDetail({ studentId: STUDENT, attemptId: ATTEMPT });

    expect(detail.reviewHidden).toBe(false);
    expect(detail.questions).toHaveLength(1);
    expect((detail.questions as { answer: string }[])[0].answer).toBe("b");
  });

  it("accepte un quiz dont la correction est masquée par le serveur", async () => {
    mockRpc.mockResolvedValue({
      data: {
        attemptId: ATTEMPT,
        mode: "quiz",
        reviewHidden: true,
        questions: [
          {
            questionId: "q1",
            order: 1,
            prompt: "…",
            questionType: "mcq",
            options: [],
            answer: "c",
            isCorrect: true,
            correctOption: null,
            explanation: null,
          },
        ],
      },
      error: null,
    });

    const detail = await attemptDetail({ studentId: STUDENT, attemptId: ATTEMPT });

    expect(detail.reviewHidden).toBe(true);
    expect((detail.questions as { correctOption: string | null }[])[0].correctOption).toBeNull();
  });

  it("refuse un identifiant de tentative mal formé", async () => {
    await expect(attemptDetail({ studentId: STUDENT, attemptId: "42" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});

/**
 * Le chemin PUBLIC par code alliance (décision produit du 2026-08-16). Ce qui se
 * teste ici est le CÂBLAGE : le code part bien tel quel vers la RPC, qui porte
 * seule le décodage et la vérification « c'est bien un élève ». Rien du contrôle
 * d'accès n'est côté client — c'est précisément l'invariant.
 */
describe("les variantes par code alliance", () => {
  beforeEach(() => mockRpc.mockReset());

  const dailyByCode = getStudentDailyReportByCode as unknown as Call;
  const detailByCode = getStudentAttemptDetailByCode as unknown as Call;
  const CODE = "1111111111114111811111111111111A";

  it("transmet le code et la période sans les réinterpréter", async () => {
    mockRpc.mockResolvedValue({ data: {}, error: null });

    await dailyByCode({ studentCode: CODE, from: "2026-08-01", to: "2026-08-07" });

    expect(mockRpc).toHaveBeenCalledWith("get_student_daily_report_by_code", {
      p_code: CODE,
      p_from: "2026-08-01",
      p_to: "2026-08-07",
      p_scope: "all",
    });
  });

  it("remonte l'échec du code en code d'erreur stable, traduisible côté client", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: "This code does not belong to a student account." },
    });

    await expect(
      dailyByCode({ studentCode: CODE, from: "2026-08-01", to: "2026-08-07" }),
    ).rejects.toThrow(/REPORT_CODE_/);
  });

  it("sert aussi le détail d'une tentative", async () => {
    mockRpc.mockResolvedValue({ data: { attemptId: ATTEMPT, questions: [] }, error: null });

    const detail = await detailByCode({ studentCode: CODE, attemptId: ATTEMPT });

    expect(mockRpc).toHaveBeenCalledWith("get_student_attempt_detail_by_code", {
      p_code: CODE,
      p_attempt: ATTEMPT,
    });
    expect(detail.questions).toEqual([]);
  });

  it("refuse un code trop court avant tout appel", async () => {
    await expect(
      dailyByCode({ studentCode: "abc", from: "2026-08-01", to: "2026-08-07" }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
