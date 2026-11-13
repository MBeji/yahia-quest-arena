/**
 * Catalogue i18n d'« INVITER MON PARENT » (étude 40, lot 5) — chargé avec le bouton du paramétrage
 * et la carte de l'écran de résultat, pas avec l'application. Pourquoi : `../invite.types.ts`.
 * Trois langues d'un coup (moins d'un kilo-octet) : la carte paraît sur un écran déjà affiché,
 * elle n'attend pas le réseau pour connaître son texte.
 */
import { useI18n } from "../hooks";
import type { InviteTranslations } from "../invite.types";
import type { Locale } from "../types";
import { arInvite } from "./ar";
import { enInvite } from "./en";
import { frInvite } from "./fr";

const inviteCatalogs: Record<Locale, InviteTranslations> = {
  ar: arInvite,
  en: enInvite,
  fr: frInvite,
};

/** Les textes de l'invitation dans la langue de l'interface. */
export function useInviteT(): InviteTranslations {
  const { locale } = useI18n();
  return inviteCatalogs[locale];
}
