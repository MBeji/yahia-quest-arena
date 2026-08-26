// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * « ENTRAÎNE-MOI SUR MA FAIBLESSE » — étude 11 lot 5, côté serveur.
 *
 * Le module pur (`practice.ts`) sait DÉCIDER ; ce fichier-ci vérifie que
 * l'orchestration lui donne les bons faits, dans le bon ordre, et qu'elle ne
 * décide rien elle-même.
 *
 * L'assertion qui compte est celle de Q-8 : le seuil des trois questions
 * fraîches vit en SQL (`tutor_practice_needs_generation`) et **nulle part
 * ailleurs**. Le jour où quelqu'un écrira `fresh_count >= 3` en TypeScript
 * « pour éviter une RPC », le seuil aura deux propriétaires qui divergeront —
 * exactement ce que `active_misconceptions` a dû réparer pour R-2, dont le
 * triplet avait fini recopié à quatre endroits.
 */

const { USER, mockRpc, mockMaybeSingle, mockSupabase } = vi.hoisted(() => {
  const rpc = vi.fn();
  // Le type porte la ligne ATTENDUE (et non `null` déduit de l'implémentation
  // par défaut) : sans lui, armer une Forge ouverte dans un test ne compile pas.
  type AccessRow = { enabled: boolean; features: string[] } | null;
  const maybeSingle = vi.fn(
    async (): Promise<{ data: AccessRow; error: { message: string } | null }> => ({
      data: null,
      error: null,
    }),
  );
  return {
    USER: "11111111-1111-4111-8111-111111111111",
    mockRpc: rpc,
    mockMaybeSingle: maybeSingle,
    mockSupabase: {
      rpc,
      from: () => ({ select: () => ({ eq: () => ({ maybeSingle }) }) }),
    },
  };
});

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
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: USER } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { startTargetedPractice } from "../tutor.practice.server";

const CHAPTER = "33333333-3333-4333-8333-333333333333";
const TAG = "frac.add-denominators";

function row(over: Record<string, unknown> = {}) {
  return {
    question_id: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
    exercise_id: "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb",
    chapter_id: CHAPTER,
    subject_id: "math",
    exercise_title: "Fractions — entraînement",
    difficulty: 2,
    is_fallback: false,
    fresh_count: 5,
    ...over,
  };
}

let replies: Record<string, { data: unknown; error: { message: string } | null }>;

function reply(data: unknown, error: { message: string } | null = null) {
  return { data, error };
}

beforeEach(() => {
  mockRpc.mockReset();
  // Par défaut la Forge est FERMÉE — c'est le défaut du produit (é29 R-3 :
  // « le défaut de TOUTE activation est éteint »), donc c'est le défaut ici.
  mockMaybeSingle.mockResolvedValue({ data: null, error: null });
  replies = {
    can_use_tutor: reply({ allowed: true, reason: "OK" }),
    get_targeted_exercises: reply([
      row(),
      row({ question_id: "cccccccc-cccc-4ccc-8ccc-cccccccccccc" }),
    ]),
    tutor_practice_needs_generation: reply(false),
  };
  mockRpc.mockImplementation(async (fn: string) => replies[fn] ?? reply(null));
});

const calls = (fn: string) => mockRpc.mock.calls.filter((c) => c[0] === fn);

describe("US-11 — la sélection est la voie par DÉFAUT", () => {
  it("rend les questions du stock quand il y en a", async () => {
    const out = await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } });

    // On NARROWE au lieu de caster : le jour où la fonction rendra `none` ici,
    // le test doit dire « ce n'est pas la bonne branche », pas planter sur un
    // `undefined.length` trois lignes plus bas.
    expect(out.kind).toBe("exercises");
    if (out.kind !== "exercises") return;
    expect(out.onTarget).toBe(true);
    expect(out.items).toHaveLength(2);
  });

  it("distingue une question SUR l'erreur d'une question de repli", async () => {
    replies.get_targeted_exercises = reply([row({ is_fallback: true })]);
    const out = await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } });

    expect(out.kind).toBe("exercises");
    if (out.kind !== "exercises") return;
    expect(out.items[0].isFallback).toBe(true);
  });
});

describe("⭐ Q-8 — le seuil vit en SQL, et il y reste", () => {
  it("la RPC de seuil est TOUJOURS interrogée, même avec du stock", async () => {
    // Il serait tentant de l'éviter quand `fresh_count >= 3` : ce serait faire
    // vivre le seuil de Q-8 à deux endroits.
    await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } });
    expect(calls("tutor_practice_needs_generation")).toHaveLength(1);
  });

  it("le verdict du SQL est repris TEL QUEL — la Forge quand il dit oui", async () => {
    replies.get_targeted_exercises = reply([]);
    replies.tutor_practice_needs_generation = reply(true);
    // …et seulement si la Forge est OUVERTE à cet élève. Les deux conditions,
    // pas une : un stock vide n'ouvre pas une Forge que le parent a laissée
    // éteinte (é29 R-3).
    mockMaybeSingle.mockResolvedValue({
      data: { enabled: true, features: ["forge"] },
      error: null,
    });

    const out = await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } });
    expect(out).toEqual({ kind: "forge", chapterId: CHAPTER });
  });

  it("une Forge ÉTEINTE ne s'ouvre pas parce que le stock est vide", async () => {
    replies.get_targeted_exercises = reply([]);
    replies.tutor_practice_needs_generation = reply(true);
    // Défaut du produit : pas de ligne d'activation ⇒ pas de Forge.
    expect(await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } })).toEqual({
      kind: "none",
      reason: "no-material",
    });
  });

  it("du matériel de REPLI vaut mieux que « rien à te proposer »", async () => {
    // La branche qu'une lecture littérale du brief oublierait : un élève avec
    // une question de repli a de quoi travailler. `onTarget: false` oblige
    // l'écran à l'annoncer honnêtement, mais on ne jette pas le matériel.
    replies.get_targeted_exercises = reply([row({ is_fallback: true, fresh_count: 1 })]);
    replies.tutor_practice_needs_generation = reply(true);

    expect(await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } })).toMatchObject({
      kind: "exercises",
      onTarget: false,
    });
  });

  it("sans chapitre, on ne forge pas — et on le DIT", async () => {
    // `get_forge_context` est chapitre-seule : promettre une génération sans
    // chapitre serait promettre ce que rien ne tient.
    replies.get_targeted_exercises = reply([]);
    replies.tutor_practice_needs_generation = reply(true);

    const out = await startTargetedPractice({ data: { tag: TAG } });
    expect(out).toMatchObject({ kind: "none" });
  });
});

describe("R-1 et R-15 — les refus", () => {
  it("une porte fermée est un ÉTAT, avec sa raison", async () => {
    replies.can_use_tutor = reply({ allowed: false, reason: "ACTIVE_DUEL" });
    expect(await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } })).toEqual({
      kind: "locked",
      reason: "ACTIVE_DUEL",
    });
  });

  it("une porte illisible est une porte fermée", async () => {
    replies.can_use_tutor = reply(null, { message: "boom" });
    expect(await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } })).toEqual({
      kind: "locked",
      reason: "UNKNOWN",
    });
  });

  it("sans chapitre, la porte n'est pas interrogée — il n'y a pas de session à juger", async () => {
    replies.get_targeted_exercises = reply([row({ chapter_id: null })]);
    await startTargetedPractice({ data: { tag: TAG } });
    expect(calls("can_use_tutor")).toHaveLength(0);
  });

  it("une sélection en panne dégrade au lieu de casser l'écran", async () => {
    replies.get_targeted_exercises = reply(null, { message: "boom" });
    expect(await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } })).toEqual({
      kind: "none",
      reason: "no-material",
    });
  });

  it("« pas de génération » vaut toujours « joue le stock », même vide", async () => {
    // Combinaison que le SQL ne produit PAS — c'est la même requête qui rend les
    // lignes et le verdict, donc zéro ligne implique `needsGeneration = true`.
    // On la fige quand même : le jour où les deux se sépareraient, ce test dirait
    // laquelle des deux branches a bougé.
    replies.get_targeted_exercises = reply([]);
    replies.tutor_practice_needs_generation = reply(false);
    expect(await startTargetedPractice({ data: { tag: TAG, chapterId: CHAPTER } })).toMatchObject({
      kind: "exercises",
      onTarget: true,
    });
  });
});
