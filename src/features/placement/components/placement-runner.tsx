import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { ChevronLeft, ChevronRight, Loader2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import { GoldProgress } from "@/components/game/gold-progress";
import { QuestionInput, type McqOptionRender } from "@/components/game/question-input";
import { RichField } from "@/components/ui/svg-figure";
import { usePlacementT } from "@/lib/i18n/placement";
import { isValidAnswerFormat } from "@/shared/lib/answer-formats";
import { buildQuestLabels, type QuestContentLang } from "@/shared/lib/quest-labels";
import { shuffleOptions, type BaseOption, type DisplayOption } from "@/shared/lib/question-utils";
import { cn } from "@/shared/lib/utils";

import type { PlacementServedQuestion } from "../placement.server";
import { readPlacementDraft, writePlacementDraft } from "../placement-memory";

/**
 * LA PASSATION (étude 39 US-1, R-3, R-4) — dix questions, une à la fois, SANS correction en cours
 * de route (patron é02 : « il ne corrige rien »). On peut revenir à la précédente ; on rend à la
 * fin. Le brouillon (réponses + position) vit en `sessionStorage` pour qu'un rechargement
 * reprenne là où l'élève en était (US-8).
 *
 * Ce n'est PAS `ExercisePlayer` (lié à un exercice, à une session de quête, à la correction
 * immédiate) : dix questions de dix missions, un seul envoi. Il en partage les primitives — la
 * saisie par type (`QuestionInput`), l'énoncé (`RichField`), la barre, les libellés par langue
 * de contenu — c'est la frontière que l'étude 30 §3.11 avait prévue.
 */
export function PlacementRunner({
  sessionId,
  questions,
  contentLanguage,
  resumed,
  finishing,
  finishError,
  onFinish,
  onLeave,
}: {
  sessionId: string;
  questions: PlacementServedQuestion[];
  contentLanguage: string | null;
  /** Le brouillon a été repris : on le dit une fois (R-15). */
  resumed?: boolean;
  finishing: boolean;
  finishError: string | null;
  onFinish: (
    answers: Array<{ questionId: string; choice: string }>,
    durationSeconds: number,
  ) => void;
  onLeave: () => void;
}) {
  const t = usePlacementT();
  const qlang = (
    contentLanguage === "ar" || contentLanguage === "en" ? contentLanguage : "fr"
  ) as QuestContentLang;
  const labels = useMemo(() => buildQuestLabels(qlang), [qlang]);
  const rtl = qlang === "ar";

  // Le brouillon, lu UNE fois au montage (SSR-safe : le serveur rend la première question).
  const draft = useMemo(() => readPlacementDraft(sessionId), [sessionId]);
  const [answers, setAnswers] = useState<Record<string, string>>(() => draft?.answers ?? {});
  const [idx, setIdx] = useState(() =>
    draft ? Math.min(Math.max(0, draft.index), Math.max(0, questions.length - 1)) : 0,
  );
  const [showResumed, setShowResumed] = useState(
    Boolean(resumed || (draft && Object.keys(draft.answers).length > 0)),
  );
  const startedAtRef = useRef<number>(Date.now());

  useEffect(() => {
    writePlacementDraft(sessionId, { answers, index: idx });
  }, [sessionId, answers, idx]);

  // Les options sont mélangées UNE fois par test, pas à chaque rendu (sinon elles bougent
  // sous le doigt). `shuffleOptions` pose les lettres A/B/C d'affichage.
  const optionsByQuestion = useMemo(() => {
    const map = new Map<string, DisplayOption[]>();
    for (const q of questions) map.set(q.id, shuffleOptions((q.options ?? []) as BaseOption[]));
    return map;
  }, [questions]);

  const total = questions.length;
  const current = questions[idx];
  const selected = current ? (answers[current.id] ?? null) : null;
  const type = current?.questionType ?? "mcq";
  const canAdvance = Boolean(selected && isValidAnswerFormat(type, selected));
  const answeredCount = questions.filter((q) => {
    const a = answers[q.id];
    return Boolean(a && isValidAnswerFormat(q.questionType ?? "mcq", a));
  }).length;
  const isLast = idx >= total - 1;

  const select = useCallback(
    (choice: string) => {
      if (!current) return;
      setShowResumed(false);
      setAnswers((prev) => ({ ...prev, [current.id]: choice }));
    },
    [current],
  );

  const finish = useCallback(() => {
    const list = questions
      .map((q) => ({ questionId: q.id, choice: answers[q.id] ?? "" }))
      .filter(
        (a) =>
          a.choice.length > 0 &&
          isValidAnswerFormat(
            questions.find((q) => q.id === a.questionId)?.questionType ?? "mcq",
            a.choice,
          ),
      );
    onFinish(list, Math.max(0, Math.round((Date.now() - startedAtRef.current) / 1000)));
  }, [answers, onFinish, questions]);

  const next = useCallback(() => {
    if (!canAdvance) return;
    if (isLast) {
      finish();
      return;
    }
    setIdx((i) => Math.min(total - 1, i + 1));
  }, [canAdvance, finish, isLast, total]);

  if (!current) return null;

  const optionClassName = ({ isSelected }: McqOptionRender) =>
    cn(
      "bg-card text-foreground",
      isSelected
        ? "border-primary bg-primary/10 text-primary"
        : "border-border hover:border-primary/60",
    );

  return (
    <div className="space-y-6" data-testid="placement-runner">
      <div>
        <div className="mb-2 flex items-center justify-between gap-3 text-sm text-muted-foreground">
          <span data-testid="placement-progress">
            {t.placement.runner.progress
              .replace("{n}", String(idx + 1))
              .replace("{total}", String(total))}
          </span>
          <button
            type="button"
            onClick={onLeave}
            className="text-xs underline-offset-2 hover:underline"
          >
            {t.placement.runner.leave}
          </button>
        </div>
        <GoldProgress
          value={(idx / total) * 100}
          aria-label={t.placement.runner.progress
            .replace("{n}", String(idx + 1))
            .replace("{total}", String(total))}
        />
      </div>

      {showResumed && (
        <p
          className="rounded-xl border border-primary/30 bg-primary/5 p-3 text-sm"
          data-testid="placement-resumed"
        >
          {t.placement.runner.resumed}
        </p>
      )}

      <article
        className="rounded-2xl border border-border bg-card p-5 sm:p-6"
        dir={rtl ? "rtl" : undefined}
      >
        <p
          className="text-xs font-semibold uppercase tracking-wider text-muted-foreground"
          dir={rtl ? "rtl" : undefined}
        >
          {current.chapterTitle}
        </p>
        <RichField
          raw={current.prompt}
          as="h2"
          className="mt-2 font-display text-lg font-bold leading-snug sm:text-xl"
        />
        <QuestionInput
          questionType={type}
          prompt={current.prompt}
          options={optionsByQuestion.get(current.id) ?? []}
          value={selected}
          onChange={select}
          onSubmit={next}
          disabled={finishing}
          rtl={rtl}
          labels={labels}
          optionClassName={optionClassName}
        />
      </article>

      <p className="text-center text-xs text-muted-foreground">
        {t.placement.runner.noFeedbackHint}
      </p>

      {isLast && answeredCount < total && (
        <p
          className="rounded-xl border border-border bg-card/60 p-3 text-center text-sm text-muted-foreground"
          data-testid="placement-unanswered"
        >
          {t.placement.runner.unanswered}
        </p>
      )}

      {finishError && (
        <p
          role="alert"
          className="rounded-xl border border-destructive/40 bg-destructive/10 p-3 text-sm text-destructive"
        >
          {finishError}
        </p>
      )}

      <div className="flex items-center justify-between gap-3">
        <Button
          type="button"
          variant="outline"
          className="min-h-11 gap-1.5"
          disabled={idx === 0 || finishing}
          onClick={() => setIdx((i) => Math.max(0, i - 1))}
          data-testid="placement-previous"
        >
          <ChevronLeft className="h-4 w-4 rtl:-scale-x-100" aria-hidden />{" "}
          {t.placement.runner.previous}
        </Button>
        <Button
          type="button"
          className="min-h-11 gap-1.5"
          disabled={!canAdvance || finishing}
          onClick={next}
          data-testid="placement-next"
        >
          {finishing ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" aria-hidden />{" "}
              {t.placement.runner.finishing}
            </>
          ) : isLast ? (
            t.placement.runner.finish
          ) : (
            <>
              {t.placement.runner.next}{" "}
              <ChevronRight className="h-4 w-4 rtl:-scale-x-100" aria-hidden />
            </>
          )}
        </Button>
      </div>
    </div>
  );
}
