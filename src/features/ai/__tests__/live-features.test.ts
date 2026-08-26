// @vitest-environment node
import { afterEach, describe, expect, it, vi } from "vitest";

import {
  AI_ENERGY_COST,
  AI_FEATURES,
  AI_INTERNAL_FEATURES,
  AI_LIVE_FEATURES,
  AI_MAX_TOKENS,
  AI_PROVIDER_PRESETS,
  type AiFeature,
} from "@/shared/constants/ai";
import { hasKnownPrice } from "@/shared/integrations/ai/pricing";
import { AI_ACTIVATABLE_FEATURES } from "../ai-access.server";
import { platformSummary } from "../ai-console.server";

/**
 * UNE SURFACE PROPOSÉE EST UNE SURFACE QUI EXISTE — DANS LES DEUX SENS.
 *
 * `AI_FEATURES` est le vocabulaire de l'étude, é11 compris : il sert à la
 * comptabilité, aux bornes de tokens et au CHECK en base. Il ne dit pas ce qui
 * est jouable, et les deux fautes qui en découlent coûtent la même chose — la
 * confiance du porteur dans son propre écran :
 *
 *   * PROMETTRE TROP. Le panneau d'activation dressait ses interrupteurs depuis
 *     `AI_FEATURES` et proposait des surfaces qu'aucun appelant n'émettait. Un
 *     parent cochait, rien ne s'allumait, il concluait que le mode était cassé.
 *     Même faute que l'écran qui n'annonçait que deux fournisseurs quand le
 *     moteur en acceptait n'importe lequel.
 *   * PROMETTRE TROP PEU. La liste est ensuite restée à `["forge"]` alors que
 *     les lots d'é11 avaient livré leurs appelants : une famille branchait sa
 *     clé et ne voyait s'allumer qu'une surface sur cinq, le reste passant en
 *     silence par la clé plateforme. Signalé en usage le 2026-08-26 — « j'ai mis
 *     ma clé et rien n'a changé » — et tranché le jour même.
 *
 * Ces tests tiennent les deux bords : rien dans la liste sans appelant, et la
 * liste exacte qu'un arbitrage a fixée.
 */

describe("AI_LIVE_FEATURES est un sous-ensemble discipliné", () => {
  it("ne contient que des surfaces du vocabulaire", () => {
    for (const feature of AI_LIVE_FEATURES) {
      expect(AI_FEATURES).toContain(feature);
    }
  });

  it("ne contient AUCUNE surface interne", () => {
    // `verify` et `forge_solve` sont émises par le produit lui-même. Les
    // proposer laisserait un parent « activer » la vérification de sa propre
    // clé, ce qui ne veut rien dire.
    for (const internal of AI_INTERNAL_FEATURES) {
      expect(AI_LIVE_FEATURES as readonly AiFeature[]).not.toContain(internal);
    }
  });

  it("porte une borne de tokens pour chaque surface proposée", () => {
    // Une surface sans plafond de sortie serait une surface sans R-10.
    for (const feature of AI_LIVE_FEATURES) {
      expect(AI_MAX_TOKENS[feature]).toBeGreaterThan(0);
    }
  });

  it("porte les six surfaces que la clé d'une famille paie (arbitrage 2026-08-26)", () => {
    // Ce test échoue au moindre ajout — c'est voulu : le faire passer oblige à
    // relire ce fichier, donc à vérifier qu'un appelant émet vraiment la
    // surface avant de l'ouvrir au porteur. Il a tenu `["forge"]` jusqu'au
    // 2026-08-26, où l'arbitrage a ouvert TOUT ce qui appelle un modèle.
    expect([...AI_LIVE_FEATURES]).toEqual([
      "explain",
      "reformulate",
      "chat",
      "forge",
      "digest_student",
      "digest_parent",
    ]);
  });

  it("laisse dehors les surfaces SANS appel de modèle", () => {
    // Les deux fautes symétriques que ce fichier existe pour empêcher.
    //
    // `check` : la boucle de compréhension d'é11 lot 4 est 100 % déterministe —
    // question du stock, correction en base, escalade en i18n. L'ouvrir donnerait
    // au porteur un interrupteur qui n'allume rien.
    //
    // `exercise_gen` : le vocabulaire existe, l'APPELANT non — les exercices
    // ciblés passent par la Forge. Une activation en base pour une surface que
    // personne n'émet est une ligne morte, et une puce de plus à décocher.
    for (const orphan of ["check", "exercise_gen"] satisfies AiFeature[]) {
      expect(AI_LIVE_FEATURES as readonly AiFeature[]).not.toContain(orphan);
    }
  });

  it("chaque surface proposée porte un coût en énergie", () => {
    // Une surface sans barème serait facturée en argent sans être comptée en
    // énergie — donc invisible du plafond pédagogique (R-9, é09 anti-farm).
    for (const feature of AI_LIVE_FEATURES) {
      expect(AI_ENERGY_COST[feature]).toBeGreaterThanOrEqual(0);
    }
  });
});

describe("le SERVEUR applique la même liste que l'écran", () => {
  it("n'accepte à l'activation que ce que l'écran propose", () => {
    // Sans cette égalité, une requête forgée inscrirait en base l'activation
    // d'une surface sans écran : `resolve_ai_access` accorderait alors un accès
    // vers nulle part, et la comptabilité porterait une ligne inexplicable.
    expect([...AI_ACTIVATABLE_FEATURES]).toEqual([...AI_LIVE_FEATURES]);
  });
});

/**
 * LA MÊME FAUTE, TROISIÈME FORME.
 *
 * L'écran d'une famille nomme six fournisseurs ; la clé PLATEFORME, elle, était
 * câblée sur Anthropic — nom de variable, `provider` du crédential et deux
 * identifiants de modèle en dur. Le moteur savait déjà appeler DeepSeek, Grok,
 * Kimi ou GLM ; nous étions les seuls à ne pas pouvoir nous en servir.
 */
describe("la clé plateforme puise dans la MÊME liste que l'écran famille", () => {
  afterEach(() => vi.unstubAllEnvs());

  it("sans clé : éteinte, et ce n'est pas une panne (R-1)", () => {
    expect(platformSummary()).toEqual({ state: "off", issue: "no_key" });
  });

  it("rend le fournisseur résolu — et JAMAIS la clé", () => {
    vi.stubEnv("AI_PLATFORM_API_KEY", "sk-secret-de-la-plateforme");
    vi.stubEnv("AI_PLATFORM_PROVIDER", "xai");
    const summary = platformSummary();

    expect(summary).toEqual({
      state: "on",
      presetId: "xai",
      label: "Grok (xAI)",
      provider: "openai_compatible",
      baseUrl: "https://api.x.ai/v1",
      models: { fast: "grok-4-fast", rich: "grok-4" },
    });
    // Ce résumé traverse le réseau vers un navigateur : la clé n'a rien à y
    // faire, pas même ses quatre derniers caractères (R-4).
    expect(JSON.stringify(summary)).not.toContain("sk-secret");
  });

  it("chaque modèle NOMMÉ par un préréglage a un tarif", () => {
    // La règle ⚠️ de `constants/ai.ts`, enfin vérifiée au lieu d'être promise :
    // `reserve_ai_spend` coupe sur l'ESTIMATION, et un modèle hors grille est
    // estimé au tarif de repli — le plus haut du parc. Suggérer un fournisseur
    // bon marché sans son tarif, c'est couper son porteur après ~4 % de sa
    // dépense réelle. C'est pourquoi `grok-4.6` et `glm-5.3`, mesurés mais non
    // tarifés, restent hors des préréglages tout en restant saisissables.
    for (const preset of AI_PROVIDER_PRESETS) {
      for (const model of [...Object.values(preset.models ?? {}), ...preset.suggested]) {
        expect(hasKnownPrice(model), `${preset.id} → ${model}`).toBe(true);
      }
    }
  });
});
