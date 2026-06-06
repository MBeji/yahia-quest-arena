import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";

const SECONDARY =
  "rounded-lg border border-border bg-background/50 px-5 py-2.5 text-sm font-semibold hover:bg-background/80";
const PRIMARY =
  "rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-black shadow-gold hover:scale-105";

/** Action buttons shown on the quest results screen. */
export function QuestResultActions({
  subjectId,
  nextExerciseId,
  onReplay,
}: {
  subjectId: string | null;
  nextExerciseId: string | null;
  onReplay: () => void;
}) {
  const t = useT();
  return (
    <div className="mt-8 flex flex-wrap justify-center gap-3">
      <Link to="/dashboard" className={SECONDARY}>
        {t.common.backToHall}
      </Link>
      {subjectId && (
        <Link to="/subject/$subjectId" params={{ subjectId }} className={SECONDARY}>
          {t.quest.backToSubject}
        </Link>
      )}
      <button onClick={onReplay} className={SECONDARY}>
        {t.quest.replayQuest}
      </button>
      {nextExerciseId && (
        <Link to="/quest/$exerciseId" params={{ exerciseId: nextExerciseId }} className={PRIMARY}>
          {t.quest.nextQuest} →
        </Link>
      )}
    </div>
  );
}
