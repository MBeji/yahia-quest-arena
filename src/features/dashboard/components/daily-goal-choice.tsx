import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";

import { useT } from "@/lib/i18n";
import {
  DAILY_GOAL_ALREADY_SET,
  DAILY_XP_GOALS,
  getDailyRing,
  setDailyXpGoal,
} from "@/features/dashboard";

/**
 * L'OBJECTIF DU JOUR, choisi (étude 31 lot 3 — US-2, R-12).
 *
 * L'anneau du tableau de bord tournait sur 100 XP en dur. Le dénominateur était
 * donc le même pour l'élève qui découvre l'application et pour celui qui tient
 * une série de trente jours : trop haut pour l'un, sans intérêt pour l'autre.
 *
 * **Une fois par jour** : un objectif qu'on remonte dès qu'il est atteint et
 * qu'on baisse dès qu'il résiste ne mesure plus rien. Le refus vient du serveur
 * (`set_daily_xp_goal`) et se dit en clair — « tu pourras le régler demain » —
 * jamais « une erreur est survenue » (R-8 : rien de culpabilisant).
 */
export function DailyGoalChoice() {
  const t = useT();
  const queryClient = useQueryClient();
  const fetchRing = useServerFn(getDailyRing);
  const saveGoal = useServerFn(setDailyXpGoal);

  const { data: ring } = useQuery({ queryKey: ["daily-ring"], queryFn: () => fetchRing() });

  const mutation = useMutation({
    mutationFn: (goal: (typeof DAILY_XP_GOALS)[number]) => saveGoal({ data: { goal } }),
    onSuccess: () => {
      toast.success(t.dashboard.dailyGoalSaved);
      queryClient.invalidateQueries({ queryKey: ["daily-ring"] });
    },
    onError: (error) => {
      const already = error instanceof Error && error.message.includes(DAILY_GOAL_ALREADY_SET);
      toast.error(already ? t.dashboard.dailyGoalAlreadySet : t.errors.errorFallback);
    },
  });

  const current = ring?.goal ?? 100;

  return (
    <div className="py-1.5" data-testid="daily-goal-choice">
      <div className="mb-1 text-xs text-muted-foreground">{t.dashboard.dailyGoalChoose}</div>
      <div className="flex gap-1">
        {DAILY_XP_GOALS.map((goal) => (
          <button
            key={goal}
            type="button"
            role="radio"
            aria-checked={goal === current}
            disabled={mutation.isPending}
            onClick={() => mutation.mutate(goal)}
            data-goal={goal}
            className={`flex min-h-11 flex-1 items-center justify-center rounded-lg px-2 py-1.5 text-xs font-bold transition disabled:opacity-60 ${
              goal === current
                ? "bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                : "text-muted-foreground hover:bg-accent hover:text-foreground"
            }`}
          >
            {goal} XP
          </button>
        ))}
      </div>
      <p className="mt-1 text-xs text-muted-foreground">{t.dashboard.dailyGoalChooseHint}</p>
    </div>
  );
}
