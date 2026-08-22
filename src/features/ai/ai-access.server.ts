// L'ACTIVATION par élève — R-3 (étude 29 lot 3).
//
// « Une clé enregistrée n'allume rien. Le défaut de toute activation est
// ÉTEINT. » Ces deux server fns sont le seul chemin par lequel un mode s'allume,
// et le seul par lequel un écran apprend qu'il est allumé.
//
// Deux formes d'activation, UNE seule mécanique : le porteur active ses élèves
// liés (`parent_student_links`), ou lui-même (auto-détention, ouverte par Q-2).
// Le SQL n'en fait pas deux cas — il vérifie « lié OU soi-même », et le reste du
// système ne sait pas laquelle des deux s'applique.
//
// R-14 s'exprime dans ce que ces fonctions NE rendent PAS : aucun montant. La
// liste porte de l'énergie — une mécanique de jeu (é11 R-12) — et rien d'autre.
// La dépense se lit ailleurs, dans une surface réservée au porteur.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { logger } from "@/shared/lib/logger";
import { failWithClientError } from "@/shared/lib/safe-error";
import { AI_FEATURES, TUTOR_HARD_DAILY_CAP } from "@/shared/constants/ai";
import { AI_MODE_ERROR_PREFIX } from "./ai-mode-status";

type AiSurfacesReader = {
  from: (table: "ai_student_access") => {
    select: (columns: string) => {
      eq: (
        column: string,
        value: string,
      ) => {
        maybeSingle: () => PromiseLike<{
          data: { enabled: boolean; features: string[] } | null;
          error: { message: string } | null;
        }>;
      };
    };
  };
};

type AiAccessRpcClient = {
  rpc: (
    fn: "get_ai_students" | "set_ai_student_access" | "resolve_ai_access",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

const studentRowSchema = z.object({
  student_user_id: z.string(),
  display_name: z.string().nullable(),
  is_self: z.boolean(),
  enabled: z.boolean(),
  features: z.array(z.string()),
  daily_energy_max: z.number(),
  energy_spent_today: z.number(),
});

/** Ce que l'écran d'activation affiche pour un élève. Aucun montant (R-14). */
export type AiStudentAccess = {
  readonly studentUserId: string;
  readonly displayName: string | null;
  /** Le porteur s'active lui-même (Q-2) — l'écran le nomme autrement qu'un enfant. */
  readonly isSelf: boolean;
  readonly enabled: boolean;
  readonly features: string[];
  readonly dailyEnergyMax: number;
  readonly energySpentToday: number;
};

export const getAiStudents = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<AiStudentAccess[]> => {
    const client = context.supabase as unknown as AiAccessRpcClient;
    const { data, error } = await client.rpc("get_ai_students");
    if (error) {
      failWithClientError("ai.getAiStudents", error, "Impossible de charger la liste.");
    }

    const parsed = z.array(studentRowSchema).safeParse(data ?? []);
    if (!parsed.success) return [];

    return parsed.data.map((row) => ({
      studentUserId: row.student_user_id,
      displayName: row.display_name,
      isSelf: row.is_self,
      enabled: row.enabled,
      features: row.features,
      dailyEnergyMax: row.daily_energy_max,
      energySpentToday: row.energy_spent_today,
    }));
  });

/**
 * Les surfaces activables par le porteur. Sous-ensemble de `AI_FEATURES` : on
 * n'active pas `verify` (c'est le geste du porteur lui-même) ni `forge_solve`
 * (c'est la seconde moitié de `forge`, pas un choix).
 */
export const AI_ACTIVATABLE_FEATURES = AI_FEATURES.filter(
  (f) => f !== "verify" && f !== "forge_solve",
);

export const setAiStudentAccess = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        studentUserId: z.guid(),
        enabled: z.boolean(),
        // La liste est validée contre le vocabulaire fermé : une surface
        // inventée côté client n'entre pas en base, et `resolve_ai_access` ne
        // la reconnaîtrait de toute façon jamais.
        features: z.array(z.enum(AI_ACTIVATABLE_FEATURES)).max(AI_ACTIVATABLE_FEATURES.length),
        // R-9 : le plafond dur ne se règle pas. La borne est ici ET dans le SQL
        // ET dans un CHECK — trois fois, parce que c'est un garde-fou
        // pédagogique (é09 anti-farm) et pas un simple réglage.
        dailyEnergyMax: z.number().int().min(0).max(TUTOR_HARD_DAILY_CAP),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const client = context.supabase as unknown as AiAccessRpcClient;
    const { error } = await client.rpc("set_ai_student_access", {
      p_student: data.studentUserId,
      p_enabled: data.enabled,
      p_features: data.features,
      p_energy_max: data.dailyEnergyMax,
    });

    if (error) {
      // Les signaux métier voyagent dans le message de l'exception SQL (motif
      // `DUNGEON_LOCKED`), et sont traduits côté client.
      for (const code of ["AI_NOT_LINKED", "AI_NO_CREDENTIAL", "AI_ENERGY_CAP_EXCEEDED"]) {
        if (error.message.includes(code)) {
          logger.warn("ai.access.set", { code });
          throw new Error(`${AI_MODE_ERROR_PREFIX}${code}`);
        }
      }
      failWithClientError("ai.setAiStudentAccess", error, "Impossible d'enregistrer l'activation.");
    }

    logger.info("ai.access", { action: "set", enabled: data.enabled, count: data.features.length });
    return { ok: true } as const;
  });

/**
 * Les surfaces IA actives POUR L'APPELANT — la lecture que fait un élève, pas
 * son porteur de clé.
 *
 * C'est la requête de R-1 côté élève : une surface qui n'est pas dans cette
 * liste ne s'affiche pas du tout. Elle lit `ai_student_access` sous la RLS de
 * l'élève (sa propre ligne), donc elle ne révèle rien d'un autre compte — et
 * surtout, elle ne porte AUCUN montant (R-14a).
 */
export const getAiStudentSurfaces = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ enabled: boolean; features: string[] }> => {
    // La table est postérieure aux types Supabase générés : contrat figé ici,
    // même patron que `exam.server.ts`. Deux colonnes, jamais une de plus — et
    // surtout jamais `owner_user_id`, qui n'a rien à faire chez l'élève.
    const client = context.supabase as unknown as AiSurfacesReader;
    const { data: row, error } = await client
      .from("ai_student_access")
      .select("enabled, features")
      .eq("student_user_id", context.userId)
      .maybeSingle();

    if (error || !row) return { enabled: false, features: [] };
    return { enabled: row.enabled === true, features: row.features ?? [] };
  });
