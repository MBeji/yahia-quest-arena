import { HelpCircle } from "lucide-react";

import { useGuideT } from "@/lib/i18n/guide";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { fillGuideText } from "@/shared/lib/guide";
import { cn } from "@/shared/lib/utils";
import { useGuide } from "./guide-context";

/**
 * La bulle « ? » posée À CÔTÉ d'un bouton (jamais dedans : un bouton dans un
 * lien n'est pas du HTML valide, et le tap ouvrirait les deux). Un Popover
 * plutôt qu'une infobulle : il s'ouvre au toucher et RESTE ouvert le temps de
 * lire — sur téléphone, une infobulle se referme avant la fin de la phrase.
 *
 * Disparaît quand l'utilisateur éteint les bulles dans la fiche d'aide.
 */
export function HelpTip({
  text,
  label,
  className,
}: {
  /** L'explication, en une ou deux phrases. */
  text: string;
  /** Ce qui est expliqué (« Lire le cours ») — pour le lecteur d'écran. */
  label: string;
  className?: string;
}) {
  const t = useGuideT();
  const { tipsEnabled } = useGuide();
  if (!tipsEnabled) return null;
  return (
    <Popover>
      <PopoverTrigger asChild>
        <button
          type="button"
          aria-label={fillGuideText(t.guide.tips.aria, { label })}
          data-testid="help-tip"
          className={cn(
            "grid h-8 w-8 shrink-0 place-items-center rounded-full border border-primary/40 bg-primary/10 text-primary transition hover:border-primary hover:bg-primary/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary [@media(pointer:coarse)]:h-11 [@media(pointer:coarse)]:w-11",
            className,
          )}
        >
          <HelpCircle className="h-4 w-4" aria-hidden="true" />
        </button>
      </PopoverTrigger>
      <PopoverContent className="w-72 text-sm leading-relaxed">{text}</PopoverContent>
    </Popover>
  );
}
