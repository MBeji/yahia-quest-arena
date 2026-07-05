import { RichField } from "@/components/ui/svg-figure";
import type { PlayerReviewItem } from "@/features/quest/components/exercise-player";

/**
 * End-of-quest correction list — one card per answered question with the
 * player's answer, the correct one, and the explanation. Extracted from the
 * player alongside <QuestionInput> (B1.3): answers are displayed through
 * `getDisplayChoice`, which resolves an option's display letter for mcq and the
 * raw (LTR-isolated) value for numeric entries.
 */
export function QuestReviewList({
  review,
  labels,
  resolvePrompt,
  getDisplayChoice,
}: {
  review: PlayerReviewItem[];
  labels: {
    questReview: string;
    questionN: string;
    passed: string;
    needsWork: string;
    yourAnswer: string;
    correctAnswer: string;
  };
  /** Fallback prompt lookup (the anon correction carries no prompt). */
  resolvePrompt: (questionId: string) => string;
  getDisplayChoice: (questionId: string, choice: string) => string;
}) {
  return (
    <div className="mt-8 text-left">
      <h2 className="font-display text-xl font-bold">{labels.questReview}</h2>
      <div className="mt-4 space-y-3">
        {review.map((item, reviewIndex) => (
          <div
            key={item.questionId}
            data-testid="review-item"
            data-correct={item.isCorrect ? "true" : "false"}
            className="rounded-2xl border border-border/50 bg-black/30 p-4"
          >
            <div className="flex items-start justify-between gap-4">
              <div>
                <div className="text-xs uppercase tracking-widest text-muted-foreground">
                  {labels.questionN.replace("{n}", String(reviewIndex + 1))}
                </div>
                <RichField
                  raw={item.prompt || resolvePrompt(item.questionId)}
                  className="mt-1 font-semibold"
                />
              </div>
              <div
                className={`rounded-full px-3 py-1 text-xs font-bold ${item.isCorrect ? "bg-(--success)/15 text-success" : "bg-destructive/15 text-destructive"}`}
              >
                {item.isCorrect ? labels.passed : labels.needsWork}
              </div>
            </div>
            <div className="mt-3 grid gap-2 text-sm sm:grid-cols-2">
              <div className="rounded-xl bg-black/60 p-3">
                <div className="text-xs uppercase tracking-widest text-muted-foreground">
                  {labels.yourAnswer}
                </div>
                <div className="mt-1 font-mono uppercase">
                  {getDisplayChoice(item.questionId, item.selectedChoice)}
                </div>
              </div>
              <div className="rounded-xl bg-black/60 p-3">
                <div className="text-xs uppercase tracking-widest text-muted-foreground">
                  {labels.correctAnswer}
                </div>
                <div className="mt-1 font-mono uppercase">
                  {getDisplayChoice(item.questionId, item.correctChoice)}
                </div>
              </div>
            </div>
            {item.explanation && (
              <RichField
                raw={item.explanation}
                as="p"
                className="mt-3 text-sm text-muted-foreground"
              />
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
