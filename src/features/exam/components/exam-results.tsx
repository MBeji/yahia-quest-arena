import { Check, X } from "lucide-react";

import { OptionContent, RichField } from "@/components/ui/svg-figure";
import { useI18n, useT } from "@/lib/i18n";
import { cn } from "@/shared/lib/utils";

import type { ExamPercentile, ExamResult, ExamReview } from "../exam.server";

/**
 * La copie corrigée.
 *
 * Ce qui est montré en premier n'est pas un pourcentage mais une **note sur 20** :
 * c'est la seule échelle que l'élève, le parent et l'établissement lisent de la
 * même façon, et c'est celle du concours. Le pourcentage sert à l'économie de
 * jeu, pas à la conversation du dimanche soir.
 *
 * Le détail par épreuve affiche le COEFFICIENT à côté du résultat : sans lui,
 * « 8/10 en anglais » et « 8/10 en maths » se lisent pareil, alors qu'ils ne
 * pèsent pas du tout pareil au concours. C'est l'information qui doit changer la
 * façon de réviser la semaine suivante.
 */
export function ExamResults({
  result,
  percentile,
  review,
  onRetryPractice,
}: {
  result: ExamResult;
  percentile: ExamPercentile | null;
  review: ExamReview | null;
  onRetryPractice?: () => void;
}) {
  const t = useT();
  const { locale } = useI18n();

  const label = (fr: string, en: string | null, ar: string | null) =>
    (locale === "ar" ? ar : locale === "en" ? en : fr) || fr;

  // Le barème est le coefficient du concours ×10 (cf. la migration du seed) ;
  // on le rend tel que l'élève le nomme. Le repli sur une décimale évite un
  // « coef. 1.5 » affiché « 1.5000000001 » si un futur examen s'écarte du ×10.
  const coefficientOf = (points: number) => {
    const coef = points / 10;
    return Number.isInteger(coef) ? String(coef) : coef.toFixed(1);
  };

  return (
    <div className="flex flex-col gap-6">
      {/* --- La note --- */}
      <section className="rounded-xl border border-border bg-surface-3 p-6 text-center">
        <p className="text-sm uppercase tracking-wide text-muted-foreground">{t.exam.scoreOn20}</p>
        <p className="font-display text-5xl font-bold tabular-nums text-gold">
          {result.scoreOn20.toFixed(2)}
        </p>
        <p className="mt-1 text-sm text-muted-foreground tabular-nums">
          {t.exam.scorePoints
            .replace("{score}", String(result.scorePoints))
            .replace("{max}", String(result.maxPoints))}
        </p>

        {result.kind === "ranked" ? (
          <p className="mt-3 text-sm text-success tabular-nums">
            {t.exam.rewards
              .replace("{xp}", String(result.xpEarned))
              .replace("{coins}", String(result.coinsEarned))}
          </p>
        ) : (
          <p className="mt-3 text-sm text-muted-foreground">{t.exam.practiceNoRank}</p>
        )}

        {percentile && result.kind === "ranked" ? (
          <p className="mt-2 text-sm text-foreground tabular-nums">
            {percentile.percentile === null
              ? t.exam.percentilePending.replace("{n}", String(percentile.minCandidates))
              : t.exam.percentile.replace("{pct}", String(percentile.percentile))}
          </p>
        ) : null}
      </section>

      {/* --- Le détail par épreuve, coefficient compris --- */}
      <section className="flex flex-col gap-3">
        <h2 className="font-display text-lg font-bold">{t.exam.byPaper}</h2>
        <ul className="flex flex-col gap-2">
          {result.papers.map((p) => {
            const ratio = p.total > 0 ? p.correct / p.total : 0;
            return (
              <li key={p.exerciseId} className="rounded-lg border border-border bg-surface-2 p-3">
                <div className="flex flex-wrap items-baseline justify-between gap-2">
                  <span className="font-medium">{label(p.labelFr, p.labelEn, p.labelAr)}</span>
                  <span className="text-sm text-muted-foreground tabular-nums">
                    {t.exam.coefficient.replace("{n}", coefficientOf(p.points))} · {p.correct}/
                    {p.total} · {p.earned ?? 0}/{p.points}
                  </span>
                </div>
                <div
                  className="mt-2 h-1.5 w-full overflow-hidden rounded-full bg-surface-1"
                  role="presentation"
                >
                  <div
                    className={cn(
                      "h-full rounded-full",
                      ratio >= 0.6 ? "bg-success" : "bg-destructive",
                    )}
                    style={{ width: `${Math.round(ratio * 100)}%` }}
                  />
                </div>
              </li>
            );
          })}
        </ul>
      </section>

      {/* --- Le corrigé, qui n'existe qu'ici (R-3) --- */}
      {review && review.length > 0 ? (
        <section className="flex flex-col gap-4">
          <h2 className="font-display text-lg font-bold">{t.exam.review}</h2>
          {review.map((paper) => (
            <div key={paper.exerciseId} className="flex flex-col gap-3">
              <h3 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
                {label(paper.labelFr, paper.labelEn, paper.labelAr)}
              </h3>
              {paper.questions.map((q) => {
                const chosen = q.options.find((o) => o.id === q.selectedChoice);
                const expected = q.options.find((o) => o.id === q.correctChoice);
                return (
                  <article
                    key={q.questionId}
                    className="rounded-lg border border-border bg-surface-2 p-3"
                  >
                    <div className="flex items-start gap-2">
                      {q.isCorrect ? (
                        <Check className="mt-1 size-4 shrink-0 text-success" aria-hidden="true" />
                      ) : (
                        <X className="mt-1 size-4 shrink-0 text-destructive" aria-hidden="true" />
                      )}
                      <RichField raw={q.prompt} className="font-medium" />
                    </div>

                    <dl className="mt-2 flex flex-col gap-1 text-sm">
                      <div className="flex flex-wrap items-baseline gap-2">
                        <dt className="text-muted-foreground">{t.exam.yourAnswer}</dt>
                        <dd className={q.isCorrect ? "text-success" : "text-destructive"}>
                          {q.selectedChoice === null ? (
                            t.exam.noAnswer
                          ) : chosen ? (
                            <OptionContent raw={chosen.text} />
                          ) : (
                            q.selectedChoice
                          )}
                        </dd>
                      </div>
                      {!q.isCorrect && q.correctChoice !== null ? (
                        <div className="flex flex-wrap items-baseline gap-2">
                          <dt className="text-muted-foreground">{t.exam.correctAnswer}</dt>
                          <dd className="text-success">
                            {expected ? <OptionContent raw={expected.text} /> : q.correctChoice}
                          </dd>
                        </div>
                      ) : null}
                    </dl>

                    {q.explanation ? (
                      <RichField
                        raw={q.explanation}
                        className="mt-2 text-sm text-muted-foreground"
                      />
                    ) : null}
                  </article>
                );
              })}
            </div>
          ))}
        </section>
      ) : null}

      {onRetryPractice ? (
        <button
          type="button"
          onClick={onRetryPractice}
          className="self-start rounded-lg border border-border bg-surface-2 px-4 py-2 text-sm font-medium hover:bg-surface-3"
        >
          {t.exam.retryPractice}
        </button>
      ) : null}
    </div>
  );
}
