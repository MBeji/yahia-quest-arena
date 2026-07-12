import { Star } from "lucide-react";
import { useT } from "@/lib/i18n";
import { cn } from "@/shared/lib/utils";

/**
 * THE difficulty vocabulary (étude 14, Q-4 — arbitrage humain) : ⭐ stars,
 * everywhere, replacing the dungeon's bars and the "Niveau N" text labels.
 * `max` is parameterized because levels 5/6 may exist later — always stars.
 */
export function DifficultyStars({
  level,
  max = 4,
  className,
}: {
  /** Filled stars, clamped to [0, max]. */
  level: number;
  max?: number;
  className?: string;
}) {
  const t = useT();
  const clamped = Math.min(max, Math.max(0, Math.round(level)));
  const label = t.common.difficulty.replace("{n}", String(clamped)).replace("{max}", String(max));
  return (
    <span
      role="img"
      aria-label={label}
      className={cn("inline-flex items-center gap-0.5", className)}
    >
      {Array.from({ length: max }, (_, i) => (
        <Star
          key={i}
          aria-hidden
          className={cn("h-3.5 w-3.5", i < clamped ? "fill-gold text-gold" : "text-border")}
        />
      ))}
    </span>
  );
}
