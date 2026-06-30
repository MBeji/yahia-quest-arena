import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import {
  Users,
  Clock,
  Target,
  TrendingUp,
  TrendingDown,
  Minus,
  Flame,
  Trophy,
  BookOpen,
  Calendar,
  Activity,
  AlertTriangle,
  CheckCircle,
  Star,
  Link as LinkIcon,
  ArrowLeft,
} from "lucide-react";
import { getLinkedStudents, getStudentReport, linkStudentByCode } from "@/features/parent-report";
import { useEffect, useMemo, useState } from "react";
import { toast } from "sonner";
import { useI18n, useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/parent-report")({
  head: () => ({ meta: [{ title: "Suivi parental · Na9ra Nal3ab" }] }),
  component: ParentReport,
});

function ParentReport() {
  const t = useT();
  const queryClient = useQueryClient();
  const getStudentsFn = useServerFn(getLinkedStudents);
  const getReportFn = useServerFn(getStudentReport);
  const linkByCodeFn = useServerFn(linkStudentByCode);
  const [selectedStudent, setSelectedStudent] = useState<string | null>(null);
  const [studentCode, setStudentCode] = useState("");
  const [relationLabel, setRelationLabel] = useState("parent");
  const [adminPage, setAdminPage] = useState(1);
  const ADMIN_PAGE_SIZE = 100;

  const { data: studentsData, isLoading: loadingStudents } = useQuery({
    queryKey: ["parent-students", adminPage],
    queryFn: () => getStudentsFn({ data: { page: adminPage, pageSize: ADMIN_PAGE_SIZE } }),
  });

  const { data: report, isLoading: loadingReport } = useQuery({
    queryKey: ["parent-report", selectedStudent],
    queryFn: () => getReportFn({ data: { studentId: selectedStudent! } }),
    enabled: !!selectedStudent,
  });

  const students = useMemo(() => studentsData?.students ?? [], [studentsData?.students]);
  const isAdmin = studentsData?.role === "admin";
  const pagination = studentsData?.pagination;

  const linkMutation = useMutation({
    mutationFn: () => linkByCodeFn({ data: { studentCode, relationLabel } }),
    onSuccess: (res) => {
      toast.success(
        t.parentReport.linkSuccess.replace(
          "{name}",
          res.student.displayName ?? t.parentReport.defaultStudentName,
        ),
      );
      setStudentCode("");
      queryClient.invalidateQueries({ queryKey: ["parent-students"] });
    },
    onError: (error) => {
      toast.error(error instanceof Error ? error.message : t.parentReport.linkFailed);
    },
  });

  // Auto-select first student
  useEffect(() => {
    if (!selectedStudent && students.length > 0) {
      setSelectedStudent(students[0].id);
    }
  }, [selectedStudent, students]);

  useEffect(() => {
    if (students.length === 0) return;

    const existsInPage = selectedStudent ? students.some((s) => s.id === selectedStudent) : false;
    if (!existsInPage) {
      setSelectedStudent(students[0].id);
    }
  }, [students, selectedStudent]);

  if (loadingStudents) {
    return (
      <div className="min-h-[100dvh] flex items-center justify-center">
        <div className="animate-spin w-8 h-8 border-4 border-[color:var(--gold)] border-t-transparent rounded-full" />
      </div>
    );
  }

  if (students.length === 0 && isAdmin) {
    return (
      <div className="min-h-[100dvh] flex flex-col items-center justify-center p-8 text-center">
        <Users className="w-16 h-16 text-muted-foreground mb-4" />
        <h2 className="text-xl font-bold text-white mb-2">{t.parentReport.adminEmptyTitle}</h2>
        <p className="text-muted-foreground max-w-md">{t.parentReport.adminEmptyDesc}</p>
      </div>
    );
  }

  return (
    <div className="min-h-[100dvh] p-4 md:p-8 max-w-6xl mx-auto">
      <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
        <Link
          to="/dashboard"
          className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.common.backToHall}
        </Link>
        <h1 className="text-2xl md:text-3xl font-bold text-white flex items-center gap-3">
          <Activity className="w-7 h-7 text-[color:var(--gold)]" />
          {isAdmin ? t.parentReport.adminTitle : t.parentReport.title}
        </h1>
        <p className="text-muted-foreground mt-1">
          {isAdmin
            ? t.parentReport.adminSubtitle.replace("{n}", String(students.length))
            : t.parentReport.subtitle}
        </p>
      </motion.div>

      {!isAdmin && (
        <div className="mb-6 rounded-xl border border-[color:var(--gold)]/40 bg-black/30 p-4">
          <div className="mb-3 flex items-center gap-2 text-[color:var(--champagne)]">
            <LinkIcon className="h-4 w-4" />
            <span className="font-semibold">{t.parentReport.linkTitle}</span>
          </div>
          <div className="grid gap-2 md:grid-cols-[1fr,180px,auto]">
            <input
              value={studentCode}
              onChange={(e) => setStudentCode(e.target.value)}
              placeholder={t.parentReport.codePlaceholder}
              className="rounded-lg border border-[color:var(--gold)]/30 bg-black/70 px-3 py-2 text-sm text-white placeholder:text-muted-foreground focus:border-[color:var(--gold)] focus:outline-none"
            />
            <input
              value={relationLabel}
              onChange={(e) => setRelationLabel(e.target.value)}
              placeholder={t.parentReport.relationPlaceholder}
              className="rounded-lg border border-[color:var(--gold)]/30 bg-black/70 px-3 py-2 text-sm text-white placeholder:text-muted-foreground focus:border-[color:var(--gold)] focus:outline-none"
            />
            <button
              type="button"
              disabled={studentCode.trim().length < 8 || linkMutation.isPending}
              onClick={() => linkMutation.mutate()}
              className="rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2 text-sm font-semibold text-black hover:opacity-90 disabled:opacity-50"
            >
              {linkMutation.isPending ? t.parentReport.linking : t.parentReport.linkCta}
            </button>
          </div>
          <p className="mt-2 text-xs text-muted-foreground">{t.parentReport.linkHint}</p>
        </div>
      )}

      {/* Student selector */}
      {(students.length > 1 || isAdmin) && (
        <div className="mb-6 flex gap-2 flex-wrap">
          {students.map((s) => (
            <button
              key={s.id}
              onClick={() => setSelectedStudent(s.id)}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                selectedStudent === s.id
                  ? "bg-[image:var(--gradient-gold)] text-black"
                  : "bg-black/50 text-muted-foreground hover:bg-black/70 border border-[color:var(--gold)]/30 hover:border-[color:var(--gold)]/60"
              }`}
            >
              {s.display_name ?? t.parentReport.defaultStudentName}
            </button>
          ))}

          {isAdmin && pagination && pagination.total > pagination.pageSize && (
            <div className="ml-auto flex items-center gap-2">
              <button
                type="button"
                onClick={() => setAdminPage((p) => Math.max(1, p - 1))}
                disabled={pagination.page <= 1}
                className="rounded-md border border-[color:var(--gold)]/30 bg-black/70 px-3 py-1.5 text-xs font-semibold text-[color:var(--champagne)] disabled:opacity-40"
              >
                {t.parentReport.prevPage}
              </button>
              <span className="text-xs text-muted-foreground">
                {t.parentReport.pageLabel
                  .replace("{page}", String(pagination.page))
                  .replace(
                    "{total}",
                    String(Math.max(1, Math.ceil(pagination.total / pagination.pageSize))),
                  )}
              </span>
              <button
                type="button"
                onClick={() => setAdminPage((p) => p + 1)}
                disabled={!pagination.hasMore}
                className="rounded-md border border-[color:var(--gold)]/30 bg-black/70 px-3 py-1.5 text-xs font-semibold text-[color:var(--champagne)] disabled:opacity-40"
              >
                {t.parentReport.nextPage}
              </button>
            </div>
          )}
        </div>
      )}

      {!isAdmin && students.length === 0 && (
        <div className="rounded-xl border border-border/50 bg-black/50 p-8 text-center text-muted-foreground">
          {t.parentReport.linkFirstHint}
        </div>
      )}

      {loadingReport ? (
        <div className="flex items-center justify-center py-20">
          <div className="animate-spin w-8 h-8 border-4 border-[color:var(--gold)] border-t-transparent rounded-full" />
        </div>
      ) : report ? (
        <ReportContent report={report} />
      ) : null}
    </div>
  );
}

type ReportData = Awaited<ReturnType<typeof getStudentReport>>;

function ReportContent({ report }: { report: ReportData }) {
  const { t, locale } = useI18n();
  const { student, summary, subjectStats, dailyActivity } = report;

  return (
    <div className="space-y-6">
      {/* Student Header */}
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-black/50 border border-[color:var(--gold)]/40 rounded-xl p-6"
      >
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h2 className="text-xl font-bold text-white">{student.displayName}</h2>
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

      {/* Key metrics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <MetricCard
          icon={<Clock className="w-5 h-5 text-blue-400" />}
          label={t.parentReport.timeTotal}
          value={formatTime(summary.totalTimeMinutes)}
        />
        <MetricCard
          icon={<BookOpen className="w-5 h-5 text-green-400" />}
          label={t.parentReport.exercisesLabel}
          value={String(summary.totalExercises)}
        />
        <MetricCard
          icon={<Target className="w-5 h-5 text-yellow-400" />}
          label={t.parentReport.avgScore}
          value={`${summary.avgScore}%`}
        />
        <MetricCard
          icon={<Calendar className="w-5 h-5 text-purple-400" />}
          label={t.parentReport.activeDays}
          value={`${summary.daysActiveThisWeek}/7`}
        />
      </div>

      {/* Score trend */}
      <div className="bg-black/50 border border-border/50 rounded-xl p-4 flex items-center gap-3">
        {summary.scoreTrend > 0 ? (
          <TrendingUp className="w-5 h-5 text-green-400" />
        ) : summary.scoreTrend < 0 ? (
          <TrendingDown className="w-5 h-5 text-red-400" />
        ) : (
          <Minus className="w-5 h-5 text-muted-foreground" />
        )}
        <span className="text-muted-foreground">
          {t.parentReport.trendPrefix}{" "}
          <span
            className={
              summary.scoreTrend > 0
                ? "text-green-400"
                : summary.scoreTrend < 0
                  ? "text-red-400"
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
        <h3 className="text-white font-semibold mb-4 flex items-center gap-2">
          <Calendar className="w-5 h-5 text-[color:var(--gold)]" />
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
                    day.exercises > 0 ? "bg-[color:var(--gold)] hover:opacity-80" : "bg-muted/50"
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
          <h3 className="text-white font-semibold mb-4 flex items-center gap-2">
            <BookOpen className="w-5 h-5 text-green-400" />
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
                    className="h-full rounded-full bg-[image:var(--gradient-gold)] transition-all"
                    style={{ width: `${s.avgScore}%` }}
                  />
                </div>
                <div className="w-10 text-right text-sm text-muted-foreground sm:w-12">
                  {s.avgScore}%
                </div>
                <div className="w-12 text-right text-xs text-muted-foreground sm:w-20">
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
  const config = {
    excellent: {
      label: t.parentReport.verdictExcellent,
      desc: t.parentReport.verdictExcellentDesc,
      color: "text-green-400",
      bg: "from-green-900/30 to-emerald-900/30 border-green-700/30",
      icon: <Star className="w-6 h-6 text-green-400" />,
    },
    good: {
      label: t.parentReport.verdictGood,
      desc: t.parentReport.verdictGoodDesc,
      color: "text-blue-400",
      bg: "from-blue-900/30 to-cyan-900/30 border-blue-700/30",
      icon: <CheckCircle className="w-6 h-6 text-blue-400" />,
    },
    average: {
      label: t.parentReport.verdictAverage,
      desc: t.parentReport.verdictAverageDesc,
      color: "text-yellow-400",
      bg: "from-yellow-900/30 to-amber-900/30 border-yellow-700/30",
      icon: <AlertTriangle className="w-6 h-6 text-yellow-400" />,
    },
    needs_improvement: {
      label: t.parentReport.verdictNeedsImprovement,
      desc: t.parentReport.verdictNeedsImprovementDesc,
      color: "text-orange-400",
      bg: "from-orange-900/30 to-red-900/30 border-orange-700/30",
      icon: <AlertTriangle className="w-6 h-6 text-orange-400" />,
    },
    inactive: {
      label: t.parentReport.verdictInactive,
      desc: t.parentReport.verdictInactiveDesc,
      color: "text-red-400",
      bg: "from-red-900/30 to-rose-900/30 border-red-700/30",
      icon: <AlertTriangle className="w-6 h-6 text-red-400" />,
    },
  };

  const c = config[verdict as keyof typeof config] ?? config.average;

  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      className={`bg-gradient-to-r ${c.bg} border rounded-xl p-4 md:p-6 flex items-center gap-3 md:gap-4`}
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
      <div className="text-xl font-bold text-white">{value}</div>
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
    <div className="flex items-center gap-2 bg-black/60 rounded-lg px-3 py-2 border border-[color:var(--gold)]/30">
      {icon}
      <div>
        <div className="text-xs text-muted-foreground">{label}</div>
        <div className="text-sm font-bold text-white">{value}</div>
      </div>
    </div>
  );
}

function formatTime(minutes: number): string {
  if (minutes < 60) return `${minutes} min`;
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return m > 0 ? `${h}h ${m}m` : `${h}h`;
}
