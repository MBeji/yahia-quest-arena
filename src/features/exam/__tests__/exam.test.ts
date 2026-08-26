// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 02 — la couche serveur de l'examen blanc.
 *
 * Ce que ces tests gardent, et qui n'est pas testable en pgTAP : la TRADUCTION.
 * Les RPC signalent leurs refus par un code dans le message d'exception
 * (`MOCK_EXAM_ALREADY_RANKED`…). Si la table de correspondance se désaligne,
 * l'élève reçoit un code SQL en pleine figure — ou pire, un message générique
 * qui masque une règle du jeu qu'il aurait dû comprendre.
 *
 * Et le repli tableau → objet de `saveMockAnswers` : c'est lui qui rend la
 * sauvegarde idempotente côté SQL (R-8). Une régression ici ne casse rien
 * visiblement — elle duplique des réponses.
 */

const mockRpc = vi.fn();
const mockSupabase = { rpc: mockRpc };

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
        // Les vraies server fns s'appellent fn({ data: payload }) : on déballe
        // l'enveloppe pour que le validateur zod voie le payload brut, comme en prod.
        return async (input: unknown) => {
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
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

const mockIsRateLimited = vi.fn().mockResolvedValue(false);
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: (...args: unknown[]) => mockIsRateLimited(...args),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

type AnyFn = (d?: unknown) => Promise<unknown>;

const EXAM_ID = "11111111-1111-4111-8111-111111111111";
const SESSION_ID = "22222222-2222-4222-8222-222222222222";
const QUESTION_ID = "33333333-3333-4333-8333-333333333333";

const START_PAYLOAD = {
  session: {
    id: SESSION_ID,
    kind: "ranked",
    startedAt: "2026-08-16T10:00:00Z",
    deadline: "2026-08-16T11:30:00Z",
    finishedAt: null,
    answers: {},
  },
  serverNow: "2026-08-16T10:00:01Z",
  exam: {
    id: EXAM_ID,
    parcoursId: "concours-9eme",
    titleFr: "Concours blanc 9ᵉ",
    titleEn: null,
    titleAr: null,
    durationMinutes: 90,
  },
  papers: [
    {
      exerciseId: "44444444-4444-4444-8444-444444444444",
      labelFr: "Mathématiques",
      labelEn: null,
      labelAr: null,
      points: 40,
      subjectId: "math",
      questions: [
        {
          id: QUESTION_ID,
          prompt: "2 + 2 ?",
          options: [
            { id: "a", text: "3" },
            { id: "b", text: "4" },
          ],
          questionType: "mcq",
        },
      ],
    },
  ],
};

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  mockIsRateLimited.mockReset().mockResolvedValue(false);
});

describe("startMockExam", () => {
  it("ouvre une session et rend les épreuves sans clé de réponse", async () => {
    mockRpc.mockResolvedValue({ data: START_PAYLOAD, error: null });
    const { startMockExam } = await import("@/features/exam");

    const res = (await (startMockExam as unknown as AnyFn)({
      data: { examId: EXAM_ID, kind: "ranked" },
    })) as typeof START_PAYLOAD;

    expect(mockRpc).toHaveBeenCalledWith("start_mock_exam", {
      p_exam_id: EXAM_ID,
      p_kind: "ranked",
    });
    expect(res.papers).toHaveLength(1);
    expect(JSON.stringify(res)).not.toMatch(/correctOption|explanation|answer_key/);
  });

  it("traduit le refus d'une seconde session classée (R-4)", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: 'raise exception "MOCK_EXAM_ALREADY_RANKED"' },
    });
    const { startMockExam } = await import("@/features/exam");

    await expect(
      (startMockExam as unknown as AnyFn)({ data: { examId: EXAM_ID, kind: "ranked" } }),
    ).rejects.toThrow(/déjà passé cet examen en mode classé/);
  });

  it("ne fuit pas le détail d'une erreur SQL inconnue", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: 'column "secret_column" does not exist' },
    });
    const { startMockExam } = await import("@/features/exam");

    await expect(
      (startMockExam as unknown as AnyFn)({ data: { examId: EXAM_ID, kind: "ranked" } }),
    ).rejects.toThrow(/Impossible d'ouvrir l'examen/);
    await expect(
      (startMockExam as unknown as AnyFn)({ data: { examId: EXAM_ID, kind: "ranked" } }),
    ).rejects.not.toThrow(/secret_column/);
  });

  it("refuse un examen dont l'identifiant n'est pas un uuid", async () => {
    const { startMockExam } = await import("@/features/exam");
    await expect(
      (startMockExam as unknown as AnyFn)({ data: { examId: "pas-un-uuid", kind: "ranked" } }),
    ).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("s'arrête au rate-limit sans toucher à la base", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    const { startMockExam } = await import("@/features/exam");

    await expect(
      (startMockExam as unknown as AnyFn)({ data: { examId: EXAM_ID, kind: "ranked" } }),
    ).rejects.toThrow(/Trop d'ouvertures/);
    expect(mockRpc).not.toHaveBeenCalled();
  });
});

describe("saveMockAnswers", () => {
  it("replie le tableau en objet — c'est ce qui rend la fusion SQL idempotente", async () => {
    mockRpc.mockResolvedValue({
      data: { answered: 2, deadline: "2026-08-16T11:30:00Z", serverNow: "2026-08-16T10:05:00Z" },
      error: null,
    });
    const { saveMockAnswers } = await import("@/features/exam");

    await (saveMockAnswers as unknown as AnyFn)({
      data: {
        sessionId: SESSION_ID,
        answers: [
          { questionId: QUESTION_ID, choice: "a" },
          // La même question renvoyée plus tard : seule la DERNIÈRE compte.
          { questionId: QUESTION_ID, choice: "b" },
        ],
      },
    });

    expect(mockRpc).toHaveBeenCalledWith("save_mock_answers", {
      p_session_id: SESSION_ID,
      p_answers: { [QUESTION_ID]: "b" },
    });
  });

  it("traduit le dépassement de la deadline (R-2)", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: "MOCK_EXAM_DEADLINE_PASSED" },
    });
    const { saveMockAnswers } = await import("@/features/exam");

    await expect(
      (saveMockAnswers as unknown as AnyFn)({
        data: { sessionId: SESSION_ID, answers: [{ questionId: QUESTION_ID, choice: "a" }] },
      }),
    ).rejects.toThrow(/temps est écoulé/);
  });
});

describe("finishMockExam", () => {
  it("rend la note /20 telle que le serveur l'a calculée", async () => {
    mockRpc.mockResolvedValue({
      data: {
        sessionId: SESSION_ID,
        kind: "ranked",
        finishedAt: "2026-08-16T11:00:00Z",
        scorePoints: 30,
        maxPoints: 50,
        scorePct: 60,
        scoreOn20: 12,
        xpEarned: 180,
        coinsEarned: 36,
        papers: [],
      },
      error: null,
    });
    const { finishMockExam } = await import("@/features/exam");

    const res = (await (finishMockExam as unknown as AnyFn)({
      data: { sessionId: SESSION_ID },
    })) as { scoreOn20: number; xpEarned: number };

    expect(res.scoreOn20).toBe(12);
    expect(res.xpEarned).toBe(180);
  });

  it("signale une forme de réponse inattendue au lieu d'afficher une note partielle", async () => {
    mockRpc.mockResolvedValue({ data: { sessionId: SESSION_ID }, error: null });
    const { finishMockExam } = await import("@/features/exam");

    await expect(
      (finishMockExam as unknown as AnyFn)({ data: { sessionId: SESSION_ID } }),
    ).rejects.toThrow(/Réponse inattendue/);
  });
});

describe("getMockExamReview", () => {
  it("traduit le refus d'ouvrir le corrigé avant le rendu (R-3)", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "MOCK_EXAM_NOT_FINISHED" } });
    const { getMockExamReview } = await import("@/features/exam");

    await expect(
      (getMockExamReview as unknown as AnyFn)({ data: { sessionId: SESSION_ID } }),
    ).rejects.toThrow(/corrigé s'ouvre une fois la copie rendue/);
  });
});

describe("getMockExamPercentile", () => {
  it("accepte un rang absent sous le seuil de candidats (R-6)", async () => {
    mockRpc.mockResolvedValue({
      data: { candidates: 3, minCandidates: 20, percentile: null },
      error: null,
    });
    const { getMockExamPercentile } = await import("@/features/exam");

    const res = (await (getMockExamPercentile as unknown as AnyFn)({
      data: { sessionId: SESSION_ID },
    })) as { percentile: number | null; candidates: number };

    expect(res.percentile).toBeNull();
    expect(res.candidates).toBe(3);
  });
});
