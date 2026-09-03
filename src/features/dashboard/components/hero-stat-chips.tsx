import { Flame, Zap, Sparkles } from "lucide-react";

import { useT } from "@/lib/i18n";
import { ExplainHint } from "@/components/ui/explain-hint";
import { isHeroClass, isHeroTitle } from "@/shared/constants/hero-identity";

interface HeroStatChipsProps {
  level: number;
  currentStreak: number;
  xp: number;
  coins: number;
  heroClass: string | null;
  /** é31 lot 7 — le titre acheté en boutique, à côté de la classe (US-11). */
  titleCode?: string | null;
}

/**
 * The dashboard hero-header stat row (Hero class · Level · Streak · XP · Coins),
 * each wrapped in a playful, non-intrusive ExplainHint so students learn what
 * every figure means and how to earn it. Extracted from the dashboard route to
 * keep that file under the max-lines budget.
 */
export function HeroStatChips({
  level,
  currentStreak,
  xp,
  coins,
  heroClass,
  titleCode,
}: HeroStatChipsProps) {
  const t = useT();

  // é31 lot 7 (R-22) — la classe est un CODE en base : elle se traduit ici. Un
  // code inconnu s'affiche tel quel plutôt que de laisser un trou.
  const className =
    heroClass && isHeroClass(heroClass) ? t.dashboard.heroClasses[heroClass] : heroClass;
  const title = isHeroTitle(titleCode) ? t.dashboard.heroTitles[titleCode] : null;

  return (
    <>
      {className ? (
        <div
          data-testid="hero-class"
          className="text-xs uppercase tracking-[0.3em] text-[color:var(--gold)]"
        >
          <ExplainHint text={t.explain.heroClass}>{className}</ExplainHint>
          {title && <span data-testid="hero-title"> · {title}</span>}
        </div>
      ) : null}
      <div className="mt-3 flex flex-wrap items-center gap-3">
        <ExplainHint
          text={t.explain.level}
          label={t.dashboard.levelLabel}
          className="[@media(pointer:coarse)]:min-h-11"
        >
          <span
            data-testid="stat-level"
            className="rounded-full bg-[color:var(--gold)]/20 px-3 py-1 text-sm font-bold text-[color:var(--gold)]"
          >
            {t.dashboard.levelLabel} {level}
          </span>
        </ExplainHint>
        <ExplainHint
          text={t.explain.streak}
          label={t.dashboard.longestStreak}
          className="[@media(pointer:coarse)]:min-h-11"
        >
          <span
            data-testid="stat-streak"
            className="flex items-center gap-1 rounded-full bg-[color:var(--flame)]/20 px-3 py-1 text-sm font-bold text-flame-ink"
          >
            <Flame className="h-4 w-4 animate-flame" /> {currentStreak}{" "}
            {currentStreak > 1 ? t.dashboard.days : t.dashboard.day}
          </span>
        </ExplainHint>
        <ExplainHint text={t.explain.xp} label="XP" className="[@media(pointer:coarse)]:min-h-11">
          <span
            data-testid="stat-xp"
            className="flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-gold)]"
          >
            <Zap className="h-4 w-4" /> {xp} XP
          </span>
        </ExplainHint>
        <ExplainHint
          text={t.explain.coins}
          label={t.quest.coinsLabel}
          className="[@media(pointer:coarse)]:min-h-11"
        >
          <span
            data-testid="stat-coins"
            className="flex items-center gap-1 rounded-full border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/10 px-3 py-1 text-sm font-bold text-[color:var(--gold)]"
          >
            <Sparkles className="h-4 w-4" /> {coins} {t.quest.coinsLabel}
          </span>
        </ExplainHint>
      </div>
    </>
  );
}
