import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
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
} from "lucide-react";
import { getLinkedStudents, getStudentReport } from "@/lib/gamification.parent";
import { useState } from "react";

export const Route = createFileRoute("/_authenticated/parent-report")({
  head: () => ({ meta: [{ title: "Parent Report · XP Scholars" }] }),
  component: ParentReport,
});

function ParentReport() {
  const getStudentsFn = useServerFn(getLinkedStudents);
  const getReportFn = useServerFn(getStudentReport);
  const [selectedStudent, setSelectedStudent] = useState<string | null>(null);

  const { data: studentsData, isLoading: loadingStudents } = useQuery({
    queryKey: ["parent-students"],
    queryFn: () => getStudentsFn(),
  });

  const { data: report, isLoading: loadingReport } = useQuery({
    queryKey: ["parent-report", selectedStudent],
    queryFn: () => getReportFn({ data: { studentId: selectedStudent! } }),
    enabled: !!selectedStudent,
  });

  if (loadingStudents) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin w-8 h-8 border-4 border-indigo-400 border-t-transparent rounded-full" />
      </div>
    );
  }

  const students = studentsData?.students ?? [];
  const isAdmin = studentsData?.role === "admin";

  if (students.length === 0) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center p-8 text-center">
        <Users className="w-16 h-16 text-gray-400 mb-4" />
        <h2 className="text-xl font-bold text-white mb-2">
          {isAdmin ? "Aucun élève inscrit" : "Aucun élève lié"}
        </h2>
        <p className="text-gray-400 max-w-md">
          {isAdmin
            ? "Aucun compte élève n'existe encore dans la plateforme."
            : "Votre compte parent n'est pas encore lié à un élève. Contactez l'administrateur pour associer un élève à votre compte."}
        </p>
      </div>
    );
  }

  // Auto-select first student
  if (!selectedStudent && students.length > 0) {
    setSelectedStudent(students[0].id);
  }

  return (
    <div className="min-h-screen p-4 md:p-8 max-w-6xl mx-auto">
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8"
      >
        <h1 className="text-2xl md:text-3xl font-bold text-white flex items-center gap-3">
          <Activity className="w-7 h-7 text-indigo-400" />
          {isAdmin ? "Admin — Suivi des élèves" : "Rapport de suivi"}
        </h1>
        <p className="text-gray-400 mt-1">
          {isAdmin
            ? `${students.length} élève(s) inscrits — sélectionnez pour voir le détail`
            : "Vue d'ensemble de l'activité de votre enfant"}
        </p>
      </motion.div>

      {/* Student selector */}
      {(students.length > 1 || isAdmin) && (
        <div className="mb-6 flex gap-2 flex-wrap">
          {students.map((s) => (
            <button
              key={s.id}
              onClick={() => setSelectedStudent(s.id)}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                selectedStudent === s.id
                  ? "bg-indigo-600 text-white"
                  : "bg-gray-800 text-gray-300 hover:bg-gray-700"
              }`}
            >
              {s.display_name ?? "Élève"}
            </button>
          ))}
        </div>
      )}

      {loadingReport ? (
        <div className="flex items-center justify-center py-20">
          <div className="animate-spin w-8 h-8 border-4 border-indigo-400 border-t-transparent rounded-full" />
        </div>
      ) : report ? (
        <ReportContent report={report} />
      ) : null}
    </div>
  );
}

type ReportData = Awaited<ReturnType<typeof getStudentReport>>;

function ReportContent({ report }: { report: ReportData }) {
  const { student, summary, subjectStats, dailyActivity } = report;

  return (
    <div className="space-y-6">
      {/* Student Header */}
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-gradient-to-r from-indigo-900/50 to-purple-900/50 border border-indigo-700/30 rounded-xl p-6"
      >
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h2 className="text-xl font-bold text-white">{student.displayName}</h2>
            <p className="text-gray-400 text-sm mt-1">
              Classe: {student.heroClass ?? "Non choisie"} · Membre depuis{" "}
              {new Date(student.createdAt).toLocaleDateString("fr-FR")}
            </p>
          </div>
          <div className="flex items-center gap-4">
            <StatBadge icon={<Trophy className="w-4 h-4" />} label="Niveau" value={student.level} />
            <StatBadge icon={<Flame className="w-4 h-4" />} label="Streak" value={`${student.currentStreak}j`} />
          </div>
        </div>
      </motion.div>

      {/* Verdict card */}
      <VerdictCard score={summary.seriousnessScore} verdict={summary.verdict} />

      {/* Key metrics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <MetricCard
          icon={<Clock className="w-5 h-5 text-blue-400" />}
          label="Temps total"
          value={formatTime(summary.totalTimeMinutes)}
        />
        <MetricCard
          icon={<BookOpen className="w-5 h-5 text-green-400" />}
          label="Exercices"
          value={String(summary.totalExercises)}
        />
        <MetricCard
          icon={<Target className="w-5 h-5 text-yellow-400" />}
          label="Score moyen"
          value={`${summary.avgScore}%`}
        />
        <MetricCard
          icon={<Calendar className="w-5 h-5 text-purple-400" />}
          label="Jours actifs (7j)"
          value={`${summary.daysActiveThisWeek}/7`}
        />
      </div>

      {/* Score trend */}
      <div className="bg-gray-900/50 border border-gray-700/50 rounded-xl p-4 flex items-center gap-3">
        {summary.scoreTrend > 0 ? (
          <TrendingUp className="w-5 h-5 text-green-400" />
        ) : summary.scoreTrend < 0 ? (
          <TrendingDown className="w-5 h-5 text-red-400" />
        ) : (
          <Minus className="w-5 h-5 text-gray-400" />
        )}
        <span className="text-gray-300">
          Tendance des scores:{" "}
          <span
            className={
              summary.scoreTrend > 0
                ? "text-green-400"
                : summary.scoreTrend < 0
                ? "text-red-400"
                : "text-gray-400"
            }
          >
            {summary.scoreTrend > 0 ? "+" : ""}
            {summary.scoreTrend}%
          </span>{" "}
          par rapport aux exercices précédents
        </span>
      </div>

      {/* Activity chart (simple bar chart) */}
      <div className="bg-gray-900/50 border border-gray-700/50 rounded-xl p-4">
        <h3 className="text-white font-semibold mb-4 flex items-center gap-2">
          <Calendar className="w-5 h-5 text-indigo-400" />
          Activité des 30 derniers jours
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
                    day.exercises > 0 ? "bg-indigo-500 hover:bg-indigo-400" : "bg-gray-700"
                  }`}
                  style={{ height: `${Math.max(height, 4)}%` }}
                />
              </div>
            );
          })}
        </div>
        <div className="flex justify-between mt-2 text-xs text-gray-500">
          <span>{dailyActivity[0]?.date}</span>
          <span>Aujourd'hui</span>
        </div>
      </div>

      {/* Subject breakdown */}
      {subjectStats.length > 0 && (
        <div className="bg-gray-900/50 border border-gray-700/50 rounded-xl p-4">
          <h3 className="text-white font-semibold mb-4 flex items-center gap-2">
            <BookOpen className="w-5 h-5 text-green-400" />
            Performance par matière
          </h3>
          <div className="space-y-3">
            {subjectStats.map((s) => (
              <div key={s.subjectId} className="flex items-center gap-3">
                <div className="w-28 text-sm text-gray-300 truncate">{s.name}</div>
                <div className="flex-1 h-4 bg-gray-800 rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full bg-gradient-to-r from-indigo-500 to-purple-500 transition-all"
                    style={{ width: `${s.avgScore}%` }}
                  />
                </div>
                <div className="w-12 text-right text-sm text-gray-300">{s.avgScore}%</div>
                <div className="w-20 text-right text-xs text-gray-500">{s.attempts} ex.</div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Last active */}
      <div className="text-center text-sm text-gray-500 py-4">
        Dernière activité:{" "}
        {student.lastActiveDate
          ? new Date(student.lastActiveDate).toLocaleDateString("fr-FR", {
              day: "numeric",
              month: "long",
              year: "numeric",
            })
          : "Aucune activité"}
      </div>
    </div>
  );
}

function VerdictCard({ score, verdict }: { score: number; verdict: string }) {
  const config = {
    excellent: {
      label: "Excellent",
      desc: "Votre enfant est très assidu et progresse rapidement !",
      color: "text-green-400",
      bg: "from-green-900/30 to-emerald-900/30 border-green-700/30",
      icon: <Star className="w-6 h-6 text-green-400" />,
    },
    good: {
      label: "Bien",
      desc: "Bonne régularité. Quelques efforts supplémentaires seront bénéfiques.",
      color: "text-blue-400",
      bg: "from-blue-900/30 to-cyan-900/30 border-blue-700/30",
      icon: <CheckCircle className="w-6 h-6 text-blue-400" />,
    },
    average: {
      label: "Moyen",
      desc: "Activité irrégulière. Encouragez des sessions plus fréquentes.",
      color: "text-yellow-400",
      bg: "from-yellow-900/30 to-amber-900/30 border-yellow-700/30",
      icon: <AlertTriangle className="w-6 h-6 text-yellow-400" />,
    },
    needs_improvement: {
      label: "À améliorer",
      desc: "Peu d'activité récente. Un suivi rapproché est recommandé.",
      color: "text-orange-400",
      bg: "from-orange-900/30 to-red-900/30 border-orange-700/30",
      icon: <AlertTriangle className="w-6 h-6 text-orange-400" />,
    },
    inactive: {
      label: "Inactif",
      desc: "Aucune activité détectée. Vérifiez que l'élève utilise la plateforme.",
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
      className={`bg-gradient-to-r ${c.bg} border rounded-xl p-6 flex items-center gap-4`}
    >
      {c.icon}
      <div className="flex-1">
        <div className="flex items-center gap-3">
          <span className={`text-lg font-bold ${c.color}`}>{c.label}</span>
          <span className="text-sm text-gray-400">Score d'assiduité: {score}/100</span>
        </div>
        <p className="text-gray-300 text-sm mt-1">{c.desc}</p>
      </div>
      {/* Circular gauge */}
      <div className="relative w-16 h-16">
        <svg className="w-16 h-16 -rotate-90" viewBox="0 0 36 36">
          <circle cx="18" cy="18" r="15" fill="none" stroke="#374151" strokeWidth="3" />
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
        <span className={`absolute inset-0 flex items-center justify-center text-sm font-bold ${c.color}`}>
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
    <div className="bg-gray-900/50 border border-gray-700/50 rounded-xl p-4 text-center">
      <div className="flex justify-center mb-2">{icon}</div>
      <div className="text-xl font-bold text-white">{value}</div>
      <div className="text-xs text-gray-400 mt-1">{label}</div>
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
    <div className="flex items-center gap-2 bg-gray-800/80 rounded-lg px-3 py-2">
      {icon}
      <div>
        <div className="text-xs text-gray-400">{label}</div>
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
