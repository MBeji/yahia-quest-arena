/**
 * Catalogue i18n des ÉTOILES ET DES SCEAUX (étude 34, R-17) — chargé avec les
 * écrans de progression, pas avec l'application.
 *
 * ⚠️ Ce module-ci n'est PAS dans le chunk de données et ne doit pas y entrer : il
 * importe React et `../hooks`, donc le chunk de données réimporterait le chunk
 * index et refermerait le cycle i18n⇄index dont le crash TDZ a tué le bundle
 * client une première fois. Le chunk de données ne contient que des données —
 * c'est la règle posée par `badges/index.ts`, appliquée telle quelle.
 *
 * `vite.config.ts` isole `./{fr,en,ar}.ts` dans le chunk `i18n-progress`, dont
 * `scripts/check-bundle-budget.mjs` tient le budget (16 KB).
 */
import { useMemo } from "react";

import { useI18n } from "../hooks";
import type { ProgressTranslations } from "../progress.types";
import type { Locale, TranslationKeys } from "../types";
import { arProgress } from "./ar";
import { enProgress } from "./en";
import { frProgress } from "./fr";

const progressCatalogs: Record<Locale, ProgressTranslations> = {
  ar: arProgress,
  en: enProgress,
  fr: frProgress,
};

/** Le catalogue app-wide augmenté du namespace de la progression. */
export type ProgressTranslationKeys = TranslationKeys & ProgressTranslations;

/** Accès hors composant (tests, helpers purs) au catalogue d'une locale. */
export function progressTranslations(locale: Locale): ProgressTranslations {
  return progressCatalogs[locale];
}

/** Équivalent de `useT()` pour la progression : mêmes clés, plus `progress.*`. */
export function useProgressT(): ProgressTranslationKeys {
  const { locale, t } = useI18n();
  return useMemo(() => ({ ...t, ...progressCatalogs[locale] }), [locale, t]);
}
