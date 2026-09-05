import type { SupabaseClient } from "@supabase/supabase-js";
import type { Database } from "@/shared/integrations/supabase/types";
import { errorMessage } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import type { RecallAvailability } from "./quest.recall";

type Supabase = SupabaseClient<Database>;

/**
 * Accès de TEST sans restriction — le compte admin (2026-09-05).
 *
 * Le rôle `admin` n'est pas un compte d'usage : c'est l'outil du test humain du
 * contenu. Il doit pouvoir ouvrir n'importe quelle mission et n'importe quelle
 * question, dans n'importe quel ordre, sans passer les quiz de compréhension.
 *
 * QUI DÉCIDE. La RPC `start_exercise_session` (20260905150000) : elle franchit
 * pour ce rôle les trois portes de PROGRESSION — accès au parcours, quiz du
 * chapitre, Rappel après un classique à 100 %. Ce module ne fait que LIRE la même
 * définition, `public.is_admin()`, pour que le hub, le lecteur de cours et le
 * lecteur d'exercice AFFICHENT ce que la RPC accordera. Sans cela, l'admin
 * verrait des cadenas que le serveur n'appliquerait pas — et une ligne
 * verrouillée n'est pas cliquable. Un appel, un prédicat : on ne recopie pas la
 * règle `role === 'admin'` une fois de plus.
 *
 * Fail-safe : anonyme, erreur ou RPC muette ⇒ `false`, l'accès ordinaire. Se
 * tromper dans ce sens coûte un cadenas de trop à un testeur ; dans l'autre, un
 * hub qui promet ce que le serveur refuse.
 */
export async function isUnrestrictedViewer(
  supabase: Supabase,
  userId: string | null,
): Promise<boolean> {
  if (!userId) return false;
  try {
    const { data, error } = await supabase.rpc("is_admin");
    if (error) {
      logger.warn("quest.access: is_admin failed — accès ordinaire", { error: error.message });
      return false;
    }
    return data === true;
  } catch (err) {
    logger.warn("quest.access: is_admin threw — accès ordinaire", { error: errorMessage(err) });
    return false;
  }
}

/**
 * Le hub vu par un compte de test : chaque porte que `getSubject` aurait affichée
 * fermée est marquée ouverte — le quiz de chaque chapitre « passé », le Rappel de
 * chaque mission éligible « débloqué ». Pur : rend de nouveaux objets et ne touche
 * pas aux entrées (le repli `EMPTY_RECALL_AVAILABILITY` est un objet partagé).
 */
export function openEveryGate(view: {
  quizPassedByChapter: Record<string, boolean>;
  recall: RecallAvailability;
}): { quizPassedByChapter: Record<string, boolean>; recall: RecallAvailability } {
  return {
    quizPassedByChapter: Object.fromEntries(
      Object.keys(view.quizPassedByChapter).map((chapterId) => [chapterId, true]),
    ),
    recall: {
      ...view.recall,
      unlockedByExercise: Object.fromEntries(
        Object.keys(view.recall.eligibleByExercise).map((exerciseId) => [exerciseId, true]),
      ),
    },
  };
}
