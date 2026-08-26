import { useParentT } from "@/lib/i18n/parent";
import type { IndexBand } from "../insights";

/**
 * Le vocabulaire visuel des niveaux, partagé par les deux indices et par la
 * colonne « Niveau » du tableau des matières.
 *
 * Fichier à part (et sans JSX) parce qu'un module qui exporte des composants ne
 * peut pas aussi exporter des constantes ou des hooks sans casser le
 * rafraîchissement à chaud (règle `react-refresh/only-export-components`).
 */

export const BAND_STYLES: Record<IndexBand, { text: string; bg: string; ring: string }> = {
  excellent: { text: "text-success", bg: "bg-success/15", ring: "border-success/40" },
  good: { text: "text-primary", bg: "bg-primary/15", ring: "border-primary/40" },
  fair: { text: "text-gold", bg: "bg-gold/15", ring: "border-gold/40" },
  weak: { text: "text-flame", bg: "bg-flame/15", ring: "border-flame/40" },
};

export function useBandLabel(): (band: IndexBand) => string {
  const t = useParentT();
  return (band) =>
    ({
      excellent: t.parentDaily.bandExcellent,
      good: t.parentDaily.bandGood,
      fair: t.parentDaily.bandFair,
      weak: t.parentDaily.bandWeak,
    })[band];
}
