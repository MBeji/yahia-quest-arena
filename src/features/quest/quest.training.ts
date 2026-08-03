import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { logger } from "@/shared/lib/logger";

// ---------- « M'entraîner » sur l'erreur commise (étude 04 A1.2 / A12) ----------
/**
 * Les exercices qui entraînent la compétence mise en défaut par l'erreur.
 *
 * R-A1.2-6 impose de RÉUTILISER la remédiation d'é07 lot 4 plutôt que d'en créer
 * une seconde — et c'est bien le cas : l'unique implémentation reste la RPC
 * `get_exercises_for_competency`, qui applique la porte d'accès côté SQL. Ce qui
 * est dupliqué ici est l'enveloppe TanStack, pas la règle, et c'est voulu : la
 * feature `quest` ne peut pas importer `progression` (frontière AGENTS.md), et
 * déplacer la RPC dans `shared` pour une enveloppe de six lignes coûterait plus
 * cher que ces six lignes.
 *
 * La traduction misconception → compétence, elle, est DÉCLARÉE dans le registre
 * (A12) et voyage avec la correction : le client passe une compétence, jamais un
 * tag. Dégradation gracieuse — une RPC absente rend une liste vide, donc le bouton
 * ne mène nulle part plutôt que de casser l'écran de résultat.
 */
type CompetencyExercisesRpc = {
  rpc: (
    fn: "get_exercises_for_competency",
    args: { p_competency: string },
  ) => PromiseLike<{
    data: Array<{ exercise_id: string }> | null;
    error: { message: string } | null;
  }>;
};

export const getTrainingForMisconception = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ competency: z.string().trim().min(1).max(120) }).parse(d))
  .handler(async ({ data, context }): Promise<{ exerciseId: string | null }> => {
    const client = context.supabase as unknown as CompetencyExercisesRpc;
    const res = await client.rpc("get_exercises_for_competency", {
      p_competency: data.competency,
    });
    if (res.error) {
      logger.warn("quest.getTrainingForMisconception: RPC en échec, aucune cible", {
        error: res.error.message,
      });
      return { exerciseId: null };
    }
    return { exerciseId: res.data?.[0]?.exercise_id ?? null };
  });
