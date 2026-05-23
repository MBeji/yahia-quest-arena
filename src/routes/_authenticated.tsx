import { createFileRoute, Outlet, redirect, Link, useNavigate } from "@tanstack/react-router";
import { useAuth } from "@/hooks/use-auth";
import { Sparkles, LayoutDashboard, LogOut, Swords } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated")({
  component: AuthenticatedLayout,
});

function AuthenticatedLayout() {
  const { user, loading } = useAuth();
  const navigate = useNavigate();

  if (loading) {
    return (
      <div className="grid min-h-screen place-items-center bg-hero">
        <div className="font-display text-sm uppercase tracking-widest text-muted-foreground">Loading…</div>
      </div>
    );
  }
  if (!user) {
    navigate({ to: "/auth", search: { mode: "login" } });
    return null;
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
            <span className="font-display text-base font-bold tracking-wider">YAHIA<span className="text-gradient-cyan">ACADEMY</span></span>
          </Link>
          <nav className="flex items-center gap-2 text-sm">
            <Link to="/dashboard" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
              <LayoutDashboard className="h-4 w-4" /> Heroes Hall
            </Link>
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
