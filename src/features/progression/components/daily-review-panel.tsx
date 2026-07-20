import { Link } from "@tanstack/react-router";
import { ChevronRight, RotateCcw, Target } from "lucide-react";

import { useT } from "@/lib/i18n";
import type { DailyPlanItem } from "@/shared/types/daily-plan";

/**
 * « Révision du jour » — étude 04, lot A1.1 (US-1).
 *
 * Le panneau qui rend enfin VISIBLE la répétition espacée. `spaced_repetition_schedule`
 * existait depuis le sprint 2 et n'alimentait aucun écran : l'élève ne savait pas ce que sa
 * mémoire est en train de lâcher. Ici, il le voit, avec la raison — et la raison compte
 * autant que la liste : « Tu n'as pas revu Fractions depuis 12 jours » se comprend et
 * s'accepte, une liste nue ressemble à une punition (RISK-4).
 *
 * Trois missions au plus (R-4), servies par `get_daily_plan` déjà triées : le composant ne
 * décide rien, il rend. C'est un SÉLECTEUR d'exercices existants — les récompenses et les
 * gardes anti-farm sont celles du jeu normal, il n'y a pas d'économie « révision ».
 *
 * L'état vide est une bonne nouvelle et se lit comme telle : personne ne doit se sentir en
 * retard parce qu'il est à jour.
 */
export function DailyReviewPanel({ items }: { items: DailyPlanItem[] }) {
  const t = useT();

  return (
    <section
      aria-label={t.dashboard.reviewTitle}
      className="mt-4 rounded-2xl border border-[color:var(--gold)]/25 bg-black/40 p-5 backdrop-blur-md"
    >
      <div className="flex items-center gap-2 font-display text-lg font-bold">
        <RotateCcw className="h-5 w-5 text-[color:var(--gold)]" />
        {t.dashboard.reviewTitle}
      </div>

      {items.length === 0 ? (
        <p className="mt-3 text-sm text-muted-foreground">{t.dashboard.dailyPlanEmpty}</p>
      ) : (
        <ul className="mt-3 space-y-2">
          {items.map((item) => (
            <li key={item.exercise_id}>
              <Link
                to="/quest/$exerciseId"
                params={{ exerciseId: item.exercise_id }}
                className="group flex items-center gap-3 rounded-xl border border-[color:var(--gold)]/20 bg-[color:var(--gold)]/5 p-3 transition hover:border-[color:var(--gold)]/50 hover:bg-[color:var(--gold)]/10"
              >
                <div className="min-w-0 flex-1">
                  <div className="truncate font-semibold">{item.exercise_title}</div>
                  <div className="truncate text-xs text-muted-foreground">
                    {reviewReason(item, t)}
                  </div>
                  {item.weak_tags > 0 && (
                    <div className="mt-1 flex items-center gap-1 text-xs text-[color:var(--flame)]">
                      <Target className="h-3 w-3" /> {t.dashboard.dailyPlanWeak}
                    </div>
                  )}
                </div>
                <span className="shrink-0 text-xs font-bold uppercase tracking-[0.14em] text-[color:var(--gold)]">
                  {t.dashboard.dailyPlanCta}
                </span>
                <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground transition group-hover:translate-x-0.5 rtl:-scale-x-100 rtl:group-hover:-translate-x-0.5" />
              </Link>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}

/**
 * La raison, dans la langue de l'interface. Le serveur ne renvoie que des faits (le chapitre,
 * le nombre de jours de retard) précisément pour que la phrase se compose ici : une raison
 * fabriquée en SQL serait francophone pour tout le monde.
 *
 * Trois formes, parce que « depuis 0 jour » ne se dit pas et que « depuis 1 jours » se
 * remarque tout de suite.
 */
function reviewReason(item: DailyPlanItem, t: ReturnType<typeof useT>): string {
  const template =
    item.days_overdue <= 0
      ? t.dashboard.dailyPlanReasonToday
      : item.days_overdue === 1
        ? t.dashboard.dailyPlanReasonOneDay
        : t.dashboard.dailyPlanReason;

  return template
    .replace("{chapter}", item.chapter_title)
    .replace("{n}", String(item.days_overdue));
}
