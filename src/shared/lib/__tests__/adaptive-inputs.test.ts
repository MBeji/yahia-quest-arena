import { describe, expect, it, vi } from "vitest";

import {
  pickAConsolider,
  pickLacune,
  pickRacine,
  resolveAdaptiveInputs,
  type AdaptiveRpcClient,
} from "../adaptive-inputs";
import { resolveNextAction } from "../next-action";
import type { LearningStateRow } from "@/shared/types/competency";

vi.mock("../logger", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));

const etat = (over: Partial<LearningStateRow> = {}): LearningStateRow => ({
  competency_id: "c1",
  slug: "frac-add",
  family: "math",
  domain: "algebre",
  label_fr: "Additionner des fractions",
  label_en: "Adding fractions",
  label_ar: "جمع الكسور",
  state: "en-cours",
  zone: "frontiere",
  p_known: null,
  evidence_count: 3,
  sessions_seen: 2,
  forms_count: 1,
  belief_source: "evidence",
  suspect: false,
  ...over,
});

/** Un client qui répond ce qu'on lui dit, et compte ses appels. */
function fakeClient(replies: Record<string, { data?: unknown; error?: { message: string } }>) {
  const calls: string[] = [];
  const client = {
    rpc: (fn: string) => {
      calls.push(fn);
      const r = replies[fn] ?? { data: [] };
      return Promise.resolve({ data: r.data ?? null, error: r.error ?? null });
    },
  } as unknown as AdaptiveRpcClient;
  return { client, calls };
}

describe("resolveAdaptiveInputs — le producteur des rangs 2 et 4 (#870)", () => {
  it("sur une matière NON TAGGÉE, ne coûte QU'UN appel et ne produit rien", () => {
    // R-6 : zéro ligne de croyance n'est pas une erreur, c'est le cas courant du
    // catalogue. Il ne doit pas déclencher les deux RPC suivantes.
    const { client, calls } = fakeClient({ get_learning_state: { data: [] } });
    return resolveAdaptiveInputs(client, null).then((out) => {
      expect(out).toEqual({});
      expect(calls).toEqual(["get_learning_state"]);
    });
  });

  it("remonte à la CAUSE RACINE, pas au symptôme", async () => {
    const { client } = fakeClient({
      get_learning_state: { data: [etat({ state: "lacune", slug: "frac-add" })] },
      get_remediation_path: {
        data: [
          { slug: "frac-add", entry_exercise_id: "ex-symptome", is_root_cause: false, depth: 0 },
          { slug: "pgcd", entry_exercise_id: "ex-racine", is_root_cause: true, depth: 2 },
        ],
      },
    });
    const out = await resolveAdaptiveInputs(client, null);
    // Le slug qui voyage est celui de la RACINE : R-14 veut la raison, et la raison
    // est le prérequis manquant, pas la compétence où ça s'est vu.
    expect(out.remediation).toEqual({ competencySlug: "pgcd", exerciseId: "ex-racine" });
  });

  it("ne propose RIEN plutôt que le symptôme quand la racine n'a pas d'exercice", async () => {
    // Proposer l'étape intermédiaire serait exactement le piétinement que
    // l'amendement C cherche à faire baisser.
    const { client } = fakeClient({
      get_learning_state: { data: [etat({ state: "lacune" })] },
      get_remediation_path: {
        data: [
          { slug: "frac-add", entry_exercise_id: "ex-symptome", is_root_cause: false, depth: 0 },
          { slug: "pgcd", entry_exercise_id: null, is_root_cause: true, depth: 2 },
        ],
      },
    });
    expect((await resolveAdaptiveInputs(client, null)).remediation).toBeNull();
  });

  it("consolide la compétence vue sous le MOINS de formes", async () => {
    const { client } = fakeClient({
      get_learning_state: {
        data: [
          etat({ slug: "variee", forms_count: 4 }),
          etat({ slug: "peu-variee", forms_count: 1 }),
        ],
      },
      get_exercises_for_competency: {
        data: [
          {
            exercise_id: "ex-dur",
            chapter_id: "c",
            subject_id: "s",
            exercise_title: "",
            difficulty: 3,
          },
          {
            exercise_id: "ex-doux",
            chapter_id: "c",
            subject_id: "s",
            exercise_title: "",
            difficulty: 1,
          },
        ],
      },
    });
    const out = await resolveAdaptiveInputs(client, null);
    // La moins variée, et le plus facile de ses exercices : consolider n'est pas éprouver.
    expect(out.strengthen).toEqual({ competencySlug: "peu-variee", exerciseId: "ex-doux" });
  });

  it("une RPC en échec laisse le rang DORMANT — jamais une page cassée", async () => {
    const { client } = fakeClient({
      get_learning_state: { data: [etat({ state: "lacune" })] },
      get_remediation_path: { error: { message: "boom" } },
      get_exercises_for_competency: { error: { message: "boom" } },
    });
    const out = await resolveAdaptiveInputs(client, null);
    expect(out).toEqual({ remediation: null, strengthen: null });
  });

  it("`get_learning_state` en échec rend `{}` — l'ordre d'avant l'amendement", async () => {
    const { client, calls } = fakeClient({ get_learning_state: { error: { message: "boom" } } });
    expect(await resolveAdaptiveInputs(client, null)).toEqual({});
    expect(calls).toEqual(["get_learning_state"]);
  });

  it("choisit de façon STABLE — la même cible d'un écran et d'une seconde à l'autre", () => {
    // é22 D-8 tombe pour une raison idiote si deux résolutions successives sur les
    // mêmes données désignent deux compétences à égalité de score.
    const aEgalite = [etat({ slug: "b", state: "lacune" }), etat({ slug: "a", state: "lacune" })];
    expect(pickLacune(aEgalite)?.slug).toBe("a");
    expect(pickLacune([...aEgalite].reverse())?.slug).toBe("a");
    const consolidables = [etat({ slug: "b" }), etat({ slug: "a" })];
    expect(pickAConsolider(consolidables)?.slug).toBe("a");
    expect(pickAConsolider([...consolidables].reverse())?.slug).toBe("a");
  });

  it("ne confond pas `fragile` avec `en-cours` — consolider n'est pas remonter", () => {
    expect(pickAConsolider([etat({ state: "fragile" })])).toBeNull();
    expect(pickLacune([etat({ state: "fragile" })])).toBeNull();
  });

  it("`pickRacine` exige la marque ET l'exercice", () => {
    expect(pickRacine([])).toBeNull();
    expect(
      pickRacine([{ slug: "a", entry_exercise_id: "e", is_root_cause: false, depth: 0 }]),
    ).toBeNull();
  });
});

describe("les rangs 2 et 4 ne sont plus dormants — bout à bout avec le moteur", () => {
  it("`remediate` passe DEVANT `retry`, ce qui était tout l'objet de l'amendement C", async () => {
    const { client } = fakeClient({
      get_learning_state: { data: [etat({ state: "lacune" })] },
      get_remediation_path: {
        data: [{ slug: "pgcd", entry_exercise_id: "ex-racine", is_root_cause: true, depth: 1 }],
      },
    });
    const adaptive = await resolveAdaptiveInputs(client, null);
    const action = resolveNextAction({ ...adaptive, failedExerciseId: "ex-rate" });
    expect(action).toEqual({
      kind: "remediate",
      exerciseId: "ex-racine",
      competencySlug: "pgcd",
    });
  });

  it("sans entrées produites, l'ordre reste EXACTEMENT celui d'avant", async () => {
    const { client } = fakeClient({ get_learning_state: { data: [] } });
    const adaptive = await resolveAdaptiveInputs(client, null);
    expect(resolveNextAction({ ...adaptive, failedExerciseId: "ex-rate" })).toEqual({
      kind: "retry",
      exerciseId: "ex-rate",
    });
  });
});
