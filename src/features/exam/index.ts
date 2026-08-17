// Feature: Mock exam — « examen blanc » (étude 02)
// Public API — import from "@/features/exam"
//
// Les composants ne passent PAS par ce barrel : ils s'importent en profondeur
// (`@/features/exam/components/...`) pour qu'une route qui n'affiche qu'un
// résultat ne tire pas la couche serveur dans son graphe de modules.

export {
  listMockExams,
  startMockExam,
  saveMockAnswers,
  finishMockExam,
  getMockExamReview,
  getMockExamPercentile,
  type ExamListItem,
  type ExamPaper,
  type ExamPercentile,
  type ExamQuestion,
  type ExamResult,
  type ExamReview,
  type ExamStartPayload,
} from "./exam.server";
