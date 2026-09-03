/**
 * Catalogue i18n de la COLLECTION DE BADGES — chargé avec la boutique, pas avec
 * l'application.
 *
 * Les libellés des badges (nom + condition, treize badges × trois langues) ne
 * servent QU'À `/boutique`, un chunk de route chargé dynamiquement. Les laisser
 * dans `TranslationKeys` les faisait descendre chez chaque élève, y compris
 * celui qui n'ouvre jamais la boutique. Ils vivent donc dans `./{fr,en,ar}.ts`,
 * que rollup isole dans le chunk `i18n-badges` (voir `vite.config.ts`).
 *
 * ⚠️ Ce module-ci n'est PAS dans ce chunk et ne doit pas y entrer : il importe
 * React et `../hooks`, donc le chunk de données réimporterait le chunk index et
 * refermerait le cycle i18n⇄index dont le crash TDZ a tué le bundle client une
 * première fois. Le chunk de données ne contient que des données.
 *
 * Même mécanique que `parent/` — et c'est la règle posée par
 * `scripts/check-bundle-budget.mjs` le 2026-08-26, appliquée plutôt que
 * contournée par un relèvement de plafond.
 */
import { useMemo } from "react";

import { useI18n } from "../hooks";
import type { BadgeTranslations } from "../badge.types";
import type { Locale, TranslationKeys } from "../types";
import { arBadges } from "./ar";
import { enBadges } from "./en";
import { frBadges } from "./fr";

const badgeCatalogs: Record<Locale, BadgeTranslations> = {
  ar: arBadges,
  en: enBadges,
  fr: frBadges,
};

/** Le catalogue app-wide augmenté du namespace de la collection. */
export type BadgeTranslationKeys = TranslationKeys & BadgeTranslations;

/** Accès hors composant (tests, helpers purs) au catalogue d'une locale. */
export function badgeTranslations(locale: Locale): BadgeTranslations {
  return badgeCatalogs[locale];
}

/** Équivalent de `useT()` pour la collection : mêmes clés, plus `badgeCollection.*`. */
export function useBadgeT(): BadgeTranslationKeys {
  const { locale, t } = useI18n();
  return useMemo(() => ({ ...t, ...badgeCatalogs[locale] }), [locale, t]);
}
