import { createFileRoute } from "@tanstack/react-router";
import { Swords } from "lucide-react";
import { BackLink } from "@/components/ui/back-link";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { PageShell } from "@/components/ui/page-shell";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getDuelQuestions, getDuelState, submitDuelAnswer } from "@/features/duel";
import { DuelArena } from "@/features/duel/components/duel-arena";
import { DuelRecap } from "@/features/duel/components/duel-recap";
import { OpponentProgress } from "@/features/duel/components/opponent-progress";
import { useDuelChannel } from "@/features/duel/use-duel-channel";
import { useAuth } from "@/features/auth";
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
  const { user } = useAuth();
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

  // Realtime enhancement layer (lot 4): presence + live opponent progress. The
  // get_duel_state polling above stays the source of truth + the R-12 fallback.
  const channel = useDuelChannel({
    duelId,
    userId: user?.id,
    myAnswered: stateQuery.data?.myAnswered ?? 0,
    enabled: stateQuery.data?.status === "active",
  });

  const state = stateQuery.data;
  const rtl = locale === "ar";

  if (stateQuery.isLoading || questionsQuery.isLoading) {
    return <LoadingState label={t.duel.loading} className="min-h-[40dvh]" />;
  }
  if (stateQuery.isError || !state) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={Swords}
          title={t.duel.notFound}
          action={
            <BackLink to="/duel" className="mb-0">
              {t.duel.backToHub}
            </BackLink>
          }
        />
      </div>
    );
  }

  const settled = state.status === "finished" || state.status === "expired";
  const iFinished = state.myAnswered >= state.total && state.total > 0;
  const questions = questionsQuery.data?.questions ?? [];
  const currentQuestion = questions[state.myAnswered];

  // Prefer the live (broadcast) opponent count when Realtime is up, but never let
  // it regress below the authoritative polled value (R-12 fallback stays valid).
  const opponentAnswered =
    channel.realtimeActive && channel.liveOpponentAnswered != null
      ? Math.max(channel.liveOpponentAnswered, state.opponentAnswered)
      : state.opponentAnswered;
  const opponentOnline = channel.realtimeActive ? channel.opponentOnline : undefined;

  return (
    <PageShell width="narrow" className="space-y-4">
      <BackLink to="/duel" className="mb-0">
        {t.duel.backToHub}
      </BackLink>

      {settled ? (
        <DuelRecap state={state} labels={t.duel} />
      ) : iFinished || !currentQuestion ? (
        <div className="space-y-4 rounded-2xl border border-gold/30 bg-black/60 p-6 text-center backdrop-blur-md">
          <p className="font-medium" role="status">
            {t.duel.waitingOpponent}
          </p>
          <OpponentProgress
            answered={opponentAnswered}
            total={state.total}
            finished={state.opponentFinished}
            online={opponentOnline}
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
              answered={opponentAnswered}
              total={state.total}
              finished={state.opponentFinished}
              online={opponentOnline}
              labels={t.duel}
            />
          }
        />
      )}
    </PageShell>
  );
}
