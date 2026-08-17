import type { ActivityTotals, DailyReport, DailySlice } from "./daily-report";

/**
 * Les KPI dérivés — §4 du cahier des charges. Tout ce qui se déduit des totaux
 * sans repasser par le serveur, plus les deux formats d'affichage que la moitié
 * des écrans du tableau de bord réclament.
 */

/** La plus longue série de jours actifs consécutifs DANS la période. */
export function longestActiveStreak(days: DailySlice[]): number {
  let best = 0;
  let run = 0;
  for (const day of days) {
    if (day.activities > 0 || day.appMinutes > 0) {
      run += 1;
      best = Math.max(best, run);
    } else {
      run = 0;
    }
  }
  return best;
}

/** La série en cours à la fin de la période (0 si le dernier jour est vide). */
export function trailingActiveStreak(days: DailySlice[]): number {
  let run = 0;
  for (let i = days.length - 1; i >= 0; i -= 1) {
    const day = days[i];
    if (day.activities > 0 || day.appMinutes > 0) run += 1;
    else break;
  }
  return run;
}

/** Part (0–100) de `value` sur `total`, 0 quand le total est nul. */
export function pct(value: number, total: number): number {
  if (!Number.isFinite(value) || !Number.isFinite(total) || total <= 0) return 0;
  return Math.round((value / total) * 100);
}

/** Écart entre deux périodes — `null` quand la précédente n'a rien à comparer. */
export function delta(current: number, previous: number, hasPrevious: boolean): number | null {
  return hasPrevious ? Math.round(current - previous) : null;
}

export type DerivedKpis = {
  /** Taux global de bonnes réponses (0–100). */
  accuracyPct: number;
  /** Taux de réussite des exercices — part passée au-dessus du seuil. */
  exerciseSuccessPct: number;
  /** Taux de complétion des cours ouverts (réellement étudiés / ouverts). */
  lessonCompletionPct: number;
  /** Taux de complétion des exercices commencés. */
  exerciseCompletionPct: number;
  /** Régularité : jours actifs sur jours de la période (0–100). */
  regularityPct: number;
  /** Jours actifs consécutifs, au sein de la période. */
  consecutiveActiveDays: number;
  /** Part du temps d'application réellement consacrée à l'apprentissage. */
  learningSharePct: number;
  /** Évolution du score moyen vs période précédente — `null` si incomparable. */
  scoreDelta: number | null;
  /** Évolution du temps d'apprentissage — `null` si la période précédente est vide. */
  learningMinutesDelta: number | null;
  /** Évolution du nombre d'exercices. */
  exercisesDelta: number | null;
};

export function deriveKpis(report: DailyReport): DerivedKpis {
  const t: ActivityTotals = report.totals;
  const p: ActivityTotals = report.previous;
  const days = Math.max(1, report.range.days);
  // « Rien la période précédente » n'est pas une base de comparaison : mieux
  // vaut ne rien afficher qu'un « +100 % » qui ne veut rien dire.
  const hasPrevious = p.exercises > 0 || p.appMinutes > 0;

  return {
    accuracyPct: pct(t.correct, t.questions),
    exerciseSuccessPct: pct(t.exercisesPassed, t.exercises),
    lessonCompletionPct: pct(t.lessonsStudied, t.lessonsOpened),
    exerciseCompletionPct: pct(t.exerciseSessionsCompleted, t.exerciseSessionsStarted),
    regularityPct: pct(t.activeDays, days),
    consecutiveActiveDays: longestActiveStreak(report.days),
    learningSharePct: pct(t.learningMinutes, t.appMinutes),
    scoreDelta: delta(t.avgScore, p.avgScore, p.exercises > 0 && t.exercises > 0),
    learningMinutesDelta: delta(t.learningMinutes, p.learningMinutes, hasPrevious),
    exercisesDelta: delta(t.exercises, p.exercises, hasPrevious),
  };
}

/** « 2 h 15 », « 45 min », « — » — le format lu par un parent, pas par un ingénieur. */
export function formatMinutes(minutes: number, emptyLabel = "—"): string {
  const value = Math.max(0, Math.round(minutes));
  if (value === 0) return emptyLabel;
  if (value < 60) return `${value} min`;
  const h = Math.floor(value / 60);
  const m = value % 60;
  return m > 0 ? `${h} h ${String(m).padStart(2, "0")}` : `${h} h`;
}

/** Idem depuis des secondes — les durées de lecture arrivent en secondes. */
export function formatSeconds(seconds: number, emptyLabel = "—"): string {
  const value = Math.max(0, Math.round(seconds));
  if (value === 0) return emptyLabel;
  if (value < 60) return `${value} s`;
  return formatMinutes(value / 60, emptyLabel);
}
