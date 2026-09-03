import type { BadgeCode, BadgeFamily } from "@/shared/constants/badges";

/**
 * La COLLECTION DE BADGES — le namespace de la vitrine, sorti de
 * `TranslationKeys` avec ses valeurs (`badges/{fr,en,ar}.ts`).
 *
 * ⚠️ Même statut que `parent.types.ts`, et pour la même raison : ces libellés ne
 * servent QU'À `/boutique`, une route chargée dynamiquement. Les laisser dans le
 * catalogue app-wide les faisait descendre chez tout le monde — élève qui
 * n'ouvre jamais la boutique compris — pour ~5 KB. C'est exactement la règle que
 * `scripts/check-bundle-budget.mjs` a posée le 2026-08-26 : « une microcopy qui
 * ne sert qu'à une surface atteinte par des routes paresseuses prend son
 * catalogue et son budget ».
 *
 * La garantie de complétude ne change pas : `Record<BadgeCode, …>` fait échouer
 * `tsc` sur un badge sans sa ligne, dans les trois langues (é31 R-13/R-22).
 */
export type BadgeTranslations = {
  badgeCollection: {
    families: Record<BadgeFamily, string>;
    labels: Record<BadgeCode, { name: string; condition: string }>;
    /** Compteur d'une famille : « 3/5 ». */
    familyProgress: string;
    locked: string;
    collectionProgress: string;
  };
};
