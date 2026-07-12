import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Flag, Loader2, Check } from "lucide-react";
import { useT } from "@/lib/i18n";
import { reportContentError } from "../content-report.server";

/**
 * "Signaler une erreur" — lets a learner flag a suspected mistake in the current
 * exercise/question. Compact inline expander (no modal dep); shows a thank-you
 * once sent. Crowdsourced QA that feeds the admin review queue.
 */
export function ReportErrorButton({
  exerciseId,
  questionId,
}: {
  exerciseId?: string;
  questionId?: string;
}) {
  const t = useT();
  const report = useServerFn(reportContentError);
  const [open, setOpen] = useState(false);
  const [sent, setSent] = useState(false);
  const [message, setMessage] = useState("");

  const mutation = useMutation({
    mutationFn: () => report({ data: { exerciseId, questionId, message: message.trim() } }),
    onSuccess: () => {
      setSent(true);
      setOpen(false);
      setMessage("");
      toast.success(t.contentReport.sent);
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.contentReport.error),
  });

  if (sent) {
    return (
      <p className="mt-3 inline-flex items-center gap-1.5 text-xs text-success">
        <Check className="h-3.5 w-3.5" /> {t.contentReport.sent}
      </p>
    );
  }

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="mt-3 inline-flex items-center gap-1.5 py-2 text-xs text-muted-foreground transition hover:text-[color:var(--neon-gold)] [@media(pointer:coarse)]:min-h-11"
      >
        <Flag className="h-3.5 w-3.5" /> {t.contentReport.cta}
      </button>
    );
  }

  const canSend = message.trim().length >= 5 && !mutation.isPending;

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        if (canSend) mutation.mutate();
      }}
      className="mt-3 rounded-xl border border-[color:var(--neon-gold)]/30 bg-background/40 p-3 text-start"
    >
      <label className="block text-xs font-semibold text-muted-foreground">
        {t.contentReport.label}
        <textarea
          className="mt-1 w-full rounded-lg border border-[color:var(--neon-gold)]/30 bg-background/50 px-3 py-2 text-sm outline-none focus:border-[color:var(--neon-gold)]/70"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          rows={3}
          maxLength={1000}
          placeholder={t.contentReport.placeholder}
        />
      </label>
      <div className="mt-2 flex items-center gap-2">
        <button
          type="submit"
          disabled={!canSend}
          className="inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-3 py-1.5 text-xs font-bold text-black shadow-gold transition hover:scale-105 disabled:opacity-50 disabled:hover:scale-100 [@media(pointer:coarse)]:min-h-11"
        >
          {mutation.isPending ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : null}
          {t.contentReport.send}
        </button>
        <button
          type="button"
          onClick={() => setOpen(false)}
          className="rounded-lg border border-border/50 px-3 py-1.5 text-xs font-semibold text-muted-foreground hover:text-foreground [@media(pointer:coarse)]:min-h-11"
        >
          {t.contentReport.cancel}
        </button>
      </div>
    </form>
  );
}
