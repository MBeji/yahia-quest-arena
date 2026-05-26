import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import { ArrowLeft, BookOpen, Scroll, Sparkles } from "lucide-react";
import { getChapterLesson } from "@/lib/gamification.functions";
import { isRtlText } from "@/lib/utils";

export const Route = createFileRoute("/_authenticated/lesson/$chapterId")({
  head: () => ({ meta: [{ title: "Lesson · XP Scholars" }] }),
  component: LessonPage,
});

function LessonPage() {
  const { chapterId } = Route.useParams();
  const fetchLesson = useServerFn(getChapterLesson);
  const { data, isLoading } = useQuery({
    queryKey: ["lesson", chapterId],
    queryFn: () => fetchLesson({ data: { chapterId } }),
  });

  if (isLoading || !data) {
    return <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">Loading lesson…</div>;
  }

  const { chapter } = data;
  const content = chapter.lesson_content;
  const isRtl = content ? isRtlText(content) : false;
  const subjectData = chapter.subjects as { name_fr: string; color_token: string; icon: string } | null;

  if (!content) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-12 text-center">
        <Scroll className="mx-auto h-16 w-16 text-muted-foreground/40" />
        <h1 className="mt-4 font-display text-2xl font-bold">Lesson coming soon</h1>
        <p className="mt-2 text-muted-foreground">This chapter's lesson is being prepared by the scholars.</p>
        <Link to=".." className="mt-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-4 w-4" /> Back
        </Link>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6">
      <Link to=".." className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-4 w-4" /> Back to quests
      </Link>

      <motion.div
        initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
        className="relative overflow-hidden rounded-3xl border border-border/50 bg-card/60 backdrop-blur-xl"
      >
        {/* Header */}
        <div className="relative border-b border-border/40 bg-gradient-to-r from-[color:var(--neon-violet)]/10 to-[color:var(--neon-cyan)]/10 px-6 py-6 sm:px-8">
          <div className="absolute -right-10 -top-10 h-40 w-40 rounded-full bg-[color:var(--neon-violet)]/20 blur-3xl" />
          <div className="relative flex items-center gap-4">
            <div className="grid h-14 w-14 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon">
              <BookOpen className="h-7 w-7 text-primary-foreground" />
            </div>
            <div>
              <div className="flex items-center gap-2 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">
                <Sparkles className="h-3 w-3" />
                {subjectData?.name_fr ?? "Lesson"}
              </div>
              <h1 className="font-display text-2xl font-bold sm:text-3xl" dir={isRtlText(chapter.title) ? "rtl" : undefined}>
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
      </motion.div>
    </div>
  );
}

/** Simple markdown-to-HTML renderer for lesson content */
function renderMarkdown(md: string): string {
  let html = md
    // Escape HTML
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    // Headings
    .replace(/^### (.+)$/gm, '<h3 class="lesson-h3">$1</h3>')
    .replace(/^## (.+)$/gm, '<h2 class="lesson-h2">$1</h2>')
    .replace(/^# (.+)$/gm, '<h1 class="lesson-h1">$1</h1>')
    // Bold
    .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")
    // Italic
    .replace(/\*(.+?)\*/g, "<em>$1</em>")
    // Blockquotes
    .replace(/^&gt; (.+)$/gm, '<blockquote class="lesson-quote">$1</blockquote>')
    // Inline code / math $$
    .replace(/\$\$(.+?)\$\$/g, '<div class="lesson-math">$1</div>')
    // Horizontal rule
    .replace(/^---$/gm, '<hr class="lesson-hr" />')
    // Tables
    .replace(/^\|(.+)\|$/gm, (match) => {
      const cells = match.split("|").filter(Boolean).map((c) => c.trim());
      if (cells.every((c) => /^[-:]+$/.test(c))) return "<!--table-sep-->";
      const tag = "td";
      return `<tr>${cells.map((c) => `<${tag}>${c}</${tag}>`).join("")}</tr>`;
    })
    // Lists (simple)
    .replace(/^- (.+)$/gm, '<li class="lesson-li">$1</li>')
    .replace(/^(\d+)\. (.+)$/gm, '<li class="lesson-li lesson-oli">$2</li>');

  // Wrap consecutive <tr> in table
  html = html.replace(/((?:<tr>.*<\/tr>\n?)+)/g, '<table class="lesson-table">$1</table>');
  html = html.replace(/<!--table-sep-->\n?/g, "");

  // Wrap consecutive <li> in <ul>
  html = html.replace(/((?:<li class="lesson-li">.*<\/li>\n?)+)/g, '<ul class="lesson-ul">$1</ul>');

  // Paragraphs: lines not starting with HTML tags
  html = html
    .split("\n")
    .map((line) => {
      if (!line.trim()) return "";
      if (/^<[a-z]/.test(line) || /^<!--/.test(line)) return line;
      return `<p>${line}</p>`;
    })
    .join("\n");

  return html;
}
