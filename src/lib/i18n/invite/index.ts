/**
 * Catalogue i18n de « INVITER MON PARENT » (étude 40, lot 5) — chargé avec le geste, pas avec
 * l'application. Pourquoi : `../invite.types.ts`. Trois langues d'un coup (moins d'un kilo-octet) :
 * le bouton paraît sur un écran déjà affiché, il n'attend pas le réseau pour connaître son texte.
 */
import { useI18n } from "../hooks";
import type { InviteTranslations } from "../invite.types";
import type { Locale } from "../types";
import { arInvite } from "./ar";
import { enInvite } from "./en";
import { frInvite } from "./fr";

export const inviteCatalogs: Record<Locale, InviteTranslations> = {
  ar: arInvite,
  en: enInvite,
  fr: frInvite,
};

/** Les textes du geste dans la langue de l'interface, et le sens d'écriture de celle-ci. */
export function useInviteT(): { copy: InviteTranslations; dir: "ltr" | "rtl" } {
  const { locale, dir } = useI18n();
  return { copy: inviteCatalogs[locale], dir };
}
