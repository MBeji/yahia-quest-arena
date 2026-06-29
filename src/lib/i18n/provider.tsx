import { useCallback, useEffect, useState } from "react";
import type { Locale, TranslationKeys } from "./types";
import { en } from "./en";
import { fr } from "./fr";
import { ar } from "./ar";
import {
  DEFAULT_LOCALE,
  I18nContext,
  LOCALE_COOKIE,
  STORAGE_KEY,
  dirForLocale,
  isLocale,
  localeFromCookieHeader,
} from "./context";

const translations: Record<Locale, TranslationKeys> = { en, fr, ar };

const COOKIE_MAX_AGE = 60 * 60 * 24 * 365; // 1 year

function writeLocaleCookie(locale: Locale): void {
  document.cookie = `${LOCALE_COOKIE}=${locale}; path=/; max-age=${COOKIE_MAX_AGE}; SameSite=Lax`;
}

function getInitialLocale(): Locale {
  if (typeof window === "undefined") return DEFAULT_LOCALE;
  // localStorage is the primary client-side preference (setLocale writes both it and
  // the cookie, so they normally agree). The cookie is a fallback that also lets the
  // SSR shell read the locale for <html lang/dir>. Applied post-mount, so this never
  // affects the first render's body markup (hydration-safe).
  const stored = localStorage.getItem(STORAGE_KEY);
  if (isLocale(stored)) return stored;
  return localeFromCookieHeader(document.cookie);
}

export function I18nProvider({ children }: { children: React.ReactNode }) {
  // Start at DEFAULT_LOCALE so the first client render matches the SSR-rendered
  // body markup (server renders with DEFAULT_LOCALE). The real locale is applied
  // after hydration in the effect below — this avoids a hydration mismatch in the
  // translated body content. The SSR shell sets <html lang/dir> from the cookie
  // (see __root.tsx) so RTL/lang are correct on first paint without FOUC.
  const [locale, setLocaleState] = useState<Locale>(DEFAULT_LOCALE);

  // Apply the persisted locale (localStorage, then cookie) after mount.
  useEffect(() => {
    const initial = getInitialLocale();
    setLocaleState(initial);
    // One-time migration (review #8): legacy users who only have the localStorage
    // value (set before the cookie existed) would otherwise flash the default locale
    // on every SSR load until their next setLocale call writes the cookie. Mirror the
    // resolved locale into the cookie whenever it's missing/stale so the SSR shell
    // reads the right <html lang/dir> from the next request onward.
    if (localeFromCookieHeader(document.cookie) !== initial) {
      writeLocaleCookie(initial);
    }
  }, []);

  const setLocale = useCallback((newLocale: Locale) => {
    setLocaleState(newLocale);
    localStorage.setItem(STORAGE_KEY, newLocale);
    writeLocaleCookie(newLocale);
    // Update document direction for Arabic
    document.documentElement.dir = dirForLocale(newLocale);
    document.documentElement.lang = newLocale;
  }, []);

  // Keep <html dir/lang> in sync after hydration (covers cookie-less localStorage users).
  useEffect(() => {
    document.documentElement.dir = dirForLocale(locale);
    document.documentElement.lang = locale;
  }, [locale]);

  const t = translations[locale];
  const dir = dirForLocale(locale);

  return (
    <I18nContext.Provider value={{ locale, t, setLocale, dir }}>{children}</I18nContext.Provider>
  );
}
