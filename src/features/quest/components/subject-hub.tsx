import { Link } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import {
  ArrowLeft,
  BookOpen,
  Check,
  ChevronDown,
  ChevronRight,
  Lock,
  Play,
  Zap,
} from "lucide-react";
import { useI18n, useT } from "@/lib/i18n";
import { isRtlText } from "@/shared/lib/utils";
import { parcoursName } from "@/shared/lib/parcours-locale";
import { PageShell } from "@/components/ui/page-shell";
import { QUIZ_PASS_THRESHOLD_PCT, RECALL_MIN_QUESTIONS } from "@/shared/constants/gamification";
import { hasPassedChapterQuiz } from "../anon-quiz-gate";
import { exerciseRouteFor } from "../exercise-route";
import { ManuelEleveCard } from "./manuel-eleve-card";

export type SubjectHubSubject = {
  name_fr: string;
  attribute: string | null;
  description: string | null;
  content_language?: string | null;
  /** `subjects.manuel_refs` JSONB — parsed (defensively) by ManuelEleveCard. */
  manuel_refs?: unknown;
};

export type SubjectHubChapter = {
  id: string;
  title: string;
  description: string | null;
};

export type SubjectHubExercise = {
  id: string;
  chapter_id: string;
  mode: string;
  title: string;
  difficulty: number;
  xp_reward: number;
};

export type SubjectHubParcours = {
  id: string;
  name_fr: string;
  name_en?: string | null;
  name_ar?: string | null;
};

/**
 * Per-mission recall availability (étude 17), from getSubject().recall. Drives
 * the "🧠 Rappel" dedicated mission row: eligible count (>= RECALL_MIN_QUESTIONS
 * to surface it), unlocked (classic mastered → the row links to the recall run),
 * and the best recall score so far. Resolved for EVERYONE — anon included
 * (override de R-9, 2026-07-15): the row is DISCOVERABLE while signed out, shown
 * locked with a "connecte-toi et finis à 100 %" reason. Eligibility is content-
 * derived (no account data); unlocked/best stay account concepts (false/absent
 * for anon).
 */
export type SubjectHubRecall = {
  eligibleByExercise: Record<string, number>;
  unlockedByExercise: Record<string, boolean>;
  bestByExercise: Record<string, number>;
};

/**
 * Public subject hub — « Référence » register, RECOMPOSED by étude 15 lot 7
 * (D-6, the "L2" layer deferred at chantier C8 and never built): the pivot
 * screen finally carries its gameplay state.
 *
 * - Level anchor + way back up: kicker = the CLASS (localized parcours name,
 *   not the RPG attribute), breadcrumb link to `/niveau/$parcoursId`.
 * - « Reprendre ici » (signed-in): the furthest in-progress chapter, linking
 *   straight to its next actionable mission.
 * - One ACCORDION per chapter (collapsed except the resume/first chapter) with
 *   a state chip: `{n}/{n} ✓` · `quiz ✓ · {done}/{n}` · `🔒 quiz to pass` · todo.
 * - Tri-state mission rows: ✓ done (best score) · → todo (+XP, signed-in only —
 *   audit §D-3: XP shown to anonymous visitors is noise) · 🔒 locked by the
 *   comprehension quiz (non-interactive; the quiz itself stays clickable, and
 *   the lock explains HOW to lift it — R-4).
 *
 * Anonymous parity: same layout; the quiz-pass state merges the server map with
 * the browser-session gate (anon-quiz-gate), read after mount so SSR and the
 * first client render agree. Exercise links stay auth-aware (`exerciseRouteFor`).
 * Data comes from `getSubject` (bestByExercise, quizPassedByChapter, parcours) —
 * no new RPC. Copy is i18n (fr/en/ar).
 */
export function SubjectHub({
  subject,
  chapters,
  exercises,
  bestByExercise = {},
  quizPassedByChapter = {},
  parcours = null,
  recall = null,
  isAuthenticated,
}: {
  subject: SubjectHubSubject;
  chapters: SubjectHubChapter[];
  exercises: SubjectHubExercise[];
  bestByExercise?: Record<string, number>;
  quizPassedByChapter?: Record<string, boolean>;
  parcours?: SubjectHubParcours | null;
  recall?: SubjectHubRecall | null;
  isAuthenticated: boolean;
}) {
  const t = useT();
  const { locale } = useI18n();
  const isRtl = subject.content_language === "ar";
  const exerciseTo = exerciseRouteFor(isAuthenticated);

  // Anonymous quiz passes live in sessionStorage — read after mount only, so
  // SSR and the first client render agree (same pattern as the course reader).
  const [anonPassed, setAnonPassed] = useState<Record<string, boolean>>({});
  useEffect(() => {
    if (isAuthenticated) return;
    const passed: Record<string, boolean> = {};
    for (const c of chapters) if (hasPassedChapterQuiz(c.id)) passed[c.id] = true;
    setAnonPassed(passed);
  }, [isAuthenticated, chapters]);

  const rows = useMemo(() => {
    return chapters.map((c, ci) => {
      const chapEx = exercises.filter((e) => e.chapter_id === c.id);
      const quiz = chapEx.find((e) => e.mode === "quiz") ?? null;
      const done = chapEx.filter((e) => bestByExercise[e.id] != null).length;
      const total = chapEx.length;
      // No quiz (or a non-gated theme: the server pre-marks those chapters true)
      // means the chapter is open; anonymous session passes merge on top.
      const unlocked = !quiz || quizPassedByChapter[c.id] === true || anonPassed[c.id] === true;
      const allDone = total > 0 && done === total;
      // Next actionable mission: the first not-done row that is clickable in the
      // current lock state (the quiz when locked, any mission otherwise).
      const next = !unlocked ? quiz : (chapEx.find((e) => bestByExercise[e.id] == null) ?? null);
      return { chapter: c, index: ci, chapEx, quiz, done, total, unlocked, allDone, next };
    });
  }, [chapters, exercises, bestByExercise, quizPassedByChapter, anonPassed]);

  // « Reprendre ici » (signed-in): furthest chapter with progress but not done;
  // fallback: first unfinished chapter with anything to do.
  const resume = useMemo(() => {
    if (!isAuthenticated) return null;
    const started = [...rows].reverse().find((r) => r.done > 0 && !r.allDone && r.next);
    return started ?? rows.find((r) => !r.allDone && r.next) ?? null;
  }, [rows, isAuthenticated]);

  // Accordions: everything collapsed except the resume chapter (or the first).
  const [openIds, setOpenIds] = useState<Set<string>>(
    () => new Set([resume?.chapter.id ?? chapters[0]?.id].filter(Boolean) as string[]),
  );
  function toggle(id: string) {
    setOpenIds((prev) => {
      const nextSet = new Set(prev);
      if (nextSet.has(id)) nextSet.delete(id);
      else nextSet.add(id);
      return nextSet;
    });
  }

  const quizContract = t.public.subject.quizContract.replace(
    "{pct}",
    String(QUIZ_PASS_THRESHOLD_PCT),
  );

  return (
    <PageShell dir={isRtl ? "rtl" : "ltr"}>
      <header className="mb-6">
        {parcours && (
          <Link
            to="/niveau/$parcoursId"
            params={{ parcoursId: parcours.id }}
            className="inline-flex items-center gap-1.5 text-sm font-medium text-muted-foreground transition hover:text-primary"
          >
            <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {parcoursName(parcours, locale)}
          </Link>
        )}
        {parcours && (
          <div className="mt-3 text-xs font-semibold uppercase tracking-[0.2em] text-primary">
            {parcoursName(parcours, locale)}
          </div>
        )}
        <h1
          className="mt-1 font-display text-3xl font-bold leading-tight sm:text-4xl"
          dir={isRtlText(subject.name_fr) ? "rtl" : "ltr"}
        >
          {subject.name_fr}
        </h1>
        {subject.description && <p className="mt-2 text-muted-foreground">{subject.description}</p>}
      </header>

      <ManuelEleveCard manuelRefs={subject.manuel_refs} isAuthenticated={isAuthenticated} />

      {resume && resume.next && (
        <Link
          to={exerciseTo}
          params={{ exerciseId: resume.next.id }}
          data-testid="hub-resume"
          className="mb-6 flex items-center gap-3 rounded-xl border border-primary/35 bg-primary/5 p-3 transition hover:border-primary/60 [@media(pointer:coarse)]:min-h-11"
        >
          <span className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-primary text-primary-foreground">
            <Play className="h-4 w-4" />
          </span>
          <span className="min-w-0 flex-1">
            <span className="block text-sm font-bold">{t.public.subject.resumeHere}</span>
            <span
              className="block truncate text-xs text-muted-foreground"
              dir={isRtlText(resume.chapter.title) ? "rtl" : "ltr"}
            >
              {resume.chapter.title} ·{" "}
              {t.public.subject.missionsProgress
                .replace("{done}", String(resume.done))
                .replace("{total}", String(resume.total))}
            </span>
          </span>
          <ChevronRight className="h-5 w-5 shrink-0 text-primary rtl:-scale-x-100" />
        </Link>
      )}

      <div className="space-y-3">
        {rows.map(({ chapter: c, index: ci, chapEx, quiz, done, total, unlocked, allDone }) => {
          const open = openIds.has(c.id);
          const chip = allDone
            ? { cls: "bg-success/12 text-success", text: `${done}/${total} ✓` }
            : !unlocked
              ? {
                  cls: "bg-[color:var(--flame)]/12 text-[color:var(--flame)]",
                  text: `🔒 ${t.public.subject.quizToPass}`,
                }
              : done > 0
                ? {
                    cls: "bg-success/12 text-success",
                    text: quiz ? `quiz ✓ · ${done}/${total}` : `${done}/${total}`,
                  }
                : { cls: "bg-muted text-muted-foreground", text: t.public.subject.todo };
          return (
            <section
              key={c.id}
              className="overflow-hidden rounded-2xl border border-border bg-card"
            >
              <button
                type="button"
                onClick={() => toggle(c.id)}
                aria-expanded={open}
                className="flex w-full items-center gap-3 px-4 py-3 text-start transition hover:bg-secondary/50 [@media(pointer:coarse)]:min-h-11"
              >
                <span className="shrink-0 text-2xs font-bold uppercase tracking-wider text-muted-foreground">
                  {t.public.subject.chapter.replace("{n}", String(ci + 1))}
                </span>
                <span
                  className="min-w-0 flex-1 truncate font-display text-base font-bold"
                  dir={isRtlText(c.title) ? "rtl" : "ltr"}
                >
                  {c.title}
                </span>
                <span
                  className={`shrink-0 rounded-full px-2 py-0.5 text-2xs font-bold ${chip.cls}`}
                >
                  {chip.text}
                </span>
                <ChevronDown
                  className={`h-4 w-4 shrink-0 text-muted-foreground transition-transform ${open ? "rotate-180" : ""}`}
                />
              </button>

              {open && (
                <div className="border-t border-border px-4 pb-3">
                  {c.description && (
                    <p
                      className="mt-2 text-sm text-muted-foreground"
                      dir={isRtlText(c.description) ? "rtl" : "ltr"}
                    >
                      {c.description}
                    </p>
                  )}
                  <Link
                    to="/chapitre/$chapterId"
                    params={{ chapterId: c.id }}
                    className="mt-2 inline-flex items-center gap-1.5 text-sm font-bold text-primary transition hover:opacity-80 [@media(pointer:coarse)]:min-h-11"
                  >
                    <BookOpen className="h-4 w-4" /> {t.public.subject.readCourse}
                  </Link>

                  {chapEx.length > 0 && (
                    <ul className="mt-1 divide-y divide-border/60 border-t border-border/60">
                      {chapEx.map((ex) => {
                        const best = bestByExercise[ex.id];
                        const isQuiz = ex.mode === "quiz";
                        const lockedRow = !unlocked && !isQuiz;
                        const title = (
                          <span
                            className="min-w-0 flex-1 truncate"
                            dir={isRtlText(ex.title) ? "rtl" : "ltr"}
                          >
                            {isQuiz ? "🧠 " : ""}
                            {ex.title}
                          </span>
                        );
                        if (lockedRow) {
                          return (
                            <li
                              key={ex.id}
                              className="flex items-center gap-2 py-2.5 text-sm text-muted-foreground/60"
                            >
                              <Lock className="h-3.5 w-3.5 shrink-0" />
                              {title}
                              <span className="shrink-0 text-xs">—</span>
                            </li>
                          );
                        }
                        return (
                          <li key={ex.id}>
                            <Link
                              to={exerciseTo}
                              params={{ exerciseId: ex.id }}
                              className="flex items-center gap-2 py-2.5 text-sm transition hover:text-primary [@media(pointer:coarse)]:min-h-11"
                            >
                              {best != null ? (
                                <Check className="h-4 w-4 shrink-0 text-success" />
                              ) : (
                                <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground rtl:-scale-x-100" />
                              )}
                              {title}
                              <span className="shrink-0 text-xs text-muted-foreground">
                                {best != null ? (
                                  <span className="font-bold text-success">
                                    {Math.round(best)}%
                                  </span>
                                ) : isQuiz && !unlocked ? (
                                  <span className="font-semibold text-primary">
                                    {t.public.subject.unlocksChapter}
                                  </span>
                                ) : isAuthenticated ? (
                                  <span className="flex items-center gap-0.5 font-semibold text-primary">
                                    <Zap className="h-3 w-3" />+{ex.xp_reward} XP
                                  </span>
                                ) : null}
                              </span>
                            </Link>
                            <RecallMissionRow
                              exerciseId={ex.id}
                              title={ex.title}
                              isQuiz={isQuiz}
                              isAuthenticated={isAuthenticated}
                              recall={recall}
                            />
                          </li>
                        );
                      })}
                    </ul>
                  )}

                  {!unlocked && (
                    <p className="mt-2 rounded-lg border border-[color:var(--flame)]/25 bg-[color:var(--flame)]/8 px-3 py-2 text-xs text-foreground/80">
                      🧠 {quizContract}
                    </p>
                  )}
                </div>
              )}
            </section>
          );
        })}
      </div>
    </PageShell>
  );
}

/**
 * "🧠 Rappel" dedicated mission row under its classic mission (étude 17,
 * US-2/US-6). Rendered at the same visual level as the other mission rows so the
 * recall variant is a first-class, discoverable mission — visible to EVERYONE,
 * anon included (override de R-9, 2026-07-15). States:
 *   - absent  — a quiz row, or fewer than RECALL_MIN_QUESTIONS eligible questions
 *               (no dead end: no lock, no promise);
 *   - unlocked — the classic run is mastered → a link into the recall run
 *               (`?variant=recall`), with the best recall score when it exists;
 *   - locked  — eligible but not yet unlocked → a non-interactive Lock + the
 *               one-sentence reason (signed-in: « finis à 100 % » ; anon:
 *               « connecte-toi et finis à 100 % »).
 */
function RecallMissionRow({
  exerciseId,
  title,
  isQuiz,
  isAuthenticated,
  recall,
}: {
  exerciseId: string;
  title: string;
  isQuiz: boolean;
  isAuthenticated: boolean;
  recall: SubjectHubRecall | null;
}) {
  const t = useT();
  if (isQuiz || !recall) return null;
  const eligible = recall.eligibleByExercise[exerciseId] ?? 0;
  if (eligible < RECALL_MIN_QUESTIONS) return null;
  const unlocked = recall.unlockedByExercise[exerciseId] === true;
  const bestRecall = recall.bestByExercise[exerciseId];
  const label = (
    <span className="min-w-0 flex-1 truncate" dir={isRtlText(title) ? "rtl" : "ltr"}>
      {t.quest.recallChip} · {title}
    </span>
  );

  if (!unlocked) {
    const hint = isAuthenticated ? t.quest.recallLockedHint : t.quest.recallLockedHintAnon;
    return (
      <div
        className="flex items-center gap-2 border-t border-dashed border-border/50 py-2.5 text-sm text-muted-foreground/70"
        data-testid="recall-chip-locked"
      >
        <Lock className="h-4 w-4 shrink-0" />
        {label}
        <span className="shrink-0 text-xs text-muted-foreground/60">{hint}</span>
      </div>
    );
  }
  return (
    <Link
      to="/quest/$exerciseId"
      params={{ exerciseId }}
      search={{ variant: "recall" }}
      data-testid="recall-chip-unlocked"
      className="flex items-center gap-2 border-t border-dashed border-(--gold)/30 py-2.5 text-sm font-semibold text-(--gold) transition hover:opacity-80 [@media(pointer:coarse)]:min-h-11"
    >
      <Play className="h-4 w-4 shrink-0" />
      {label}
      <span className="shrink-0 text-xs">
        {bestRecall != null ? `${Math.round(bestRecall)}%` : t.quest.recallPlay}
      </span>
    </Link>
  );
}
