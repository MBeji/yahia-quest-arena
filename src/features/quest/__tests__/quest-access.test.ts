// @vitest-environment node
import { describe, it, expect, vi } from "vitest";

/**
 * Accès de test sans restriction (compte admin, 2026-09-05) — `quest.access.ts`.
 * La DÉCISION est dans la RPC `start_exercise_session` (pgTAP 97) ; ici on
 * vérifie que la lecture côté server fn lit la même définition (`is_admin()`),
 * ne s'ouvre jamais par défaut, et que l'ouverture des portes affichées est pure.
 */

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { isUnrestrictedViewer, openEveryGate } from "../quest.access";

type Supabase = Parameters<typeof isUnrestrictedViewer>[0];
function supabaseWithRpc(rpc: (...args: unknown[]) => unknown): Supabase {
  return { rpc } as unknown as Supabase;
}

describe("quest.access — isUnrestrictedViewer", () => {
  it("anonyme : jamais d'accès de test, et la RPC n'est même pas appelée", async () => {
    const rpc = vi.fn();
    expect(await isUnrestrictedViewer(supabaseWithRpc(rpc), null)).toBe(false);
    expect(rpc).not.toHaveBeenCalled();
  });

  it("lit is_admin() — la définition SQL du rôle, pas une copie de la règle", async () => {
    const rpc = vi.fn().mockResolvedValue({ data: true, error: null });
    expect(await isUnrestrictedViewer(supabaseWithRpc(rpc), "u-admin")).toBe(true);
    expect(rpc).toHaveBeenCalledWith("is_admin");
  });

  it("un compte ordinaire reste ordinaire", async () => {
    const rpc = vi.fn().mockResolvedValue({ data: false, error: null });
    expect(await isUnrestrictedViewer(supabaseWithRpc(rpc), "u-student")).toBe(false);
  });

  it("fail-safe : une erreur RPC vaut accès ordinaire, jamais accès ouvert", async () => {
    const rpc = vi.fn().mockResolvedValue({ data: null, error: { message: "boom" } });
    expect(await isUnrestrictedViewer(supabaseWithRpc(rpc), "u-admin")).toBe(false);
  });

  it("fail-safe : une RPC qui lève vaut accès ordinaire", async () => {
    const rpc = vi.fn().mockRejectedValue(new Error("network down"));
    expect(await isUnrestrictedViewer(supabaseWithRpc(rpc), "u-admin")).toBe(false);
  });
});

describe("quest.access — openEveryGate", () => {
  it("marque chaque quiz passé et chaque mission éligible débloquée, sans toucher aux entrées", () => {
    const quizPassedByChapter = { c1: false, c2: true };
    const recall = {
      eligibleByExercise: { e1: 3, e2: 5 },
      unlockedByExercise: { e2: true },
      bestByExercise: { e2: 80 },
    };

    const out = openEveryGate({ quizPassedByChapter, recall });

    expect(out.quizPassedByChapter).toEqual({ c1: true, c2: true });
    expect(out.recall.unlockedByExercise).toEqual({ e1: true, e2: true });
    // Éligibilité et meilleurs scores sont du CONTENU / de l'historique : inchangés.
    expect(out.recall.eligibleByExercise).toEqual({ e1: 3, e2: 5 });
    expect(out.recall.bestByExercise).toEqual({ e2: 80 });
    // Pur : les objets d'entrée (dont le repli partagé du hub) ne sont pas mutés.
    expect(quizPassedByChapter).toEqual({ c1: false, c2: true });
    expect(recall.unlockedByExercise).toEqual({ e2: true });
  });
});
