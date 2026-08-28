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
import { AI_LIVE_FEATURES, TUTOR_HARD_DAILY_CAP } from "@/shared/constants/ai";
import { isPlatformPathEnabled } from "@/shared/integrations/ai/provider.server";
import { AI_MODE_ERROR_PREFIX } from "./ai-mode-status";

type MaybeSingle<Row> = {
  maybeSingle: () => PromiseLike<{
    data: Row | null;
    error: { message: string } | null;
  }>;
};

type AiSurfacesReader = {
  from: {
    (table: "ai_student_access"): {
      select: (columns: string) => {
        eq: (
          column: string,
          value: string,
        ) => MaybeSingle<{ enabled: boolean; features: string[] }>;
      };
    };
    /** Singleton (`id` booléen vrai, CHECK sur la clé) : pas de `.eq()` à écrire. */
    (table: "ai_admin_state"): {
      select: (columns: string) => MaybeSingle<{ ai_enabled: boolean }>;
    };
  };
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
    const client = context.supabase;
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
 * Ce qu'un parent peut activer : les surfaces qui ont un écran, et elles seules
 * ({@link AI_LIVE_FEATURES}). Le serveur applique la même liste que l'écran —
 * sans quoi une requête forgée pourrait inscrire en base l'activation d'une
 * surface qui n'existe pas, et `resolve_ai_access` accorderait un accès vers
 * nulle part.
 */
export const AI_ACTIVATABLE_FEATURES = AI_LIVE_FEATURES;

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
    const client = context.supabase;
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

/** Ce qu'un élève peut atteindre. Aucun montant, et jamais le nom d'un payeur. */
export type AiStudentSurfaces = { enabled: boolean; features: string[] };

/**
 * LA DÉCISION, séparée de ses deux lectures — et elle a DEUX payeurs.
 *
 * `ai_student_access` répond à « la clé de ma famille paie-t-elle cette
 * surface », jamais à « cette surface est-elle ouverte ». Les deux questions ont
 * eu la même réponse tant que le chemin plateforme était éteint ; le jour où
 * `AI_PLATFORM_API_KEY` est posée, elles divergent — `resolve_ai_access` retombe
 * sur la plateforme pour tout élève SANS ligne famille, et pour toute surface
 * qu'une ligne famille ne coche pas.
 *
 * L'écran, lui, ne lisait que la première. Un élève sans clé de famille voyait
 * donc « le mode IA n'est pas encore ouvert sur ce compte » et l'invitation à en
 * brancher une — pendant que le serveur, sollicité, l'aurait servi. La bulle de
 * #894 est née d'exactement cette faute côté famille (« une famille avait
 * branché sa clé sans trouver aucune des surfaces ») ; celle-ci en est l'étage
 * du dessous, et elle rendait la clé plateforme quasi invisible.
 *
 * L'ORDRE DES TROIS ENTRÉES SUIT CELUI DE `resolve_ai_access`, pour que l'écran
 * ne puisse pas promettre ce que le SQL refusera :
 *
 *   1. le kill-switch DONNÉES (`ai_admin_state`) coupe tout, les deux payeurs ;
 *   2. le chemin plateforme, s'il est armé, ouvre TOUTES les surfaces vivantes —
 *      `preparePlatformCall` n'applique aucun filtre de surface ;
 *   3. la ligne famille s'y ajoute (elle ne peut qu'ajouter : ce qu'elle décoche
 *      retombe sur la plateforme, jamais dans le vide).
 *
 * Ce qu'elle NE dit toujours pas, délibérément : qui paie. R-14a interdit tout
 * montant sur cette route, et le payeur n'a pas d'intérêt pour l'élève — il se
 * lit dans la console du porteur, et nulle part ailleurs.
 */
export function studentSurfaces(input: {
  globalEnabled: boolean;
  family: { enabled: boolean; features: string[] } | null;
  platformOpen: boolean;
}): AiStudentSurfaces {
  if (!input.globalEnabled) return { enabled: false, features: [] };

  const features: string[] = input.platformOpen ? [...AI_LIVE_FEATURES] : [];
  if (input.family?.enabled === true) {
    for (const feature of input.family.features ?? []) {
      if (!features.includes(feature)) features.push(feature);
    }
  }

  return { enabled: features.length > 0, features };
}

/**
 * Les surfaces IA actives POUR L'APPELANT — la lecture que fait un élève, pas
 * son porteur de clé.
 *
 * C'est la requête de R-1 côté élève : une surface qui n'est pas dans cette
 * liste ne s'affiche pas du tout. Elle lit sous la RLS de l'élève (sa propre
 * ligne d'accès, et un état global que la migration déclare non secret
 * justement « pour que l'UI puisse dégrader sans passer par une RPC »), donc
 * elle ne révèle rien d'un autre compte — et surtout, elle ne porte AUCUN
 * montant (R-14a).
 */
export const getAiStudentSurfaces = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<AiStudentSurfaces> => {
    // Contrat figé ici, même patron que `exam.server.ts`. Deux colonnes pour
    // l'accès, jamais une de plus — et surtout jamais `owner_user_id`, qui n'a
    // rien à faire chez l'élève.
    const client = context.supabase as unknown as AiSurfacesReader;

    const [family, admin] = await Promise.all([
      client
        .from("ai_student_access")
        .select("enabled, features")
        .eq("student_user_id", context.userId)
        .maybeSingle(),
      client.from("ai_admin_state").select("ai_enabled").maybeSingle(),
    ]);

    return studentSurfaces({
      // Ligne absente ou lecture en échec ⇒ ALLUMÉ. C'est le `COALESCE(…, true)`
      // de `resolve_ai_access`, mot pour mot : le kill-switch se lit à ce qu'il
      // affirme, pas à ce qu'il tait, et une lecture ratée ne doit pas éteindre
      // le parc. La coupure qui ne dépend de rien reste `AI_MODE_ENABLED`.
      globalEnabled: admin.error ? true : admin.data?.ai_enabled !== false,
      family: family.error ? null : family.data,
      // Lu à CHAQUE appel comme partout ailleurs : un kill-switch qu'il faut
      // redéployer pour actionner n'est pas un kill-switch.
      platformOpen: isPlatformPathEnabled(),
    });
  });
