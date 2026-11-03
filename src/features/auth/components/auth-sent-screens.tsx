import { motion } from "motion/react";
import { Link } from "@tanstack/react-router";
import { Loader2, MailCheck } from "lucide-react";
import type { ReactNode } from "react";
import { useT } from "@/lib/i18n";
import { useEntrance } from "@/shared/lib/motion";

// Les deux écrans qui remplacent le formulaire de `routes/auth.tsx` une fois le courriel parti —
// confirmation d'inscription, réinitialisation du mot de passe. Sortis de la route (2026-11-03), qui
// était à 728 lignes de code pour un plafond de 750 : de la présentation pure, dont l'état reste
// dans la page. Le texte est déplacé à l'identique.

/** La coquille commune : fond, carte centrée, pastille « courrier envoyé ». */
function SentShell({ children }: { children: ReactNode }) {
  const entrance = useEntrance("scale");
  return (
    <main className="relative min-h-[100dvh] overflow-hidden bg-black-deep">
      <div className="absolute inset-0 bg-grid opacity-50" />
      <div className="relative mx-auto flex min-h-[100dvh] max-w-md flex-col items-center justify-center px-6 py-12">
        <motion.div
          {...entrance}
          className="w-full glass-gold rounded-2xl p-8 shadow-gold text-center"
        >
          <div className="mx-auto mb-4 grid h-16 w-16 place-items-center rounded-2xl bg-gold/20 border border-gold/40">
            <MailCheck className="h-8 w-8 text-gold" />
          </div>
          {children}
        </motion.div>
      </div>
    </main>
  );
}

/** « Mot de passe oublié » : le lien est parti (sans révéler si l'adresse a un compte). */
export function ForgotSentScreen({ sentTo }: { sentTo: string }) {
  const t = useT();
  return (
    <SentShell>
      <h1 className="font-display text-2xl font-bold">{t.auth.forgotSentTitle}</h1>
      <p className="mt-3 text-sm text-muted-foreground">
        {t.auth.forgotSentBody.replace("{email}", sentTo)}
      </p>
      <div className="mt-6 rounded-xl border border-gold/30 bg-gold/5 p-4 text-xs text-muted-foreground">
        {t.auth.forgotSentSpam}
      </div>
      <Link
        to="/auth"
        search={{ mode: "login" }}
        className="mt-6 inline-flex min-h-11 items-center text-xs text-gold hover:underline"
      >
        {t.auth.forgotBack}
      </Link>
    </SentShell>
  );
}

/** Inscription : le lien de confirmation est parti — et le renvoyer, ou corriger l'adresse. */
export function EmailSentScreen({
  sentTo,
  formError,
  resendBusy,
  resendCooldown,
  resendNote,
  onResend,
  onEdit,
}: {
  sentTo: string;
  formError: string;
  resendBusy: boolean;
  resendCooldown: number;
  resendNote: string;
  onResend: () => void;
  onEdit: () => void;
}) {
  const t = useT();
  return (
    <SentShell>
      <h1 className="font-display text-2xl font-bold">{t.auth.emailSentTitle}</h1>
      <p className="mt-3 text-sm text-muted-foreground">
        {t.auth.emailSentBody1} <span className="font-semibold text-foreground">{sentTo}</span>.
        <br />
        {t.auth.emailSentBody2}
      </p>
      <div className="mt-6 rounded-xl border border-gold/30 bg-gold/5 p-4 text-xs text-muted-foreground">
        {t.auth.emailSentSpam}
      </div>
      <button
        type="button"
        disabled={resendBusy || resendCooldown > 0}
        onClick={() => onResend()}
        className="mt-5 flex min-h-11 w-full items-center justify-center gap-2 rounded-lg border border-gold/40 bg-gold/10 py-2.5 text-sm font-bold text-gold transition hover:bg-gold/20 disabled:opacity-60"
      >
        {resendBusy && <Loader2 className="h-4 w-4 animate-spin" />}
        {resendCooldown > 0
          ? t.auth.emailSentResendWait.replace("{s}", String(resendCooldown))
          : t.auth.emailSentResend}
      </button>
      <div role="status" aria-live="polite">
        {resendNote && <p className="mt-3 text-xs text-gold">{resendNote}</p>}
      </div>
      <div role="alert" aria-live="polite">
        {formError && (
          <p className="mt-3 rounded-lg border border-gold/40 bg-gold/10 px-3 py-2 text-xs text-gold">
            {formError}
          </p>
        )}
      </div>
      <button
        type="button"
        onClick={onEdit}
        className="mt-4 inline-flex min-h-11 items-center text-xs text-gold hover:underline"
      >
        {t.auth.emailSentEdit}
      </button>
    </SentShell>
  );
}
