// Feature: Progression (spaced repetition, daily/weekly objectives, difficulty)
// Public API — import from "@/features/progression"

export {
  scheduleSpacedRepetition,
  getPendingSpacedRepetition,
  getDailyObjectives,
  updateDailyObjectiveProgress,
  getWeeklyQuests,
  updateWeeklyQuestProgress,
  adaptDifficulty,
  recoverStreak,
} from "./progression.server";
