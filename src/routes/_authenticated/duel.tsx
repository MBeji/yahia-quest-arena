import { useEffect, useRef, useState } from "react";
import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import {
  forfeitDuel,
  getDuelHistory,
  getDuelLastAward,
  getDuelLeague,
  leaveDuelQueue,
  matchDuel,
} from "@/features/duel";
import { DuelQueueCard } from "@/features/duel/components/duel-queue-card";
import { DuelLeague } from "@/features/duel/components/duel-league";
import { Swords } from "lucide-react";
import { BackLink } from "@/components/ui/back-link";
import { EmptyState } from "@/components/ui/empty-state";
import { PageShell } from "@/components/ui/page-shell";
import { DUEL_REWARDS } from "@/shared/constants/gamification";
import { useT } from "@/lib/i18n";
import { toast } from "sonner";

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
    // Surface a real error (rate limit, no active parcours, active-duel cap)
    // instead of silently re-polling and spinning on "Recherche…" forever.
    onError: (err) => {
      stopPolling();
      setSearching(false);
      toast.error(err instanceof Error ? err.message : t.duel.errorSearch);
    },
  });

  const leaveMutation = useMutation({ mutationFn: () => leave() });

  // Abandon an active duel: frees the active-duel cap when an opponent no-shows.
  const forfeit = useServerFn(forfeitDuel);
  const forfeitMutation = useMutation({
    mutationFn: (duelId: string) => forfeit({ data: { duelId } }),
    onSuccess: () => {
      historyQuery.refetch();
      toast.success(t.duel.forfeitDone);
    },
    onError: (err) => toast.error(err instanceof Error ? err.message : t.duel.errorSearch),
  });

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
    <PageShell width="narrow" className="space-y-6">
      <BackLink to="/dashboard" className="mb-0">
        {t.common.backToHall}
      </BackLink>
      <header>
        <h1 className="flex items-center gap-2 font-display text-3xl font-bold sm:text-4xl">
          <Swords className="h-7 w-7 text-gold" /> {t.duel.title}
        </h1>
      </header>

      {/* Pre-match narration (étude 15 lot 11, D-7): tell the rule and show the reward
          tiers BEFORE the click — participation always pays. Constants from gamification.ts. */}
      <div className="rounded-2xl border border-gold/25 bg-black/40 p-4 backdrop-blur-md">
        <p className="text-sm text-muted-foreground">{t.duel.rulesFirstDone}</p>
        <div className="mt-3 flex flex-wrap gap-2">
          {[
            { key: "win", label: t.duel.rewardWin, xp: DUEL_REWARDS.win.xp },
            { key: "draw", label: t.duel.rewardDraw, xp: DUEL_REWARDS.draw.xp },
            { key: "loss", label: t.duel.rewardLoss, xp: DUEL_REWARDS.loss.xp },
          ].map((tier) => (
            <span
              key={tier.key}
              className="inline-flex items-center gap-1.5 rounded-full border border-gold/30 px-3 py-1 text-xs font-semibold text-gold"
            >
              {tier.label} · +{tier.xp} XP
            </span>
          ))}
        </div>
        <p className="mt-2 text-xs text-muted-foreground">{t.duel.rewardsHint}</p>
      </div>

      <DuelQueueCard
        searching={searching}
        disabled={matchMutation.isPending && !searching}
        onFind={onFind}
        onCancel={onCancel}
        labels={t.duel}
      />

      {active.length > 0 ? (
        <section className="space-y-2">
          <h2 className="font-display text-xl font-bold">{t.duel.activeDuels}</h2>
          {active.map((e) => (
            <div
              key={e.duelId}
              className="flex items-center justify-between gap-2 rounded-xl border border-border/50 bg-black/40 p-3 backdrop-blur-md"
            >
              <span>{t.duel[STATUS_KEY[e.status]]}</span>
              <div className="flex items-center gap-4">
                <Link
                  to="/duel/$duelId"
                  params={{ duelId: e.duelId }}
                  className="inline-flex min-h-11 items-center font-semibold text-gold underline-offset-2 hover:underline"
                >
                  {e.status === "pending" ? t.duel.play : t.duel.resume}
                </Link>
                <button
                  type="button"
                  onClick={() => forfeitMutation.mutate(e.duelId)}
                  disabled={forfeitMutation.isPending}
                  className="inline-flex min-h-11 items-center text-sm text-muted-foreground transition hover:text-destructive disabled:opacity-50"
                >
                  {t.duel.forfeit}
                </button>
              </div>
            </div>
          ))}
        </section>
      ) : null}

      <section className="space-y-2">
        <h2 className="font-display text-xl font-bold">{t.duel.history}</h2>
        {past.length === 0 ? (
          <EmptyState icon={Swords} title={t.duel.noHistory} />
        ) : (
          <ul className="space-y-2">
            {past.map((e) => (
              <li
                key={e.duelId}
                className="flex items-center justify-between rounded-xl border border-border/50 bg-black/40 p-3 text-sm backdrop-blur-md"
              >
                <span className="text-muted-foreground">{t.duel[STATUS_KEY[e.status]]}</span>
                <Link
                  to="/duel/$duelId"
                  params={{ duelId: e.duelId }}
                  className="inline-flex min-h-11 items-center font-semibold text-gold underline-offset-2 hover:underline"
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
    </PageShell>
  );
}
