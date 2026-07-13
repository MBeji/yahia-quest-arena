/**
 * Raw objective/quest type codes come from the DB (`daily_objectives.objective_type`,
 * `weekly_quests.quest_type`). They are rendered through the i18n dictionaries
 * (`t.dashboard.objectiveTypes` / `questTypes` — étude 15, lot 1: hard-coded English
 * like "Beat 2 boss exercises" used to leak into every locale); an unknown code
 * degrades to a humanized version of itself instead of a raw snake_case token.
 */
export function formatObjectiveType(type: string, labels: Record<string, string>): string {
  return labels[type] ?? type.replace(/_/g, " ");
}

export function formatQuestType(type: string, labels: Record<string, string>): string {
  return labels[type] ?? type.replace(/_/g, " ");
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
