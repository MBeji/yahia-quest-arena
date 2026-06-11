import { createContext } from "react";
import type { Locale, TranslationKeys } from "./types";
import { fr } from "./fr";

export const STORAGE_KEY = "xp-scholars-locale";
/** Cookie name mirrors the locale so the SSR shell can set <html lang/dir>. */
export const LOCALE_COOKIE = "xp-scholars-locale";
/** French-first: the product targets the Tunisian market (GAP-010). */
export const DEFAULT_LOCALE: Locale = "fr";

export function isLocale(value: string | null | undefined): value is Locale {
  return value === "en" || value === "fr" || value === "ar";
}

export function dirForLocale(locale: Locale): "ltr" | "rtl" {
  return locale === "ar" ? "rtl" : "ltr";
}

/** Parse the locale from a raw Cookie header value (SSR-safe, no browser APIs). */
export function localeFromCookieHeader(cookieHeader: string | null | undefined): Locale {
  if (!cookieHeader) return DEFAULT_LOCALE;
  for (const part of cookieHeader.split(";")) {
    const [rawName, ...rawValue] = part.split("=");
    if (rawName?.trim() === LOCALE_COOKIE) {
      const value = decodeURIComponent(rawValue.join("=").trim());
      if (isLocale(value)) return value;
    }
  }
  return DEFAULT_LOCALE;
}

export type I18nContextValue = {
  locale: Locale;
  t: TranslationKeys;
  setLocale: (locale: Locale) => void;
  dir: "ltr" | "rtl";
};

export const I18nContext = createContext<I18nContextValue>({
  locale: DEFAULT_LOCALE,
  t: fr,
  setLocale: () => {},
  dir: "ltr",
});
