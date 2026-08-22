// La console du porteur de clé — attacher, vérifier, régler, révoquer (é29 lot 2).
//
// LES QUATRE GESTES, ET CE QU'ILS COÛTENT
// ---------------------------------------------------------------------------
//   getAiModeStatus     lecture — l'état de SA clé, jamais la clé (R-4)
//   setAiCredential     US-1 + US-2 — le SEUL appel réel du système (§5)
//   setAiPreferences    plafonds et double résolution, sans re-saisir la clé
//   revokeAiCredential  US-8 — la ligne est supprimée, pas marquée
//
// L'ORDRE DE `setAiCredential` N'EST PAS NÉGOCIABLE (US-2)
// ---------------------------------------------------------------------------
// Valider la forme → vérifier les sept conditions de sortie → **appeler le
// fournisseur** → seulement alors chiffrer et écrire. Un échec de vérification
// ⇒ **la clé n'est pas enregistrée**, et l'erreur est nommée en clair (annexe C).
// Écrire d'abord et vérifier ensuite laisserait en base une clé dont personne ne
// sait si elle marche, derrière un `status` qui ment.
//
// R-2, TELLE QUE Q-2 L'A RÉÉCRITE
// ---------------------------------------------------------------------------
// Aucun filtre de rôle : un `student` comme un `parent` peut coller la sienne.
// La contrepartie est double, et elle est ici. (a) Le niveau scolaire du compte
// est LU EN BASE — pas déclaré par le formulaire — et sous la 4ᵉ année secondaire
// la confirmation qu'un adulte responsable est présent est exigée : un signal que
// l'app possède, au lieu d'un « je certifie être majeur » que personne ne lit.
// (b) Le consentement versionné est signé par celui qui attache, et un décalage
// de version refuse l'écriture.
//
// Un compte sans niveau connu — parcours libre, compte ancien, parent — est
// traité comme MINEUR. C'est la consigne explicite du §7, et elle penche du bon
// côté : se tromper ainsi coûte une case à cocher.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
import {
  AI_ADULT_CONFIRM_GRADE_RANK,
  AI_BUDGET_LIMITS,
  AI_CONSENT_VERSION,
  AI_MAX_TOKENS,
  AI_PROVIDERS,
  type AiProviderId,
} from "@/shared/constants/ai";
import { asAiErrorCode, toAiError, type AiErrorCode } from "@/shared/integrations/ai";
import { sealSecret } from "@/shared/integrations/ai/types";
import { resolveEgressTarget } from "@/shared/integrations/ai/egress.server";
import {
  getAiProvider,
  isAiModeEnabled,
  isByokEnabled,
} from "@/shared/integrations/ai/provider.server";
import { logAiUsage } from "@/shared/integrations/ai/usage.server";
import { settledCostMicros } from "@/shared/integrations/ai/pricing";
import { AI_ENC_VERSION, fingerprint, isVaultAvailable, last4, sealForRow } from "./crypto.server";
import { AI_MODE_ERROR_PREFIX, type AiModeStatus } from "./ai-mode-status";

/**
 * Les RPC du coffre sont postérieures aux types Supabase générés (non
 * régénérables sans accès DB) : on fige leur contrat ici, même patron que
 * `exam.server.ts`. À supprimer à la prochaine régénération des types.
 */
type AiCredentialRpcClient = {
  rpc: (
    fn:
      | "set_ai_credential"
      | "set_ai_credential_state"
      | "set_ai_preferences"
      | "revoke_ai_credential"
      | "get_ai_credential_status"
      | "get_my_grade_rank",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

const adminRpc = () => supabaseAdmin as unknown as AiCredentialRpcClient;

const credentialRowSchema = z.object({
  provider: z.enum(AI_PROVIDERS),
  base_url: z.string().nullable(),
  model_fast: z.string(),
  model_rich: z.string(),
  last4: z.string(),
  status: z.enum(["unverified", "active", "invalid", "revoked"]),
  last_error_code: z.string().nullable(),
  verified_at: z.string().nullable(),
  last_used_at: z.string().nullable(),
  daily_budget_usd: z.coerce.number(),
  monthly_budget_usd: z.coerce.number(),
  double_solve: z.boolean(),
  consent_version: z.string(),
  // Ajoutée le 2026-08-22. `.catch(false)` et non `.optional()` : pendant la
  // fenêtre où le code neuf tourne contre la base d'avant la migration, la
  // colonne manque — et l'absence doit se lire « plafonds non armés », qui est
  // le nouveau défaut, jamais « armés » (ce qui couperait des familles à tort).
  limits_enforced: z.boolean().catch(false),
});

/**
 * Le code stable voyage dans le message de l'exception (motif
 * `parent-code-errors.ts`), et le client le traduit. Le serveur n'envoie JAMAIS
 * une phrase venue d'un fournisseur — annexe C, R-5.
 */
function failWithAiCode(context: string, code: AiErrorCode, cause?: unknown): never {
  logger.warn(context, { code, error: cause ? errorMessage(cause) : undefined });
  throw new Error(`${AI_MODE_ERROR_PREFIX}${code}`);
}

/** `bytea` pour PostgREST : la notation hexadécimale d'échappement de Postgres. */
function toByteaLiteral(buffer: Buffer): string {
  return `\\x${buffer.toString("hex")}`;
}

// ---------------------------------------------------------------------------
// Lecture — ce que la section « Mode IA » des Réglages affiche
// ---------------------------------------------------------------------------

export const getAiModeStatus = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<AiModeStatus> => {
    const client = context.supabase as unknown as AiCredentialRpcClient;

    const [{ data: rows, error }, { data: rank }] = await Promise.all([
      client.rpc("get_ai_credential_status"),
      client.rpc("get_my_grade_rank"),
    ]);
    if (error) {
      failWithClientError("ai.getAiModeStatus", error, "Impossible de lire l'état du mode IA.");
    }

    const parsed = z.array(credentialRowSchema).safeParse(rows ?? []);
    const row = parsed.success ? (parsed.data[0] ?? null) : null;
    const gradeRank = typeof rank === "number" ? rank : null;

    return {
      // Le chemin famille peut être éteint pour trois raisons — kill-switch
      // global, kill-switch BYOK, coffre sans clé maîtresse. Elles se réduisent
      // ici à un booléen parce que l'utilisateur n'a rien à en faire ; le log,
      // lui, les distingue.
      available: isAiModeEnabled() && isByokEnabled() && isVaultAvailable(),
      consentVersion: AI_CONSENT_VERSION,
      requiresAdultConfirmation: gradeRank === null || gradeRank < AI_ADULT_CONFIRM_GRADE_RANK,
      credential: row
        ? {
            provider: row.provider,
            baseUrl: row.base_url,
            modelFast: row.model_fast,
            modelRich: row.model_rich,
            last4: row.last4,
            status: row.status,
            lastErrorCode: asAiErrorCode(row.last_error_code),
            hasError: row.last_error_code !== null,
            verifiedAt: row.verified_at,
            lastUsedAt: row.last_used_at,
            dailyBudgetUsd: row.daily_budget_usd,
            monthlyBudgetUsd: row.monthly_budget_usd,
            doubleSolve: row.double_solve,
            consentStale: row.consent_version !== AI_CONSENT_VERSION,
            limitsEnforced: row.limits_enforced,
          }
        : null,
    };
  });

// ---------------------------------------------------------------------------
// US-1 + US-2 — attacher une clé, et prouver qu'elle répond
// ---------------------------------------------------------------------------

const setCredentialInput = z
  .object({
    provider: z.enum(AI_PROVIDERS),
    baseUrl: z.string().max(300).nullish(),
    modelFast: z.string().min(1).max(120),
    modelRich: z.string().min(1).max(120),
    /** La clé elle-même. Elle ne quitte ce handler que chiffrée. */
    secret: z.string().min(8).max(400),
    dailyBudgetUsd: z.number().min(AI_BUDGET_LIMITS.minDailyUsd).max(AI_BUDGET_LIMITS.maxDailyUsd),
    monthlyBudgetUsd: z
      .number()
      .min(AI_BUDGET_LIMITS.minMonthlyUsd)
      .max(AI_BUDGET_LIMITS.maxMonthlyUsd),
    doubleSolve: z.boolean(),
    consentVersion: z.string().max(32),
    /** R-2a : cochée par celui qui attache, quand son niveau l'exige. */
    adultPresent: z.boolean(),
  })
  .refine((v) => v.provider === "openai_compatible" || !v.baseUrl, {
    message: "base_url_not_allowed",
    path: ["baseUrl"],
  });

export const setAiCredential = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => setCredentialInput.parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const client = supabase as unknown as AiCredentialRpcClient;

    if (!isAiModeEnabled() || !isByokEnabled() || !isVaultAvailable()) {
      failWithAiCode("ai.setAiCredential.off", "AI_MODE_OFF");
    }
    // R-20 : le consentement est PRÉALABLE et VERSIONNÉ. Un client qui renverrait
    // une version périmée signerait un texte qui n'est plus celui affiché.
    if (data.consentVersion !== AI_CONSENT_VERSION) {
      failWithAiCode("ai.setAiCredential.consent", "AI_MODE_OFF");
    }

    // R-2a. Le niveau est lu EN BASE : un client modifié ne peut pas s'exempter.
    const { data: rank } = await client.rpc("get_my_grade_rank");
    const gradeRank = typeof rank === "number" ? rank : null;
    if ((gradeRank === null || gradeRank < AI_ADULT_CONFIRM_GRADE_RANK) && !data.adultPresent) {
      failWithAiCode("ai.setAiCredential.minor", "AI_MODE_OFF");
    }

    const baseUrl = data.provider === "openai_compatible" ? (data.baseUrl ?? "") : null;

    // R-6 à l'enregistrement : les sept conditions, avant le moindre octet
    // envoyé. Une adresse recalée ne devient jamais une ligne en base.
    if (baseUrl !== null) {
      try {
        await resolveEgressTarget(baseUrl);
      } catch (error) {
        failWithAiCode("ai.setAiCredential.egress", toAiError(error).code, error);
      }
    }

    // US-2 — LE seul appel réel du système (§5). Prompt fixe, ≤ 16 tokens de
    // sortie : il prouve que la clé ET le modèle répondent, rien de plus.
    const provider = getAiProvider(data.provider);
    const startedAt = Date.now();
    let verifiedModel = data.modelFast;
    let usage = { inputTokens: 0, outputTokens: 0, cachedTokens: 0 };
    try {
      const result = await provider.generate(
        {
          tier: "fast",
          system: "Réponds exactement OK.",
          blocks: [{ label: "ping", text: "OK" }],
          maxTokens: AI_MAX_TOKENS.verify,
          feature: "verify",
        },
        {
          provider: data.provider as AiProviderId,
          baseUrl: baseUrl ?? undefined,
          // Même ici, où la clé est déjà en main, elle passe par le type qui
          // empêche de la journaliser par accident.
          secret: sealSecret(data.secret),
          models: { fast: data.modelFast, rich: data.modelRich },
        },
      );
      verifiedModel = result.model;
      usage = result.usage;
    } catch (error) {
      const typed = toAiError(error);
      // Échec ⇒ RIEN n'est écrit. La ligne n'existe pas, donc l'événement de
      // comptabilité n'aurait pas de porteur : on journalise le refus, pas une
      // dépense orpheline (R-7).
      logger.warn("ai.credential", { action: "verify", result: "error", errorCode: typed.code });
      failWithAiCode("ai.setAiCredential.verify", typed.code, error);
    }

    // La clé répond : on peut la mettre au coffre. Le chiffrement se fait ICI,
    // en mémoire, et le clair ne va nulle part ailleurs (R-5).
    const sealed = sealForRow(data.secret, {
      ownerUserId: userId,
      provider: data.provider as AiProviderId,
      encVersion: AI_ENC_VERSION,
    });

    const { error: writeError } = await adminRpc().rpc("set_ai_credential", {
      p_owner: userId,
      p_provider: data.provider,
      p_base_url: baseUrl,
      p_model_fast: data.modelFast,
      p_model_rich: data.modelRich,
      p_secret_enc: toByteaLiteral(sealed),
      p_enc_version: AI_ENC_VERSION,
      p_key_fingerprint: fingerprint(data.secret),
      p_last4: last4(data.secret),
      p_daily_budget_usd: data.dailyBudgetUsd,
      p_monthly_budget_usd: data.monthlyBudgetUsd,
      p_consent_version: data.consentVersion,
      p_double_solve: data.doubleSolve,
      p_status: "active",
    });
    if (writeError) {
      failWithAiCode("ai.setAiCredential.write", "AI_UNKNOWN", writeError);
    }

    // La vérification est une dépense RÉELLE sur la clé de la famille : elle est
    // comptée (R-7). Moins d'un millième de dollar, mais la ligne commence par
    // une dépense honnête plutôt que par rien.
    await logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
      userId: null,
      payer: "family",
      credentialOwner: userId,
      provider: data.provider,
      feature: "verify",
      model: verifiedModel,
      inputTokens: usage.inputTokens,
      outputTokens: usage.outputTokens,
      cachedTokens: usage.cachedTokens,
      costUsdMicros: settledCostMicros({ model: verifiedModel, ...usage }),
      status: "ok",
      latencyMs: Date.now() - startedAt,
    });

    logger.info("ai.credential", { action: "set", result: "ok", provider: data.provider });
    return { ok: true, last4: last4(data.secret) } as const;
  });

// ---------------------------------------------------------------------------
// Réglages sans re-saisie — plafonds et double résolution
// ---------------------------------------------------------------------------

export const setAiPreferences = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        dailyBudgetUsd: z
          .number()
          .min(AI_BUDGET_LIMITS.minDailyUsd)
          .max(AI_BUDGET_LIMITS.maxDailyUsd),
        monthlyBudgetUsd: z
          .number()
          .min(AI_BUDGET_LIMITS.minMonthlyUsd)
          .max(AI_BUDGET_LIMITS.maxMonthlyUsd),
        doubleSolve: z.boolean(),
        // R-11 devenue optionnelle (2026-08-22) : le porteur arme ou désarme la
        // coupure. `undefined` ⇒ la RPC laisse le réglage en place.
        limitsEnforced: z.boolean().optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const client = context.supabase as unknown as AiCredentialRpcClient;
    const { data: updated, error } = await client.rpc("set_ai_preferences", {
      p_daily_budget_usd: data.dailyBudgetUsd,
      p_monthly_budget_usd: data.monthlyBudgetUsd,
      p_double_solve: data.doubleSolve,
      p_limits_enforced: data.limitsEnforced ?? null,
    });
    if (error) {
      failWithClientError("ai.setAiPreferences", error, "Impossible d'enregistrer les réglages.");
    }
    logger.info("ai.credential", {
      action: "preferences",
      result: "ok",
      doubleSolve: data.doubleSolve,
    });
    return { saved: updated === true } as const;
  });

// ---------------------------------------------------------------------------
// US-8 — révoquer
// ---------------------------------------------------------------------------

export const revokeAiCredential = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const client = context.supabase as unknown as AiCredentialRpcClient;
    const { data, error } = await client.rpc("revoke_ai_credential");
    if (error) {
      failWithClientError("ai.revokeAiCredential", error, "Impossible de révoquer la clé.");
    }
    logger.info("ai.credential", { action: "revoke", result: "ok" });
    // `false` = il n'y avait rien à révoquer. Ce n'est pas une erreur : deux
    // onglets ouverts suffisent à produire ce cas.
    return { revoked: data === true } as const;
  });

/**
 * Marque l'état d'une clé après un appel — appelé par l'orchestrateur des lots
 * suivants, jamais par un client.
 *
 * Un 401 fait basculer la clé en `invalid` : elle le restera jusqu'à ce que son
 * porteur la remplace. Ne pas le faire condamnerait chaque appel suivant à
 * re-découvrir la même chose, sur le quota du parent.
 */
export async function markCredentialState(
  ownerUserId: string,
  status: "active" | "invalid",
  errorCode: AiErrorCode | null,
): Promise<void> {
  const { error } = await adminRpc().rpc("set_ai_credential_state", {
    p_owner: ownerUserId,
    p_status: status,
    p_error_code: errorCode,
    p_touch_used: true,
  });
  if (error) logger.error("ai.credential.state", { error: errorMessage(error) });
}
