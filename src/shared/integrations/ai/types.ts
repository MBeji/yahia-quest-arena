// Le contrat d'adaptateur — `AiProvider` (étude 29 §3.5).
//
// Généralisation du `TutorLLM` de é11 §3.5 : même intention (le nom d'un
// fournisseur n'apparaît JAMAIS dans le code d'une feature), périmètre élargi au
// payeur. Une feature demande un `tier` et une `feature` ; elle ne sait pas, et
// n'a pas à savoir, si c'est Anthropic, un compatible OpenAI ou le fournisseur
// factice de la CI qui répond.
//
// Module ISOMORPHE : ce sont des types et une marque de sécurité, pas du réseau.

import type { AiFeature, AiProviderId, AiTier } from "@/shared/constants/ai";

/**
 * Un secret **opaque**. Le type existe pour rendre l'invariant D-3 vérifiable
 * par le compilateur : une valeur de ce type ne peut pas être concaténée dans
 * une chaîne, écrite dans un log, ni renvoyée par une server fn sans un
 * `revealSecret()` explicite — qui n'existe que dans l'adaptateur.
 *
 * Ce n'est pas un chiffrement : c'est un panneau qu'on ne peut pas ne pas voir.
 */
declare const OPAQUE: unique symbol;
export type OpaqueSecret = { readonly [OPAQUE]: "ai-secret"; readonly __brand: never };

/**
 * Le clair vit derrière une clé SYMBOLE non énumérable. Ce n'est pas une
 * coquetterie : `JSON.stringify` ignore les clés symboles, `Object.keys` ne les
 * voit pas, et `logger` sérialise sa méta en JSON. Une première version stockait
 * le clair dans une propriété `value` ordinaire — un secret passé par mégarde
 * dans la méta d'un log en serait ressorti EN CLAIR, parce que le rédacteur du
 * logger ne rédige que sur le NOM du champ, et `value` n'est pas un nom suspect.
 * Le test « le secret ouvert est OPAQUE » garde cette propriété.
 *
 * `Symbol.for` et non `Symbol()` : le symbole doit être le MÊME d'une instance
 * de module à l'autre. Un `Symbol()` local casse dès que le graphe est dupliqué
 * — un `vi.resetModules()` suffit à le prouver, et un bundler peut faire pareil
 * en production. Le registre global ne réduit pas la protection : le but est
 * qu'une fuite se voie en revue, pas qu'elle soit cryptographiquement empêchée.
 */
const SECRET_VALUE = Symbol.for("na9ra.ai.secret");

/** Emballe une clé en clair. Appelé UNIQUEMENT par le coffre, après déchiffrement. */
export function sealSecret(clear: string): OpaqueSecret {
  const holder = {
    toString: () => "[secret]",
    // Les trois portes par lesquelles une valeur sort d'un objet sans qu'on l'ait
    // demandé : concaténation, sérialisation JSON, inspection Node (`console.log`).
    toJSON: () => "[secret]",
    [Symbol.for("nodejs.util.inspect.custom")]: () => "[secret]",
  };
  Object.defineProperty(holder, SECRET_VALUE, { value: clear, enumerable: false });
  return holder as unknown as OpaqueSecret;
}

/**
 * Déballe une clé. Appelé UNIQUEMENT par un adaptateur, pour poser l'en-tête
 * d'autorisation, dans le même appel. Toute autre utilisation est un bug de
 * revue — et il se voit, parce que ce nom est cherchable.
 */
export function revealSecret(secret: OpaqueSecret): string {
  return (secret as unknown as Record<symbol, string>)[SECRET_VALUE];
}

/**
 * Un bloc de contexte. L'ORDRE est significatif : du plus stable au plus
 * volatil, pour que le préfixe reste identique d'un appel à l'autre et que le
 * cache de prompt du fournisseur morde (é11 §3.4). Un horodatage placé en tête
 * invalide tout ce qui suit.
 */
export type AiBlock = {
  /** Étiquette de journalisation — jamais envoyée au modèle. */
  readonly label: string;
  readonly text: string;
  /** `true` sur le DERNIER bloc stable : c'est là que se pose la césure de cache. */
  readonly cacheBoundary?: boolean;
};

export type AiRequest = {
  readonly tier: AiTier;
  /** Instructions système. Hiérarchie de confiance : rien de ce que l'élève écrit n'entre ici (é11 R-5). */
  readonly system: string;
  /** Contexte, du stable au volatil. */
  readonly blocks: readonly AiBlock[];
  /** Plafond de sortie. Vient de `AI_MAX_TOKENS`, jamais d'un appelant (R-10). */
  readonly maxTokens: number;
  readonly feature: AiFeature;
  /**
   * Schéma de sortie attendu, en JSON Schema. Un fournisseur qui déclare
   * `structuredOutput` le contraint nativement ; les autres le demandent dans le
   * prompt et subissent un taux de rebut supérieur — c'est un fait à afficher
   * (R-19), pas à masquer.
   */
  readonly responseSchema?: Record<string, unknown>;
  /**
   * Patience de CET appel, en millisecondes. Absent ⇒ le barème par surface
   * ({@link AI_TIMEOUT_MS}).
   *
   * Il existe parce qu'une surface n'a pas toujours la même durée : la Forge
   * demande N+2 questions, et un modèle à raisonnement passe des milliers de
   * tokens de réflexion sur CHACUNE. Un délai unique calibré sur le plus petit
   * quiz condamne les grands — c'est la panne du 2026-08-26, où un quiz de huit
   * questions (dix candidats) dépassait un plafond réglé pour sept.
   *
   * Ce n'est PAS une porte ouverte à l'appelant : la borne haute reste celle de
   * R-6 condition 6, vérifiée contre le `maxDuration` de la fonction SSR.
   */
  readonly timeoutMs?: number;
};

/** Ce que le fournisseur rapporte avoir consommé. Base de l'estimation de coût (R-12). */
export type AiUsage = {
  readonly inputTokens: number;
  readonly outputTokens: number;
  /** Tokens d'entrée servis depuis le cache du fournisseur. 0 quand il n'en a pas. */
  readonly cachedTokens: number;
};

export type AiResult = {
  readonly text: string;
  readonly usage: AiUsage;
  /** L'id de modèle RÉELLEMENT utilisé — c'est lui qui est journalisé (R-13). */
  readonly model: string;
  readonly latencyMs: number;
};

export type AiChunk =
  | { readonly type: "text"; readonly text: string }
  | {
      readonly type: "done";
      readonly result: AiResult;
    };

/** L'identité du coffre à ouvrir, résolue côté serveur. Ne circule jamais vers le client. */
export type AiCredential = {
  readonly provider: AiProviderId;
  /** NULL sauf `openai_compatible` ; validée par les sept conditions de R-6. */
  readonly baseUrl?: string;
  readonly secret: OpaqueSecret;
  readonly models: { readonly fast: string; readonly rich: string };
};

/**
 * Ce qu'un fournisseur sait faire. Ce n'est pas décoratif : la Forge bascule en
 * « JSON demandé dans le prompt » sans `structuredOutput`, et le chat de é11
 * retombe en réponse non streamée sans `streaming` — dégradation prévue, pas
 * panne (§3.5).
 */
export type AiCapabilities = {
  readonly streaming: boolean;
  readonly structuredOutput: boolean;
  readonly promptCache: boolean;
};

export interface AiProvider {
  readonly id: AiProviderId | "fake";
  readonly capabilities: AiCapabilities;
  generate(req: AiRequest, cred: AiCredential): Promise<AiResult>;
  stream(req: AiRequest, cred: AiCredential): AsyncIterable<AiChunk>;
}

/**
 * Assemble les blocs en un seul texte utilisateur. Fonction PURE, partagée par
 * les deux adaptateurs : deux façons de sérialiser le contexte, ce serait deux
 * préfixes différents, donc deux caches de prompt qui ne se rejoignent jamais.
 */
export function renderBlocks(blocks: readonly AiBlock[]): string {
  return blocks.map((b) => `<${b.label}>\n${b.text}\n</${b.label}>`).join("\n\n");
}

/** L'index du dernier bloc marqué `cacheBoundary`, ou -1. */
export function cacheBoundaryIndex(blocks: readonly AiBlock[]): number {
  let last = -1;
  blocks.forEach((b, i) => {
    if (b.cacheBoundary) last = i;
  });
  return last;
}
