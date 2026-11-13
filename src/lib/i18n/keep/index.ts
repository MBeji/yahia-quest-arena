/**
 * Catalogue i18n de « GARDER CE CHAPITRE » (étude 40, lot 4) — chargé avec la rangée, pas avec
 * l'application. Pourquoi : `../keep.types.ts`. Trois langues d'un coup (moins d'un kilo-octet) :
 * la rangée paraît sur un écran déjà affiché, elle n'attend pas le réseau pour connaître son texte.
 */
import { useI18n } from "../hooks";
import type { KeepTranslations } from "../keep.types";
import type { Locale } from "../types";
import { arKeep } from "./ar";
import { enKeep } from "./en";
import { frKeep } from "./fr";

const keepCatalogs: Record<Locale, KeepTranslations> = { ar: arKeep, en: enKeep, fr: frKeep };

/** Les textes de la rangée dans la langue de l'interface, et le sens d'écriture de celle-ci. */
export function useKeepT(): { copy: KeepTranslations; dir: "ltr" | "rtl" } {
  const { locale, dir } = useI18n();
  return { copy: keepCatalogs[locale], dir };
}
