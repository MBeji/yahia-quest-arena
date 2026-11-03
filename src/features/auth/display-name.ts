/**
 * The one rule for a display name (« pseudo ») — shared by every path that writes
 * `profiles.display_name`.
 *
 * It exists because the pseudo is now written from TWO surfaces: signup
 * (`bootstrapProfile`) and account settings (`updateDisplayName`). Two inline
 * validators would drift, and drift here has a nasty shape: a rule stricter than
 * signup's locks an existing user out of editing a pseudo the app itself gave them.
 * One rule, both callers, no drift: the constants below, the pure predicate for
 * the settings form, and the zod schema in `./display-name.schema` (server fns),
 * which is derived from the SAME constants.
 */

/** Longest accepted pseudo — the bound signup has always enforced server-side. */
export const DISPLAY_NAME_MAX_LENGTH = 80;

/**
 * Invisible characters, refused in a pseudo.
 *
 * `Cc` (controls) covers newlines and tabs, which would break every one-line
 * surface the pseudo appears on — dashboard hero, leaderboard row, parent report.
 * `Cf` (format) covers zero-width characters and, above all, the bidi overrides
 * (U+202E & co): a pseudo carrying one renders as a DIFFERENT name than the string
 * stored, which on a shared leaderboard is impersonation, not decoration.
 *
 * Everything else stays welcome — accents, emoji, and Arabic all pass, as they must
 * in a trilingual product.
 */
export const INVISIBLE_CHARACTERS = /[\p{Cc}\p{Cf}]/u;

/**
 * La règle elle-même, en TypeScript pur : on rogne d'abord (« Yahia » et
 * «  Yahia  » sont un seul pseudo, et c'est la forme rognée qui est stockée),
 * puis la longueur et les invisibles se jugent sur la valeur rognée.
 *
 * Sans zod, à dessein (2026-10-31) : ce prédicat sert au formulaire de
 * /parametrage, et `displayNameSchema` — le même en zod, pour les validateurs
 * des server fns — vit dans `./display-name.schema`. Le schéma est DÉRIVÉ de ces
 * deux constantes ; `display-name.test.ts` épingle que les deux jugent pareil.
 * Avant, le prédicat appelait `schema.safeParse`, et ce seul appel servait zod
 * entier (84 KB) à tout élève qui ouvrait ses réglages.
 */
export function isValidDisplayName(raw: string): boolean {
  const value = raw.trim();
  return (
    value.length >= 1 &&
    value.length <= DISPLAY_NAME_MAX_LENGTH &&
    !INVISIBLE_CHARACTERS.test(value)
  );
}
