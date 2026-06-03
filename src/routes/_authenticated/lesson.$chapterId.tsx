import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import {
  ArrowLeft,
  BookOpen,
  Scroll,
  Sparkles,
  ChevronLeft,
  ChevronRight,
  List,
  CheckCircle2,
  FileText,
} from "lucide-react";
import { getChapterLesson } from "@/features/quest";
import { isRtlText } from "@/shared/lib/utils";
import { renderMarkdown } from "@/shared/lib/markdown";
import { useState } from "react";

export const Route = createFileRoute("/_authenticated/lesson/$chapterId")({
  head: () => ({ meta: [{ title: "Lesson · XP Scholars" }] }),
  component: LessonPage,
});

function LessonPage() {
  const { chapterId } = Route.useParams();
  const navigate = useNavigate();
  const fetchLesson = useServerFn(getChapterLesson);
  const { data, isLoading } = useQuery({
    queryKey: ["lesson", chapterId],
    queryFn: () => fetchLesson({ data: { chapterId } }),
  });
  const [tocOpen, setTocOpen] = useState(false);
  const [showSummary, setShowSummary] = useState(false);

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center">
        <div className="flex flex-col items-center gap-3">
          <div className="h-10 w-10 animate-spin rounded-full border-2 border-[color:var(--neon-cyan)] border-t-transparent" />
          <span className="text-sm text-muted-foreground">Loading lesson…</span>
        </div>
      </div>
    );
  }

  const { chapter, allChapters } = data;
  const content = chapter.lesson_content;
  const summary = chapter.summary;
  const subjectData = chapter.subjects as {
    id: string;
    name_fr: string;
    color_token: string;
    icon: string;
    content_language?: string;
  } | null;
  const isRtlSubject =
    subjectData?.content_language === "ar" || (content ? isRtlText(content) : false);
  const isRtl = isRtlSubject;

  const currentIdx = allChapters.findIndex((c) => c.id === chapterId);
  const prevChapter = currentIdx > 0 ? allChapters[currentIdx - 1] : null;
  const nextChapter = currentIdx < allChapters.length - 1 ? allChapters[currentIdx + 1] : null;

  if (!content) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-12 text-center">
        <Scroll className="mx-auto h-16 w-16 text-muted-foreground/40" />
        <h1 className="mt-4 font-display text-2xl font-bold">Lesson coming soon</h1>
        <p className="mt-2 text-muted-foreground">
          This chapter's lesson is being prepared by the scholars.
        </p>
        <Link
          to="/subject/$subjectId"
          params={{ subjectId: chapter.subject_id }}
          className="mt-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> Back to subject
        </Link>
      </div>
    );
  }

  // Extract headings for TOC
  const headings = Array.from(content.matchAll(/^##\s+(.+)$/gm)).map((m) => m[1]);

  return (
    <div className="mx-auto max-w-5xl px-4 py-6 sm:px-6" dir={isRtl ? "rtl" : undefined}>
      {/* Top navigation bar */}
      <div className="mb-4 flex items-center justify-between gap-3">
        <Link
          to="/subject/$subjectId"
          params={{ subjectId: chapter.subject_id }}
          className="inline-flex items-center gap-1.5 rounded-lg border border-border/50 bg-card/60 px-3 py-2 text-sm text-muted-foreground backdrop-blur-sm transition hover:border-[color:var(--neon-cyan)]/40 hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {subjectData?.name_fr ?? "Back"}
        </Link>

        {/* Chapter progress indicator */}
        <div className="hidden items-center gap-1.5 sm:flex">
          {allChapters.map((c, i) => (
            <button
              key={c.id}
              onClick={() => navigate({ to: "/lesson/$chapterId", params: { chapterId: c.id } })}
              title={c.title}
              className={`h-2.5 rounded-full transition-all ${
                c.id === chapterId
                  ? "w-8 bg-[color:var(--neon-cyan)]"
                  : c.hasLesson
                    ? "w-2.5 bg-[color:var(--neon-cyan)]/30 hover:bg-[color:var(--neon-cyan)]/60"
                    : "w-2.5 bg-muted-foreground/20"
              }`}
            />
          ))}
        </div>

        {/* Action buttons */}
        <div className="flex items-center gap-2">
          {summary && (
            <button
              onClick={() => setShowSummary(!showSummary)}
              className={`inline-flex items-center gap-1.5 rounded-lg border px-3 py-2 text-sm backdrop-blur-sm transition ${
                showSummary
                  ? "border-[color:var(--neon-gold)]/50 bg-[color:var(--neon-gold)]/10 text-[color:var(--neon-gold)]"
                  : "border-border/50 bg-card/60 text-muted-foreground hover:border-[color:var(--neon-gold)]/40 hover:text-foreground"
              }`}
            >
              <FileText className="h-4 w-4" /> ملخّص
            </button>
          )}

          {/* TOC button */}
          {headings.length > 0 && (
            <button
              onClick={() => setTocOpen(!tocOpen)}
              className="inline-flex items-center gap-1.5 rounded-lg border border-border/50 bg-card/60 px-3 py-2 text-sm text-muted-foreground backdrop-blur-sm transition hover:border-[color:var(--neon-violet)]/40 hover:text-foreground"
            >
              <List className="h-4 w-4" /> فهرس
            </button>
          )}
        </div>
      </div>

      {/* Table of Contents dropdown */}
      {tocOpen && headings.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: -8 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-4 rounded-2xl border border-[color:var(--neon-violet)]/30 bg-card/80 p-4 backdrop-blur-xl"
          dir="rtl"
        >
          <h3 className="mb-3 flex items-center gap-2 font-display text-sm font-bold text-[color:var(--neon-violet)]">
            <List className="h-4 w-4" /> فهرس الدرس
          </h3>
          <div className="grid gap-1.5 sm:grid-cols-2">
            {headings.map((h, i) => (
              <a
                key={i}
                href={`#section-${i}`}
                onClick={() => setTocOpen(false)}
                className="flex items-center gap-2 rounded-lg px-3 py-2 text-sm transition hover:bg-[color:var(--neon-violet)]/10"
              >
                <CheckCircle2 className="h-3.5 w-3.5 text-[color:var(--neon-cyan)]" />
                <span>{h.replace(/[#*]/g, "").trim()}</span>
              </a>
            ))}
          </div>
        </motion.div>
      )}

      {/* Course summary (résumé) */}
      {summary && showSummary && (
        <motion.div
          initial={{ opacity: 0, y: -8 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-4 rounded-2xl border border-[color:var(--neon-gold)]/30 bg-card/80 p-5 backdrop-blur-xl"
          dir={isRtl ? "rtl" : undefined}
        >
          <h3 className="mb-3 flex items-center gap-2 font-display text-sm font-bold text-[color:var(--neon-gold)]">
            <FileText className="h-4 w-4" /> ملخّص الدرس
          </h3>
          <div
            className="lesson-content prose prose-invert max-w-none text-sm"
            dangerouslySetInnerHTML={{ __html: renderMarkdown(summary) }}
          />
        </motion.div>
      )}

      {/* Chapter navigation (mobile) */}
      <div className="mb-4 flex items-center justify-between sm:hidden">
        <span className="text-xs text-muted-foreground">
          {currentIdx + 1} / {allChapters.length}
        </span>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        className="relative overflow-hidden rounded-3xl border border-border/50 bg-card/60 backdrop-blur-xl"
      >
        {/* Header */}
        <div className="relative border-b border-border/40 bg-gradient-to-r from-[color:var(--neon-violet)]/10 to-[color:var(--neon-cyan)]/10 px-6 py-6 sm:px-8">
          <div className="absolute -right-10 -top-10 h-40 w-40 rounded-full bg-[color:var(--neon-violet)]/20 blur-3xl" />
          <div className="relative flex items-center gap-4">
            <div className="grid h-14 w-14 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon">
              <BookOpen className="h-7 w-7 text-primary-foreground" />
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-2 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">
                <Sparkles className="h-3 w-3" />
                {subjectData?.name_fr ?? "Lesson"}
                <span className="text-muted-foreground">·</span>
                <span className="text-muted-foreground">
                  Ch. {currentIdx + 1}/{allChapters.length}
                </span>
              </div>
              <h1
                className="font-display text-2xl font-bold sm:text-3xl"
                dir={isRtlText(chapter.title) ? "rtl" : undefined}
              >
                📖 {chapter.title}
              </h1>
            </div>
          </div>
        </div>

        {/* Content */}
        <div
          className="lesson-content prose prose-invert max-w-none px-6 py-8 sm:px-8"
          dir={isRtl ? "rtl" : undefined}
          dangerouslySetInnerHTML={{ __html: renderMarkdown(content) }}
        />

        {/* Bottom navigation */}
        <div className="border-t border-border/40 bg-gradient-to-r from-[color:var(--neon-cyan)]/5 to-[color:var(--neon-violet)]/5 px-6 py-5 sm:px-8">
          <div className="flex items-center justify-between gap-4">
            {prevChapter ? (
              <Link
                to="/lesson/$chapterId"
                params={{ chapterId: prevChapter.id }}
                className="group flex items-center gap-2 rounded-xl border border-border/50 bg-card/60 px-4 py-3 text-sm transition hover:border-[color:var(--neon-cyan)]/50 hover:bg-[color:var(--neon-cyan)]/10"
              >
                <ChevronLeft className="h-4 w-4 transition group-hover:-translate-x-0.5 rtl:-scale-x-100 rtl:group-hover:translate-x-0.5" />
                <div className="text-right" dir={isRtlText(prevChapter.title) ? "rtl" : undefined}>
                  <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                    السابق
                  </div>
                  <div className="font-semibold line-clamp-1">{prevChapter.title}</div>
                </div>
              </Link>
            ) : (
              <div />
            )}

            <Link
              to="/subject/$subjectId"
              params={{ subjectId: chapter.subject_id }}
              className="hidden items-center gap-1.5 rounded-lg border border-border/50 px-3 py-2 text-xs text-muted-foreground transition hover:border-[color:var(--neon-violet)]/40 hover:text-foreground sm:inline-flex"
            >
              <List className="h-3.5 w-3.5" /> كل الفصول
            </Link>

            {nextChapter ? (
              <Link
                to="/lesson/$chapterId"
                params={{ chapterId: nextChapter.id }}
                className="group flex items-center gap-2 rounded-xl border border-border/50 bg-card/60 px-4 py-3 text-sm transition hover:border-[color:var(--neon-violet)]/50 hover:bg-[color:var(--neon-violet)]/10"
              >
                <div dir={isRtlText(nextChapter.title) ? "rtl" : undefined}>
                  <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                    التالي
                  </div>
                  <div className="font-semibold line-clamp-1">{nextChapter.title}</div>
                </div>
                <ChevronRight className="h-4 w-4 transition group-hover:translate-x-0.5 rtl:-scale-x-100 rtl:group-hover:-translate-x-0.5" />
              </Link>
            ) : (
              <Link
                to="/subject/$subjectId"
                params={{ subjectId: chapter.subject_id }}
                className="group flex items-center gap-2 rounded-xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/10 px-4 py-3 text-sm font-semibold text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20"
              >
                🏆 أنهيت كل الدروس!
              </Link>
            )}
          </div>
        </div>
      </motion.div>

      {/* Chapters sidebar on large screens */}
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="mt-6 rounded-2xl border border-border/50 bg-card/60 p-5 backdrop-blur-xl"
        dir="rtl"
      >
        <h3 className="mb-3 flex items-center gap-2 font-display text-sm font-bold text-[color:var(--neon-cyan)]">
          <BookOpen className="h-4 w-4" /> جميع فصول {subjectData?.name_fr}
        </h3>
        <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-3">
          {allChapters.map((c, i) => (
            <Link
              key={c.id}
              to="/lesson/$chapterId"
              params={{ chapterId: c.id }}
              className={`flex items-center gap-2 rounded-xl border px-3 py-2.5 text-sm transition ${
                c.id === chapterId
                  ? "border-[color:var(--neon-cyan)]/60 bg-[color:var(--neon-cyan)]/15 font-semibold text-[color:var(--neon-cyan)]"
                  : c.hasLesson
                    ? "border-border/50 hover:border-[color:var(--neon-cyan)]/30 hover:bg-[color:var(--neon-cyan)]/5"
                    : "border-border/30 text-muted-foreground/50 pointer-events-none"
              }`}
            >
              <span
                className={`grid h-6 w-6 shrink-0 place-items-center rounded-lg text-xs font-bold ${
                  c.id === chapterId ? "bg-[color:var(--neon-cyan)]/20" : "bg-muted-foreground/10"
                }`}
              >
                {i + 1}
              </span>
              <span className="line-clamp-1">{c.title}</span>
            </Link>
          ))}
        </div>
      </motion.div>
    </div>
  );
}
