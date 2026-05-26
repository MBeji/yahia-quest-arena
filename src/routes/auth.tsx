import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { motion } from "motion/react";
import { Sparkles, Mail, Lock, User as UserIcon, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { supabase } from "@/integrations/supabase/client";
import { lovable } from "@/integrations/lovable/index";
import {
  GUEST_ACCESS_COPY,
  getGuestSignInErrorMessage,
  PUBLIC_GUEST_ACCESS_ENABLED,
  signInGuestUser,
} from "@/lib/guest-access";

export const Route = createFileRoute("/auth")({
  head: () => ({
    meta: [
      { title: "Join the Academy · XP Scholars" },
      { name: "description", content: "Create your hero and start preparing for the 9th grade exam." },
    ],
  }),
  validateSearch: (s: Record<string, unknown>) => ({ mode: (s.mode as string) || "login" }),
  component: AuthPage,
});

function AuthPage() {
  const { mode } = Route.useSearch();
  const navigate = useNavigate();
  const isSignup = mode === "signup";
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) navigate({ to: "/dashboard" });
    });
  }, [navigate]);

  function friendlyAuthError(err: unknown): string {
    const msg = err instanceof Error ? err.message.toLowerCase() : "";
    if (msg.includes("invalid login")) return "Email ou mot de passe incorrect.";
    if (msg.includes("email not confirmed")) return "Vérifie ta boîte mail pour confirmer ton compte.";
    if (msg.includes("user already registered")) return "Ce compte existe déjà. Connecte-toi.";
    if (msg.includes("rate limit") || msg.includes("too many")) return "Trop de tentatives. Réessaie dans quelques minutes.";
    if (msg.includes("password")) return "Le mot de passe doit contenir au moins 8 caractères.";
    if (msg.includes("signup_disabled")) return "L'inscription est temporairement désactivée.";
    return "Erreur d'authentification. Réessaie.";
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (password.length < 8) {
      toast.error("Le mot de passe doit contenir au moins 8 caractères.");
      return;
    }
    setBusy(true);
    try {
      if (isSignup) {
        const { error } = await supabase.auth.signUp({
          email, password,
          options: {
            emailRedirectTo: `${window.location.origin}/dashboard`,
            data: { display_name: name || email.split("@")[0] },
          },
        });
        if (error) throw error;
        toast.success("Hero created! Welcome to the academy.");
        navigate({ to: "/dashboard" });
      } else {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        toast.success("Welcome back, warrior.");
        navigate({ to: "/dashboard" });
      }
    } catch (err) {
      toast.error(friendlyAuthError(err));
    } finally {
      setBusy(false);
    }
  }

  async function handleGoogle() {
    setBusy(true);
    const res = await lovable.auth.signInWithOAuth("google", { redirect_uri: window.location.origin + "/dashboard" });
    if (res.error) {
      toast.error("Google error");
      setBusy(false);
      return;
    }
    if (res.redirected) return;
    navigate({ to: "/dashboard" });
  }

  async function handleGuestAccess() {
    setBusy(true);

    const res = await signInGuestUser(supabase);
    if (!res.ok) {
      toast.error(getGuestSignInErrorMessage(res));
      setBusy(false);
      return;
    }

    navigate({ to: "/dashboard" });
  }

  return (
    <main className="relative min-h-screen overflow-hidden bg-hero">
      <div className="absolute inset-0 bg-grid opacity-50" />
      <div className="relative mx-auto flex min-h-screen max-w-md flex-col items-center justify-center px-6 py-12">
        <Link to="/" className="mb-8 flex items-center gap-2">
          <div className="grid h-10 w-10 place-items-center rounded-lg bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon">
            <Sparkles className="h-5 w-5 text-primary-foreground" />
          </div>
          <span className="font-display text-xl font-bold tracking-wider">XP <span className="text-gradient-cyan">SCHOLARS</span></span>
        </Link>

        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="w-full glass rounded-2xl p-8 shadow-neon"
        >
          <h1 className="font-display text-2xl font-bold">
            {isSignup ? "Forge your hero" : "Welcome back, warrior"}
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            {isSignup ? "A few seconds to enter the arena." : "Resume your quest where you left off."}
          </p>

          <button
            type="button"
            disabled={busy}
            onClick={handleGoogle}
            className="mt-6 flex w-full items-center justify-center gap-2 rounded-lg border border-border bg-background/50 px-4 py-2.5 text-sm font-medium transition hover:bg-background/80 disabled:opacity-50"
          >
            <svg width="18" height="18" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.99.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.1A6.97 6.97 0 0 1 5.46 12c0-.73.13-1.44.36-2.1V7.07H2.18A11 11 0 0 0 1 12c0 1.77.42 3.45 1.18 4.93l3.66-2.83z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.83C6.71 7.31 9.14 5.38 12 5.38z"/></svg>
            Continue with Google
          </button>

          {PUBLIC_GUEST_ACCESS_ENABLED && (
            <button
              type="button"
              disabled={busy}
              onClick={handleGuestAccess}
              className="mt-3 w-full rounded-lg border border-dashed border-[color:var(--neon-cyan)]/40 bg-[color:var(--neon-cyan)]/10 px-4 py-2.5 text-sm font-semibold text-[color:var(--neon-cyan)] transition hover:bg-[color:var(--neon-cyan)]/20 disabled:opacity-50"
            >
              {GUEST_ACCESS_COPY.authButton}
            </button>
          )}

          {PUBLIC_GUEST_ACCESS_ENABLED && (
            <p className="mt-2 text-center text-xs text-muted-foreground">{GUEST_ACCESS_COPY.authHint}</p>
          )}

          <div className="my-5 flex items-center gap-3 text-xs uppercase tracking-widest text-muted-foreground">
            <span className="h-px flex-1 bg-border" /> or <span className="h-px flex-1 bg-border" />
          </div>

          <form onSubmit={handleSubmit} className="space-y-3">
            {isSignup && (
              <div className="relative">
                <UserIcon className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <input
                  type="text" required value={name} onChange={(e) => setName(e.target.value)}
                  placeholder="Hero name"
                  className="w-full rounded-lg border border-input bg-background/50 py-2.5 pl-10 pr-3 text-sm focus:border-[color:var(--neon-violet)] focus:outline-none"
                />
              </div>
            )}
            <div className="relative">
              <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
              <input
                type="email" required value={email} onChange={(e) => setEmail(e.target.value)}
                placeholder="Email"
                className="w-full rounded-lg border border-input bg-background/50 py-2.5 pl-10 pr-3 text-sm focus:border-[color:var(--neon-violet)] focus:outline-none"
              />
            </div>
            <div className="relative">
              <Lock className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
              <input
                type="password" required minLength={8} value={password} onChange={(e) => setPassword(e.target.value)}
                  placeholder="Password (min 8 characters)"
                className="w-full rounded-lg border border-input bg-background/50 py-2.5 pl-10 pr-3 text-sm focus:border-[color:var(--neon-violet)] focus:outline-none"
              />
            </div>
            <button
              type="submit" disabled={busy}
              className="flex w-full items-center justify-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] py-2.5 text-sm font-bold text-primary-foreground shadow-neon transition hover:scale-[1.02] disabled:opacity-60"
            >
              {busy && <Loader2 className="h-4 w-4 animate-spin" />}
              {isSignup ? "Forge my hero" : "Enter the arena"}
            </button>
          </form>

          <p className="mt-5 text-center text-xs text-muted-foreground">
            {isSignup ? "Already a hero? " : "No hero yet? "}
            <Link
              to="/auth"
              search={{ mode: isSignup ? "login" : "signup" }}
              className="font-semibold text-[color:var(--neon-cyan)] hover:underline"
            >
              {isSignup ? "Sign in" : "Create an account"}
            </Link>
          </p>
        </motion.div>
      </div>
    </main>
  );
}
