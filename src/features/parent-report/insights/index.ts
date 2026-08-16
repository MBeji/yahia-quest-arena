// Le moteur d'analyse du suivi parental — fonctions PURES uniquement.
//
// Rien ici ne touche au réseau, au DOM ni à l'horloge : les faits arrivent du
// RPC `get_student_daily_report`, les règles produit (engagement, efficacité,
// alertes, lecture par matière) sont appliquées ici. C'est ce découpage qui
// rend l'ensemble testable ligne à ligne — et qui laissera brancher plus tard
// une couche d'insights IA sur les mêmes faits sans réécrire le SQL.

export {
  answerLabel,
  attemptDetailSchema,
  dailyReportSchema,
  parseAttemptDetail,
  parseDailyReport,
  type ActivityBreakdown,
  type ActivityTotals,
  type AttemptDetail,
  type AttemptQuestion,
  type ChapterSlice,
  type DailyReport,
  type DailySlice,
  type ExerciseRun,
  type LessonView,
  type SubjectSlice,
} from "./daily-report";

export {
  MAX_RANGE_DAYS,
  REPORT_TIMEZONE,
  clampRange,
  rangeLengthDays,
  resolvePeriod,
  shiftDays,
  todayInReportTz,
  type DateRange,
  type PeriodPresetKey,
} from "./periods";

export {
  BAND_THRESHOLDS,
  bandFor,
  clamp01,
  ratioBetween,
  scoreIndex,
  topContributors,
  topGaps,
  type IndexBand,
  type IndexResult,
  type ScoredFactor,
} from "./scoring";

export {
  computeEngagement,
  isTimeMeasured,
  scoreTrend,
  type EngagementFactorKey,
  type EngagementResult,
} from "./engagement";

export {
  computeEfficiency,
  paceRatio,
  revisionGain,
  type EfficiencyFactorKey,
  type EfficiencyResult,
} from "./efficiency";

export { analyzeSubjects, subjectLevel, type SubjectAnalysis } from "./subjects";

export { buildAlerts, type AlertKey, type AlertTone, type ParentAlert } from "./alerts";

export {
  deriveKpis,
  formatMinutes,
  formatSeconds,
  longestActiveStreak,
  pct,
  trailingActiveStreak,
  type DerivedKpis,
} from "./kpis";
