/**
 * Complétion d'un chapitre et progression d'une matière — étude 22, R-14/R-15/R-16.
 *
 * Helpers purs (aucun React, aucun Supabase), unité de vérité côté client de la définition
 * que la RPC `get_user_parcours_progress` encode côté serveur pour la carte `/parcours`. Le hub
 * matière les consomme sur les données que `getSubject` lui envoie déjà — aucune requête de
 * plus. Si tu changes une règle ici, change la migration `20260720120000` dans le même lot :
 * les deux doivent rester d'accord, sinon la carte et le hub raconteront deux histoires.
 *
 * Le mode Rappel n'apparaît nulle part : ce n'est pas une ligne `exercises` mais une variante
 * de tentative, et `bestByExercise` ne remonte que les tentatives `variant = 'classic'`. Une
 * reprise en Rappel ne complète donc jamais un chapitre, sans qu'aucun filtre soit nécessaire.
 */
import { PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";

/** Le strict minimum dont les règles ont besoin — volontairement plus large que le hub. */
export type CompletionExercise = {
  id: string;
  chapter_id: string;
  mode: string;
  /** `admin` (catalogue) ou `parent` (mission créée par un parent). Absent ⇒ `admin`. */
  source?: string | null;
};

/**
 * Une **mission de catalogue** : `source = 'admin'`, hors quiz de compréhension (R-15).
 * Les missions `source = 'parent'` sont du contenu familial : elles ne comptent ni dans la
 * complétion d'un chapitre ni dans la progression d'une matière.
 */
export function isCatalogueMission(exercise: CompletionExercise): boolean {
  return (exercise.source ?? "admin") === "admin" && exercise.mode !== "quiz";
}

/** R-14 : une mission est **réussie** à partir de 60 % (meilleur score classique). */
export function isMissionPassed(bestScore: number | null | undefined): boolean {
  return bestScore != null && bestScore >= PASS_THRESHOLD_PCT;
}

/**
 * R-16 : un chapitre est **publié** — donc compté au dénominateur de la progression — s'il
 * porte au moins une mission de catalogue, c'est-à-dire s'il y a quelque chose à y jouer.
 *
 * Un chapitre sans mission serait sinon « complété » par vacuité (« toutes ses missions sont
 * réussies » est vrai quand il n'y en a aucune) ou bloquerait la progression sous 100 % à
 * jamais, selon le sens de lecture. On l'exclut des deux côtés de la fraction.
 */
export function isChapterPublished(exercisesOfChapter: CompletionExercise[]): boolean {
  return exercisesOfChapter.some(isCatalogueMission);
}

/**
 * R-15 : un chapitre est **complété** quand son quiz de compréhension est passé (si le
 * chapitre est quiz-gaté) ET que toutes ses missions de catalogue sont réussies (≥ 60 %).
 *
 * `quizSatisfied` est fourni par l'appelant parce que la porte du quiz est **serveur** : le
 * hub reçoit `quizPassedByChapter` déjà résolu (score ≥ 80 % ET ≥ 4 s/question), pré-rempli à
 * `true` pour les matières hors-école, et le fusionne avec la session anonyme. Cette fonction
 * ne la recalcule pas — elle ne fait que la respecter.
 */
export function isChapterComplete(
  exercisesOfChapter: CompletionExercise[],
  bestByExercise: Record<string, number>,
  quizSatisfied: boolean,
): boolean {
  if (!isChapterPublished(exercisesOfChapter)) return false;
  if (!quizSatisfied) return false;
  return exercisesOfChapter
    .filter(isCatalogueMission)
    .every((e) => isMissionPassed(bestByExercise[e.id]));
}

/** Nombre de missions de catalogue réussies / total, pour le compteur `x/y` du hub. */
export function chapterMissionCounts(
  exercisesOfChapter: CompletionExercise[],
  bestByExercise: Record<string, number>,
): { done: number; total: number } {
  const missions = exercisesOfChapter.filter(isCatalogueMission);
  return {
    done: missions.filter((e) => isMissionPassed(bestByExercise[e.id])).length,
    total: missions.length,
  };
}

/**
 * R-16 : progression d'une matière = chapitres complétés / chapitres publiés.
 *
 * `pct` vaut `null` quand la matière ne publie aucun chapitre — jamais 100 %, qui allumerait
 * l'état `done` de la carte sur une matière vide.
 */
export function subjectProgression(
  chapterIds: string[],
  exercises: CompletionExercise[],
  bestByExercise: Record<string, number>,
  quizSatisfiedByChapter: Record<string, boolean>,
): { total: number; completed: number; pct: number | null } {
  let total = 0;
  let completed = 0;
  for (const chapterId of chapterIds) {
    const chapEx = exercises.filter((e) => e.chapter_id === chapterId);
    if (!isChapterPublished(chapEx)) continue;
    total += 1;
    if (isChapterComplete(chapEx, bestByExercise, quizSatisfiedByChapter[chapterId] === true)) {
      completed += 1;
    }
  }
  return { total, completed, pct: total > 0 ? Math.round((completed / total) * 100) : null };
}
