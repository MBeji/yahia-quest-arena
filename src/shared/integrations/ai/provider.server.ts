// La PORTE — résolution de fournisseur et kill-switches (étude 29 §1.3, §3.10).
//
// L'INVARIANT QUE CE FICHIER INCARNE
// ---------------------------------------------------------------------------
// é26 D-8 : **une seule porte LLM runtime**. Cette étude ne crée pas un second
// moteur IA à côté de celui de é11 ; elle livre LE socle, en lui ajoutant la
// seule chose que é11 n'avait pas prévue : *de qui vient la clé*.
//
//     1. clé de la famille  → payeur = family    ← é29
//     2. clé plateforme     → payeur = platform  ← é11 (budget A5)
//     3. aucune             → mode IA éteint
//
// La chaîne est ORDONNÉE, et le mode « éteint » est un état de première classe :
// c'est l'état par défaut de tout le monde, et le produit y est complet (R-1).
// Aucun appelant ne doit traiter « éteint » comme une erreur.
//
// Les variables d'environnement sont lues À CHAQUE APPEL, jamais mémorisées :
// un kill-switch qu'il faut redéployer pour actionner n'est pas un kill-switch.

import { makeAnthropicProvider } from "./anthropic.server";
import { makeFakeAiProvider } from "./fake.server";
import { makeOpenAiCompatibleProvider } from "./openai-compatible.server";
import { sealSecret, type AiCredential, type AiProvider } from "./types";
import {
  AI_PLATFORM_DEFAULT_PRESET_ID,
  presetById,
  type AiPlatformIssue,
  type AiProviderId,
} from "@/shared/constants/ai";

/** `false` seulement sur une valeur explicitement fausse : l'absence vaut « allumé ». */
function envFlag(name: string, fallback: boolean): boolean {
  const raw = process.env[name];
  if (raw === undefined || raw === "") return fallback;
  return raw !== "0" && raw.toLowerCase() !== "false";
}

/**
 * Une variable d'environnement, ou `null` si elle est absente ou vide.
 *
 * Le `trim()` n'est pas de la coquetterie : une valeur collée dans le tableau de
 * bord de l'hébergeur emporte volontiers une espace ou un retour à la ligne, et
 * une adresse qui finit par `\n` échoue à la construction d'URL — avec un
 * message qui ne dit pas pourquoi.
 */
function envText(name: string): string | null {
  const raw = process.env[name]?.trim();
  return raw ? raw : null;
}

/** Kill-switch global de la porte IA (§3.10). Éteint ⇒ ni famille, ni plateforme. */
export function isAiModeEnabled(): boolean {
  return envFlag("AI_MODE_ENABLED", true);
}

/**
 * Kill-switch du seul chemin FAMILLE. Il dépend d'un fait autant que d'un
 * réglage : sans `AI_KEY_ENC_KEY`, le coffre ne peut ni écrire ni lire, donc le
 * BYOK est éteint quoi qu'en dise la variable — et le chemin plateforme, lui,
 * continue (§3.10).
 */
export function isByokEnabled(): boolean {
  if (!isAiModeEnabled()) return false;
  if (!process.env.AI_KEY_ENC_KEY) return false;
  return envFlag("AI_BYOK_ENABLED", true);
}

// ---------------------------------------------------------------------------
// Le fournisseur PLATEFORME — résolu depuis l'environnement, pas câblé
// ---------------------------------------------------------------------------

/** Ce que l'environnement décrit, une fois validé. Jamais la clé elle-même. */
export type PlatformProviderConfig = {
  /** L'identifiant de préréglage retenu — `custom` pour une adresse libre. */
  readonly presetId: string;
  readonly provider: AiProviderId;
  /** `null` pour Anthropic : son adresse est fixée par le SDK. */
  readonly baseUrl: string | null;
  readonly models: { readonly fast: string; readonly rich: string };
};

/**
 * Le résultat de la résolution. L'échec porte un MOTIF — le vocabulaire vit
 * dans `constants/ai.ts` ({@link AI_PLATFORM_ISSUES}), avec le pourquoi.
 */
export type PlatformProviderResolution =
  | { readonly ok: true; readonly config: PlatformProviderConfig }
  | { readonly ok: false; readonly issue: AiPlatformIssue };

/** La clé plateforme, quel que soit le fournisseur. */
function platformApiKey(): string | null {
  // `ANTHROPIC_API_KEY` reste acceptée : c'est le nom sous lequel la clé
  // plateforme a été posée en production, et une variable renommée du jour au
  // lendemain éteint le tuteur de tous les élèves sans clé de famille.
  return envText("AI_PLATFORM_API_KEY") ?? envText("ANTHROPIC_API_KEY");
}

/**
 * Le fournisseur plateforme, lu dans l'environnement à CHAQUE appel.
 *
 * Cinq variables, dont aucune n'est requise : sans elles, le préréglage
 * `anthropic` s'applique et le comportement est identique à ce qu'il était
 * quand ce chemin était câblé.
 *
 *   AI_PLATFORM_API_KEY     la clé (à défaut `ANTHROPIC_API_KEY`)
 *   AI_PLATFORM_PROVIDER    un id de {@link AI_PROVIDER_PRESETS} — deepseek,
 *                           xai, moonshot, zai, openai, anthropic, custom
 *   AI_PLATFORM_BASE_URL    l'adresse compatible OpenAI (obligatoire en custom)
 *   AI_PLATFORM_MODEL_FAST  le modèle du palier `fast`
 *   AI_PLATFORM_MODEL_RICH  celui du palier `rich`
 *
 * UN PRÉRÉGLAGE INCONNU EST REFUSÉ, PAS RATTRAPÉ. Retomber sur Anthropic
 * enverrait la clé DeepSeek d'un exploitant à l'adresse d'Anthropic — un 401
 * dont la cause serait invisible, là où le refus la nomme.
 */
export function resolvePlatformProvider(): PlatformProviderResolution {
  if (!platformApiKey()) return { ok: false, issue: "no_key" };

  const presetId = envText("AI_PLATFORM_PROVIDER") ?? AI_PLATFORM_DEFAULT_PRESET_ID;
  const preset = presetById(presetId);
  if (!preset) return { ok: false, issue: "unknown_preset" };

  // Le préréglage remplit, l'environnement surcharge — exactement l'ordre du
  // formulaire famille, où choisir « DeepSeek » pré-remplit deux champs qui
  // restent éditables (D-11).
  const baseUrl =
    preset.provider === "openai_compatible"
      ? (envText("AI_PLATFORM_BASE_URL") ?? preset.baseUrl)
      : null;

  if (preset.provider === "openai_compatible") {
    if (!baseUrl) return { ok: false, issue: "missing_base_url" };
    // Condition 1 de R-6, vérifiée ICI pour que l'erreur soit lisible à froid.
    // Les sept conditions restent appliquées à l'appel par `egressFetch` — ce
    // contrôle-ci s'y ajoute, il ne s'y substitue pas.
    if (!baseUrl.startsWith("https://")) return { ok: false, issue: "insecure_base_url" };
  }

  const fast = envText("AI_PLATFORM_MODEL_FAST") ?? preset.models?.fast ?? null;
  const rich = envText("AI_PLATFORM_MODEL_RICH") ?? preset.models?.rich ?? null;
  // « Autre » ne propose aucun modèle : les deux paliers doivent alors être
  // nommés. Un palier vide partirait tel quel chez le fournisseur, qui répondrait
  // par une erreur de modèle inconnu à chaque appel.
  if (!fast || !rich) return { ok: false, issue: "missing_model" };

  return {
    ok: true,
    config: { presetId: preset.id, provider: preset.provider, baseUrl, models: { fast, rich } },
  };
}

/** Le chemin plateforme est-il disponible ? (é11, budget A5) */
export function isPlatformPathEnabled(): boolean {
  return isAiModeEnabled() && resolvePlatformProvider().ok;
}

/** Fournisseur factice : CI, e2e, développement sans clé. Coût zéro, sortie stable. */
export function isFakeProvider(): boolean {
  return process.env.AI_FAKE_PROVIDER === "1";
}

/** Plafond plateforme par jour (A5 : 5 $). Ne s'applique JAMAIS au payeur `family` (§3.10). */
export function platformDailyBudgetUsd(): number {
  const raw = Number(process.env.AI_PLATFORM_DAILY_BUDGET_USD);
  return Number.isFinite(raw) && raw > 0 ? raw : 5;
}

/**
 * L'adaptateur pour un fournisseur donné.
 *
 * `AI_FAKE_PROVIDER=1` court-circuite TOUT : c'est la garantie que la CI ne peut
 * pas émettre un appel réel même si un test oublie un mock (§5 — « aucun appel
 * réel vers un fournisseur, jamais, sous aucun prétexte »).
 */
export function getAiProvider(provider: AiProviderId): AiProvider {
  if (isFakeProvider()) return makeFakeAiProvider();
  return provider === "anthropic" ? makeAnthropicProvider() : makeOpenAiCompatibleProvider();
}

/**
 * Le crédential du chemin PLATEFORME, construit depuis l'environnement.
 *
 * Il n'y a pas de coffre ici : la clé plateforme est une variable d'environnement
 * Vercel, pas une ligne de `ai_credentials`. C'est la seule asymétrie entre les
 * deux payeurs, et elle est structurelle — nous ne stockons pas notre propre clé
 * dans la base que nous exploitons.
 *
 * Rend `null` quand le chemin plateforme est éteint : un appelant ne doit jamais
 * avoir à distinguer « pas de clé » de « kill-switch », seulement « pas de porte ».
 *
 * IL NE PREND PLUS SES MODÈLES DE L'APPELANT. L'orchestrateur en écrivait deux
 * en dur (`claude-haiku-4-5` / `claude-sonnet-5`) : des identifiants de modèle
 * hors de `constants/ai.ts`, et une bascule de fournisseur qui aurait demandé de
 * modifier du code de feature. Ils viennent maintenant du même endroit que le
 * reste — préréglage ou environnement.
 */
export function platformCredential(): AiCredential | null {
  const apiKey = platformApiKey();
  const resolved = resolvePlatformProvider();
  if (!isAiModeEnabled() || !apiKey || !resolved.ok) return null;
  return {
    provider: resolved.config.provider,
    baseUrl: resolved.config.baseUrl ?? undefined,
    secret: sealSecret(apiKey),
    models: resolved.config.models,
  };
}
