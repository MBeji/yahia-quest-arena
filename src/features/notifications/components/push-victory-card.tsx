import { Bell, Loader2 } from "lucide-react";
import { toast } from "sonner";
import type { NudgeControls } from "@/components/public/nudge-slot";
import { useT } from "@/lib/i18n";
import { usePush } from "../use-push";

/**
 * LE RAPPEL PROPOSÉ APRÈS UNE VICTOIRE — étude 40, lot 2 (R-5, R-6, US-3).
 *
 * Le seul moment où l'élève dirait oui : il vient de gagner. Jusqu'ici la carte vivait au bas du
 * hall et au paramétrage, et parlait de « série en danger ». Ici elle dit le gain, une fois par
 * jour au plus, et elle part sur un geste :
 *   - « Activer » ⇒ la fenêtre du navigateur ; accordé ⇒ c'est fait, l'invitation ne revient plus ;
 *     refusé ⇒ elle ne revient plus non plus (le navigateur a tranché) ; fenêtre refermée ⇒ un refus ;
 *   - « Plus tard » ⇒ un refus : pas avant sept jours, deux refus ⇒ plus jamais sur cet écran
 *     (la carte reste au paramétrage, R-6).
 */
export function PushVictoryCard({
  push,
  controls,
}: {
  push: ReturnType<typeof usePush>;
  controls: NudgeControls;
}) {
  const t = useT();

  async function activate() {
    try {
      const armed = await push.enable();
      if (armed || Notification.permission === "denied") controls.settle();
      else controls.dismiss();
    } catch {
      toast.error(t.pushNotifications.errorGeneric);
    }
  }

  return (
    <section
      data-testid="push-victory"
      aria-label={t.pushNotifications.cardTitle}
      className="rounded-2xl border border-[color:var(--neon-gold)]/30 bg-card p-4 text-start print:hidden"
    >
      <div className="flex items-start gap-3">
        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-[color:var(--neon-gold)]/10 text-[color:var(--neon-gold)]">
          <Bell className="h-5 w-5" />
        </div>
        <div className="min-w-0 flex-1">
          <p className="text-sm font-bold">{t.pushNotifications.cardTitle}</p>
          <p className="mt-1 text-sm text-muted-foreground">{t.pushNotifications.cardDesc}</p>
          <div className="mt-3 flex flex-wrap items-center gap-2">
            <button
              type="button"
              data-testid="push-victory-enable"
              onClick={() => void activate()}
              disabled={push.busy}
              className="inline-flex min-h-11 items-center gap-1.5 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90 disabled:opacity-50"
            >
              {push.busy ? <Loader2 className="h-4 w-4 animate-spin" /> : null}
              {push.busy ? t.pushNotifications.enabling : t.pushNotifications.enable}
            </button>
            <button
              type="button"
              data-testid="push-victory-later"
              onClick={controls.dismiss}
              disabled={push.busy}
              className="inline-flex min-h-11 items-center rounded-lg px-3 py-2.5 text-sm font-semibold text-muted-foreground transition hover:text-foreground"
            >
              {t.pushNotifications.later}
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
