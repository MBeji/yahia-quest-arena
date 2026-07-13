import { createContext } from "react";

/**
 * UI colour scheme — the user-selectable visual skin, applied globally as a single
 * `<html>` class and persisted (localStorage + cookie). Exactly TWO themes (étude 14,
 * arbitrage Q-1): `reference` is the sober white + teal reading register (the default);
 * `dark` is the black & gold arena. The former `light` (Atome lime) theme was removed —
 * a persisted `light` preference silently migrates to `reference`. These are NOT the
 * curriculum `themes` table (content organisation) — purely the visual skin.
 */
export type Theme = "dark" | "reference";

export const THEME_STORAGE_KEY = "xp-scholars-theme";
/** Cookie name mirrors the storage key so the SSR shell can set <html class>. */
export const THEME_COOKIE = "xp-scholars-theme";
export const DEFAULT_THEME: Theme = "reference";
/** Display order in the theme picker. */
export const THEMES: readonly Theme[] = ["reference", "dark"];

export function isTheme(value: string | null | undefined): value is Theme {
  return value === "dark" || value === "reference";
}

/**
 * Coerce any persisted value (localStorage/cookie) to a valid theme.
 * Legacy `light` (removed 2026-07, étude 14 Q-1) lands on `reference`,
 * its closest surviving register; anything unknown falls back to the default.
 */
export function normalizeTheme(value: string | null | undefined): Theme {
  if (isTheme(value)) return value;
  return DEFAULT_THEME;
}

/** Parse the theme from a raw Cookie header value (SSR-safe, no browser APIs). */
export function themeFromCookieHeader(cookieHeader: string | null | undefined): Theme {
  if (!cookieHeader) return DEFAULT_THEME;
  for (const part of cookieHeader.split(";")) {
    const [rawName, ...rawValue] = part.split("=");
    if (rawName?.trim() === THEME_COOKIE) {
      const value = decodeURIComponent(rawValue.join("=").trim());
      return normalizeTheme(value);
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
