import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Check, Sparkles, ThumbsDown, ThumbsUp, TriangleAlert, X } from "lucide-react";

import { LoadingState } from "@/components/ui/loading-state";
import { useT } from "@/lib/i18n";
import { getForgedQuiz, gradeForgedQuiz, type ForgedQuizResult } from "../forge.server";
import { submitAiFeedback } from "../ai-console.server";
import { toast } from "sonner";

/**
 * Le lecteur d'un quiz FORGÉ — étude 29 lot 4.
 *
 * POURQUOI IL N'EST PAS `ExercisePlayer`
 * -------------------------------------------------------------------------
 * L'étude dit « jouable dans le lecteur de quête existant », et l'intention est
 * claire : ne pas réinventer l'interaction. Deux faits l'ont emporté sur la
 * lettre, et les deux viennent de l'étude elle-même.
 *
 * 1. `ExercisePlayer` vit dans `@/features/quest`, et **une feature n'en importe
 *    jamais une autre** (AGENTS.md). Le partage passerait par `shared/`, donc
 *    par un déplacement du lecteur de quête — une refonte qui n'appartient pas à
 *    ce lot.
 * 2. Ce lecteur EST une machine à récompenses : session à usage unique, XP,
 *    pièces, badges, série, chrono de boss, quiz de compréhension, répétition
 *    espacée. R-16 les interdit TOUS pour un quiz forgé, et D-13 y ajoute la
 *    télémétrie d'apprentissage. Y brancher la Forge reviendrait à désarmer une
 *    à une les fonctions du composant, en espérant n'en oublier aucune.
 *
 * Ce lecteur-ci ne PEUT rien verser : il n'appelle qu'une RPC, et cette RPC
 * n'a pas de récompense à donner. C'est la même garantie, obtenue par
 * l'absence plutôt que par la désactivation.
 *
 * R-18bis.2 : l'étiquette « non vérifié » est portée par la QUESTION JOUÉE, pas
 * par l'écran de création — donc elle s'affiche ici, au moment de la correction,
 * là où l'élève peut encore en tenir compte.
 */

const OPTION_BASE =
  "flex min-h-11 w-full items-center gap-3 rounded-xl border px-3 py-2.5 text-start text-sm transition";

export function ForgedQuizPlayer({ quizId, onLeave }: { quizId: string; onLeave: () => void }) {
  const t = useT();
  const fetchQuiz = useServerFn(getForgedQuiz);
  const grade = useServerFn(gradeForgedQuiz);

  const { data: quiz, isLoading } = useQuery({
    queryKey: ["forged-quiz", quizId],
    queryFn: () => fetchQuiz({ data: { quizId } }),
    staleTime: 5 * 60_000,
  });

  const [index, setIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [result, setResult] = useState<ForgedQuizResult | null>(null);
  const [busy, setBusy] = useState(false);

  if (isLoading) return <LoadingState label={t.ai.forgeWorking} />;
  if (!quiz) return null;

  if (result) {
    return (
      <ForgedQuizResultScreen
        quizId={quizId}
        result={result}
        verified={quiz.verified}
        onReplay={() => {
          setAnswers({});
          setIndex(0);
          setResult(null);
        }}
        onLeave={onLeave}
      />
    );
  }

  const item = quiz.items[index];
  const chosen = answers[item.id];
  const last = index === quiz.items.length - 1;

  async function submit() {
    if (busy) return;
    setBusy(true);
    try {
      setResult(await grade({ data: { quizId, answers } }));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="mx-auto max-w-2xl" data-testid="forged-quiz">
      <Banner verified={quiz.verified} />

      <p className="mt-3 text-xs font-semibold uppercase tracking-widest text-muted-foreground">
        {t.ai.forgeQuestion
          .replace("{n}", String(index + 1))
          .replace("{total}", String(quiz.items.length))}
      </p>
      {/* La langue du contenu est celle de la MATIÈRE, jamais celle de
          l'interface (é11 R-3) : c'est `dir` qui suit le contenu, pas l'inverse. */}
      <h2 className="mt-1 text-lg font-bold" dir={quiz.lang === "ar" ? "rtl" : "ltr"}>
        {item.prompt}
      </h2>

      <div className="mt-3 grid gap-2" dir={quiz.lang === "ar" ? "rtl" : "ltr"}>
        {item.options.map((option) => (
          <button
            key={option.id}
            type="button"
            data-testid={`forge-option-${option.id}`}
            aria-pressed={chosen === option.id}
            onClick={() => setAnswers({ ...answers, [item.id]: option.id })}
            className={`${OPTION_BASE} ${
              chosen === option.id
                ? "border-[color:var(--gold)] bg-[color:var(--gold)]/12 text-foreground"
                : "border-border/60 text-muted-foreground hover:bg-accent"
            }`}
          >
            <span className="font-mono text-xs font-bold uppercase">{option.id}</span>
            <span>{option.text}</span>
          </button>
        ))}
      </div>

      <div className="mt-4 flex gap-2">
        <button
          type="button"
          disabled={!chosen || busy}
          data-testid="forge-advance"
          onClick={() => (last ? void submit() : setIndex(index + 1))}
          className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-[color:var(--gold)]/40 px-4 py-1.5 text-sm font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10 disabled:opacity-50"
        >
          {last ? t.ai.forgeFinish : t.ai.forgeNext}
        </button>
        <button
          type="button"
          onClick={onLeave}
          className="inline-flex min-h-11 items-center rounded-lg px-3 py-1.5 text-sm text-muted-foreground transition hover:text-foreground"
        >
          {t.ai.forgeBack}
        </button>
      </div>
    </div>
  );
}

/** L'étiquette permanente : d'où vient ce quiz, et ce qu'il ne rapporte pas (R-16, R-17). */
function Banner({ verified }: { verified: boolean }) {
  const t = useT();
  return (
    <div className="rounded-xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-2.5 text-xs">
      <p className="flex items-center gap-1.5 font-semibold">
        <Sparkles className="h-3.5 w-3.5 text-[color:var(--gold)]" />
        {t.ai.forgeNoReward}
      </p>
      {!verified && (
        <p
          className="mt-1 flex items-start gap-1.5 text-destructive"
          data-testid="forge-unverified"
        >
          <TriangleAlert className="mt-0.5 h-3.5 w-3.5 shrink-0" />
          <span>
            <strong>{t.ai.forgeUnverified}</strong> — {t.ai.forgeUnverifiedWhy}
          </span>
        </p>
      )}
    </div>
  );
}

function ForgedQuizResultScreen({
  quizId,
  result,
  verified,
  onReplay,
  onLeave,
}: {
  quizId: string;
  result: ForgedQuizResult;
  verified: boolean;
  onReplay: () => void;
  onLeave: () => void;
}) {
  const t = useT();
  return (
    <div className="mx-auto max-w-2xl" data-testid="forge-result">
      <Banner verified={verified} />

      {/* R-16 : un score, et RIEN d'autre. Pas de grille de récompense, pas de
          barre d'XP, pas de badge — il n'y en a pas à montrer. */}
      <h2 className="mt-3 font-display text-2xl font-bold">
        {t.ai.forgeScore
          .replace("{correct}", String(result.correct))
          .replace("{total}", String(result.total))}
      </h2>

      <ul className="mt-3 grid gap-2">
        {result.review.map((item) => (
          <li
            key={item.questionId}
            className="rounded-xl border border-border/60 p-2.5 text-sm"
            data-testid={`forge-review-${item.questionId}`}
          >
            <p className="flex items-start gap-2 font-semibold">
              {item.isCorrect ? (
                <Check className="mt-0.5 h-4 w-4 shrink-0 text-[color:var(--gold)]" />
              ) : (
                <X className="mt-0.5 h-4 w-4 shrink-0 text-destructive" />
              )}
              {item.prompt}
            </p>
            {item.explanation && (
              <p className="mt-1 text-xs text-muted-foreground">{item.explanation}</p>
            )}
          </li>
        ))}
      </ul>

      {/* R-13/R-19 : le 👍/👎 est la matière première de la console qualité. Il
          part avec le MODÈLE du quiz — lu côté serveur, pas déclaré par le
          navigateur — sinon un avis pourrait être imputé au mauvais modèle et la
          seule donnée que ce lot produit deviendrait fausse. */}
      <FeedbackButtons quizId={quizId} />

      <div className="mt-4 flex gap-2">
        <button
          type="button"
          onClick={onReplay}
          data-testid="forge-replay"
          className="inline-flex min-h-11 items-center rounded-lg border border-[color:var(--gold)]/40 px-4 py-1.5 text-sm font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10"
        >
          {t.ai.forgeReplay}
        </button>
        <button
          type="button"
          onClick={onLeave}
          className="inline-flex min-h-11 items-center rounded-lg px-3 py-1.5 text-sm text-muted-foreground transition hover:text-foreground"
        >
          {t.ai.forgeBack}
        </button>
      </div>
    </div>
  );
}

/**
 * Le retour qualité — R-17 : il va au canal IA, JAMAIS dans la file
 * `content_reports` du catalogue. Un item forgé n'est pas du catalogue : personne
 * ne le corrigera, et noyer la file éditoriale sous des signalements de contenu
 * éphémère la rendrait inutilisable.
 */
function FeedbackButtons({ quizId }: { quizId: string }) {
  const t = useT();
  const send = useServerFn(submitAiFeedback);
  const [sent, setSent] = useState(false);

  if (sent) return <p className="mt-3 text-xs text-muted-foreground">{t.ai.feedbackSent}</p>;

  function vote(verdict: "up" | "down") {
    void send({ data: { quizId, verdict } })
      .then(() => setSent(true))
      .catch(() => toast.error(t.ai.errGeneric));
  }

  return (
    <div className="mt-3 flex gap-2">
      <button
        type="button"
        onClick={() => vote("up")}
        data-testid="forge-thumbs-up"
        className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-border/60 px-3 py-1.5 text-xs font-semibold text-muted-foreground transition hover:text-foreground"
      >
        <ThumbsUp className="h-3.5 w-3.5" />
        {t.ai.feedbackUp}
      </button>
      <button
        type="button"
        onClick={() => vote("down")}
        data-testid="forge-thumbs-down"
        className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-destructive/50 px-3 py-1.5 text-xs font-semibold text-destructive transition hover:bg-destructive/10"
      >
        <ThumbsDown className="h-3.5 w-3.5" />
        {t.ai.feedbackDown}
      </button>
    </div>
  );
}
