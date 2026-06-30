import { FlaskConical } from "lucide-react";
import { useT } from "@/lib/i18n";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";

/**
 * Compact "Bêta" badge shown in the global header during the test phase.
 * Signals that the platform is still under test and (via tooltip) invites
 * users to report problems with the floating bug launcher.
 */
export function BetaBadge() {
  const t = useT();
  return (
    <TooltipProvider delayDuration={150}>
      <Tooltip>
        <TooltipTrigger asChild>
          <span
            className="inline-flex shrink-0 items-center gap-1 rounded-full border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-[color:var(--gold)]"
            aria-label={t.betaBanner.tooltip}
          >
            <FlaskConical className="h-3 w-3 shrink-0" aria-hidden="true" />
            {t.betaBanner.badge}
          </span>
        </TooltipTrigger>
        <TooltipContent className="max-w-[16rem] text-center">
          {t.betaBanner.tooltip}
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}
