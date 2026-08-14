import { motion } from "motion/react";
import { Flame, Trophy } from "lucide-react";
import { GoldProgress } from "@/components/game/gold-progress";
import { useEntrance } from "@/shared/lib/motion";
import { useT } from "@/lib/i18n";
import {
  formatObjectiveType,
  formatQuestType,
  resolveDailyAction,
  resolveWeeklyAction,
} from "@/features/dashboard/dashboard-helpers";
import { FamilyGoalCard } from "@/features/dashboard/components/family-goal-card";

// =============================================================================
// Objectifs du jour + quêtes de la semaine. Extrait de la route et chargé
// PARESSEUSEMENT : après le lot de hiérarchie (#729) il ne restait que 0,24 ko
// de marge sous le budget du chunk `dashboard`, et cette section en est le plus
// gros morceau — deux colonnes, deux boucles, quatre helpers.
//
// Extraire sans rendre paresseux n'aurait RIEN rendu : un composant importé
// statiquement atterrit dans le même chunk que la route. C'est le `lazy()` côté
// route qui déplace vraiment les octets.
// =============================================================================

export type DashboardObjective = {
  id: string;
  objective_type: string;
  current_value: number;
  target_value: number;
  status: string;
  xp_reward: number | null;
};

export type DashboardQuest = {
  id: string;
  quest_type: string;
  current_value: number;
  target_value: number;
  status: string;
  xp_reward: number | null;
};

export type GoalAction = "retry" | "subject" | "dungeon";

/** Barre de progression bornée, sur une cible qui peut être nulle en base. */
function progressPct(current: number, target: number): number {
  return target > 0 ? Math.min(100, Math.round((current / target) * 100)) : 0;
}

export function DashboardGoals({
  dailyObjectives,
  weeklyQuests,
  onAction,
}: {
  dailyObjectives: DashboardObjective[];
  weeklyQuests: DashboardQuest[];
  onAction: (action: GoalAction) => void;
}) {
  const t = useT();
  const rise = useEntrance("rise", 0.2);

  return (
    <motion.div {...rise} className="mt-8 grid gap-6 sm:grid-cols-2">
      {/* Objectifs du jour */}
      <div className="rounded-2xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-5 backdrop-blur-md">
        <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
          <Trophy className="h-5 w-5 text-[color:var(--gold)]" /> {t.dashboard.dailyQuests}
        </div>
        <div className="space-y-3">
          {dailyObjectives.length === 0 && (
            <p className="text-xs text-muted-foreground">{t.dashboard.dailyEmpty}</p>
          )}
          {dailyObjectives.map((obj) => {
            const done = obj.status === "completed";
            const label = formatObjectiveType(obj.objective_type, t.dashboard.objectiveTypes);
            return (
              <div
                key={obj.id}
                className={`rounded-xl bg-surface-2 p-3 ${done ? "opacity-60" : ""}`}
              >
                <div className="flex items-center justify-between">
                  <div className="text-sm font-semibold">{label}</div>
                  <div className="text-xs text-[color:var(--gold)]">{obj.xp_reward} XP</div>
                </div>
                <GoldProgress
                  value={progressPct(obj.current_value, obj.target_value)}
                  size="sm"
                  className="mt-2"
                  aria-label={label}
                />
                <div className="mt-1 text-xs text-muted-foreground">
                  {obj.current_value}/{obj.target_value} {done ? "✓" : ""}
                </div>
                <button
                  type="button"
                  disabled={done}
                  onClick={() => onAction(resolveDailyAction(obj.objective_type))}
                  className="mt-2 rounded-md border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/25 disabled:cursor-not-allowed disabled:opacity-50 [@media(pointer:coarse)]:min-h-11"
                >
                  {done ? t.common.completed : t.common.continue}
                </button>
              </div>
            );
          })}
        </div>
      </div>

      {/* Quêtes de la semaine */}
      <div className="rounded-2xl border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/5 p-5 backdrop-blur-md">
        <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
          <Flame className="h-5 w-5 text-[color:var(--neon-gold)]" /> {t.dashboard.weeklyQuests}
        </div>
        <div className="space-y-3">
          {/* Quête famille — l'objectif fixé par le parent lié (null sinon). */}
          <FamilyGoalCard />
          {weeklyQuests.length === 0 && (
            <p className="text-xs text-muted-foreground">{t.dashboard.weeklyEmpty}</p>
          )}
          {weeklyQuests.map((q) => {
            const done = q.status === "completed";
            const label = formatQuestType(q.quest_type, t.dashboard.questTypes);
            return (
              <div key={q.id} className={`rounded-xl bg-surface-2 p-3 ${done ? "opacity-60" : ""}`}>
                <div className="flex items-center justify-between">
                  <div className="text-sm font-semibold">{label}</div>
                  <div className="text-xs text-[color:var(--neon-gold)]">{q.xp_reward} XP</div>
                </div>
                <GoldProgress
                  value={progressPct(q.current_value, q.target_value)}
                  size="sm"
                  className="mt-2"
                  aria-label={label}
                />
                <div className="mt-1 text-xs text-muted-foreground">
                  {q.current_value}/{q.target_value} {done ? "✓" : ""}
                </div>
                <button
                  type="button"
                  disabled={done}
                  onClick={() => onAction(resolveWeeklyAction(q.quest_type))}
                  className="mt-2 rounded-md border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/25 disabled:cursor-not-allowed disabled:opacity-50 [@media(pointer:coarse)]:min-h-11"
                >
                  {done ? t.common.completed : t.common.continue}
                </button>
              </div>
            );
          })}
        </div>
      </div>
    </motion.div>
  );
}
