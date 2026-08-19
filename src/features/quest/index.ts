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
// Module ÉTROIT (comme `quest.training`) : le verdict par question ne doit pas
// tirer tout `quest.server` dans le chunk qui l'importe.
export { checkQuestion } from "./quest.check.server";
// Zero-import module — importing these plain strings must NOT pull the server
// module into the client `index` chunk (bundle-budget regression, étude 17).
export { RECALL_LOCKED_MESSAGE, RECALL_NOT_ELIGIBLE_MESSAGE } from "./recall-messages";
export { computeNextExerciseId } from "./next-exercise";
export { noXpReason } from "./no-xp-reason";
export { exerciseRouteFor } from "./exercise-route";
