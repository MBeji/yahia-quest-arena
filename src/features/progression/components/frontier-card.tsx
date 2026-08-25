import { useNavigate } from "@tanstack/react-router";
import { Compass, KeyRound } from "lucide-react";

import { useI18n } from "@/lib/i18n";
import type { Locale } from "@/lib/i18n";
import type { LearningFrontierRow } from "@/shared/types/competency";

/**
 * « Prêt à apprendre » — la frontière (étude 30, lot 3 · §3.4).
 *
 * C'est la lecture la plus rentable de l'étude, et l'écran le plus simple : au plus trois
 * cartes, JAMAIS une liste. Une frontière qui déroulerait vingt compétences serait un
 * catalogue de plus ; ce qu'on veut, c'est une proposition qu'on peut suivre sans choisir
 * (é15 R-1, le CTA unique).
 *
 * Ce que ces trois cartes valent, et qui n'est pas évident : la frontière n'est pas
 * « ce qui reste à faire », c'est ce dont TOUS les prérequis sont déjà maîtrisés. La ZPD de
 * Vygotsky, calculée sur le graphe plutôt que devinée. L'exercice d'entrée, lui, est celui
 * dont la probabilité de réussite prédite tombe dans [0,55 ; 0,80] — ni frustration, ni ennui.
 *
 * ⚠️ Comme sa voisine, ce composant ne rend NI `p_known`, NI `entry_odds` (D-1). Les deux
 * arrivent dans les données pour la console d'admin ; ici ils servent uniquement à ce que le
 * serveur ait pu trier et choisir. Le test l'assert.
 *
 * Le tri par fan-out est le seul pari pédagogique explicite de l'étude : à croyance égale, on
 * propose d'abord ce qui ouvre le plus de portes. Il est affiché (« ouvre 3 suites ») parce
 * qu'un pari qu'on montre est un pari qu'on peut contester — et parce que c'est vrai : la
 * raison d'une proposition fait partie de la proposition (R-14).
 */
function pickLabel(
  row: { label_fr: string; label_en: string; label_ar: string },
  locale: Locale,
): string {
  return locale === "ar" ? row.label_ar : locale === "en" ? row.label_en : row.label_fr;
}

export function FrontierCard({ rows }: { rows: LearningFrontierRow[] }) {
  const { t, locale } = useI18n();
  const a = t.adaptive;
  const navigate = useNavigate();

  // Sur une matière non taggée la lecture rend zéro ligne : le panneau ne s'affiche pas du
  // tout, et l'écran est exactement celui d'aujourd'hui (R-6). Ce `null` EST la neutralité.
  if (rows.length === 0) return null;

  return (
    <section aria-labelledby="frontier-title" className="rounded-xl border p-4">
      <h2 id="frontier-title" className="flex items-center gap-2 text-lg font-semibold">
        <Compass className="size-5" aria-hidden />
        {a.frontierTitle}
      </h2>
      <p className="text-muted-foreground mt-1 text-sm">{a.frontierSubtitle}</p>

      <ul className="mt-4 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
        {rows.map((row) => (
          <li key={row.competency_id} className="border-border flex flex-col rounded-lg border p-3">
            <span className="text-sm font-semibold">{pickLabel(row, locale)}</span>

            <span className="text-muted-foreground mt-1 flex items-center gap-1 text-xs">
              <KeyRound className="size-3.5 shrink-0" aria-hidden />
              {row.unlocks > 0
                ? a.frontierUnlocks.replace("{n}", String(row.unlocks))
                : a.frontierUnlocksNone}
            </span>

            {/* Pas d'exercice d'entrée ⇒ pas de bouton. Le corpus n'offre pas toujours un
                item accessible pour chaque compétence de la frontière (la porte d'accès reste
                l'arbitre unique, R-16) ; proposer un CTA qui mène à un refus serait pire que
                de n'en proposer aucun — c'est la leçon de R-30 de é22. */}
            {row.entry_exercise_id ? (
              <button
                type="button"
                className="bg-primary text-primary-foreground hover:bg-primary/90 mt-3 rounded-md px-3 py-1.5 text-xs font-semibold"
                onClick={() => {
                  void navigate({
                    to: "/quest/$exerciseId",
                    params: { exerciseId: row.entry_exercise_id as string },
                  });
                }}
              >
                {a.frontierStartCta}
              </button>
            ) : null}
          </li>
        ))}
      </ul>
    </section>
  );
}
