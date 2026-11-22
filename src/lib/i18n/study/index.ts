/**
 * Catalogue i18n du BILAN ET DU PROGRAMME DU JOUR — chargé avec ses surfaces
 * (carte du tableau de bord, écran « Mon bilan », suivi parental), pas avec
 * l'application.
 *
 * ⚠️ Même règle que `progress/index.ts` : ce module-ci importe React et
 * `../hooks`, il ne doit donc PAS entrer dans le chunk de données.
 * `vite.config.ts` isole `./{fr,en,ar}.ts` dans le chunk `i18n-study`, dont
 * `scripts/check-bundle-budget.mjs` tient le budget.
 */
import { useMemo } from "react";

import { useI18n } from "../hooks";
import type { StudyTranslations } from "../study.types";
import type { Locale, TranslationKeys } from "../types";
import { arStudy } from "./ar";
import { enStudy } from "./en";
import { frStudy } from "./fr";

const studyCatalogs: Record<Locale, StudyTranslations> = {
  ar: arStudy,
  en: enStudy,
  fr: frStudy,
};

/** Le catalogue app-wide augmenté du namespace du bilan. */
export type StudyTranslationKeys = TranslationKeys & StudyTranslations;

/** Accès hors composant (tests, helpers purs) au catalogue d'une locale. */
export function studyTranslations(locale: Locale): StudyTranslations {
  return studyCatalogs[locale];
}

/** Équivalent de `useT()` pour le bilan : mêmes clés, plus `study.*`. */
export function useStudyT(): StudyTranslationKeys {
  const { locale, t } = useI18n();
  return useMemo(() => ({ ...t, ...studyCatalogs[locale] }), [locale, t]);
}
