// L'ORCHESTRATEUR — le chemin qu'emprunte CHAQUE appel IA (étude 29 §3.1).
//
// Sept étapes, dans cet ordre, sans exception :
//
//   1. resolve_ai_access(élève, surface)   ← SQL : R-1 / R-2 / R-3 / R-9
//   2. reserve_ai_spend(argent + énergie)  ← SQL : R-11, atomique
//   3. charge le chiffré (service_role)    ← R-5, mémoire seule
//   4. déchiffre + AiProvider.generate
//   5. valide la sortie
//   6. log_ai_usage(payeur, fournisseur, modèle, tokens, coût)
//   7. libère ou solde la réservation
//
// POURQUOI L'ORDRE COMPTE
// ---------------------------------------------------------------------------
// La réservation vient AVANT l'appel (D-8) : vérifier après, c'est découvrir le
// dépassement une fois qu'il est payé. Le déchiffrement vient après la
// réservation : inutile d'ouvrir le coffre pour un appel qu'on va refuser. Et le
// solde vient toujours, même sur un échec — un appel qui a échoué CHEZ le
// fournisseur a pu être facturé.
//
// CE QUE L'APPELANT N'A PAS À SAVOIR
// ---------------------------------------------------------------------------
// Ni le fournisseur, ni le modèle, ni qui paie. Il demande une surface et un
// palier ; il reçoit un texte ou un refus TYPÉ. C'est ce qui permet aux lots
// suivants — et aux lots 1-7 de l'étude 11 — d'être écrits une seule fois pour
// les deux payeurs (D-7 : « le payeur est une colonne, pas un mode de
// déploiement »).
//
// LA DÉGRADATION EST SILENCIEUSE CÔTÉ ÉLÈVE (é11 R-15)
// ---------------------------------------------------------------------------
// Un refus n'est jamais une exception : c'est un `{ ok: false, code }`. La
// surface appelante disparaît, le produit déterministe reprend la main, et
// l'élève ne voit pas d'erreur. Le porteur, lui, voit l'état dans sa console.

import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import {
  AI_ENERGY_COST,
  AI_MAX_TOKENS,
  type AiFeature,
  type AiPayer,
  type AiProviderId,
  type AiTier,
} from "@/shared/constants/ai";
import { toAiError, type AiErrorCode } from "@/shared/integrations/ai";
import {
  estimateCostMicros,
  estimateTokens,
  settledCostMicros,
} from "@/shared/integrations/ai/pricing";
import {
  getAiProvider,
  isAiModeEnabled,
  platformCredential,
} from "@/shared/integrations/ai/provider.server";
import { logAiUsage } from "@/shared/integrations/ai/usage.server";
import { renderBlocks, type AiBlock, type AiCredential } from "@/shared/integrations/ai/types";
import { AI_ENC_VERSION, openSecret, rewriteUnderCurrentKek } from "./crypto.server";
import { markCredentialState } from "./ai-credentials.server";
import { notifyBudgetAlerts } from "./ai-alerts.server";

/**
 * Les RPC du lot 3 sont postérieures aux types Supabase générés (non
 * régénérables sans accès DB) : contrat figé ici, même patron que
 * `exam.server.ts`. À supprimer à la prochaine régénération des types.
 */
type AiCallRpcClient = {
  rpc: (
    fn: "resolve_ai_access" | "reserve_ai_spend" | "settle_ai_spend" | "release_ai_reservation",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

const rpc = () => supabaseAdmin as unknown as AiCallRpcClient;

/**
 * La lecture du CHIFFRÉ, et d'elle seule. L'étude la décrit ainsi : « le
 * chargement du chiffré se fait en Node, avec le client `service_role` » (§3.4).
 * La table n'est pas dans les types générés (elle est postérieure), et son
 * contrat est figé ici — trois colonnes, jamais une de plus.
 *
 * `secret_enc` sort d'ici sous sa forme CHIFFRÉE. Le seul consommateur est le
 * coffre, dans la ligne suivante.
 */
type AiSecretReader = {
  from: (table: "ai_credentials") => {
    select: (columns: string) => {
      eq: (
        column: string,
        value: string,
      ) => {
        maybeSingle: () => PromiseLike<{
          data: { secret_enc: string; enc_version: number; provider: AiProviderId } | null;
          error: { message: string } | null;
        }>;
      };
    };
  };
};

type AccessRow = {
  allowed: boolean;
  payer: AiPayer;
  owner_user_id: string | null;
  provider: AiProviderId | null;
  base_url: string | null;
  model_fast: string | null;
  model_rich: string | null;
  energy_left: number;
  double_solve: boolean | null;
  reason: string | null;
};

export type AiCallRequest = {
  readonly studentUserId: string;
  readonly feature: AiFeature;
  readonly tier: AiTier;
  readonly system: string;
  readonly blocks: readonly AiBlock[];
  readonly responseSchema?: Record<string, unknown>;
  /**
   * Surcharge du coût en énergie. Absent ⇒ le barème de la surface
   * ({@link AI_ENERGY_COST}). Sert à la Forge, qui débite une fois pour un quiz
   * entier plutôt qu'une fois par candidat.
   */
  readonly energyCost?: number;
};

export type AiCallOutcome =
  | {
      readonly ok: true;
      readonly text: string;
      readonly model: string;
      readonly payer: AiPayer;
      readonly costUsdMicros: number;
      /** R-18bis : la double résolution est-elle demandée pour ce porteur ? */
      readonly doubleSolve: boolean;
    }
  | { readonly ok: false; readonly code: AiErrorCode };

/** Un refus, journalisé et rendu — jamais levé (é11 R-15). */
function refuse(feature: AiFeature, code: AiErrorCode): AiCallOutcome {
  logger.info("ai.request", { feature, status: "degraded", errorCode: code });
  return { ok: false, code };
}

/** Charge et déchiffre le secret d'un porteur. `null` ⇒ clé illisible (RISK-10). */
async function loadCredential(
  ownerUserId: string,
  access: AccessRow,
): Promise<AiCredential | null> {
  const { data: row, error } = await (supabaseAdmin as unknown as AiSecretReader)
    .from("ai_credentials")
    .select("secret_enc, enc_version, provider")
    .eq("owner_user_id", ownerUserId)
    .maybeSingle();

  if (error || !row) {
    logger.error("ai.credential.load", { error: error ? errorMessage(error) : "missing" });
    return null;
  }

  // PostgREST rend un `bytea` en notation `\x…`. C'est le seul endroit du
  // système qui reconstitue le tampon, et il le passe immédiatement au coffre.
  const blob = Buffer.from(row.secret_enc.replace(/^\\x/, ""), "hex");
  const opened = openSecret(blob, {
    ownerUserId,
    provider: row.provider,
    encVersion: row.enc_version ?? AI_ENC_VERSION,
  });

  if (!opened) {
    // Clé illisible : KEK perdue ou remplacée sans rotation, chiffré déplacé.
    // Aucune donnée d'apprentissage n'est perdue — seule la clé l'est, et son
    // porteur est invité à la re-saisir (RISK-10).
    await markCredentialState(ownerUserId, "invalid", "AI_KEY_INVALID");
    return null;
  }

  if (opened.needsRewrite) {
    // Rotation paresseuse : la lecture a réussi avec la KEK précédente. On ne
    // bloque pas l'appel là-dessus — la ré-écriture est un effet de bord, et son
    // échec se rattrape à la lecture suivante.
    void rewriteSecret(ownerUserId, blob, row.provider, row.enc_version ?? AI_ENC_VERSION);
  }

  return {
    provider: access.provider ?? row.provider,
    baseUrl: access.base_url ?? undefined,
    secret: opened.secret,
    models: { fast: access.model_fast ?? "", rich: access.model_rich ?? "" },
  };
}

async function rewriteSecret(
  ownerUserId: string,
  blob: Buffer,
  provider: AiProviderId,
  encVersion: number,
): Promise<void> {
  const next = rewriteUnderCurrentKek(blob, { ownerUserId, provider, encVersion });
  if (!next) return;
  const { error } = await (
    supabaseAdmin as unknown as {
      rpc: (
        fn: "rewrite_ai_credential_secret",
        args: Record<string, unknown>,
      ) => PromiseLike<{
        error: { message: string } | null;
      }>;
    }
  ).rpc("rewrite_ai_credential_secret", {
    p_owner: ownerUserId,
    p_secret_enc: `\\x${next.toString("hex")}`,
    p_enc_version: encVersion,
  });
  if (error) logger.warn("ai.credential.rotate", { error: errorMessage(error) });
}

/**
 * Émet un appel IA pour un élève, ou explique pourquoi il ne part pas.
 *
 * Ne LÈVE jamais pour un refus métier : les exceptions sont réservées aux bugs.
 */
export async function callAi(request: AiCallRequest): Promise<AiCallOutcome> {
  const { studentUserId, feature, tier } = request;

  // Kill-switch d'ENVIRONNEMENT, avant même d'interroger la base : le premier
  // geste d'un incident est de baisser un interrupteur, pas d'attendre une RPC.
  if (!isAiModeEnabled()) return refuse(feature, "AI_MODE_OFF");

  // 1. La résolution — R-1/R-2/R-3/R-9, décidées en SQL.
  const { data: rows, error: resolveError } = await rpc().rpc("resolve_ai_access", {
    p_student: studentUserId,
    p_feature: feature,
  });
  if (resolveError) {
    logger.error("ai.resolve", { error: errorMessage(resolveError), feature });
    return refuse(feature, "AI_UNKNOWN");
  }

  const access = (Array.isArray(rows) ? rows[0] : null) as AccessRow | null;
  if (!access) return refuse(feature, "AI_MODE_OFF");

  // Le chemin PLATEFORME : la base a dit « pas de clé de famille », Node décide
  // si notre propre clé prend le relais (é11, budget A5). Il n'y a pas de
  // troisième moteur — seulement un second payeur derrière la même porte.
  const usePlatform = !access.allowed && access.payer === "platform";
  const maxTokens = AI_MAX_TOKENS[feature];
  const energyCost = request.energyCost ?? AI_ENERGY_COST[feature];
  const contextTokens = estimateTokens(`${request.system}\n${renderBlocks(request.blocks)}`);

  if (usePlatform) {
    return callOnPlatform(request, { maxTokens, contextTokens });
  }

  if (!access.allowed || !access.owner_user_id || !access.provider) {
    return refuse(feature, (access.reason as AiErrorCode | null) ?? "AI_MODE_OFF");
  }

  const ownerUserId = access.owner_user_id;
  const model = tier === "rich" ? (access.model_rich ?? "") : (access.model_fast ?? "");
  const estimate = estimateCostMicros({
    model,
    estimatedInputTokens: contextTokens,
    maxOutputTokens: maxTokens,
  });

  // 2. La réservation — argent ET énergie, atomiquement, AVANT l'appel (R-11).
  const { data: reservation, error: reserveError } = await rpc().rpc("reserve_ai_spend", {
    p_owner: ownerUserId,
    p_student: studentUserId,
    p_micros: estimate,
    p_energy: energyCost,
  });
  if (reserveError) {
    logger.error("ai.reserve", { error: errorMessage(reserveError), feature });
    return refuse(feature, "AI_UNKNOWN");
  }

  const grant = (Array.isArray(reservation) ? reservation[0] : null) as {
    granted: boolean;
    reason: string | null;
  } | null;

  if (!grant?.granted) {
    const code = (grant?.reason as AiErrorCode | null) ?? "AI_BUDGET_REACHED";
    logger.info("ai.budget", { owner: ownerUserId, action: "cut", code });
    // Le porteur est prévenu une fois — pas à chaque appel (R-11).
    void notifyBudgetAlerts(ownerUserId);
    return refuse(feature, code);
  }

  // 3-4. Le coffre, puis l'appel.
  const credential = await loadCredential(ownerUserId, access);
  if (!credential) {
    await releaseReservation(ownerUserId, studentUserId, estimate, energyCost);
    return refuse(feature, "AI_KEY_INVALID");
  }

  const startedAt = Date.now();
  try {
    const result = await getAiProvider(access.provider).generate(
      {
        tier,
        system: request.system,
        blocks: request.blocks,
        maxTokens,
        feature,
        responseSchema: request.responseSchema,
      },
      credential,
    );

    const actual = settledCostMicros({ model: result.model, ...result.usage });

    // 6-7. Comptabilité, puis solde réel.
    await Promise.all([
      logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
        userId: studentUserId,
        payer: "family",
        credentialOwner: ownerUserId,
        provider: access.provider,
        feature,
        model: result.model,
        inputTokens: result.usage.inputTokens,
        outputTokens: result.usage.outputTokens,
        cachedTokens: result.usage.cachedTokens,
        costUsdMicros: actual,
        status: "ok",
        latencyMs: result.latencyMs,
      }),
      settle(ownerUserId, estimate, actual),
    ]);

    void notifyBudgetAlerts(ownerUserId);

    return {
      ok: true,
      text: result.text,
      model: result.model,
      payer: "family",
      costUsdMicros: actual,
      doubleSolve: access.double_solve ?? true,
    };
  } catch (error) {
    const typed = toAiError(error);

    // Une clé refusée le reste : la marquer évite que chaque appel suivant
    // re-découvre la même chose sur le quota du parent (§3.5).
    if (typed.code === "AI_KEY_INVALID") {
      await markCredentialState(ownerUserId, "invalid", typed.code);
    }

    // L'énergie est REMBOURSÉE (é11 R-15) ; l'argent réservé est libéré, parce
    // qu'aucun appel n'a abouti. Un appel qui échoue AVANT d'atteindre le
    // fournisseur n'a rien coûté ; un appel qui échoue APRÈS a été facturé, mais
    // nous n'avons alors aucun usage à solder — l'estimation resterait plus
    // fausse que zéro, et la facture du fournisseur reste le juge (R-12).
    await releaseReservation(ownerUserId, studentUserId, estimate, energyCost);

    await logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
      userId: studentUserId,
      payer: "family",
      credentialOwner: ownerUserId,
      provider: access.provider,
      feature,
      model,
      status: "error",
      errorCode: typed.code,
      latencyMs: Date.now() - startedAt,
    });

    return refuse(feature, typed.code);
  }
}

/**
 * Le chemin PLATEFORME (é11, budget A5). Volontairement minimal ici : le lot 1
 * de é11 le complétera avec son propre plafond journalier. Ce qui compte pour
 * é29, c'est que le payeur soit écrit (R-7) et qu'aucune clé de famille ne soit
 * utilisée pour un travail qui ne sert pas ses propres élèves (R-8).
 */
async function callOnPlatform(
  request: AiCallRequest,
  bounds: { maxTokens: number; contextTokens: number },
): Promise<AiCallOutcome> {
  const models = { fast: "claude-haiku-4-5", rich: "claude-sonnet-5" };
  const credential = platformCredential(models);
  if (!credential) return refuse(request.feature, "AI_MODE_OFF");

  const startedAt = Date.now();
  try {
    const result = await getAiProvider("anthropic").generate(
      {
        tier: request.tier,
        system: request.system,
        blocks: request.blocks,
        maxTokens: bounds.maxTokens,
        feature: request.feature,
        responseSchema: request.responseSchema,
      },
      credential,
    );
    const actual = settledCostMicros({ model: result.model, ...result.usage });

    await logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
      userId: request.studentUserId,
      payer: "platform",
      credentialOwner: null,
      provider: "anthropic",
      feature: request.feature,
      model: result.model,
      inputTokens: result.usage.inputTokens,
      outputTokens: result.usage.outputTokens,
      cachedTokens: result.usage.cachedTokens,
      costUsdMicros: actual,
      status: "ok",
      latencyMs: result.latencyMs,
    });

    return {
      ok: true,
      text: result.text,
      model: result.model,
      payer: "platform",
      costUsdMicros: actual,
      // R-18bis.4 : sur le chemin plateforme la vérification est TOUJOURS
      // complète. C'est nous qui payons, et c'est notre nom sur le contenu.
      doubleSolve: true,
    };
  } catch (error) {
    const typed = toAiError(error);
    await logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
      userId: request.studentUserId,
      payer: "platform",
      credentialOwner: null,
      provider: "anthropic",
      feature: request.feature,
      model: request.tier === "rich" ? models.rich : models.fast,
      status: "error",
      errorCode: typed.code,
      latencyMs: Date.now() - startedAt,
    });
    return refuse(request.feature, typed.code);
  }
}

async function settle(owner: string, reserved: number, actual: number): Promise<void> {
  const { error } = await rpc().rpc("settle_ai_spend", {
    p_owner: owner,
    p_reserved_micros: reserved,
    p_actual_micros: actual,
  });
  if (error) logger.error("ai.settle", { error: errorMessage(error) });
}

async function releaseReservation(
  owner: string,
  student: string,
  micros: number,
  energy: number,
): Promise<void> {
  const { error } = await rpc().rpc("release_ai_reservation", {
    p_owner: owner,
    p_student: student,
    p_micros: micros,
    p_energy: energy,
  });
  if (error) logger.error("ai.release", { error: errorMessage(error) });
}
