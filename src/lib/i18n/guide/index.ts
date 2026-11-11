/**
 * Catalogue i18n du GUIDE INTÉGRÉ — chargé avec les surfaces qui l'affichent
 * (fiche d'aide paresseuse, hub matière, lecteur de cours, QG, suivi parent),
 * jamais avec le chunk index.
 *
 * ⚠️ Même règle que `progress/index.ts` : ce module importe React et `../hooks`,
 * il reste donc HORS du chunk de données ; `vite.config.ts` n'isole que
 * `./{fr,en,ar}.ts` dans `i18n-guide`, dont `scripts/check-bundle-budget.mjs`
 * tient le budget.
 */
import { useMemo } from "react";

import { useI18n } from "../hooks";
import type { GuideTranslations } from "../guide.types";
import type { Locale, TranslationKeys } from "../types";
import { arGuide } from "./ar";
import { enGuide } from "./en";
import { frGuide } from "./fr";

const guideCatalogs: Record<Locale, GuideTranslations> = {
  ar: arGuide,
  en: enGuide,
  fr: frGuide,
};

/** Le catalogue app-wide augmenté du namespace du guide. */
export type GuideTranslationKeys = TranslationKeys & GuideTranslations;

/** Accès hors composant (tests, helpers purs) au catalogue d'une locale. */
export function guideTranslations(locale: Locale): GuideTranslations {
  return guideCatalogs[locale];
}

/** Équivalent de `useT()` pour le guide : mêmes clés, plus `guide.*`. */
export function useGuideT(): GuideTranslationKeys {
  const { locale, t } = useI18n();
  return useMemo(() => ({ ...t, ...guideCatalogs[locale] }), [locale, t]);
}
