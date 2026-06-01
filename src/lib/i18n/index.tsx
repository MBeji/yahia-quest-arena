import { createContext, useCallback, useContext, useEffect, useState } from "react";
import type { Locale, TranslationKeys } from "./types";
import { en } from "./en";
import { fr } from "./fr";
import { ar } from "./ar";

const translations: Record<Locale, TranslationKeys> = { en, fr, ar };

const STORAGE_KEY = "xp-scholars-locale";
const DEFAULT_LOCALE: Locale = "en";

function getInitialLocale(): Locale {
  if (typeof window === "undefined") return DEFAULT_LOCALE;
  const stored = localStorage.getItem(STORAGE_KEY);
  if (stored && (stored === "en" || stored === "fr" || stored === "ar")) {
    return stored;
  }
  return DEFAULT_LOCALE;
}

type I18nContextValue = {
  locale: Locale;
  t: TranslationKeys;
  setLocale: (locale: Locale) => void;
  dir: "ltr" | "rtl";
};

const I18nContext = createContext<I18nContextValue>({
  locale: DEFAULT_LOCALE,
  t: en,
  setLocale: () => {},
  dir: "ltr",
});

export function I18nProvider({ children }: { children: React.ReactNode }) {
  const [locale, setLocaleState] = useState<Locale>(DEFAULT_LOCALE);

  useEffect(() => {
    setLocaleState(getInitialLocale());
  }, []);

  const setLocale = useCallback((newLocale: Locale) => {
    setLocaleState(newLocale);
    localStorage.setItem(STORAGE_KEY, newLocale);
    // Update document direction for Arabic
    document.documentElement.dir = newLocale === "ar" ? "rtl" : "ltr";
    document.documentElement.lang = newLocale;
  }, []);

  // Set initial dir on mount
  useEffect(() => {
    document.documentElement.dir = locale === "ar" ? "rtl" : "ltr";
    document.documentElement.lang = locale;
  }, [locale]);

  const t = translations[locale];
  const dir = locale === "ar" ? "rtl" : "ltr";

  return (
    <I18nContext.Provider value={{ locale, t, setLocale, dir }}>
      {children}
    </I18nContext.Provider>
  );
}

export function useI18n() {
  return useContext(I18nContext);
}

export function useT() {
  return useContext(I18nContext).t;
}

export { type Locale, type TranslationKeys };
