import type { NudgeControls } from "@/components/public/nudge-slot";
import { useParentInvite } from "@/components/public/use-parent-invite";
import { useI18n } from "@/lib/i18n";
import { useInviteT } from "@/lib/i18n/invite";

/**
 * La carte « Inviter mon parent » de l'écran de résultat (étude 40, lot 5 — R-20). Le geste et sa
 * mesure : `use-parent-invite.ts`. Jamais bloquante : deux boutons, aucun délai, aucune rareté.
 */
export function ParentInviteCard({
  allianceCode,
  controls,
}: {
  allianceCode: string;
  controls: NudgeControls;
}) {
  const copy = useInviteT();
  const { dir } = useI18n();
  const invite = useParentInvite(allianceCode, "result");

  async function send() {
    // Feuille de partage fermée : ni envoi ni refus — la carte reste, l'élève peut réessayer.
    if ((await invite()) !== "none") controls.settle();
  }

  return (
    <section
      data-testid="parent-invite"
      // Le sens de l'INTERFACE, pas celui du contenu (même raison que la carte d'installation).
      dir={dir}
      aria-label={copy.cardTitle}
      className="rounded-2xl border border-border bg-card p-4 text-start print:hidden"
    >
      <p className="text-sm font-bold">{copy.cardTitle}</p>
      <p className="mt-1 text-sm text-muted-foreground">{copy.hint}</p>
      <div className="mt-3 flex flex-wrap items-center gap-2">
        <button
          type="button"
          data-testid="parent-invite-cta"
          onClick={() => void send()}
          className="inline-flex min-h-11 items-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
        >
          {copy.button}
        </button>
        <button
          type="button"
          data-testid="parent-invite-later"
          onClick={controls.dismiss}
          className="inline-flex min-h-11 items-center rounded-lg px-3 py-2.5 text-sm font-semibold text-muted-foreground transition hover:text-foreground"
        >
          {copy.later}
        </button>
      </div>
    </section>
  );
}
