// Public API barrel for the UI theme — import from "@/lib/theme"
export { ThemeProvider } from "./provider";
export { useTheme } from "./hooks";
export {
  DEFAULT_THEME,
  THEME_COOKIE,
  THEME_STORAGE_KEY,
  THEMES,
  isTheme,
  themeFromCookieHeader,
  type Theme,
} from "./context";
