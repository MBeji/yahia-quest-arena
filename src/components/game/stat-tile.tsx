import type { LucideIcon } from "lucide-react";
import { cn } from "@/shared/lib/utils";

/**
 * The reward/stat tile of the Arène register (étude 14, D-2) — one surface
 * opacity, one padding, one number size, replacing the divergent copies the
 * audit found in the dungeon, quest rewards and hero chips.
 */
const TONES = {
  gold: { surface: "bg-gold/15", ink: "text-gold" },
  neon: { surface: "bg-neon-gold/15", ink: "text-neon-gold" },
  flame: { surface: "bg-flame/15", ink: "text-flame" },
} as const;

export function StatTile({
  icon: Icon,
  value,
  label,
  tone = "gold",
  className,
}: {
  icon?: LucideIcon;
  value: React.ReactNode;
  label: string;
  tone?: keyof typeof TONES;
  className?: string;
}) {
  const { surface, ink } = TONES[tone];
  return (
    <div className={cn("rounded-xl p-4 text-center", surface, className)}>
      {Icon && <Icon className={cn("mx-auto mb-1 h-5 w-5", ink)} aria-hidden />}
      <div className={cn("font-display text-xl font-bold", ink)}>{value}</div>
      <div className="text-2xs uppercase tracking-wider text-muted-foreground">{label}</div>
    </div>
  );
}
