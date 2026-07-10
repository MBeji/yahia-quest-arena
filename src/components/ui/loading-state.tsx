import { Loader2 } from "lucide-react";
import { cn } from "@/shared/lib/utils";

/**
 * The single loading treatment (étude 14, D-2) — replaces the five divergent
 * loaders the audit found (two spinner styles, bare text, ad-hoc pulses).
 * Skeleton layouts keep using `@/components/ui/skeleton`; this is the
 * centered "the screen is coming" state, announced to screen readers.
 */
export function LoadingState({ label, className }: { label: string; className?: string }) {
  return (
    <div
      role="status"
      className={cn("flex flex-col items-center justify-center gap-3 py-16", className)}
    >
      <Loader2 className="h-8 w-8 animate-spin text-gold" aria-hidden />
      <p className="text-sm text-muted-foreground">{label}</p>
    </div>
  );
}
