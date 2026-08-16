import { useLearningPulse } from "@/hooks/use-learning-pulse";

/** La part de l'exercice chargé dont dépend le type d'activité rapporté. */
type PulsedExercise = {
  subject_id?: string | null;
  chapter_id?: string | null;
  mode?: string | null;
} | null;

/**
 * Le pouls d'activité d'une mission, avec le bon type d'activité.
 *
 * Extrait du lecteur d'exercice pour deux raisons : le mapping mode → surface est
 * une règle produit qui se teste seule, et `exercise-player.tsx` est au plafond
 * de `max-lines` — y ajouter sept lignes de câblage l'aurait fait déborder.
 *
 * Le type d'activité suit le mode RÉEL de la mission, pour que le parent lise
 * « quiz », « révisions » ou « exercices » plutôt qu'un fourre-tout.
 */
export function useQuestPulse(
  exercise: PulsedExercise | undefined,
  exerciseId: string,
  isRecall: boolean,
  enabled: boolean,
): void {
  useLearningPulse({
    surface: isRecall ? "recall" : exercise?.mode === "quiz" ? "quiz" : "exercise",
    subjectId: exercise?.subject_id ?? null,
    chapterId: exercise?.chapter_id ?? null,
    exerciseId,
    enabled,
  });
}
