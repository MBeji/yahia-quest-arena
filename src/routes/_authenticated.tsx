import { createFileRoute, Outlet, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useAuth } from "@/hooks/use-auth";
import { Sparkles, LayoutDashboard, LogOut, Swords, Crown, ClipboardList, MailCheck } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated")({
  component: AuthenticatedLayout,
});

function AuthenticatedLayout() {
  const { user, loading } = useAuth();
  const navigate = useNavigate();
  const [userRole, setUserRole] = useState<string | null>(null);

  // Fetch user role for conditional nav
  useEffect(() => {
    if (!user) return;
    supabase
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single()
      .then(({ data }) => {
        if (data) setUserRole(data.role);
      });
  }, [user]);

  // Redirect unauthenticated users via effect (not during render)
  useEffect(() => {
    if (!loading && !user) {
      navigate({ to: "/auth", search: { mode: "login" } });
    }
  }, [loading, user, navigate]);

  if (loading) {
    return (
      <div className="grid min-h-screen place-items-center bg-hero">
        <div className="font-display text-sm uppercase tracking-widest text-muted-foreground">
          Loading…
        </div>
      </div>
    );
  }
  if (!user) {
    return null;
  }

  // Block access if email is not yet confirmed
  if (!user.email_confirmed_at) {
    return (
      <div className="grid min-h-screen place-items-center bg-hero px-6">
        <div className="absolute inset-0 bg-grid opacity-40 pointer-events-none" />
        <div className="relative w-full max-w-sm rounded-2xl border border-[color:var(--neon-cyan)]/40 bg-card/60 p-8 text-center backdrop-blur-xl shadow-neon">
          <div className="mx-auto mb-4 grid h-14 w-14 place-items-center rounded-xl bg-[color:var(--neon-cyan)]/15">
            <MailCheck className="h-7 w-7 text-[color:var(--neon-cyan)]" />
          </div>
          <h2 className="font-display text-xl font-bold">Confirme ton email</h2>
          <p className="mt-2 text-sm text-muted-foreground">
            Un lien d&apos;activation a été envoyé à{" "}
            <span className="font-semibold text-foreground">{user.email}</span>.
            <br />Clique dessus pour accéder à l&apos;arène.
          </p>
          <div className="mt-4 rounded-lg border border-border/50 bg-background/30 p-3 text-xs text-muted-foreground">
            📧 Vérifie aussi tes spams.
          </div>
          <button
            type="button"
            onClick={async () => {
              await supabase.auth.signOut();
              navigate({ to: "/auth", search: { mode: "login" } });
            }}
            className="mt-5 text-xs text-muted-foreground hover:text-foreground underline underline-offset-2"
          >
            Se déconnecter
          </button>
        </div>
      </div>
    );
  }

  async function signOut() {
    await supabase.auth.signOut();
    toast.success("See you soon, warrior.");
    navigate({ to: "/" });
  }

  return (
    <div className="min-h-screen bg-hero">
      <div className="absolute inset-0 bg-grid opacity-40 pointer-events-none" />
      <header className="relative z-10 border-b border-border/40 bg-background/40 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-4 px-6 py-3">
          <Link to="/dashboard" className="flex items-center gap-2">
            <div className="grid h-9 w-9 place-items-center rounded-lg bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon">
              <Sparkles className="h-4 w-4 text-primary-foreground" />
            </div>
            <span className="font-display text-base font-bold tracking-wider">XP <span className="text-gradient-cyan">SCHOLARS</span></span>
          </Link>
          <nav className="flex items-center gap-2 text-sm">
            <Link to="/dashboard" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
              <LayoutDashboard className="h-4 w-4" /> Heroes Hall
            </Link>
            <Link to="/dungeon" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
              <Swords className="h-4 w-4" /> Dungeon
            </Link>
            <Link to="/leaderboard" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
              <Crown className="h-4 w-4" /> Ranking
            </Link>
            {userRole === "parent" && (
              <Link to="/parent-report" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
                <ClipboardList className="h-4 w-4" /> Suivi
              </Link>
            )}
            {userRole === "admin" && (
              <Link to="/parent-report" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
                <ClipboardList className="h-4 w-4" /> Admin
              </Link>
            )}
            <button onClick={signOut} className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground">
              <LogOut className="h-4 w-4" /> Sign out
            </button>
          </nav>
        </div>
      </header>
      <main className="relative z-10">
        <Outlet />
      </main>
    </div>
  );
}
