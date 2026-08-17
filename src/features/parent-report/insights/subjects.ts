import type { ChapterSlice, DailyReport, SubjectSlice } from "./daily-report";
import type { IndexBand } from "./scoring";

/**
 * L'analyse par matière — §7 du cahier des charges : quelles matières sont
 * fortes, lesquelles sont fragiles, lesquelles ont été délaissées, où l'enfant
 * progresse le plus, et quels chapitres demandent une révision.
 *
 * Tout est déduit du rapport : aucune règle ici n'a besoin d'un aller-retour
 * serveur, et chacune est un seuil nommé plutôt qu'un nombre magique enfoui.
 */

/** Une moyenne sur une seule tentative n'est pas un niveau, c'est un coup de dé. */
export const MIN_ATTEMPTS_FOR_VERDICT = 2;
/** À partir d'ici on parle de matière forte. */
export const STRONG_SUBJECT_PCT = 80;
/** En deçà, la matière est fragile (aligné sur le seuil de réussite). */
export const FRAGILE_SUBJECT_PCT = 60;
/** Activité minimale la période précédente pour parler d'abandon. */
export const MIN_PREVIOUS_FOR_NEGLECT = 2;
/** Écart minimal pour saluer une progression sur une matière. */
export const MIN_DELTA_FOR_IMPROVEMENT = 5;

export type SubjectAnalysis = {
  /** Travaillées et bien réussies. */
  strong: SubjectSlice[];
  /** Travaillées mais en difficulté. */
  fragile: SubjectSlice[];
  /** Travaillées la période précédente, plus du tout maintenant. */
  neglected: SubjectSlice[];
  /** Celles où le score monte le plus par rapport à la période précédente. */
  mostImproved: SubjectSlice[];
  /** Chapitres sous le seuil de réussite — la liste à réviser. */
  chaptersToReview: ChapterSlice[];
};

/**
 * Le « niveau » affiché dans la colonne du tableau des matières. `null` quand la
 * matière n'a pas assez de tentatives pour qu'un niveau veuille dire quelque
 * chose — on affiche alors un tiret, pas un verdict inventé.
 */
export function subjectLevel(subject: SubjectSlice): IndexBand | null {
  if (subject.exercises < MIN_ATTEMPTS_FOR_VERDICT) return null;
  if (subject.avgScore >= STRONG_SUBJECT_PCT) return "excellent";
  if (subject.avgScore >= 65) return "good";
  if (subject.avgScore >= 50) return "fair";
  return "weak";
}

export function analyzeSubjects(report: DailyReport): SubjectAnalysis {
  const passPct = report.thresholds.passPct || FRAGILE_SUBJECT_PCT;
  const worked = report.subjects.filter((s) => s.exercises >= MIN_ATTEMPTS_FOR_VERDICT);

  const strong = worked
    .filter((s) => s.avgScore >= STRONG_SUBJECT_PCT)
    .sort((a, b) => b.avgScore - a.avgScore);

  const fragile = worked
    .filter((s) => s.avgScore < FRAGILE_SUBJECT_PCT)
    .sort((a, b) => a.avgScore - b.avgScore);

  // Délaissée : elle existait dans la période précédente et a totalement
  // disparu de celle-ci — ni exercice, ni minute mesurée.
  const neglected = report.subjects
    .filter(
      (s) =>
        s.exercises === 0 && s.minutes === 0 && s.previousExercises >= MIN_PREVIOUS_FOR_NEGLECT,
    )
    .sort((a, b) => b.previousExercises - a.previousExercises);

  const mostImproved = report.subjects
    .filter((s) => s.scoreDelta !== null && s.scoreDelta >= MIN_DELTA_FOR_IMPROVEMENT)
    .sort((a, b) => (b.scoreDelta ?? 0) - (a.scoreDelta ?? 0));

  const chaptersToReview = report.chapters
    .filter((c) => c.exercises >= MIN_ATTEMPTS_FOR_VERDICT && c.avgScore < passPct)
    .sort((a, b) => a.avgScore - b.avgScore);

  return { strong, fragile, neglected, mostImproved, chaptersToReview };
}
