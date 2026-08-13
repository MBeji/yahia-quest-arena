import { useEffect, useRef, useState } from "react";
import { motion } from "motion/react";
import { Skull, Heart } from "lucide-react";
import { Timer } from "lucide-react";
import { BOSS_TIME_PER_QUESTION_S } from "@/shared/constants/gamification";
import { useSound } from "@/lib/sound";

/** Play a tick from this many seconds down to 1 — the tense final stretch. */
const TICK_FROM_SECONDS = 5;

/**
 * Boss-mode per-question countdown. Owns its own 1 Hz state so the ticking
 * re-renders only this chip, not the (large) QuestPage tree. Resets whenever the
 * question changes; fires `onTimeout` at zero (the parent auto-submits). The
 * callback is read through a ref so its identity can change every render without
 * restarting the interval.
 */
export function BossCountdown({
  active,
  questionIndex,
  onTimeout,
}: {
  active: boolean;
  questionIndex: number;
  onTimeout: () => void;
}) {
  const [seconds, setSeconds] = useState(BOSS_TIME_PER_QUESTION_S);
  const onTimeoutRef = useRef(onTimeout);
  onTimeoutRef.current = onTimeout;
  const { play } = useSound();

  // Tense tick over the final seconds (no-op when sound is muted).
  useEffect(() => {
    if (active && seconds > 0 && seconds <= TICK_FROM_SECONDS) play("tick");
  }, [active, seconds, play]);

  useEffect(() => {
    if (!active) return;
    setSeconds(BOSS_TIME_PER_QUESTION_S);
    const id = setInterval(() => {
      setSeconds((s) => {
        if (s <= 1) {
          onTimeoutRef.current();
          return BOSS_TIME_PER_QUESTION_S;
        }
        return s - 1;
      });
    }, 1000);
    return () => clearInterval(id);
  }, [active, questionIndex]);

  return (
    <div className="flex items-center gap-2 rounded-full bg-black/60 px-3 py-1.5 text-sm font-bold">
      <Timer className="h-4 w-4 text-destructive" />
      <span
        className={seconds <= 5 ? "text-destructive animate-pulse" : "text-[color:var(--gold)]"}
      >
        {seconds}s
      </span>
    </div>
  );
}

/**
 * Boss chrome: the skull header, the HP bar and the countdown, as one block.
 * Lives beside the countdown it hosts — extracted from the play loop to keep
 * that file under the max-lines cap, exactly as <QuestResultScreen> was.
 */
export function BossBanner({
  title,
  hp,
  questionIndex,
  countdownActive,
  onTimeout,
  entrance,
  reduced,
  labels,
}: {
  title: string;
  hp: number;
  questionIndex: number;
  countdownActive: boolean;
  onTimeout: () => void;
  entrance: Record<string, unknown>;
  reduced: boolean;
  labels: { fight: string; hp: string };
}) {
  return (
    <motion.div
      {...entrance}
      className="mb-6 rounded-2xl border border-destructive/40 bg-destructive/10 p-4 backdrop-blur-md"
    >
      <div className="flex items-center justify-between gap-3">
        <div className="flex min-w-0 items-center gap-3">
          <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-linear-to-br from-destructive to-gold shadow-lg animate-pulse">
            <Skull className="h-5 w-5 text-primary-foreground" />
          </div>
          <div className="min-w-0">
            <div className="text-xs uppercase tracking-[0.3em] text-destructive font-bold">
              {labels.fight}
            </div>
            <div className="truncate font-display text-lg font-bold">{title}</div>
          </div>
        </div>
        <BossCountdown
          active={countdownActive}
          questionIndex={questionIndex}
          onTimeout={onTimeout}
        />
      </div>
      <div className="mt-4">
        <div className="mb-1 flex items-center justify-between text-xs">
          <span className="flex items-center gap-1 font-bold text-destructive">
            <Heart className="h-3 w-3" /> {labels.hp}
          </span>
          <span className="text-muted-foreground">{hp}%</span>
        </div>
        <div className="h-3 overflow-hidden rounded-full bg-secondary/80">
          <motion.div
            className="h-full rounded-full bg-linear-to-r from-destructive to-gold"
            initial={reduced ? false : { width: "100%" }}
            animate={{ width: `${hp}%` }}
            transition={{ duration: reduced ? 0 : 0.5 }}
          />
        </div>
      </div>
    </motion.div>
  );
}
