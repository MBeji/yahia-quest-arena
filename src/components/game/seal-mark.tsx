import { cn } from "@/shared/lib/utils";
import type { StarTier } from "@/shared/lib/progress-stars";

/**
 * LE SCEAU D'UNE MATIÈRE (étude 34, R-9) — la reconnaissance de matière, gagnée
 * quand **tous** les chapitres publiés portent la même étoile.
 *
 * Volontairement un CACHET, pas une médaille : un disque cerclé qui porte ses
 * étoiles, à distance visuelle des badges de la boutique (`badge-medal`) et des
 * ligues (or / platine / diamant, é31 R-14). Un sceau ne se troque pas, ne se
 * perd pas, ne classe personne — il atteste. Le vocabulaire visuel devait dire
 * exactement cela, sinon un élève y lirait une monnaie de plus.
 *
 * Deux états seulement, et aucun entre les deux :
 *  - **acquis** — inscrit au grand livre, daté, définitif ;
 *  - **en attente** — le contour seul. C'est l'état de l'anonyme (R-16) et celui
 *    d'un sceau pas encore tombé. Jamais grisé « perdu » : rien ne se perd ici.
 *
 * Présentation pure : les libellés arrivent en props, comme `badge-medal`, ce qui
 * garde le catalogue paresseux `i18n/progress/` hors de ce module.
 */
export function SealMark({
  star,
  earned,
  label,
  size = "md",
  className,
}: {
  /** Le rang du sceau, 1 à 4 — autant d'étoiles dessinées dans le cachet. */
  star: StarTier;
  /** Inscrit au grand livre. `false` = en attente (anonyme compris). */
  earned: boolean;
  /** `aria-label` — « Sceau ⭐⭐ ». Le cachet est UNE image. */
  label: string;
  size?: "sm" | "md";
  className?: string;
}) {
  const box = size === "md" ? "h-14 w-14" : "h-10 w-10";
  const glyph = size === "md" ? "text-xs" : "text-2xs";

  return (
    <span
      role="img"
      aria-label={label}
      data-testid="seal-mark"
      data-star={star}
      data-earned={earned ? "true" : "false"}
      className={cn(
        "grid shrink-0 place-items-center rounded-full border-2 leading-none",
        earned
          ? "border-(--gold) bg-(--gold)/12 text-(--gold)"
          : // Encre sourde NON diluée : empiler un modificateur d'opacité sur le
            // jeton `muted-foreground` fait tomber le contraste sous WCAG AA sur
            // blanc — le piège déjà payé deux fois sur le hub et la ligue.
            "border-dashed border-border bg-card text-muted-foreground",
        box,
        className,
      )}
    >
      {/* Les étoiles du cachet : autant que le rang, sur deux lignes au-delà de
          deux, pour qu'un sceau ⭐⭐⭐⭐ reste un disque et non une barre. */}
      <span aria-hidden className={cn("max-w-[80%] text-center font-bold", glyph)}>
        {"⭐".repeat(star)}
      </span>
    </span>
  );
}
