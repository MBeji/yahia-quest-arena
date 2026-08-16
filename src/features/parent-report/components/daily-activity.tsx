import { useState } from "react";
import { BookOpen, ChevronRight, Dumbbell, Eye } from "lucide-react";
import { useT } from "@/lib/i18n";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import { DifficultyStars } from "@/components/game/difficulty-stars";
import type { DailyReport, ExerciseRun, LessonView } from "../insights";
import { formatSeconds } from "../insights";
import { DeltaChip, EmptyRow, Meter, SectionCard } from "./daily-primitives";

/**
 * Le DÉTAIL des activités — §2 et §3 : chaque cours consulté et chaque exercice
 * réalisé, avec de quoi juger.
 *
 * Volontairement en listes et non en tableaux : le cahier des charges demande
 * treize colonnes par exercice, ce qui est illisible sur le téléphone où ce
 * tableau de bord sera surtout lu. Chaque ligne porte donc l'essentiel en
 * évidence et le reste en seconde ligne, et l'exercice s'ouvre d'un clic sur le
 * détail question par question.
 */

const PAGE_STEP = 8;

export function LessonsSection({ report }: { report: DailyReport }) {
  const t = useT();
  const [shown, setShown] = useState(PAGE_STEP);
  const rows = report.lessons.slice(0, shown);

  return (
    <SectionCard
      title={t.parentDaily.lessonsTitle}
      subtitle={t.parentDaily.lessonsSubtitle
        .replace("{studied}", String(report.totals.lessonsStudied))
        .replace("{opened}", String(report.totals.lessonsOpened))}
      icon={<BookOpen className="h-5 w-5 text-success" />}
    >
      {report.lessons.length === 0 ? (
        <EmptyRow label={t.parentDaily.lessonsEmpty} />
      ) : (
        <>
          <ul className="space-y-2">
            {rows.map((lesson) => (
              <LessonRow key={`${lesson.date}-${lesson.chapterId}`} lesson={lesson} />
            ))}
          </ul>
          <MoreButton
            total={report.lessons.length}
            shown={shown}
            onMore={() => setShown((n) => n + PAGE_STEP)}
          />
        </>
      )}
    </SectionCard>
  );
}

function LessonRow({ lesson }: { lesson: LessonView }) {
  const t = useT();

  return (
    <li className="rounded-lg border border-border/50 bg-surface-3 p-3">
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="truncate text-sm font-semibold text-foreground">
            {isolateLtrRuns(lesson.chapterTitle)}
          </div>
          <div className="mt-0.5 truncate text-xs text-muted-foreground">
            {isolateLtrRuns(lesson.subjectName)}
            {lesson.gradeName ? ` · ${isolateLtrRuns(lesson.gradeName)}` : ""} · {lesson.date}{" "}
            {lesson.at}
          </div>
        </div>
        {/* Le verdict qui compte pour un parent : lu, ou seulement ouvert. */}
        <span
          className={`shrink-0 rounded-md px-2 py-1 text-2xs font-bold ${
            lesson.studied ? "bg-success/20 text-success" : "bg-muted/60 text-muted-foreground"
          }`}
        >
          {lesson.studied ? t.parentDaily.lessonStudied : t.parentDaily.lessonOpened}
        </span>
      </div>

      <div className="mt-2 flex items-center gap-3">
        <Meter
          value={lesson.progressPct}
          className="bg-success"
          label={t.parentDaily.lessonProgressAria.replace("{pct}", String(lesson.progressPct))}
        />
        <span className="w-10 shrink-0 text-end text-xs tabular-nums text-muted-foreground">
          {lesson.progressPct}%
        </span>
      </div>

      <div className="mt-1.5 flex flex-wrap gap-x-3 text-2xs text-muted-foreground">
        <span>{formatSeconds(lesson.seconds)}</span>
        <span className="inline-flex items-center gap-1">
          <Eye className="h-3 w-3" />
          {t.parentDaily.lessonViews.replace("{n}", String(lesson.views))}
        </span>
      </div>
    </li>
  );
}

export function ExercisesSection({
  report,
  onOpenAttempt,
}: {
  report: DailyReport;
  onOpenAttempt: (attemptId: string) => void;
}) {
  const t = useT();
  const [shown, setShown] = useState(PAGE_STEP);
  const rows = report.exercises.slice(0, shown);

  return (
    <SectionCard
      title={t.parentDaily.exercisesTitle}
      subtitle={t.parentDaily.exercisesSubtitle
        .replace("{passed}", String(report.totals.exercisesPassed))
        .replace("{total}", String(report.totals.exercises))}
      icon={<Dumbbell className="h-5 w-5 text-primary" />}
    >
      {report.exercises.length === 0 ? (
        <EmptyRow label={t.parentDaily.exercisesEmpty} />
      ) : (
        <>
          <ul className="space-y-2">
            {rows.map((run) => (
              <ExerciseRow
                key={run.attemptId}
                run={run}
                passPct={report.thresholds.passPct}
                onOpen={() => onOpenAttempt(run.attemptId)}
              />
            ))}
          </ul>
          <MoreButton
            total={report.exercises.length}
            shown={shown}
            onMore={() => setShown((n) => n + PAGE_STEP)}
          />
        </>
      )}
    </SectionCard>
  );
}

function ExerciseRow({
  run,
  passPct,
  onOpen,
}: {
  run: ExerciseRun;
  passPct: number;
  onOpen: () => void;
}) {
  const t = useT();
  const passed = run.scorePct >= passPct;
  const modeLabel = exerciseModeLabel(run, t);

  return (
    <li>
      <button
        type="button"
        onClick={onOpen}
        className="flex w-full items-start gap-3 rounded-lg border border-border/50 bg-surface-3 p-3 text-start transition hover:border-gold/60 [@media(pointer:coarse)]:min-h-11"
      >
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            <span className="truncate text-sm font-semibold text-foreground">
              {isolateLtrRuns(run.exerciseTitle)}
            </span>
            <span className="rounded bg-muted/60 px-1.5 py-0.5 text-2xs font-semibold text-muted-foreground">
              {modeLabel}
            </span>
            {run.attemptNo > 1 && (
              <span className="rounded bg-muted/60 px-1.5 py-0.5 text-2xs text-muted-foreground">
                {t.parentDaily.attemptNo.replace("{n}", String(run.attemptNo))}
              </span>
            )}
          </div>

          <div className="mt-0.5 truncate text-xs text-muted-foreground">
            {isolateLtrRuns(run.subjectName)}
            {run.gradeName ? ` · ${isolateLtrRuns(run.gradeName)}` : ""}
            {run.chapterTitle ? ` · ${isolateLtrRuns(run.chapterTitle)}` : ""}
          </div>

          <div className="mt-1.5 flex flex-wrap items-center gap-x-3 gap-y-1 text-2xs text-muted-foreground">
            <span>
              {run.date} {run.at}
            </span>
            <span>{formatSeconds(run.durationSeconds)}</span>
            <span>
              {t.parentDaily.rightWrong
                .replace("{right}", String(run.correct))
                .replace("{wrong}", String(run.wrong))}
            </span>
            {run.difficulty > 0 && <DifficultyStars level={run.difficulty} />}
          </div>
        </div>

        <div className="flex shrink-0 flex-col items-end gap-1">
          <span
            className={`rounded-md px-2 py-1 text-sm font-bold ${
              passed ? "bg-success/20 text-success" : "bg-flame/20 text-flame"
            }`}
          >
            {run.scorePct}%
          </span>
          {/* L'évolution quand l'exercice est refait — le signal « il a compris ». */}
          {run.previousScorePct !== null && (
            <DeltaChip value={run.scorePct - run.previousScorePct} suffix="%" />
          )}
          <ChevronRight className="h-4 w-4 text-muted-foreground rtl:-scale-x-100" />
        </div>
      </button>
    </li>
  );
}

function MoreButton({
  total,
  shown,
  onMore,
}: {
  total: number;
  shown: number;
  onMore: () => void;
}) {
  const t = useT();
  if (shown >= total) return null;
  return (
    <button
      type="button"
      onClick={onMore}
      className="mt-3 w-full rounded-lg border border-border/50 py-2 text-sm font-semibold text-muted-foreground transition hover:border-gold/60 hover:text-foreground [@media(pointer:coarse)]:min-h-11"
    >
      {t.parentDaily.showMore.replace("{n}", String(Math.min(total - shown, 8)))}
    </button>
  );
}

/** Le type d'exercice, dans les mots d'un parent — pas ceux du moteur. */
function exerciseModeLabel(
  run: ExerciseRun,
  t: {
    parentDaily: { modeQuiz: string; modeBoss: string; modeRecall: string; modePractice: string };
  },
): string {
  if (run.variant === "recall") return t.parentDaily.modeRecall;
  if (run.mode === "quiz") return t.parentDaily.modeQuiz;
  if (run.mode === "boss" || run.mode === "challenge") return t.parentDaily.modeBoss;
  return t.parentDaily.modePractice;
}
