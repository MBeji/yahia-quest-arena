/**
 * « Bilan et programme du jour » — le contrat de la RPC `get_study_report`
 * (migration 20261122160000_study_report.sql) et les quelques lectures pures que ses trois
 * surfaces partagent.
 *
 * POURQUOI `shared/`. Trois appelants lisent le MÊME bilan sans se connaître : le tableau de
 * bord (la carte « Programme du jour » et la bande focus), l'écran « Mon bilan » de l'élève,
 * et le suivi parental. Les features ne s'importent jamais entre elles ; le contrat vit donc
 * ici, et un seul schéma décide de ce qui est un bilan valide.
 *
 * CE FICHIER NE CALCULE AUCUN VERDICT. Le niveau d'une matière, l'état d'un chapitre, ce qui
 * est « vu en classe », la durée d'une mission et la composition du programme sont tranchés
 * en base — une seule définition, lue par l'élève et par son parent. Ici on ne fait que
 * présenter : trier ce qui reste à travailler, convertir une note sur 20, préparer la liste
 * de chapitres qu'un geste de l'élève enverra à `set_class_chapters`.
 *
 * ⚠️ PAS DE ZOD ICI : ce module est importé par des composants, et zod ne doit jamais atteindre
 * un chunk client (`check-bundle-budget.mjs`, 2026-10-31). Le schéma qui valide la RPC vit dans
 * `study-report.schema.ts`, lu par les seules server fns ; il est typé CONTRE ces types, donc
 * les deux ne peuvent pas diverger sans que `tsc` le dise.
 */
export const STUDY_LEVELS = ["non-evalue", "a-renforcer", "en-progres", "solide"] as const;
export const STUDY_CHAPTER_STATUSES = [
  "non-commence",
  "fragile",
  "en-cours",
  "acquis",
  "maitrise",
] as const;
export const STUDY_PLAN_KINDS = ["retry", "quiz", "start", "advance"] as const;

/** Les objectifs quotidiens proposés, en minutes. 30 est le PLANCHER (commande du 2026-11-22). */
export const STUDY_TARGET_OPTIONS = [30, 45, 60, 90] as const;
/** Deux matières prioritaires au plus : au-delà, « prioritaire » ne veut plus rien dire. */
export const STUDY_MAX_FOCUS = 2;

export type StudyLevel = (typeof STUDY_LEVELS)[number];
export type StudyChapterStatus = (typeof STUDY_CHAPTER_STATUSES)[number];
export type StudyPlanKind = (typeof STUDY_PLAN_KINDS)[number];

export type StudyChapter = {
  id: string;
  title: string;
  /** Vu en classe : déclaré par l'élève ou son parent, sinon estimé au calendrier. */
  seen: boolean;
  status: StudyChapterStatus;
  /** Étoile AU GRAND LIVRE (0 à 4). */
  star: number;
  missionsTotal: number;
  missionsCounted: number;
  missionsFailed: number;
  nextStar: number;
  /** Gestes avant la prochaine étoile — missions à compter, plus le quiz s'il reste dû. */
  missingForNext: number;
};

export type StudySubject = {
  id: string;
  name: string;
  contentLanguage: string | null;
  /**
   * Matière PRIORITAIRE : le programme la sert chaque jour, en premier. Absente d'une base qui
   * n'a pas encore la migration des réglages — d'où l'optionnel.
   */
  focus?: boolean;
  /** L'élève a coché des chapitres ; sinon « vu » est une estimation du calendrier. */
  declared: boolean;
  chaptersTotal: number;
  chaptersSeen: number;
  seenMastered: number;
  seenAcquired: number;
  seenInProgress: number;
  seenFragile: number;
  seenNotStarted: number;
  missionsSeenTotal: number;
  missionsSeenCounted: number;
  recentAttempts: number;
  recentAvgScore: number | null;
  level: StudyLevel;
  lastActiveAt: string | null;
  exam: { scorePoints: number; maxPoints: number; finishedAt: string } | null;
  /** `null` quand le bilan a été demandé sans le détail (tableau de bord). */
  chapters: StudyChapter[] | null;
};

export type StudyDone = {
  exerciseId: string;
  title: string;
  subjectId: string;
  chapterTitle: string | null;
  scorePct: number;
};

export type StudyPlanItem = {
  exerciseId: string;
  title: string;
  subjectId: string;
  chapterId: string;
  chapterTitle: string;
  kind: StudyPlanKind;
  difficulty: number;
  estMinutes: number;
};

export type StudyReport = {
  studentId: string;
  day: string;
  parcoursId: string | null;
  targetMinutes: number;
  /** Minutes MESURÉES aujourd'hui (hors navigation) — pas une estimation. */
  doneMinutes: number;
  weekMinutes: number;
  weekActiveDays: number;
  subjects: StudySubject[];
  today: StudyDone[];
  plan: StudyPlanItem[];
};

/** L'objectif du jour est atteint quand le temps MESURÉ couvre l'objectif. */
export function isStudyGoalReached(report: Pick<StudyReport, "doneMinutes" | "targetMinutes">) {
  return report.doneMinutes >= report.targetMinutes;
}

/** Part de l'objectif déjà faite, entre 0 et 100 — pour une jauge. */
export function studyGoalPercent(report: Pick<StudyReport, "doneMinutes" | "targetMinutes">) {
  if (report.targetMinutes <= 0) return 100;
  return Math.min(100, Math.round((report.doneMinutes / report.targetMinutes) * 100));
}

/** La durée estimée de ce qui reste au programme. */
export function studyPlanMinutes(plan: readonly Pick<StudyPlanItem, "estMinutes">[]): number {
  return plan.reduce((sum, item) => sum + item.estMinutes, 0);
}

/** Une note d'épreuve ramenée sur 20, au dixième. */
export function examMarkOutOf20(exam: { scorePoints: number; maxPoints: number }): number {
  return Math.round((exam.scorePoints / exam.maxPoints) * 200) / 10;
}

// Ce qui presse d'abord : ce qui a été raté, puis ce qui est entamé, puis ce qui n'a jamais
// été ouvert. « Acquis » et « maîtrisé » ne sont pas « à travailler ».
const WORK_ORDER: readonly StudyChapterStatus[] = ["fragile", "en-cours", "non-commence"];

/** Les chapitres VUS en classe qui restent à travailler, le plus pressant d'abord. */
export function chaptersToWork(chapters: readonly StudyChapter[]): StudyChapter[] {
  return WORK_ORDER.flatMap((status) => chapters.filter((c) => c.seen && c.status === status));
}

/** La déclaration après avoir coché ou décoché UN chapitre — la liste entière, prête à envoyer. */
export function toggleSeenChapter(chapters: readonly StudyChapter[], chapterId: string): string[] {
  return chapters.filter((c) => (c.id === chapterId ? !c.seen : c.seen)).map((c) => c.id);
}

/** « J'en suis là » : tout le programme jusqu'à ce chapitre compris, rien après. */
export function seenThroughChapter(chapters: readonly StudyChapter[], chapterId: string): string[] {
  const last = chapters.findIndex((c) => c.id === chapterId);
  if (last < 0) return chapters.filter((c) => c.seen).map((c) => c.id);
  return chapters.slice(0, last + 1).map((c) => c.id);
}

/** Applique une déclaration au bilan affiché, en attendant la relecture du serveur. */
export function withSeenChapters(
  report: StudyReport,
  subjectId: string,
  seenIds: readonly string[],
): StudyReport {
  const seen = new Set(seenIds);
  return {
    ...report,
    subjects: report.subjects.map((s) =>
      s.id !== subjectId || !s.chapters
        ? s
        : {
            ...s,
            declared: seen.size > 0,
            chaptersSeen: seen.size > 0 ? seen.size : s.chaptersSeen,
            chapters: s.chapters.map((c) => ({ ...c, seen: seen.has(c.id) })),
          },
    ),
  };
}

/** Les matières prioritaires du bilan, dans l'ordre du parcours. */
export function focusSubjectIds(report: Pick<StudyReport, "subjects">): string[] {
  return report.subjects.filter((s) => s.focus === true).map((s) => s.id);
}

/**
 * La liste après avoir basculé UNE matière. `null` quand le geste est refusé : on ne peut pas
 * en ajouter une troisième — la base le refuserait aussi (`set_study_preferences`).
 */
export function toggleFocusSubject(
  report: Pick<StudyReport, "subjects">,
  subjectId: string,
): string[] | null {
  const current = focusSubjectIds(report);
  if (current.includes(subjectId)) return current.filter((id) => id !== subjectId);
  if (current.length >= STUDY_MAX_FOCUS) return null;
  return report.subjects.filter((s) => s.focus === true || s.id === subjectId).map((s) => s.id);
}

/** Applique un réglage au bilan affiché, en attendant la relecture du serveur. */
export function withStudyPreferences(
  report: StudyReport,
  prefs: { dailyMinutes?: number; focusSubjectIds?: readonly string[] },
): StudyReport {
  const focus = prefs.focusSubjectIds;
  return {
    ...report,
    targetMinutes: prefs.dailyMinutes ?? report.targetMinutes,
    subjects: focus
      ? report.subjects.map((s) => ({ ...s, focus: focus.includes(s.id) }))
      : report.subjects,
  };
}
