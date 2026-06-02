import { useCallback, useEffect, useState } from "react";
import type { Locale, TranslationKeys } from "./types";
import { en } from "./en";
import { fr } from "./fr";
import { ar } from "./ar";
import { DEFAULT_LOCALE, I18nContext, STORAGE_KEY } from "./context";

const translations: Record<Locale, TranslationKeys> = { en, fr, ar };

function getInitialLocale(): Locale {
  if (typeof window === "undefined") return DEFAULT_LOCALE;
  const stored = localStorage.getItem(STORAGE_KEY);
  if (stored && (stored === "en" || stored === "fr" || stored === "ar")) {
    return stored;
  }
  return DEFAULT_LOCALE;
}

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
    <I18nContext.Provider value={{ locale, t, setLocale, dir }}>{children}</I18nContext.Provider>
  );
}
