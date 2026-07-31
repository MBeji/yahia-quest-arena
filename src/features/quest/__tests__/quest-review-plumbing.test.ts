import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

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
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));
vi.mock("@tanstack/react-start/server", () => ({
  getRequest: vi.fn(() => ({ headers: new Headers() })),
}));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
  isRateLimitedLocal: vi.fn().mockReturnValue(false),
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of ["select", "eq", "order", "limit", "insert", "in", "gte", "not", "neq"]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.then = (fn: (v: unknown) => unknown) => fn(result);
  Object.assign(chain, result);
  return chain;
}

const SESSION_ID = "22222222-2222-2222-2222-222222222222";
const EXERCISE_ID = "11111111-1111-1111-1111-111111111111";
const Q1_ID = "33333333-3333-3333-3333-333333333333";
const Q2_ID = "44444444-4444-4444-4444-444444444444";

/**
 * Étude 04 lot A1.2b — le CÂBLAGE de l'erreur nommée, de la RPC jusqu'à l'écran.
 *
 * Le serveur décide seul (quel tag, pour quel choix, et rien sur une bonne
 * réponse) : c'est prouvé en pgTAP par le lot A1.2a. Ici on prouve l'autre
 * moitié — que sa décision ARRIVE, sans être perdue en route ni re-jugée par le
 * client. Le rendu, lui, vit dans `quest-review-mistake.test.tsx`.
 */
describe("submitAttempt — remontée de l'erreur nommée (A1.2b)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("fait remonter misconception_tag et chapter_id jusqu'à la correction (A1.2b)", async () => {
    const reviewRows = [
      {
        question_id: Q1_ID,
        prompt: "1/2 + 1/3 ?",
        correct_option: "a",
        explanation: "Même dénominateur.",
        is_correct: false,
        misconception_tag: "math.frac.add-denominators",
        chapter_id: "chap-1",
      },
      // Question taguée nulle part : la ligne remonte quand même (R-A1.2-3).
      {
        question_id: Q2_ID,
        prompt: "3+3?",
        correct_option: "6",
        explanation: null,
        is_correct: true,
        misconception_tag: null,
        chapter_id: "chap-1",
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      if (table === "misconceptions")
        return mockQuery([
          {
            tag: "math.frac.add-denominators",
            label_fr: "Tu additionnes les dénominateurs",
            label_en: "You add the denominators",
            label_ar: "تجمع المقامات",
          },
        ]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation((name: string) => {
      if (name === "get_attempt_review") return { data: reviewRows, error: null };
      return {
        data: { correct: 1, total: 2, scorePct: 50, xpEarned: 10, coinsEarned: 2 },
        error: null,
      };
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [
        { questionId: Q1_ID, choice: "b" },
        { questionId: Q2_ID, choice: "6" },
      ],
    });

    const review = (result as Record<string, unknown>).review as Array<{
      misconceptionTag: string | null;
      chapterId: string | null;
    }>;
    expect(review[0].misconceptionTag).toBe("math.frac.add-denominators");
    expect(review[0].chapterId).toBe("chap-1");
    expect(review[1].misconceptionTag).toBeNull();
  });

  // A1.2b — le tag devient une phrase. Les TROIS langues remontent : mettre en
  // langue est une décision de rendu, pas de serveur (même règle qu'é07).
  it("met le tag en mots depuis le vocabulaire versionné (A1.2b)", async () => {
    const reviewRows = [
      {
        question_id: Q1_ID,
        prompt: "1/2 + 1/3 ?",
        correct_option: "a",
        explanation: null,
        is_correct: false,
        misconception_tag: "math.frac.add-denominators",
        chapter_id: "chap-1",
      },
    ];
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      if (table === "misconceptions")
        return mockQuery([
          {
            tag: "math.frac.add-denominators",
            label_fr: "Tu additionnes les dénominateurs",
            label_en: "You add the denominators",
            label_ar: "تجمع المقامات",
          },
        ]);
      return mockQuery([]);
    });
    mockRpc.mockImplementation((name: string) => {
      if (name === "get_attempt_review") return { data: reviewRows, error: null };
      return { data: { correct: 0, total: 1, scorePct: 0 }, error: null };
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "b" }],
    });

    const review = (result as Record<string, unknown>).review as Array<{
      misconceptionLabels: { fr: string; en: string; ar: string } | null;
    }>;
    expect(review[0].misconceptionLabels).toEqual({
      fr: "Tu additionnes les dénominateurs",
      en: "You add the denominators",
      ar: "تجمع المقامات",
    });
  });

  it("vocabulaire MUET ou illisible : la correction vit quand même (R-A1.2-3)", async () => {
    const reviewRows = [
      {
        question_id: Q1_ID,
        prompt: "1/2 + 1/3 ?",
        correct_option: "a",
        explanation: "Même dénominateur.",
        is_correct: false,
        misconception_tag: "math.frac.add-denominators",
        chapter_id: "chap-1",
      },
    ];
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      // La table répond en erreur (fenêtre de déploiement, droits, réseau).
      if (table === "misconceptions")
        return mockQuery(null, { message: "relation does not exist" });
      return mockQuery([]);
    });
    mockRpc.mockImplementation((name: string) => {
      if (name === "get_attempt_review") return { data: reviewRows, error: null };
      return { data: { correct: 0, total: 1, scorePct: 0 }, error: null };
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "b" }],
    });

    const review = (result as Record<string, unknown>).review as Array<{
      misconceptionTag: string | null;
      misconceptionLabels: unknown;
      explanation: string | null;
    }>;
    // Le tag et l'explication survivent : seule la PHRASE manque.
    expect(review[0].misconceptionLabels).toBeNull();
    expect(review[0].misconceptionTag).toBe("math.frac.add-denominators");
    expect(review[0].explanation).toBe("Même dénominateur.");
  });

  it("une correction SANS les colonnes A1.2a ne casse pas (fenêtre de déploiement)", async () => {
    // La migration part avant le client (DoD §7), mais l'inverse doit rester sûr :
    // un serveur d'avant A1.2a rend des lignes sans ces colonnes.
    const reviewRows = [
      { question_id: Q1_ID, prompt: "2+2?", correct_option: "4", explanation: null },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ mode: "practice" });
      return mockQuery([]);
    });
    mockRpc.mockImplementation((name: string) => {
      if (name === "get_attempt_review") return { data: reviewRows, error: null };
      return { data: { correct: 1, total: 1, scorePct: 100 }, error: null };
    });

    const { submitAttempt } = await import("@/features/quest");
    const result = await (submitAttempt as unknown as (d: unknown) => Promise<unknown>)({
      sessionId: SESSION_ID,
      exerciseId: EXERCISE_ID,
      answers: [{ questionId: Q1_ID, choice: "4" }],
    });

    const review = (result as Record<string, unknown>).review as Array<{
      misconceptionTag: string | null;
      chapterId: string | null;
    }>;
    expect(review[0].misconceptionTag).toBeNull();
    expect(review[0].chapterId).toBeNull();
  });
});
