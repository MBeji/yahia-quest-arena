import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { motion } from "motion/react";
import { Sparkles, Mail, Lock, User as UserIcon, Loader2, MailCheck } from "lucide-react";
import { toast } from "sonner";
import { supabase } from "@/shared/integrations/supabase/client";
import { useServerFn } from "@tanstack/react-start";
import { linkStudentByCode } from "@/features/parent-report";
import { bootstrapProfile } from "@/features/auth";
import { Label } from "@/components/ui/label";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { useT } from "@/lib/i18n";
import { useEntrance } from "@/shared/lib/motion";
import type { TranslationKeys } from "@/lib/i18n/types";

/** `AuthError.code` when supabase-js exposes one (it is absent on plain Errors). */
function authCode(err: unknown): string {
  const code = (err as { code?: unknown } | null)?.code;
  return typeof code === "string" ? code : "";
}

/** GoTrue refuses an unconfirmed sign-in with « Email not confirmed ». */
export function isEmailNotConfirmed(err: unknown): boolean {
  const msg = err instanceof Error ? err.message.toLowerCase() : "";
  return msg.includes("email not confirmed") || authCode(err) === "email_not_confirmed";
}

/** Map a raw Supabase auth error to a localized, user-actionable message. */
export function friendlyAuthError(t: TranslationKeys, err: unknown): string {
  const msg = err instanceof Error ? err.message.toLowerCase() : "";
  const code = authCode(err);
  if (msg.includes("invalid login")) return t.auth.errorInvalidLogin;
  if (isEmailNotConfirmed(err)) return t.auth.errorEmailNotConfirmed;
  if (msg.includes("user already registered") || code === "user_already_exists")
    return t.auth.errorAccountExists;
  // A mailer failure is not a credentials problem: the account exists, only the mail
  // never left. Answering « authentication error » sends the user back to a form that
  // will then tell them the account already exists — the dead end this branch closes.
  if (msg.includes("error sending")) return t.auth.errorMailerDown;
  // GoTrue's per-address cooldown reads « For security purposes, you can only request
  // this after N seconds » — neither « rate limit » nor « too many » appears in it.
  if (
    msg.includes("rate limit") ||
    msg.includes("too many") ||
    msg.includes("for security purposes") ||
    code === "over_email_send_rate_limit"
  )
    return t.auth.errorRateLimit;
  if (msg.includes("password")) return t.auth.passwordTooShort;
  if (msg.includes("signup_disabled") || code === "signup_disabled")
    return t.auth.errorSignupDisabled;
  return t.auth.errorGeneric;
}

/** Seconds GoTrue asks us to wait, parsed from its cooldown message. */
function cooldownFromError(err: unknown): number {
  const m = err instanceof Error ? /after (\d+) seconds?/i.exec(err.message) : null;
  return m ? Number(m[1]) : 0;
}

export const Route = createFileRoute("/auth")({
  head: () => ({
    meta: [
      { title: "Rejoindre l'Académie · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Crée ton compte gratuit : cours, résumés et exercices de toute l'école tunisienne — apprends en jouant.",
      },
    ],
  }),
  // `role` optionnel — tunnel parent depuis la landing « Espace Famille ».
  validateSearch: (s: Record<string, unknown>): { mode: string; role?: "parent" } => ({
    mode: (s.mode as string) || "login",
    ...(s.role === "parent" ? { role: "parent" as const } : {}),
  }),
  component: AuthPage,
});

function AuthPage() {
  const { mode, role: roleParam } = Route.useSearch();
  const navigate = useNavigate();
  const t = useT();
  const isSignup = mode === "signup";
  const isForgot = mode === "forgot";
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [role, setRole] = useState<"student" | "parent">(roleParam ?? "student");
  const [allianceCode, setAllianceCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [emailSent, setEmailSent] = useState(false);
  const [forgotSent, setForgotSent] = useState(false);
  const [sentTo, setSentTo] = useState("");
  // Confirmation resend: the interstitial used to be a one-way door — a mail lost in
  // spam or refused by the mailer left no way to ask for another one.
  const [resendBusy, setResendBusy] = useState(false);
  const [resendCooldown, setResendCooldown] = useState(0);
  const [resendNote, setResendNote] = useState("");
  // Set when a sign-in fails on an unconfirmed address, to offer the same resend there.
  const [unconfirmedEmail, setUnconfirmedEmail] = useState("");
  // Inline, screen-reader-announced form error (see #23). `passwordError` is the
  // specific min-length validation surfaced on the password field.
  const [formError, setFormError] = useState("");
  const [passwordError, setPasswordError] = useState("");
  const entrance = useEntrance("scale");
  const linkByCode = useServerFn(linkStudentByCode);
  const runBootstrapProfile = useServerFn(bootstrapProfile);

  useEffect(() => {
    // 1) Surface OAuth/callback errors that Supabase appends to the URL (query or
    // hash). Without this the user silently bounces back to the login form.
    const params = new URLSearchParams(window.location.search);
    const hash = new URLSearchParams(window.location.hash.replace(/^#/, ""));
    const oauthError =
      params.get("error_description") ||
      params.get("error") ||
      hash.get("error_description") ||
      hash.get("error");
    if (oauthError) {
      const raw = decodeURIComponent(oauthError);
      const friendly = friendlyAuthError(t, new Error(raw));
      // For OAuth, show the raw provider/Supabase message when it isn't a known
      // case — it's far more actionable than a generic fallback for debugging.
      const shown =
        friendly === t.auth.errorGeneric ? t.auth.oauthErrorPrefix.replace("{msg}", raw) : friendly;
      setFormError(shown);
      toast.error(shown);
      window.history.replaceState({}, "", "/auth");
    }

    // 2) Redirect away if already signed in. Covers the OAuth callback too:
    // Supabase exchanges /auth?code=... for a session ASYNCHRONOUSLY, so we also
    // subscribe to auth-state changes and navigate on SIGNED_IN.
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) navigate({ to: "/dashboard" });
    });
    const { data: authSub } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session) navigate({ to: "/dashboard" });
    });

    // 3) Fallback: arrived from the OAuth callback (?code=) but no session
    // materialised → tell the user instead of silently bouncing.
    let timer: ReturnType<typeof setTimeout> | undefined;
    if (params.has("code") && !oauthError) {
      timer = setTimeout(() => {
        supabase.auth.getSession().then(({ data }) => {
          if (!data.session) {
            const m = t.auth.googleCallbackIncomplete;
            setFormError(m);
            toast.error(m);
          }
        });
      }, 2500);
    }

    return () => {
      authSub.subscription.unsubscribe();
      if (timer) clearTimeout(timer);
    };
  }, [navigate, t]);

  // Cooldown ticker — mirrors GoTrue's own per-address throttle so the button says
  // when it will work again instead of failing on every click.
  useEffect(() => {
    if (resendCooldown <= 0) return;
    const id = setTimeout(() => setResendCooldown((s) => s - 1), 1000);
    return () => clearTimeout(id);
  }, [resendCooldown]);

  /** Ask Supabase for a fresh confirmation link, from the interstitial or the login form. */
  async function resendConfirmation(target: string) {
    setResendNote("");
    setFormError("");
    setResendBusy(true);
    try {
      const { error } = await supabase.auth.resend({
        type: "signup",
        email: target,
        options: { emailRedirectTo: `${window.location.origin}/dashboard` },
      });
      if (error) throw error;
      setSentTo(target);
      setEmailSent(true);
      setResendNote(t.auth.emailSentResendDone);
      setResendCooldown(60);
    } catch (err) {
      const message = friendlyAuthError(t, err);
      setFormError(message);
      toast.error(message);
      setResendCooldown(cooldownFromError(err));
    } finally {
      setResendBusy(false);
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setFormError("");
    setResendNote("");
    setUnconfirmedEmail("");
    if (password.length < 8) {
      const msg = t.auth.passwordTooShort;
      setPasswordError(msg);
      setFormError(msg);
      toast.error(msg);
      return;
    }
    setPasswordError("");
    setBusy(true);
    try {
      if (isSignup) {
        const displayName = name || email.split("@")[0];
        const { data, error } = await supabase.auth.signUp({
          email,
          password,
          options: {
            emailRedirectTo: `${window.location.origin}/dashboard`,
            // `role` lets `handle_new_user` persist the parent/student choice even on
            // the email-confirmation path where `bootstrapProfile` never runs (lot 10).
            data: { display_name: displayName, role },
          },
        });
        if (error) throw error;

        // Email-enumeration protection: on an address that already has an account,
        // GoTrue answers 200 with an OBFUSCATED user — fresh random id, empty role,
        // a `confirmation_sent_at` stamped now — and sends NOTHING. The only honest
        // tell is an EMPTY `identities` array (verified against prod, 2026-08-16).
        // Without this branch the interstitial promises a mail that never comes and
        // the address is stuck: signing up again repeats the lie, signing in answers
        // « confirm your account first ». `undefined` identities ≠ empty: only an
        // actual empty array means « nothing was created here ».
        const identities = data.user?.identities;
        if (!data.session && Array.isArray(identities) && identities.length === 0) {
          const message = t.auth.errorAccountExistsSignup;
          setFormError(message);
          toast.error(message);
          return;
        }

        // Profile bootstrap (display name + role) is extracted to the
        // `bootstrapProfile` server fn (review #19). It is authenticated, so it can
        // only run once a session exists (signup auto-login). When email
        // confirmation is required there is no session yet — the `handle_new_user`
        // trigger + signUp metadata already seed the profile, so we skip it.
        if (data.user && data.session) {
          await runBootstrapProfile({ data: { displayName, role } });

          if (role === "parent" && allianceCode.trim().length > 0) {
            const linkRes = await linkByCode({
              data: { studentCode: allianceCode.trim(), relationLabel: "parent" },
            });
            if (linkRes.linked) {
              toast.success(
                t.auth.toastLinked.replace("{name}", linkRes.student.displayName ?? "élève"),
              );
            }
          }
        }

        // If session is null, Supabase requires email confirmation before login
        if (!data.session) {
          setSentTo(email);
          setEmailSent(true);
          return;
        }
        toast.success(t.auth.toastSignupSuccess);
        navigate({ to: "/dashboard" });
      } else {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        toast.success(t.auth.toastLoginSuccess);
        navigate({ to: "/dashboard" });
      }
    } catch (err) {
      const message = friendlyAuthError(t, err);
      setFormError(message);
      toast.error(message);
      // « Confirm your account first » was a dead end for anyone whose mail was lost:
      // offer the resend right where they are told to check their inbox.
      if (isEmailNotConfirmed(err)) setUnconfirmedEmail(email);
    } finally {
      setBusy(false);
    }
  }

  async function handleGoogle() {
    setFormError("");
    setBusy(true);
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: `${window.location.origin}/auth`,
        queryParams: {
          prompt: "select_account",
        },
      },
    });

    if (error) {
      const message = error.message.toLowerCase();
      const friendly =
        message.includes("provider") || message.includes("oauth")
          ? t.auth.googleNotConfigured
          : t.auth.googleFailed.replace("{message}", error.message);
      setFormError(friendly);
      toast.error(friendly);
      setBusy(false);
      return;
    }
    // Supabase redirects the browser to Google; no local navigation needed here.
  }

  async function handleForgot(e: React.FormEvent) {
    e.preventDefault();
    setFormError("");
    setBusy(true);
    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/auth/reset`,
      });
      if (error) throw error;
      // Confirmation never reveals whether the address has an account (privacy).
      setSentTo(email);
      setForgotSent(true);
    } catch (err) {
      const message = friendlyAuthError(t, err);
      setFormError(message);
      toast.error(message);
    } finally {
      setBusy(false);
    }
  }

  if (forgotSent) {
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
          </motion.div>
        </div>
      </main>
    );
  }

  if (emailSent) {
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
            <h1 className="font-display text-2xl font-bold">{t.auth.emailSentTitle}</h1>
            <p className="mt-3 text-sm text-muted-foreground">
              {t.auth.emailSentBody1}{" "}
              <span className="font-semibold text-foreground">{sentTo}</span>.<br />
              {t.auth.emailSentBody2}
            </p>
            <div className="mt-6 rounded-xl border border-gold/30 bg-gold/5 p-4 text-xs text-muted-foreground">
              {t.auth.emailSentSpam}
            </div>
            <button
              type="button"
              disabled={resendBusy || resendCooldown > 0}
              onClick={() => void resendConfirmation(sentTo)}
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
              onClick={() => {
                setEmailSent(false);
                setSentTo("");
                setResendNote("");
                setFormError("");
              }}
              className="mt-4 inline-flex min-h-11 items-center text-xs text-gold hover:underline"
            >
              {t.auth.emailSentEdit}
            </button>
          </motion.div>
        </div>
      </main>
    );
  }

  return (
    <main className="relative min-h-[100dvh] overflow-hidden bg-black-deep">
      <div className="absolute inset-0 bg-grid opacity-50" />
      <div className="relative mx-auto flex min-h-[100dvh] max-w-md flex-col items-center justify-center px-4 pt-[max(3rem,env(safe-area-inset-top))] pb-[max(3rem,env(safe-area-inset-bottom))] sm:px-6">
        <Link to="/" className="mb-8 flex items-center gap-2">
          <div className="grid h-10 w-10 place-items-center rounded-lg bg-[image:var(--gradient-gold)] shadow-gold">
            <Sparkles className="h-5 w-5 text-primary-foreground" />
          </div>
          <span className="font-display text-xl font-bold tracking-wider">
            Na9ra <span className="text-gradient-gold">Nal3ab</span>
          </span>
        </Link>

        <motion.div {...entrance} className="w-full glass-gold rounded-2xl p-6 shadow-gold sm:p-8">
          <div className="mb-3 flex justify-end">
            <LanguageSwitcher />
          </div>
          <h1 className="font-display text-2xl font-bold">
            {isForgot ? t.auth.forgotTitle : isSignup ? t.auth.titleSignup : t.auth.titleLogin}
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            {isForgot
              ? t.auth.forgotSubtitle
              : isSignup
                ? t.auth.subtitleSignup
                : t.auth.subtitleLogin}
          </p>

          {isForgot ? (
            <form onSubmit={handleForgot} className="mt-6 space-y-3">
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
                  onChange={(e) => setEmail(e.target.value)}
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
          ) : (
            <>
              <button
                type="button"
                disabled={busy}
                onClick={handleGoogle}
                className="mt-6 flex min-h-11 w-full items-center justify-center gap-2 rounded-lg border border-border bg-background/50 px-4 py-2.5 text-sm font-medium transition hover:bg-background/80 disabled:opacity-50"
              >
                <svg width="18" height="18" viewBox="0 0 24 24">
                  <path
                    fill="#4285F4"
                    d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                  />
                  <path
                    fill="#34A853"
                    d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.99.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                  />
                  <path
                    fill="#FBBC05"
                    d="M5.84 14.1A6.97 6.97 0 0 1 5.46 12c0-.73.13-1.44.36-2.1V7.07H2.18A11 11 0 0 0 1 12c0 1.77.42 3.45 1.18 4.93l3.66-2.83z"
                  />
                  <path
                    fill="#EA4335"
                    d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.83C6.71 7.31 9.14 5.38 12 5.38z"
                  />
                </svg>
                {t.auth.googleCta}
              </button>

              <p className="mt-2 text-center text-xs text-muted-foreground">
                {t.auth.sessionRemembered}
              </p>

              <div className="my-5 flex items-center gap-3 text-xs uppercase tracking-widest text-muted-foreground">
                <span className="h-px flex-1 bg-border" /> {t.auth.or}{" "}
                <span className="h-px flex-1 bg-border" />
              </div>

              <form onSubmit={handleSubmit} className="space-y-3">
                {isSignup && (
                  <div className="rounded-xl border border-border/60 bg-background/30 p-3">
                    <div className="mb-2 text-xs uppercase tracking-wider text-muted-foreground">
                      {t.auth.roleLabel}
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <button
                        type="button"
                        onClick={() => setRole("student")}
                        className={`min-h-11 rounded-lg px-3 py-2 text-sm font-semibold transition ${role === "student" ? "bg-gold/15 text-gold border border-gold/40" : "bg-background/40 text-muted-foreground border border-border/50 hover:text-foreground"}`}
                      >
                        {t.auth.roleStudent}
                      </button>
                      <button
                        type="button"
                        onClick={() => setRole("parent")}
                        className={`min-h-11 rounded-lg px-3 py-2 text-sm font-semibold transition ${role === "parent" ? "bg-gold/15 text-gold border border-gold/40" : "bg-background/40 text-muted-foreground border border-border/50 hover:text-foreground"}`}
                      >
                        {t.auth.roleParent}
                      </button>
                    </div>
                  </div>
                )}

                {isSignup && (
                  <div className="relative">
                    <Label htmlFor="auth-name" className="sr-only">
                      {t.auth.heroNameLabel}
                    </Label>
                    <UserIcon className="absolute start-3 top-3 h-4 w-4 text-muted-foreground" />
                    <input
                      id="auth-name"
                      type="text"
                      required
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      placeholder={t.auth.heroNameLabel}
                      className="w-full rounded-lg border border-input bg-background/60 py-3 ps-10 pe-3 text-sm focus:border-gold focus:outline-none"
                    />
                  </div>
                )}

                {isSignup && role === "parent" && (
                  <div className="relative">
                    <Label htmlFor="auth-alliance-code" className="sr-only">
                      {t.auth.allianceCodeLabel}
                    </Label>
                    <input
                      id="auth-alliance-code"
                      type="text"
                      value={allianceCode}
                      onChange={(e) => setAllianceCode(e.target.value)}
                      placeholder={t.auth.allianceCodeLabel}
                      aria-describedby="auth-alliance-code-hint"
                      className="w-full rounded-lg border border-input bg-background/60 py-2.5 px-3 text-sm focus:border-gold focus:outline-none"
                    />
                    <p id="auth-alliance-code-hint" className="mt-1 text-xs text-muted-foreground">
                      {t.auth.allianceCodeHint}
                    </p>
                  </div>
                )}
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
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder={t.auth.emailLabel}
                    className="w-full rounded-lg border border-input bg-background/60 py-2.5 ps-10 pe-3 text-sm focus:border-gold focus:outline-none"
                  />
                </div>
                <div className="relative">
                  <Label htmlFor="auth-password" className="sr-only">
                    {t.auth.passwordLabel}
                  </Label>
                  <Lock className="absolute start-3 top-3 h-4 w-4 text-muted-foreground" />
                  <input
                    id="auth-password"
                    type="password"
                    required
                    minLength={8}
                    value={password}
                    onChange={(e) => {
                      setPassword(e.target.value);
                      if (passwordError) setPasswordError("");
                    }}
                    placeholder={t.auth.passwordLabel}
                    aria-invalid={passwordError ? true : undefined}
                    aria-describedby={passwordError ? "auth-password-error" : undefined}
                    className="w-full rounded-lg border border-input bg-background/60 py-2.5 ps-10 pe-3 text-sm focus:border-gold focus:outline-none"
                  />
                  {passwordError && (
                    <p id="auth-password-error" className="mt-1 text-xs text-gold">
                      {passwordError}
                    </p>
                  )}
                </div>

                {/* Password recovery entry (login only) — the previously missing US-8 flow. */}
                {!isSignup && (
                  <div className="text-end">
                    <Link
                      to="/auth"
                      search={{ mode: "forgot" }}
                      className="text-xs font-semibold text-gold hover:underline"
                    >
                      {t.auth.forgotCta}
                    </Link>
                  </div>
                )}

                {/* Always-mounted live region so screen readers announce errors
                reliably when `formError` changes (see #23). */}
                <div role="alert" aria-live="polite">
                  {formError && (
                    <p className="rounded-lg border border-gold/40 bg-gold/10 px-3 py-2 text-xs text-gold">
                      {formError}
                    </p>
                  )}
                </div>
                {unconfirmedEmail && (
                  <button
                    type="button"
                    disabled={resendBusy || resendCooldown > 0}
                    onClick={() => void resendConfirmation(unconfirmedEmail)}
                    className="flex min-h-11 w-full items-center justify-center gap-2 rounded-lg border border-gold/40 bg-gold/10 py-2.5 text-sm font-bold text-gold transition hover:bg-gold/20 disabled:opacity-60"
                  >
                    {resendBusy && <Loader2 className="h-4 w-4 animate-spin" />}
                    {resendCooldown > 0
                      ? t.auth.emailSentResendWait.replace("{s}", String(resendCooldown))
                      : t.auth.emailSentResend}
                  </button>
                )}
                <button
                  type="submit"
                  disabled={busy}
                  className="flex min-h-11 w-full items-center justify-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition hover:opacity-90 disabled:opacity-60"
                >
                  {busy && <Loader2 className="h-4 w-4 animate-spin" />}
                  {isSignup ? t.auth.submitSignup : t.auth.submitLogin}
                </button>
              </form>

              <p className="mt-5 text-center text-xs text-muted-foreground">
                {isSignup ? t.auth.hasAccountPrompt : t.auth.noAccountPrompt}
                <Link
                  to="/auth"
                  search={{ mode: isSignup ? "login" : "signup" }}
                  className="inline-block py-2 font-semibold text-gold hover:underline"
                >
                  {isSignup ? t.common.signIn : t.auth.switchToSignup}
                </Link>
              </p>
            </>
          )}
        </motion.div>
      </div>
    </main>
  );
}
