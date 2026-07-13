import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { motion } from "motion/react";
import { Lock, Loader2, ShieldAlert } from "lucide-react";
import { toast } from "sonner";
import { supabase } from "@/shared/integrations/supabase/client";
import { Label } from "@/components/ui/label";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { useT } from "@/lib/i18n";
import { useEntrance } from "@/shared/lib/motion";

/**
 * Password-reset landing (`/auth/reset`, étude 15 lot 9 — US-8). The emailed
 * `resetPasswordForEmail` link lands here; supabase-js exchanges the recovery token
 * from the URL and fires `PASSWORD_RECOVERY`, establishing a temporary session that
 * authorizes `updateUser`. The user picks a new password → signed in → dashboard.
 * A bad/expired link resolves to an actionable dead-end-free « request a new one »
 * state (R-2). Un-nested from `/auth` (no shared layout) via the `auth_` segment.
 */
export const Route = createFileRoute("/auth_/reset")({
  head: () => ({ meta: [{ title: "Nouveau mot de passe · Na9ra Nal3ab" }] }),
  component: ResetPasswordPage,
});

export function ResetPasswordPage() {
  const navigate = useNavigate();
  const t = useT();
  const entrance = useEntrance("scale");
  const [phase, setPhase] = useState<"checking" | "ready" | "invalid">("checking");
  const [password, setPassword] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    let active = true;
    // Recovery session may arrive via the auth-state event or already be present.
    const { data: sub } = supabase.auth.onAuthStateChange((event, session) => {
      if (active && (event === "PASSWORD_RECOVERY" || session)) setPhase("ready");
    });
    supabase.auth.getSession().then(({ data }) => {
      if (active && data.session) setPhase("ready");
    });
    // Give the URL-token exchange a moment; no session ⇒ the link is invalid/expired.
    const timer = setTimeout(() => {
      if (active) setPhase((p) => (p === "checking" ? "invalid" : p));
    }, 2500);
    return () => {
      active = false;
      sub.subscription.unsubscribe();
      clearTimeout(timer);
    };
  }, []);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    if (password.length < 8) {
      setError(t.auth.passwordTooShort);
      return;
    }
    setBusy(true);
    try {
      const { error: updateError } = await supabase.auth.updateUser({ password });
      if (updateError) throw updateError;
      toast.success(t.auth.resetSuccess);
      navigate({ to: "/dashboard" });
    } catch {
      setError(t.auth.resetError);
      toast.error(t.auth.resetError);
    } finally {
      setBusy(false);
    }
  }

  return (
    <main className="relative min-h-[100dvh] overflow-hidden bg-black-deep">
      <div className="absolute inset-0 bg-grid opacity-50" />
      <div className="relative mx-auto flex min-h-[100dvh] max-w-md flex-col items-center justify-center px-4 py-12 sm:px-6">
        <motion.div {...entrance} className="w-full glass-gold rounded-2xl p-6 shadow-gold sm:p-8">
          <div className="mb-3 flex justify-end">
            <LanguageSwitcher />
          </div>

          {phase === "checking" && (
            <div className="flex items-center justify-center gap-2 py-8 text-sm text-muted-foreground">
              <Loader2 className="h-4 w-4 animate-spin" /> {t.auth.resetChecking}
            </div>
          )}

          {phase === "invalid" && (
            <div className="text-center">
              <div className="mx-auto mb-4 grid h-16 w-16 place-items-center rounded-2xl border border-gold/40 bg-gold/20">
                <ShieldAlert className="h-8 w-8 text-gold" />
              </div>
              <h1 className="font-display text-2xl font-bold">{t.auth.resetInvalidTitle}</h1>
              <p className="mt-3 text-sm text-muted-foreground">{t.auth.resetInvalidBody}</p>
              <Link
                to="/auth"
                search={{ mode: "forgot" }}
                className="mt-6 inline-flex min-h-11 items-center justify-center rounded-lg bg-[image:var(--gradient-gold)] px-6 py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition hover:opacity-90"
              >
                {t.auth.resetRequestNew}
              </Link>
            </div>
          )}

          {phase === "ready" && (
            <>
              <h1 className="font-display text-2xl font-bold">{t.auth.resetTitle}</h1>
              <p className="mt-1 text-sm text-muted-foreground">{t.auth.resetSubtitle}</p>
              <form onSubmit={handleSubmit} className="mt-6 space-y-3">
                <div className="relative">
                  <Label htmlFor="reset-password" className="sr-only">
                    {t.auth.resetPasswordLabel}
                  </Label>
                  <Lock className="absolute start-3 top-3 h-4 w-4 text-muted-foreground" />
                  <input
                    id="reset-password"
                    type="password"
                    required
                    minLength={8}
                    value={password}
                    onChange={(e) => {
                      setPassword(e.target.value);
                      if (error) setError("");
                    }}
                    placeholder={t.auth.resetPasswordLabel}
                    aria-invalid={error ? true : undefined}
                    aria-describedby={error ? "reset-error" : undefined}
                    className="w-full rounded-lg border border-input bg-background/60 py-2.5 ps-10 pe-3 text-sm focus:border-gold focus:outline-none"
                  />
                </div>
                <div role="alert" aria-live="polite">
                  {error && (
                    <p
                      id="reset-error"
                      className="rounded-lg border border-gold/40 bg-gold/10 px-3 py-2 text-xs text-gold"
                    >
                      {error}
                    </p>
                  )}
                </div>
                <button
                  type="submit"
                  disabled={busy}
                  className="flex min-h-11 w-full items-center justify-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition hover:opacity-90 disabled:opacity-60"
                >
                  {busy && <Loader2 className="h-4 w-4 animate-spin" />}
                  {t.auth.resetSubmit}
                </button>
              </form>
            </>
          )}
        </motion.div>
      </div>
    </main>
  );
}
