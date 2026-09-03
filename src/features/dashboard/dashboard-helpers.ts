/** Les écrans qu'une mission peut viser. `duel` est arrivé avec é31 lot 3. */
export type DashboardGoalAction = "retry" | "subject" | "dungeon" | "duel";

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

/**
 * é31 lot 3 — où mène le bouton d'une mission du jour. Les huit types du pool
 * (R-10) s'y ajoutent : une mission qui renvoie au mauvais écran est aussi
 * inutile qu'une mission impossible.
 */
export function resolveDailyAction(type: string): DashboardGoalAction {
  if (type === "dungeon_floors") return "dungeon";
  if (type === "duel_play") return "duel";
  // Le rappel actif et la révision due sont deux entrées du même plan du jour :
  // « Reprendre » les sert, parce que `resolveNextAction` les a déjà classées.
  if (type === "review_due" || type === "recall_one") return "retry";
  if (type === "perfect_score" || type === "chapter_step") return "retry";
  if (type === "15_min_study") return "subject";
  return "subject";
}

export function resolveWeeklyAction(type: string): DashboardGoalAction {
  if (type === "beat_2_bosses" || type === "2_boss_exercises") return "dungeon";
  if (type === "all_subjects") return "subject";
  return "subject";
}
