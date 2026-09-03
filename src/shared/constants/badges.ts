/**
 * Étude 31 lot 2 — LE CATALOGUE DE BADGES, côté code.
 *
 * La base porte les badges (nom, rareté, icône, famille, condition) ; ce fichier
 * porte ce que le TYPE doit garantir : la liste fermée des codes et l'ordre des
 * familles. Deux raisons, toutes deux nées d'une panne du dépôt :
 *
 *   * **un badge sans libellé traduit ne doit pas compiler.** `badgeLabels` est
 *     un `Record<BadgeCode, …>` dans les trois langues : ajouter un badge sans
 *     sa ligne fait échouer `tsc`, exactement comme `auth-refusals.ts` le fait
 *     pour les refus d'authentification (deux listes tenues à la main y avaient
 *     divergé deux fois) ;
 *   * **l'ordre des familles est une décision de lecture**, pas un tri
 *     alphabétique : on ouvre la collection sur ce qu'un débutant peut obtenir.
 *
 * R-13 : tout badge de la base est décernable. Les conditions vivent en SQL, dans
 * le finalizer qui possède le fait ; ici on n'en garde que le libellé.
 */

/** Ordre d'affichage de la collection — du plus accessible au plus lointain. */
export const BADGE_FAMILIES = ["debut", "serie", "maitrise", "arene", "saison"] as const;
export type BadgeFamily = (typeof BADGE_FAMILIES)[number];

/**
 * Les codes semés en base après le lot 2 (`night_owl` retiré, D-5).
 Les badges d'événement (lot 8) s'y ajouteront avec leur
 * migration — et leur ligne de traduction, faute de quoi `tsc` refusera.
 */
export const BADGE_CODES = [
  "first_quest",
  "level_10",
  "streak_7",
  "streak_30",
  "perfect_score",
  "speed_demon",
  "math_blitz",
  "math_master",
  "polyglot",
  "boss_slayer",
  "collector",
  "rich_kid",
  // é31 lot 5 — décerné par la clôture hebdo de ligue (R-14), famille `saison`.
  "league_podium",
  // é31 lot 8 — le badge de l'événement PILOTE. Chaque événement futur ajoute le
  // sien ici avec sa migration : sans sa ligne de traduction, `tsc` refuse.
  "event_rentree",
] as const;
export type BadgeCode = (typeof BADGE_CODES)[number];

/** Un code inconnu (badge semé hors de cette liste) reste affichable, sans libellé traduit. */
export function isKnownBadgeCode(code: string): code is BadgeCode {
  return (BADGE_CODES as readonly string[]).includes(code);
}

/** Une famille inconnue retombe en fin de collection plutôt que de disparaître. */
export function badgeFamilyRank(family: string): number {
  const index = (BADGE_FAMILIES as readonly string[]).indexOf(family);
  return index === -1 ? BADGE_FAMILIES.length : index;
}
