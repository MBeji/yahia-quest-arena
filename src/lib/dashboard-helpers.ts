export function formatObjectiveType(type: string): string {
  const map: Record<string, string> = {
    "3_exercises": "Complete 3 exercises",
    "15_min_study": "15 min study time",
    perfect_score: "Get a perfect score",
  };
  return map[type] ?? type.replace(/_/g, " ");
}

export function formatQuestType(type: string): string {
  const map: Record<string, string> = {
    "5_day_streak": "Maintain 5-day streak",
    "2_boss_exercises": "Beat 2 boss exercises",
    "10_exercises": "Complete 10 exercises",
    all_subjects: "Practice all subjects",
  };
  return map[type] ?? type.replace(/_/g, " ");
}

export function resolveDailyAction(type: string): "retry" | "subject" | "dungeon" {
  if (type === "perfect_score") return "retry";
  if (type === "15_min_study") return "subject";
  return "subject";
}

export function resolveWeeklyAction(type: string): "retry" | "subject" | "dungeon" {
  if (type === "beat_2_bosses" || type === "2_boss_exercises") return "dungeon";
  if (type === "all_subjects") return "subject";
  return "subject";
}
