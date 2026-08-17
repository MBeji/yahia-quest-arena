import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { PULSE_MAX_SECONDS, PULSE_MIN_SECONDS } from "@/shared/lib/learning-pulse";

/**
 * L'écriture d'un pouls d'activité.
 *
 * Elle vit dans `shared/` et non dans une feature : les émetteurs sont le lecteur
 * de cours, la quête, le donjon et les duels — quatre features, qui n'ont pas le
 * droit de s'importer entre elles. Le consommateur (le suivi parental) ne lit
 * jamais cette fonction, seulement la table.
 *
 * Elle ne casse JAMAIS l'écran appelant : une panne de télémétrie n'a pas à
 * interrompre une lecture ou une quête. Toute erreur est journalisée puis avalée,
 * et l'appelant reçoit `credited: 0`.
 */
export const recordLearningPulse = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        surface: z.enum(["lesson", "exercise", "quiz", "recall", "dungeon", "duel", "browse"]),
        activeSeconds: z.number().int().min(PULSE_MIN_SECONDS).max(PULSE_MAX_SECONDS),
        // `subjects.id` est un slug texte, pas un UUID (catalogue).
        subjectId: z.string().min(1).max(64).nullish(),
        chapterId: z.guid().nullish(),
        exerciseId: z.guid().nullish(),
        progressPct: z.number().int().min(0).max(100).nullish(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Le débit normal est d'un pouls par minute et par surface ouverte. 40/min
    // laisse largement passer plusieurs onglets sans ouvrir la porte au flood.
    if (await isRateLimited(supabase, `pulse_${userId}`, 40, 60_000)) {
      return { credited: 0 };
    }

    const { data: credited, error } = await supabase.rpc("record_learning_pulse", {
      p_surface: data.surface,
      p_active_seconds: data.activeSeconds,
      p_subject: data.subjectId ?? undefined,
      p_chapter: data.chapterId ?? undefined,
      p_exercise: data.exerciseId ?? undefined,
      p_progress_pct: data.progressPct ?? undefined,
    });

    if (error) {
      logger.warn("learningPulse.record: RPC failed", { error: errorMessage(error) });
      return { credited: 0 };
    }

    return { credited: typeof credited === "number" ? credited : 0 };
  });
