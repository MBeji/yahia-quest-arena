import { GoldProgress } from "@/components/game/gold-progress";
import type { TranslationKeys } from "@/lib/i18n/types";

type DuelLabels = TranslationKeys["duel"];

/**
 * US-3: the opponent's live progress — a COUNT only (never their answers or
 * score-in-progress, R-3). Fed by `get_duel_state.opponentAnswered`.
 */
export function OpponentProgress({
  answered,
  total,
  finished,
  online,
  labels,
}: {
  answered: number;
  total: number;
  finished: boolean;
  /** Presence (lot 4): undefined = unknown/polling, true/false = live status. */
  online?: boolean;
  labels: DuelLabels;
}) {
  const pct = total > 0 ? Math.round((Math.min(answered, total) / total) * 100) : 0;
  const text = finished
    ? labels.opponentDone
    : labels.opponentAnswered.replace("{n}", String(answered)).replace("{total}", String(total));
  return (
    <div className="space-y-1" data-testid="opponent-progress">
      <p className="flex items-center gap-2 text-sm text-muted-foreground">
        {online !== undefined ? (
          <span
            className={`inline-block h-2 w-2 rounded-full ${online ? "bg-success" : "bg-muted-foreground/40"}`}
            aria-label={online ? labels.online : labels.offline}
            title={online ? labels.online : labels.offline}
          />
        ) : null}
        {text}
      </p>
      <GoldProgress value={pct} size="sm" aria-label={text} />
    </div>
  );
}
