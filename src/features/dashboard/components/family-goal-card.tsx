import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useT } from "@/lib/i18n";
import { getMyFamilyGoal } from "../dashboard.server";

type Goal = { target: number; done: number };

/**
 * La quête famille : les objectifs (nombre de missions) fixés par le parent lié,
 * avec la progression réelle de l'élève. Le parent en pose un par jour, un par
 * semaine, ou les deux — la carte rend ce qui existe et disparaît quand rien
 * n'est posé (ou que la RPC n'est pas déployée : le server fn dégrade en null).
 */
export function FamilyGoalCard() {
  const t = useT();
  const fetchFamilyGoal = useServerFn(getMyFamilyGoal);
  const { data: goals } = useQuery({
    queryKey: ["family-goal"],
    queryFn: () => fetchFamilyGoal(),
  });

  if (!goals?.daily && !goals?.weekly) return null;

  return (
    <div className="rounded-xl border border-[color:var(--gold)]/40 bg-surface-2 p-3">
      <div className="text-sm font-semibold">👨‍👩‍👧 {t.dashboard.familyGoalTitle}</div>
      {goals.daily && <GoalBar goal={goals.daily} label={t.dashboard.familyGoalProgressDaily} />}
      {goals.weekly && <GoalBar goal={goals.weekly} label={t.dashboard.familyGoalProgress} />}
      <div className="mt-1 text-xs text-muted-foreground">{t.dashboard.familyGoalHint}</div>
    </div>
  );
}

function GoalBar({ goal, label }: { goal: Goal; label: string }) {
  const t = useT();
  const pct = Math.min(100, Math.round((goal.done / Math.max(1, goal.target)) * 100));

  return (
    <div className="mt-2">
      <div className="mb-1 flex items-center justify-between gap-2">
        <span className="text-xs text-muted-foreground">
          {label.replace("{done}", String(goal.done)).replace("{target}", String(goal.target))}
        </span>
        {goal.done >= goal.target && (
          <span className="text-xs text-success">{t.dashboard.familyGoalReached}</span>
        )}
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-secondary">
        <div
          className="h-full bg-gradient-to-r from-[color:var(--gold)] to-[color:var(--gold-bright)] transition-all"
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
}
