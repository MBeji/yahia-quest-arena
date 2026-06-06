import { Moon, Sun } from "lucide-react";
import { useTheme } from "@/lib/theme";

/**
 * Compact dark/light toggle. Mirrors the LanguageSwitcher chrome so it sits
 * cleanly beside it in the nav. The icon swap is a pure-CSS rotate/fade (no
 * animation lib) to keep the global nav bundle light and 60fps everywhere;
 * it collapses gracefully under prefers-reduced-motion. Theme-aware surfaces
 * so it looks right in both skins.
 */
export function ThemeSwitcher({ className = "" }: { className?: string }) {
  const { theme, toggleTheme } = useTheme();
  const isDark = theme === "dark";

  return (
    <button
      type="button"
      onClick={toggleTheme}
      aria-label={isDark ? "Switch to light theme" : "Switch to dark theme"}
      aria-pressed={!isDark}
      title={isDark ? "Light theme" : "Dark theme"}
      className={`relative grid h-8 w-8 place-items-center overflow-hidden rounded-md border border-border/50 bg-background/50 text-muted-foreground backdrop-blur-md transition hover:border-[color:var(--gold)]/50 hover:text-foreground ${className}`}
    >
      <Moon
        aria-hidden
        className="absolute h-4 w-4 transition-all duration-300 ease-out motion-reduce:transition-none data-[hidden=true]:rotate-90 data-[hidden=true]:scale-0 data-[hidden=true]:opacity-0"
        data-hidden={!isDark}
      />
      <Sun
        aria-hidden
        className="absolute h-4 w-4 text-[color:var(--gold)] transition-all duration-300 ease-out motion-reduce:transition-none data-[hidden=true]:-rotate-90 data-[hidden=true]:scale-0 data-[hidden=true]:opacity-0"
        data-hidden={isDark}
      />
    </button>
  );
}
