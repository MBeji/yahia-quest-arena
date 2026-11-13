// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * `getAttemptProgress` (étude 34, lot 4) — le delta d'une soumission : étoiles,
 * sceau, badges. Lue APRÈS le résultat ; une lecture ratée rend `null`, et l'écran
 * se tait. Jusqu'ici aucun test ne l'appelait (couverture 9 %).
 */
const mockRpc = vi.fn();

vi.mock("@tanstack/react-start", () => ({
  createServerFn: () => {
    let validate: (d: unknown) => unknown = (d) => d;
    const chain = {
      middleware: () => chain,
      validator: (fn: (d: unknown) => unknown) => {
        validate = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => async (input: unknown) =>
        fn({ data: validate(input), context: { supabase: { rpc: mockRpc }, userId: "user-1" } }),
    };
    return chain;
  },
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
const { mockWarn } = vi.hoisted(() => ({ mockWarn: vi.fn() }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: mockWarn, info: vi.fn(), debug: vi.fn() },
}));

import { getAttemptProgress } from "../quest.progress.server";

const read = getAttemptProgress as unknown as (input: unknown) => Promise<unknown>;
const EXERCISE = "11111111-1111-4111-8111-111111111111";

beforeEach(() => {
  mockRpc.mockReset();
  mockWarn.mockReset();
});

describe("quest — getAttemptProgress", () => {
  it("rend le delta de la DERNIÈRE tentative sur l'exercice, tel que la base le décrit", async () => {
    const delta = { stars: { chapterId: "c1", gained: 1 }, seal: null, badges: ["first-quest"] };
    mockRpc.mockResolvedValue({ data: delta, error: null });

    await expect(read({ exerciseId: EXERCISE })).resolves.toEqual(delta);
    expect(mockRpc).toHaveBeenCalledWith("get_last_attempt_progress", {
      p_exercise_id: EXERCISE,
    });
  });

  it("rend null quand rien n'est tombé", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });

    await expect(read({ exerciseId: EXERCISE })).resolves.toBeNull();
  });

  it("se tait sur une RPC en échec — une célébration inventée vaut moins que rien", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });

    await expect(read({ exerciseId: EXERCISE })).resolves.toBeNull();
    expect(mockWarn).toHaveBeenCalledWith("quest.getAttemptProgress: RPC failed", {
      exerciseId: EXERCISE,
      error: "boom",
    });
  });

  it("se tait aussi quand l'appel lève (réseau coupé)", async () => {
    mockRpc.mockRejectedValue(new Error("fetch failed"));

    await expect(read({ exerciseId: EXERCISE })).resolves.toBeNull();
    expect(mockWarn).toHaveBeenCalledWith("quest.getAttemptProgress: RPC threw", {
      exerciseId: EXERCISE,
      error: "fetch failed",
    });
  });

  it("refuse un identifiant qui n'est pas un uuid avant d'appeler la base", async () => {
    await expect(read({ exerciseId: "pas-un-uuid" })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });
});
