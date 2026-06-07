/**
 * Show non-school subjects in the language selected at the top of the site.
 *
 * Trilingual themes (e.g. `culture-generale`, `muscle-cerveau`) ship one sibling
 * subject per language, so the catalogue should follow the UI language picker.
 * Rule, applied per theme: if the theme has at least one subject in the active
 * locale, keep only those; otherwise keep the theme's subjects unchanged
 * (fallback) — so single-language tracks (the language-learning themes, or any
 * theme not yet translated into the locale) are never hidden. Original order is
 * preserved. School subjects (shown by grade, not by this helper) are unaffected.
 */
export function filterSubjectsByLocale<
  T extends { theme_id: string | null; content_language: string },
>(subjects: T[], locale: string): T[] {
  const themesWithLocale = new Set(
    subjects.filter((s) => s.content_language === locale).map((s) => s.theme_id),
  );
  return subjects.filter((s) =>
    themesWithLocale.has(s.theme_id) ? s.content_language === locale : true,
  );
}
