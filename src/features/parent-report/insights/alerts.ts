import type { DailyReport } from "./daily-report";
import { isTimeMeasured, scoreTrend, EXPECTED_ACTIVE_DAYS_PER_WEEK } from "./engagement";
import { analyzeSubjects } from "./subjects";

/**
 * Les alertes et recommandations — §9 du cahier des charges.
 *
 * Ce module ne rend AUCUN texte : il rend une clé, un ton, une gravité et des
 * paramètres. Le libellé est monté côté composant depuis le dictionnaire i18n,
 * en français, anglais ou arabe. C'est ce qui permet de tester les règles sans
 * tester des phrases, et de traduire sans toucher aux règles.
 *
 * Une alerte n'est utile que si elle est RARE. Les seuils sont donc posés haut :
 * mieux vaut ne rien dire que noyer un parent sous des avertissements
 * hebdomadaires qu'il apprendra à ignorer.
 */

export type AlertTone = "warning" | "positive";

export type AlertKey =
  | "noActivity"
  | "performanceDrop"
  | "timeWithoutProgress"
  | "timeLowYield"
  | "chapterStruggle"
  | "subjectNeglected"
  | "abandonedExercises"
  | "lowRegularity"
  | "revisionNeeded"
  | "improvement"
  | "goalReached"
  | "strongSubject";

export type ParentAlert = {
  key: AlertKey;
  tone: AlertTone;
  /** Plus grand = plus prioritaire dans la liste rendue. */
  severity: number;
  /** Valeurs à injecter dans le libellé i18n (`{name}`, `{pct}`…). */
  params: Record<string, string | number>;
  /** Cible d'action : le cours à ouvrir pour agir sur l'alerte. */
  chapterId?: string;
  subjectId?: string;
};

/** Minutes d'apprentissage à partir desquelles « il y passe du temps » est vrai. */
export const HIGH_TIME_MINUTES = 60;
/** Score moyen sous lequel ce temps n'a visiblement pas porté. */
export const LOW_YIELD_SCORE_PCT = 65;
/** Chute de moyenne (en points) qui mérite d'être signalée. */
export const SIGNIFICANT_DROP_PCT = 10;
/** Hausse de moyenne (en points) qui mérite d'être saluée. */
export const SIGNIFICANT_GAIN_PCT = 8;
/** En deçà de cette part d'exercices menés à terme, l'abandon est un motif. */
export const ABANDON_RATIO = 0.6;
export const MIN_SESSIONS_FOR_ABANDON = 4;
/** Part des jours attendus en deçà de laquelle la régularité décroche. */
export const LOW_REGULARITY_RATIO = 0.4;
/** Nombre maximal d'alertes rendues — au-delà, plus personne ne les lit. */
export const MAX_ALERTS = 6;

export type BuildAlertsOptions = {
  /** Objectif famille de la semaine, quand le parent en a posé un. */
  weeklyGoal?: { target: number; done: number } | null;
};

export function buildAlerts(report: DailyReport, options: BuildAlertsOptions = {}): ParentAlert[] {
  const alerts: ParentAlert[] = [];
  const { totals } = report;
  const days = Math.max(1, report.range.days);
  const measured = isTimeMeasured(report);
  const trend = scoreTrend(report);
  const analysis = analyzeSubjects(report);

  const nothingHappened =
    totals.exercises === 0 && totals.lessonsOpened === 0 && totals.appMinutes === 0;

  if (nothingHappened) {
    alerts.push({ key: "noActivity", tone: "warning", severity: 100, params: { days } });
  }

  if (trend !== null && trend <= -SIGNIFICANT_DROP_PCT) {
    alerts.push({
      key: "performanceDrop",
      tone: "warning",
      severity: 90,
      params: {
        drop: Math.abs(trend),
        avgScore: totals.avgScore,
        previousAvgScore: report.previous.avgScore,
      },
    });
  }

  // « Beaucoup de temps, peu de progrès » — le signal le plus demandé, et celui
  // qui justifie à lui seul de mesurer le temps. On le rend ACTIONNABLE en le
  // rattachant à la matière la plus travaillée et à son chapitre le plus faible :
  // « les maths, 2 h 15 cette semaine, mais les fractions restent à 58 % ».
  const heavyTimeNoYield =
    measured &&
    totals.learningMinutes >= HIGH_TIME_MINUTES &&
    totals.avgScore < LOW_YIELD_SCORE_PCT &&
    (trend === null || trend <= 0);

  if (heavyTimeNoYield && !nothingHappened) {
    const topSubject = [...report.subjects].sort((a, b) => b.minutes - a.minutes)[0];
    const weakChapter = topSubject
      ? analysis.chaptersToReview.find((c) => c.subjectId === topSubject.subjectId)
      : undefined;

    if (topSubject && weakChapter) {
      alerts.push({
        key: "timeWithoutProgress",
        tone: "warning",
        severity: 85,
        params: {
          subjectName: topSubject.name,
          minutes: topSubject.minutes,
          chapterTitle: weakChapter.title,
          chapterScore: weakChapter.avgScore,
        },
        chapterId: weakChapter.chapterId,
        subjectId: topSubject.subjectId,
      });
    } else {
      alerts.push({
        key: "timeLowYield",
        tone: "warning",
        severity: 84,
        params: { minutes: totals.learningMinutes, avgScore: totals.avgScore },
      });
    }
  }

  // Les chapitres en difficulté répétée — hors celui déjà cité ci-dessus.
  const citedChapter = alerts.find((a) => a.key === "timeWithoutProgress")?.chapterId;
  for (const chapter of analysis.chaptersToReview
    .filter((c) => c.chapterId !== citedChapter)
    .slice(0, 2)) {
    alerts.push({
      key: "chapterStruggle",
      tone: "warning",
      severity: 80,
      params: {
        chapterTitle: chapter.title,
        subjectName: chapter.subjectName,
        avgScore: chapter.avgScore,
        exercises: chapter.exercises,
      },
      chapterId: chapter.chapterId,
      subjectId: chapter.subjectId,
    });
  }

  for (const subject of analysis.neglected.slice(0, 2)) {
    alerts.push({
      key: "subjectNeglected",
      tone: "warning",
      severity: 70,
      params: { subjectName: subject.name, previousExercises: subject.previousExercises },
      subjectId: subject.subjectId,
    });
  }

  if (
    totals.exerciseSessionsStarted >= MIN_SESSIONS_FOR_ABANDON &&
    totals.exerciseSessionsCompleted / totals.exerciseSessionsStarted < ABANDON_RATIO
  ) {
    const abandoned = totals.exerciseSessionsStarted - totals.exerciseSessionsCompleted;
    alerts.push({
      key: "abandonedExercises",
      tone: "warning",
      severity: 65,
      params: {
        started: totals.exerciseSessionsStarted,
        abandoned,
        pct: Math.round((abandoned / totals.exerciseSessionsStarted) * 100),
      },
    });
  }

  // La régularité ne se juge pas sur une journée : au moins une semaine.
  const expectedActiveDays = Math.max(1, Math.round((days * EXPECTED_ACTIVE_DAYS_PER_WEEK) / 7));
  if (
    days >= 7 &&
    !nothingHappened &&
    totals.activeDays / expectedActiveDays < LOW_REGULARITY_RATIO
  ) {
    alerts.push({
      key: "lowRegularity",
      tone: "warning",
      severity: 60,
      params: { activeDays: totals.activeDays, days, expectedActiveDays },
    });
  }

  // Des chapitres faibles ET aucune minute de rappel actif : la révision existe
  // dans l'application, elle n'est simplement pas utilisée.
  const weakest = analysis.chaptersToReview[0];
  if (measured && weakest && totals.byActivity.recall === 0) {
    alerts.push({
      key: "revisionNeeded",
      tone: "warning",
      severity: 55,
      params: { chapterTitle: weakest.title, avgScore: weakest.avgScore },
      chapterId: weakest.chapterId,
      subjectId: weakest.subjectId,
    });
  }

  if (trend !== null && trend >= SIGNIFICANT_GAIN_PCT) {
    alerts.push({
      key: "improvement",
      tone: "positive",
      severity: 45,
      params: { gain: trend, avgScore: totals.avgScore },
    });
  }

  const goal = options.weeklyGoal;
  if (goal && goal.target > 0 && goal.done >= goal.target) {
    alerts.push({
      key: "goalReached",
      tone: "positive",
      severity: 40,
      params: { target: goal.target, done: goal.done },
    });
  }

  const best = analysis.strong[0];
  if (best) {
    alerts.push({
      key: "strongSubject",
      tone: "positive",
      severity: 30,
      params: { subjectName: best.name, avgScore: best.avgScore },
      subjectId: best.subjectId,
    });
  }

  // Les avertissements d'abord — un parent qui ne lit qu'une ligne doit lire
  // celle qui appelle une action.
  return alerts
    .sort((a, b) => {
      if (a.tone !== b.tone) return a.tone === "warning" ? -1 : 1;
      return b.severity - a.severity;
    })
    .slice(0, MAX_ALERTS);
}
