import { BarChart3, ListChecks, Target } from "lucide-react";

import { useStudyT } from "@/lib/i18n/study";
import {
  chaptersToWork,
  examMarkOutOf20,
  seenThroughChapter,
  toggleSeenChapter,
  type StudyReport,
  type StudySubject,
} from "@/shared/lib/study-report";

/** Un isolat LTR garde « 13,5/20 » ou « 72 % » d'un bloc dans une phrase arabe. */
function ltr(text: string): string {
  return `⁦${text}⁩`;
}

const LEVEL_TONE: Record<StudySubject["level"], string> = {
  "non-evalue": "text-muted-foreground border-border/60",
  "a-renforcer": "text-flame-ink border-flame-ink/40",
  "en-progres": "text-foreground border-[color:var(--gold)]/40",
  solide: "text-[color:var(--gold)] border-[color:var(--gold)]/60",
};

/**
 * Le bilan matière par matière : le NIVEAU (la réussite récente, tranchée en base), où en est
 * l'élève sur ce qu'il a VU EN CLASSE, ce qui reste à travailler, et — quand `onSetChapters`
 * est fourni — de quoi cocher les chapitres vus.
 *
 * Aucun seuil ici : `level`, `status` et `seen` sont lus tels que `get_study_report` les rend.
 * L'élève et son parent lisent donc exactement la même chose.
 */
export function StudySubjects({
  report,
  audience,
  onSetChapters,
  savingSubjectId = null,
  errorSubjectId = null,
}: {
  report: StudyReport;
  audience: "student" | "parent";
  /** Déclare les chapitres vus d'une matière. Absent : le bilan se lit sans se modifier. */
  onSetChapters?: (subjectId: string, chapterIds: string[]) => void;
  savingSubjectId?: string | null;
  errorSubjectId?: string | null;
}) {
  const t = useStudyT().study;

  return (
    <div className="space-y-4" data-testid="study-subjects">
      <h3 className="text-foreground flex items-center gap-2 font-semibold">
        <BarChart3 className="h-5 w-5 text-[color:var(--gold)]" />
        {t.levels.title}
      </h3>

      {report.subjects.map((subject) => {
        const acquired = subject.seenMastered + subject.seenAcquired;
        const toWork = subject.chapters ? chaptersToWork(subject.chapters) : [];
        const saving = savingSubjectId === subject.id;
        return (
          <article
            key={subject.id}
            data-testid="study-subject"
            className="bg-surface-2 border-border/50 rounded-xl border p-4"
          >
            <div className="flex flex-wrap items-center justify-between gap-2">
              <h4 className="text-foreground font-semibold" dir="auto">
                {subject.name}
              </h4>
              <span
                data-testid="study-level"
                className={`rounded-full border px-3 py-0.5 text-xs font-bold ${LEVEL_TONE[subject.level]}`}
              >
                {t.levels.level[subject.level]}
              </span>
            </div>

            <p className="text-muted-foreground mt-2 text-sm">
              {subject.recentAvgScore !== null && subject.level !== "non-evalue"
                ? t.levels.recent
                    .replace("{score}", ltr(String(subject.recentAvgScore)))
                    .replace("{n}", String(subject.recentAttempts))
                : t.levels.noRecent}
            </p>
            <p className="text-muted-foreground mt-1 text-sm">
              {t.levels.seen
                .replace("{done}", String(acquired))
                .replace("{seen}", String(subject.chaptersSeen))}
            </p>
            {subject.exam && (
              <p className="text-muted-foreground mt-1 text-sm" data-testid="study-exam">
                {t.levels.exam.replace("{mark}", ltr(String(examMarkOutOf20(subject.exam))))}
              </p>
            )}

            {subject.chapters && (
              <>
                <div className="mt-4">
                  <div className="text-foreground flex items-center gap-2 text-sm font-semibold">
                    <Target className="h-4 w-4 text-[color:var(--gold)]" />
                    {t.work.title}
                  </div>
                  {toWork.length === 0 ? (
                    <p className="text-muted-foreground mt-1 text-sm">{t.work.empty}</p>
                  ) : (
                    <ul className="mt-2 space-y-1">
                      {toWork.map((chapter) => (
                        <li
                          key={chapter.id}
                          data-testid="study-to-work"
                          className="bg-surface-3 border-border/40 flex flex-wrap items-baseline justify-between gap-x-3 rounded-lg border px-3 py-2 text-sm"
                        >
                          <span className="min-w-0 flex-1" dir="auto">
                            {chapter.title}
                          </span>
                          <span className="text-muted-foreground text-xs">
                            {`${t.work.status[chapter.status]} · ${t.work.missing
                              .replace("{n}", String(chapter.missingForNext))
                              .replace("{star}", String(chapter.nextStar))}`}
                          </span>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>

                <details className="mt-4" data-testid="study-class-chapters">
                  <summary className="text-foreground flex cursor-pointer items-center gap-2 text-sm font-semibold">
                    <ListChecks className="h-4 w-4 text-[color:var(--gold)]" />
                    {t.classChapters.title[audience]}
                    <span className="text-muted-foreground text-xs font-normal">
                      {subject.declared
                        ? t.classChapters.declared
                            .replace("{seen}", String(subject.chaptersSeen))
                            .replace("{total}", String(subject.chaptersTotal))
                        : t.classChapters.estimated}
                    </span>
                  </summary>
                  {onSetChapters && (
                    <p className="text-muted-foreground mt-2 text-xs">
                      {t.classChapters.hint[audience]}
                    </p>
                  )}
                  {errorSubjectId === subject.id && (
                    <p role="alert" className="text-flame-ink mt-2 text-xs">
                      {t.classChapters.error}
                    </p>
                  )}
                  <ul className="mt-2 space-y-1">
                    {subject.chapters.map((chapter) => (
                      <li key={chapter.id} className="flex items-center gap-2 text-sm">
                        <label className="flex min-w-0 flex-1 items-center gap-2">
                          <input
                            type="checkbox"
                            className="h-4 w-4 shrink-0 accent-[color:var(--gold)]"
                            checked={chapter.seen}
                            disabled={!onSetChapters || saving}
                            onChange={() =>
                              onSetChapters?.(
                                subject.id,
                                toggleSeenChapter(subject.chapters ?? [], chapter.id),
                              )
                            }
                          />
                          <span className="min-w-0 flex-1" dir="auto">
                            {chapter.title}
                          </span>
                        </label>
                        <span className="text-muted-foreground shrink-0 text-xs">
                          {t.work.status[chapter.status]}
                        </span>
                        {onSetChapters && (
                          <button
                            type="button"
                            disabled={saving}
                            className="shrink-0 text-xs font-semibold text-[color:var(--gold)] disabled:opacity-50"
                            onClick={() =>
                              onSetChapters(
                                subject.id,
                                seenThroughChapter(subject.chapters ?? [], chapter.id),
                              )
                            }
                          >
                            {t.classChapters.through}
                          </button>
                        )}
                      </li>
                    ))}
                  </ul>
                </details>
              </>
            )}
          </article>
        );
      })}
    </div>
  );
}
