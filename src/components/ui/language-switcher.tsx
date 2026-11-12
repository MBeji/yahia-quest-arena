import { useI18n, useT } from "@/lib/i18n";
import { Globe } from "lucide-react";
import { useState, useRef, useEffect } from "react";

import { LOCALES } from "@/components/ui/settings-controls";

export function LanguageSwitcher({ className = "" }: { className?: string }) {
  const t = useT();
  const { locale, setLocale } = useI18n();
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    function handleClickOutside(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setOpen(false);
      }
    }
    // Échap ferme, comme le menu des réglages : une liste qui ne se referme qu'à la
    // souris piège le clavier derrière elle.
    function handleKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("mousedown", handleClickOutside);
    document.addEventListener("keydown", handleKeyDown);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
      document.removeEventListener("keydown", handleKeyDown);
    };
  }, [open]);

  const current = LOCALES.find((l) => l.code === locale) ?? LOCALES[0];

  return (
    <div ref={ref} className={`relative ${className}`}>
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className="flex min-h-11 items-center justify-center gap-1.5 rounded-md border border-border/50 bg-background/50 px-2.5 py-1.5 text-xs font-medium text-muted-foreground backdrop-blur-md transition hover:border-[color:var(--gold)]/50 hover:text-foreground"
        aria-expanded={open}
      >
        <Globe className="h-3.5 w-3.5" aria-hidden="true" />
        {/* Le nom accessible se LIT sur le bouton : l'intitulé (masqué) puis le code
            visible. Un `aria-label` — anglais, de surcroît — remplaçait « FR » par un
            texte que la commande vocale ne pouvait pas viser (WCAG 2.5.3). */}
        <span className="sr-only">{t.settings.languageLabel}</span>
        <span className="font-bold tracking-wide">{current.short}</span>
      </button>
      {open && (
        <div className="absolute end-0 top-full z-50 mt-1.5 min-w-[140px] overflow-hidden rounded-xl border border-border/60 bg-popover/95 p-1 shadow-lg backdrop-blur-xl">
          {LOCALES.map((l) => (
            <button
              key={l.code}
              type="button"
              lang={l.code}
              aria-current={l.code === locale ? "true" : undefined}
              onClick={() => {
                setLocale(l.code);
                setOpen(false);
              }}
              className={`flex min-h-11 w-full items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition ${
                l.code === locale
                  ? "bg-[color:var(--gold)]/15 text-[color:var(--gold)] font-semibold"
                  : "text-muted-foreground hover:bg-accent hover:text-foreground"
              }`}
            >
              <span
                aria-hidden="true"
                className="grid h-6 w-7 place-items-center rounded border border-border/60 text-[10px] font-bold tracking-wide"
              >
                {l.short}
              </span>
              <span>{l.label}</span>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
