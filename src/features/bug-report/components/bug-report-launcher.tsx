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
 * "Signaler un bug", mounted globally during the beta phase: a small dialog with a
 * free-text field; the current route is attached automatically so admins know where
 * the problem happened.
 *
 * Deux portes, une seule fenêtre (2026-11-14). L'état d'ouverture appartient à la
 * coquille, parce que la porte dépend de l'écran :
 *   - dès `lg`, la pastille flottante (`floating`), en bas de l'écran côté fin ;
 *   - sous `lg`, une ligne du menu des réglages (`SettingsMenu`, `onReportBug`).
 *     La pastille y recouvrait le contenu : deux boutons flottants empilés (elle et
 *     la bulle du Prof) au-dessus de la barre d'onglets, par-dessus les cartes.
 * `floating` à `false` sur un écran immersif (quête, cours, examen) : aucune pastille,
 * à aucune largeur — la ligne du menu, elle, reste, et c'est là qu'un bug se signale.
 */
export function BugReportLauncher({
  open,
  onOpenChange: setOpen,
  floating = true,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  floating?: boolean;
}) {
  const t = useT();
  const send = useServerFn(reportBug);
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
      {floating && (
        <button
          type="button"
          onClick={() => setOpen(true)}
          data-testid="bug-report-floating"
          className="fixed end-4 bottom-[calc(1.25rem+env(safe-area-inset-bottom))] z-40 hidden items-center gap-2 rounded-full border border-[color:var(--gold)]/40 bg-surface-3 px-4 py-2.5 text-sm font-semibold text-champagne shadow-gold backdrop-blur-md transition hover:scale-105 hover:text-[color:var(--gold)] lg:inline-flex print:hidden"
        >
          <Bug className="h-4 w-4 shrink-0" aria-hidden="true" />
          {t.bugReport.launcherLabel}
        </button>
      )}

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
                className="inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-1.5 text-sm font-bold text-primary-foreground shadow-gold transition hover:scale-105 disabled:opacity-50 disabled:hover:scale-100 [@media(pointer:coarse)]:min-h-11"
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
