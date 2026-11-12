// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * Étude 38, lot 2 — le parcours (la classe) d'un exercice.
 *
 * `resolveSubjectParcours` est la dérivation que le hub (`getSubject`) et la quête
 * (`getExerciseParcours`) partagent : un seul juge sur « de quelle classe est cette
 * matière ? ». `getExerciseParcours` n'alimente qu'une carte facultative — tout ce
 * qui tourne mal doit rendre `null`, jamais casser la quête.
 */

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
      validator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async (input: { data: unknown }) =>
          handlerFn({
            data: validatorFn ? validatorFn(input.data) : input.data,
            context: { supabase: mockSupabase, userId: "user-123" },
          });
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

import type { SupabaseClient } from "@supabase/supabase-js";
import type { Database } from "@/shared/integrations/supabase/types";
import {
  getExerciseParcours,
  resolveSubjectParcours,
} from "@/features/quest/quest.parcours.server";
import { logger } from "@/shared/lib/logger";

const supabase = mockSupabase as unknown as SupabaseClient<Database>;

const EXERCISE_ID = "6e7219be-5c5a-586e-bedd-318a6262ec8f";
const PARCOURS = {
  id: "ecole-9eme",
  name_fr: "9ème année",
  name_en: "9th grade",
  name_ar: "السنة التاسعة",
  is_premium: false,
};

/** Une lecture `from(table).select(…).eq(…).maybeSingle()` qui rend `result`. */
function lookup(result: { data: unknown; error?: unknown }) {
  const select = vi.fn();
  const eq = vi.fn();
  const maybeSingle = vi.fn().mockResolvedValue({ error: null, ...result });
  select.mockReturnValue({ eq });
  eq.mockReturnValue({ maybeSingle });
  return { select, eq, maybeSingle };
}

/** Route chaque table vers sa lecture ; une table non prévue fait échouer le test. */
function mockTables(tables: Record<string, ReturnType<typeof lookup>>) {
  mockFrom.mockImplementation((table: string) => {
    const chain = tables[table];
    if (!chain) throw new Error(`lecture inattendue de la table ${table}`);
    return { select: chain.select };
  });
}

beforeEach(() => {
  vi.clearAllMocks();
});

describe("resolveSubjectParcours", () => {
  it("résout le parcours d'une matière scolaire par (thème, niveau) et lit sa ligne", async () => {
    mockRpc.mockResolvedValue({ data: PARCOURS.id, error: null });
    const parcours = lookup({ data: PARCOURS });
    mockTables({ parcours });

    await expect(
      resolveSubjectParcours(supabase, { theme_id: "ecole-tn", grade_id: "grade-9" }),
    ).resolves.toEqual(PARCOURS);
    expect(mockRpc).toHaveBeenCalledWith("resolve_subject_parcours", {
      p_theme: "ecole-tn",
      p_grade: "grade-9",
    });
    expect(parcours.eq).toHaveBeenCalledWith("id", PARCOURS.id);
  });

  // Un thème hors école (anglais, culture générale…) n'a pas de niveau : la RPC
  // compare avec IS NOT DISTINCT FROM, donc `null` est une valeur valide.
  it("passe un niveau nul tel quel pour un thème sans niveau", async () => {
    mockRpc.mockResolvedValue({ data: "extras-anglais", error: null });
    mockTables({ parcours: lookup({ data: { ...PARCOURS, id: "extras-anglais" } }) });

    await resolveSubjectParcours(supabase, { theme_id: "anglais", grade_id: null });
    expect(mockRpc).toHaveBeenCalledWith("resolve_subject_parcours", {
      p_theme: "anglais",
      p_grade: null,
    });
  });

  it("rend null sans rien lire quand la matière n'a pas de thème", async () => {
    await expect(resolveSubjectParcours(supabase, { theme_id: null })).resolves.toBeNull();
    await expect(resolveSubjectParcours(supabase, {})).resolves.toBeNull();
    expect(mockRpc).not.toHaveBeenCalled();
    expect(mockFrom).not.toHaveBeenCalled();
  });

  it("rend null sans lire `parcours` quand la RPC ne trouve rien", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    await expect(
      resolveSubjectParcours(supabase, { theme_id: "ecole-tn", grade_id: "grade-9" }),
    ).resolves.toBeNull();
    expect(mockFrom).not.toHaveBeenCalled();
  });

  it("rend null quand la ligne du parcours a disparu", async () => {
    mockRpc.mockResolvedValue({ data: PARCOURS.id, error: null });
    mockTables({ parcours: lookup({ data: null }) });
    await expect(
      resolveSubjectParcours(supabase, { theme_id: "ecole-tn", grade_id: "grade-9" }),
    ).resolves.toBeNull();
  });
});

describe("getExerciseParcours", () => {
  it("rend le parcours du chapitre de l'exercice — de quoi nommer et choisir, rien de plus", async () => {
    const exercises = lookup({
      data: { subjects: { theme_id: "ecole-tn", grade_id: "grade-9" } },
    });
    mockTables({ exercises, parcours: lookup({ data: PARCOURS }) });
    mockRpc.mockResolvedValue({ data: PARCOURS.id, error: null });

    const result = await getExerciseParcours({ data: { exerciseId: EXERCISE_ID } });
    expect(result).toEqual({
      id: PARCOURS.id,
      name_fr: PARCOURS.name_fr,
      name_en: PARCOURS.name_en,
      name_ar: PARCOURS.name_ar,
    });
    // `is_premium` reste côté serveur : la carte ne parle jamais d'accès.
    expect(result).not.toHaveProperty("is_premium");
    expect(exercises.eq).toHaveBeenCalledWith("id", EXERCISE_ID);
    // Une lecture de rattachement : ni question ni clé de réponse.
    expect(exercises.select.mock.calls[0][0]).not.toMatch(/question|correct|option/i);
  });

  it("rend null pour un exercice inconnu, sans alerter", async () => {
    mockTables({ exercises: lookup({ data: null }) });
    await expect(getExerciseParcours({ data: { exerciseId: EXERCISE_ID } })).resolves.toBeNull();
    expect(mockRpc).not.toHaveBeenCalled();
    expect(logger.warn).not.toHaveBeenCalled();
  });

  it("rend null quand la matière n'a pas de parcours", async () => {
    mockTables({ exercises: lookup({ data: { subjects: { theme_id: "x", grade_id: null } } }) });
    mockRpc.mockResolvedValue({ data: null, error: null });
    await expect(getExerciseParcours({ data: { exerciseId: EXERCISE_ID } })).resolves.toBeNull();
  });

  it("rend null et journalise quand la lecture de l'exercice échoue", async () => {
    mockTables({ exercises: lookup({ data: null, error: { message: "boom" } }) });
    await expect(getExerciseParcours({ data: { exerciseId: EXERCISE_ID } })).resolves.toBeNull();
    expect(logger.warn).toHaveBeenCalledWith(
      expect.stringContaining("getExerciseParcours"),
      expect.objectContaining({ exerciseId: EXERCISE_ID, error: "boom" }),
    );
  });

  // La carte est facultative : une RPC qui casse ne doit pas remonter à la quête.
  it("rend null et journalise quand la résolution du parcours lève", async () => {
    mockTables({
      exercises: lookup({ data: { subjects: { theme_id: "ecole-tn", grade_id: "grade-9" } } }),
    });
    mockRpc.mockRejectedValue(new Error("rpc down"));
    await expect(getExerciseParcours({ data: { exerciseId: EXERCISE_ID } })).resolves.toBeNull();
    expect(logger.warn).toHaveBeenCalledWith(
      expect.stringContaining("getExerciseParcours"),
      expect.objectContaining({ error: "rpc down" }),
    );
  });

  it("refuse un identifiant qui n'est pas un GUID avant toute lecture", async () => {
    await expect(getExerciseParcours({ data: { exerciseId: "pas-un-uuid" } })).rejects.toThrow();
    expect(mockFrom).not.toHaveBeenCalled();
  });
});
