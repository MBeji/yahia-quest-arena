"use client";

import * as React from "react";
import { HelpCircle } from "lucide-react";

import { cn } from "@/shared/lib/utils";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";

export interface ExplainHintProps {
  /** Short explanation shown in the tooltip. */
  text: string;
  /**
   * Optional element being explained. When provided it gets a subtle dotted
   * underline and becomes the hover/focus/tap target. When omitted, a small
   * help icon is rendered instead.
   */
  children?: React.ReactNode;
  /** Accessible label for the trigger (used for the icon-only variant). */
  label?: string;
  className?: string;
}

/**
 * A subtle, accessible explanation hint built on the shadcn Tooltip.
 *
 * Opens on hover, keyboard focus, AND tap (mobile) — the trigger is a real
 * <button>, and `disableHoverableContent` keeps tap-to-open snappy. Visually
 * non-intrusive: either a small help icon, or a dotted underline on `children`.
 */
export function ExplainHint({ text, children, label, className }: ExplainHintProps) {
  return (
    <TooltipProvider delayDuration={150}>
      <Tooltip disableHoverableContent>
        <TooltipTrigger asChild>
          <button
            type="button"
            // Prevent a tap from triggering an underlying click (e.g. a card link).
            onClick={(e) => {
              e.preventDefault();
              e.stopPropagation();
            }}
            // Le nom accessible ne doit JAMAIS remplacer ce qui est écrit : avec un
            // `aria-label`, « 1234 XP » disparaissait pour un lecteur d'écran, qui
            // n'entendait que l'explication (niveau, série, XP, pièces, score — audit
            // d'affichage du 2026-10-31). Avec un contenu, le nom vient du contenu ;
            // l'explication arrive par l'infobulle, que Radix relie au bouton en
            // `aria-describedby` dès qu'elle s'ouvre (survol, focus, tap). Sans
            // contenu (icône seule), le libellé reste le nom.
            aria-label={children ? undefined : (label ?? text)}
            className={cn(
              "inline-flex max-w-full cursor-help items-center gap-1 align-middle outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--gold)] focus-visible:ring-offset-1 focus-visible:ring-offset-transparent rounded-sm",
              children &&
                "underline decoration-dotted decoration-[color:var(--gold)]/60 underline-offset-4",
              className,
            )}
          >
            {children}
            {!children && (
              <HelpCircle
                className="h-3.5 w-3.5 shrink-0 text-[color:var(--gold)]/70"
                aria-hidden="true"
              />
            )}
          </button>
        </TooltipTrigger>
        <TooltipContent className="max-w-[16rem] text-pretty text-xs leading-relaxed">
          {text}
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}
