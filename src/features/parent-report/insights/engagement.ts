import type { DailyReport } from "./daily-report";
import { clamp01, ratioBetween, scoreIndex, type IndexResult } from "./scoring";

/**
 * L'indice d'ENGAGEMENT — « est-ce qu'il travaille sérieusement et
 * régulièrement ? ».
 *
 * Il répond à une question de comportement, pas de résultat : un enfant peut
 * être très engagé et encore fragile sur le fond (c'est l'indice d'EFFICACITÉ,
 * `efficiency.ts`, qui parle de résultat). Les deux sont volontairement séparés
 * pour qu'un parent ne confonde pas « il s'y met » et « ça marche ».
 *
 * Sept signaux, pondérés. Chacun est ramené à un objectif proportionnel à la
 * LONGUEUR de la période : « 25 minutes » veut dire 25 minutes sur une journée
 * et 175 sur une semaine, sinon « aujourd'hui » serait toujours médiocre et
 * « ce mois » toujours excellent.
 */

export type EngagementFactorKey =
  | "regularity"
  | "learningTime"
  | "activityVolume"
  | "lessonCompletion"
  | "perseverance"
  | "progress"
  | "revision";

/** Jours travaillés attendus sur 7 — 5, pas 7 : personne ne demande le sans-faute. */
export const EXPECTED_ACTIVE_DAYS_PER_WEEK = 5;

/** Minutes d'apprentissage visées par jour de la période. */
export const DAILY_LEARNING_TARGET_MIN = 25;

/** Activités (exercices terminés + cours étudiés) visées par jour. */
export const DAILY_ACTIVITY_TARGET = 3;

/** Minutes de rappel actif visées par jour — la révision est un bonus, pas le cœur. */
export const DAILY_REVISION_TARGET_MIN = 5;

/** En deçà, une comparaison de scores entre deux périodes n'est que du bruit. */
export const MIN_ATTEMPTS_FOR_TREND = 3;

export type EngagementResult = IndexResult<EngagementFactorKey>;

/**
 * Le temps est-il mesuré sur TOUTE la période ?
 *
 * Les pouls d'activité n'existent que depuis leur mise en place. Sur une période
 * qui la précède, « 0 minute » ne signifie pas « n'a rien fait » : les facteurs
 * qui en dépendent doivent alors être retirés du calcul, pas comptés zéro.
 */
export function isTimeMeasured(report: DailyReport): boolean {
  const since = report.range.measuredSince;
  return since !== null && since !== "" && since <= report.range.from;
}

/** Écart de score entre la période et la précédente, `null` si incomparable. */
export function scoreTrend(report: DailyReport): number | null {
  const enough =
    report.totals.exercises >= MIN_ATTEMPTS_FOR_TREND &&
    report.previous.exercises >= MIN_ATTEMPTS_FOR_TREND;
  return enough ? report.totals.avgScore - report.previous.avgScore : null;
}

export function computeEngagement(report: DailyReport): EngagementResult {
  const days = Math.max(1, report.range.days);
  const { totals } = report;
  const measured = isTimeMeasured(report);

  const expectedActiveDays = Math.max(1, Math.round((days * EXPECTED_ACTIVE_DAYS_PER_WEEK) / 7));
  const activities = totals.exercises + totals.lessonsStudied;
  const trend = scoreTrend(report);

  return scoreIndex<EngagementFactorKey>([
    {
      key: "regularity",
      weight: 22,
      ratio: clamp01(totals.activeDays / expectedActiveDays),
      detail: { activeDays: totals.activeDays, expectedActiveDays, days },
    },
    {
      key: "learningTime",
      weight: 20,
      // Le temps d'APPRENTISSAGE, pas le temps d'application : la navigation
      // dans le catalogue ne compte pas comme du travail.
      ratio: measured ? clamp01(totals.learningMinutes / (days * DAILY_LEARNING_TARGET_MIN)) : null,
      detail: {
        learningMinutes: totals.learningMinutes,
        targetMinutes: days * DAILY_LEARNING_TARGET_MIN,
        appMinutes: totals.appMinutes,
      },
    },
    {
      key: "activityVolume",
      weight: 18,
      ratio: clamp01(activities / (days * DAILY_ACTIVITY_TARGET)),
      detail: {
        activities,
        exercises: totals.exercises,
        lessonsStudied: totals.lessonsStudied,
        target: days * DAILY_ACTIVITY_TARGET,
      },
    },
    {
      key: "lessonCompletion",
      weight: 12,
      // Cours réellement étudiés / cours ouverts : ouvrir dix chapitres sans en
      // lire un seul est un signal, et c'en est un mauvais.
      ratio:
        totals.lessonsOpened > 0 ? clamp01(totals.lessonsStudied / totals.lessonsOpened) : null,
      detail: { lessonsStudied: totals.lessonsStudied, lessonsOpened: totals.lessonsOpened },
    },
    {
      key: "perseverance",
      weight: 13,
      // L'effort fourni avant d'abandonner : part des exercices commencés qui
      // sont allés jusqu'à la validation.
      ratio:
        totals.exerciseSessionsStarted > 0
          ? clamp01(totals.exerciseSessionsCompleted / totals.exerciseSessionsStarted)
          : null,
      detail: {
        started: totals.exerciseSessionsStarted,
        completed: totals.exerciseSessionsCompleted,
      },
    },
    {
      key: "progress",
      weight: 10,
      // −10 points de moyenne → 0 ; stable → 0,5 ; +10 → 1.
      ratio: trend === null ? null : ratioBetween(trend, -10, 10),
      detail: {
        trend: trend ?? 0,
        avgScore: totals.avgScore,
        previousAvgScore: report.previous.avgScore,
      },
    },
    {
      key: "revision",
      weight: 5,
      ratio: measured
        ? clamp01(totals.byActivity.recall / (days * DAILY_REVISION_TARGET_MIN))
        : null,
      detail: {
        revisionMinutes: totals.byActivity.recall,
        targetMinutes: days * DAILY_REVISION_TARGET_MIN,
      },
    },
  ]);
}
