import { createFileRoute, useNavigate, useRouter, Link } from "@tanstack/react-router";
import { useCallback, useEffect, useRef, useState } from "react";
import { motion } from "motion/react";
import { Mail, Lock, User as UserIcon, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { supabase } from "@/shared/integrations/supabase/client";
import { useServerFn } from "@tanstack/react-start";
import { linkStudentByCode } from "@/features/parent-report";
import { bootstrapProfile } from "@/features/auth";
import { Label } from "@/components/ui/label";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { CrownMark } from "@/components/brand-mark";
import { useT } from "@/lib/i18n";
import {
  cooldownFromError,
  friendlyAuthError,
  isEmailNotConfirmed,
} from "@/features/auth/auth-errors";
import {
  isFreshGoogleSignIn,
  readReturnContext,
  type ReturnContext,
  type SignInProbe,
} from "@/features/auth/sign-in-arrival";
import { EmailSentScreen, ForgotSentScreen } from "@/features/auth/components/auth-sent-screens";
import { ForgotPasswordForm } from "@/features/auth/components/forgot-password-form";
import { GoogleSignInButton } from "@/features/auth/components/google-sign-in-button";
import { useEntrance } from "@/shared/lib/motion";
import { trackProductEvent } from "@/shared/lib/product-events";
import { consumeReturnTo, rememberReturnTo } from "@/shared/lib/return-to";
import { pageTitle } from "@/lib/i18n/head";

export const Route = createFileRoute("/auth")({
  head: () => ({
    meta: [
      { title: pageTitle((t) => t.public.titles.auth) },
      {
        name: "description",
        content:
          "Crée ton compte gratuit : cours, résumés et exercices de toute l'école tunisienne — apprends en jouant.",
      },
    ],
  }),
  // `role` optionnel — tunnel parent depuis la landing « Espace Famille ». `returnTo` (é38 lot 1) :
  // la page où ramener le visiteur ; gardé tel quel ici, VALIDÉ par `return-to.ts` avant tout usage.
  validateSearch: (
    s: Record<string, unknown>,
  ): { mode: string; role?: "parent"; returnTo?: string } => ({
    mode: (s.mode as string) || "login",
    ...(s.role === "parent" ? { role: "parent" as const } : {}),
    ...(typeof s.returnTo === "string" ? { returnTo: s.returnTo } : {}),
  }),
  component: AuthPage,
});

function AuthPage() {
  const { mode, role: roleParam, returnTo } = Route.useSearch();
  const navigate = useNavigate();
  const router = useRouter();
  const t = useT();
  // é38 lot 1 (R-3) — OÙ ALLER une fois la session ouverte : le retour gardé s'il y en a un, sinon
  // le Hall. Une seule fois par page : l'inscription, le rappel de session et l'événement SIGNED_IN
  // arrivent tous, dans un ordre que personne ne maîtrise, et le premier doit gagner — le second
  // retrouverait une mémoire déjà consommée et renverrait au Hall par-dessus le retour.
  const left = useRef(false);
  const leave = useCallback(() => {
    if (left.current) return;
    left.current = true;
    const back = consumeReturnTo();
    if (back) router.history.push(back);
    else navigate({ to: "/dashboard" });
  }, [navigate, router]);
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

  // R-2 : l'adresse peut porter le retour (un lien d'invitation partagé). Elle ne fait qu'ÉCRIRE dans la
  // mémoire — la décision se prend sur la mémoire, qui survit au lien de confirmation d'e-mail et à
  // l'aller-retour chez Google, là où l'adresse, elle, est perdue. Le chemin est validé à l'écriture.
  useEffect(() => {
    if (returnTo !== undefined) rememberReturnTo(returnTo);
  }, [returnTo]);

  // La mesure du retour de Google se lit ICI, à l'arrivée : personne n'appelle rien à ce moment-là, la
  // session est déjà ouverte, et trois chemins (le rappel de session, l'écouteur, l'événement) peuvent
  // consommer la mémoire avant celui qui mesure. Lue APRÈS l'écriture d'un `?returnTo=` éventuel.
  // Une seule fois PAR PAGE, pas par abonnement : l'effet qui s'abonne se rejoue quand `leave` ou `t`
  // change, et un garde local à l'effet aurait alors mesuré la même connexion deux fois.
  const googleLoginTracked = useRef(false);
  const arrival = useRef<ReturnContext>({
    return_to_kept: false,
    from_content: false,
    reason: "fresh",
  });
  // R-7 : la session est morte sous ses doigts — l'écran le dit en tête de formulaire. Même lecture
  // que la mesure, donc elle aussi APRÈS le montage (la mémoire est locale à l'appareil : la lire au
  // rendu ferait diverger l'hydratation du HTML serveur) et APRÈS l'écriture d'un `?returnTo=`, qui
  // remplace un retour d'expiration par une invitation — l'avis ne vaut alors plus.
  const [sessionExpired, setSessionExpired] = useState(false);
  useEffect(() => {
    arrival.current = readReturnContext();
    setSessionExpired(arrival.current.reason === "expired");
  }, [returnTo]);

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
    // é38 lot 0 — le retour de Google (voir isFreshGoogleSignIn : jamais `?code=`). Le premier chemin qui
    // voit la session fraîche la mesure, UNE fois, avec le contexte lu à l'arrivée : la page a été rechargée
    // chez Google, mais le retour gardé a survécu — c'est lui qui dit d'où l'on venait. Deux chemins et pas
    // un seul : selon l'ordre où Supabase livre INITIAL_SESSION et SIGNED_IN, c'est l'un ou l'autre qui
    // arrive d'abord, et `leave()` quitte la page aussitôt.
    const trackGoogleLogin = (session: SignInProbe) => {
      if (googleLoginTracked.current || !isFreshGoogleSignIn(session, Date.now())) return;
      googleLoginTracked.current = true;
      trackProductEvent("login", { method: "google", ...arrival.current });
    };
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) {
        trackGoogleLogin(data.session);
        leave();
      }
    });
    const { data: authSub } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session) {
        trackGoogleLogin(session);
        leave();
      }
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
  }, [leave, t]);

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
        options: { emailRedirectTo: `${window.location.origin}/auth` },
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
    // Lu AVANT l'appel qui ouvre la session : voir `readReturnContext`.
    const context = readReturnContext();
    try {
      if (isSignup) {
        const displayName = name || email.split("@")[0];
        const { data, error } = await supabase.auth.signUp({
          email,
          password,
          options: {
            emailRedirectTo: `${window.location.origin}/auth`,
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

        // é31 lot 1 — le premier fait du funnel produit. Émis dès que le compte
        // EXISTE (une session, ou un mail de confirmation parti), donc y compris
        // sur le chemin « confirme ton adresse » où l'élève ne revient parfois
        // jamais : c'est justement la fuite qu'on veut voir. Aucune PII — le
        // rôle choisi, rien d'autre.
        trackProductEvent("signup", {
          role,
          needs_confirmation: !data.session,
          return_to_kept: context.return_to_kept,
          from_content: context.from_content,
        });

        // Profile bootstrap (display name + role) is extracted to the
        // `bootstrapProfile` server fn (review #19). It is authenticated, so it can
        // only run once a session exists (signup auto-login). When email
        // confirmation is required there is no session yet — the `handle_new_user`
        // trigger + signUp metadata already seed the profile, so we skip it.
        if (data.user && data.session) {
          await runBootstrapProfile({ data: { displayName, role } });

          if (role === "parent" && allianceCode.trim().length > 0) {
            try {
              const linkRes = await linkByCode({
                data: { studentCode: allianceCode.trim(), relationLabel: "parent" },
              });
              if (linkRes.linked) {
                toast.success(
                  t.auth.toastLinked.replace("{name}", linkRes.student.displayName ?? "élève"),
                );
              }
            } catch {
              // The alliance-code step is optional: an invalid or unknown code must not
              // block account creation; the parent can link from /parent-report later.
              toast.error(t.auth.allianceLinkFailed);
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
        leave();
      } else {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        // `reason: "expired"` arrive avec le lot 3 (la session qui meurt).
        trackProductEvent("login", { method: "password", ...context });
        toast.success(t.auth.toastLoginSuccess);
        leave();
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

  if (forgotSent) return <ForgotSentScreen sentTo={sentTo} />;

  if (emailSent) {
    return (
      <EmailSentScreen
        sentTo={sentTo}
        formError={formError}
        resendBusy={resendBusy}
        resendCooldown={resendCooldown}
        resendNote={resendNote}
        onResend={() => void resendConfirmation(sentTo)}
        onEdit={() => {
          setEmailSent(false);
          setSentTo("");
          setResendNote("");
          setFormError("");
        }}
      />
    );
  }

  return (
    <main className="relative min-h-[100dvh] overflow-hidden bg-black-deep">
      <div className="absolute inset-0 bg-grid opacity-50" />
      <div className="relative mx-auto flex min-h-[100dvh] max-w-md flex-col items-center justify-center px-4 pt-[max(3rem,env(safe-area-inset-top))] pb-[max(3rem,env(safe-area-inset-bottom))] sm:px-6">
        <Link to="/" className="mb-8 flex min-h-11 items-center gap-2">
          <div className="grid h-10 w-10 place-items-center rounded-lg bg-[image:var(--gradient-gold)] shadow-gold">
            <CrownMark className="h-6 w-6 text-primary-foreground" />
          </div>
          <span className="font-display text-xl font-bold tracking-wider">
            Na9ra <span className="text-gradient-gold">Nal3ab</span>
          </span>
        </Link>

        <motion.div
          {...entrance}
          data-testid="auth-card"
          className="w-full glass-gold rounded-2xl p-6 shadow-gold sm:p-8"
        >
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
            <ForgotPasswordForm
              email={email}
              onEmailChange={setEmail}
              formError={formError}
              busy={busy}
              onSubmit={handleForgot}
            />
          ) : (
            <>
              {/* R-7 : « Ta session a expiré » — en connexion seulement (créer un compte n'a rien à voir),
                  dans une région d'état toujours montée : un lecteur d'écran l'annonce sans voler le focus. */}
              <div role="status" aria-live="polite">
                {sessionExpired && !isSignup && (
                  <p
                    data-testid="auth-session-expired"
                    className="mt-6 rounded-lg border border-gold/40 bg-gold/10 px-3 py-2 text-center text-xs text-gold"
                  >
                    {t.errors.sessionExpired}
                  </p>
                )}
              </div>
              <GoogleSignInButton busy={busy} onClick={handleGoogle} />

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
                      className="w-full rounded-lg border border-input bg-background/60 py-3 ps-10 pe-3 text-base focus:border-gold focus:outline-none sm:text-sm"
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
                      className="w-full rounded-lg border border-input bg-background/60 min-h-11 py-2.5 px-3 text-base focus:border-gold focus:outline-none sm:text-sm"
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
                    className="w-full rounded-lg border border-input bg-background/60 py-2.5 ps-10 pe-3 text-base min-h-11 focus:border-gold focus:outline-none sm:text-sm"
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
                    className="w-full rounded-lg border border-input bg-background/60 py-2.5 ps-10 pe-3 text-base min-h-11 focus:border-gold focus:outline-none sm:text-sm"
                  />
                  {passwordError && (
                    <p id="auth-password-error" className="mt-1 text-xs text-gold">
                      {passwordError}
                    </p>
                  )}
                </div>

                {/* Password recovery entry (login only) — the previously missing US-8 flow. */}
                {!isSignup && (
                  <div className="-my-2 text-end">
                    <Link
                      to="/auth"
                      search={{ mode: "forgot" }}
                      className="inline-flex min-h-11 items-center text-xs font-semibold text-gold hover:underline"
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
                  className="inline-flex min-h-11 items-center px-1 font-semibold text-gold hover:underline"
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
