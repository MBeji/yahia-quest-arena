import type { Locale, TranslationKeys } from "./types";
import { fr } from "./fr";
import { loadedCatalogue } from "./catalogues";
import { getShellLocale } from "./shell-locale";

/**
 * Le titre d'onglet d'une route, dans la langue de la requête.
 *
 * `head()` s'exécute hors de l'arbre React : pas de `useT()`. Mais depuis le
 * 2026-11-12 `router.tsx` charge le catalogue de la langue du cookie AVANT tout
 * rendu, serveur comme client — il est donc lisible ici de façon synchrone. Les
 * titres étaient des littéraux français dans chaque fichier de route : l'élève
 * arabophone lisait « Classement · Na9ra Nal3ab » dans son onglet (issue #1228,
 * `route-titles-french-only`).
 *
 * Le visiteur sans cookie — donc tout robot d'indexation — reçoit le français :
 * les titres français des pages publiques sont repris tels quels dans
 * `public.titles`, le référencement ne bouge pas.
 */
const BRAND: Record<Locale, string> = {
  fr: "Na9ra Nal3ab",
  en: "Na9ra Nal3ab",
  ar: "نقرا نلعب",
};

/** Le catalogue de la langue de la requête (français si son chunk a manqué). */
export function headCatalogue(): TranslationKeys {
  return loadedCatalogue(getShellLocale()) ?? fr;
}

/** « {libellé} · {marque} », le libellé étant lu dans le catalogue de la requête. */
export function pageTitle(pick: (t: TranslationKeys) => string): string {
  const locale = getShellLocale();
  const t = loadedCatalogue(locale);
  return t ? `${pick(t)} · ${BRAND[locale]}` : `${pick(fr)} · ${BRAND.fr}`;
}
