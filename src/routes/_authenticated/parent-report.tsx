import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import {
  Users,
  Flame,
  Trophy,
  Activity,
  Link as LinkIcon,
  ArrowLeft,
  Printer,
  Share2,
  Target,
} from "lucide-react";
import {
  buildFamilyReportShareText,
  getLinkedStudents,
  getStudentReport,
  getStudentWeeklyGoal,
  linkStudentByCode,
  ReportContent,
  setStudentWeeklyGoal,
} from "@/features/parent-report";
import { EnablePushCard } from "@/features/notifications";
import { useEffect, useMemo, useState } from "react";
import { toast } from "sonner";
import { useI18n } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/parent-report")({
  head: () => ({ meta: [{ title: "Suivi parental · Na9ra Nal3ab" }] }),
  component: ParentReport,
});

function ParentReport() {
  const { t, locale } = useI18n();
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
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8 print:hidden"
      >
        <Link
          to="/dashboard"
          className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.common.backToHall}
        </Link>
        <div className="flex flex-wrap items-start justify-between gap-3">
          <div>
            <h1 className="text-2xl md:text-3xl font-bold text-white flex items-center gap-3">
              <Activity className="w-7 h-7 text-[color:var(--gold)]" />
              {isAdmin ? t.parentReport.adminTitle : t.parentReport.title}
            </h1>
            <p className="text-muted-foreground mt-1">
              {isAdmin
                ? t.parentReport.adminSubtitle.replace("{n}", String(students.length))
                : t.parentReport.subtitle}
            </p>
          </div>
          {report && (
            <div className="flex flex-wrap gap-2">
              <button
                type="button"
                onClick={() => shareReport(buildFamilyReportShareText(report, t))}
                className="inline-flex items-center gap-2 rounded-lg border border-[color:var(--gold)]/40 bg-black/50 px-4 py-2 text-sm font-semibold text-[color:var(--champagne)] transition hover:border-[color:var(--gold)] [@media(pointer:coarse)]:min-h-11"
              >
                <Share2 className="h-4 w-4" /> {t.parentReport.shareCta}
              </button>
              <button
                type="button"
                onClick={() => window.print()}
                className="inline-flex items-center gap-2 rounded-lg border border-[color:var(--gold)]/40 bg-black/50 px-4 py-2 text-sm font-semibold text-[color:var(--champagne)] transition hover:border-[color:var(--gold)] [@media(pointer:coarse)]:min-h-11"
              >
                <Printer className="h-4 w-4" /> {t.parentReport.printCta}
              </button>
            </div>
          )}
        </div>
      </motion.div>

      {!isAdmin && (
        <div className="mb-6 rounded-xl border border-[color:var(--gold)]/40 bg-black/30 p-4 print:hidden">
          <div className="mb-3 flex items-center gap-2 text-[color:var(--champagne)]">
            <LinkIcon className="h-4 w-4" />
            <span className="font-semibold">{t.parentReport.linkTitle}</span>
          </div>
          <div className="grid gap-2 md:grid-cols-[1fr_180px_auto]">
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

      {/* Opt-in au digest hebdo (dimanche soir) — la carte s'auto-masque si le
          push est impossible ici (navigateur non supporté / VAPID absent). */}
      {!isAdmin && (
        <div className="mb-6 print:hidden">
          <EnablePushCard title={t.parentReport.pushTitle} desc={t.parentReport.pushDesc} />
        </div>
      )}

      {/* Fratrie : cartes résumé côte à côte — chaque enfant en un coup d'œil
          (niveau, série, dernière activité), cliquables pour ouvrir son bilan. */}
      {!isAdmin && students.length > 1 && (
        <div className="mb-6 grid gap-3 sm:grid-cols-2 lg:grid-cols-3 print:hidden">
          {students.map((s) => {
            const selected = selectedStudent === s.id;
            return (
              <button
                key={s.id}
                type="button"
                onClick={() => setSelectedStudent(s.id)}
                aria-pressed={selected}
                className={`rounded-xl border p-4 text-start transition [@media(pointer:coarse)]:min-h-11 ${
                  selected
                    ? "border-[color:var(--gold)] bg-[color:var(--gold)]/10"
                    : "border-border/50 bg-black/50 hover:border-[color:var(--gold)]/60"
                }`}
              >
                <div className="flex items-center justify-between gap-2">
                  <span className="truncate font-bold text-white">
                    {s.display_name ?? t.parentReport.defaultStudentName}
                  </span>
                  <span
                    className={`h-2.5 w-2.5 shrink-0 rounded-full ${
                      isActiveThisWeek(s.last_active_date) ? "bg-green-400" : "bg-red-400/70"
                    }`}
                    title={
                      s.last_active_date
                        ? new Date(s.last_active_date).toLocaleDateString(locale)
                        : t.parentReport.noActivity
                    }
                  />
                </div>
                <div className="mt-2 flex items-center gap-4 text-sm text-muted-foreground">
                  <span className="inline-flex items-center gap-1">
                    <Trophy className="h-3.5 w-3.5 text-[color:var(--gold)]" />
                    {t.dashboard.levelLabel} {s.level}
                  </span>
                  <span className="inline-flex items-center gap-1">
                    <Flame className="h-3.5 w-3.5 text-orange-400" />
                    {s.current_streak}j
                  </span>
                </div>
                <div className="mt-1 text-xs text-muted-foreground">
                  {t.parentReport.lastActivity}{" "}
                  {s.last_active_date
                    ? new Date(s.last_active_date).toLocaleDateString(locale)
                    : t.parentReport.noActivity}
                </div>
              </button>
            );
          })}
        </div>
      )}

      {/* Admin : sélecteur compact paginé (jusqu'à 100 élèves par page). */}
      {isAdmin && (
        <div className="mb-6 flex gap-2 flex-wrap print:hidden">
          {students.map((s) => (
            <button
              key={s.id}
              onClick={() => setSelectedStudent(s.id)}
              className={`px-4 py-2 rounded-lg font-medium transition-colors [@media(pointer:coarse)]:min-h-11 ${
                selectedStudent === s.id
                  ? "bg-[image:var(--gradient-gold)] text-black"
                  : "bg-black/50 text-muted-foreground hover:bg-black/70 border border-[color:var(--gold)]/30 hover:border-[color:var(--gold)]/60"
              }`}
            >
              {s.display_name ?? t.parentReport.defaultStudentName}
            </button>
          ))}

          {pagination && pagination.total > pagination.pageSize && (
            <div className="ml-auto flex items-center gap-2">
              <button
                type="button"
                onClick={() => setAdminPage((p) => Math.max(1, p - 1))}
                disabled={pagination.page <= 1}
                className="rounded-md border border-[color:var(--gold)]/30 bg-black/70 px-3 py-1.5 text-xs font-semibold text-[color:var(--champagne)] disabled:opacity-40 [@media(pointer:coarse)]:min-h-11"
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
                className="rounded-md border border-[color:var(--gold)]/30 bg-black/70 px-3 py-1.5 text-xs font-semibold text-[color:var(--champagne)] disabled:opacity-40 [@media(pointer:coarse)]:min-h-11"
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

      {/* Objectif de la semaine — le parent fixe la quête famille de l'enfant. */}
      {!isAdmin && selectedStudent && <WeeklyGoalCard studentId={selectedStudent} />}

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

/**
 * Partage du bilan : Web Share natif quand disponible (mobile), sinon WhatsApp
 * web — le canal familial n°1 en Tunisie.
 */
function shareReport(text: string): void {
  if (typeof navigator !== "undefined" && typeof navigator.share === "function") {
    navigator.share({ text }).catch(() => {});
    return;
  }
  window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, "_blank", "noopener,noreferrer");
}

/** Actif dans les 7 derniers jours — pastille verte sur la carte enfant. */
function isActiveThisWeek(lastActiveDate: string | null): boolean {
  if (!lastActiveDate) return false;
  const last = new Date(lastActiveDate).getTime();
  return Number.isFinite(last) && Date.now() - last < 7 * 24 * 60 * 60 * 1000;
}

/**
 * Objectif de la semaine : le parent fixe un cap de missions ; l'enfant le voit
 * comme une quête famille sur son dashboard. Une ligne par élève et par semaine
 * (upsert côté RPC — le lien parent-élève y est vérifié).
 */
function WeeklyGoalCard({ studentId }: { studentId: string }) {
  const { t } = useI18n();
  const queryClient = useQueryClient();
  const getGoalFn = useServerFn(getStudentWeeklyGoal);
  const setGoalFn = useServerFn(setStudentWeeklyGoal);
  const [target, setTarget] = useState(5);

  const { data: goal } = useQuery({
    queryKey: ["weekly-goal", studentId],
    queryFn: () => getGoalFn({ data: { studentId } }),
  });

  // Aligne le champ sur l'objectif déjà posé quand il arrive / change d'élève.
  useEffect(() => {
    if (goal) setTarget(goal.target);
  }, [goal]);

  const saveMutation = useMutation({
    mutationFn: () => setGoalFn({ data: { studentId, target } }),
    onSuccess: (res) => {
      toast.success(t.parentReport.goalSaved.replace("{n}", String(res.target)));
      queryClient.invalidateQueries({ queryKey: ["weekly-goal", studentId] });
    },
    onError: (error) => {
      toast.error(error instanceof Error ? error.message : t.parentReport.linkFailed);
    },
  });

  const done = goal?.done ?? 0;
  const progressPct = goal ? Math.min(100, Math.round((done / goal.target) * 100)) : 0;

  return (
    <div className="mb-6 rounded-xl border border-[color:var(--gold)]/40 bg-black/30 p-4 print:hidden">
      <div className="mb-1 flex items-center gap-2 text-[color:var(--champagne)]">
        <Target className="h-4 w-4" />
        <span className="font-semibold">{t.parentReport.goalTitle}</span>
      </div>
      <p className="text-xs text-muted-foreground">{t.parentReport.goalHint}</p>
      <div className="mt-3 flex flex-wrap items-center gap-3">
        <input
          type="number"
          min={1}
          max={50}
          value={target}
          onChange={(e) => {
            const n = Number(e.target.value);
            if (Number.isFinite(n)) setTarget(Math.max(1, Math.min(50, Math.trunc(n))));
          }}
          aria-label={t.parentReport.goalTitle}
          className="w-20 rounded-lg border border-[color:var(--gold)]/30 bg-black/70 px-3 py-2 text-sm text-white focus:border-[color:var(--gold)] focus:outline-none"
        />
        <span className="text-sm text-muted-foreground">{t.parentReport.goalUnit}</span>
        <button
          type="button"
          disabled={saveMutation.isPending || (goal != null && goal.target === target)}
          onClick={() => saveMutation.mutate()}
          className="rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2 text-sm font-semibold text-black hover:opacity-90 disabled:opacity-50 [@media(pointer:coarse)]:min-h-11"
        >
          {saveMutation.isPending ? t.parentReport.goalSaving : t.parentReport.goalSave}
        </button>
      </div>
      {goal && (
        <div className="mt-3">
          <div className="mb-1 text-xs text-muted-foreground">
            {t.parentReport.goalProgress
              .replace("{done}", String(done))
              .replace("{target}", String(goal.target))}
          </div>
          <div className="h-2 overflow-hidden rounded-full bg-muted/50">
            <div
              className="h-full rounded-full bg-[image:var(--gradient-gold)] transition-all"
              style={{ width: `${progressPct}%` }}
            />
          </div>
        </div>
      )}
    </div>
  );
}
