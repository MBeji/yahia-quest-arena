import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { errorMessage } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import type { Json } from "@/shared/integrations/supabase/types";

/**
 * Le DELTA d'une soumission — étude 34, lot 4.
 *
 * Extrait de `quest.server.ts` parce que ce fichier-là avait atteint sa limite de
 * 750 lignes. Ce n'est pas une contorsion pour passer le lint : la lecture « ce
 * que ce geste a fait tomber » est un sujet à part de « soumettre une tentative »,
 * et elle a maintenant un endroit qui le dit.
 */
/**
 * Le DELTA d'une soumission : les étoiles gagnées, le sceau s'il tombe, les
 * badges décernés par CE geste-là.
 *
 * ⚠️ Elle prend un `exerciseId`, pas un id de tentative, et c'est délibéré :
 * `submit_exercise_attempt` ne rend pas l'id de la tentative qu'elle crée, et
 * l'étude 34 a décidé de **ne pas la toucher** (D-4 — ~570 lignes que trois
 * études ont déjà ré-émises en trois semaines). L'enveloppe SQL résout « ma
 * dernière tentative sur cet exercice », qui est exactement celle qu'on vient
 * de rendre.
 *
 * Lue APRÈS le résultat, jamais avant : la célébration suit le fait, elle ne
 * l'annonce pas. Un échec de lecture rend `null` — l'écran se tait alors, et
 * c'est la bonne conduite : une célébration inventée vaut moins que rien.
 */
export const getAttemptProgress = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<Json | null> => {
    const { supabase } = context;
    try {
      const res = await supabase.rpc("get_last_attempt_progress", {
        p_exercise_id: data.exerciseId,
      });
      if (res.error) {
        logger.warn("quest.getAttemptProgress: RPC failed", {
          exerciseId: data.exerciseId,
          error: res.error.message,
        });
        return null;
      }
      return res.data ?? null;
    } catch (err: unknown) {
      logger.warn("quest.getAttemptProgress: RPC threw", {
        exerciseId: data.exerciseId,
        error: errorMessage(err),
      });
      return null;
    }
  });
