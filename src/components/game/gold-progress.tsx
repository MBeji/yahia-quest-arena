import { cn } from "@/shared/lib/utils";

/**
 * THE gold progress bar of the Arène register (étude 14, D-2) — replaces the
 * eight inline implementations (four gradient syntaxes, five rail colours,
 * three heights) the audit found. RTL-safe: the fill is width-based, so it
 * grows from the inline start in both directions.
 */
const SIZES = {
  sm: "h-2",
  md: "h-2.5",
  lg: "h-3",
} as const;

export function GoldProgress({
  value,
  size = "md",
  className,
  "aria-label": ariaLabel,
}: {
  /** Progress in percent, clamped to [0, 100]. */
  value: number;
  size?: keyof typeof SIZES;
  className?: string;
  /**
   * Required: `role="progressbar"` below is unconditional, and an ARIA widget
   * without an accessible name is a serious axe violation (WCAG 1.1.1). Two
   * dashboard bars shipped unnamed when this primitive replaced plain divs, so
   * the compiler now enforces it. Echo the visible label next to the bar.
   */
  "aria-label": string;
}) {
  const clamped = Math.min(100, Math.max(0, value));
  return (
    <div
      role="progressbar"
      aria-valuemin={0}
      aria-valuemax={100}
      aria-valuenow={Math.round(clamped)}
      aria-label={ariaLabel}
      className={cn("w-full overflow-hidden rounded-full bg-secondary", SIZES[size], className)}
    >
      <div
        className="h-full rounded-full bg-[image:var(--gradient-gold)] transition-[width] duration-500"
        style={{ width: `${clamped}%` }}
      />
    </div>
  );
}
