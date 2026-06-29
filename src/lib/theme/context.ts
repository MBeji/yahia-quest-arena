import { createContext } from "react";

/**
 * UI colour scheme — the user-selectable visual skin, applied globally as a single
 * `<html>` class and persisted (localStorage + cookie). `reference` is the sober
 * white + teal reading register (the default); `light` is the clean Atome variant
 * (white + electric lime); `dark` is the original Shonen Neon arena. These are NOT
 * the curriculum `themes` table (content organisation) — purely the visual skin.
 */
export type Theme = "dark" | "light" | "reference";

export const THEME_STORAGE_KEY = "xp-scholars-theme";
/** Cookie name mirrors the storage key so the SSR shell can set <html class>. */
export const THEME_COOKIE = "xp-scholars-theme";
export const DEFAULT_THEME: Theme = "reference";
/** Display order in the theme picker. */
export const THEMES: readonly Theme[] = ["reference", "light", "dark"];

export function isTheme(value: string | null | undefined): value is Theme {
  return value === "dark" || value === "light" || value === "reference";
}

/** Parse the theme from a raw Cookie header value (SSR-safe, no browser APIs). */
export function themeFromCookieHeader(cookieHeader: string | null | undefined): Theme {
  if (!cookieHeader) return DEFAULT_THEME;
  for (const part of cookieHeader.split(";")) {
    const [rawName, ...rawValue] = part.split("=");
    if (rawName?.trim() === THEME_COOKIE) {
      const value = decodeURIComponent(rawValue.join("=").trim());
      if (isTheme(value)) return value;
    }
  }
  return DEFAULT_THEME;
}

export type ThemeContextValue = {
  theme: Theme;
  setTheme: (theme: Theme) => void;
};

export const ThemeContext = createContext<ThemeContextValue>({
  theme: DEFAULT_THEME,
  setTheme: () => {},
});
