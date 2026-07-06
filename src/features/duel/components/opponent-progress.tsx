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
  labels,
}: {
  answered: number;
  total: number;
  finished: boolean;
  labels: DuelLabels;
}) {
  const pct = total > 0 ? Math.round((Math.min(answered, total) / total) * 100) : 0;
  const text = finished
    ? labels.opponentDone
    : labels.opponentAnswered.replace("{n}", String(answered)).replace("{total}", String(total));
  return (
    <div className="space-y-1" data-testid="opponent-progress">
      <p className="text-sm text-muted-foreground">{text}</p>
      <div className="h-2 w-full overflow-hidden rounded-full bg-muted">
        <div
          className="h-2 rounded-full bg-primary transition-all"
          style={{ width: `${pct}%` }}
          role="progressbar"
          aria-valuenow={answered}
          aria-valuemin={0}
          aria-valuemax={total}
        />
      </div>
    </div>
  );
}
