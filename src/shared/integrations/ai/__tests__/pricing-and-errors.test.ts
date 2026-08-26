import { describe, expect, it } from "vitest";

import {
  AI_MODEL_PRICES,
  AI_MODEL_PRICES_AS_OF,
  AI_UNKNOWN_MODEL_PRICE,
  AI_CURATED_MODELS,
  AI_DEFAULT_BUDGETS,
  AI_MAX_TOKENS,
  AI_FEATURES,
} from "@/shared/constants/ai";
import {
  estimateCostMicros,
  estimateTokens,
  hasKnownPrice,
  microsToUsd,
  priceFor,
  settledCostMicros,
  usdToMicros,
} from "../pricing";
import { AiError, aiErrorFromStatus, asAiErrorCode, isRetryableStatus, toAiError } from "../errors";

describe("la grille de prix est DATÉE et complète (R-12)", () => {
  it("porte sa date", () => {
    expect(AI_MODEL_PRICES_AS_OF).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });

  it("couvre chaque modèle curé — la liste proposée ne peut pas être hors grille", () => {
    for (const models of Object.values(AI_CURATED_MODELS)) {
      for (const model of models) expect(hasKnownPrice(model), model).toBe(true);
    }
  });

  it("chaque surface a une borne de tokens (R-10)", () => {
    for (const feature of AI_FEATURES) expect(AI_MAX_TOKENS[feature]).toBeGreaterThan(0);
  });

  it("la vérification de clé est minuscule — US-2 : ≤ 16 tokens de sortie", () => {
    expect(AI_MAX_TOKENS.verify).toBeLessThanOrEqual(16);
  });
});

describe("un modèle inconnu n'ouvre PAS une vanne (§3.7)", () => {
  it("est facturé au tarif de repli, jamais à zéro", () => {
    const price = priceFor("un-modele-que-personne-ne-connait");
    expect(price).toEqual(AI_UNKNOWN_MODEL_PRICE);
    expect(price.inputPerMTokUsd).toBeGreaterThan(0);
    expect(price.outputPerMTokUsd).toBeGreaterThan(0);
  });

  it("le tarif de repli est le PLUS HAUT du parc connu, pas une moyenne", () => {
    for (const price of Object.values(AI_MODEL_PRICES)) {
      expect(price.inputPerMTokUsd).toBeLessThanOrEqual(AI_UNKNOWN_MODEL_PRICE.inputPerMTokUsd);
      expect(price.outputPerMTokUsd).toBeLessThanOrEqual(AI_UNKNOWN_MODEL_PRICE.outputPerMTokUsd);
    }
  });

  it("estimer un modèle inconnu coûte au moins autant qu'estimer le plus cher des connus", () => {
    const args = { estimatedInputTokens: 10_000, maxOutputTokens: 1_000 };
    const unknown = estimateCostMicros({ model: "inconnu", ...args });
    for (const model of Object.keys(AI_MODEL_PRICES)) {
      expect(estimateCostMicros({ model, ...args })).toBeLessThanOrEqual(unknown);
    }
  });
});

describe("le calcul lui-même", () => {
  it("estime en micro-dollars entiers, sortie prise au plafond", () => {
    // 1 M de tokens d'entrée à 1 $/MTok + 1 000 de sortie à 5 $/MTok = 1,005 $.
    expect(
      estimateCostMicros({
        model: "claude-haiku-4-5",
        estimatedInputTokens: 1_000_000,
        maxOutputTokens: 1_000,
      }),
    ).toBe(1_005_000);
  });

  it("arrondit AU SUPÉRIEUR — on ne sous-facture jamais un plafond", () => {
    expect(
      estimateCostMicros({
        model: "claude-haiku-4-5",
        estimatedInputTokens: 1,
        maxOutputTokens: 0,
      }),
    ).toBe(1);
  });

  it("solde l'appel sur les tokens réellement rapportés, cache compris", () => {
    // 1 000 entrée (1 $/M) + 500 sortie (5 $/M) + 10 000 cachés (0,1 $/M).
    expect(
      settledCostMicros({
        model: "claude-haiku-4-5",
        inputTokens: 1_000,
        outputTokens: 500,
        cachedTokens: 10_000,
      }),
    ).toBe(1_000 + 2_500 + 1_000);
  });

  it("le cache ALLÈGE la facture — c'est la promesse de l'annexe A", () => {
    const cold = settledCostMicros({
      model: "claude-sonnet-5",
      inputTokens: 10_000,
      outputTokens: 0,
    });
    const warm = settledCostMicros({
      model: "claude-sonnet-5",
      inputTokens: 0,
      outputTokens: 0,
      cachedTokens: 10_000,
    });
    expect(warm).toBeLessThan(cold);
  });

  it("ne compte rien pour un usage vide", () => {
    expect(settledCostMicros({ model: "claude-opus-5", inputTokens: 0, outputTokens: 0 })).toBe(0);
  });

  it("l'estimation de tokens est haute, jamais basse", () => {
    // 360 caractères ⇒ 100 tokens estimés. Un texte réel en produit moins.
    expect(estimateTokens("a".repeat(360))).toBe(100);
    expect(estimateTokens("")).toBe(0);
  });

  it("convertit dollars ↔ micro-dollars sans dérive", () => {
    expect(usdToMicros(AI_DEFAULT_BUDGETS.monthlyUsd)).toBe(20_000_000);
    expect(microsToUsd(2_000_000)).toBe(2);
  });
});

describe("la liste curée est la condition d'entrée du pot commun (R-15.2)", () => {
  // Le prédicat d'entrée, lui, vit dans `features/tutor/tutor.server.ts` et se
  // teste là-bas : il ignore le fournisseur, et dit pourquoi.
  it("⭐ aucun id curé n'est un ALIAS — un « -latest » ne matcherait jamais l'id écho", () => {
    // Les deux adaptateurs retiennent l'id RENVOYÉ par le fournisseur, pas celui
    // qu'on lui a demandé (openai-compatible.server.ts, anthropic.server.ts :
    // « un service qui substitue un modèle doit se voir dans la console »).
    // Curer `mistral-large-latest` serait donc un no-op SILENCIEUX : le service
    // écho sa version concrète, la comparaison échoue, et rien ne signale que le
    // modèle n'entre pas dans le pot commun — on le croit curé pour toujours.
    for (const models of Object.values(AI_CURATED_MODELS)) {
      for (const model of models) expect(model, model).not.toMatch(/-latest$/);
    }
  });

  it("chaque fournisseur a une liste NON VIDE — sinon la condition R-15 laisse tout passer", () => {
    // Le §7 le dit : « la liste curée doit exister AVANT le lot où le cache
    // devient mutualisé ; sans elle, la condition d'entrée est vide. »
    for (const [provider, models] of Object.entries(AI_CURATED_MODELS)) {
      expect(models.length, provider).toBeGreaterThan(0);
    }
  });
});

describe("codes d'erreur stables — annexe C (R-5)", () => {
  it("traduit chaque statut en code stable", () => {
    expect(aiErrorFromStatus(401).code).toBe("AI_KEY_INVALID");
    expect(aiErrorFromStatus(403).code).toBe("AI_KEY_INVALID");
    expect(aiErrorFromStatus(402).code).toBe("AI_CREDIT_EXHAUSTED");
    expect(aiErrorFromStatus(404).code).toBe("AI_MODEL_UNKNOWN");
    expect(aiErrorFromStatus(429).code).toBe("AI_RATE_LIMITED");
    expect(aiErrorFromStatus(500).code).toBe("AI_PROVIDER_DOWN");
    expect(aiErrorFromStatus(503).code).toBe("AI_PROVIDER_DOWN");
  });

  it("distingue le 400 « modèle inconnu » du 400 quelconque", () => {
    expect(aiErrorFromStatus(400, '{"error":"unknown model xyz"}').code).toBe("AI_MODEL_UNKNOWN");
    expect(aiErrorFromStatus(400, '{"error":"bad json"}').code).toBe("AI_UNKNOWN");
  });

  it("distingue le 429 de débit du 429 « crédit épuisé »", () => {
    expect(aiErrorFromStatus(429, "insufficient_quota").code).toBe("AI_CREDIT_EXHAUSTED");
    expect(aiErrorFromStatus(429, "credit balance is too low").code).toBe("AI_CREDIT_EXHAUSTED");
    expect(aiErrorFromStatus(429, "rate limit exceeded, retry").code).toBe("AI_RATE_LIMITED");
  });

  it("le corps du fournisseur ne survit PAS à la traduction — le message est le code seul", () => {
    // Le scénario redouté par R-5 : un fournisseur qui répète un fragment de clé
    // dans son message d'erreur.
    const error = aiErrorFromStatus(401, 'invalid api key "sk-live-abcdef123456"');
    expect(error.message).toBe("AI_KEY_INVALID");
    expect(JSON.stringify(error)).not.toContain("sk-live");
  });

  it("re-type n'importe quelle exception, y compris une qui cite la requête", () => {
    const sdkError = Object.assign(new Error("400 https://api.anthropic.com key=sk-live-xyz"), {
      status: 400,
    });
    const typed = toAiError(sdkError);
    expect(typed).toBeInstanceOf(AiError);
    expect(typed.message).not.toContain("sk-live");
  });

  it("traite un abandon comme une panne de fournisseur", () => {
    expect(toAiError(Object.assign(new Error("aborted"), { name: "AbortError" })).code).toBe(
      "AI_PROVIDER_DOWN",
    );
  });

  it("laisse passer une AiError sans la ré-emballer", () => {
    const original = new AiError("AI_BUDGET_REACHED");
    expect(toAiError(original)).toBe(original);
  });

  it("dégrade un code inconnu plutôt que de le propager", () => {
    expect(asAiErrorCode("AI_KEY_INVALID")).toBe("AI_KEY_INVALID");
    expect(asAiErrorCode("AI_QUELQUE_CHOSE")).toBe("AI_UNKNOWN");
    expect(asAiErrorCode(null)).toBe("AI_UNKNOWN");
  });

  it("ne retente que 429 et 5xx", () => {
    expect(isRetryableStatus(429)).toBe(true);
    expect(isRetryableStatus(500)).toBe(true);
    expect(isRetryableStatus(401)).toBe(false);
    expect(isRetryableStatus(403)).toBe(false);
    expect(isRetryableStatus(404)).toBe(false);
    expect(isRetryableStatus(400)).toBe(false);
  });
});
