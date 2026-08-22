// La COMPTABILITÉ — un appel IA porte toujours un payeur (étude 29, R-7).
//
// « Aucun appel n'est émis sans payeur identifié — c'est la condition pour
// qu'aucune dépense ne soit orpheline. » Ce module est le point de passage
// unique : chaque appel, réussi ou non, laisse une ligne dans `ai_usage_events`
// avec son payeur, son fournisseur, son modèle réel et son coût estimé.
//
// CE QUI N'ENTRE JAMAIS DANS UN ÉVÉNEMENT (§3.9, `docs/logging-standard.md`) :
// la clé, un fragment de clé au-delà de `last4`, le texte de l'élève, la sortie
// du modèle. Une ligne de comptabilité dit COMBIEN et QUOI, jamais QUEL CONTENU.

import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import type { AiFeature, AiPayer, AiTier } from "@/shared/constants/ai";
import type { AiErrorCode } from "./errors";

/**
 * `log_ai_usage` est postérieure aux types Supabase générés (non régénérables
 * sans accès DB) : on fige son contrat ici, même patron que `exam.server.ts`,
 * `economy.server.ts` et `dashboard.server.ts`. À supprimer à la prochaine
 * régénération des types.
 */
type AiUsageRpcClient = {
  rpc: (
    fn: "log_ai_usage",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

/** L'état terminal d'un appel. Miroir du CHECK de `ai_usage_events.status`. */
export type AiUsageStatus = "ok" | "rejected" | "error" | "degraded" | "discarded";

export type AiUsageEvent = {
  /** L'élève SERVI. `null` pour un appel qui ne sert personne (vérification de clé). */
  readonly userId: string | null;
  readonly payer: AiPayer;
  /** Le porteur de la clé. `null` sur le chemin plateforme — c'est nous qui payons. */
  readonly credentialOwner: string | null;
  readonly provider: string;
  readonly feature: AiFeature;
  /** Le modèle RÉELLEMENT utilisé, tel que rapporté par le fournisseur (R-13). */
  readonly model: string;
  readonly inputTokens?: number;
  readonly outputTokens?: number;
  readonly cachedTokens?: number;
  readonly costUsdMicros?: number;
  readonly status: AiUsageStatus;
  readonly errorCode?: AiErrorCode | null;
  readonly latencyMs?: number;
};

/**
 * Écrit l'événement, et n'interrompt JAMAIS l'appelant.
 *
 * Une panne de comptabilité ne doit pas priver un élève de son explication —
 * même posture que `record_learning_pulse` : on journalise l'échec, on rend
 * `false`, et la surface continue. Le prix de ce choix est explicite : une
 * écriture perdue est une dépense non comptée, donc un plafond légèrement
 * sous-estimé. C'est acceptable parce que la COUPURE, elle, ne dépend pas de
 * cette table mais de `ai_spend_ledger`, écrit dans la même transaction que la
 * réservation (R-11, D-8).
 */
export async function logAiUsage(client: AiUsageRpcClient, event: AiUsageEvent): Promise<boolean> {
  const { error } = await client.rpc("log_ai_usage", {
    p_user: event.userId,
    p_payer: event.payer,
    p_credential_owner: event.credentialOwner,
    p_provider: event.provider,
    p_feature: event.feature,
    p_model: event.model,
    p_input_tokens: event.inputTokens ?? 0,
    p_output_tokens: event.outputTokens ?? 0,
    p_cached_tokens: event.cachedTokens ?? 0,
    p_cost_usd_micros: event.costUsdMicros ?? 0,
    p_status: event.status,
    p_error_code: event.errorCode ?? null,
    p_latency_ms: event.latencyMs ?? null,
  });

  if (error) {
    logger.error("ai.usage.write", { error: errorMessage(error), feature: event.feature });
    return false;
  }
  return true;
}

/**
 * Le log structuré `ai.request` (§3.9). Séparé de l'écriture en base parce que
 * les deux ont des destinataires différents : la base sert la console parent,
 * le log sert l'exploitation.
 *
 * La liste des champs est FERMÉE. Ajouter « juste le prompt pour déboguer » est
 * la façon dont les fuites arrivent — et `logger` ne rédige que sur le NOM de la
 * clé, donc un champ mal nommé passerait.
 */
export function logAiRequest(fields: {
  feature: AiFeature;
  payer: AiPayer;
  provider: string;
  model: string;
  tier: AiTier;
  latencyMs: number;
  tokensIn: number;
  tokensOut: number;
  costUsdMicros: number;
  status: AiUsageStatus;
  errorCode?: AiErrorCode | null;
}): void {
  logger.info("ai.request", { ...fields, errorCode: fields.errorCode ?? null });
}
