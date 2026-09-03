import { CalendarCheck } from "lucide-react";

import { useT } from "@/lib/i18n";
import type { WeeklyRecap } from "../weekly-recap.server";

/**
 * « Ta semaine » (étude 31 lot 5 — US-8, R-18).
 *
 * La fin de cycle qui manquait : la semaine se terminait sans rien dire. Cinq
 * faits, comparés à la semaine d'avant, et RIEN d'autre —
 *
 *   * **aucune récompense** (R-18) : lire son bilan ne rapporte ni XP ni pièces.
 *     Un bilan qui paye devient une tâche ;
 *   * **aucun écart inventé** : un delta de précision n'est affiché que si les
 *     DEUX semaines ont eu des missions. Sinon une reprise après vacances
 *     annoncerait « +67 points de progression » — un compliment mécanique et faux ;
 *   * **aucun reproche** (R-8) : une semaine vide n'affiche pas « tu n'as rien
 *     fait », elle affiche « ta semaine commence ».
 */
export function WeeklyRecapCard({ recap }: { recap: WeeklyRecap }) {
  const t = useT();

  if (!recap.hasActivity) {
    return (
      <section
        data-testid="weekly-recap-empty"
        className="rounded-2xl border border-border/50 bg-surface-2 p-5 backdrop-blur-md"
      >
        <h2 className="flex items-center gap-2 font-display text-lg font-bold">
          <CalendarCheck className="h-5 w-5 text-[color:var(--gold)]" aria-hidden="true" />
          {t.dashboard.weeklyRecapTitle}
        </h2>
        <p className="mt-2 text-sm text-muted-foreground">{t.dashboard.weeklyRecapEmpty}</p>
      </section>
    );
  }

  const signed = (n: number): string => (n > 0 ? `+${n}` : String(n));

  const facts: { label: string; value: string; delta: string | null }[] = [
    {
      label: t.dashboard.weeklyRecapXp,
      value: String(recap.thisWeek.xp),
      delta: signed(recap.delta.xp),
    },
    {
      label: t.dashboard.weeklyRecapMissions,
      value: String(recap.thisWeek.missions),
      delta: signed(recap.delta.missions),
    },
    {
      label: t.dashboard.weeklyRecapAccuracy,
      value: `${recap.thisWeek.avgScore} %`,
      // NULL = pas comparable ; on n'affiche pas un écart qu'on ne sait pas calculer.
      delta: recap.delta.avgScore === null ? null : signed(recap.delta.avgScore),
    },
    {
      label: t.dashboard.weeklyRecapDays,
      value: String(recap.thisWeek.daysActive),
      delta: signed(recap.delta.daysActive),
    },
  ];

  return (
    <section
      data-testid="weekly-recap"
      className="rounded-2xl border border-[color:var(--gold)]/25 bg-surface-2 p-5 backdrop-blur-md"
    >
      <h2 className="flex items-center gap-2 font-display text-lg font-bold">
        <CalendarCheck className="h-5 w-5 text-[color:var(--gold)]" aria-hidden="true" />
        {t.dashboard.weeklyRecapTitle}
      </h2>

      <div className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-4">
        {facts.map((fact) => (
          <div key={fact.label} className="rounded-xl bg-surface-1 p-3">
            <div className="text-xs uppercase tracking-widest text-muted-foreground">
              {fact.label}
            </div>
            <div className="mt-1 font-display text-lg font-bold tabular-nums">{fact.value}</div>
            {fact.delta !== null && (
              <div className="text-xs text-muted-foreground tabular-nums">
                {fact.delta} {t.dashboard.weeklyRecapVsLast}
              </div>
            )}
          </div>
        ))}
      </div>

      {recap.badges.length > 0 && (
        <p className="mt-3 text-sm text-muted-foreground" data-testid="weekly-recap-badges">
          {recap.badges.length} {t.dashboard.weeklyRecapBadges}
        </p>
      )}
      {recap.league && (
        <p className="mt-1 text-sm text-[color:var(--gold)]" data-testid="weekly-recap-league">
          {t.dashboard.weeklyRecapLeague
            .replace("{tier}", recap.league.tier)
            .replace("{rank}", String(recap.league.rank))}
        </p>
      )}
    </section>
  );
}
