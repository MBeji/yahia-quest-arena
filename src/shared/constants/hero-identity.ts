/**
 * Étude 31 lot 7 — L'IDENTITÉ DU HÉROS, côté code (US-11, R-22).
 *
 * `profiles.hero_class` portait du FRANÇAIS NON ACCENTUÉ (« Guerrier des
 * Equations »), rendu tel quel dans les trois langues : un élève arabophone
 * lisait sa classe en français. La base garde désormais un code ; ce module
 * fixe la liste fermée, et l'i18n porte les libellés.
 *
 * Le type est le garde-fou, comme pour les badges et les refus d'auth : une
 * classe sans sa ligne de traduction ne compile pas.
 */

/** Les sept paliers, du socle à la légende. `novice` est le défaut de colonne. */
export const HERO_CLASSES = [
  "novice",
  "candidat",
  "aspirant",
  "guerrier",
  "maitre",
  "elite",
  "s_rank",
] as const;

export type HeroClass = (typeof HERO_CLASSES)[number];

export function isHeroClass(value: string): value is HeroClass {
  return (HERO_CLASSES as readonly string[]).includes(value);
}

/** Les cadres achetables (`shop_items.effect_payload.frameSlug`). */
export const HERO_FRAMES = ["bronze", "gold", "neon"] as const;
export type HeroFrame = (typeof HERO_FRAMES)[number];

/** Les titres achetables (`shop_items.effect_payload.titleCode`). */
export const HERO_TITLES = ["studious", "sharp", "legend"] as const;
export type HeroTitle = (typeof HERO_TITLES)[number];

export function isHeroFrame(value: string | null | undefined): value is HeroFrame {
  return typeof value === "string" && (HERO_FRAMES as readonly string[]).includes(value);
}

export function isHeroTitle(value: string | null | undefined): value is HeroTitle {
  return typeof value === "string" && (HERO_TITLES as readonly string[]).includes(value);
}

/**
 * Le PALIER D'AVATAR (`profiles.avatar_tier`) était calculé à chaque gain d'XP
 * et rendu nulle part. Il vaut 1 à 6 — `LEAST(6, GREATEST(1, level / 8 + 1))`
 * dans `award_xp` — et se lit ici comme une progression, pas comme un nombre.
 */
export const AVATAR_TIER_MAX = 6;

export function clampAvatarTier(tier: number | null | undefined): number {
  if (!tier || Number.isNaN(tier)) return 1;
  return Math.min(AVATAR_TIER_MAX, Math.max(1, Math.round(tier)));
}
