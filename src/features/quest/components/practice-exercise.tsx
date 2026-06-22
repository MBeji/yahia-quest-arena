import { useMemo, useState } from "react";
import { Link } from "@tanstack/react-router";
import { ArrowLeft, Check, Loader2, RotateCcw, Sparkles, X, Zap } from "lucide-react";
import { RichField, OptionContent } from "@/components/ui/svg-figure";
import { isMathExpression, isRtlText } from "@/shared/lib/utils";
import { shuffleOptions, type BaseOption } from "@/shared/lib/question-utils";
import { useT } from "@/lib/i18n";
import type { PracticeReviewItem } from "@/features/quest/quest.server";

/**
 * Public practice screen — « Référence » register (chantier C8, L1.5). « Mode
 * entraînement » : an anonymous visitor answers the QCM and, on « Corriger »,
 * gets an immediate correction (right/wrong options + explanation + score) via
 * the public `check_answers` RPC. Nothing is recorded, no XP — the account is the
 * upsell (XP/save/leaderboard). Presentational: the route owns the data
 * (`getExercise`) and the `checkAnswers` caller (`checkAnswersPublic`); this
 * component holds only the local answer/review UI state. Copy is i18n (fr/en/ar).
 */

export type PracticeExerciseInfo = {
  id: string;
  title: string;
  subject_id: string | null;
  subjects?: { content_language?: string | null } | null;
};

export type PracticeQuestion = { id: string; prompt: string; options: BaseOption[] };

export type CheckAnswersResult = {
  reviewable: boolean;
  correct: number;
  total: number;
  scorePct: number;
  review: PracticeReviewItem[];
};

export function PracticeExercise({
  exercise,
  questions,
  isAuthenticated,
  checkAnswers,
}: {
  exercise: PracticeExerciseInfo;
  questions: PracticeQuestion[];
  isAuthenticated: boolean;
  checkAnswers: (payload: {
    exerciseId: string;
    answers: { questionId: string; choice: string }[];
  }) => Promise<CheckAnswersResult>;
}) {
  const t = useT();
  const isRtl = exercise.subjects?.content_language === "ar";
  // Shuffle once per question set (stable across re-renders; reset re-shuffles via runKey).
  const [runKey, setRunKey] = useState(0);
  const optionsByQuestion = useMemo(
    () => new Map(questions.map((q) => [q.id, shuffleOptions((q.options as BaseOption[]) ?? [])])),
    // runKey forces a fresh shuffle on « Recommencer »
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [questions, runKey],
  );

  const [selections, setSelections] = useState<Record<string, string>>({});
  const [result, setResult] = useState<CheckAnswersResult | null>(null);
  const [isChecking, setIsChecking] = useState(false);
  const [failed, setFailed] = useState(false);

  const reviewByQuestion = useMemo(
    () => new Map((result?.review ?? []).map((r) => [r.questionId, r])),
    [result],
  );

  const allAnswered = questions.length > 0 && Object.keys(selections).length === questions.length;
  const corrected = result !== null;

  async function onCorrect() {
    if (!allAnswered || isChecking) return;
    setIsChecking(true);
    setFailed(false);
    try {
      const res = await checkAnswers({
        exerciseId: exercise.id,
        answers: questions.map((q) => ({ questionId: q.id, choice: selections[q.id] })),
      });
      setResult(res);
      if (typeof window !== "undefined") window.scrollTo({ top: 0, behavior: "smooth" });
    } catch {
      setFailed(true);
    } finally {
      setIsChecking(false);
    }
  }

  function onReset() {
    setSelections({});
    setResult(null);
    setFailed(false);
    setRunKey((k) => k + 1);
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6" dir={isRtl ? "rtl" : "ltr"}>
      {exercise.subject_id ? (
        <Link
          to="/matiere/$subjectId"
          params={{ subjectId: exercise.subject_id }}
          className="inline-flex items-center gap-1.5 text-sm font-medium text-muted-foreground transition hover:text-primary"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.public.practice.back}
        </Link>
      ) : null}

      <header className="mb-6 mt-3">
        <div className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          {t.public.practice.modeKicker}
        </div>
        <h1
          className="mt-1 font-display text-2xl font-bold leading-tight sm:text-3xl"
          dir={isRtlText(exercise.title) ? "rtl" : "ltr"}
        >
          {exercise.title}
        </h1>
        <p className="mt-2 text-sm text-muted-foreground">{t.public.practice.subtitle}</p>
      </header>

      {corrected && (
        <div
          data-testid="practice-score"
          className="mb-6 rounded-2xl border border-primary/30 bg-primary/[0.04] p-5 text-center"
        >
          <div className="font-display text-3xl font-bold text-primary">{result.scorePct}%</div>
          <p className="mt-1 text-sm text-muted-foreground">
            {t.public.practice.scoreCorrect
              .replace("{correct}", String(result.correct))
              .replace("{total}", String(result.total))}
          </p>
        </div>
      )}

      <div className="space-y-5">
        {questions.map((q, qi) => {
          const opts = optionsByQuestion.get(q.id) ?? [];
          const review = reviewByQuestion.get(q.id);
          const questionLabel = t.public.practice.questionN.replace("{n}", String(qi + 1));
          return (
            <section key={q.id} className="rounded-2xl border border-border bg-card p-5">
              <div className="text-xs font-bold uppercase tracking-wider text-primary">
                {questionLabel}
              </div>
              <RichField
                raw={q.prompt}
                as="h2"
                className="mt-1 font-display text-lg font-semibold"
              />

              <div className="mt-4 space-y-2.5" role="radiogroup" aria-label={questionLabel}>
                {opts.map((opt) => {
                  const selected = selections[q.id] === opt.id;
                  const isCorrectOpt = corrected && review && opt.id === review.correctChoice;
                  const isWrongPick =
                    corrected && review && opt.id === review.selectedChoice && !review.isCorrect;
                  const cls = isCorrectOpt
                    ? "border-emerald-500/60 bg-emerald-500/10"
                    : isWrongPick
                      ? "border-destructive/60 bg-destructive/10"
                      : selected && !corrected
                        ? "border-primary bg-primary/10"
                        : "border-border bg-background hover:border-primary/50";
                  return (
                    <button
                      key={opt.id}
                      type="button"
                      role="radio"
                      aria-checked={selected}
                      disabled={corrected}
                      onClick={() => setSelections((prev) => ({ ...prev, [q.id]: opt.id }))}
                      className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3 text-left text-sm transition disabled:cursor-default ${cls}`}
                    >
                      <span
                        className="flex items-center gap-3"
                        dir={
                          isMathExpression(opt.text)
                            ? "ltr"
                            : isRtlText(opt.text)
                              ? "rtl"
                              : undefined
                        }
                      >
                        <span className="grid h-7 w-7 shrink-0 place-items-center rounded-md border border-current font-mono text-xs uppercase">
                          {opt.displayId}
                        </span>
                        <OptionContent raw={opt.text} />
                      </span>
                      {isCorrectOpt && (
                        <Check
                          className="h-5 w-5 shrink-0 text-emerald-600"
                          aria-label={t.public.practice.correctAria}
                        />
                      )}
                      {isWrongPick && (
                        <X
                          className="h-5 w-5 shrink-0 text-destructive"
                          aria-label={t.public.practice.yourAnswerAria}
                        />
                      )}
                      {selected && !corrected && (
                        <Check className="h-5 w-5 shrink-0 text-primary" aria-hidden="true" />
                      )}
                    </button>
                  );
                })}
              </div>

              {corrected && review?.explanation && (
                <RichField
                  raw={review.explanation}
                  as="p"
                  className="mt-3 rounded-xl bg-secondary p-3 text-sm text-muted-foreground"
                />
              )}
            </section>
          );
        })}
      </div>

      {failed && (
        <p className="mt-4 text-center text-sm text-destructive">{t.public.practice.checkError}</p>
      )}

      {!corrected ? (
        <div className="mt-6 flex flex-col items-center gap-2">
          <button
            type="button"
            data-testid="practice-check"
            disabled={!allAnswered || isChecking}
            onClick={onCorrect}
            className="inline-flex items-center gap-2 rounded-lg bg-primary px-6 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90 disabled:opacity-40"
          >
            {isChecking && <Loader2 className="h-4 w-4 animate-spin" />}
            {t.public.practice.checkCta}
          </button>
          {!allAnswered && (
            <p className="text-xs text-muted-foreground">{t.public.practice.answerAllHint}</p>
          )}
        </div>
      ) : (
        <div className="mt-8 space-y-4">
          <div className="flex justify-center">
            <button
              type="button"
              onClick={onReset}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
            >
              <RotateCcw className="h-4 w-4" /> {t.public.practice.restart}
            </button>
          </div>

          {isAuthenticated ? (
            <Link
              to="/quest/$exerciseId"
              params={{ exerciseId: exercise.id }}
              className="flex items-center justify-center gap-2 rounded-2xl border border-primary/30 bg-primary/[0.04] p-4 text-sm font-semibold text-primary transition hover:bg-primary/10"
            >
              <Zap className="h-4 w-4" /> {t.public.practice.questCta}
            </Link>
          ) : (
            <div className="rounded-2xl border border-primary/30 bg-primary/[0.04] p-5 text-center">
              <Sparkles className="mx-auto h-6 w-6 text-primary" />
              <p className="mt-2 text-sm font-semibold">{t.public.practice.inviteDesc}</p>
              <Link
                to="/signup"
                className="mt-3 inline-flex items-center gap-1.5 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
              >
                {t.public.practice.inviteCta}
              </Link>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
