import React from "react";
import {
  Crown,
  Check,
  Sword,
  BookOpen,
  Leaf,
  Globe,
  Calculator,
  Languages,
  Atom,
} from "lucide-react";
import type { NodeState } from "../journey";

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  Sword,
  BookOpen,
  Leaf,
  Globe,
  Calculator,
  Languages,
  Atom,
};

export type PathNodeProps = {
  state: NodeState;
  title: string;
  sublabel?: string;
  badge?: string;
  icon?: string;
  /** Accent colour (CSS value). Defaults to gold. */
  color?: string;
};

const GOLD = "var(--gold)";

/**
 * Pure visual node (circle + label). Links/layout are handled by the parent.
 *
 * Tous les nœuds sont cliquables (étude 22, R-11) : il n'existe plus d'état `locked` et le
 * cadenas a disparu. Seul `premium-locked` porte encore une couronne — dormante en phase
 * gratuite —, et il reste cliquable : c'est la page matière qui explique, pas la carte.
 */
export function PathNode({ state, title, sublabel, badge, icon, color = GOLD }: PathNodeProps) {
  const Icon = (icon && ICONS[icon]) || Sword;
  const isPremium = state === "premium-locked";
  const isDone = state === "done";
  const isCurrent = state === "current";
  const isNext = state === "next";

  const ring = isPremium
    ? "border-[color:var(--gold)]/60 bg-[color:var(--gold)]/10 text-[color:var(--gold)]"
    : isDone
      ? "border-transparent bg-[image:var(--gradient-gold)] text-black shadow-gold"
      : isNext
        ? "border-[color:var(--gold)] bg-black/50 ring-2 ring-[color:var(--gold)]/35 ring-offset-2 ring-offset-transparent"
        : "border-[color:var(--gold)]/50 bg-black/50";

  const glyph = isPremium ? (
    <Crown className="h-7 w-7" />
  ) : isDone ? (
    <Check className="h-8 w-8" />
  ) : (
    <Icon className="h-7 w-7" style={{ color }} />
  );

  return (
    <div className="group flex w-40 cursor-pointer flex-col items-center">
      <div className="relative">
        {isCurrent && (
          <span
            className="absolute inset-0 animate-ping rounded-full"
            style={{ background: color, opacity: 0.25 }}
            aria-hidden
          />
        )}
        <div
          className={`relative grid h-16 w-16 place-items-center rounded-full border-2 backdrop-blur-md transition group-hover:scale-105 ${ring}`}
          style={isCurrent ? { boxShadow: `0 0 28px ${color}55` } : undefined}
        >
          {glyph}
        </div>
      </div>
      <div className="mt-2 max-w-[10rem] text-center">
        <div className="flex items-center justify-center gap-1 text-sm font-bold">
          {title}
          {badge && (
            <span className="rounded-full bg-[color:var(--gold)]/15 px-1.5 py-0.5 text-[9px] font-bold uppercase tracking-wider text-[color:var(--gold)]">
              {badge}
            </span>
          )}
        </div>
        {sublabel && <div className="text-[11px] text-muted-foreground">{sublabel}</div>}
      </div>
    </div>
  );
}
