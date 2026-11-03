// La partie CLIENT du rapport quotidien : ses types et son seul helper pur.
//
// Les schémas zod qui produisent ces types vivent dans `./daily-report.schemas`
// (serveur seulement, 2026-10-31) : un `export type` s'efface à la compilation,
// un `z.object()` de niveau module non — et c'est lui qui expédiait zod entier
// aux parents via le barrel `./index`.
export type {
  ActivityBreakdown,
  ActivityTotals,
  AttemptDetail,
  AttemptQuestion,
  ChapterGap,
  ChapterSlice,
  DailyReport,
  DailySlice,
  ExerciseRun,
  LessonView,
  SubjectSlice,
  SubjectStarsSlice,
} from "./daily-report.schemas";

/**
 * Le libellé lisible d'une réponse : le texte de l'option quand l'identifiant en
 * désigne une, la valeur brute sinon (réponse libre, mise en ordre, appariement).
 */
export function answerLabel(
  question: { options: { id: string; text: string }[] },
  value: string | null,
): string | null {
  if (!value) return null;
  return question.options.find((option) => option.id === value)?.text ?? value;
}
