// Feature: Quest (exercise flow)
// Public API — import from "@/features/quest"

export {
  getSubject,
  getChapterLesson,
  getManuelPageUrls,
  getExercise,
  startExerciseSession,
  submitAttempt,
  revealHint,
  checkAnswersPublic,
  scoreQuizPublic,
} from "./quest.server";
export type { ManuelPage } from "./quest.server";
export { getSubjectManuels } from "./manuel.server";
export type { SubjectManuel } from "./manuel.server";
// Zero-import module — importing these plain strings must NOT pull the server
// module into the client `index` chunk (bundle-budget regression, étude 17).
export { RECALL_LOCKED_MESSAGE, RECALL_NOT_ELIGIBLE_MESSAGE } from "./recall-messages";
export { computeNextExerciseId } from "./next-exercise";
export { noXpReason } from "./no-xp-reason";
export { exerciseRouteFor } from "./exercise-route";
