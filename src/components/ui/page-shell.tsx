import { cn } from "@/shared/lib/utils";

/**
 * Standard page container (étude 14, D-2). Three gabarits replace the five
 * ad-hoc page widths the audit found; padding is uniform across screens.
 * - `narrow`  — focused game/flow screens (quest, dungeon, duel, onboarding)
 * - `reading` — lists & content (leaderboard, parcours, subject)
 * - `wide`    — dense boards (dashboard, parent-report, admin)
 */
const WIDTHS = {
  narrow: "max-w-2xl",
  reading: "max-w-3xl",
  wide: "max-w-6xl",
} as const;

export type PageShellWidth = keyof typeof WIDTHS;

export function PageShell({
  width = "reading",
  className,
  children,
}: {
  width?: PageShellWidth;
  className?: string;
  children: React.ReactNode;
}) {
  return (
    <div className={cn("mx-auto w-full px-4 py-8 sm:px-6", WIDTHS[width], className)}>
      {children}
    </div>
  );
}
