// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * L'écriture d'un pouls. Deux invariants sont testés ici parce que leur
 * violation serait invisible à l'œil nu :
 *   * une panne de télémétrie ne remonte JAMAIS dans l'écran appelant ;
 *   * une valeur hors bornes est refusée avant d'atteindre la base (le serveur
 *     ré-écrête de son côté, mais rien ne doit compter sur ça).
 */

const mockRpc = vi.fn();
const mockSupabase = { rpc: mockRpc };
// `vi.hoisted` : ces deux espions sont consommés au moment où la fabrique de
// mock construit le module, donc AVANT l'évaluation du corps du fichier.
const { isRateLimited, warn } = vi.hoisted(() => ({
  isRateLimited: vi.fn(),
  warn: vi.fn(),
}));

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
            context: { supabase: mockSupabase, userId: "student-1" },
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
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn, info: vi.fn(), debug: vi.fn() },
}));

import { recordLearningPulse } from "../learning-pulse.server";

// Le harnais ci-dessus court-circuite `createServerFn` : la fonction exportée
// reçoit directement la charge utile, sans l'enveloppe `{ data }` du client.
const pulse = recordLearningPulse as unknown as (
  data: Record<string, unknown>,
) => Promise<{ credited: number }>;

describe("recordLearningPulse", () => {
  beforeEach(() => {
    mockRpc.mockReset();
    isRateLimited.mockResolvedValue(false);
    warn.mockClear();
  });

  it("transmet le pouls et rend les secondes créditées par le serveur", async () => {
    mockRpc.mockResolvedValue({ data: 55, error: null });

    const result = await pulse({
      surface: "lesson",
      activeSeconds: 60,
      subjectId: "math-6",
      chapterId: "11111111-1111-4111-8111-111111111111",
      progressPct: 73,
    });

    expect(result).toEqual({ credited: 55 });
    expect(mockRpc).toHaveBeenCalledWith("record_learning_pulse", {
      p_surface: "lesson",
      p_active_seconds: 60,
      p_subject: "math-6",
      p_chapter: "11111111-1111-4111-8111-111111111111",
      p_exercise: undefined,
      p_progress_pct: 73,
    });
  });

  it("refuse une surface inconnue ou une durée hors bornes", async () => {
    await expect(pulse({ surface: "tiktok", activeSeconds: 60 })).rejects.toThrow();
    await expect(pulse({ surface: "lesson", activeSeconds: 99_999 })).rejects.toThrow();
    await expect(pulse({ surface: "lesson", activeSeconds: 1 })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("ne fait rien de plus quand la cadence est dépassée", async () => {
    isRateLimited.mockResolvedValue(true);

    const result = await pulse({ surface: "duel", activeSeconds: 60 });

    expect(result).toEqual({ credited: 0 });
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("avale une erreur serveur : la télémétrie ne casse pas l'écran", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });

    const result = await pulse({ surface: "exercise", activeSeconds: 30 });

    expect(result).toEqual({ credited: 0 });
    expect(warn).toHaveBeenCalled();
  });
});
