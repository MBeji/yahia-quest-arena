import type {
  ActivityTotals,
  DailyReport,
  DailySlice,
  ExerciseRun,
} from "../insights/daily-report";

/**
 * Fabriques de rapport quotidien pour les tests des indices.
 *
 * Volontairement explicites : chaque test part d'un élève « neutre » (rien
 * mesuré, rien fait) et ne déclare QUE les faits dont dépend l'assertion. Un
 * changement de pondération casse alors le test qui portait sur ce facteur, pas
 * les douze autres.
 */

export function makeTotals(overrides: Partial<ActivityTotals> = {}): ActivityTotals {
  return {
    appMinutes: 0,
    learningMinutes: 0,
    byActivity: { lesson: 0, exercise: 0, quiz: 0, recall: 0, arena: 0, browse: 0 },
    activeDays: 0,
    sessions: 0,
    exercises: 0,
    exercisesPassed: 0,
    exercisesFailed: 0,
    correct: 0,
    wrong: 0,
    questions: 0,
    avgScore: 0,
    avgSecondsPerExercise: 0,
    avgSecondsPerQuestion: 0,
    lessonsOpened: 0,
    lessonsStudied: 0,
    exerciseSessionsStarted: 0,
    exerciseSessionsCompleted: 0,
    avgTriesToPass: 0,
    ...overrides,
  };
}

export function makeDay(date: string, overrides: Partial<DailySlice> = {}): DailySlice {
  return {
    date,
    appMinutes: 0,
    learningMinutes: 0,
    byActivity: { lesson: 0, exercise: 0, quiz: 0, recall: 0, arena: 0, browse: 0 },
    firstAt: null,
    lastAt: null,
    sessions: 0,
    exercises: 0,
    lessonsRead: 0,
    activities: 0,
    avgScore: 0,
    correct: 0,
    questions: 0,
    ...overrides,
  };
}

export function makeRun(overrides: Partial<ExerciseRun> = {}): ExerciseRun {
  return {
    attemptId: "attempt-1",
    date: "2026-08-10",
    at: "18:00",
    exerciseId: "exercise-1",
    exerciseTitle: "Fractions — niveau 1",
    mode: "practice",
    variant: "classic",
    difficulty: 2,
    chapterId: "chapter-1",
    chapterTitle: "Les fractions",
    subjectId: "math-6",
    subjectName: "Mathématiques",
    gradeName: "6ème",
    durationSeconds: 300,
    scorePct: 70,
    correct: 7,
    wrong: 3,
    total: 10,
    attemptNo: 1,
    previousScorePct: null,
    ...overrides,
  };
}

export function makeReport(overrides: Partial<DailyReport> = {}): DailyReport {
  return {
    student: {
      displayName: "Yahia",
      level: 5,
      currentStreak: 2,
      longestStreak: 9,
      lastActiveDate: "2026-08-15",
    },
    range: {
      from: "2026-08-09",
      to: "2026-08-15",
      days: 7,
      timezone: "Africa/Tunis",
      // Par défaut le temps EST mesuré sur toute la période : les tests qui
      // veulent l'inverse le déclarent explicitement.
      measuredSince: "2026-01-01",
    },
    // Par défaut : aucun périmètre appliqué, et l'élève a bien une classe — les
    // tests qui veulent l'inverse le déclarent explicitement.
    scope: {
      applied: "all",
      label: null,
      gradeId: null,
      gradeName: null,
      hasClass: true,
      excludedMinutes: 0,
      excludedExercises: 0,
    },
    scopes: [],
    thresholds: { passPct: 60, studiedSeconds: 120, studiedPct: 60, sessionGapMinutes: 30 },
    days: [],
    lessons: [],
    exercises: [],
    subjects: [],
    chapters: [],
    totals: makeTotals(),
    previous: makeTotals(),
    ...overrides,
  };
}
