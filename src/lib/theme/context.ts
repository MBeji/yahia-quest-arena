import { createContext } from "react";

/**
 * UI colour scheme. `dark` is the original Shonen Neon arena (default); `light`
 * is the clean Atome-style variant (white canvas + electric-lime accent). These are NOT the curriculum
 * `themes` table (that is content organisation) — this is purely the visual skin.
 */
export type Theme = "dark" | "light";

export const THEME_STORAGE_KEY = "xp-scholars-theme";
/** Cookie name mirrors the storage key so the SSR shell can set <html class>. */
export const THEME_COOKIE = "xp-scholars-theme";
export const DEFAULT_THEME: Theme = "dark";
export const THEMES: readonly Theme[] = ["dark", "light"];

export function isTheme(value: string | null | undefined): value is Theme {
  return value === "dark" || value === "light";
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
  toggleTheme: () => void;
};

export const ThemeContext = createContext<ThemeContextValue>({
  theme: DEFAULT_THEME,
  setTheme: () => {},
  toggleTheme: () => {},
});
