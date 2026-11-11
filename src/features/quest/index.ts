// Feature: Quest (exercise flow)
// Public API — import from "@/features/quest"

export {
  getSubject,
  getExercise,
  startExerciseSession,
  submitAttempt,
  revealHint,
} from "./quest.server";
export { getChapterLesson, getManuelPageUrls } from "./quest.lesson.server";
export type { ManuelPage } from "./quest.lesson.server";
export { checkAnswersPublic, scoreQuizPublic } from "./quest.practice.server";
// Module ÉTROIT (comme `quest.training`) : le verdict par question ne doit pas
// tirer tout `quest.server` dans le chunk qui l'importe.
export { checkQuestion } from "./quest.check.server";
// Zero-import module — importing these plain strings must NOT pull the server
// module into the client `index` chunk (bundle-budget regression, étude 17).
export { RECALL_LOCKED_MESSAGE, RECALL_NOT_ELIGIBLE_MESSAGE } from "./recall-messages";
export { computeNextExerciseId } from "./next-exercise";
export { noXpReason } from "./no-xp-reason";
export { exerciseRouteFor } from "./exercise-route";
// Chargé UNIQUEMENT par un `import()` dynamique depuis `__root.tsx` : il tire
// `quest.server` et `quest-draft`, qui n'ont rien à faire dans le chunk index.
export { registerQuestOutboxSender } from "./quest-outbox";
export { getAttemptProgress } from "./quest.progress.server";
