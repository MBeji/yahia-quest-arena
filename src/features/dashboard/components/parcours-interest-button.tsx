import { Heart, Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";

/**
 * Interest toggle for a coming-soon parcours: "Ça m'intéresse" → "Intéressé·e ✓",
 * with the live public count beside it. Presentational only — the parent owns the
 * state (count/interested/pending) and the toggle handler. Rendered INSIDE a
 * coming-soon card, which is a <div> (not the selectable <button>), so this real
 * <button> never nests inside another button.
 */
export function ParcoursInterestButton({
  count,
  interested,
  isPending,
  onToggle,
}: {
  count: number;
  interested: boolean;
  isPending: boolean;
  onToggle: () => void;
}) {
  const t = useT();
  return (
    <div className="mt-3 flex items-center justify-between gap-2 border-t border-border/40 pt-3">
      <span className="text-xs text-muted-foreground">
        {t.parcoursInterest.count.replace("{count}", String(count))}
      </span>
      <button
        type="button"
        onClick={() => {
          if (!isPending) onToggle();
        }}
        disabled={isPending}
        aria-pressed={interested}
        className={`inline-flex min-h-11 items-center gap-1.5 rounded-full border px-3 py-2.5 text-xs font-bold transition disabled:opacity-60 ${
          interested
            ? "border-[color:var(--gold)]/60 bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
            : "border-[color:var(--gold)]/30 text-muted-foreground hover:border-[color:var(--gold)]/60 hover:text-champagne"
        }`}
      >
        {isPending ? (
          <Loader2 className="h-3.5 w-3.5 animate-spin" />
        ) : (
          <Heart className={`h-3.5 w-3.5 ${interested ? "fill-current" : ""}`} />
        )}
        {interested ? t.parcoursInterest.interested : t.parcoursInterest.cta}
      </button>
    </div>
  );
}
