import { Link } from "@tanstack/react-router";
import { CalendarCheck, Check, ChevronRight } from "lucide-react";

import { useStudyT } from "@/lib/i18n/study";
import {
  isStudyGoalReached,
  STUDY_TARGET_OPTIONS,
  studyGoalPercent,
  studyPlanMinutes,
  type StudyReport,
} from "@/shared/lib/study-report";

/**
 * « Programme du jour » — l'objectif (le temps MESURÉ, pas une estimation), ce qui a été fait
 * aujourd'hui, et ce qui reste à faire pour l'atteindre.
 *
 * LE MÊME COMPOSANT POUR L'ÉLÈVE ET SON PARENT (commande du 2026-11-22 : « il doit avoir le
 * même rapport »). Seule différence : l'élève peut lancer une mission, le parent la lit. Rien
 * n'est décidé ici — la composition du programme, la durée d'une mission et ce qui est « vu
 * en classe » viennent de `get_study_report`.
 *
 * Chaque phrase chiffrée est UN seul nœud de texte (docs/design-surfaces.md).
 */
export function StudyPlanCard({
  report,
  audience,
  showReportLink = false,
  onSetTarget,
  saving = false,
  className = "",
}: {
  report: StudyReport;
  audience: "student" | "parent";
  /** Le lien vers le bilan complet — sur le tableau de bord, pas dans le bilan lui-même. */
  showReportLink?: boolean;
  /** Règle l'objectif quotidien. Absent (tableau de bord) : l'objectif se lit sans se régler. */
  onSetTarget?: (minutes: number) => void;
  saving?: boolean;
  className?: string;
}) {
  const t = useStudyT().study;
  const subjectName = new Map(report.subjects.map((s) => [s.id, s.name]));
  const reached = isStudyGoalReached(report);
  const percent = studyGoalPercent(report);
  const remaining = studyPlanMinutes(report.plan);

  return (
    <section
      aria-label={t.plan.title}
      data-testid="study-plan-card"
      className={`bg-surface-2 rounded-2xl border border-[color:var(--gold)]/25 p-5 backdrop-blur-md ${className}`}
    >
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="font-display flex items-center gap-2 text-lg font-bold">
          <CalendarCheck className="h-5 w-5 text-[color:var(--gold)]" />
          {t.plan.title}
        </div>
        {report.plan.length > 0 && (
          <span className="text-muted-foreground text-xs" data-testid="study-plan-minutes">
            {t.plan.minutes.replace("{n}", String(remaining))}
          </span>
        )}
      </div>

      <div className="mt-3">
        <div className="flex items-baseline justify-between gap-2 text-sm">
          <span className="font-semibold">{reached ? t.goal.reached : t.goal.title}</span>
          <span className="text-muted-foreground" data-testid="study-goal-progress">
            {t.goal.progress
              .replace("{done}", String(report.doneMinutes))
              .replace("{target}", String(report.targetMinutes))}
          </span>
        </div>
        <div
          role="progressbar"
          aria-label={t.goal.title}
          aria-valuemin={0}
          aria-valuemax={100}
          aria-valuenow={percent}
          className="bg-surface-3 mt-2 h-2 overflow-hidden rounded-full"
        >
          <div
            className="h-full rounded-full bg-[color:var(--gold)]"
            style={{ width: `${percent}%` }}
          />
        </div>
        <p className="text-muted-foreground mt-2 text-xs">
          {t.goal.week
            .replace("{minutes}", String(report.weekMinutes))
            .replace("{days}", String(report.weekActiveDays))}
        </p>
        {onSetTarget && (
          <div
            role="group"
            aria-label={t.goal.choose}
            data-testid="study-target"
            className="mt-3 flex flex-wrap items-center gap-2"
          >
            <span className="text-muted-foreground text-xs">{t.goal.choose}</span>
            {STUDY_TARGET_OPTIONS.map((minutes) => {
              const active = report.targetMinutes === minutes;
              return (
                <button
                  key={minutes}
                  type="button"
                  aria-pressed={active}
                  disabled={saving}
                  onClick={() => onSetTarget(minutes)}
                  className={`rounded-full border px-3 py-1 text-xs font-semibold transition disabled:opacity-50 ${
                    active
                      ? "border-[color:var(--gold)] bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                      : "border-border/60 text-muted-foreground hover:border-[color:var(--gold)]/50"
                  }`}
                >
                  {t.goal.option.replace("{n}", String(minutes))}
                </button>
              );
            })}
          </div>
        )}
      </div>

      {report.plan.length === 0 ? (
        <p className="text-muted-foreground mt-4 text-sm" data-testid="study-plan-empty">
          {reached ? t.plan.emptyGoalReached[audience] : t.plan.emptyUpToDate[audience]}
        </p>
      ) : (
        <ol className="mt-4 space-y-2">
          {report.plan.map((item) => {
            const body = (
              <>
                <div className="min-w-0 flex-1">
                  {/* Deux lignes, pas une : sur téléphone un titre de mission tronqué à vingt
                      caractères ne dit plus de quoi il s'agit. */}
                  <div className="line-clamp-2 leading-snug font-semibold" dir="auto">
                    {item.title}
                  </div>
                  <div className="text-muted-foreground mt-0.5 line-clamp-2 text-xs" dir="auto">
                    {`${subjectName.get(item.subjectId) ?? ""} · ${item.chapterTitle}`}
                  </div>
                  <div className="mt-1 text-xs text-[color:var(--gold)]">
                    {t.plan.kind[item.kind]}
                  </div>
                </div>
                <span className="text-muted-foreground shrink-0 text-xs">
                  {t.plan.stepMinutes.replace("{n}", String(item.estMinutes))}
                </span>
              </>
            );
            const box =
              "flex items-center gap-3 rounded-xl border border-[color:var(--gold)]/20 bg-[color:var(--gold)]/5 p-3";
            return (
              <li key={item.exerciseId} data-testid="study-plan-item">
                {audience === "student" ? (
                  <Link
                    to="/quest/$exerciseId"
                    params={{ exerciseId: item.exerciseId }}
                    className={`group ${box} transition hover:border-[color:var(--gold)]/50`}
                  >
                    {body}
                    <ChevronRight className="text-muted-foreground h-4 w-4 shrink-0 rtl:-scale-x-100" />
                  </Link>
                ) : (
                  <div className={box}>{body}</div>
                )}
              </li>
            );
          })}
        </ol>
      )}

      {report.today.length > 0 && (
        <div className="mt-4" data-testid="study-done-today">
          <div className="text-muted-foreground text-xs font-bold tracking-[0.14em] uppercase">
            {t.plan.doneTitle}
          </div>
          <ul className="mt-2 space-y-1">
            {report.today.map((done) => (
              <li key={done.exerciseId} className="flex items-center gap-2 text-sm">
                <Check className="h-4 w-4 shrink-0 text-[color:var(--gold)]" />
                <span className="min-w-0 flex-1 truncate" dir="auto">
                  {done.title}
                </span>
                <span className="text-muted-foreground shrink-0 text-xs">
                  {/* Isolat LTR : sans lui « 88 % » se lit « % 88 » dans une ligne arabe. */}
                  {`\u2066${t.plan.doneScore.replace("{score}", String(done.scorePct))}\u2069`}
                </span>
              </li>
            ))}
          </ul>
        </div>
      )}

      {showReportLink && (
        <Link
          to="/bilan"
          className="mt-4 inline-flex items-center gap-1 text-sm font-semibold text-[color:var(--gold)]"
          data-testid="study-report-link"
        >
          {t.plan.seeReport}
          <ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
        </Link>
      )}
    </section>
  );
}
