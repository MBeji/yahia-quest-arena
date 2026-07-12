/** The three localized name columns a parcours row may carry. */
export type LocalizedParcoursName = {
  name_fr: string;
  name_en?: string | null;
  name_ar?: string | null;
};

/**
 * Localized display name of a parcours (étude 15, lot 3 — R-6). `name_fr` is
 * the always-present source of truth (seed data); `name_en`/`name_ar` are the
 * translations populated by migration 20260711120000. Any missing/empty
 * translation falls back to French rather than rendering a blank card.
 */
export function parcoursName(p: LocalizedParcoursName, locale: string): string {
  const localized = locale === "ar" ? p.name_ar : locale === "en" ? p.name_en : p.name_fr;
  return localized && localized.trim() !== "" ? localized : p.name_fr;
}
