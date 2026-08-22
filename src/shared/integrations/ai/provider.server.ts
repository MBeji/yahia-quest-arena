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
import type { AiProviderId } from "@/shared/constants/ai";

/** `false` seulement sur une valeur explicitement fausse : l'absence vaut « allumé ». */
function envFlag(name: string, fallback: boolean): boolean {
  const raw = process.env[name];
  if (raw === undefined || raw === "") return fallback;
  return raw !== "0" && raw.toLowerCase() !== "false";
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

/** Le chemin plateforme est-il disponible ? (é11, budget A5) */
export function isPlatformPathEnabled(): boolean {
  return isAiModeEnabled() && Boolean(process.env.ANTHROPIC_API_KEY);
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
 */
export function platformCredential(models: { fast: string; rich: string }): AiCredential | null {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!isAiModeEnabled() || !apiKey) return null;
  return { provider: "anthropic", secret: sealSecret(apiKey), models };
}
