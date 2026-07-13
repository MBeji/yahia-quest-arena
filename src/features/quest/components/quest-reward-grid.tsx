import { Zap, Sparkles, Flame } from "lucide-react";

import { useT } from "@/lib/i18n";
import { ExplainHint } from "@/components/ui/explain-hint";
import { StatTile } from "@/components/game/stat-tile";

interface QuestRewardGridProps {
  xpEarned: number;
  coinsEarned: number;
  level: number | string;
  streak: number;
}

/**
 * The quest result reward summary (XP · Coins · Level · Streak), on the shared
 * StatTile primitive (étude 14, D-2). The XP figure always carries a playful
 * ExplainHint describing exactly how XP is earned, so the rule is visible even
 * on a winning run. Extracted from the quest route to keep that file within
 * the max-lines budget.
 */
export function QuestRewardGrid({ xpEarned, coinsEarned, level, streak }: QuestRewardGridProps) {
  const t = useT();

  return (
    <div className="mt-6 grid grid-cols-2 gap-3 sm:grid-cols-4">
      <StatTile
        icon={Zap}
        tone="neon"
        label={t.quest.xpLabel}
        value={
          <ExplainHint text={t.explain.questResultXp} label={t.quest.xpLabel}>
            <span>+{xpEarned}</span>
          </ExplainHint>
        }
      />
      <StatTile icon={Sparkles} tone="gold" label={t.quest.coinsLabel} value={`+${coinsEarned}`} />
      <StatTile icon={Sparkles} tone="gold" label={t.quest.levelLabel} value={level} />
      <StatTile
        icon={Flame}
        iconClassName="animate-flame"
        tone="flame"
        label={t.quest.streakLabel}
        value={streak}
      />
    </div>
  );
}
