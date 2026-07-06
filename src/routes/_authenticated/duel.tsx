import { useEffect, useRef, useState } from "react";
import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import {
  getDuelHistory,
  getDuelLastAward,
  getDuelLeague,
  leaveDuelQueue,
  matchDuel,
} from "@/features/duel";
import { DuelQueueCard } from "@/features/duel/components/duel-queue-card";
import { DuelLeague } from "@/features/duel/components/duel-league";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/duel")({
  head: () => ({ meta: [{ title: "Duels · Na9ra Nal3ab" }] }),
  component: DuelHubPage,
});

const STATUS_KEY = {
  active: "statusActive",
  finished: "statusFinished",
  expired: "statusExpired",
  pending: "statusPending",
} as const;

function DuelHubPage() {
  const t = useT();
  const navigate = useNavigate();
  const match = useServerFn(matchDuel);
  const leave = useServerFn(leaveDuelQueue);
  const history = useServerFn(getDuelHistory);
  const league = useServerFn(getDuelLeague);
  const lastAward = useServerFn(getDuelLastAward);
  const [searching, setSearching] = useState(false);
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const historyQuery = useQuery({
    queryKey: ["duel-history"],
    queryFn: () => history(),
  });
  const leagueQuery = useQuery({ queryKey: ["duel-league"], queryFn: () => league() });
  const awardQuery = useQuery({ queryKey: ["duel-last-award"], queryFn: () => lastAward() });

  const stopPolling = () => {
    if (pollRef.current) clearInterval(pollRef.current);
    pollRef.current = null;
  };

  const matchMutation = useMutation({
    mutationFn: () => match(),
    onSuccess: (res) => {
      if (res.duelId) {
        stopPolling();
        setSearching(false);
        navigate({ to: "/duel/$duelId", params: { duelId: res.duelId } });
      }
    },
  });

  const leaveMutation = useMutation({ mutationFn: () => leave() });

  // Poll match_duel while searching (a NULL result = still waiting; a duel id
  // navigates away). Cleared on cancel / unmount.
  useEffect(() => {
    if (!searching) return;
    pollRef.current = setInterval(() => matchMutation.mutate(), 3000);
    return stopPolling;
    // matchMutation identity is stable enough for this interval.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searching]);

  const onFind = () => {
    setSearching(true);
    matchMutation.mutate();
  };
  const onCancel = () => {
    stopPolling();
    setSearching(false);
    leaveMutation.mutate();
  };

  const entries = historyQuery.data?.entries ?? [];
  const active = entries.filter((e) => e.status === "active" || e.status === "pending");
  const past = entries.filter((e) => e.status === "finished" || e.status === "expired");

  return (
    <div className="mx-auto max-w-2xl space-y-6 p-4">
      <header>
        <h1 className="text-2xl font-bold">{t.duel.title}</h1>
      </header>

      <DuelQueueCard
        searching={searching}
        disabled={matchMutation.isPending && !searching}
        onFind={onFind}
        onCancel={onCancel}
        labels={t.duel}
      />

      {active.length > 0 ? (
        <section className="space-y-2">
          <h2 className="font-semibold">{t.duel.activeDuels}</h2>
          {active.map((e) => (
            <Link
              key={e.duelId}
              to="/duel/$duelId"
              params={{ duelId: e.duelId }}
              className="flex items-center justify-between rounded-lg border border-border p-3 hover:bg-muted"
            >
              <span>{t.duel[STATUS_KEY[e.status]]}</span>
              <span className="font-medium">
                {e.status === "pending" ? t.duel.play : t.duel.resume}
              </span>
            </Link>
          ))}
        </section>
      ) : null}

      <section className="space-y-2">
        <h2 className="font-semibold">{t.duel.history}</h2>
        {past.length === 0 ? (
          <p className="text-sm text-muted-foreground">{t.duel.noHistory}</p>
        ) : (
          <ul className="space-y-2">
            {past.map((e) => (
              <li
                key={e.duelId}
                className="flex items-center justify-between rounded-lg border border-border p-3 text-sm"
              >
                <span className="text-muted-foreground">{t.duel[STATUS_KEY[e.status]]}</span>
                <Link
                  to="/duel/$duelId"
                  params={{ duelId: e.duelId }}
                  className="font-medium underline-offset-2 hover:underline"
                >
                  {e.myScore}/{e.total}
                </Link>
              </li>
            ))}
          </ul>
        )}
      </section>

      <DuelLeague
        rows={leagueQuery.data?.rows ?? []}
        lastAward={awardQuery.data?.award ?? null}
        labels={t.duel}
      />
    </div>
  );
}
