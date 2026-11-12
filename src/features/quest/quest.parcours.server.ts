// Le parcours (la classe) auquel une matière, donc un exercice, appartient.
//
// Étude 38, lot 2. `getSubject` dérivait ce parcours pour l'ancre de niveau du hub ;
// la quête en a besoin à son tour, pour proposer sa classe à un élève qui n'en a
// pas encore choisi (R-5). Plutôt qu'une seconde copie de la dérivation — donc un
// second juge sur la même question, leçon L-4 —, elle vit ici, une fois, et les
// deux appelants la partagent.

import { createServerFn } from "@tanstack/react-start";
import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import type { Database } from "@/shared/integrations/supabase/types";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";

type Supabase = SupabaseClient<Database>;

/** La ligne `parcours` telle que le hub et la quête la lisent. */
export type SubjectParcours = {
  id: string;
  name_fr: string;
  name_en: string | null;
  name_ar: string | null;
  is_premium: boolean;
};

/** Ce que la carte de classe de la quête reçoit : de quoi nommer, et de quoi choisir. */
export type ExerciseParcours = Pick<SubjectParcours, "id" | "name_fr" | "name_en" | "name_ar">;

/**
 * Le parcours qui porte une matière — RPC `resolve_subject_parcours(theme, grade)`,
 * puis lecture de la ligne. `null` quand la matière n'a pas de thème ou que rien ne
 * lui correspond. LÈVE si la base échoue : chaque appelant choisit sa dégradation
 * (le hub perd son ancre, la quête sa carte), aucun ne casse sa page.
 */
export async function resolveSubjectParcours(
  supabase: Supabase,
  subject: { theme_id?: string | null; grade_id?: string | null },
): Promise<SubjectParcours | null> {
  const themeId = subject.theme_id ?? null;
  const gradeId = subject.grade_id ?? null;
  if (!themeId) return null;
  // resolve_subject_parcours matches grade_id with IS NOT DISTINCT FROM, so a
  // null grade is valid (grade-agnostic themes resolve their own parcours); the
  // generated arg type narrows p_grade to string, hence the cast on the nullable.
  const parcoursIdRes = await supabase.rpc("resolve_subject_parcours", {
    p_theme: themeId,
    p_grade: gradeId as string,
  });
  const parcoursId = (parcoursIdRes as { data?: string | null }).data ?? null;
  if (!parcoursId) return null;
  const { data: p } = await supabase
    .from("parcours")
    .select("id,name_fr,name_en,name_ar,is_premium")
    .eq("id", parcoursId)
    .maybeSingle();
  return (p as SubjectParcours | null) ?? null;
}

/**
 * Le parcours du chapitre d'un exercice (étude 38, lot 2 — R-5). Lecture seule.
 *
 * La route `quest` ne l'appelle QUE pour un élève sans parcours : aucun surcoût
 * pour les autres chargements. `null` — exercice inconnu, matière sans parcours,
 * ou lecture en échec — veut dire « pas de carte » : la quête, elle, se joue
 * toujours.
 */
export const getExerciseParcours = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d) => z.object({ exerciseId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<ExerciseParcours | null> => {
    const { supabase } = context;
    try {
      const { data: row, error } = await supabase
        .from("exercises")
        .select("subjects(theme_id, grade_id)")
        .eq("id", data.exerciseId)
        .maybeSingle();
      if (error) throw error;
      if (!row?.subjects) return null;
      const parcours = await resolveSubjectParcours(supabase, row.subjects);
      if (!parcours) return null;
      return {
        id: parcours.id,
        name_fr: parcours.name_fr,
        name_en: parcours.name_en,
        name_ar: parcours.name_ar,
      };
    } catch (err) {
      logger.warn("quest.getExerciseParcours: parcours lookup failed", {
        exerciseId: data.exerciseId,
        error: errorMessage(err),
      });
      return null;
    }
  });
