import { useEffect, useRef, useState } from "react";
import { Timer } from "lucide-react";
import { BOSS_TIME_PER_QUESTION_S } from "@/shared/constants/gamification";

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
