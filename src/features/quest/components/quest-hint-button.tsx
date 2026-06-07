import { Lightbulb, Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";
import { RichField } from "@/components/ui/svg-figure";

type QuestHintButtonProps = {
  /** Remaining reveal charges the user owns across all hint consumables. */
  remaining: number;
  /** Hint already revealed for this question this session (null = not revealed). */
  revealed: string | null | undefined;
  /** True once a hint has been revealed for this question, even with no text. */
  isRevealed: boolean;
  isPending: boolean;
  onReveal: () => void;
};

/**
 * Per-question "Indice" button for the quest screen. Hint consumables
 * (booster_hint / potion_rappel) are spent on demand: clicking decrements one
 * charge server-side (consume_hint RPC) and reveals the question's explanation.
 * The button is hidden when no charges remain and a hint isn't already revealed;
 * once revealed, the hint shows inline and re-spending is blocked.
 */
export function QuestHintButton({
  remaining,
  revealed,
  isRevealed,
  isPending,
  onReveal,
}: QuestHintButtonProps) {
  const t = useT();

  if (isRevealed) {
    return (
      <div className="mt-4 rounded-xl border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 p-4 text-sm text-[color:var(--neon-gold)]">
        <div className="mb-1 flex items-center gap-1.5 text-xs font-bold uppercase tracking-widest">
          <Lightbulb className="h-3.5 w-3.5" /> {t.quest.hintRevealed}
        </div>
        {revealed ? <RichField raw={revealed} as="p" /> : <p>{t.quest.hintUnavailable}</p>}
      </div>
    );
  }

  // No reveal yet and no charges left → nothing to show.
  if (remaining <= 0) return null;

  return (
    <div className="mt-4 flex justify-start">
      <button
        type="button"
        disabled={isPending}
        onClick={onReveal}
        className="inline-flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/10 px-4 py-2 text-xs font-bold text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20 disabled:opacity-40"
      >
        {isPending ? (
          <Loader2 className="h-3.5 w-3.5 animate-spin" />
        ) : (
          <Lightbulb className="h-3.5 w-3.5" />
        )}
        {t.quest.revealHint.replace("{count}", String(remaining))}
      </button>
    </div>
  );
}
