/**
 * Catalogue i18n du TEST DE NIVEAU (étude 39) — chargé avec les écrans du test, pas avec
 * l'application.
 *
 * ⚠️ Ce module-ci n'est PAS dans le chunk de données et ne doit pas y entrer : il importe
 * React et `../hooks`, donc le chunk de données réimporterait le chunk index et refermerait le
 * cycle i18n⇄index dont le crash TDZ a tué le bundle client une première fois. Le chunk de
 * données ne contient que des données — règle posée par `badges/index.ts`, appliquée telle
 * quelle.
 *
 * `vite.config.ts` isole `./{fr,en,ar}.ts` dans le chunk `i18n-placement`, dont
 * `scripts/check-bundle-budget.mjs` tient le budget.
 */
import { useMemo } from "react";

import { useI18n } from "../hooks";
import type { PlacementTranslations } from "../placement.types";
import type { Locale, TranslationKeys } from "../types";
import { arPlacement } from "./ar";
import { enPlacement } from "./en";
import { frPlacement } from "./fr";

const placementCatalogs: Record<Locale, PlacementTranslations> = {
  ar: arPlacement,
  en: enPlacement,
  fr: frPlacement,
};

/** Le catalogue app-wide augmenté du namespace du test de niveau. */
export type PlacementTranslationKeys = TranslationKeys & PlacementTranslations;

/** Accès hors composant (tests, helpers purs) au catalogue d'une locale. */
export function placementTranslations(locale: Locale): PlacementTranslations {
  return placementCatalogs[locale];
}

/** Équivalent de `useT()` pour le test de niveau : mêmes clés, plus `placement.*`. */
export function usePlacementT(): PlacementTranslationKeys {
  const { locale, t } = useI18n();
  return useMemo(() => ({ ...t, ...placementCatalogs[locale] }), [locale, t]);
}
