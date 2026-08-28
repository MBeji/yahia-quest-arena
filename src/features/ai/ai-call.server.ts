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
  MICROS_PER_USD,
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
  platformDailyBudgetUsd,
} from "@/shared/integrations/ai/provider.server";
import { logAiUsage } from "@/shared/integrations/ai/usage.server";
import {
  renderBlocks,
  type AiBlock,
  type AiCredential,
  type AiRequest,
  type AiResult,
} from "@/shared/integrations/ai/types";
import { markCredentialState, openOwnerSecret } from "./ai-vault.server";
import { notifyBudgetAlerts } from "./ai-alerts.server";

const rpc = () => supabaseAdmin;

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
  /**
   * La surface contre laquelle l'ACCÈS est résolu, quand elle diffère de celle
   * qui est journalisée. Absent ⇒ `feature`.
   *
   * Un seul cas aujourd'hui, et il est structurel : la double résolution de la
   * Forge se journalise en `forge_solve` — pour que la comptabilité distingue
   * les deux moitiés de la dépense (annexe A) — mais elle s'autorise sur
   * `forge`, parce que le porteur active « la Forge », pas « la seconde moitié
   * de la Forge ». Sans cette distinction, `forge_solve` devrait figurer dans
   * l'écran d'activation, et un porteur pourrait activer la génération sans sa
   * vérification : exactement ce que R-18bis interdit.
   */
  readonly accessFeature?: AiFeature;
  /**
   * Patience de CET appel. Absent ⇒ le barème par surface
   * ({@link AI_TIMEOUT_MS}). Un seul appelant aujourd'hui : la Forge, dont la
   * durée dépend du NOMBRE de candidats demandés — voir `forgeTimeoutMs`.
   */
  readonly timeoutMs?: number;
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
  const opened = await openOwnerSecret(ownerUserId);
  if (!opened) return null;

  return {
    // L'accès fait foi sur le fournisseur et les modèles — c'est lui que la
    // porte a résolu. Le coffre ne rend que le secret, et le fournisseur en
    // repli pour le cas où l'accès n'en porte pas.
    provider: access.provider ?? opened.provider,
    baseUrl: access.base_url ?? undefined,
    secret: opened.secret,
    models: { fast: access.model_fast ?? "", rich: access.model_rich ?? "" },
  };
}

/**
 * LE BILLET D'APPEL — ce que la préparation a résolu, et qu'il faudra solder.
 *
 * Il existe pour une raison précise : le lot 3 de é11 ouvre une seconde forme
 * d'appel — le STREAMING — et elle doit emprunter EXACTEMENT le même chemin
 * d'argent. Sans ce billet, `streamAi()` recopierait la résolution, la
 * réservation, la comptabilité et le solde ; six mois plus tard l'une des deux
 * copies aurait un plafond que l'autre n'a pas.
 *
 * La forme du billet dit aussi ce qui différencie les deux payeurs : un porteur
 * (`ownerUserId`) ou personne. Tout le reste — bornes, estimation, énergie — est
 * commun, et c'est bien ce que é29 D-7 affirmait : « le payeur est une colonne,
 * pas un mode de déploiement ».
 */
type AiTicket = {
  readonly payer: AiPayer;
  /** `null` sur le chemin plateforme : la clé est une variable d'environnement. */
  readonly ownerUserId: string | null;
  readonly provider: AiProviderId;
  readonly credential: AiCredential;
  /** Le modèle DEMANDÉ. Celui rapporté par l'API fait foi au succès (R-13). */
  readonly model: string;
  readonly maxTokens: number;
  readonly estimate: number;
  readonly energyCost: number;
  readonly doubleSolve: boolean;
  readonly startedAt: number;
};

type AiPreparation =
  | { readonly ok: true; readonly ticket: AiTicket }
  | { readonly ok: false; readonly code: AiErrorCode };

/**
 * Étapes 1 à 4 : kill-switch, résolution, réservation, coffre.
 *
 * Après elle, l'argent et l'énergie sont RÉSERVÉS : tout chemin qui n'aboutit
 * pas doit passer par `concludeFailure`, sinon la réservation reste gelée
 * jusqu'au balayage des dix minutes.
 */
async function prepareAiCall(request: AiCallRequest): Promise<AiPreparation> {
  const { studentUserId, feature, tier } = request;

  // Kill-switch d'ENVIRONNEMENT, avant même d'interroger la base : le premier
  // geste d'un incident est de baisser un interrupteur, pas d'attendre une RPC.
  if (!isAiModeEnabled()) return { ok: false, code: "AI_MODE_OFF" };

  // 1. La résolution — R-1/R-2/R-3/R-9, décidées en SQL.
  const { data: rows, error: resolveError } = await rpc().rpc("resolve_ai_access", {
    p_student: studentUserId,
    p_feature: request.accessFeature ?? feature,
  });
  if (resolveError) {
    logger.error("ai.resolve", { error: errorMessage(resolveError), feature });
    return { ok: false, code: "AI_UNKNOWN" };
  }

  const access = (Array.isArray(rows) ? rows[0] : null) as AccessRow | null;
  if (!access) return { ok: false, code: "AI_MODE_OFF" };

  const maxTokens = AI_MAX_TOKENS[feature];
  const energyCost = request.energyCost ?? AI_ENERGY_COST[feature];
  const contextTokens = estimateTokens(`${request.system}\n${renderBlocks(request.blocks)}`);

  // Le chemin PLATEFORME : la base a dit « pas de clé de famille », Node décide
  // si notre propre clé prend le relais (é11, budget A5). Il n'y a pas de
  // troisième moteur — seulement un second payeur derrière la même porte.
  if (!access.allowed && access.payer === "platform") {
    return preparePlatformCall(request, {
      maxTokens,
      contextTokens,
      energyCost,
    });
  }

  if (!access.allowed || !access.owner_user_id || !access.provider) {
    return {
      ok: false,
      code: (access.reason as AiErrorCode | null) ?? "AI_MODE_OFF",
    };
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
    return { ok: false, code: "AI_UNKNOWN" };
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
    return { ok: false, code };
  }

  // 3-4. Le coffre.
  const credential = await loadCredential(ownerUserId, access);
  if (!credential) {
    await releaseReservation(ownerUserId, studentUserId, estimate, energyCost);
    return { ok: false, code: "AI_KEY_INVALID" };
  }

  return {
    ok: true,
    ticket: {
      payer: "family",
      ownerUserId,
      provider: access.provider,
      credential,
      model,
      maxTokens,
      estimate,
      energyCost,
      doubleSolve: access.double_solve ?? true,
      startedAt: Date.now(),
    },
  };
}

/**
 * Le chemin PLATEFORME — é11 R-12 (énergie) et R-13 (budget), enfin branchés.
 *
 * é29 avait laissé cette moitié ouverte en toutes lettres (« volontairement
 * minimal ici : le lot 1 de é11 le complétera »), et le lot 1 ne l'a pas fermée.
 * Tant qu'elle l'est restée, poser `ANTHROPIC_API_KEY` en production donnait un
 * tuteur ILLIMITÉ, à nos frais, à chaque élève sans clé de famille — parce que
 * `resolve_ai_access` renvoie `payer = 'platform'` pour tous ceux-là.
 *
 * La coupure est INCONDITIONNELLE, contrairement au chemin famille où le porteur
 * arme lui-même son frein (`limits_enforced`, défaut `false`). La différence
 * n'est pas un oubli de symétrie : là-bas c'est la facture d'un parent qui a
 * choisi son plafond ; ici c'est la nôtre, et R-13 est catégorique — « un
 * dépassement doit être impossible, pas signalé ».
 */
async function preparePlatformCall(
  request: AiCallRequest,
  bounds: { maxTokens: number; contextTokens: number; energyCost: number },
): Promise<AiPreparation> {
  // Le fournisseur et les deux modèles viennent de l'ENVIRONNEMENT, résolus
  // contre les mêmes préréglages que le formulaire d'une famille : Anthropic par
  // défaut, mais DeepSeek, Grok, Kimi, GLM ou n'importe quelle adresse
  // compatible sans qu'une ligne d'ici change. Ils étaient écrits en dur juste
  // ici — deux identifiants de modèle hors de `constants/ai.ts`, et une bascule
  // de fournisseur qui passait par une PR.
  const credential = platformCredential();
  if (!credential) return { ok: false, code: "AI_MODE_OFF" };

  const model = request.tier === "rich" ? credential.models.rich : credential.models.fast;
  const estimate = estimateCostMicros({
    model,
    estimatedInputTokens: bounds.contextTokens,
    maxOutputTokens: bounds.maxTokens,
  });

  const { data: reservation, error: reserveError } = await rpc().rpc("reserve_platform_spend", {
    p_student: request.studentUserId,
    p_micros: estimate,
    p_energy: bounds.energyCost,
    p_budget_micros: Math.round(platformDailyBudgetUsd() * MICROS_PER_USD),
  });
  if (reserveError) {
    logger.error("ai.reserve.platform", {
      error: errorMessage(reserveError),
      feature: request.feature,
    });
    return { ok: false, code: "AI_UNKNOWN" };
  }

  const grant = (Array.isArray(reservation) ? reservation[0] : null) as {
    granted: boolean;
    reason: string | null;
  } | null;

  if (!grant?.granted) {
    const code = (grant?.reason as AiErrorCode | null) ?? "AI_BUDGET_REACHED";
    // Le budget plateforme atteint est un ÉVÉNEMENT D'EXPLOITATION, pas un
    // incident d'élève : `info` avec l'action, comme la coupure côté famille,
    // pour que la console admin puisse dire « budget atteint à HH:MM » (§3.10).
    logger.info("ai.budget", { owner: "platform", action: "cut", code });
    return { ok: false, code };
  }

  return {
    ok: true,
    ticket: {
      payer: "platform",
      ownerUserId: null,
      // Le fournisseur RÉELLEMENT résolu, pas une constante : c'est lui qui est
      // journalisé (R-13), donc lui que la console admin agrège. Le figer à
      // « anthropic » aurait fait mentir la répartition par fournisseur le jour
      // où la plateforme bascule.
      provider: credential.provider,
      credential,
      model,
      maxTokens: bounds.maxTokens,
      estimate,
      energyCost: bounds.energyCost,
      // R-18bis.4 : sur le chemin plateforme la vérification est TOUJOURS
      // complète. C'est nous qui payons, et c'est notre nom sur le contenu.
      doubleSolve: true,
      startedAt: Date.now(),
    },
  };
}

/** La requête telle que l'adaptateur l'attend. Une seule construction, deux formes d'appel. */
function providerRequest(request: AiCallRequest, ticket: AiTicket): AiRequest {
  return {
    tier: request.tier,
    system: request.system,
    blocks: request.blocks,
    maxTokens: ticket.maxTokens,
    feature: request.feature,
    responseSchema: request.responseSchema,
    timeoutMs: request.timeoutMs,
  };
}

/** Étapes 6-7 au SUCCÈS : comptabilité, puis solde réel. Rend le coût constaté. */
async function concludeSuccess(
  request: AiCallRequest,
  ticket: AiTicket,
  result: AiResult,
): Promise<number> {
  const actual = settledCostMicros({ model: result.model, ...result.usage });

  await Promise.all([
    logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
      userId: request.studentUserId,
      payer: ticket.payer,
      credentialOwner: ticket.ownerUserId,
      provider: ticket.provider,
      feature: request.feature,
      model: result.model,
      inputTokens: result.usage.inputTokens,
      outputTokens: result.usage.outputTokens,
      cachedTokens: result.usage.cachedTokens,
      costUsdMicros: actual,
      status: "ok",
      latencyMs: result.latencyMs,
    }),
    ticket.ownerUserId
      ? settle(ticket.ownerUserId, ticket.estimate, actual)
      : settlePlatform(ticket.estimate, actual),
  ]);

  if (ticket.ownerUserId) void notifyBudgetAlerts(ticket.ownerUserId);

  return actual;
}

/**
 * Étapes 6-7 à l'ÉCHEC : libérer, marquer la clé si besoin, journaliser.
 *
 * L'énergie est REMBOURSÉE (é11 R-15) ; l'argent réservé est libéré, parce
 * qu'aucun appel n'a abouti. Un appel qui échoue AVANT d'atteindre le
 * fournisseur n'a rien coûté ; un appel qui échoue APRÈS a été facturé, mais
 * nous n'avons alors aucun usage à solder — l'estimation resterait plus fausse
 * que zéro, et la facture du fournisseur reste le juge (R-12).
 */
async function concludeFailure(
  request: AiCallRequest,
  ticket: AiTicket,
  error: unknown,
): Promise<AiErrorCode> {
  const typed = toAiError(error);

  // Une clé refusée le reste : la marquer évite que chaque appel suivant
  // re-découvre la même chose sur le quota du parent (§3.5).
  if (typed.code === "AI_KEY_INVALID" && ticket.ownerUserId) {
    await markCredentialState(ticket.ownerUserId, "invalid", typed.code);
  }

  await (ticket.ownerUserId
    ? releaseReservation(
        ticket.ownerUserId,
        request.studentUserId,
        ticket.estimate,
        ticket.energyCost,
      )
    : releasePlatformReservation(request.studentUserId, ticket.estimate, ticket.energyCost));

  await logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
    userId: request.studentUserId,
    payer: ticket.payer,
    credentialOwner: ticket.ownerUserId,
    provider: ticket.provider,
    feature: request.feature,
    model: ticket.model,
    status: "error",
    errorCode: typed.code,
    latencyMs: Date.now() - ticket.startedAt,
  });

  return typed.code;
}

/**
 * Émet un appel IA pour un élève, ou explique pourquoi il ne part pas.
 *
 * Ne LÈVE jamais pour un refus métier : les exceptions sont réservées aux bugs.
 */
export async function callAi(request: AiCallRequest): Promise<AiCallOutcome> {
  const prepared = await prepareAiCall(request);
  if (!prepared.ok) return refuse(request.feature, prepared.code);

  const { ticket } = prepared;
  try {
    const result = await getAiProvider(ticket.provider).generate(
      providerRequest(request, ticket),
      ticket.credential,
    );
    const actual = await concludeSuccess(request, ticket, result);
    return {
      ok: true,
      text: result.text,
      model: result.model,
      payer: ticket.payer,
      costUsdMicros: actual,
      doubleSolve: ticket.doubleSolve,
    };
  } catch (error) {
    return refuse(request.feature, await concludeFailure(request, ticket, error));
  }
}

/** Ce qu'un appel STREAMÉ rend, morceau par morceau (é11 lot 3). */
export type AiStreamChunk =
  | { readonly type: "text"; readonly text: string }
  | {
      readonly type: "done";
      readonly text: string;
      readonly model: string;
      readonly payer: AiPayer;
      readonly costUsdMicros: number;
    }
  | { readonly type: "error"; readonly code: AiErrorCode };

/**
 * La forme STREAMÉE du même appel — étude 11 lot 3 (D-7).
 *
 * Elle emprunte le MÊME chemin d'argent que `callAi` : même résolution, même
 * réservation avant l'appel, même comptabilité, même solde. C'est tout l'intérêt
 * du billet — un plafond ne peut pas exister d'un côté et manquer de l'autre.
 *
 * Comme sa jumelle, elle ne LÈVE jamais pour un refus métier : le refus est un
 * dernier morceau `error`, que la route traduit en trame SSE et que l'écran
 * traduit en phrase d'enfant (R-15).
 *
 * Un fournisseur sans streaming n'est pas un cas d'échec : son adaptateur rend
 * le texte en un seul morceau (dégradation prévue, §3.5). L'appelant n'a rien à
 * savoir de la différence.
 */
export async function* streamAi(request: AiCallRequest): AsyncGenerator<AiStreamChunk> {
  const prepared = await prepareAiCall(request);
  if (!prepared.ok) {
    // Le refus passe par `refuse()` pour être JOURNALISÉ comme celui de
    // `callAi`, puis ressort en morceau : la route n'a pas à connaître deux
    // formes de refus.
    refuse(request.feature, prepared.code);
    yield { type: "error", code: prepared.code };
    return;
  }

  const { ticket } = prepared;
  let full = "";
  try {
    for await (const chunk of getAiProvider(ticket.provider).stream(
      providerRequest(request, ticket),
      ticket.credential,
    )) {
      if (chunk.type === "text") {
        full += chunk.text;
        yield { type: "text", text: chunk.text };
        continue;
      }

      const actual = await concludeSuccess(request, ticket, chunk.result);
      yield {
        type: "done",
        // Le texte du morceau final fait foi : c'est celui que l'adaptateur a
        // reconstruit depuis la réponse, pas notre concaténation.
        text: chunk.result.text || full,
        model: chunk.result.model,
        payer: ticket.payer,
        costUsdMicros: actual,
      };
      return;
    }

    // Un flux qui se termine sans `done` n'a pas de comptabilité à solder ; on
    // le traite comme une panne, pour que la réservation soit libérée.
    yield {
      type: "error",
      code: await concludeFailure(request, ticket, new Error("no_done")),
    };
  } catch (error) {
    yield {
      type: "error",
      code: await concludeFailure(request, ticket, error),
    };
  }
}
async function settlePlatform(reserved: number, actual: number): Promise<void> {
  const { error } = await rpc().rpc("settle_platform_spend", {
    p_reserved_micros: reserved,
    p_actual_micros: actual,
  });
  if (error) logger.error("ai.settle.platform", { error: errorMessage(error) });
}

async function releasePlatformReservation(
  student: string,
  micros: number,
  energy: number,
): Promise<void> {
  const { error } = await rpc().rpc("release_platform_reservation", {
    p_student: student,
    p_micros: micros,
    p_energy: energy,
  });
  if (error) logger.error("ai.release.platform", { error: errorMessage(error) });
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
