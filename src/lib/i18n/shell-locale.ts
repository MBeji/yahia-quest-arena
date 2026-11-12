import { createIsomorphicFn } from "@tanstack/react-start";
import { getRequestHeader } from "@tanstack/react-start/server";
import type { Locale } from "./types";
import { DEFAULT_LOCALE, localeFromCookieHeader } from "./context";

/**
 * La langue de la REQUÊTE : celle du cookie que l'élève a persisté, lue du même
 * endroit des deux côtés — l'en-tête `Cookie` au rendu serveur, `document.cookie`
 * dans le navigateur. Elle décide de tout ce que le serveur rend : `<html lang dir>`,
 * la méta du document (`__root.tsx`) et, depuis le 2026-11-12, le texte du corps
 * (`router.tsx` charge le catalogue de cette langue avant le premier rendu).
 *
 * Le cookie est la SEULE source commune au serveur et au client : `localStorage`,
 * que le client préfère ensuite (`persistedLocale`), n'existe pas côté serveur. Le
 * rendu d'hydratation part donc du cookie, et `I18nProvider` ne réconcilie avec
 * `localStorage` qu'après le montage.
 *
 * Module à part, importé par `router.tsx` et `__root.tsx` seulement : la branche
 * `.server()` et son import sont retirés du bundle client par la frontière isomorphe.
 */
export const getShellLocale = createIsomorphicFn()
  .client((): Locale => localeFromCookieHeader(document.cookie))
  .server((): Locale => {
    try {
      return localeFromCookieHeader(getRequestHeader("cookie"));
    } catch {
      return DEFAULT_LOCALE;
    }
  });
