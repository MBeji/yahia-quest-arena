import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getDuelQuestions, getDuelState, submitDuelAnswer } from "@/features/duel";
import { DuelArena } from "@/features/duel/components/duel-arena";
import { DuelRecap } from "@/features/duel/components/duel-recap";
import { OpponentProgress } from "@/features/duel/components/opponent-progress";
import { buildQuestLabels } from "@/features/quest/quest-labels";
import { useI18n, useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/duel/$duelId")({
  head: () => ({ meta: [{ title: "Duel · Na9ra Nal3ab" }] }),
  component: DuelPlayPage,
});

function DuelPlayPage() {
  const { duelId } = Route.useParams();
  const t = useT();
  const { locale } = useI18n();
  const qc = useQueryClient();
  const fetchState = useServerFn(getDuelState);
  const fetchQuestions = useServerFn(getDuelQuestions);
  const submit = useServerFn(submitDuelAnswer);

  const stateQuery = useQuery({
    queryKey: ["duel-state", duelId],
    queryFn: () => fetchState({ data: { duelId } }),
    // Poll while the duel is live; stop once settled.
    refetchInterval: (q) => (q.state.data?.status === "active" ? 3000 : false),
  });

  const questionsQuery = useQuery({
    queryKey: ["duel-questions", duelId],
    queryFn: () => fetchQuestions({ data: { duelId } }),
  });

  const answerMutation = useMutation({
    mutationFn: (choice: string) => {
      const q = questionsQuery.data?.questions[stateQuery.data?.myAnswered ?? 0];
      if (!q) throw new Error("no question");
      return submit({ data: { duelId, questionId: q.id, choice } });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["duel-state", duelId] });
      qc.invalidateQueries({ queryKey: ["duel-history"] });
    },
  });

  const state = stateQuery.data;
  const rtl = locale === "ar";

  if (stateQuery.isLoading || questionsQuery.isLoading) {
    return <p className="p-6 text-center text-muted-foreground">{t.duel.loading}</p>;
  }
  if (stateQuery.isError || !state) {
    return (
      <div className="p-6 text-center">
        <p className="text-muted-foreground">{t.duel.notFound}</p>
        <Link to="/duel" className="mt-3 inline-block underline">
          {t.duel.backToHub}
        </Link>
      </div>
    );
  }

  const settled = state.status === "finished" || state.status === "expired";
  const iFinished = state.myAnswered >= state.total && state.total > 0;
  const questions = questionsQuery.data?.questions ?? [];
  const currentQuestion = questions[state.myAnswered];

  return (
    <div className="mx-auto max-w-2xl space-y-4 p-4">
      <Link to="/duel" className="text-sm text-muted-foreground underline-offset-2 hover:underline">
        ← {t.duel.backToHub}
      </Link>

      {settled ? (
        <DuelRecap state={state} labels={t.duel} />
      ) : iFinished || !currentQuestion ? (
        <div className="space-y-4 rounded-xl border border-border p-6 text-center">
          <p className="font-medium" role="status">
            {t.duel.waitingOpponent}
          </p>
          <OpponentProgress
            answered={state.opponentAnswered}
            total={state.total}
            finished={state.opponentFinished}
            labels={t.duel}
          />
        </div>
      ) : (
        <DuelArena
          question={currentQuestion}
          questionIndex={state.myAnswered}
          total={state.total}
          rtl={rtl}
          questLabels={buildQuestLabels(locale)}
          labels={t.duel}
          submitting={answerMutation.isPending}
          tooFast={answerMutation.data?.tooFast === true}
          onSubmit={(choice) => answerMutation.mutate(choice)}
          opponent={
            <OpponentProgress
              answered={state.opponentAnswered}
              total={state.total}
              finished={state.opponentFinished}
              labels={t.duel}
            />
          }
        />
      )}
    </div>
  );
}
