// Barrel re-export for backward compatibility.
// Prefer importing directly from the domain-specific modules:
//   @/lib/gamification.dashboard
//   @/lib/gamification.shop
//   @/lib/gamification.quest
//   @/lib/gamification.progression

export { getDashboard, getLeaderboard, getSprint2Dashboard } from "./gamification.dashboard";
export { purchaseShopItem, equipInventorySkin } from "./gamification.shop";
export {
  getSubject,
  getChapterLesson,
  getExercise,
  startExerciseSession,
  submitAttempt,
} from "./gamification.quest";
export {
  scheduleSpacedRepetition,
  getPendingSpacedRepetition,
  getDailyObjectives,
  updateDailyObjectiveProgress,
  getWeeklyQuests,
  updateWeeklyQuestProgress,
  adaptDifficulty,
} from "./gamification.progression";
