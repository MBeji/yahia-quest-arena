import { useCallback, useEffect, useState } from "react";
import {
  DEFAULT_THEME,
  THEME_COOKIE,
  THEME_STORAGE_KEY,
  ThemeContext,
  isTheme,
  themeFromCookieHeader,
  type Theme,
} from "./context";

const COOKIE_MAX_AGE = 60 * 60 * 24 * 365; // 1 year

function getInitialTheme(): Theme {
  if (typeof window === "undefined") return DEFAULT_THEME;
  // localStorage is the primary client-side preference (setTheme writes both it
  // and the cookie, so they normally agree). The cookie is a fallback that also
  // lets the SSR shell read the theme for the <html> class (see __root.tsx).
  const stored = localStorage.getItem(THEME_STORAGE_KEY);
  if (isTheme(stored)) return stored;
  return themeFromCookieHeader(document.cookie);
}

/** Reflect the active theme as a single class on <html> for the CSS variants. */
function applyThemeClass(theme: Theme) {
  const root = document.documentElement;
  root.classList.remove("dark", "light", "reference");
  root.classList.add(theme);
}

function persistTheme(theme: Theme) {
  localStorage.setItem(THEME_STORAGE_KEY, theme);
  document.cookie = `${THEME_COOKIE}=${theme}; path=/; max-age=${COOKIE_MAX_AGE}; SameSite=Lax`;
  applyThemeClass(theme);
}

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  // Start at DEFAULT_THEME so the first client render matches the SSR-rendered
  // body markup (the Toaster reads `theme` from context). The persisted theme is
  // applied post-mount; the <html> class is already correct from the SSR shell
  // (set from the same cookie in __root.tsx), so there is no flash of the wrong
  // theme — only the (toast-less) Toaster prop settles after hydration.
  const [theme, setThemeState] = useState<Theme>(DEFAULT_THEME);

  // Apply the persisted theme (localStorage, then cookie) after mount.
  useEffect(() => {
    setThemeState(getInitialTheme());
  }, []);

  // Keep the <html> class in sync with the active theme after hydration (covers
  // cookie-less localStorage users and client navigations).
  useEffect(() => {
    applyThemeClass(theme);
  }, [theme]);

  const setTheme = useCallback((next: Theme) => {
    setThemeState(next);
    persistTheme(next);
  }, []);

  return <ThemeContext.Provider value={{ theme, setTheme }}>{children}</ThemeContext.Provider>;
}
