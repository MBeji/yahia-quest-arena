import { Lock } from "lucide-react";
import { cn } from "@/shared/lib/utils";

/**
 * The premium-lock chip (GAP-047 pattern, étude 14, D-2) — extracted from its
 * two hand-copied instances (subject-path-card, leaderboard). Opaque
 * card-surface chip (not a translucent gold tint) so the text always meets
 * contrast over colourful blobs, in both themes. Positioning belongs to the
 * consumer (e.g. `className="absolute end-3 top-3"`).
 */
export function PremiumBadge({
  className,
  children = "Premium",
}: {
  className?: string;
  children?: React.ReactNode;
}) {
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1 rounded-full border border-gold/50 bg-card px-2 py-0.5 text-2xs font-bold uppercase tracking-wider text-foreground shadow-sm",
        className,
      )}
    >
      <Lock className="h-3 w-3 text-gold" aria-hidden />
      {children}
    </span>
  );
}
