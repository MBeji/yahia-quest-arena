import { useMemo, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import {
  Activity,
  BarChart3,
  BrainCircuit,
  CalendarDays,
  CheckCircle2,
  Clock,
  Gauge,
  HeartPulse,
  Info,
  XCircle,
} from "lucide-react";
import { useT } from "@/lib/i18n";
import { LoadingState } from "@/components/ui/loading-state";
import { getStudentDailyReport } from "../parent-report.server";
import {
  buildAlerts,
  computeEfficiency,
  computeEngagement,
  deriveKpis,
  formatMinutes,
  resolvePeriod,
  shiftDays,
  todayInReportTz,
  type DailyReport,
  type DateRange,
  type PeriodPresetKey,
} from "../insights";
import { AttemptDetailDialog } from "./attempt-detail-dialog";
import { ExercisesSection, LessonsSection } from "./daily-activity";
import { AlertsSection, IndexCard, SubjectsSection } from "./daily-insights";
import { BandPill, BigStat, DeltaChip, EmptyRow, Meter, SectionCard } from "./daily-primitives";

/**
 * Le tableau de bord « jour par jour » du suivi parental.
 *
 * L'ordre des sections suit celui du cahier des charges (§10) parce que c'est
 * l'ordre dans lequel un parent se pose ses questions : d'abord ce qui s'est
 * passé aujourd'hui, ensuite ce qui a été fait, puis ce que ça vaut, puis où ça
 * va, et seulement à la fin ce qu'il faudrait faire.
 *
 * Toute la logique de jugement vit dans `../insights` (fonctions pures, testées).
 * Ce composant orchestre : il choisit une période, charge les faits, et rend.
 */

const PRESETS: PeriodPresetKey[] = [
  "today",
  "yesterday",
  "last7",
  "thisWeek",
  "last30",
  "thisMonth",
  "custom",
];

export function DailyDashboard({
  studentId,
  weeklyGoal = null,
}: {
  studentId: string;
  /** Objectif famille de la semaine, quand le parent en a posé un (§5). */
  weeklyGoal?: { target: number; done: number } | null;
}) {
  const t = useT();
  const fetchReport = useServerFn(getStudentDailyReport);

  const today = useMemo(() => todayInReportTz(), []);
  const [preset, setPreset] = useState<PeriodPresetKey>("today");
  const [custom, setCustom] = useState<DateRange>({ from: shiftDays(today, -13), to: today });
  const [openAttempt, setOpenAttempt] = useState<string | null>(null);

  const range = useMemo(() => resolvePeriod(preset, { today, custom }), [preset, today, custom]);

  const { data: report, isLoading } = useQuery({
    queryKey: ["parent-daily-report", studentId, range.from, range.to],
    queryFn: () => fetchReport({ data: { studentId, from: range.from, to: range.to } }),
  });

  return (
    <div className="space-y-4">
      <PeriodPicker
        preset={preset}
        custom={custom}
        today={today}
        onPreset={setPreset}
        onCustom={(next) => {
          setCustom(next);
          setPreset("custom");
        }}
      />

      {isLoading || !report ? (
        <LoadingState label={t.common.loading} className="py-16" />
      ) : (
        <DailyDashboardBody
          report={report}
          weeklyGoal={weeklyGoal}
          onOpenAttempt={setOpenAttempt}
        />
      )}

      <AttemptDetailDialog
        studentId={studentId}
        attemptId={openAttempt}
        onClose={() => setOpenAttempt(null)}
      />
    </div>
  );
}

function DailyDashboardBody({
  report,
  weeklyGoal,
  onOpenAttempt,
}: {
  report: DailyReport;
  weeklyGoal: { target: number; done: number } | null;
  onOpenAttempt: (attemptId: string) => void;
}) {
  const t = useT();
  const engagement = useMemo(() => computeEngagement(report), [report]);
  const efficiency = useMemo(() => computeEfficiency(report), [report]);
  const kpis = useMemo(() => deriveKpis(report), [report]);
  const alerts = useMemo(() => buildAlerts(report, { weeklyGoal }), [report, weeklyGoal]);

  // Le temps n'est mesuré que depuis la mise en place des pouls d'activité :
  // sur une période antérieure, « 0 minute » ne veut pas dire « rien fait ».
  // On le DIT, au lieu d'afficher un zéro que le parent lirait de travers.
  const partiallyMeasured =
    report.range.measuredSince !== null && report.range.measuredSince > report.range.from;

  return (
    <>
      <FourQuestions report={report} engagement={engagement} efficiency={efficiency} kpis={kpis} />

      {partiallyMeasured && (
        <p className="flex items-start gap-2 rounded-lg border border-border/50 bg-surface-2 p-3 text-xs text-muted-foreground">
          <Info className="mt-0.5 h-4 w-4 shrink-0 text-gold" />
          {t.parentDaily.measuredSinceNotice.replace("{date}", report.range.measuredSince ?? "")}
        </p>
      )}

      <DaySummary report={report} />
      <TimeBreakdown report={report} />
      <LessonsSection report={report} />
      <ExercisesSection report={report} onOpenAttempt={onOpenAttempt} />
      <Performance report={report} kpis={kpis} />
      <Progression report={report} kpis={kpis} />

      <div className="grid gap-4 lg:grid-cols-2">
        <IndexCard
          title={t.parentDaily.engagementTitle}
          subtitle={t.parentDaily.engagementSubtitle}
          icon={<HeartPulse className="h-5 w-5 text-flame" />}
          result={engagement}
        />
        <IndexCard
          title={t.parentDaily.efficiencyTitle}
          subtitle={t.parentDaily.efficiencySubtitle}
          icon={<BrainCircuit className="h-5 w-5 text-primary" />}
          result={efficiency}
        />
      </div>

      <SubjectsSection report={report} />
      <AlertsSection alerts={alerts} />
    </>
  );
}

/**
 * §11 : les quatre questions auxquelles un parent veut une réponse, en haut de
 * page et en un mot chacune. Tout le reste du tableau de bord n'est que la
 * justification de ces quatre cases.
 */
function FourQuestions({
  report,
  engagement,
  efficiency,
  kpis,
}: {
  report: DailyReport;
  engagement: ReturnType<typeof computeEngagement>;
  efficiency: ReturnType<typeof computeEfficiency>;
  kpis: ReturnType<typeof deriveKpis>;
}) {
  const t = useT();
  const works = report.totals.exercises + report.totals.lessonsOpened > 0;

  return (
    <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
      <QuestionCard
        question={t.parentDaily.q1Works}
        answer={
          works
            ? t.parentDaily.q1Yes
                .replace("{exercises}", String(report.totals.exercises))
                .replace("{lessons}", String(report.totals.lessonsOpened))
            : t.parentDaily.q1No
        }
        good={works}
      />
      <QuestionCard
        question={t.parentDaily.q2Serious}
        answer={engagement.insufficientData ? t.parentDaily.unknown : ""}
        badge={engagement.insufficientData ? undefined : <BandPill band={engagement.band} />}
        good={!engagement.insufficientData && engagement.score >= 60}
      />
      <QuestionCard
        question={t.parentDaily.q3Progress}
        answer={
          kpis.scoreDelta === null
            ? t.parentDaily.noComparison
            : t.parentDaily.q3Answer
                .replace("{delta}", `${kpis.scoreDelta > 0 ? "+" : ""}${kpis.scoreDelta}`)
                .replace("{score}", String(report.totals.avgScore))
        }
        good={kpis.scoreDelta !== null && kpis.scoreDelta >= 0}
      />
      <QuestionCard
        question={t.parentDaily.q4Efficient}
        answer={efficiency.insufficientData ? t.parentDaily.unknown : ""}
        badge={efficiency.insufficientData ? undefined : <BandPill band={efficiency.band} />}
        good={!efficiency.insufficientData && efficiency.score >= 60}
      />
    </div>
  );
}

function QuestionCard({
  question,
  answer,
  badge,
  good,
}: {
  question: string;
  answer: string;
  badge?: React.ReactNode;
  good: boolean;
}) {
  return (
    <div className="rounded-xl border border-border/50 bg-surface-2 p-3">
      <div className="flex items-start gap-2">
        {good ? (
          <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-success" />
        ) : (
          <XCircle className="mt-0.5 h-4 w-4 shrink-0 text-muted-foreground" />
        )}
        <div className="min-w-0">
          <div className="text-xs text-muted-foreground">{question}</div>
          <div className="mt-1 text-sm font-semibold text-foreground">{badge ?? answer}</div>
        </div>
      </div>
    </div>
  );
}

/** §1 : le résumé de la journée (ou de la période choisie). */
function DaySummary({ report }: { report: DailyReport }) {
  const t = useT();
  const { totals } = report;
  const singleDay = report.range.days === 1;
  const day = singleDay ? report.days[0] : undefined;

  return (
    <SectionCard
      title={singleDay ? t.parentDaily.summaryTitleDay : t.parentDaily.summaryTitlePeriod}
      subtitle={`${report.range.from} → ${report.range.to}`}
      icon={<CalendarDays className="h-5 w-5 text-gold" />}
    >
      <div className="grid grid-cols-2 gap-2 lg:grid-cols-4">
        <BigStat
          label={t.parentDaily.appTime}
          value={formatMinutes(totals.appMinutes)}
          hint={t.parentDaily.appTimeHint}
        />
        <BigStat
          label={t.parentDaily.learningTime}
          value={formatMinutes(totals.learningMinutes)}
          hint={t.parentDaily.learningTimeHint}
          tone="primary"
        />
        <BigStat
          label={t.parentDaily.activities}
          value={String(totals.exercises + totals.lessonsStudied)}
        />
        <BigStat
          label={t.parentReport.avgScore}
          value={totals.exercises > 0 ? `${totals.avgScore}%` : "—"}
          tone="gold"
        />
      </div>

      <div className="mt-3 grid grid-cols-2 gap-2 text-xs text-muted-foreground lg:grid-cols-4">
        <Fact label={t.parentDaily.firstActivity} value={day?.firstAt ?? "—"} hidden={!singleDay} />
        <Fact label={t.parentDaily.lastActivity} value={day?.lastAt ?? "—"} hidden={!singleDay} />
        <Fact label={t.parentDaily.sessions} value={String(totals.sessions)} />
        <Fact
          label={t.parentDaily.activeDays}
          value={`${totals.activeDays}/${report.range.days}`}
          hidden={singleDay}
        />
      </div>
    </SectionCard>
  );
}

function Fact({ label, value, hidden }: { label: string; value: string; hidden?: boolean }) {
  if (hidden) return null;
  return (
    <div className="rounded-lg bg-surface-3 px-3 py-2">
      <div className="text-2xs uppercase tracking-wider">{label}</div>
      <div className="mt-0.5 font-semibold tabular-nums text-foreground">{value}</div>
    </div>
  );
}

/** §1 : le temps consacré à chaque type d'activité. */
function TimeBreakdown({ report }: { report: DailyReport }) {
  const t = useT();
  const b = report.totals.byActivity;
  const rows = [
    { key: "lesson", label: t.parentDaily.typeLesson, minutes: b.lesson, color: "bg-success" },
    {
      key: "exercise",
      label: t.parentDaily.typeExercise,
      minutes: b.exercise,
      color: "bg-primary",
    },
    { key: "quiz", label: t.parentDaily.typeQuiz, minutes: b.quiz, color: "bg-gold" },
    { key: "recall", label: t.parentDaily.typeRecall, minutes: b.recall, color: "bg-flame" },
    // `champagne` est un jeton de TEXTE d'emphase (teal foncé en clair,
    // quasi-blanc en sombre) : il ne se comporte pas comme un aplat. On reste
    // dans la palette de remplissage avec une déclinaison du primaire.
    { key: "arena", label: t.parentDaily.typeArena, minutes: b.arena, color: "bg-primary/60" },
    {
      key: "browse",
      label: t.parentDaily.typeBrowse,
      minutes: b.browse,
      color: "bg-muted-foreground",
    },
  ];
  const max = Math.max(...rows.map((r) => r.minutes), 1);
  const hasAny = rows.some((r) => r.minutes > 0);

  return (
    <SectionCard
      title={t.parentDaily.breakdownTitle}
      subtitle={t.parentDaily.breakdownSubtitle}
      icon={<Clock className="h-5 w-5 text-primary" />}
    >
      {!hasAny ? (
        <EmptyRow label={t.parentDaily.breakdownEmpty} />
      ) : (
        <ul className="space-y-2">
          {rows.map((row) => (
            <li key={row.key} className="flex items-center gap-2 sm:gap-3">
              <span className="w-20 shrink-0 truncate text-xs text-muted-foreground sm:w-28">
                {row.label}
              </span>
              <span className="min-w-0 flex-1">
                <Meter value={row.minutes} max={max} className={row.color} label={row.label} />
              </span>
              <span className="w-14 shrink-0 text-end text-xs tabular-nums text-muted-foreground">
                {formatMinutes(row.minutes, "0")}
              </span>
            </li>
          ))}
        </ul>
      )}
    </SectionCard>
  );
}

/** §4 : les KPI de performance pédagogique. */
function Performance({
  report,
  kpis,
}: {
  report: DailyReport;
  kpis: ReturnType<typeof deriveKpis>;
}) {
  const t = useT();
  const { totals } = report;

  return (
    <SectionCard
      title={t.parentDaily.performanceTitle}
      subtitle={t.parentDaily.performanceSubtitle}
      icon={<Gauge className="h-5 w-5 text-gold" />}
    >
      <div className="grid grid-cols-2 gap-2 lg:grid-cols-4">
        <BigStat
          label={t.parentDaily.kpiAccuracy}
          value={totals.questions > 0 ? `${kpis.accuracyPct}%` : "—"}
          hint={`${totals.correct}/${totals.questions}`}
        />
        <BigStat
          label={t.parentDaily.kpiSuccess}
          value={totals.exercises > 0 ? `${kpis.exerciseSuccessPct}%` : "—"}
          hint={`${totals.exercisesPassed} / ${totals.exercisesFailed}`}
        />
        <BigStat
          label={t.parentDaily.kpiTriesToPass}
          value={totals.avgTriesToPass > 0 ? String(totals.avgTriesToPass) : "—"}
        />
        <BigStat
          label={t.parentDaily.kpiPerQuestion}
          value={totals.avgSecondsPerQuestion > 0 ? `${totals.avgSecondsPerQuestion} s` : "—"}
          hint={
            totals.avgSecondsPerExercise > 0
              ? t.parentDaily.kpiPerExercise.replace(
                  "{value}",
                  formatMinutes(totals.avgSecondsPerExercise / 60, "0"),
                )
              : undefined
          }
        />
        <BigStat
          label={t.parentDaily.kpiLessonCompletion}
          value={totals.lessonsOpened > 0 ? `${kpis.lessonCompletionPct}%` : "—"}
          hint={`${totals.lessonsStudied}/${totals.lessonsOpened}`}
        />
        <BigStat
          label={t.parentDaily.kpiExerciseCompletion}
          value={totals.exerciseSessionsStarted > 0 ? `${kpis.exerciseCompletionPct}%` : "—"}
          hint={`${totals.exerciseSessionsCompleted}/${totals.exerciseSessionsStarted}`}
        />
        <BigStat
          label={t.parentDaily.kpiRegularity}
          value={`${kpis.regularityPct}%`}
          hint={`${totals.activeDays}/${report.range.days}`}
        />
        <BigStat
          label={t.parentDaily.kpiStreak}
          value={`${kpis.consecutiveActiveDays} ${t.parentDaily.unitDays}`}
        />
      </div>
    </SectionCard>
  );
}

/** §8 : la courbe du temps, des exercices et du score sur la période. */
function Progression({
  report,
  kpis,
}: {
  report: DailyReport;
  kpis: ReturnType<typeof deriveKpis>;
}) {
  const t = useT();
  // Sur une période antérieure à la mesure du temps, les minutes valent zéro
  // partout : on bascule alors sur le nombre d'activités, qui, lui, existe.
  const useMinutes = report.totals.appMinutes > 0;
  const max = Math.max(
    ...report.days.map((d) => (useMinutes ? d.learningMinutes : d.activities)),
    1,
  );

  return (
    <SectionCard
      title={t.parentDaily.progressionTitle}
      subtitle={useMinutes ? t.parentDaily.progressionByTime : t.parentDaily.progressionByActivity}
      icon={<BarChart3 className="h-5 w-5 text-gold" />}
    >
      {/* `h-full` sur la colonne : sans hauteur définie, le pourcentage de la
          barre ne résout pas et le graphe rend 0 px (le bug qui vidait le graphe
          « Activité 30 jours » du bilan). */}
      <div className="flex h-32 items-end gap-[2px] overflow-x-auto">
        {report.days.map((day) => {
          const value = useMinutes ? day.learningMinutes : day.activities;
          const height = (value / max) * 100;
          const passed = day.exercises > 0 && day.avgScore >= report.thresholds.passPct;
          return (
            <div
              key={day.date}
              className="flex h-full min-w-[6px] flex-1 items-end"
              title={t.parentDaily.dayTooltip
                .replace("{date}", day.date)
                .replace("{minutes}", formatMinutes(day.learningMinutes, "0"))
                .replace("{exercises}", String(day.exercises))
                .replace("{score}", day.exercises > 0 ? `${day.avgScore}%` : "—")}
            >
              <div
                className={`w-full rounded-t transition-colors ${
                  value === 0
                    ? "bg-muted/50"
                    : passed
                      ? "print-fill bg-success"
                      : day.exercises > 0
                        ? "print-fill bg-flame"
                        : "print-fill bg-gold"
                }`}
                style={{ height: `${Math.max(height, 4)}%` }}
              />
            </div>
          );
        })}
      </div>
      <div className="mt-2 flex justify-between text-xs text-muted-foreground">
        <span>{report.days[0]?.date}</span>
        <span>{report.days[report.days.length - 1]?.date}</span>
      </div>

      <div className="mt-4 grid grid-cols-3 gap-2">
        <CompareCell
          label={t.parentDaily.learningTime}
          value={formatMinutes(report.totals.learningMinutes, "0")}
          delta={kpis.learningMinutesDelta}
        />
        <CompareCell
          label={t.parentReport.exercisesLabel}
          value={String(report.totals.exercises)}
          delta={kpis.exercisesDelta}
        />
        <CompareCell
          label={t.parentReport.avgScore}
          value={report.totals.exercises > 0 ? `${report.totals.avgScore}%` : "—"}
          delta={kpis.scoreDelta}
          suffix="%"
        />
      </div>
      <p className="mt-2 text-2xs text-muted-foreground">{t.parentDaily.compareHint}</p>
    </SectionCard>
  );
}

function CompareCell({
  label,
  value,
  delta,
  suffix = "",
}: {
  label: string;
  value: string;
  delta: number | null;
  suffix?: string;
}) {
  return (
    <div className="rounded-lg border border-border/50 bg-surface-3 p-3 text-center">
      <div className="text-lg font-bold tabular-nums text-foreground">{value}</div>
      <div className="mt-0.5 text-xs text-muted-foreground">{label}</div>
      <div className="mt-1">
        <DeltaChip value={delta} suffix={suffix} />
      </div>
    </div>
  );
}

/** §8 : le sélecteur de période. */
function PeriodPicker({
  preset,
  custom,
  today,
  onPreset,
  onCustom,
}: {
  preset: PeriodPresetKey;
  custom: DateRange;
  today: string;
  onPreset: (preset: PeriodPresetKey) => void;
  onCustom: (range: DateRange) => void;
}) {
  const t = useT();
  const labels: Record<PeriodPresetKey, string> = {
    today: t.parentDaily.periodToday,
    yesterday: t.parentDaily.periodYesterday,
    last7: t.parentDaily.periodLast7,
    thisWeek: t.parentDaily.periodThisWeek,
    last30: t.parentDaily.periodLast30,
    thisMonth: t.parentDaily.periodThisMonth,
    custom: t.parentDaily.periodCustom,
  };

  return (
    <div className="rounded-xl border border-border/50 bg-surface-2 p-3 print:hidden">
      <div className="flex flex-wrap gap-1.5">
        {PRESETS.map((key) => (
          <button
            key={key}
            type="button"
            onClick={() => onPreset(key)}
            aria-pressed={preset === key}
            className={`rounded-lg px-3 py-1.5 text-sm font-medium transition [@media(pointer:coarse)]:min-h-11 ${
              preset === key
                ? "bg-[image:var(--gradient-gold)] text-primary-foreground"
                : "border border-border/60 bg-surface-3 text-muted-foreground hover:border-gold/60"
            }`}
          >
            {labels[key]}
          </button>
        ))}
      </div>

      {preset === "custom" && (
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <label className="flex items-center gap-2 text-xs text-muted-foreground">
            {t.parentDaily.periodFrom}
            <input
              type="date"
              value={custom.from}
              max={today}
              onChange={(e) => onCustom({ ...custom, from: e.target.value })}
              className="rounded-lg border border-border/60 bg-surface-3 px-2 py-1.5 text-sm text-foreground"
            />
          </label>
          <label className="flex items-center gap-2 text-xs text-muted-foreground">
            {t.parentDaily.periodTo}
            <input
              type="date"
              value={custom.to}
              max={today}
              onChange={(e) => onCustom({ ...custom, to: e.target.value })}
              className="rounded-lg border border-border/60 bg-surface-3 px-2 py-1.5 text-sm text-foreground"
            />
          </label>
          <span className="inline-flex items-center gap-1 text-2xs text-muted-foreground">
            <Activity className="h-3 w-3" />
            {t.parentDaily.periodMaxHint}
          </span>
        </div>
      )}
    </div>
  );
}
