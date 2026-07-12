import type { TranslationKeys } from "@/lib/i18n/types";

type DuelLabels = TranslationKeys["duel"];

const TIER_LABEL: Record<string, keyof DuelLabels> = {
  diamond: "tierDiamond",
  platinum: "tierPlatinum",
  gold: "tierGold",
  silver: "tierSilver",
  bronze: "tierBronze",
};

/** Localized league-tier name, falling back to Bronze for an unknown tier. Kept
 *  out of the component file so it can be shared/tested without tripping
 *  react-refresh's only-export-components rule. */
export function tierLabel(tier: string, labels: DuelLabels): string {
  return labels[TIER_LABEL[tier] ?? "tierBronze"];
}
