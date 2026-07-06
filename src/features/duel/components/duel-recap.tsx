import type { TranslationKeys } from "@/lib/i18n/types";
import type { DuelState } from "../duel.server";
import { computeOutcome } from "../duel-outcome";

type DuelLabels = TranslationKeys["duel"];

/**
 * US-5: the final recap — verdict, both scores, and the correction. Shown ONLY
 * once the duel is settled (the route gates on status); the opponent's score is
 * revealed here (server-side, post-settlement — R-3 held during play).
 */
export function DuelRecap({ state, labels }: { state: DuelState; labels: DuelLabels }) {
  const outcome = computeOutcome(state);
  const verdictClass =
    outcome === "resultWin"
      ? "text-emerald-600"
      : outcome === "resultLoss"
        ? "text-red-600"
        : "text-muted-foreground";

  return (
    <div className="space-y-4">
      <h2 className={`text-2xl font-bold ${verdictClass}`}>{labels[outcome]}</h2>

      <div className="rounded-lg border border-border p-4 text-sm">
        <p>
          {labels.finalScore
            .replace("{score}", String(state.myScore))
            .replace("{total}", String(state.total))}
        </p>
        <p className="text-muted-foreground">
          {labels.opponent}: {state.opponentScore ?? "—"}/{state.total}
        </p>
      </div>

      {state.review && state.review.length > 0 ? (
        <div className="space-y-3">
          <h3 className="font-semibold">{labels.reviewTitle}</h3>
          {state.review.map((r) => (
            <div key={r.questionId} className="rounded-lg border border-border p-3 text-sm">
              <p className="font-medium">{r.prompt}</p>
              <p className="text-emerald-600">
                {labels.correctAnswer.replace("{answer}", r.correctChoice ?? "—")}
              </p>
              {r.explanation ? <p className="mt-1 text-muted-foreground">{r.explanation}</p> : null}
            </div>
          ))}
        </div>
      ) : null}
    </div>
  );
}
