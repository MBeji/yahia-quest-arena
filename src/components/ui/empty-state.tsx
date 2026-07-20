import type { LucideIcon } from "lucide-react";
import { cn } from "@/shared/lib/utils";

/**
 * The single empty-state grammar (étude 14, D-2) — dashed card, optional icon,
 * title, supporting line and action. Replaces the three divergent treatments
 * the audit found (bare one-liners, ad-hoc dashed card, illustrated block).
 */
export function EmptyState({
  icon: Icon,
  title,
  description,
  action,
  className,
}: {
  icon?: LucideIcon;
  title: string;
  description?: string;
  action?: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      // Stable hook for the e2e suites. Empty-state COPY is product-owned and
      // drifts (the leaderboard's flat "aucun héros inscrit" became the étude-15
      // cold-start invitation), which silently un-finds any locator written
      // against the wording. The grammar is shared, so the hook belongs here once.
      data-testid="empty-state"
      className={cn(
        "rounded-2xl border border-dashed border-border/50 bg-card/40 p-6 text-center",
        className,
      )}
    >
      {Icon && <Icon className="mx-auto h-8 w-8 text-muted-foreground/70" aria-hidden />}
      <p className={cn("font-semibold", Icon && "mt-3")}>{title}</p>
      {description && <p className="mt-1 text-sm text-muted-foreground">{description}</p>}
      {action && <div className="mt-4 flex justify-center">{action}</div>}
    </div>
  );
}
