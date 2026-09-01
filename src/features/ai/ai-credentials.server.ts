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
import { nullableRpcArg } from "@/shared/integrations/supabase/rpc-args";
import { logger } from "@/shared/lib/logger";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
import {
  AI_ADULT_CONFIRM_GRADE_RANK,
  AI_BUDGET_LIMITS,
  AI_ENC_VERSION,
  AI_CONSENT_VERSION,
  AI_MAX_TOKENS,
  AI_PROVIDERS,
  type AiProviderId,
} from "@/shared/constants/ai";
import { asAiErrorCode, toAiError, type AiErrorCode } from "@/shared/integrations/ai";
import { revealSecret, sealSecret } from "@/shared/integrations/ai/types";
import {
  getAiProvider,
  isAiModeEnabled,
  isByokEnabled,
} from "@/shared/integrations/ai/provider.server";
import { logAiUsage } from "@/shared/integrations/ai/usage.server";
import { settledCostMicros } from "@/shared/integrations/ai/pricing";
// Ni `egress.server` (→ `node:dns`, `node:net`, `node:https`) ni `crypto.server`
// (→ `node:crypto`) ne sont importés statiquement ici : ce module est atteint
// depuis le graphe du CLIENT via `components/ai-mode-section.tsx`, et le dev
// server charge vraiment ce qu'il voit. Les deux sont chargés à l'usage, dans
// des handlers déjà `async` (#909). Aucune logique de sécurité ne bouge.
import { openOwnerSecret } from "./ai-vault.server";
import { AI_MODE_ERROR_PREFIX, type AiModeStatus } from "./ai-mode-status";

const adminRpc = () => supabaseAdmin;

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
    const client = context.supabase;
    const { isVaultAvailable } = await import("./crypto.server");

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
    const client = supabase;

    const { fingerprint, isVaultAvailable, last4, sealForRow } = await import("./crypto.server");

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
        const { resolveEgressTarget } = await import("@/shared/integrations/ai/egress.server");
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
      p_base_url: nullableRpcArg(baseUrl),
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
// Changer de MODÈLE sans recoller la clé
// ---------------------------------------------------------------------------

/**
 * LE TROU QUE CECI FERME, ET POURQUOI IL N'ÉTAIT PAS VISIBLE.
 * ---------------------------------------------------------------------------
 * R-4 fait qu'une clé enregistrée ne réapparaît jamais — pas même à son
 * porteur. `setAiCredential`, lui, exige le secret. La conséquence n'avait été
 * énoncée nulle part : **changer un identifiant de modèle imposait d'avoir la
 * clé sous la main et de la recoller en entier**. Signalé en usage le
 * 2026-08-28, sur le geste le plus courant qui soit — passer le palier rapide
 * d'un modèle à raisonnement à un modèle rapide, parce que le premier répondait
 * en trente secondes.
 *
 * CE QUI N'EST PAS ASSOUPLI POUR AUTANT (§5)
 * ---------------------------------------------------------------------------
 * L'invariant tient mot pour mot : rien n'est écrit qui n'ait répondu. Le
 * secret est simplement lu au COFFRE au lieu d'être ressaisi, et l'appel de
 * vérification est exactement celui de US-2 — même prompt, mêmes 16 tokens,
 * même comptabilité. Un modèle qui n'existe pas chez le fournisseur échoue ici,
 * et la ligne en base ne bouge pas.
 *
 * Ni le consentement ni la confirmation d'adulte ne sont redemandés, et c'est
 * délibéré : R-20 lie le consentement au FOURNISSEUR et au texte, dont aucun ne
 * change. La version stockée est renvoyée telle quelle — écrire une version
 * différente ici ferait signer un texte que personne n'a affiché.
 */
const setModelsInput = z.object({
  modelFast: z.string().min(1).max(120),
  modelRich: z.string().min(1).max(120),
});

export const setAiModels = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => setModelsInput.parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const client = supabase;

    const { fingerprint, isVaultAvailable, last4, sealForRow } = await import("./crypto.server");

    if (!isAiModeEnabled() || !isByokEnabled() || !isVaultAvailable()) {
      failWithAiCode("ai.setAiModels.off", "AI_MODE_OFF");
    }

    // L'état COURANT fait foi pour tout ce qu'on ne change pas : fournisseur,
    // adresse, plafonds, double résolution, version de consentement. Le client
    // n'envoie que les deux modèles — il ne peut donc pas, au passage, se
    // réécrire un plafond ou un consentement.
    const { data: rows, error: readError } = await client.rpc("get_ai_credential_status");
    if (readError) {
      failWithAiCode("ai.setAiModels.read", "AI_UNKNOWN", readError);
    }
    const parsed = z.array(credentialRowSchema).safeParse(rows ?? []);
    const row = parsed.success ? (parsed.data[0] ?? null) : null;
    if (!row) {
      failWithAiCode("ai.setAiModels.missing", "AI_MODE_OFF");
    }

    const opened = await openOwnerSecret(userId);
    if (!opened) {
      // Clé illisible : `openOwnerSecret` a déjà basculé la ligne en `invalid`.
      // Le porteur devra la re-saisir — c'est le seul cas où on ne peut pas
      // faire l'économie de la re-saisie, et il est nommé (RISK-10).
      failWithAiCode("ai.setAiModels.vault", "AI_KEY_INVALID");
    }

    // R-6 à chaque écriture, comme à l'attachement : une adresse qui a cessé
    // d'être joignable publiquement ne se re-valide pas parce qu'elle est déjà
    // en base.
    if (row.base_url !== null) {
      try {
        const { resolveEgressTarget } = await import("@/shared/integrations/ai/egress.server");
        await resolveEgressTarget(row.base_url);
      } catch (error) {
        failWithAiCode("ai.setAiModels.egress", toAiError(error).code, error);
      }
    }

    const provider = getAiProvider(row.provider);
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
          provider: row.provider,
          baseUrl: row.base_url ?? undefined,
          secret: opened.secret,
          models: { fast: data.modelFast, rich: data.modelRich },
        },
      );
      verifiedModel = result.model;
      usage = result.usage;
    } catch (error) {
      const typed = toAiError(error);
      logger.warn("ai.credential", { action: "verify", result: "error", errorCode: typed.code });
      failWithAiCode("ai.setAiModels.verify", typed.code, error);
    }

    // Le modèle répond : on ré-écrit la ligne. Le secret repart au coffre scellé
    // à neuf — `set_ai_credential` REMPLACE (R-4 : « pas de modification
    // partielle »), donc il faut le lui redonner. `limits_enforced` n'est pas
    // dans son UPDATE et survit ; `last_error_code` est remis à NULL, ce qui est
    // exact puisqu'on vient de re-vérifier.
    const clear = revealSecret(opened.secret);
    const sealed = sealForRow(clear, {
      ownerUserId: userId,
      provider: row.provider,
      encVersion: AI_ENC_VERSION,
    });

    const { error: writeError } = await adminRpc().rpc("set_ai_credential", {
      p_owner: userId,
      p_provider: row.provider,
      p_base_url: nullableRpcArg(row.base_url),
      p_model_fast: data.modelFast,
      p_model_rich: data.modelRich,
      p_secret_enc: toByteaLiteral(sealed),
      p_enc_version: AI_ENC_VERSION,
      p_key_fingerprint: fingerprint(clear),
      p_last4: last4(clear),
      p_daily_budget_usd: row.daily_budget_usd,
      p_monthly_budget_usd: row.monthly_budget_usd,
      p_consent_version: row.consent_version,
      p_double_solve: row.double_solve,
      p_status: "active",
    });
    if (writeError) {
      failWithAiCode("ai.setAiModels.write", "AI_UNKNOWN", writeError);
    }

    // La vérification est une dépense réelle sur la clé de la famille (R-7).
    await logAiUsage(supabaseAdmin as unknown as Parameters<typeof logAiUsage>[0], {
      userId: null,
      payer: "family",
      credentialOwner: userId,
      provider: row.provider,
      feature: "verify",
      model: verifiedModel,
      inputTokens: usage.inputTokens,
      outputTokens: usage.outputTokens,
      cachedTokens: usage.cachedTokens,
      costUsdMicros: settledCostMicros({ model: verifiedModel, ...usage }),
      status: "ok",
      latencyMs: Date.now() - startedAt,
    });

    logger.info("ai.credential", { action: "models", result: "ok", provider: row.provider });
    return { ok: true, modelFast: data.modelFast, modelRich: data.modelRich } as const;
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
    const client = context.supabase;
    const { data: updated, error } = await client.rpc("set_ai_preferences", {
      p_daily_budget_usd: data.dailyBudgetUsd,
      p_monthly_budget_usd: data.monthlyBudgetUsd,
      p_double_solve: data.doubleSolve,
      // `p_limits_enforced BOOLEAN DEFAULT NULL`, et le SQL documente que
      // « NULL laisse le réglage inchangé » : l'omettre porte le même sens.
      p_limits_enforced: data.limitsEnforced ?? undefined,
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
    const client = context.supabase;
    const { data, error } = await client.rpc("revoke_ai_credential");
    if (error) {
      failWithClientError("ai.revokeAiCredential", error, "Impossible de révoquer la clé.");
    }
    logger.info("ai.credential", { action: "revoke", result: "ok" });
    // `false` = il n'y avait rien à révoquer. Ce n'est pas une erreur : deux
    // onglets ouverts suffisent à produire ce cas.
    return { revoked: data === true } as const;
  });

// `markCredentialState` a déménagé dans `./ai-vault.server` (2026-08-28), avec
// `openOwnerSecret` : les deux modules avaient fini par se tenir l'un l'autre —
// la console voulait lire le coffre, l'orchestrateur voulait marquer l'état — et
// un cycle d'imports entre deux modules serveur ne se laisse pas parier.
