/**
 * Le rangement du catalogue des examens blancs (étude 02, suite du 2026-11-22).
 *
 * Tant qu'il n'y avait qu'un concours blanc, une liste suffisait. Avec les
 * épreuves par matière que le corpus déclare, l'élève cherche « mes épreuves
 * d'arabe », pas la quatorzième carte d'une file : on range par matière.
 *
 * L'ordre n'est décidé nulle part ici. `list_mock_exams` rend les examens triés
 * par `display_order` ; ce module ne fait que les regrouper EN GARDANT cet ordre
 * — les concours blancs multi-matières d'abord (ils n'ont pas de matière), puis
 * chaque matière dans l'ordre où son premier examen apparaît. Le corpus règle
 * donc l'ordre des groupes par ses `displayOrder`, sans second réglage côté écran.
 */

/** Ce que le rangement lit d'un examen — la forme de liste le porte déjà. */
export interface GroupableExam {
  subjectId: string | null;
  subjectName: string | null;
}

export interface ExamGroup<T extends GroupableExam> {
  /** Clé stable pour React : l'id de la matière, ou `mixed` pour les blancs multi-matières. */
  key: string;
  subjectId: string | null;
  /** Nom de la matière tel que le catalogue le sert ; `null` pour le groupe multi-matières. */
  subjectName: string | null;
  exams: T[];
}

export const MIXED_EXAM_GROUP_KEY = "mixed";

export function groupExamsBySubject<T extends GroupableExam>(exams: readonly T[]): ExamGroup<T>[] {
  const mixed: T[] = [];
  const bySubject = new Map<string, ExamGroup<T>>();
  for (const exam of exams) {
    if (exam.subjectId === null) {
      mixed.push(exam);
      continue;
    }
    const group = bySubject.get(exam.subjectId);
    if (group) {
      group.exams.push(exam);
      // Un nom manquant sur le premier examen (matière lue pendant qu'on la
      // republiait) ne doit pas rendre tout le groupe anonyme.
      group.subjectName ??= exam.subjectName;
    } else {
      bySubject.set(exam.subjectId, {
        key: exam.subjectId,
        subjectId: exam.subjectId,
        subjectName: exam.subjectName,
        exams: [exam],
      });
    }
  }
  const groups: ExamGroup<T>[] = [];
  if (mixed.length > 0) {
    groups.push({ key: MIXED_EXAM_GROUP_KEY, subjectId: null, subjectName: null, exams: mixed });
  }
  groups.push(...bySubject.values());
  return groups;
}
