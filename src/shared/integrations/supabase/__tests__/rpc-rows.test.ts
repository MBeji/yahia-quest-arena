import { beforeEach, describe, expect, it, vi } from "vitest";
import { z } from "zod";

const { mockError } = vi.hoisted(() => ({ mockError: vi.fn() }));
vi.mock("@/shared/lib/logger", () => ({ logger: { error: mockError, warn: vi.fn() } }));

import {
  competencyMasteryRowSchema,
  learningFrontierRowSchema,
  learningStateRowSchema,
  parseRpcRows,
  weaknessRowSchema,
} from "../rpc-rows";

const rowSchema = z.object({ id: z.string(), n: z.number() });

describe("parseRpcRows — la frontière de forme des RPC", () => {
  beforeEach(() => mockError.mockReset());

  it("rend les lignes conformes telles quelles, sans rien journaliser", () => {
    const rows = [
      { id: "a", n: 1 },
      { id: "b", n: 2 },
    ];
    expect(parseRpcRows(rowSchema, rows, "ctx")).toEqual(rows);
    expect(mockError).not.toHaveBeenCalled();
  });

  it("rend une liste vide pour `null` — une RPC sans ligne n'est pas une dérive", () => {
    expect(parseRpcRows(rowSchema, null, "ctx")).toEqual([]);
    expect(parseRpcRows(rowSchema, undefined, "ctx")).toEqual([]);
    expect(mockError).not.toHaveBeenCalled();
  });

  it("écarte la ligne hors contrat, garde les autres, et le dit UNE fois", () => {
    const out = parseRpcRows(
      rowSchema,
      [{ id: "a", n: 1 }, { id: "b", n: "2" }, { id: "c", n: 3 }, { n: 4 }],
      "getThing",
    );
    expect(out).toEqual([
      { id: "a", n: 1 },
      { id: "c", n: 3 },
    ]);
    expect(mockError).toHaveBeenCalledTimes(1);
    expect(mockError).toHaveBeenCalledWith("getThing: unexpected RPC shape", {
      rejected: 2,
      total: 4,
      firstIssue: "n: invalid_type",
    });
  });

  it("ne journalise jamais la VALEUR fautive — une ligne porte des données d'élève", () => {
    parseRpcRows(rowSchema, [{ id: "a", n: "secret-eleve" }], "ctx");
    expect(JSON.stringify(mockError.mock.calls)).not.toContain("secret-eleve");
  });

  it("refuse en bloc une réponse qui n'est pas un tableau", () => {
    expect(parseRpcRows(rowSchema, { id: "a", n: 1 }, "ctx")).toEqual([]);
    expect(mockError).toHaveBeenCalledWith("ctx: unexpected RPC shape", {
      reason: "not an array",
    });
  });

  it("retire les colonnes que le contrat ne déclare pas", () => {
    expect(parseRpcRows(rowSchema, [{ id: "a", n: 1, extra: "x" }], "ctx")).toEqual([
      { id: "a", n: 1 },
    ]);
  });
});

/**
 * Ce que le générateur de types ne sait PAS dire, et que ces schémas tiennent :
 * la nullabilité d'une colonne de retour et les unions fermées.
 */
describe("les schémas de lignes — nullabilité et unions fermées", () => {
  const competency = {
    competency_id: "c1",
    slug: "math.frac.add",
    family: "math",
    domain: "frac",
    label_fr: "fr",
    label_en: "en",
    label_ar: "ar",
  };

  it("accepte `recent_result` NULL (rien joué en 14 jours), refuse `mastery` NULL", () => {
    const row = { ...competency, mastery: 41.5, attempts: 6, recent_result: null };
    expect(competencyMasteryRowSchema.safeParse(row).success).toBe(true);
    expect(competencyMasteryRowSchema.safeParse({ ...row, mastery: null }).success).toBe(false);
  });

  const belief = {
    ...competency,
    state: "lacune",
    zone: "frontiere",
    p_known: null,
    evidence_count: 0,
    sessions_seen: 0,
    forms_count: 0,
    belief_source: "evidence",
    suspect: false,
  };

  it("accepte une compétence jamais vue (`p_known` NULL, état « inconnue »)", () => {
    expect(learningStateRowSchema.safeParse({ ...belief, state: "inconnue" }).success).toBe(true);
  });

  it.each([
    ["state", "maîtrisée"],
    ["zone", "ailleurs"],
    ["belief_source", "guess"],
  ])("refuse une valeur hors de l'union fermée de `%s`", (field, value) => {
    expect(learningStateRowSchema.safeParse({ ...belief, [field]: value }).success).toBe(false);
  });

  it("accepte une frontière sans exercice d'entrée — le corpus n'en offre pas toujours", () => {
    const { family: _family, domain: _domain, ...labels } = competency;
    const row = {
      ...labels,
      state: "fragile",
      p_known: 0.4,
      unlocks: 3,
      entry_exercise_id: null,
      entry_subject_id: null,
      entry_odds: null,
    };
    expect(learningFrontierRowSchema.safeParse(row).success).toBe(true);
  });

  const weakness = {
    tag: "frac-add-denominators",
    label_fr: "fr",
    label_en: "en",
    label_ar: "ar",
    competency: null,
    occurrences: 4,
    last_seen_at: "2026-11-10T08:00:00Z",
    chapter_id: null,
    chapter_title: null,
    subject_id: null,
    recent_7d: 1,
    previous_7d: 3,
    trend: "improving",
  };

  it("accepte une erreur sans compétence ni chapitre d'origine (LEFT JOIN vides)", () => {
    expect(weaknessRowSchema.safeParse(weakness).success).toBe(true);
  });

  it("refuse une tendance hors du CASE fermé", () => {
    expect(weaknessRowSchema.safeParse({ ...weakness, trend: "unknown" }).success).toBe(false);
  });
});
