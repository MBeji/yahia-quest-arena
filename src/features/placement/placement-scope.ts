/**
 * LA PORTÉE DU TEST (étude 39 R-22) — « où en es-tu dans le programme ? ».
 *
 * Le SERVEUR décide ce qu'un chapitre atteint veut dire (`start_placement_session` borne le
 * tirage, élargit un chapitre trop tôt, fige la portée). Ce module ne fait que PROPOSER un point
 * de départ d'après le calendrier — une valeur par défaut que l'élève corrige, jamais une règle.
 * Pur : la date est un argument, les tests n'ont pas d'horloge à simuler.
 */

/**
 * L'ANNÉE SCOLAIRE tunisienne, pour préremplir « où en es-tu ? » (étude 39 R-22) : les cours
 * vont, à peu près, de la mi-septembre à la fin mai ; juin est la révision et les examens, l'été
 * suit — le programme est alors vu en entier. Mois de 1 à 12. Une APPROXIMATION assumée : les
 * classes n'avancent pas au même pas, l'élève corrige d'un geste.
 */
const PLACEMENT_SCHOOL_YEAR = {
  start: { month: 9, day: 15 },
  end: { month: 5, day: 31 },
} as const;

/** Un chapitre testable, tel que `list_placement_chapters` le rend (dans l'ordre du programme). */
export type ScopeChapter = {
  chapterId: string;
  title: string;
  /** Le programme jusqu'à ce chapitre porte assez de questions pour un test (R-1). */
  enough: boolean;
};

/**
 * La part de l'année de cours écoulée à `date`, entre 0 et 1. De la fin des cours à la rentrée
 * suivante (juin → mi-septembre), elle vaut 1 : le programme est vu.
 */
export function schoolYearProgress(date: Date): number {
  const { start, end } = PLACEMENT_SCHOOL_YEAR;
  const y = date.getFullYear();
  const month = date.getMonth() + 1;
  const afterStart = month > start.month || (month === start.month && date.getDate() >= start.day);
  // L'année de cours en cours a commencé cette année civile (sept. → déc.) ou la précédente.
  const startYear = afterStart ? y : y - 1;
  const from = new Date(startYear, start.month - 1, start.day).getTime();
  const to = new Date(startYear + 1, end.month - 1, end.day).getTime();
  const now = date.getTime();
  if (now >= to) return 1;
  return Math.min(1, Math.max(0, (now - from) / (to - from)));
}

/**
 * Le chapitre atteint que le calendrier suggère — `null` = tout le programme.
 * Le rang visé est la part de l'année × le nombre de chapitres (au moins le premier), remonté au
 * premier chapitre qui porte un test ; viser le dernier chapitre, c'est tout le programme.
 */
export function suggestThroughChapterId(chapters: ScopeChapter[], date: Date): string | null {
  const n = chapters.length;
  if (n <= 1) return null;
  let rank = Math.max(1, Math.ceil(schoolYearProgress(date) * n));
  while (rank < n && !chapters[rank - 1].enough) rank += 1;
  return rank >= n ? null : chapters[rank - 1].chapterId;
}

/** Les chapitres qu'on peut proposer comme « chapitre atteint » : ceux qui portent un test, sauf le dernier (= tout le programme). */
export function selectableThroughChapters(chapters: ScopeChapter[]): ScopeChapter[] {
  return chapters.slice(0, -1).filter((c) => c.enough);
}
