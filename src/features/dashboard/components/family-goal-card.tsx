import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useT } from "@/lib/i18n";
import { getMyFamilyGoal } from "../dashboard.server";

/**
 * La quête famille de la semaine : l'objectif (nombre de missions) fixé par le
 * parent lié, avec la progression réelle de l'élève. Rendu dans le panneau des
 * quêtes hebdomadaires du dashboard ; ne rend rien quand aucun objectif n'est
 * posé cette semaine (ou que la RPC n'est pas déployée — le server fn dégrade
 * en null).
 */
export function FamilyGoalCard() {
  const t = useT();
  const fetchFamilyGoal = useServerFn(getMyFamilyGoal);
  const { data: goal } = useQuery({
    queryKey: ["family-goal"],
    queryFn: () => fetchFamilyGoal(),
  });

  if (!goal) return null;

  const pct = Math.min(100, Math.round((goal.done / Math.max(1, goal.target)) * 100));

  return (
    <div className="rounded-xl border border-[color:var(--gold)]/40 bg-black/40 p-3">
      <div className="flex items-center justify-between">
        <div className="text-sm font-semibold">👨‍👩‍👧 {t.dashboard.familyGoalTitle}</div>
        {goal.done >= goal.target && (
          <span className="text-xs text-success">{t.dashboard.familyGoalReached}</span>
        )}
      </div>
      <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
        <div
          className="h-full bg-gradient-to-r from-[color:var(--gold)] to-[color:var(--gold-bright)] transition-all"
          style={{ width: `${pct}%` }}
        />
      </div>
      <div className="mt-1 text-xs text-muted-foreground">
        {t.dashboard.familyGoalProgress
          .replace("{done}", String(goal.done))
          .replace("{target}", String(goal.target))}
      </div>
      <div className="mt-1 text-xs text-muted-foreground">{t.dashboard.familyGoalHint}</div>
    </div>
  );
}
