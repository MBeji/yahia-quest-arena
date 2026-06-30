import { useState, useRef, useEffect } from "react";
import { BookOpen, Check, Moon, Sun, type LucideIcon } from "lucide-react";
import { useTheme, THEMES, type Theme } from "@/lib/theme";
import { useT } from "@/lib/i18n";

const THEME_ICONS: Record<Theme, LucideIcon> = {
  reference: BookOpen,
  light: Sun,
  dark: Moon,
};

/**
 * Theme picker — a 3-way dropdown (Référence / Clair / Sombre) shown in BOTH the
 * public and authenticated headers. The chosen theme is the single global skin
 * (applied as an `<html>` class, persisted to localStorage + cookie), so navigating
 * — public↔connecté or page to page — never changes it. Mirrors the LanguageSwitcher
 * chrome so the two controls sit cleanly side by side.
 */
export function ThemeSwitcher({ className = "" }: { className?: string }) {
  const { theme, setTheme } = useTheme();
  const t = useT();
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const CurrentIcon = THEME_ICONS[theme];

  return (
    <div ref={ref} className={`relative ${className}`}>
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className="flex min-h-11 min-w-11 items-center justify-center gap-1.5 rounded-md border border-border/50 bg-background/50 px-2 py-1.5 text-xs font-medium text-muted-foreground backdrop-blur-md transition hover:border-[color:var(--gold)]/50 hover:text-foreground"
        aria-label={t.theme.label}
        aria-haspopup="menu"
        aria-expanded={open}
      >
        <CurrentIcon className="h-3.5 w-3.5" />
      </button>
      {open && (
        <div
          role="menu"
          className="absolute end-0 top-full z-50 mt-1.5 min-w-[150px] overflow-hidden rounded-xl border border-border/60 bg-popover/95 p-1 shadow-lg backdrop-blur-xl"
        >
          {THEMES.map((value) => {
            const Icon = THEME_ICONS[value];
            const active = value === theme;
            return (
              <button
                key={value}
                type="button"
                role="menuitemradio"
                aria-checked={active}
                onClick={() => {
                  setTheme(value);
                  setOpen(false);
                }}
                className={`flex w-full items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition ${
                  active
                    ? "bg-[color:var(--gold)]/15 text-[color:var(--gold)] font-semibold"
                    : "text-muted-foreground hover:bg-accent hover:text-foreground"
                }`}
              >
                <Icon className="h-4 w-4 shrink-0" />
                <span className="flex-1 text-start">{t.theme[value]}</span>
                {active && <Check className="h-3.5 w-3.5 shrink-0" />}
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}
