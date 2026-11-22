import { BarChart3, ListChecks, Star, Target } from "lucide-react";

import { useI18n } from "@/lib/i18n";
import { useStudyT } from "@/lib/i18n/study";
import { formatScoreOn20 } from "@/shared/constants/placement";
import {
  chaptersToWork,
  examMarkOutOf20,
  seenThroughChapter,
  toggleFocusSubject,
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
  onSetFocus,
  savingFocus = false,
  focusError = false,
}: {
  report: StudyReport;
  audience: "student" | "parent";
  /** Déclare les chapitres vus d'une matière. Absent : le bilan se lit sans se modifier. */
  onSetChapters?: (subjectId: string, chapterIds: string[]) => void;
  savingSubjectId?: string | null;
  errorSubjectId?: string | null;
  /** Règle les matières prioritaires (deux au plus). Absent : elles se lisent sans se régler. */
  onSetFocus?: (subjectIds: string[]) => void;
  savingFocus?: boolean;
  focusError?: boolean;
}) {
  const { locale } = useI18n();
  const t = useStudyT().study;

  return (
    <div className="space-y-4" data-testid="study-subjects">
      <h3 className="text-foreground flex items-center gap-2 font-semibold">
        <BarChart3 className="h-5 w-5 text-[color:var(--gold)]" />
        {t.levels.title}
      </h3>
      {onSetFocus && (
        <p className="text-muted-foreground text-xs" data-testid="study-focus-hint">
          {t.focus.hint[audience]}
        </p>
      )}
      {focusError && (
        <p role="alert" className="text-flame-ink text-xs">
          {t.focus.error}
        </p>
      )}

      {report.subjects.map((subject) => {
        const acquired = subject.seenMastered + subject.seenAcquired;
        const toWork = subject.chapters ? chaptersToWork(subject.chapters) : [];
        const saving = savingSubjectId === subject.id;
        const focused = subject.focus === true;
        const nextFocus = toggleFocusSubject(report, subject.id);
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
              <div className="flex items-center gap-2">
                {onSetFocus ? (
                  <button
                    type="button"
                    data-testid="study-focus-toggle"
                    aria-pressed={focused}
                    // Une troisième matière ne se choisit pas : il faut d'abord en libérer une.
                    disabled={savingFocus || nextFocus === null}
                    onClick={() => nextFocus && onSetFocus(nextFocus)}
                    className={`inline-flex items-center gap-1 rounded-full border px-2.5 py-0.5 text-xs font-semibold transition disabled:opacity-40 ${
                      focused
                        ? "border-[color:var(--gold)] bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                        : "border-border/60 text-muted-foreground hover:border-[color:var(--gold)]/50"
                    }`}
                  >
                    <Star className={`h-3.5 w-3.5 ${focused ? "fill-current" : ""}`} />
                    {focused ? t.focus.active : t.focus.toggle}
                  </button>
                ) : (
                  focused && (
                    <span
                      data-testid="study-focus-badge"
                      className="inline-flex items-center gap-1 rounded-full border border-[color:var(--gold)] px-2.5 py-0.5 text-xs font-semibold text-[color:var(--gold)]"
                    >
                      <Star className="h-3.5 w-3.5 fill-current" />
                      {t.focus.active}
                    </span>
                  )
                )}
                <span
                  data-testid="study-level"
                  className={`rounded-full border px-3 py-0.5 text-xs font-bold ${LEVEL_TONE[subject.level]}`}
                >
                  {t.levels.level[subject.level]}
                </span>
              </div>
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
                {t.levels.exam.replace(
                  "{mark}",
                  ltr(`${formatScoreOn20(examMarkOutOf20(subject.exam), locale)}/20`),
                )}
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
                          className="bg-surface-3 border-border/40 rounded-lg border px-3 py-2 text-sm"
                        >
                          {/* Le titre sur sa ligne, l'état dessous : côte à côte sur
                              téléphone, le titre se retrouvait à un mot par ligne. */}
                          <div dir="auto">{chapter.title}</div>
                          <div className="text-muted-foreground mt-0.5 text-xs">
                            {`${t.work.status[chapter.status]} · ${t.work.missing
                              .replace("{n}", String(chapter.missingForNext))
                              .replace("{star}", String(chapter.nextStar))}`}
                          </div>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>

                <details className="mt-4" data-testid="study-class-chapters">
                  <summary className="text-foreground cursor-pointer text-sm font-semibold">
                    <span className="inline-flex items-center gap-2 align-middle">
                      <ListChecks className="h-4 w-4 text-[color:var(--gold)]" />
                      {t.classChapters.title[audience]}
                    </span>
                    <span className="text-muted-foreground mt-1 block text-xs font-normal">
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
                      <li key={chapter.id} className="flex items-start gap-2 py-1 text-sm">
                        <label className="flex min-w-0 flex-1 items-start gap-2">
                          <input
                            type="checkbox"
                            className="mt-0.5 h-4 w-4 shrink-0 accent-[color:var(--gold)]"
                            checked={chapter.seen}
                            disabled={!onSetChapters || saving}
                            onChange={() =>
                              onSetChapters?.(
                                subject.id,
                                toggleSeenChapter(subject.chapters ?? [], chapter.id),
                              )
                            }
                          />
                          <span className="min-w-0 flex-1">
                            <span className="block" dir="auto">
                              {chapter.title}
                            </span>
                            <span className="text-muted-foreground block text-xs">
                              {t.work.status[chapter.status]}
                            </span>
                          </span>
                        </label>
                        {onSetChapters && (
                          <button
                            type="button"
                            disabled={saving}
                            className="mt-0.5 shrink-0 text-xs font-semibold text-[color:var(--gold)] disabled:opacity-50"
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
