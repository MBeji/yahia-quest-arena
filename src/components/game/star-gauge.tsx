import { Star } from "lucide-react";
import { cn } from "@/shared/lib/utils";
import type { ChapterRung } from "@/shared/lib/progress-stars";

/**
 * LA JAUGE D'UN CHAPITRE (étude 34, R-8) — autant de crans que de difficultés
 * PRÉSENTES, jamais quatre par principe.
 *
 * Ce que la jauge dit, et pourquoi elle est faite ainsi :
 *
 *  - **un cran allumé est acquis pour toujours.** Il se lit au grand livre
 *    (`ChapterRung.lit`, posé depuis `user_chapter_stars`), jamais au calcul
 *    vivant. Une campagne de contenu peut ajouter dix missions : aucun cran ne
 *    s'éteint. C'est l'invariant qui a motivé toute l'étude, et il se voit ici ;
 *  - **un cran présent non acquis porte son compteur** `n/m` — le reste-à-faire
 *    est une information, pas un reproche. Aucun pourcentage : on ne divise pas
 *    un travail par un catalogue qui bouge ;
 *  - **un cran qui a grandi porte ✨.** C'est la réponse à « pourquoi ma jauge
 *    n'est-elle pas pleine alors que je l'avais finie » : le contenu est arrivé
 *    après, et on le dit plutôt que de le taire ;
 *  - **deux crans seulement si le chapitre n'a que ⭐ et ⭐⭐** (D-3). Afficher un
 *    palier qu'aucun contenu ne permet d'atteindre promettrait un travail
 *    inexistant. 57 chapitres du corpus n'ont aucune mission ⭐.
 *
 * ⚠️ **RTL** : rien ici ne force un sens. La rangée est un `inline-flex` simple,
 * donc elle se remplit de droite à gauche dès que le conteneur est en `dir="rtl"`
 * — ce que fait le hub pour une matière arabe. Ne jamais ajouter de
 * `flex-row-reverse` ni de positionnement absolu : ce serait retourner la jauge
 * une seconde fois, donc la remettre à l'endroit au mauvais endroit.
 *
 * Présentation pure : les libellés arrivent en props (modèle `badge-medal`), ce
 * qui garde le catalogue paresseux `i18n/progress/` hors de ce module.
 */
export function StarGauge({
  rungs,
  label,
  size = "sm",
  className,
}: {
  /** Les crans du chapitre, déjà triés et déjà résolus (`progress-stars`). */
  rungs: ChapterRung[];
  /** `aria-label` de l'ensemble — « 2 étoiles sur 3 ». La jauge est UNE image. */
  label: string;
  size?: "sm" | "md";
  className?: string;
}) {
  // Un chapitre non publié n'a pas de jauge : il n'y a rien à y jouer, et une
  // rangée vide se lirait comme « zéro sur zéro ».
  if (rungs.length === 0) return null;

  const starSize = size === "md" ? "h-5 w-5" : "h-3.5 w-3.5";
  const countSize = size === "md" ? "text-xs" : "text-2xs";

  return (
    <span
      role="img"
      aria-label={label}
      data-testid="star-gauge"
      className={cn("inline-flex items-center gap-1.5", className)}
    >
      {rungs.map((rung) => (
        <span
          key={rung.tier}
          data-testid={`star-rung-${rung.tier}`}
          data-lit={rung.lit ? "true" : "false"}
          data-new={rung.newMissions > 0 ? "true" : "false"}
          className="inline-flex items-center gap-0.5"
        >
          <Star
            aria-hidden
            className={cn(starSize, "shrink-0", rung.lit ? "fill-gold text-gold" : "text-border")}
          />
          {/* Le compteur n'apparaît QUE sur un cran encore à gagner : sur un cran
              acquis il redirait « 3/3 » sous une étoile pleine, et l'acquis n'a
              pas à être justifié une seconde fois. */}
          {!rung.lit && rung.total > 0 && (
            <span className={cn(countSize, "font-bold tabular-nums text-muted-foreground")}>
              {rung.counted}/{rung.total}
            </span>
          )}
          {rung.newMissions > 0 && (
            <span aria-hidden className={countSize}>
              ✨
            </span>
          )}
        </span>
      ))}
    </span>
  );
}
