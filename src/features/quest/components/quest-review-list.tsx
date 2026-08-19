import { Link } from "@tanstack/react-router";
import { BookOpen, Dumbbell } from "lucide-react";

import { RichField } from "@/components/ui/svg-figure";
import type { PlayerReviewItem } from "@/features/quest/components/exercise-player";

/**
 * End-of-quest correction list — one card per answered question with the
 * player's answer, the correct one, and the explanation. Extracted from the
 * player alongside <QuestionInput> (B1.3): answers are displayed through
 * `getDisplayChoice`, which resolves an option's display letter for mcq and the
 * raw (LTR-isolated) value for numeric entries.
 *
 * Étude 04 lot A1.2b — la correction RICHE à l'échec. Sur une réponse fausse
 * seulement (R-A1.2-2 : on ne transforme pas une réussite en leçon), la carte
 * gagne un bloc qui NOMME l'erreur et ouvre le cours du chapitre.
 *
 * Trois choses s'y jouent, dans cet ordre de priorité :
 *
 *   1. **La dégradation est totale et silencieuse** (R-A1.2-3). Question non
 *      taguée, registre muet sur le tag, exercice sans chapitre, correction
 *      anonyme : chaque morceau disparaît seul, sans trou visuel ni message
 *      d'erreur, et le bloc entier s'efface s'il n'a plus rien à dire. Le rendu
 *      d'avant A1.2 est le PLANCHER — jamais une régression. C'est le mode
 *      NORMAL aujourd'hui : seuls `math` et `math-6eme` sont tagués (é07 lot 3).
 *   2. **Le tag n'est jamais affiché** (R-A1.2-1) : c'est un id. La phrase vient
 *      de `resolveMisconceptionLabel`, injecté — le composant ne sait pas d'où
 *      elle vient et n'a pas à le savoir.
 *   3. **C'est l'emplacement que l'étude 11 lot 1 remplira** (D-A1.2-5) : le
 *      déterministe décide (quel tag, quel chapitre), le LLM rédigera la phrase
 *      plus tard. Si A1.2b est bien fait, é11 lot 1 remplace un contenu, il ne
 *      refond pas un écran.
 */
export function QuestReviewList({
  review,
  labels,
  resolvePrompt,
  getDisplayChoice,
  resolveMisconceptionLabel,
  onTrain,
  trainLabel,
}: {
  review: PlayerReviewItem[];
  labels: {
    questReview: string;
    questionN: string;
    passed: string;
    needsWork: string;
    yourAnswer: string;
    correctAnswer: string;
    reviewMistakeTitle: string;
    reviewCourseCta: string;
  };
  /** Fallback prompt lookup (the anon correction carries no prompt). */
  resolvePrompt: (questionId: string) => string;
  getDisplayChoice: (questionId: string, choice: string) => string;
  /**
   * Met le tag en langue. Rend `null` quand le vocabulaire ne connaît pas le tag —
   * le bloc se tait alors sur l'erreur sans rien casser autour (R-A1.2-3).
   * Absent = aucune erreur n'est jamais nommée, ce qui reste un rendu valide.
   */
  resolveMisconceptionLabel?: (tag: string) => string | null;
  /**
   * Résout la compétence de l'erreur en un exercice d'entraînement, puis y mène.
   * Injecté par l'écran : le composant ne sait pas qu'une RPC existe. Absent =
   * pas de geste « m'entraîner », ce qui reste un rendu valide (R-A1.2-3).
   */
  onTrain?: (competency: string) => void;
  trainLabel?: string;
}) {
  return (
    <div className="mt-8 text-start">
      <h2 className="font-display text-xl font-bold">{labels.questReview}</h2>
      <div className="mt-4 space-y-3">
        {review.map((item, reviewIndex) => (
          <div
            key={item.questionId}
            data-testid="review-item"
            data-correct={item.isCorrect ? "true" : "false"}
            className="rounded-2xl border border-border/50 bg-surface-1 p-4"
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
              <div className="rounded-xl bg-surface-3 p-3">
                <div className="text-xs uppercase tracking-widest text-muted-foreground">
                  {labels.yourAnswer}
                </div>
                <div className="mt-1 font-mono uppercase">
                  {getDisplayChoice(item.questionId, item.selectedChoice)}
                </div>
              </div>
              <div className="rounded-xl bg-surface-3 p-3">
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
            <MistakeBlock
              item={item}
              labels={labels}
              resolveMisconceptionLabel={resolveMisconceptionLabel}
              onTrain={onTrain}
              trainLabel={trainLabel}
            />
          </div>
        ))}
      </div>
    </div>
  );
}

/**
 * Le bloc riche d'UNE question ratée. Rend `null` — donc rien du tout, pas un
 * cadre vide — dès qu'il n'a ni erreur nommée ni cours à proposer.
 */
function MistakeBlock({
  item,
  labels,
  resolveMisconceptionLabel,
  onTrain,
  trainLabel,
}: {
  item: PlayerReviewItem;
  labels: { reviewMistakeTitle: string; reviewCourseCta: string };
  resolveMisconceptionLabel?: (tag: string) => string | null;
  /**
   * Résout la compétence de l'erreur en un exercice d'entraînement, puis y mène.
   * Injecté par l'écran : le composant ne sait pas qu'une RPC existe. Absent =
   * pas de geste « m'entraîner », ce qui reste un rendu valide (R-A1.2-3).
   */
  onTrain?: (competency: string) => void;
  trainLabel?: string;
}) {
  // R-A1.2-2 : rien sur une bonne réponse. Le serveur ne tague déjà que les
  // réponses fausses (A1.2a) ; la garde est ici aussi, pour que le composant
  // reste juste même servi par une correction d'une autre provenance.
  if (item.isCorrect) return null;

  const label = item.misconceptionTag
    ? (resolveMisconceptionLabel?.(item.misconceptionTag) ?? null)
    : null;
  const chapterId = item.chapterId ?? null;
  // « M'entraîner » (A12) n'apparaît que si l'erreur DÉCLARE une compétence : une
  // confusion de vocabulaire n'en a pas, et proposer un exercice au hasard serait
  // pire que de ne rien proposer.
  const competency = onTrain && trainLabel ? (item.misconceptionCompetency ?? null) : null;
  if (!label && !chapterId && !competency) return null;

  return (
    <div
      data-testid="review-mistake"
      className="mt-3 rounded-xl border border-[color:var(--flame)]/25 bg-[color:var(--flame)]/5 p-3"
    >
      {label && (
        <>
          <div className="text-xs font-bold uppercase tracking-widest text-flame-ink">
            {labels.reviewMistakeTitle}
          </div>
          <p data-testid="review-mistake-label" className="mt-1 text-sm">
            {label}
          </p>
        </>
      )}
      <div className={`flex flex-wrap items-center gap-2 ${label ? "mt-2" : ""}`}>
        {chapterId && (
          <Link
            to="/lesson/$chapterId"
            params={{ chapterId }}
            data-testid="review-course-link"
            className="inline-flex items-center gap-1 rounded-lg border border-[color:var(--gold)]/30 px-2 py-1 text-xs font-bold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10"
          >
            <BookOpen className="h-3 w-3" />
            {labels.reviewCourseCta}
          </Link>
        )}
        {competency && (
          <button
            type="button"
            onClick={() => onTrain?.(competency)}
            data-testid="review-train-button"
            className="inline-flex items-center gap-1 rounded-lg border border-[color:var(--gold)]/30 px-2 py-1 text-xs font-bold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10"
          >
            <Dumbbell className="h-3 w-3" />
            {trainLabel}
          </button>
        )}
      </div>
    </div>
  );
}
