import type { ChapterGap, DailyReport } from "./daily-report";

/**
 * « 3/20 chapitres » cesse d'être un verdict et devient une action.
 *
 * LE SIGNALEMENT (2026-09-04). Le propriétaire lit « 3/20 chap. » sur la matière
 * où son fils a travaillé toute la semaine, et le comprend comme « il a fait 3
 * chapitres sur 20 ». Le chiffre était pourtant JUSTE : la barre est « toutes
 * les missions du chapitre réussies au-dessus de 60 % », et ses chapitres
 * étaient à « 4/6 missions ». Quand c'est l'auteur du produit qui se trompe en
 * lisant son propre chiffre, ce n'est pas le lecteur qui est en tort.
 *
 * Ce module ne recalcule RIEN — le serveur a déjà répondu « ce qui manque » avec
 * les prédicats de `student_parcours_progress` (migration 20260904120000). Il
 * fait la seule chose que le serveur ne peut pas faire : rattacher chaque lacune
 * à la matière que le parent voit à l'écran, et la nommer.
 */

/** Ce qui bloque un chapitre — donc la nature du geste attendu. */
export type GapBlocker = "missions" | "quiz" | "both";

export type ChapterGapRow = {
  chapterId: string;
  chapterTitle: string;
  subjectName: string;
  /** Le niveau, sans lequel « Mathématiques » apparaît autant de fois que de classes suivies. */
  gradeName: string | null;
  blocker: GapBlocker;
  missionsPassed: number;
  missionsTotal: number;
  /** Combien de missions restent à réussir. 0 quand seul le quiz bloque. */
  missionsRemaining: number;
};

/** Ce qui manque à ce chapitre, en une des trois formes possibles. */
export function gapBlocker(gap: ChapterGap): GapBlocker {
  const missionsLeft = Math.max(0, gap.missionsTotal - gap.missionsPassed);
  const quizLeft = gap.quizGated && !gap.quizSatisfied;
  if (missionsLeft > 0 && quizLeft) return "both";
  return quizLeft ? "quiz" : "missions";
}

/**
 * Les lacunes prêtes à afficher, LE PLUS PROCHE DU BUT EN PREMIER.
 *
 * L'ordre est le sujet : un chapitre à qui il ne manque que le quiz est à UN
 * geste, et personne — ni l'élève ni le parent — ne sait aujourd'hui que ce
 * geste est dû. Le montrer sous une liste de chapitres à quatre missions près
 * reviendrait à l'enterrer.
 *
 * Une lacune dont la matière n'est pas dans le rapport est écartée : elle
 * s'afficherait sans nom, et un chapitre sans matière n'aide personne.
 */
export function chapterGapRows(report: DailyReport, limit = 6): ChapterGapRow[] {
  const subjectsById = new Map(report.subjects.map((s) => [s.subjectId, s]));

  return report.chapterGaps
    .flatMap((gap) => {
      const subject = subjectsById.get(gap.subjectId);
      if (!subject) return [];
      const missionsTotal = Math.max(0, gap.missionsTotal);
      const missionsPassed = Math.min(Math.max(0, gap.missionsPassed), missionsTotal);
      return [
        {
          chapterId: gap.chapterId,
          chapterTitle: gap.title,
          subjectName: subject.name,
          gradeName: subject.gradeName,
          blocker: gapBlocker(gap),
          missionsPassed,
          missionsTotal,
          missionsRemaining: missionsTotal - missionsPassed,
        },
      ];
    })
    .sort(
      (a, b) =>
        a.missionsRemaining - b.missionsRemaining ||
        a.subjectName.localeCompare(b.subjectName) ||
        a.chapterTitle.localeCompare(b.chapterTitle),
    )
    .slice(0, Math.max(0, limit));
}
