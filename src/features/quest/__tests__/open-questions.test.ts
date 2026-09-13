// @vitest-environment node
import { describe, expect, it, vi } from "vitest";

import { canPlayOpenQuestions, filterOpenQuestions } from "../quest.open-questions";

/**
 * LA PORTE DES QUESTIONS OUVERTES — étude 33 lot 1, côté lecteur de quête.
 *
 * L'arbitrage du propriétaire (2026-09-13) : une question ouverte
 * (`short_answer` — aucune proposition, une réponse tapée) n'est servie qu'à un
 * élève dont le mode IA peut juger une formulation imprévue.
 *
 * ⚠️ LE DANGER DE CE LOT N'EST PAS LE FILTRE, C'EST SA MOITIÉ MANQUANTE. Retirer
 * une question de l'écran sans la retirer du DÉNOMINATEUR est pire que ne rien
 * faire : `submit_exercise_attempt` compte `FROM questions WHERE exercise_id`,
 * donc une `short_answer` jamais servie serait restée dans le total, sans
 * réponse, donc fausse — une mission de 9 questions jouée sur 8 et notée sur 9.
 * C'est `is_question_in_play` qui tient l'autre moitié, en base, et le pgTAP
 * `101_open_questions_gate` le vérifie là où ça se décide.
 */

/** Une question telle que `getExercise` la sert — le type est OPTIONNEL. */
type Servie = { id: string; question_type?: string | null };

const mcq: Servie = { id: "q1", question_type: "mcq" };
const ouverte: Servie = { id: "q2", question_type: "short_answer" };
const numeric: Servie = { id: "q3", question_type: "numeric" };
/** Une ligne ancienne, sans colonne de type : le défaut historique est `mcq`. */
const sansType: Servie = { id: "q4" };

describe("filterOpenQuestions", () => {
  it("porte fermée : la question ouverte sort, les autres restent", () => {
    expect(filterOpenQuestions([mcq, ouverte, numeric, sansType], false)).toEqual([
      mcq,
      numeric,
      sansType,
    ]);
  });

  it("porte ouverte : le jeu servi est INTACT, dans son ordre", () => {
    // Pas de tri, pas de dédoublonnage, pas de réécriture : une mission dont la
    // porte est ouverte doit se jouer exactement comme avant l'étude 33.
    const jeu = [mcq, ouverte, numeric, sansType];
    expect(filterOpenQuestions(jeu, true)).toEqual(jeu);
  });

  it("ne touche à AUCUN des cinq autres types natifs", () => {
    // `numeric`, `ordering`, `matching`, `multi` ont eux aussi une clé et une
    // saisie, mais leur verdict est structurel — aucun n'a besoin d'un juge.
    const autres: Servie[] = ["numeric", "ordering", "matching", "multi", "mcq"].map((t, i) => ({
      id: `n${i}`,
      question_type: t,
    }));
    expect(filterOpenQuestions(autres, false)).toEqual(autres);
  });

  it("rend une COPIE, jamais le tableau reçu", () => {
    // `getExercise` sert le résultat tel quel ; rendre la référence exposerait
    // le cache de requête à une mutation depuis l'appelant.
    const jeu = [mcq];
    expect(filterOpenQuestions(jeu, true)).not.toBe(jeu);
    expect(filterOpenQuestions(jeu, false)).not.toBe(jeu);
  });
});

describe("canPlayOpenQuestions", () => {
  // ⚠️ UN FAUX CLIENT NEUF PAR TEST, et surtout PAS un `vi.fn()` de portée
  // `describe` remis à zéro dans un `beforeEach`. Vitest 4 fait alors remonter
  // comme un ÉCHEC DU TEST une erreur levée par l'implémentation du mock — même
  // lorsque le code testé l'a attrapée (les `logger.warn` sortent, la fonction
  // rend bien `false`). Réduit à quatre lignes pour en être sûr : le même test
  // passe sans le `beforeEach(() => mock.mockReset())`, échoue avec.
  function fakeClient(impl: (...args: unknown[]) => unknown) {
    const rpc = vi.fn(impl);
    return { rpc, supabase: { rpc: (...args: unknown[]) => rpc(...args) } };
  }

  it("anonyme : FERMÉE, sans même interroger la base", async () => {
    // Le catalogue public (`/exercice`) n'a pas d'élève, donc pas de mode IA,
    // donc aucune question ouverte — et pas un aller-retour pour l'apprendre.
    const { rpc, supabase } = fakeClient(() => Promise.resolve({ data: true, error: null }));
    expect(await canPlayOpenQuestions(supabase, null)).toBe(false);
    expect(await canPlayOpenQuestions(supabase, undefined)).toBe(false);
    expect(await canPlayOpenQuestions(supabase, "")).toBe(false);
    expect(rpc).not.toHaveBeenCalled();
  });

  it("lit la porte EN BASE, jamais une règle recalculée ici", async () => {
    // `can_play_open_questions` est la même fonction que celle dont dépend le
    // dénominateur du score. Un second calcul en TypeScript divergerait le jour
    // où la porte gagne une condition, et la divergence se paierait en
    // questions notées mais jamais servies.
    const { rpc, supabase } = fakeClient(() => Promise.resolve({ data: true, error: null }));
    expect(await canPlayOpenQuestions(supabase, "eleve")).toBe(true);
    expect(rpc).toHaveBeenCalledWith("can_play_open_questions", { p_student: "eleve" });
  });

  it("n'ouvre que sur un `true` franc", async () => {
    for (const data of [false, null, undefined, 1, "true"]) {
      const { supabase } = fakeClient(() => Promise.resolve({ data, error: null }));
      expect(await canPlayOpenQuestions(supabase, "eleve")).toBe(false);
    }
  });

  it("DÉGRADE EN FERMÉ quand la base répond une erreur — jamais en ouvert", async () => {
    // Au pire, l'élève joue une mission d'une question de moins, notée sur ce
    // qu'il a vu. Dégrader en ouvert servirait une question libre SANS juge,
    // c'est-à-dire exactement ce que l'arbitrage interdit.
    const { supabase } = fakeClient(() =>
      Promise.resolve({ data: null, error: { message: "hors service" } }),
    );
    expect(await canPlayOpenQuestions(supabase, "eleve")).toBe(false);
  });

  it("DÉGRADE EN FERMÉ quand l'appel REJETTE, au lieu de faire tomber la mission", async () => {
    // Une mission qui ne se charge plus parce que le mode IA a hoqueté serait
    // une panne bien pire que la question manquante.
    const { supabase } = fakeClient(() => Promise.reject(new Error("réseau coupé")));
    expect(await canPlayOpenQuestions(supabase, "eleve")).toBe(false);
  });

  it("DÉGRADE EN FERMÉ quand le client LÈVE SYNCHRONEMENT", async () => {
    const { supabase } = fakeClient(() => {
      throw new Error("client cassé");
    });
    expect(await canPlayOpenQuestions(supabase, "eleve")).toBe(false);
  });
});
