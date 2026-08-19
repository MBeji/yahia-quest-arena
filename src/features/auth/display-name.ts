import { z } from "zod";

/**
 * The one rule for a display name (« pseudo ») — shared by every path that writes
 * `profiles.display_name`.
 *
 * It exists because the pseudo is now written from TWO surfaces: signup
 * (`bootstrapProfile`) and account settings (`updateDisplayName`). Two inline
 * validators would drift, and drift here has a nasty shape: a rule stricter than
 * signup's locks an existing user out of editing a pseudo the app itself gave them.
 * One schema, both callers, no drift.
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
const INVISIBLE_CHARACTERS = /[\p{Cc}\p{Cf}]/u;

/**
 * Parse/validate a pseudo. Trims first, so " Yahia " and "Yahia" are one value —
 * the trimmed form is what gets stored.
 */
export const displayNameSchema = z
  .string()
  .trim()
  .min(1)
  .max(DISPLAY_NAME_MAX_LENGTH)
  .refine((value) => !INVISIBLE_CHARACTERS.test(value), {
    message: "display_name_invalid_characters",
  });

/**
 * Client-side mirror of the same rule, so the settings form can refuse a pseudo
 * before the round-trip instead of after it. Deliberately derived from the schema
 * rather than re-implemented — a second regex here would be the drift this module
 * exists to prevent.
 */
export function isValidDisplayName(raw: string): boolean {
  return displayNameSchema.safeParse(raw).success;
}
