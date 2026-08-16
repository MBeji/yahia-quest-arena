import type { DailyReport, ExerciseRun } from "./daily-report";
import { isTimeMeasured, scoreTrend } from "./engagement";
import { clamp01, ratioBetween, scoreIndex, type IndexResult } from "./scoring";

/**
 * L'indice d'EFFICACITÉ pédagogique — « est-ce que son temps de travail est
 * efficace ? ».
 *
 * C'est le contrepoids de l'indice d'engagement. Passer deux heures par jour
 * dans l'application n'est pas une réussite en soi : la question posée ici est
 * ce que ces heures produisent. Un enfant peut être très engagé et peu efficace
 * (il travaille beaucoup mais recommence sans comprendre), ou l'inverse (peu de
 * temps, mais du temps qui porte).
 *
 * Six signaux : la justesse, le rendement du temps, la progression, la capacité
 * à finir par réussir, le rythme de réponse, et le gain après révision.
 */

export type EfficiencyFactorKey =
  "accuracy" | "timeToResult" | "progression" | "retrySuccess" | "pace" | "revisionGain";

/** Taux de bonnes réponses considéré comme la cible haute. */
export const ACCURACY_TARGET = 0.85;

/** Minutes d'apprentissage par exercice réussi : efficace ↔ inefficace. */
export const MINUTES_PER_PASS_BEST = 8;
export const MINUTES_PER_PASS_WORST = 30;

/** Tentatives moyennes avant réussite : idéal ↔ décrochage. */
export const TRIES_TO_PASS_BEST = 1;
export const TRIES_TO_PASS_WORST = 3.5;

/**
 * Fenêtre de rythme sain, en secondes par question. En dessous de
 * `PACE_RUSHED_S`, on clique sans lire ; au-dessus de `PACE_STALLED_S`, on a
 * décroché de l'écran. Entre `PACE_GOOD_MIN_S` et `PACE_GOOD_MAX_S`, on réfléchit.
 */
export const PACE_RUSHED_S = 8;
export const PACE_GOOD_MIN_S = 15;
export const PACE_GOOD_MAX_S = 45;
export const PACE_STALLED_S = 90;
/** Un rythme hors fenêtre n'annule pas le facteur : il le plafonne bas. */
export const PACE_FLOOR_RATIO = 0.2;

export type EfficiencyResult = IndexResult<EfficiencyFactorKey>;

/** Rythme de réponse → 0–1, en cloche : trop vite ET trop lent sont mauvais. */
export function paceRatio(secondsPerQuestion: number): number {
  if (!Number.isFinite(secondsPerQuestion) || secondsPerQuestion <= 0) return 0;
  if (secondsPerQuestion <= PACE_RUSHED_S) return PACE_FLOOR_RATIO;
  if (secondsPerQuestion >= PACE_STALLED_S) return PACE_FLOOR_RATIO;

  if (secondsPerQuestion < PACE_GOOD_MIN_S) {
    const t = ratioBetween(secondsPerQuestion, PACE_RUSHED_S, PACE_GOOD_MIN_S);
    return PACE_FLOOR_RATIO + t * (1 - PACE_FLOOR_RATIO);
  }
  if (secondsPerQuestion > PACE_GOOD_MAX_S) {
    const t = ratioBetween(secondsPerQuestion, PACE_STALLED_S, PACE_GOOD_MAX_S);
    return PACE_FLOOR_RATIO + t * (1 - PACE_FLOOR_RATIO);
  }
  return 1;
}

/**
 * Le gain apporté par les révisions : écart entre la moyenne obtenue en rappel
 * actif et la moyenne obtenue en mode classique sur la période.
 *
 * `null` tant que l'un des deux modes est absent — comparer une moyenne à rien
 * ne dit rien.
 */
export function revisionGain(exercises: ExerciseRun[]): number | null {
  const recall = exercises.filter((e) => e.variant === "recall");
  const classic = exercises.filter((e) => e.variant !== "recall");
  if (recall.length === 0 || classic.length === 0) return null;

  const mean = (rows: ExerciseRun[]) => rows.reduce((s, r) => s + r.scorePct, 0) / rows.length;
  return Math.round(mean(recall) - mean(classic));
}

export function computeEfficiency(report: DailyReport): EfficiencyResult {
  const { totals } = report;
  const measured = isTimeMeasured(report);
  const trend = scoreTrend(report);

  const accuracy = totals.questions > 0 ? totals.correct / totals.questions : null;
  const minutesPerPass =
    measured && totals.exercisesPassed > 0 && totals.learningMinutes > 0
      ? totals.learningMinutes / totals.exercisesPassed
      : null;
  const gain = revisionGain(report.exercises);

  return scoreIndex<EfficiencyFactorKey>([
    {
      key: "accuracy",
      weight: 25,
      ratio: accuracy === null ? null : clamp01(accuracy / ACCURACY_TARGET),
      detail: {
        accuracyPct: accuracy === null ? 0 : Math.round(accuracy * 100),
        correct: totals.correct,
        questions: totals.questions,
      },
    },
    {
      key: "timeToResult",
      weight: 20,
      // Le cœur de la question : combien de minutes coûte UN exercice réussi.
      ratio:
        minutesPerPass === null
          ? null
          : ratioBetween(minutesPerPass, MINUTES_PER_PASS_WORST, MINUTES_PER_PASS_BEST),
      detail: {
        minutesPerPass: minutesPerPass === null ? 0 : Math.round(minutesPerPass),
        learningMinutes: totals.learningMinutes,
        exercisesPassed: totals.exercisesPassed,
      },
    },
    {
      key: "progression",
      weight: 20,
      ratio: trend === null ? null : ratioBetween(trend, -10, 10),
      detail: {
        trend: trend ?? 0,
        avgScore: totals.avgScore,
        previousAvgScore: report.previous.avgScore,
      },
    },
    {
      key: "retrySuccess",
      weight: 15,
      // Réussir du premier coup vaut mieux que réussir au quatrième essai — mais
      // réussir au deuxième reste une réussite, d'où une pente et non un seuil.
      ratio:
        totals.avgTriesToPass > 0
          ? ratioBetween(totals.avgTriesToPass, TRIES_TO_PASS_WORST, TRIES_TO_PASS_BEST)
          : null,
      detail: {
        avgTriesToPass: totals.avgTriesToPass,
        exercisesPassed: totals.exercisesPassed,
        exercisesFailed: totals.exercisesFailed,
      },
    },
    {
      key: "pace",
      weight: 10,
      ratio: totals.avgSecondsPerQuestion > 0 ? paceRatio(totals.avgSecondsPerQuestion) : null,
      detail: {
        secondsPerQuestion: totals.avgSecondsPerQuestion,
        secondsPerExercise: totals.avgSecondsPerExercise,
      },
    },
    {
      key: "revisionGain",
      weight: 10,
      // Une révision qui ne fait pas remonter le score n'a pas fonctionné.
      ratio: gain === null ? null : ratioBetween(gain, -10, 15),
      detail: { gain: gain ?? 0 },
    },
  ]);
}
