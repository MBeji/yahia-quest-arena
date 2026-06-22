import { Link } from "@tanstack/react-router";
import React from "react";
import {
  Sword,
  BookOpen,
  Scroll,
  Leaf,
  Globe,
  Calculator,
  Languages,
  Atom,
  ChevronRight,
  Lock,
} from "lucide-react";
import { useT } from "@/lib/i18n";

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  Sword,
  BookOpen,
  Scroll,
  Leaf,
  Globe,
  Calculator,
  Languages,
  Atom,
};

/**
 * Resolve a subject's CSS colour variable from its `color_token`. The DB stores
 * the token already prefixed (e.g. "subject-math"), so we normalise a possible
 * leading "subject-" and rebuild `--subject-<base>` — robust whether the token
 * is stored as "subject-math" or bare "math".
 */
const colorVar = (token: string) => `var(--subject-${token.replace(/^subject-/, "")})`;

type SubjectLike = {
  id: string;
  name_fr: string;
  icon: string;
  attribute: string;
  color_token: string;
  is_premium?: boolean;
};

/** One subject "path" card on the dashboard. Locked premium subjects show a lock badge. */
export function SubjectPathCard(props: {
  subject: SubjectLike;
  stat: { count: number; avg: number } | undefined;
  premiumLocked: boolean;
}) {
  const { subject, stat } = props;
  const t = useT();
  const Icon = ICONS[subject.icon] ?? Sword;
  // Show the Premium (lock) badge only when the subject is locked (the student is
  // not yet entitled); an entitled student needs no badge.
  const premiumLocked = props.premiumLocked;
  const color = colorVar(subject.color_token);

  return (
    <Link
      to="/matiere/$subjectId"
      params={{ subjectId: subject.id }}
      className={`group relative block overflow-hidden rounded-2xl border bg-black/60 p-5 backdrop-blur-md transition hover:-translate-y-1 ${
        premiumLocked
          ? "border-[color:var(--neon-gold)]/50 hover:border-[color:var(--neon-gold)]/80"
          : "border-border/50 hover:border-[color:var(--gold)]/60"
      }`}
    >
      {premiumLocked && (
        <div className="absolute right-3 top-3 z-10 flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/15 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-[color:var(--neon-gold)]">
          <Lock className="h-3 w-3" />
          Premium
        </div>
      )}
      <div
        className="absolute -right-8 -top-8 h-28 w-28 rounded-full blur-2xl opacity-50 transition-opacity group-hover:opacity-90"
        style={{ background: color }}
      />
      <div className="relative flex items-start justify-between">
        <Icon className="h-8 w-8" style={{ color }} />
        <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
      </div>
      <div className="relative mt-4">
        <div className="font-display text-lg font-bold">{subject.name_fr}</div>
        <div className="text-xs uppercase tracking-wider text-muted-foreground">
          Attribute · {subject.attribute}
        </div>
      </div>
      <div className="relative mt-4 flex items-center justify-between text-xs">
        <span className="text-muted-foreground">
          {stat ? `${stat.count} quest${stat.count > 1 ? "s" : ""}` : t.dashboard.notAttempted}
        </span>
        <span className="font-bold" style={{ color }}>
          {stat ? `${Math.round(stat.avg)}%` : "—"}
        </span>
      </div>
    </Link>
  );
}
