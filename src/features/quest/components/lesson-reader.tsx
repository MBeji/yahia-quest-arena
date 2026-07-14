import { Link } from "@tanstack/react-router";
import { useEffect, useMemo, useRef, useState } from "react";
import {
  BookOpen,
  Brain,
  ChevronLeft,
  ChevronRight,
  Dumbbell,
  FileText,
  Printer,
  ScrollText,
} from "lucide-react";
import { renderLesson } from "@/shared/lib/markdown";
import { asContentLang } from "@/shared/lib/lesson-blocks";
import { sanitizeSvg } from "@/shared/lib/figure";
import { isRtlText } from "@/shared/lib/utils";
import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { useT } from "@/lib/i18n";
import { exerciseRouteFor } from "../exercise-route";
import { ManuelPagesSection } from "./manuel-pages-section";

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
 * toggle, print, soft account invite — reading never requires an account. A
 * single « practise this chapter » CTA links to the chapter's first non-quiz
 * exercise (auth-aware: signed-in → scored quest, anon → free practice) so a
 * reader can go straight from the lesson to its exercises instead of bouncing
 * back to the subject hub (GAP-044). Content direction is pinned explicitly so
 * LTR content reads correctly even under an Arabic UI. Copy is i18n (fr/en/ar).
 */
export function LessonReader({
  chapterId,
  chapter,
  allChapters,
  practiceExerciseId = null,
  quizCta = null,
  isAuthenticated = false,
}: {
  chapterId: string;
  chapter: LessonReaderChapter;
  allChapters: LessonReaderSibling[];
  practiceExerciseId?: string | null;
  /** When the chapter's quiz gate is still closed for THIS visitor, the CTA
   *  targets the comprehension quiz instead of a locked exercise (audit §D-4). */
  quizCta?: { exerciseId: string } | null;
  isAuthenticated?: boolean;
}) {
  const t = useT();
  const [showSummary, setShowSummary] = useState(false);
  const [activeSection, setActiveSection] = useState<string | null>(null);
  const [zoomedFigure, setZoomedFigure] = useState<{ svg: string; label: string } | null>(null);
  const contentRef = useRef<HTMLDivElement>(null);

  const content = chapter.lesson_content;
  const summary = chapter.summary;
  const subjectData = chapter.subjects as { name_fr: string; content_language?: string } | null;
  const isRtl = subjectData?.content_language === "ar" || (content ? isRtlText(content) : false);
  // Les libellés des blocs pédagogiques suivent la langue du CONTENU, pas celle de
  // l'interface (étude 18, R-8) : un chip « PIÈGE » français dans une prose arabe RTL
  // serait une faute de composition.
  const lang = asContentLang(subjectData?.content_language, isRtl ? "ar" : "fr");

  const currentIdx = allChapters.findIndex((c) => c.id === chapterId);
  const prevChapter = currentIdx > 0 ? allChapters[currentIdx - 1] : null;
  const nextChapter =
    currentIdx >= 0 && currentIdx < allChapters.length - 1 ? allChapters[currentIdx + 1] : null;

  const showingSummary = showSummary && !!summary;
  const body = showingSummary ? summary : content;
  // renderLesson segments the body then runs ~15 regex passes + a DOMPurify sanitize;
  // memoize so a re-render that doesn't change the body (e.g. the Cours/Résumé toggle
  // landing back on the same text) doesn't re-parse + re-sanitize the whole lesson.
  const rendered = useMemo(() => (body ? renderLesson(body, { lang }) : null), [body, lang]);
  // Référence stable : le scroll-spy en dépend, un tableau neuf à chaque rendu le relancerait.
  const sections = useMemo(() => rendered?.sections ?? [], [rendered]);
  // A table of contents earns its place from two sections up; below that it is noise.
  const showToc = !showingSummary && sections.length >= 2;

  // Scroll-spy: the `#section-N` anchors have always been emitted by the renderer and
  // never used. Degrades to a plain (unhighlighted) TOC where IntersectionObserver is
  // unavailable — jsdom, older engines — rather than crashing the public reader.
  useEffect(() => {
    if (!showToc || typeof IntersectionObserver === "undefined") return;
    const headings = sections
      .map((s) => document.getElementById(s.id))
      .filter((el): el is HTMLElement => el !== null);
    if (headings.length === 0) return;

    const observer = new IntersectionObserver(
      (entries) => {
        const onScreen = entries.filter((e) => e.isIntersecting);
        if (onScreen.length > 0) setActiveSection(onScreen[0].target.id);
      },
      { rootMargin: "-15% 0px -70% 0px" },
    );
    headings.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, [rendered, showToc, sections]);

  // Agrandissement des figures (US-3). L'écouteur est DÉLÉGUÉ sur le conteneur : les
  // figures sont du HTML injecté, il n'existe aucun nœud React où accrocher un handler.
  // Le renderer leur pose `role="button"` + `tabindex="0"`, d'où le clavier.
  useEffect(() => {
    const root = contentRef.current;
    if (!root) return;

    const openFrom = (target: EventTarget | null): boolean => {
      if (!(target instanceof Element)) return false;
      const figure = target.closest(".lesson-figure");
      const plate = figure?.querySelector(".lesson-figure__plate");
      if (!figure || !plate) return false;
      // Défense en profondeur : ce SVG a déjà été assaini au rendu, mais il repasse par
      // le profil vetté avant d'être réinjecté dans le dialogue (docs/xss-rendering-policy.md).
      setZoomedFigure({
        svg: sanitizeSvg(plate.innerHTML),
        label: figure.getAttribute("aria-label") ?? "",
      });
      return true;
    };

    const onClick = (event: MouseEvent) => {
      openFrom(event.target);
    };
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key !== "Enter" && event.key !== " ") return;
      if (openFrom(event.target)) event.preventDefault();
    };

    root.addEventListener("click", onClick);
    root.addEventListener("keydown", onKeyDown);
    return () => {
      root.removeEventListener("click", onClick);
      root.removeEventListener("keydown", onKeyDown);
    };
  }, [rendered]);

  return (
    <article className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <header className="mb-6" dir={isRtl ? "rtl" : "ltr"}>
        <div className="flex items-center gap-2 text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          <BookOpen className="h-3.5 w-3.5 shrink-0" />
          <Link
            to="/matiere/$subjectId"
            params={{ subjectId: chapter.subject_id }}
            className="truncate transition hover:underline"
          >
            {subjectData?.name_fr ?? t.public.reader.defaultSubject}
          </Link>
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
              className={`rounded-md px-3 py-1.5 text-sm font-medium transition [@media(pointer:coarse)]:min-h-11 ${
                !showingSummary ? "bg-card text-primary shadow-sm" : "text-muted-foreground"
              }`}
            >
              {t.public.reader.courseTab}
            </button>
            <button
              type="button"
              data-testid="lesson-tab-summary"
              onClick={() => setShowSummary(true)}
              className={`rounded-md px-3 py-1.5 text-sm font-medium transition [@media(pointer:coarse)]:min-h-11 ${
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
          className="ml-auto inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-1.5 text-sm font-medium text-muted-foreground transition hover:border-primary/40 hover:text-primary [@media(pointer:coarse)]:min-h-11"
        >
          <Printer className="h-4 w-4" /> {t.public.reader.print}
        </button>
      </div>

      {/* Sommaire — construit en React à partir des sections retournées par le renderer,
          jamais dans la chaîne HTML injectée : aucun href n'entre donc dans le HTML
          assaini (étude 18, D-3). */}
      {showToc && (
        <nav
          aria-label={t.public.reader.toc}
          data-testid="lesson-toc"
          dir={isRtl ? "rtl" : "ltr"}
          className="mb-8 rounded-xl border border-border bg-secondary px-4 py-3 print:hidden"
        >
          <p className="mb-2 flex flex-wrap items-center gap-x-2 text-2xs font-semibold uppercase tracking-[0.16em] text-muted-foreground">
            <span>{t.public.reader.toc}</span>
            {/* « 3 figures » — un chapitre illustré l'annonce : c'est ce que l'élève cherche
                en géométrie, et ce que 12 % des cours seulement peuvent afficher aujourd'hui. */}
            {rendered && rendered.figureCount > 0 && (
              <span className="text-primary">
                ·{" "}
                {rendered.figureCount === 1
                  ? t.public.reader.figureCountOne
                  : t.public.reader.figureCount.replace("{n}", String(rendered.figureCount))}
              </span>
            )}
          </p>
          <ol className="grid gap-x-6 sm:grid-cols-2">
            {sections.map((section, i) => (
              <li key={section.id}>
                <a
                  href={`#${section.id}`}
                  className={`flex items-baseline gap-2 py-1 text-sm transition hover:text-primary ${
                    activeSection === section.id
                      ? "font-semibold text-primary"
                      : "text-muted-foreground"
                  }`}
                >
                  <span className="shrink-0 tabular-nums opacity-60">{i + 1}.</span>
                  <span className="truncate">{section.title}</span>
                </a>
              </li>
            ))}
          </ol>
        </nav>
      )}

      {rendered ? (
        <div
          ref={contentRef}
          className="lesson-content"
          dir={isRtl ? "rtl" : "ltr"}
          dangerouslySetInnerHTML={{ __html: rendered.html }}
        />
      ) : (
        <div className="rounded-2xl border border-dashed border-border bg-card px-6 py-12 text-center">
          <ScrollText className="mx-auto h-12 w-12 text-muted-foreground/40" />
          <p className="mt-3 text-muted-foreground">{t.public.reader.courseSoon}</p>
        </div>
      )}

      {/* Agrandissement d'une figure — une configuration de géométrie doit pouvoir se lire
          sur un téléphone, étiquettes comprises (US-3). Le SVG y est re-assaini. */}
      <Dialog
        open={zoomedFigure !== null}
        onOpenChange={(open) => {
          if (!open) setZoomedFigure(null);
        }}
      >
        <DialogContent className="max-w-3xl" data-testid="lesson-figure-zoom">
          <DialogTitle className="text-sm font-medium text-muted-foreground">
            {zoomedFigure?.label || t.public.reader.zoomFigure}
          </DialogTitle>
          {zoomedFigure && (
            <div
              className="lesson-figure__plate lesson-figure__plate--zoom"
              dir="ltr"
              dangerouslySetInnerHTML={{ __html: zoomedFigure.svg }}
            />
          )}
        </DialogContent>
      </Dialog>

      <ManuelPagesSection chapterId={chapterId} isAuthenticated={isAuthenticated} />

      {(quizCta || practiceExerciseId) && (
        <div className="mt-10 print:hidden">
          {quizCta ? (
            // Gate still closed for this visitor: practising would hit the locked
            // screen, so the single CTA sends them to the comprehension quiz first.
            <Link
              to={exerciseRouteFor(isAuthenticated)}
              params={{ exerciseId: quizCta.exerciseId }}
              data-testid="lesson-practice-cta"
              className="flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
            >
              <Brain className="h-4 w-4" /> {t.public.reader.quizFirstCta}
            </Link>
          ) : (
            <Link
              to={exerciseRouteFor(isAuthenticated)}
              params={{ exerciseId: practiceExerciseId as string }}
              data-testid="lesson-practice-cta"
              className="flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
            >
              <Dumbbell className="h-4 w-4" /> {t.public.reader.practiceCta}
            </Link>
          )}
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

      {/* Soft account invite — anonymous readers only: a signed-in student must
          never be told to create the account they already have (audit §B-4). */}
      {!isAuthenticated && (
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
      )}
    </article>
  );
}
