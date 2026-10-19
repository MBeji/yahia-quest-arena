import { HelpCircle } from "lucide-react";

import { useT } from "@/lib/i18n";
import { cn } from "@/shared/lib/utils";
import { useGuide } from "./guide-context";

/**
 * Le bouton « Aide » des en-têtes — toujours visible, toujours au même endroit,
 * et ÉCRIT partout où la ligne a la place : une icône seule dit peu à qui
 * découvre le numérique.
 */
export function GuideButton({
  className,
  compact = false,
}: {
  className?: string;
  /** Libellé masqué sous `sm` (l'icône et `aria-label` restent) — pour un en-tête déjà plein. */
  compact?: boolean;
}) {
  const t = useT();
  const { openGuide } = useGuide();
  return (
    <button
      type="button"
      onClick={openGuide}
      // Nom accessible porté par l'attribut : en mode compact, le libellé est masqué.
      aria-label={t.layout.help}
      title={t.layout.help}
      data-testid="guide-open"
      className={cn(
        "inline-flex shrink-0 items-center gap-1.5 rounded-full border border-primary/40 bg-primary/10 px-2.5 py-1.5 text-sm font-semibold text-primary transition hover:border-primary hover:bg-primary/15 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary [@media(pointer:coarse)]:min-h-11",
        className,
      )}
    >
      <HelpCircle className="h-4 w-4 shrink-0" aria-hidden="true" />
      <span className={compact ? "hidden sm:inline" : undefined}>{t.layout.help}</span>
    </button>
  );
}
