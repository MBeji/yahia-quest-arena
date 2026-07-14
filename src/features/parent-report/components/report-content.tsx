import { motion } from "motion/react";
import { Link } from "@tanstack/react-router";
import {
  ChevronRight,
  Clock,
  Target,
  TrendingUp,
  TrendingDown,
  Minus,
  Flame,
  Trophy,
  BookOpen,
  Calendar,
  AlertTriangle,
  CheckCircle,
  Star,
  Lightbulb,
  ShieldCheck,
} from "lucide-react";
import { useI18n, useT } from "@/lib/i18n";
import { useEntrance } from "@/shared/lib/motion";
import { buildWeeklyAdvice, type ReportData } from "../report-share";
export type { ReportData } from "../report-share";

/**
 * Le corps du « Bilan famille » : en-tête élève, verdict d'assiduité, conseil de
 * la semaine, métriques clés, comparaison hebdo, forces/faiblesses par chapitre,
 * activité 30 j et détail par matière. Rendu par la route /parent-report (qui
 * reste mince) ; les styles `print-fill`/`family-report` pilotent l'impression.
 */

export function ReportContent({ report }: { report: ReportData }) {
  const { t, locale } = useI18n();
  const { student, summary, subjectStats, dailyActivity, weekComparison, chapterInsights } = report;
  const riseIn = useEntrance("rise");

  const advice = buildWeeklyAdvice(report, t);
  // The advice is built around the weakest chapter — make it actionable (D-9).
  const adviceChapter = chapterInsights.weaknesses[0];

  return (
    <div className="family-report space-y-6">
      {/* En-tête imprimé uniquement : titre du bulletin + date d'édition. */}
      <div className="hidden print:block">
        <h1 className="text-2xl font-bold">{t.parentReport.printTitle}</h1>
        <p className="text-sm">
          {t.parentReport.printGenerated.replace(
            "{date}",
            new Date().toLocaleDateString(locale, {
              day: "numeric",
              month: "long",
              year: "numeric",
            }),
          )}
        </p>
      </div>
      {/* Student Header */}
      <motion.div {...riseIn} className="bg-black/50 border border-gold/40 rounded-xl p-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h2 className="text-xl font-bold text-foreground">{student.displayName}</h2>
            <p className="text-muted-foreground text-sm mt-1">
              {t.parentReport.classLabel} {student.heroClass ?? t.parentReport.classNone} ·{" "}
              {t.parentReport.memberSince} {new Date(student.createdAt).toLocaleDateString(locale)}
            </p>
          </div>
          <div className="flex items-center gap-4">
            <StatBadge
              icon={<Trophy className="w-4 h-4" />}
              label={t.dashboard.levelLabel}
              value={student.level}
            />
            <StatBadge
              icon={<Flame className="w-4 h-4" />}
              label={t.quest.streakLabel}
              value={`${student.currentStreak}j`}
            />
          </div>
        </div>
      </motion.div>

      {/* Verdict card */}
      <VerdictCard score={summary.seriousnessScore} verdict={summary.verdict} />

      {/* Le conseil de la semaine — la ligne d'action concrète pour le parent. */}
      <motion.div
        {...riseIn}
        className="flex items-start gap-3 rounded-xl border border-gold/40 bg-gold/5 p-4"
      >
        <Lightbulb className="mt-0.5 h-5 w-5 shrink-0 text-gold" />
        <div>
          <div className="font-semibold text-champagne">{t.parentReport.adviceTitle}</div>
          <p className="mt-1 text-sm text-muted-foreground">{advice}</p>
          {adviceChapter?.chapterId && (
            <Link
              to="/chapitre/$chapterId"
              params={{ chapterId: adviceChapter.chapterId }}
              className="mt-2 inline-flex items-center gap-1 text-sm font-semibold text-gold hover:underline print:hidden"
            >
              {t.parentReport.adviceReviewCta} <ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
            </Link>
          )}
        </div>
      </motion.div>

      {/* Key metrics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <MetricCard
          icon={<Clock className="w-5 h-5 text-primary" />}
          label={t.parentReport.timeTotal}
          value={formatTime(summary.totalTimeMinutes)}
        />
        <MetricCard
          icon={<BookOpen className="w-5 h-5 text-success" />}
          label={t.parentReport.exercisesLabel}
          value={String(summary.totalExercises)}
        />
        <MetricCard
          icon={<Target className="w-5 h-5 text-gold" />}
          label={t.parentReport.avgScore}
          value={`${summary.avgScore}%`}
        />
        <MetricCard
          icon={<Calendar className="w-5 h-5 text-flame" />}
          label={t.parentReport.activeDays}
          value={`${summary.daysActiveThisWeek}/7`}
        />
      </div>

      {/* Cette semaine vs la précédente */}
      <div className="bg-black/50 border border-border/50 rounded-xl p-4">
        <h3 className="text-foreground font-semibold mb-4 flex items-center gap-2">
          <Calendar className="w-5 h-5 text-gold" />
          {t.parentReport.weekCompareTitle}
        </h3>
        <div className="grid grid-cols-3 gap-2 sm:gap-4">
          <WeekCompareCell
            label={t.parentReport.exercisesLabel}
            current={weekComparison.thisWeek.exercises}
            previous={weekComparison.lastWeek.exercises}
          />
          <WeekCompareCell
            label={t.parentReport.weekMinutes}
            current={weekComparison.thisWeek.minutes}
            previous={weekComparison.lastWeek.minutes}
          />
          <WeekCompareCell
            label={t.parentReport.avgScore}
            current={weekComparison.thisWeek.avgScore}
            previous={weekComparison.lastWeek.avgScore}
            suffix="%"
          />
        </div>
      </div>

      {/* Points forts & à renforcer (chapitres, 30 j) */}
      <div className="bg-black/50 border border-border/50 rounded-xl p-4">
        <h3 className="text-foreground font-semibold flex items-center gap-2">
          <Target className="w-5 h-5 text-gold" />
          {t.parentReport.insightsTitle}
        </h3>
        <p className="mt-1 text-xs text-muted-foreground">{t.parentReport.insightsSubtitle}</p>
        <div className="mt-4 grid gap-4 md:grid-cols-2">
          <InsightList
            title={t.parentReport.strengthsTitle}
            icon={<ShieldCheck className="h-4 w-4 text-success" />}
            items={chapterInsights.strengths}
            emptyLabel={t.parentReport.strengthsEmpty}
            tone="strength"
          />
          <InsightList
            title={t.parentReport.weaknessesTitle}
            icon={<AlertTriangle className="h-4 w-4 text-flame" />}
            items={chapterInsights.weaknesses}
            emptyLabel={t.parentReport.weaknessesEmpty}
            tone="weakness"
          />
        </div>
      </div>

      {/* Score trend */}
      <div className="bg-black/50 border border-border/50 rounded-xl p-4 flex items-center gap-3">
        {summary.scoreTrend > 0 ? (
          <TrendingUp className="w-5 h-5 text-success" />
        ) : summary.scoreTrend < 0 ? (
          <TrendingDown className="w-5 h-5 text-destructive" />
        ) : (
          <Minus className="w-5 h-5 text-muted-foreground" />
        )}
        <span className="text-muted-foreground">
          {t.parentReport.trendPrefix}{" "}
          <span
            className={
              summary.scoreTrend > 0
                ? "text-success"
                : summary.scoreTrend < 0
                  ? "text-destructive"
                  : "text-muted-foreground"
            }
          >
            {summary.scoreTrend > 0 ? "+" : ""}
            {summary.scoreTrend}%
          </span>{" "}
          {t.parentReport.trendSuffix}
        </span>
      </div>

      {/* Activity chart (simple bar chart) */}
      <div className="bg-black/50 border border-border/50 rounded-xl p-4">
        <h3 className="text-foreground font-semibold mb-4 flex items-center gap-2">
          <Calendar className="w-5 h-5 text-gold" />
          {t.parentReport.activityTitle}
        </h3>
        <div className="flex items-end gap-[2px] h-32 overflow-x-auto">
          {dailyActivity.map((day) => {
            const maxExercises = Math.max(...dailyActivity.map((d) => d.exercises), 1);
            const height = (day.exercises / maxExercises) * 100;
            return (
              <div
                key={day.date}
                className="flex-1 min-w-[6px] group relative"
                title={`${day.date}: ${day.exercises} exercice(s), ${day.minutes} min, ${day.avgScore}%`}
              >
                <div
                  className={`w-full rounded-t transition-colors ${
                    day.exercises > 0 ? "print-fill bg-gold hover:opacity-80" : "bg-muted/50"
                  }`}
                  style={{ height: `${Math.max(height, 4)}%` }}
                />
              </div>
            );
          })}
        </div>
        <div className="flex justify-between mt-2 text-xs text-muted-foreground">
          <span>{dailyActivity[0]?.date}</span>
          <span>{t.parentReport.today}</span>
        </div>
      </div>

      {/* Subject breakdown */}
      {subjectStats.length > 0 && (
        <div className="bg-black/50 border border-border/50 rounded-xl p-4">
          <h3 className="text-foreground font-semibold mb-4 flex items-center gap-2">
            <BookOpen className="w-5 h-5 text-success" />
            {t.parentReport.perSubjectTitle}
          </h3>
          <div className="space-y-3">
            {subjectStats.map((s) => (
              <div key={s.subjectId} className="flex items-center gap-2 sm:gap-3">
                {/* Fixed columns shrink on phones so the progress bar keeps a usable
                    width down to 360px (multi-device audit — layout). */}
                <div className="w-16 truncate text-sm text-muted-foreground sm:w-28">{s.name}</div>
                <div className="h-4 min-w-0 flex-1 overflow-hidden rounded-full bg-muted/50">
                  <div
                    className="print-fill h-full rounded-full bg-[image:var(--gradient-gold)] transition-all"
                    style={{ width: `${s.avgScore}%` }}
                  />
                </div>
                <div className="w-10 text-end text-sm text-muted-foreground sm:w-12">
                  {s.avgScore}%
                </div>
                <div className="w-12 text-end text-xs text-muted-foreground sm:w-20">
                  {s.attempts} {t.parentReport.exSuffix}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Last active */}
      <div className="text-center text-sm text-muted-foreground py-4">
        {t.parentReport.lastActivity}{" "}
        {student.lastActiveDate
          ? new Date(student.lastActiveDate).toLocaleDateString(locale, {
              day: "numeric",
              month: "long",
              year: "numeric",
            })
          : t.parentReport.noActivity}
      </div>
    </div>
  );
}

function VerdictCard({ score, verdict }: { score: number; verdict: string }) {
  const t = useT();
  const scaleIn = useEntrance("scale");
  const config = {
    excellent: {
      label: t.parentReport.verdictExcellent,
      desc: t.parentReport.verdictExcellentDesc,
      color: "text-success",
      bg: "border-success/30 bg-success/10",
      icon: <Star className="w-6 h-6 text-success" />,
    },
    good: {
      label: t.parentReport.verdictGood,
      desc: t.parentReport.verdictGoodDesc,
      color: "text-primary",
      bg: "border-primary/30 bg-primary/10",
      icon: <CheckCircle className="w-6 h-6 text-primary" />,
    },
    average: {
      label: t.parentReport.verdictAverage,
      desc: t.parentReport.verdictAverageDesc,
      color: "text-gold",
      bg: "border-gold/30 bg-gold/10",
      icon: <AlertTriangle className="w-6 h-6 text-gold" />,
    },
    needs_improvement: {
      label: t.parentReport.verdictNeedsImprovement,
      desc: t.parentReport.verdictNeedsImprovementDesc,
      color: "text-flame",
      bg: "border-flame/30 bg-flame/10",
      icon: <AlertTriangle className="w-6 h-6 text-flame" />,
    },
    inactive: {
      label: t.parentReport.verdictInactive,
      desc: t.parentReport.verdictInactiveDesc,
      color: "text-destructive",
      bg: "border-destructive/30 bg-destructive/10",
      icon: <AlertTriangle className="w-6 h-6 text-destructive" />,
    },
  };

  const c = config[verdict as keyof typeof config] ?? config.average;

  return (
    <motion.div
      {...scaleIn}
      className={`${c.bg} border rounded-xl p-4 md:p-6 flex items-center gap-3 md:gap-4`}
    >
      <span className="shrink-0">{c.icon}</span>
      <div className="min-w-0 flex-1">
        <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
          <span className={`text-lg font-bold ${c.color}`}>{c.label}</span>
          <span className="text-sm text-muted-foreground">
            {t.parentReport.seriousness} {score}/100
          </span>
        </div>
        <p className="text-muted-foreground text-sm mt-1">{c.desc}</p>
      </div>
      {/* Circular gauge — smaller on phones to free horizontal room. */}
      <div className="relative h-12 w-12 shrink-0 md:h-16 md:w-16">
        <svg className="h-12 w-12 -rotate-90 md:h-16 md:w-16" viewBox="0 0 36 36">
          <circle cx="18" cy="18" r="15" fill="none" stroke="var(--muted)" strokeWidth="3" />
          <circle
            cx="18"
            cy="18"
            r="15"
            fill="none"
            stroke="currentColor"
            strokeWidth="3"
            strokeDasharray={`${score * 0.94} 100`}
            className={c.color}
          />
        </svg>
        <span
          className={`absolute inset-0 flex items-center justify-center text-sm font-bold ${c.color}`}
        >
          {score}
        </span>
      </div>
    </motion.div>
  );
}

function MetricCard({
  icon,
  label,
  value,
}: {
  icon: React.ReactNode;
  label: string;
  value: string;
}) {
  return (
    <div className="bg-black/50 border border-border/50 rounded-xl p-4 text-center">
      <div className="flex justify-center mb-2">{icon}</div>
      <div className="text-xl font-bold text-foreground">{value}</div>
      <div className="text-xs text-muted-foreground mt-1">{label}</div>
    </div>
  );
}

function StatBadge({
  icon,
  label,
  value,
}: {
  icon: React.ReactNode;
  label: string;
  value: string | number;
}) {
  return (
    <div className="flex items-center gap-2 bg-black/60 rounded-lg px-3 py-2 border border-gold/30">
      {icon}
      <div>
        <div className="text-xs text-muted-foreground">{label}</div>
        <div className="text-sm font-bold text-foreground">{value}</div>
      </div>
    </div>
  );
}

function WeekCompareCell({
  label,
  current,
  previous,
  suffix = "",
}: {
  label: string;
  current: number;
  previous: number;
  suffix?: string;
}) {
  const delta = current - previous;
  return (
    <div className="rounded-lg border border-border/50 bg-black/40 p-3 text-center">
      <div className="text-xl font-bold text-foreground">
        {current}
        {suffix}
      </div>
      <div className="mt-0.5 text-xs text-muted-foreground">{label}</div>
      <div
        className={`mt-1 inline-flex items-center gap-1 text-xs font-semibold ${
          delta > 0 ? "text-success" : delta < 0 ? "text-destructive" : "text-muted-foreground"
        }`}
      >
        {delta > 0 ? (
          <TrendingUp className="h-3.5 w-3.5" />
        ) : delta < 0 ? (
          <TrendingDown className="h-3.5 w-3.5" />
        ) : (
          <Minus className="h-3.5 w-3.5" />
        )}
        {delta > 0 ? "+" : ""}
        {delta}
        {suffix}
      </div>
    </div>
  );
}

type ChapterInsight = ReportData["chapterInsights"]["strengths"][number];

function InsightList({
  title,
  icon,
  items,
  emptyLabel,
  tone,
}: {
  title: string;
  icon: React.ReactNode;
  items: ChapterInsight[];
  emptyLabel: string;
  tone: "strength" | "weakness";
}) {
  const t = useT();
  return (
    <div
      className={`rounded-lg border p-3 ${
        tone === "strength" ? "border-success/30 bg-success/10" : "border-flame/30 bg-flame/10"
      }`}
    >
      <div className="flex items-center gap-2 font-semibold text-foreground">
        {icon}
        {title}
      </div>
      {items.length === 0 ? (
        <p className="mt-2 text-sm text-muted-foreground">{emptyLabel}</p>
      ) : (
        <ul className="mt-2 space-y-2">
          {items.map((c) => {
            // Actionable (D-9 — le cœur de l'offre parent) : chaque chapitre pointé
            // ouvre son cours/lecteur (`/chapitre/$id`), pour réviser sans chercher.
            const inner = (
              <>
                <div className="min-w-0">
                  <div className="truncate text-foreground">{c.chapterTitle}</div>
                  <div className="text-xs text-muted-foreground">
                    {c.subjectName} ·{" "}
                    {t.parentReport.insightAttempts.replace("{n}", String(c.attempts))}
                  </div>
                </div>
                <span className="flex shrink-0 items-center gap-1.5">
                  <span
                    className={`rounded-md px-2 py-1 text-xs font-bold ${
                      tone === "strength" ? "bg-success/20 text-success" : "bg-flame/20 text-flame"
                    }`}
                  >
                    {c.avgScore}%
                  </span>
                  {c.chapterId && (
                    <ChevronRight className="h-4 w-4 text-muted-foreground rtl:-scale-x-100 print:hidden" />
                  )}
                </span>
              </>
            );
            return (
              <li key={c.chapterId}>
                {c.chapterId ? (
                  <Link
                    to="/chapitre/$chapterId"
                    params={{ chapterId: c.chapterId }}
                    className="flex items-center justify-between gap-2 rounded-md text-sm transition hover:bg-white/5"
                  >
                    {inner}
                  </Link>
                ) : (
                  <div className="flex items-center justify-between gap-2 text-sm">{inner}</div>
                )}
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}

function formatTime(minutes: number): string {
  if (minutes < 60) return `${minutes} min`;
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return m > 0 ? `${h}h ${m}m` : `${h}h`;
}
