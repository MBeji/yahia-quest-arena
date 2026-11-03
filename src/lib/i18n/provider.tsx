import { useCallback, useEffect, useLayoutEffect, useRef, useState } from "react";
import type { Locale } from "./types";
import { fr } from "./fr";
import { loadCatalogue, loadedCatalogue, persistedLocale } from "./catalogues";
import {
  DEFAULT_LOCALE,
  I18nContext,
  LOCALE_COOKIE,
  STORAGE_KEY,
  dirForLocale,
  localeFromCookieHeader,
} from "./context";

const COOKIE_MAX_AGE = 60 * 60 * 24 * 365; // 1 year

function writeLocaleCookie(locale: Locale): void {
  document.cookie = `${LOCALE_COOKIE}=${locale}; path=/; max-age=${COOKIE_MAX_AGE}; SameSite=Lax`;
}

export function I18nProvider({ children }: { children: React.ReactNode }) {
  // Start at DEFAULT_LOCALE so the first client render matches the SSR-rendered
  // body markup (server renders with DEFAULT_LOCALE). The real locale is applied
  // after hydration in the effect below — this avoids a hydration mismatch in the
  // translated body content. The SSR shell sets <html lang/dir> from the cookie
  // (see __root.tsx) so RTL/lang are correct on first paint without FOUC.
  const [locale, setLocaleState] = useState<Locale>(DEFAULT_LOCALE);
  const request = useRef(0);

  // H2-fe (2026-10-31) : en/ar ne sont plus importés statiquement, leur chunk est
  // tiré par `loadCatalogue`. `locale` ne bascule qu'une fois son catalogue chargé,
  // donc `t` et `locale` concordent toujours ; un catalogue déjà là (fr, toujours)
  // bascule de façon synchrone. Le compteur fait gagner la dernière demande quand
  // deux bascules se croisent pendant un chargement.
  const applyLocale = useCallback((next: Locale) => {
    const id = ++request.current;
    if (loadedCatalogue(next)) {
      setLocaleState(next);
      return;
    }
    void loadCatalogue(next).then(() => {
      if (request.current === id) setLocaleState(next);
    });
  }, []);

  // Apply the persisted locale (localStorage, then cookie) after mount.
  useEffect(() => {
    const initial = persistedLocale();
    // One-time migration (review #8): legacy users who only have the localStorage
    // value (set before the cookie existed) would otherwise flash the default locale
    // on every SSR load until their next setLocale call writes the cookie. Mirror the
    // resolved locale into the cookie whenever it's missing/stale so the SSR shell
    // reads the right <html lang/dir> from the next request onward.
    if (localeFromCookieHeader(document.cookie) !== initial) {
      writeLocaleCookie(initial);
    }
    applyLocale(initial);
  }, [applyLocale]);

  const setLocale = useCallback(
    (newLocale: Locale) => {
      localStorage.setItem(STORAGE_KEY, newLocale);
      writeLocaleCookie(newLocale);
      applyLocale(newLocale);
    },
    [applyLocale],
  );

  // <html dir/lang> suit la locale appliquée (après hydratation et à chaque bascule).
  // Effet de layout : il tourne dans le même commit que le texte traduit, avant la
  // peinture, pour que sens et texte basculent ensemble — jamais du français en RTL
  // (un effet passif l'a laissé passer une fois sous charge, 2026-10-31).
  useLayoutEffect(() => {
    document.documentElement.dir = dirForLocale(locale);
    document.documentElement.lang = locale;
  }, [locale]);

  const t = loadedCatalogue(locale) ?? fr;
  const dir = dirForLocale(locale);

  return (
    <I18nContext.Provider value={{ locale, t, setLocale, dir }}>{children}</I18nContext.Provider>
  );
}
