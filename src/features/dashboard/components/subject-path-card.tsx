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
import type { SubjectStarSummary } from "@/shared/lib/progress-stars";
import { nextSealOf } from "@/shared/lib/progress-stars";

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

/**
 * One subject "path" card on the dashboard. Locked premium subjects show a lock badge.
 *
 * ⭐ Le chiffre de droite était la MOYENNE DES SCORES, affichée « 40 % » — exactement la
 * même forme que le « 40 % » de la carte `/parcours`, qui lui disait la couverture des
 * chapitres. Deux pourcentages identiques à l'œil pour deux choses différentes : c'est
 * l'ambiguïté que l'étude 34 supprime. À sa place, le SCEAU de la matière et ce qui
 * manque pour le suivant — une donnée qui ne peut pas se confondre avec une note.
 */
export function SubjectPathCard(props: {
  subject: SubjectLike;
  stat: { count: number; avg: number } | undefined;
  /** Étoiles et sceaux de la matière (é34). Absent ⇒ la carte se tait, elle n'invente rien. */
  stars?: SubjectStarSummary;
  premiumLocked: boolean;
}) {
  const { subject, stat, stars } = props;
  const t = useT();
  const Icon = ICONS[subject.icon] ?? Sword;
  // Show the Premium (lock) badge only when the subject is locked (the student is
  // not yet entitled); an entitled student needs no badge.
  const premiumLocked = props.premiumLocked;
  const color = colorVar(subject.color_token);
  const nextSeal = stars && stars.chaptersTotal > 0 ? nextSealOf(stars) : null;
  const sealStar = stars && stars.chaptersTotal > 0 ? stars.sealStar : 0;

  return (
    <Link
      to="/matiere/$subjectId"
      params={{ subjectId: subject.id }}
      className={`group relative block overflow-hidden rounded-2xl border bg-surface-3 p-5 backdrop-blur-md transition hover:-translate-y-1 ${
        premiumLocked
          ? "border-[color:var(--neon-gold)]/50 hover:border-[color:var(--neon-gold)]/80"
          : "border-border/50 hover:border-[color:var(--gold)]/60"
      }`}
    >
      {/* Opaque card-surface chip (not a translucent gold tint) so the text always
          meets contrast over the subject-colour blob — readable in all 3 themes
          (the gold token is dark teal under Référence). */}
      {premiumLocked && (
        <div className="absolute end-3 top-3 z-10 flex items-center gap-1 rounded-full border border-[color:var(--gold)]/50 bg-card px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-foreground shadow-sm">
          <Lock className="h-3 w-3 text-[color:var(--gold)]" />
          Premium
        </div>
      )}
      <div
        className="absolute -end-8 -top-8 h-28 w-28 rounded-full blur-2xl opacity-50 transition-opacity group-hover:opacity-90"
        style={{ background: color }}
      />
      <div className="relative flex items-start justify-between">
        <Icon className="h-8 w-8" style={{ color }} />
        <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground rtl:-scale-x-100 rtl:group-hover:-translate-x-1" />
      </div>
      <div className="relative mt-4 min-w-0">
        <div className="truncate font-display text-lg font-bold">{subject.name_fr}</div>
        <div className="truncate text-xs uppercase tracking-wider text-muted-foreground">
          Attribute · {subject.attribute}
        </div>
      </div>
      <div className="relative mt-4 flex items-center justify-between text-xs">
        <span className="text-muted-foreground">
          {stat ? `${stat.count} quest${stat.count > 1 ? "s" : ""}` : t.dashboard.notAttempted}
        </span>
        <span className="font-bold" data-testid="card-seal" style={{ color }}>
          {sealStar > 0 ? "⭐".repeat(sealStar) : "—"}
        </span>
      </div>
      {/* La barre du prochain sceau : « k chapitres prêts sur N ». Elle ne se remplit que
          vers le haut — un chapitre prêt le reste, donc elle ne recule jamais. Absente au
          sceau ⭐⭐⭐⭐, où il n'y a plus rien à atteindre. */}
      {nextSeal && (
        <div className="relative mt-2" data-testid="card-next-seal">
          <div className="h-1 overflow-hidden rounded-full bg-border/60">
            <div
              className="h-full rounded-full transition-[width]"
              style={{
                width: `${Math.min(100, Math.round((nextSeal.chaptersReady / Math.max(1, nextSeal.chaptersTotal)) * 100))}%`,
                background: color,
              }}
            />
          </div>
          <div className="mt-1 text-[10px] tabular-nums text-muted-foreground">
            {"⭐".repeat(nextSeal.star)} {nextSeal.chaptersReady}/{nextSeal.chaptersTotal}
          </div>
        </div>
      )}
    </Link>
  );
}
