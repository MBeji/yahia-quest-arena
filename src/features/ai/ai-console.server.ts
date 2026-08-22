// LA CONSOLE — ce que le porteur de clé lit, et ce que l'admin mesure (lot 5).
//
// R-12 EST LE FIL DE CE FICHIER
// ---------------------------------------------------------------------------
// « Le montant affiché est une ESTIMATION, et le dit. » Chaque montant qui sort
// d'ici est accompagné de sa grille datée, et le type le porte : `pricesAsOf`
// n'est pas un champ facultatif qu'un écran pourrait oublier — il est dans la
// réponse, à côté du chiffre.
//
// R-19 : LA SEULE DÉCISION AUTOMATIQUE DE L'ÉTUDE
// ---------------------------------------------------------------------------
// « Taux de rebut > 50 % sur 7 jours pour un porteur de clé ⇒ bandeau dans ses
// Réglages : ce modèle échoue trop souvent, voici ceux qui passent. » Nommer,
// et rien de plus : aucune bascule automatique vers un autre modèle, parce que
// c'est sa clé, donc son choix (D-11).
//
// La mesure reste alimentée quand la double résolution est coupée, grâce à
// l'échantillon de 20 % (R-18bis.3). C'est ce qui rend l'avertissement possible
// dans le seul cas où il est vraiment nécessaire.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import {
  AI_CURATED_MODELS,
  AI_DISCARD_ADVICE_THRESHOLD,
  AI_MODEL_PRICES_AS_OF,
  type AiProviderId,
} from "@/shared/constants/ai";
import { AI_MODE_ERROR_PREFIX } from "./ai-mode-status";

type AiConsoleRpcClient = {
  rpc: (
    fn:
      | "get_ai_console"
      | "get_ai_admin_overview"
      | "set_ai_mode_enabled"
      | "set_ai_owner_suspension"
      | "submit_ai_feedback",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

const consoleRowSchema = z.object({
  day_micros: z.coerce.number(),
  month_micros: z.coerce.number(),
  daily_budget_usd: z.coerce.number(),
  monthly_budget_usd: z.coerce.number(),
  calls_month: z.coerce.number(),
  by_feature: z.record(z.string(), z.coerce.number()),
  by_student: z.record(z.string(), z.coerce.number()),
  by_model: z.record(
    z.string(),
    z.object({ micros: z.coerce.number(), calls: z.coerce.number(), errors: z.coerce.number() }),
  ),
  recent: z.array(
    z.object({
      feature: z.string(),
      model: z.string(),
      status: z.string(),
      errorCode: z.string().nullable(),
      micros: z.coerce.number(),
      at: z.string(),
    }),
  ),
  forge_discard_rate: z.coerce.number(),
});

export type AiConsole = {
  readonly dayMicros: number;
  readonly monthMicros: number;
  readonly dailyBudgetUsd: number;
  readonly monthlyBudgetUsd: number;
  readonly callsMonth: number;
  readonly byFeature: Record<string, number>;
  readonly byStudent: Record<string, number>;
  readonly byModel: Record<string, { micros: number; calls: number; errors: number }>;
  readonly recent: {
    feature: string;
    model: string;
    status: string;
    errorCode: string | null;
    micros: number;
    at: string;
  }[];
  /** R-19 : part des candidats jetés par la Forge sur 7 jours, 0 à 1. */
  readonly forgeDiscardRate: number;
  /** R-19 : au-delà du seuil, l'écran NOMME le modèle. Il ne bascule pas (D-11). */
  readonly modelAdvice: { model: string; suggestions: readonly string[] } | null;
  /** R-12 : la date de la grille, à côté du chiffre — jamais en note de bas de page. */
  readonly pricesAsOf: string;
};

/**
 * Le modèle le plus utilisé du mois. C'est LUI que R-19 nomme : nommer « le
 * modèle rapide » quand 95 % des appels passent par le modèle avancé enverrait
 * le porteur corriger le mauvais réglage.
 */
export function dominantModel(byModel: Record<string, { calls: number }>): string | null {
  const entries = Object.entries(byModel);
  if (entries.length === 0) return null;
  return entries.sort((a, b) => b[1].calls - a[1].calls)[0][0];
}

/**
 * R-19, exprimée en une fonction pure et testable.
 *
 * Rend `null` tant que le taux reste sous le seuil, ou quand il n'y a rien à
 * nommer. Les suggestions sont la liste CURÉE du fournisseur, privée du modèle
 * incriminé — proposer au porteur celui qui vient d'échouer serait comique.
 */
export function modelAdviceFor(args: {
  discardRate: number;
  byModel: Record<string, { calls: number }>;
  provider: AiProviderId | null;
}): { model: string; suggestions: readonly string[] } | null {
  if (args.discardRate <= AI_DISCARD_ADVICE_THRESHOLD) return null;
  const model = dominantModel(args.byModel);
  if (!model) return null;
  const curated = args.provider ? AI_CURATED_MODELS[args.provider] : [];
  return { model, suggestions: curated.filter((m) => m !== model) };
}

export const getAiConsole = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<AiConsole | null> => {
    const client = context.supabase as unknown as AiConsoleRpcClient;
    const { data, error } = await client.rpc("get_ai_console");
    if (error) {
      failWithClientError("ai.getAiConsole", error, "Impossible de lire la dépense.");
    }

    const parsed = consoleRowSchema.safeParse(Array.isArray(data) ? data[0] : null);
    // Pas de clé ⇒ pas de console. Ce n'est pas une erreur : c'est l'état par
    // défaut de tout le monde (R-1), et l'écran n'affiche simplement rien.
    if (!parsed.success) return null;
    const row = parsed.data;

    return {
      dayMicros: row.day_micros,
      monthMicros: row.month_micros,
      dailyBudgetUsd: row.daily_budget_usd,
      monthlyBudgetUsd: row.monthly_budget_usd,
      callsMonth: row.calls_month,
      byFeature: row.by_feature,
      byStudent: row.by_student,
      byModel: row.by_model,
      recent: row.recent,
      forgeDiscardRate: row.forge_discard_rate,
      modelAdvice: modelAdviceFor({
        discardRate: row.forge_discard_rate,
        byModel: row.by_model,
        // Le fournisseur se déduit du modèle dominant : la console ne relit pas
        // le crédential pour ça, et n'a donc aucune raison d'y toucher.
        provider: dominantModel(row.by_model)?.startsWith("claude-")
          ? "anthropic"
          : "openai_compatible",
      }),
      pricesAsOf: AI_MODEL_PRICES_AS_OF,
    };
  });

// ---------------------------------------------------------------------------
// Le retour qualité — 👍/👎 sur un quiz forgé
// ---------------------------------------------------------------------------

export const submitAiFeedback = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        quizId: z.guid(),
        verdict: z.enum(["up", "down"]),
        reason: z.string().max(300).optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const client = context.supabase as unknown as AiConsoleRpcClient;
    // Le `model` n'est PAS envoyé par le client : la RPC le lit sur le quiz.
    // Le laisser déclarer permettrait d'imputer un 👎 au mauvais modèle, et la
    // seule donnée que ce lot produit deviendrait fausse (R-13).
    const { error } = await client.rpc("submit_ai_feedback", {
      p_quiz: data.quizId,
      p_verdict: data.verdict,
      p_reason: data.reason ?? null,
    });
    if (error) {
      if (error.message.includes("AI_FORGE_NOT_FOUND")) {
        throw new Error(`${AI_MODE_ERROR_PREFIX}AI_FORGE_NOT_FOUND`);
      }
      failWithClientError("ai.submitAiFeedback", error, "Le signalement n'a pas pu être envoyé.");
    }
    logger.info("ai.feedback", { verdict: data.verdict });
    return { ok: true } as const;
  });

// ---------------------------------------------------------------------------
// La console ADMIN — des agrégats, et les deux interrupteurs
// ---------------------------------------------------------------------------

const adminRowSchema = z.object({
  ai_enabled: z.boolean(),
  families_with_key: z.coerce.number(),
  families_suspended: z.coerce.number(),
  students_enabled: z.coerce.number(),
  calls_30d: z.coerce.number(),
  micros_30d: z.coerce.number(),
  by_provider: z.record(z.string(), z.coerce.number()),
  by_model: z.record(z.string(), z.coerce.number()),
  quality_by_model: z.record(
    z.string(),
    z.object({ up: z.coerce.number(), down: z.coerce.number() }),
  ),
});

export type AiAdminOverview = z.infer<typeof adminRowSchema>;

export const getAiAdminOverview = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<AiAdminOverview | null> => {
    const client = context.supabase as unknown as AiConsoleRpcClient;
    const { data, error } = await client.rpc("get_ai_admin_overview");
    // Un non-admin reçoit `Unauthorized` de la RPC : on rend `null` plutôt que
    // de lever, pour que la route affiche « accès refusé » comme ses voisines.
    if (error) return null;
    const parsed = adminRowSchema.safeParse(Array.isArray(data) ? data[0] : null);
    return parsed.success ? parsed.data : null;
  });

export const setAiModeEnabled = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ enabled: z.boolean() }).parse(d))
  .handler(async ({ data, context }) => {
    const client = context.supabase as unknown as AiConsoleRpcClient;
    const { error } = await client.rpc("set_ai_mode_enabled", { p_enabled: data.enabled });
    if (error) {
      failWithClientError("ai.setAiModeEnabled", error, "Impossible de changer l'état du mode IA.");
    }
    // Un kill-switch actionné se journalise TOUJOURS : c'est un geste
    // d'exploitation, et le prochain incident se lira dans ces lignes.
    logger.warn("ai.killswitch", { scope: "global", enabled: data.enabled });
    return { enabled: data.enabled } as const;
  });

export const setAiOwnerSuspension = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        ownerUserId: z.guid(),
        suspended: z.boolean(),
        reason: z.string().max(300).optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const client = context.supabase as unknown as AiConsoleRpcClient;
    const { error } = await client.rpc("set_ai_owner_suspension", {
      p_owner: data.ownerUserId,
      p_suspended: data.suspended,
      p_reason: data.reason ?? null,
    });
    if (error) {
      failWithClientError("ai.setAiOwnerSuspension", error, "Impossible de couper cette famille.");
    }
    logger.warn("ai.killswitch", { scope: "owner", enabled: !data.suspended });
    return { suspended: data.suspended } as const;
  });
