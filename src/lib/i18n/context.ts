import { createContext } from "react";
import type { Locale, TranslationKeys } from "./types";
import { en } from "./en";

export const STORAGE_KEY = "xp-scholars-locale";
export const DEFAULT_LOCALE: Locale = "en";

export type I18nContextValue = {
  locale: Locale;
  t: TranslationKeys;
  setLocale: (locale: Locale) => void;
  dir: "ltr" | "rtl";
};

export const I18nContext = createContext<I18nContextValue>({
  locale: DEFAULT_LOCALE,
  t: en,
  setLocale: () => {},
  dir: "ltr",
});
