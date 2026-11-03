import { Link } from "@tanstack/react-router";
import { Loader2, Mail } from "lucide-react";
import type { FormEvent } from "react";
import { Label } from "@/components/ui/label";
import { useT } from "@/lib/i18n";

// Le formulaire « mot de passe oublié » de `routes/auth.tsx`, sorti de la route (2026-11-03) : une
// adresse, un bouton, un retour. L'état et l'envoi restent dans la page. Texte déplacé à l'identique.
export function ForgotPasswordForm({
  email,
  onEmailChange,
  formError,
  busy,
  onSubmit,
}: {
  email: string;
  onEmailChange: (value: string) => void;
  formError: string;
  busy: boolean;
  onSubmit: (e: FormEvent) => void;
}) {
  const t = useT();
  return (
    <form onSubmit={onSubmit} className="mt-6 space-y-3">
      <div className="relative">
        <Label htmlFor="auth-email" className="sr-only">
          {t.auth.emailLabel}
        </Label>
        <Mail className="absolute start-3 top-3 h-4 w-4 text-muted-foreground" />
        <input
          id="auth-email"
          type="email"
          required
          value={email}
          onChange={(e) => onEmailChange(e.target.value)}
          placeholder={t.auth.emailLabel}
          className="w-full rounded-lg border border-input bg-background/60 py-2.5 ps-10 pe-3 text-sm focus:border-gold focus:outline-none"
        />
      </div>
      <div role="alert" aria-live="polite">
        {formError && (
          <p className="rounded-lg border border-gold/40 bg-gold/10 px-3 py-2 text-xs text-gold">
            {formError}
          </p>
        )}
      </div>
      <button
        type="submit"
        disabled={busy}
        className="flex min-h-11 w-full items-center justify-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition hover:opacity-90 disabled:opacity-60"
      >
        {busy && <Loader2 className="h-4 w-4 animate-spin" />}
        {t.auth.forgotSubmit}
      </button>
      <Link
        to="/auth"
        search={{ mode: "login" }}
        className="block py-2 text-center text-xs font-medium text-muted-foreground transition hover:text-foreground"
      >
        {t.auth.forgotBack}
      </Link>
    </form>
  );
}
