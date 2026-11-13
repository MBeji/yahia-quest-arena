/**
 * Catalogue i18n de L'INVITATION À INSTALLER (étude 40, lot 3) — chargé avec la carte, pas avec
 * l'application. Pourquoi : `../install.types.ts`.
 *
 * Trois langues d'un coup (un kilo-octet en tout) : la carte paraît sur un écran déjà affiché,
 * elle ne peut pas attendre un aller-retour réseau pour connaître son texte.
 */
import { useI18n } from "../hooks";
import type { InstallTranslations } from "../install.types";
import type { Locale } from "../types";
import { arInstall } from "./ar";
import { enInstall } from "./en";
import { frInstall } from "./fr";

const installCatalogs: Record<Locale, InstallTranslations> = {
  ar: arInstall,
  en: enInstall,
  fr: frInstall,
};

/** Les textes de la carte dans la langue de l'interface, et le sens d'écriture de celle-ci. */
export function useInstallT(): { copy: InstallTranslations; dir: "ltr" | "rtl" } {
  const { locale, dir } = useI18n();
  return { copy: installCatalogs[locale], dir };
}
