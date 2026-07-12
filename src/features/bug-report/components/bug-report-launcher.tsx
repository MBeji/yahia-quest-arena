import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Bug, Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { reportBug } from "../bug-report.server";

/**
 * Floating "Signaler un bug" launcher, mounted globally during the beta phase.
 * Opens a small dialog with a free-text field; the current route is attached
 * automatically so admins know where the problem happened. Sits above the
 * mobile bottom tab bar and flips side in RTL.
 */
export function BugReportLauncher() {
  const t = useT();
  const send = useServerFn(reportBug);
  const [open, setOpen] = useState(false);
  const [message, setMessage] = useState("");

  const mutation = useMutation({
    mutationFn: () =>
      send({
        data: {
          message: message.trim(),
          page: typeof window !== "undefined" ? window.location.pathname : undefined,
        },
      }),
    onSuccess: () => {
      toast.success(t.bugReport.sent);
      setOpen(false);
      setMessage("");
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.bugReport.error),
  });

  const canSend = message.trim().length >= 5 && !mutation.isPending;

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label={t.bugReport.launcherLabel}
        title={t.bugReport.launcherLabel}
        className="fixed bottom-[calc(5rem+env(safe-area-inset-bottom))] end-4 z-40 inline-flex items-center gap-2 rounded-full border border-[color:var(--gold)]/40 bg-black/70 px-4 py-2.5 text-sm font-semibold text-champagne shadow-gold backdrop-blur-md transition hover:scale-105 hover:text-[color:var(--gold)] lg:bottom-[calc(1.25rem+env(safe-area-inset-bottom))]"
      >
        <Bug className="h-4 w-4 shrink-0" aria-hidden="true" />
        <span className="hidden sm:inline">{t.bugReport.launcherLabel}</span>
      </button>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Bug className="h-5 w-5 text-[color:var(--gold)]" aria-hidden="true" />
              {t.bugReport.title}
            </DialogTitle>
            <DialogDescription>{t.bugReport.desc}</DialogDescription>
          </DialogHeader>
          <form
            onSubmit={(e) => {
              e.preventDefault();
              if (canSend) mutation.mutate();
            }}
          >
            <label className="block text-xs font-semibold text-muted-foreground">
              {t.bugReport.label}
              <textarea
                className="mt-1 w-full rounded-lg border border-[color:var(--gold)]/30 bg-background/50 px-3 py-2 text-sm text-foreground outline-none focus:border-[color:var(--gold)]/70"
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                rows={4}
                maxLength={2000}
                placeholder={t.bugReport.placeholder}
                autoFocus
              />
            </label>
            <div className="mt-4 flex items-center justify-end gap-2">
              <button
                type="button"
                onClick={() => setOpen(false)}
                className="rounded-lg border border-border/50 px-3 py-1.5 text-sm font-semibold text-muted-foreground transition hover:text-foreground"
              >
                {t.bugReport.cancel}
              </button>
              <button
                type="submit"
                disabled={!canSend}
                className="inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-1.5 text-sm font-bold text-black shadow-gold transition hover:scale-105 disabled:opacity-50 disabled:hover:scale-100"
              >
                {mutation.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : null}
                {t.bugReport.send}
              </button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </>
  );
}
