// @vitest-environment node
import { describe, expect, it } from "vitest";

import { AI_DISCARD_ADVICE_THRESHOLD, presetById } from "@/shared/constants/ai";
import { dominantModel, modelAdviceFor } from "../ai-console.server";

/**
 * R-19 — « Un modèle qui ne tient pas la barre est NOMMÉ ».
 *
 * C'est la seule décision automatique de toute l'étude, et son bord est étroit :
 * elle nomme, chiffre et suggère ; elle ne bascule jamais. « C'est sa clé, donc
 * son choix » (D-11). Un test qui laisserait passer une bascule automatique
 * ferait de nous quelqu'un qui dépense l'argent d'un parent à sa place.
 *
 * La mesure reste alimentée même quand la double résolution est coupée, grâce à
 * l'échantillon de 20 % (R-18bis.3) — c'est justement le cas où l'avertissement
 * est le plus utile.
 */

const HEAVY = { "claude-sonnet-5": { calls: 40 }, "claude-haiku-4-5": { calls: 3 } };
const ANTHROPIC = presetById("anthropic")!;
const DEEPSEEK = presetById("deepseek")!;

describe("le modèle NOMMÉ est le modèle DOMINANT", () => {
  it("désigne celui qui a fait le plus d'appels", () => {
    // Nommer « le modèle rapide » quand 93 % des appels passent par l'avancé
    // enverrait le porteur corriger le mauvais réglage.
    expect(dominantModel(HEAVY)).toBe("claude-sonnet-5");
  });

  it("rend `null` quand il n'y a rien à nommer", () => {
    expect(dominantModel({})).toBeNull();
  });
});

describe("le seuil de R-19", () => {
  it("se tait sous le seuil", () => {
    expect(modelAdviceFor({ discardRate: 0.5, byModel: HEAVY, preset: ANTHROPIC })).toBeNull();
    expect(modelAdviceFor({ discardRate: 0.2, byModel: HEAVY, preset: ANTHROPIC })).toBeNull();
  });

  it("parle au-delà — « plus d'une question sur deux jetée »", () => {
    const advice = modelAdviceFor({
      discardRate: AI_DISCARD_ADVICE_THRESHOLD + 0.01,
      byModel: HEAVY,
      preset: ANTHROPIC,
    });
    expect(advice?.model).toBe("claude-sonnet-5");
  });

  it("se tait quand aucun appel n'a eu lieu, quel que soit le taux", () => {
    // Un taux calculé sur zéro appel n'est pas une mesure : c'est une division
    // qu'on n'a pas faite. Nommer un modèle sur cette base serait du bruit.
    expect(modelAdviceFor({ discardRate: 1, byModel: {}, preset: ANTHROPIC })).toBeNull();
  });
});

describe("les suggestions", () => {
  it("proposent la liste du fournisseur RÉEL", () => {
    const advice = modelAdviceFor({ discardRate: 0.9, byModel: HEAVY, preset: ANTHROPIC });
    for (const suggestion of advice!.suggestions) {
      expect(ANTHROPIC.suggested).toContain(suggestion);
    }
  });

  it("ne conseille JAMAIS un modèle absent de l'endpoint du porteur", () => {
    // La régression que ce correctif ferme. La version d'origine déduisait le
    // fournisseur du préfixe `claude-` : tout ce qui n'était pas Claude recevait
    // la liste OpenAI. Un porteur DeepSeek se voyait donc conseiller `gpt-5` —
    // un identifiant qui n'existe pas chez lui, donc un conseil qui casse ce
    // qu'il prétend réparer.
    const advice = modelAdviceFor({
      discardRate: 0.9,
      byModel: { "deepseek-v4-pro": { calls: 30 } },
      preset: DEEPSEEK,
    });
    expect(advice?.model).toBe("deepseek-v4-pro");
    expect(advice!.suggestions).toEqual(["deepseek-v4-flash"]);
    expect(advice!.suggestions).not.toContain("gpt-5");
  });

  it("ne re-proposent PAS le modèle qui vient d'échouer", () => {
    const advice = modelAdviceFor({ discardRate: 0.9, byModel: HEAVY, preset: ANTHROPIC });
    expect(advice!.suggestions).not.toContain("claude-sonnet-5");
    expect(advice!.suggestions.length).toBeGreaterThan(0);
  });

  it("restent vides quand le fournisseur est inconnu — on ne conseille pas au hasard", () => {
    const advice = modelAdviceFor({ discardRate: 0.9, byModel: HEAVY, preset: null });
    expect(advice?.suggestions).toEqual([]);
    // Le modèle est nommé quand même : le constat vaut sans la suggestion.
    expect(advice?.model).toBe("claude-sonnet-5");
  });
});

describe("D-11 — l'app conseille, elle ne bascule pas", () => {
  it("le conseil ne porte AUCUN champ d'action", () => {
    const advice = modelAdviceFor({ discardRate: 0.9, byModel: HEAVY, preset: ANTHROPIC });
    // Ni `switchTo`, ni `apply`, ni `autoFix` : la forme du retour interdit à un
    // écran d'offrir un bouton « corriger pour moi ». C'est sa clé, son argent.
    expect(Object.keys(advice!).sort()).toEqual(["model", "suggestions"]);
  });
});
