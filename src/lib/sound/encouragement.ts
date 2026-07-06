import type { TranslationKeys } from "@/lib/i18n/types";

export type EncouragementTier = "combo" | "onFire" | "unstoppable" | "legendary";

export type Encouragement = { message: string; tier: EncouragementTier };

/**
 * Map a running combo count to an escalating encouragement banner. Returns null
 * below the first milestone so short streaks stay quiet. Tiers:
 *   3–4  → "Combo x{n}!"   5–6 → "On fire!"   7–9 → "Unstoppable!"   10+ → "Legendary!"
 */
export function encouragementFor(
  labels: TranslationKeys["encouragement"],
  combo: number,
): Encouragement | null {
  if (!Number.isFinite(combo) || combo < 3) return null;
  if (combo >= 10) return { message: labels.legendary, tier: "legendary" };
  if (combo >= 7) return { message: labels.unstoppable, tier: "unstoppable" };
  if (combo >= 5) return { message: labels.onFire, tier: "onFire" };
  return { message: labels.combo.replace("{n}", String(combo)), tier: "combo" };
}
