import { Zap, Sparkles, Flame } from "lucide-react";

import { useT } from "@/lib/i18n";
import { ExplainHint } from "@/components/ui/explain-hint";

interface QuestRewardGridProps {
  xpEarned: number;
  coinsEarned: number;
  level: number | string;
  streak: number;
}

/**
 * The quest result reward summary (XP · Coins · Level · Streak). The XP figure
 * always carries a playful ExplainHint describing exactly how XP is earned, so
 * the rule is visible even on a winning run. Extracted from the quest route to
 * keep that file within the max-lines budget.
 */
export function QuestRewardGrid({ xpEarned, coinsEarned, level, streak }: QuestRewardGridProps) {
  const t = useT();

  return (
    <div className="mt-6 grid grid-cols-2 gap-3 sm:grid-cols-4">
      <div className="rounded-xl bg-(--neon-gold)/15 p-4">
        <Zap className="mx-auto h-5 w-5 text-neon-gold" />
        <ExplainHint text={t.explain.questResultXp} label={t.quest.xpLabel}>
          <span className="mt-1 block font-display text-2xl font-bold text-neon-gold">
            +{xpEarned}
          </span>
        </ExplainHint>
        <div className="text-xs uppercase tracking-wider text-muted-foreground">
          {t.quest.xpLabel}
        </div>
      </div>
      <div className="rounded-xl bg-(--gold)/15 p-4">
        <Sparkles className="mx-auto h-5 w-5 text-[color:var(--gold)]" />
        <div className="mt-1 font-display text-2xl font-bold text-[color:var(--gold)]">
          +{coinsEarned}
        </div>
        <div className="text-xs uppercase tracking-wider text-muted-foreground">
          {t.quest.coinsLabel}
        </div>
      </div>
      <div className="rounded-xl bg-(--gold)/15 p-4">
        <Sparkles className="mx-auto h-5 w-5 text-[color:var(--gold)]" />
        <div className="mt-1 font-display text-2xl font-bold text-[color:var(--gold)]">{level}</div>
        <div className="text-xs uppercase tracking-wider text-muted-foreground">
          {t.quest.levelLabel}
        </div>
      </div>
      <div className="rounded-xl bg-(--flame)/15 p-4">
        <Flame className="mx-auto h-5 w-5 text-flame animate-flame" />
        <div className="mt-1 font-display text-2xl font-bold text-flame">{streak}</div>
        <div className="text-xs uppercase tracking-wider text-muted-foreground">
          {t.quest.streakLabel}
        </div>
      </div>
    </div>
  );
}
