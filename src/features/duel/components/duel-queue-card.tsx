import type { TranslationKeys } from "@/lib/i18n/types";

type DuelLabels = TranslationKeys["duel"];

/**
 * US-1: join the matchmaking queue, or show a cancellable "searching…" state.
 * Pure presentational card — the route owns the queue mutation + polling.
 */
export function DuelQueueCard({
  searching,
  disabled,
  onFind,
  onCancel,
  labels,
}: {
  searching: boolean;
  disabled?: boolean;
  onFind: () => void;
  onCancel: () => void;
  labels: DuelLabels;
}) {
  return (
    <div className="rounded-xl border border-border bg-card p-6 text-center">
      <p className="mb-4 text-sm text-muted-foreground">{labels.subtitle}</p>
      {searching ? (
        <div className="space-y-3">
          <p className="animate-pulse font-medium" role="status">
            {labels.searching}
          </p>
          <p className="text-xs text-muted-foreground">{labels.emptyHubHint}</p>
          <button
            type="button"
            onClick={onCancel}
            disabled={disabled}
            className="rounded-lg border border-border px-4 py-2 text-sm hover:bg-muted disabled:opacity-50"
          >
            {labels.cancel}
          </button>
        </div>
      ) : (
        <button
          type="button"
          onClick={onFind}
          disabled={disabled}
          className="rounded-lg bg-primary px-6 py-3 font-semibold text-primary-foreground hover:opacity-90 disabled:opacity-50"
        >
          {labels.findOpponent}
        </button>
      )}
    </div>
  );
}
