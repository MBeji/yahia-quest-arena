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
import { useProgressT } from "@/lib/i18n/progress";
import { isRtlText } from "@/shared/lib/utils";
import { parcoursName } from "@/shared/lib/parcours-locale";
import { PageShell } from "@/components/ui/page-shell";
import { DifficultyStars } from "@/components/game/difficulty-stars";
import { QUIZ_PASS_THRESHOLD_PCT, RECALL_MIN_QUESTIONS } from "@/shared/constants/gamification";
import {
  emptyRungs,
  parseSubjectProgress,
  rungTally,
  type MissionProgress,
} from "@/shared/lib/progress-stars";
import { resolveNextAction } from "@/shared/lib/next-action";
import { groupChaptersByDomain } from "@/shared/lib/subject-domains";
import { hasPassedChapterQuiz } from "../anon-quiz-gate";
import { exerciseRouteFor } from "../exercise-route";
import { ChapterStarsChip, ChapterStarsNote } from "./chapter-stars";
import { ManuelEleveCard } from "./manuel-eleve-card";
import { SubjectSeals } from "./subject-seals";

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
  /**
   * Domaine du programme auquel ce chapitre appartient — la « section » de la
   * matière (Algèbre / Géométrie, قواعد اللغة / فهم المقروء). Écrit par l'auteur
   * du contenu, dans la langue de la matière. Déjà servi par `getSubject`
   * (`select("*")`) ; optionnel côté type parce que la colonne est nullable ET
   * parce qu'une matière non sectionnée n'en déclare aucun — le hub retombe alors
   * sur sa liste à plat (`groupChaptersByDomain` rend `null`).
   */
  domain?: string | null;
};

export type SubjectHubExercise = {
  id: string;
  chapter_id: string;
  mode: string;
  title: string;
  difficulty: number;
  xp_reward: number;
  /**
   * `admin` (catalogue) ou `parent` (mission familiale). Déjà servi par `getSubject`
   * (`select("*")`) ; déclaré depuis l'étude 22 R-15, qui exclut les missions `parent` de la
   * complétion d'un chapitre. Absent ⇒ `admin` (valeur par défaut de la colonne).
   */
  source?: string | null;
  /** Rang d'affichage dans le chapitre (R-13 : tri quiz d'abord, puis difficulté, puis ordre). */
  display_order?: number | null;
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
 * - « État de la matière » (étude 34) : les sceaux, le prochain (« 12/20 chapitres
 *   prêts »), et l'effort en compteurs — jamais un pourcentage.
 * - « Reprendre ici » (signed-in): the furthest in-progress chapter, linking
 *   straight to its next actionable mission.
 * - One ACCORDION per chapter (collapsed except the resume/first chapter) with
 *   sa JAUGE D'ÉTOILES (étude 34, R-8) et, à l'étoile 4, « Maîtrisé ✓ ».
 * - Tri-state mission rows: ✓ comptée (é34 R-3 — pas « ≥ 60 % ») · → todo (+XP,
 *   signed-in only — audit §D-3: XP shown to anonymous visitors is noise) · 🔒
 *   locked by the comprehension quiz (non-interactive; the quiz itself stays
 *   clickable, and the lock explains HOW to lift it — R-4).
 *
 * ⭐ **Rien n'est recalculé ici.** Depuis l'étude 34, l'état de chaque chapitre et
 * de chaque mission arrive tranché par `get_subject_progress` : la jauge dit
 * l'ACQUIS (grand livre, jamais décroissant), le compteur de cran dit le
 * reste-à-faire (vivant), ✨ nomme l'écart. Le hub tenait auparavant sa propre
 * copie des seuils, qui redescendait dès qu'une mission arrivait et qui avait
 * divergé sur l'anti-précipitation. Voir `docs/etoiles-et-sceaux.md`.
 *
 * Anonymous parity: same layout; the quiz-pass state merges the server map with
 * the browser-session gate (anon-quiz-gate), read after mount so SSR and the
 * first client render agree. Exercise links stay auth-aware (`exerciseRouteFor`).
 * Sans compte, `progress` est `null` : on garde la FORME des chapitres (leurs
 * crans, éteints) et une promesse en une ligne, sans rien calculer (R-16).
 * Data comes from `getSubject` (progress, quizPassedByChapter, parcours) — une
 * RPC, pas une de plus. Copy is i18n (fr/en/ar + catalogue paresseux `progress/`).
 */
export function SubjectHub({
  subject,
  chapters,
  exercises,
  progress: rawProgress = null,
  quizPassedByChapter = {},
  parcours = null,
  recall = null,
  isAuthenticated,
  unrestricted = false,
}: {
  subject: SubjectHubSubject;
  chapters: SubjectHubChapter[];
  exercises: SubjectHubExercise[];
  /**
   * La charge de `get_subject_progress` (étude 34), telle que `getSubject` la
   * rend : étoiles inscrites, sceaux, effort, état de chaque mission. `null` pour
   * l'anonyme et sur une RPC en échec — le hub retombe alors sur l'expérience
   * publique, qui est complète (R-16), plutôt que d'inventer une progression.
   */
  progress?: unknown;
  quizPassedByChapter?: Record<string, boolean>;
  parcours?: SubjectHubParcours | null;
  recall?: SubjectHubRecall | null;
  isAuthenticated: boolean;
  /**
   * Accès de TEST (compte admin, 2026-09-05) : `getSubject` a déjà marqué chaque
   * porte ouverte (quest.access.ts) — le hub n'a rien à recalculer, il le DIT.
   * Sans ce bandeau, un testeur qui voit toutes les missions ouvertes croirait la
   * porte du quiz cassée pour les élèves.
   */
  unrestricted?: boolean;
}) {
  const t = useProgressT();
  const { locale } = useI18n();
  const isRtl = subject.content_language === "ar";
  const exerciseTo = exerciseRouteFor(isAuthenticated);

  // Le grand livre, lu UNE fois. `null` = anonyme (ou RPC en échec) : tout ce qui
  // suit le traite comme « pas de compte », jamais comme « zéro ».
  const progress = useMemo(() => parseSubjectProgress(rawProgress), [rawProgress]);

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
      // R-13 : le quiz d'abord, puis les missions par (difficulté, ordre d'affichage) — la
      // progression recommandée ⭐ → ⭐⭐ → ⭐⭐⭐ (boss) → ⭐⭐⭐⭐ (défi) se lit dans la liste.
      const chapEx = exercises
        .filter((e) => e.chapter_id === c.id)
        .sort((a, b) => {
          if ((a.mode === "quiz") !== (b.mode === "quiz")) return a.mode === "quiz" ? -1 : 1;
          if (a.difficulty !== b.difficulty) return a.difficulty - b.difficulty;
          return (a.display_order ?? 0) - (b.display_order ?? 0);
        });
      const quiz = chapEx.find((e) => e.mode === "quiz") ?? null;
      // No quiz (or a non-gated theme: the server pre-marks those chapters true)
      // means the chapter is open; anonymous session passes merge on top.
      const unlocked = !quiz || quizPassedByChapter[c.id] === true || anonPassed[c.id] === true;
      // ⭐ Étude 34 : l'état du chapitre ne se RECALCULE plus, il se lit. `star` vient du
      // grand livre (il ne redescend jamais), `rungs` du calcul vivant (il dit le
      // reste-à-faire), et l'écart entre les deux est nommé par ✨. Sans compte, on garde
      // la FORME du chapitre — ses crans, éteints — sans rien calculer d'un élève absent.
      const chapterProgress = progress?.chapters[c.id] ?? null;
      const rungs = chapterProgress ? chapterProgress.rungs : emptyRungs(chapEx);
      const { counted: done, total } = rungTally(rungs);
      const mastered = chapterProgress?.mastered === true;
      return {
        chapter: c,
        index: ci,
        // Porté à plat sur la ligne pour que le regroupement par domaine lise la
        // même donnée que l'affichage, sans re-projeter les chapitres.
        domain: c.domain ?? null,
        chapEx,
        done,
        total,
        unlocked,
        chapterProgress,
        rungs,
        mastered,
      };
    });
  }, [chapters, exercises, progress, quizPassedByChapter, anonPassed]);

  // Les deux cartes que `resolveNextAction` attend — dérivées UNE fois du grand livre.
  // « Comptée » et « tentée » sont deux faits distincts : un chapitre tout tenté sans
  // rien réussir est commencé, et c'est bien là qu'il faut reprendre.
  const missionFlags = useMemo(() => {
    const counted: Record<string, boolean> = {};
    const attempted: Record<string, boolean> = {};
    for (const mission of Object.values(progress?.missions ?? {})) {
      counted[mission.exerciseId] = mission.counted;
      attempted[mission.exerciseId] = mission.bestClassic != null;
    }
    // La charge du serveur ne porte QUE les missions (`mode <> 'quiz'`). Or franchir
    // la porte d'un chapitre est du travail fait : sans cette boucle, un chapitre dont
    // seul le quiz est passé ne serait pas « commencé », et « Reprendre ici » renverrait
    // l'élève au début de la matière.
    for (const exercise of exercises) {
      if (exercise.mode !== "quiz") continue;
      if (progress?.chapters[exercise.chapter_id]?.quiz.cleared) attempted[exercise.id] = true;
    }
    return { counted, attempted };
  }, [progress, exercises]);

  // « Reprendre ici » (connecté) — étude 22 R-31. La cible ne se décide plus ici : elle sort du
  // moteur partagé `resolveNextAction`, celui-là même qui alimente la bande focus du dashboard.
  // Les deux écrans désignaient auparavant des cibles pouvant différer au même instant.
  // Vu depuis une matière, seule la priorité 3 (« la prochaine mission du chemin ») s'applique :
  // les révisions dues et le dernier échec sont des notions de parcours, pas de matière, et
  // c'est le dashboard qui les porte.
  const resume = useMemo(() => {
    if (!isAuthenticated) return null;
    const action = resolveNextAction({
      chapters,
      exercises,
      // Le moteur reçoit le verdict du serveur, jamais un score à re-seuiller : c'est
      // ce qui garantit que « Reprendre ici » et la jauge désignent la même mission.
      countedByExercise: missionFlags.counted,
      attemptedByExercise: missionFlags.attempted,
      quizSatisfiedByChapter: Object.fromEntries(rows.map((r) => [r.chapter.id, r.unlocked])),
    });
    if (action?.kind !== "continue") return null;
    const row = rows.find((r) => r.chapter.id === action.chapterId) ?? null;
    const next = row?.chapEx.find((e) => e.id === action.exerciseId) ?? null;
    return row && next ? { ...row, next } : null;
  }, [rows, chapters, exercises, missionFlags, isAuthenticated]);

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

  // Une matière est « sectionnée » dès que son contenu déclare des domaines de
  // programme : le hub pose alors un en-tête par domaine (Algèbre, Géométrie,
  // قواعد اللغة…) au lieu d'aligner douze chapitres à la suite. `null` — aucun
  // domaine déclaré, ou un seul pour toute la matière — et la liste reste
  // exactement celle d'avant : la bascule se fait matière par matière, au rythme
  // où le contenu est rattaché.
  const domainGroups = useMemo(() => groupChaptersByDomain(rows), [rows]);

  // Une carte de chapitre, rendue à l'identique dans les deux dispositions — la
  // liste plate et les groupes. Les dupliquer serait le meilleur moyen de les
  // laisser diverger.
  const renderChapter = ({
    chapter: c,
    index: ci,
    chapEx,
    unlocked,
    chapterProgress,
    rungs,
  }: (typeof rows)[number]) => {
    const open = openIds.has(c.id);
    return (
      <section key={c.id} className="overflow-hidden rounded-2xl border border-border bg-card">
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
          <ChapterStarsChip progress={chapterProgress} rungs={rungs} locked={!unlocked} />
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
            <ChapterStarsNote progress={chapterProgress} />
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
                  const isQuiz = ex.mode === "quiz";
                  // La charge du serveur ne porte QUE les missions : la porte du
                  // chapitre a son propre verdict (`chapter_quiz_cleared`), et c'est
                  // lui qui coche la ligne du quiz. Sans cela, un quiz déjà franchi
                  // se serait remis à promettre ses XP comme s'il restait à faire.
                  const mission: MissionProgress | null = isQuiz
                    ? null
                    : (progress?.missions[ex.id] ?? null);
                  const done = isQuiz
                    ? chapterProgress?.quiz.cleared === true
                    : mission?.counted === true;
                  const best = mission?.bestClassic ?? null;
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
                        // No opacity modifier on muted-foreground: the token
                        // IS the muted step already, and diluting it drove
                        // 14px body text to 2.66:1 on white (WCAG AA needs
                        // 4.5:1). Locked rows read "muted" via the padlock.
                        className="flex items-center gap-2 py-2.5 text-sm text-muted-foreground"
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
                        {/* ⭐ Le ✓ dit « comptée pour une étoile » (é34 R-3), pas
                            « ≥ 60 % » : une réussite expédiée montre son score sans
                            cocher, et la note du chapitre dit pourquoi. */}
                        {done ? (
                          <Check className="h-4 w-4 shrink-0 text-success" />
                        ) : (
                          <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground rtl:-scale-x-100" />
                        )}
                        {title}
                        {/* R-13 : la difficulté se lit en ⭐, pas dans le titre. Le quiz
                                  n'en a pas — ce n'est pas une mission mais la porte du chapitre. */}
                        {!isQuiz && <DifficultyStars level={ex.difficulty} className="shrink-0" />}
                        {mission?.isNew && (
                          <span
                            data-testid="mission-new"
                            aria-label={t.progress.newMissions.replace("{n}", "1")}
                            className="shrink-0 text-xs"
                          >
                            ✨
                          </span>
                        )}
                        <span className="shrink-0 text-xs text-muted-foreground">
                          {best != null ? (
                            <span
                              className={
                                done ? "font-bold text-success" : "font-bold text-muted-foreground"
                              }
                            >
                              {Math.round(best)}%
                            </span>
                          ) : isQuiz && !unlocked ? (
                            <span className="font-semibold text-primary">
                              {t.public.subject.unlocksChapter}
                            </span>
                          ) : done ? null : isAuthenticated ? (
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
  };

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

      {unrestricted && (
        <p
          role="status"
          data-testid="hub-unrestricted"
          className="mb-6 rounded-xl border border-dashed border-(--gold)/40 bg-(--gold)/5 px-3 py-2 text-xs font-semibold text-(--gold)"
        >
          🧪 {t.public.subject.unrestrictedBanner}
        </p>
      )}

      <SubjectSeals progress={progress} />

      <ManuelEleveCard manuelRefs={subject.manuel_refs} />

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

      {domainGroups ? (
        <div className="space-y-7">
          {domainGroups.map((group) => {
            // L'en-tête ne porte que ce qu'un élève cherche du regard : le nom du
            // domaine, et où il en est dedans. Le détail par chapitre est déjà
            // dans les cartes, il n'a pas à être répété deux fois.
            const label = group.label ?? t.public.subject.otherChapters;
            const doneChapters = group.chapters.filter((r) => r.mastered).length;
            // La clé porte des espaces (et « : » pour le fourre-tout) : un id
            // doit rester utilisable tel quel, aussi comme sélecteur.
            const headingId = `domain-${group.key.replace(/[^\p{L}\p{N}]+/gu, "-")}`;
            return (
              <section key={group.key} aria-labelledby={headingId} data-testid="domain-group">
                <div className="mb-3 flex items-center gap-3">
                  <h2
                    id={headingId}
                    // Le fourre-tout n'est pas un domaine : il se lit en encre
                    // sourde, sans l'accent que portent les vrais en-têtes.
                    className={`font-display text-sm font-bold uppercase tracking-[0.14em] ${
                      group.label ? "text-primary" : "text-muted-foreground"
                    }`}
                    dir={isRtlText(label) ? "rtl" : "ltr"}
                  >
                    {label}
                  </h2>
                  <span className="h-px flex-1 bg-border" aria-hidden="true" />
                  <span className="shrink-0 text-2xs font-bold text-muted-foreground">
                    {t.public.subject.chaptersProgress
                      .replace("{done}", String(doneChapters))
                      .replace("{total}", String(group.chapters.length))}
                  </span>
                </div>
                <div className="space-y-3">{group.chapters.map(renderChapter)}</div>
              </section>
            );
          })}
        </div>
      ) : (
        <div className="space-y-3">{rows.map(renderChapter)}</div>
      )}
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
        // Undiluted muted-foreground — see the locked-mission row above: stacking
        // an opacity modifier on the muted token fails WCAG AA on white.
        className="flex items-center gap-2 border-t border-dashed border-border/50 py-2.5 text-sm text-muted-foreground"
        data-testid="recall-chip-locked"
      >
        <Lock className="h-4 w-4 shrink-0" />
        {label}
        <span className="shrink-0 text-xs text-muted-foreground">{hint}</span>
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
