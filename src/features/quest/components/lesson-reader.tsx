import { Link } from "@tanstack/react-router";
import { useState } from "react";
import { BookOpen, ChevronLeft, ChevronRight, FileText, Printer, ScrollText } from "lucide-react";
import { renderMarkdown } from "@/shared/lib/markdown";
import { isRtlText } from "@/shared/lib/utils";
import { useT } from "@/lib/i18n";

export type LessonReaderChapter = {
  title: string;
  lesson_content: string | null;
  summary: string | null;
  subject_id: string;
  /** Joined subject row; loosely typed (Supabase relation) — narrowed below. */
  subjects: unknown;
};

export type LessonReaderSibling = {
  id: string;
  title: string;
  hasLesson: boolean;
};

/**
 * Public course reader — « Référence » register (chantier C8, L1.4). Purely
 * presentational: the route fetches the lesson (anon-capable `getChapterLesson`,
 * L0.4a) and passes it in. Editorial light + teal reading skin, Cours/Résumé
 * toggle, print, soft account invite — reading never requires an account.
 * Content direction is pinned explicitly so LTR content reads correctly even
 * under an Arabic UI. Copy is i18n (fr/en/ar).
 */
export function LessonReader({
  chapterId,
  chapter,
  allChapters,
}: {
  chapterId: string;
  chapter: LessonReaderChapter;
  allChapters: LessonReaderSibling[];
}) {
  const t = useT();
  const [showSummary, setShowSummary] = useState(false);

  const content = chapter.lesson_content;
  const summary = chapter.summary;
  const subjectData = chapter.subjects as { name_fr: string; content_language?: string } | null;
  const isRtl = subjectData?.content_language === "ar" || (content ? isRtlText(content) : false);

  const currentIdx = allChapters.findIndex((c) => c.id === chapterId);
  const prevChapter = currentIdx > 0 ? allChapters[currentIdx - 1] : null;
  const nextChapter =
    currentIdx >= 0 && currentIdx < allChapters.length - 1 ? allChapters[currentIdx + 1] : null;

  const showingSummary = showSummary && !!summary;
  const body = showingSummary ? summary : content;

  return (
    <article className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <header className="mb-6" dir={isRtl ? "rtl" : "ltr"}>
        <div className="flex items-center gap-2 text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          <BookOpen className="h-3.5 w-3.5 shrink-0" />
          <span className="truncate">{subjectData?.name_fr ?? t.public.reader.defaultSubject}</span>
          {allChapters.length > 0 && (
            <span className="text-muted-foreground">
              · {currentIdx + 1}/{allChapters.length}
            </span>
          )}
        </div>
        <h1
          className="mt-2 font-display text-3xl font-bold leading-tight sm:text-4xl"
          dir={isRtlText(chapter.title) ? "rtl" : "ltr"}
        >
          {chapter.title}
        </h1>
      </header>

      <div className="mb-8 flex flex-wrap items-center gap-2 border-y border-border py-3 print:hidden">
        {summary && (
          <div className="inline-flex rounded-lg border border-border bg-secondary p-0.5">
            <button
              type="button"
              data-testid="lesson-tab-course"
              onClick={() => setShowSummary(false)}
              className={`rounded-md px-3 py-1.5 text-sm font-medium transition ${
                !showingSummary ? "bg-card text-primary shadow-sm" : "text-muted-foreground"
              }`}
            >
              {t.public.reader.courseTab}
            </button>
            <button
              type="button"
              data-testid="lesson-tab-summary"
              onClick={() => setShowSummary(true)}
              className={`rounded-md px-3 py-1.5 text-sm font-medium transition ${
                showingSummary ? "bg-card text-primary shadow-sm" : "text-muted-foreground"
              }`}
            >
              {t.public.reader.summaryTab}
            </button>
          </div>
        )}
        <button
          type="button"
          data-testid="lesson-print"
          onClick={() => window.print()}
          className="ml-auto inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-1.5 text-sm font-medium text-muted-foreground transition hover:border-primary/40 hover:text-primary"
        >
          <Printer className="h-4 w-4" /> {t.public.reader.print}
        </button>
      </div>

      {body ? (
        <div
          className="lesson-content"
          dir={isRtl ? "rtl" : "ltr"}
          dangerouslySetInnerHTML={{ __html: renderMarkdown(body) }}
        />
      ) : (
        <div className="rounded-2xl border border-dashed border-border bg-card px-6 py-12 text-center">
          <ScrollText className="mx-auto h-12 w-12 text-muted-foreground/40" />
          <p className="mt-3 text-muted-foreground">{t.public.reader.courseSoon}</p>
        </div>
      )}

      <nav className="mt-10 flex items-center justify-between gap-3 border-t border-border pt-5 print:hidden">
        {prevChapter ? (
          <Link
            to="/chapitre/$chapterId"
            params={{ chapterId: prevChapter.id }}
            className="inline-flex max-w-[46%] items-center gap-2 text-sm text-muted-foreground transition hover:text-primary"
          >
            <ChevronLeft className="h-4 w-4 shrink-0 rtl:-scale-x-100" />
            <span className="truncate">{prevChapter.title}</span>
          </Link>
        ) : (
          <span />
        )}
        {nextChapter ? (
          <Link
            to="/chapitre/$chapterId"
            params={{ chapterId: nextChapter.id }}
            className="inline-flex max-w-[46%] items-center gap-2 text-sm font-semibold text-primary transition hover:opacity-80"
          >
            <span className="truncate">{nextChapter.title}</span>
            <ChevronRight className="h-4 w-4 shrink-0 rtl:-scale-x-100" />
          </Link>
        ) : (
          <span />
        )}
      </nav>

      <aside className="mt-12 rounded-2xl border border-primary/20 bg-secondary px-6 py-7 text-center print:hidden">
        <FileText className="mx-auto h-6 w-6 text-primary" />
        <h2 className="mt-2 font-display text-lg font-bold text-foreground">
          {t.public.reader.inviteTitle}
        </h2>
        <p className="mx-auto mt-1 max-w-md text-sm text-muted-foreground">
          {t.public.reader.inviteDesc}
        </p>
        <Link
          to="/signup"
          className="mt-4 inline-flex items-center justify-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
        >
          {t.public.reader.inviteCta}
        </Link>
      </aside>
    </article>
  );
}
