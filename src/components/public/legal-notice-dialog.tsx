import { useT } from "@/lib/i18n";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

/**
 * « Mentions légales & propriété intellectuelle » en modale déclenchée depuis le
 * footer. Modale (et non route dédiée) à dessein : ajouter une route exigerait de
 * régénérer le route-tree TanStack — ceci livre la notice IP/légale tout de suite
 * et pourra être promu en page `/mentions-legales` plus tard. Copie i18n (fr/en/ar).
 */
export function LegalNoticeDialog() {
  const t = useT();
  const l = t.public.legal;
  return (
    <Dialog>
      <DialogTrigger className="cursor-pointer underline underline-offset-2 transition hover:text-foreground">
        {t.public.footer.legalLink}
      </DialogTrigger>
      <DialogContent className="max-h-[85vh] overflow-y-auto text-start">
        <DialogHeader>
          <DialogTitle>{l.title}</DialogTitle>
          <DialogDescription>{l.intro}</DialogDescription>
        </DialogHeader>
        <div className="space-y-4 text-sm text-muted-foreground">
          <section>
            <h3 className="font-semibold text-foreground">{l.ipTitle}</h3>
            <p className="mt-1">{l.ipBody}</p>
          </section>
          <section>
            <h3 className="font-semibold text-foreground">{l.useTitle}</h3>
            <p className="mt-1">{l.useBody}</p>
          </section>
          <section>
            <h3 className="font-semibold text-foreground">{l.brandTitle}</h3>
            <p className="mt-1">{l.brandBody}</p>
          </section>
          <section>
            <h3 className="font-semibold text-foreground">{l.contactTitle}</h3>
            <p className="mt-1">{l.contactBody}</p>
          </section>
          <section>
            <h3 className="font-semibold text-foreground">{l.lawTitle}</h3>
            <p className="mt-1">{l.lawBody}</p>
          </section>
          <p className="pt-2 text-xs">{l.updated}</p>
        </div>
      </DialogContent>
    </Dialog>
  );
}
