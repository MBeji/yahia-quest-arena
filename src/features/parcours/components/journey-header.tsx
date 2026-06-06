import { Sparkles, Trophy } from "lucide-react";
import { useT } from "@/lib/i18n";
import { xpProgress } from "../journey";

export type JourneyHeaderProps = {
  title: string;
  subtitle?: string;
  level: number;
  xp: number;
  heroClass: string;
};

/** Level + XP-to-next progress bar + hero class. Sits atop every journey view. */
export function JourneyHeader({ title, subtitle, level, xp, heroClass }: JourneyHeaderProps) {
  const t = useT();
  const p = xpProgress(xp, level);

  return (
    <div className="relative overflow-hidden rounded-3xl border border-[color:var(--gold)]/20 bg-black/50 p-6 backdrop-blur-xl">
      <div className="relative flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="font-display text-3xl font-bold sm:text-4xl">
            <span className="text-gradient-gold">{title}</span>
          </h1>
          {subtitle && <p className="mt-1 max-w-xl text-sm text-muted-foreground">{subtitle}</p>}
        </div>
        <div className="flex items-center gap-3 rounded-2xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/10 px-4 py-2">
          <div className="grid h-11 w-11 place-items-center rounded-xl bg-[image:var(--gradient-gold)] text-black shadow-gold">
            <Trophy className="h-5 w-5" />
          </div>
          <div>
            <div className="font-display text-lg font-bold leading-none">
              {t.parcours.level} {level}
            </div>
            <div className="text-[11px] uppercase tracking-wider text-[color:var(--gold)]">
              {heroClass}
            </div>
          </div>
        </div>
      </div>

      <div className="relative mt-5">
        <div className="mb-1 flex items-center justify-between text-xs text-muted-foreground">
          <span className="flex items-center gap-1">
            <Sparkles className="h-3.5 w-3.5 text-[color:var(--gold)]" /> {p.intoLevel}/{p.perLevel}{" "}
            XP
          </span>
          <span>{p.isMax ? t.parcours.maxLevel : `${p.toNext} ${t.parcours.xpToNext}`}</span>
        </div>
        <div className="h-2.5 overflow-hidden rounded-full bg-secondary/50">
          <div
            className="h-full rounded-full bg-[linear-gradient(to_right,var(--gold),var(--gold-bright))] transition-all duration-700"
            style={{ width: `${p.pct}%` }}
          />
        </div>
      </div>
    </div>
  );
}
