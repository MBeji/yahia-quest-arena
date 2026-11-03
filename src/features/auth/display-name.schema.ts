import { z } from "zod";
import { DISPLAY_NAME_MAX_LENGTH, INVISIBLE_CHARACTERS } from "./display-name";

/**
 * Parse/validate a pseudo for the server fns (`bootstrapProfile`,
 * `updateDisplayName`). Trims first, so " Yahia " and "Yahia" are one value —
 * the trimmed form is what gets stored.
 *
 * Même règle que `isValidDisplayName` (./display-name), construite sur les MÊMES
 * constantes — c'est le test co-localisé qui tient les deux ensemble. Fichier à
 * part (2026-10-31) pour que zod reste hors du bundle client : le compilateur de
 * TanStack Start retire cet import du stub `auth.server-*.js` avec les
 * validateurs, alors qu'un schéma de niveau module dans `display-name.ts` partait
 * dans le chunk de /parametrage.
 */
export const displayNameSchema = z
  .string()
  .trim()
  .min(1)
  .max(DISPLAY_NAME_MAX_LENGTH)
  .refine((value) => !INVISIBLE_CHARACTERS.test(value), {
    message: "display_name_invalid_characters",
  });
