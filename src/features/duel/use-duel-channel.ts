import { useEffect, useRef, useState } from "react";
import type { RealtimeChannel } from "@supabase/supabase-js";
import { supabase } from "@/shared/integrations/supabase/client";
import { useAuth } from "@/features/auth";
import { logger } from "@/shared/lib/logger";

/**
 * Duel Realtime channel (étude 05, lot 4). A private per-duel channel
 * `duel:{duelId}` carrying ONLY presence (opponent online) + a `progress`
 * broadcast (`{ answered }`) — never an answer, score or key (R-4). It is a
 * pure ENHANCEMENT layer on top of the authoritative `get_duel_state` polling:
 * if the channel never establishes, `realtimeActive` stays false and the caller
 * keeps polling (R-12 — the polling is always on and is the source of truth for
 * status/score/review). A fallback is logged as `duel.realtime_fallback`.
 */
export type DuelChannelState = {
  /** The channel reached SUBSCRIBED — live signals are flowing. */
  realtimeActive: boolean;
  /** Presence: the opponent currently has the duel open. */
  opponentOnline: boolean;
  /** Opponent's answered count from the live layer; null until a first signal. */
  liveOpponentAnswered: number | null;
};

type ProgressMeta = { answered?: number };

export function useDuelChannel({
  duelId,
  myAnswered,
  enabled,
}: {
  duelId: string;
  myAnswered: number;
  enabled: boolean;
}): DuelChannelState {
  const { user } = useAuth();
  const userId = user?.id;

  const [realtimeActive, setRealtimeActive] = useState(false);
  const [opponentOnline, setOpponentOnline] = useState(false);
  const [liveOpponentAnswered, setLiveOpponentAnswered] = useState<number | null>(null);

  const channelRef = useRef<RealtimeChannel | null>(null);
  // Keep the latest answered count reachable inside the subscribe closure without
  // re-subscribing on every answer.
  const answeredRef = useRef(myAnswered);
  answeredRef.current = myAnswered;

  useEffect(() => {
    if (!enabled || !duelId || !userId) return;

    const channel = supabase.channel(`duel:${duelId}`, {
      config: { presence: { key: userId }, broadcast: { self: false } },
    });
    channelRef.current = channel;

    const readPresence = () => {
      const state = channel.presenceState<ProgressMeta>();
      const others = Object.entries(state)
        .filter(([key]) => key !== userId)
        .flatMap(([, metas]) => metas);
      setOpponentOnline(others.length > 0);
      const counts = others
        .map((m) => m.answered)
        .filter((n): n is number => typeof n === "number");
      if (counts.length > 0) setLiveOpponentAnswered(Math.max(...counts));
    };

    channel
      .on("presence", { event: "sync" }, readPresence)
      .on("presence", { event: "join" }, readPresence)
      .on("presence", { event: "leave" }, readPresence)
      .on("broadcast", { event: "progress" }, ({ payload }) => {
        const answered = Number((payload as ProgressMeta)?.answered);
        if (Number.isFinite(answered)) setLiveOpponentAnswered(answered);
      })
      .subscribe((status) => {
        if (status === "SUBSCRIBED") {
          setRealtimeActive(true);
          void channel.track({ answered: answeredRef.current });
        } else if (status === "CHANNEL_ERROR" || status === "TIMED_OUT" || status === "CLOSED") {
          // R-12: the channel failed — the caller's polling remains the source of truth.
          setRealtimeActive(false);
          logger.warn("duel.realtime_fallback", { duelId, status });
        }
      });

    return () => {
      void supabase.removeChannel(channel);
      channelRef.current = null;
      setRealtimeActive(false);
      setOpponentOnline(false);
    };
    // Re-subscribe only when the duel/user/enabled changes — progress updates
    // flow through the effect below via the ref.
  }, [enabled, duelId, userId]);

  // Publish my progress (presence + broadcast) whenever my answered count moves.
  useEffect(() => {
    const channel = channelRef.current;
    if (!channel || !realtimeActive) return;
    void channel.track({ answered: myAnswered });
    void channel.send({
      type: "broadcast",
      event: "progress",
      payload: { answered: myAnswered },
    });
  }, [myAnswered, realtimeActive]);

  return { realtimeActive, opponentOnline, liveOpponentAnswered };
}
