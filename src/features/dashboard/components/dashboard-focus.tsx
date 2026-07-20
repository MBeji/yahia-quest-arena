import { Link } from "@tanstack/react-router";
import { Flame, ChevronRight, Skull, Gamepad2 } from "lucide-react";
import type { ComponentType, SVGProps } from "react";

import { useT } from "@/lib/i18n";
import type { NextAction } from "@/shared/lib/next-action";

interface ContinueSubject {
  id: string;
  name_fr: string;
}

/**
 * The dashboard "focus" band — the single most important redesign idea: promote
 * ONE prioritised action ("Reprendre") to hero prominence, paired with the daily
 * objective ring, then two calm secondary tiles (Donjon · Duel). Everything is
 * token-driven (`--gold`, `--flame`, `--gradient-gold`) so it reads correctly in
 * all three themes — the premium gold-on-black look is what the dark theme yields.
 */
export function DashboardFocus({
  nextAction,
  continueSubject,
  xpToday,
  dailyGoal,
  streak,
}: {
  /** L'action unique résolue par le moteur partagé (étude 22, R-31). */
  nextAction: NextAction | null | undefined;
  /** Sert à nommer la matière quand l'action désigne une matière plutôt qu'un exercice. */
  continueSubject: ContinueSubject | undefined;
  xpToday: number;
  dailyGoal: number;
  streak: number;
}) {
  const t = useT();

  // La bande focus ne DÉCIDE plus : elle rend. La priorité est tranchée en amont par
  // `resolveNextAction` (R-31), le même moteur que le « Reprendre ici » du hub matière — les
  // deux écrans ne peuvent donc plus désigner deux cibles différentes au même instant.
  // Ici, il ne reste qu'à choisir le verbe : réviser, reprendre, continuer, découvrir.
  const target = !nextAction
    ? null
    : nextAction.kind === "review"
      ? {
          to: "/quest/$exerciseId" as const,
          params: { exerciseId: nextAction.exerciseId },
          overline: t.dashboard.reviewOverline,
          title: t.dashboard.reviewTitle,
        }
      : nextAction.kind === "retry"
        ? {
            to: "/quest/$exerciseId" as const,
            params: { exerciseId: nextAction.exerciseId },
            overline: t.duel.resume,
            title: t.dashboard.retryTitle,
          }
        : nextAction.kind === "continue"
          ? {
              to: "/quest/$exerciseId" as const,
              params: { exerciseId: nextAction.exerciseId },
              overline: t.dashboard.continueLabel,
              title: t.dashboard.retryTitle,
            }
          : continueSubject
            ? {
                to: "/matiere/$subjectId" as const,
                params: { subjectId: continueSubject.id },
                overline: t.dashboard.continueLabel,
                title: continueSubject.name_fr,
              }
            : null;

  return (
    <div className="mt-6 space-y-4">
      <div className="grid gap-4 lg:grid-cols-[1fr_320px]">
        {target ? (
          <Link
            to={target.to}
            params={target.params}
            className="group relative flex items-center justify-between gap-4 overflow-hidden rounded-2xl bg-[image:var(--gradient-gold)] p-6 text-black shadow-gold transition hover:brightness-[1.04] sm:p-7"
          >
            <div className="min-w-0">
              <div className="text-[11px] font-bold uppercase tracking-[0.18em] opacity-70">
                {target.overline}
              </div>
              <div className="mt-1.5 truncate font-display text-xl font-bold sm:text-2xl">
                {target.title}
              </div>
              <div className="mt-1 truncate text-sm opacity-75">{t.dashboard.resumeSubtitle}</div>
            </div>
            <span className="grid h-14 w-14 shrink-0 place-items-center rounded-full bg-black/15">
              <ChevronRight className="h-6 w-6 transition group-hover:translate-x-0.5 rtl:-scale-x-100 rtl:group-hover:-translate-x-0.5" />
            </span>
          </Link>
        ) : (
          <div className="grid place-items-center rounded-2xl border border-[color:var(--gold)]/25 bg-black/40 p-7 text-sm text-muted-foreground backdrop-blur-md">
            {t.dashboard.noQuestTarget}
          </div>
        )}

        <DailyRing xpToday={xpToday} dailyGoal={dailyGoal} streak={streak} />
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        <ActionTile
          to="/dungeon"
          Icon={Skull}
          title={t.dungeon.title}
          desc={t.dashboard.dungeonDesc}
        />
        <ActionTile to="/duel" Icon={Gamepad2} title={t.duel.title} desc={t.duel.subtitle} />
      </div>
    </div>
  );
}

/** Daily-objective progress ring, paired with the Reprendre CTA. */
function DailyRing({
  xpToday,
  dailyGoal,
  streak,
}: {
  xpToday: number;
  dailyGoal: number;
  streak: number;
}) {
  const t = useT();
  const pct = Math.min(100, Math.round((xpToday / dailyGoal) * 100));
  const circumference = 2 * Math.PI * 40;
  const dashOffset = circumference - (pct / 100) * circumference;
  const isComplete = pct >= 100;

  return (
    <div className="flex items-center gap-5 rounded-2xl border border-[color:var(--gold)]/25 bg-black/40 p-5 backdrop-blur-md">
      <div className="relative h-20 w-20 shrink-0">
        <svg className="h-full w-full -rotate-90" viewBox="0 0 96 96">
          <circle
            cx="48"
            cy="48"
            r="40"
            fill="none"
            stroke="currentColor"
            strokeWidth="6"
            className="text-secondary"
          />
          <circle
            cx="48"
            cy="48"
            r="40"
            fill="none"
            strokeWidth="6"
            strokeLinecap="round"
            stroke={isComplete ? "var(--neon-gold)" : "var(--gold)"}
            strokeDasharray={circumference}
            strokeDashoffset={dashOffset}
            className="transition-all duration-700"
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="font-display text-base font-bold">{pct}%</span>
        </div>
      </div>
      <div className="min-w-0">
        <div className="text-xs uppercase tracking-[0.16em] text-[color:var(--gold)]">
          {t.dashboard.dailyGoalLabel}
        </div>
        <div className="mt-1 font-display text-lg font-bold">
          {xpToday} <span className="text-sm text-muted-foreground">/ {dailyGoal} XP</span>
        </div>
        {isComplete ? (
          <div className="mt-1 text-xs font-semibold text-[color:var(--neon-gold)]">
            {t.dashboard.dailyGoalReached}
          </div>
        ) : (
          <div className="mt-1 text-xs text-muted-foreground">
            {dailyGoal - xpToday} {t.dashboard.dailyGoalRemaining}
          </div>
        )}
        {streak > 0 && (
          <div className="mt-1.5 flex items-center gap-1 text-xs text-[color:var(--flame)]">
            <Flame className="h-3 w-3 animate-flame" /> {streak} {t.dashboard.consecutiveDays}
          </div>
        )}
      </div>
    </div>
  );
}

/** A calm secondary destination tile (Donjon · Duel). */
function ActionTile({
  to,
  Icon,
  title,
  desc,
}: {
  to: "/dungeon" | "/duel";
  Icon: ComponentType<SVGProps<SVGSVGElement>>;
  title: string;
  desc: string;
}) {
  return (
    <Link
      to={to}
      // `min-w-0` is load-bearing: as a GRID ITEM this tile defaults to
      // `min-width:auto`, so its track cannot shrink below the tile's own
      // min-content and the tile renders 479px wide inside a 343px column on a
      // 375px phone — pushing the document to scrollWidth 495 (the horizontal
      // overflow the responsive suite reports). The inner `min-w-0 flex-1` only
      // lets the LABEL shrink; the item itself needs its own floor removed.
      className="group flex min-w-0 items-center gap-3.5 rounded-2xl border border-[color:var(--gold)]/25 bg-black/40 p-4 backdrop-blur-md transition hover:-translate-y-0.5 hover:border-[color:var(--gold)]/50 sm:p-5"
    >
      <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/12">
        <Icon className="h-5 w-5 text-[color:var(--gold)]" />
      </span>
      <div className="min-w-0 flex-1">
        <div className="truncate font-display text-base font-bold">{title}</div>
        <div className="truncate text-xs text-muted-foreground">{desc}</div>
      </div>
      <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground transition group-hover:translate-x-0.5 rtl:-scale-x-100 rtl:group-hover:-translate-x-0.5" />
    </Link>
  );
}
