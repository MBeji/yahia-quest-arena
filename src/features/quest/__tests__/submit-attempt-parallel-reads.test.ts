// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

// =============================================================================
// SOUMISSION : LES QUATRE LECTURES PRÉPARATOIRES PARTENT ENSEMBLE (perf, 2026-10-31)
//
// Avant : rate limit → types des questions → réponses figées → mode, quatre
// allers-retours EN SÉRIE pour ~1 ms de SQL, soit 20 à 40 ms d'attente par
// soumission (l'écriture la plus fréquente). Elles n'ont aucune dépendance entre
// elles : ce fichier verrouille qu'elles sont toutes EN VOL avant qu'aucune n'ait
// répondu, et que la précédence des refus reste celle d'avant — le débit dépassé
// l'emporte sur la réponse mal formée, et rien ne s'écrit quand il est dépassé.
// =============================================================================

const { mockFrom, mockRpc, mockIsRateLimited } = vi.hoisted(() => ({
  mockFrom: vi.fn(),
  mockRpc: vi.fn(),
  mockIsRateLimited: vi.fn(),
}));
const mockSupabase = { from: mockFrom, rpc: mockRpc };

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
        return async (input: unknown) =>
          handlerFn({
            data: validatorFn ? validatorFn(input) : input,
            context: { supabase: mockSupabase, userId: "user-123" },
          });
      },
    };
    return chain;
  },
}));
vi.mock("@tanstack/react-start/server", () => ({
  getRequest: vi.fn(() => ({ headers: new Headers() })),
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: (...args: unknown[]) => mockIsRateLimited(...args),
  isRateLimitedLocal: vi.fn().mockReturnValue(false),
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { submitAttempt } from "@/features/quest";

const submit = submitAttempt as unknown as (d: unknown) => Promise<Record<string, unknown>>;

const EXERCISE_ID = "22222222-2222-2222-2222-222222222222";
const SESSION_ID = "11111111-1111-1111-1111-111111111111";
const Q1 = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";

/** Ce que chaque table répond, dans le décor minimal d'une soumission. */
function rowsOf(table: string): unknown {
  if (table === "exercises") return { mode: "practice" };
  if (table === "questions") return [{ id: Q1, question_type: "numeric" }];
  return [];
}

/**
 * Une requête PostgREST thenable. Avec `release`, elle ne RÉPOND que quand le
 * test la libère : c'est ce qui permet d'observer combien de lectures sont en vol
 * en même temps. Sans, elle répond au tic suivant, comme un réseau instantané.
 */
function query(data: unknown, release?: Array<() => void>) {
  const result = { data, error: null };
  const chain: Record<string, unknown> = {
    then: (resolve: (v: unknown) => unknown) => {
      if (release) release.push(() => resolve(result));
      else queueMicrotask(() => resolve(result));
    },
  };
  for (const method of ["select", "eq", "in", "order", "limit", "single", "maybeSingle"]) {
    chain[method] = vi.fn().mockReturnValue(chain);
  }
  return chain;
}

const SUBMISSION = {
  sessionId: SESSION_ID,
  exerciseId: EXERCISE_ID,
  answers: [{ questionId: Q1, choice: "4" }],
};

beforeEach(() => {
  mockFrom.mockReset();
  mockRpc.mockReset();
  mockIsRateLimited.mockReset();
  mockRpc.mockReturnValue({ data: null, error: null });
});

describe("submitAttempt — les lectures préparatoires partent ensemble", () => {
  it("rate limit, types, réponses figées et mode sont en vol avant qu'aucun n'ait répondu", async () => {
    const release: Array<() => void> = [];
    const issued: string[] = [];
    mockRpc.mockImplementation((name: string) => ({
      data:
        name === "submit_exercise_attempt"
          ? {
              correct: 1,
              total: 1,
              scorePct: 100,
              xpEarned: 10,
              coinsEarned: 1,
              durationSeconds: 9,
            }
          : [],
      error: null,
    }));
    mockIsRateLimited.mockImplementation(
      () => new Promise<boolean>((resolve) => release.push(() => resolve(false))),
    );
    mockFrom.mockImplementation((table: string) => {
      issued.push(table);
      return query(rowsOf(table), release);
    });

    const pending = submit(SUBMISSION);

    // En série, seule la première partirait ; ici les quatre attendent ensemble.
    await vi.waitFor(() => expect(release).toHaveLength(4));
    expect(mockIsRateLimited).toHaveBeenCalledTimes(1);
    expect(issued.sort()).toEqual(["exercise_session_reveals", "exercises", "questions"]);
    expect(mockRpc).not.toHaveBeenCalled();

    for (const answer of release) answer();
    await expect(pending).resolves.toBeDefined();
    expect(mockRpc).toHaveBeenCalledWith("submit_exercise_attempt", expect.anything());
  });

  it("débit dépassé : refus avant tout examen des autres lectures, et aucune écriture", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    mockFrom.mockImplementation((table: string) => query(rowsOf(table)));

    await expect(
      submit({ ...SUBMISSION, answers: [{ questionId: Q1, choice: "abc" }] }),
    ).rejects.toThrow("Too many submissions. Please slow down.");
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("débit libre : la réponse mal formée est refusée avant toute RPC, comme avant", async () => {
    mockIsRateLimited.mockResolvedValue(false);
    mockFrom.mockImplementation((table: string) => query(rowsOf(table)));

    await expect(
      submit({ ...SUBMISSION, answers: [{ questionId: Q1, choice: "abc" }] }),
    ).rejects.toThrow("Réponse invalide pour ce type de question.");
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
