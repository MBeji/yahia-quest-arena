/**
 * Catalogue i18n de la **surface parent** — chargé avec les écrans parent, pas
 * avec l'application.
 *
 * `parentReport.*` + `parentDaily.*` pèsent ~42 KB de source (~36 KB une fois
 * bundlés) et ne servent QU'aux comptes parent : `/suivi` et `/parent-report`,
 * deux chunks de route chargés dynamiquement. Les laisser dans `TranslationKeys`
 * les faisait descendre chez chaque élève. Ils vivent donc dans `./{fr,en,ar}.ts`,
 * que le rollup isole dans le chunk `i18n-parent` (voir `vite.config.ts`) —
 * atteignable seulement depuis ces deux routes.
 *
 * ⚠️ Ce module-ci n'est PAS dans ce chunk, et ne doit pas y entrer : il importe
 * React et `../hooks`, donc le chunk de données rimporterait le chunk index et
 * refermerait le cycle i18n⇄index dont le crash TDZ a tué le bundle client une
 * première fois (cf. le commentaire de `manualChunks`). Le chunk `i18n-parent`
 * ne contient que des données, sans un seul import runtime.
 *
 * `useParentT()` rend le catalogue app-wide **fusionné** avec celui-ci : un écran
 * parent a besoin des deux (`t.common.back` autant que `t.parentDaily.tabSummary`),
 * et la fusion garde tous les chemins de clés inchangés — un composant parent
 * remplace `useT()` par `useParentT()`, rien d'autre ne bouge.
 */
import { useMemo } from "react";
import { useI18n } from "../hooks";
import type { ParentTranslations } from "../parent.types";
import type { Locale, TranslationKeys } from "../types";
import { arParent } from "./ar";
import { enParent } from "./en";
import { frParent } from "./fr";

const parentCatalogs: Record<Locale, ParentTranslations> = {
  ar: arParent,
  en: enParent,
  fr: frParent,
};

/** Le catalogue app-wide augmenté des namespaces parent. */
export type ParentTranslationKeys = TranslationKeys & ParentTranslations;

/** Accès hors composant (tests, helpers purs) au catalogue parent d'une locale. */
export function parentTranslations(locale: Locale): ParentTranslations {
  return parentCatalogs[locale];
}

/**
 * Équivalent de `useT()` pour les écrans parent : mêmes clés, plus
 * `parentReport.*` et `parentDaily.*`.
 */
export function useParentT(): ParentTranslationKeys {
  const { locale, t } = useI18n();
  return useMemo(() => ({ ...t, ...parentCatalogs[locale] }), [locale, t]);
}
